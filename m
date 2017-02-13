Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753454AbdBMPdk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:33:40 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v28 12/21] richacl: Update the file masks in chmod()
Date: Mon, 13 Feb 2017 16:32:28 +0100
Message-Id: <1486999957-2381-13-git-send-email-agruenba@redhat.com>
In-Reply-To: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
References: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

Doing a chmod() sets the file mode, which includes the file permission
bits.  When a file has a richacl, the permissions that the richacl
grants need to be limited to what the new file permission bits allow.

This is done by setting the file masks in the richacl to what the file
permission bits map to.  The richacl access check algorithm takes the
file masks into account, which ensures that the richacl cannot grant too
many permissions.

It is possible to explicitly add permissions to the file masks which go
beyond what the file permission bits can grant (like the
RICHACE_WRITE_ACL permission).  The POSIX.1 standard calls this an
alternate file access control mechanism.  A subsequent chmod() would
ensure that those permissions are disabled again.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
---
 fs/richacl.c            | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |  1 +
 2 files changed, 72 insertions(+)

diff --git a/fs/richacl.c b/fs/richacl.c
index 731c468..a199245 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -541,3 +541,74 @@ void richacl_compute_max_masks(struct richacl *acl)
 	acl->a_flags &= ~(RICHACL_WRITE_THROUGH | RICHACL_MASKED);
 }
 EXPORT_SYMBOL_GPL(richacl_compute_max_masks);
+
+/**
+ * __richacl_chmod  -  update the file masks to reflect the new mode
+ * @acl:	access control list
+ * @mode:	new file permission bits including the file type
+ *
+ * Return a copy of @acl where the file masks have been replaced by the file
+ * masks corresponding to the file permission bits in @mode, or returns @acl
+ * itself if the file masks are already up to date.  Takes over a reference
+ * to @acl.
+ */
+static struct richacl *
+__richacl_chmod(struct richacl *acl, umode_t mode)
+{
+	unsigned int x = S_ISDIR(mode) ? 0 : RICHACE_DELETE_CHILD;
+	unsigned int owner_mask, group_mask, other_mask;
+	struct richacl *clone;
+
+	owner_mask = richacl_mode_to_mask(mode >> 6) & ~x;
+	group_mask = richacl_mode_to_mask(mode >> 3) & ~x;
+	other_mask = richacl_mode_to_mask(mode)      & ~x;
+
+	if (acl->a_owner_mask == owner_mask &&
+	    acl->a_group_mask == group_mask &&
+	    acl->a_other_mask == other_mask &&
+	    (acl->a_flags & RICHACL_MASKED) &&
+	    (acl->a_flags & RICHACL_WRITE_THROUGH))
+		return acl;
+
+	clone = richacl_clone(acl, GFP_KERNEL);
+	richacl_put(acl);
+	if (!clone)
+		return ERR_PTR(-ENOMEM);
+
+	clone->a_flags |= (RICHACL_WRITE_THROUGH | RICHACL_MASKED);
+	clone->a_owner_mask = owner_mask;
+	clone->a_group_mask = group_mask;
+	clone->a_other_mask = other_mask;
+
+	return clone;
+}
+
+/**
+ * richacl_chmod  -  filesystem chmod helper
+ * @inode:	inode whose file permission bits to change
+ * @mode:	new file permission bits including the file type
+ *
+ * Helper for filesystems to use to perform a chmod on the richacl of an inode.
+ */
+int
+richacl_chmod(struct inode *inode, umode_t mode)
+{
+	struct richacl *acl;
+	int retval;
+
+	if (S_ISLNK(mode))
+		return -EOPNOTSUPP;
+	if (!inode->i_op->set_richacl)
+		return -EOPNOTSUPP;
+	acl = get_richacl(inode);
+	if (IS_ERR_OR_NULL(acl))
+		return PTR_ERR(acl);
+	acl = __richacl_chmod(acl, mode);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+	retval = inode->i_op->set_richacl(inode, acl);
+	richacl_put(acl);
+
+	return retval;
+}
+EXPORT_SYMBOL(richacl_chmod);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 207fe06..3cd5e53 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -189,5 +189,6 @@ extern int richacl_masks_to_mode(const struct richacl *);
 extern unsigned int richacl_mode_to_mask(umode_t);
 extern int richacl_permission(struct inode *, const struct richacl *, int);
 extern void richacl_compute_max_masks(struct richacl *);
+extern int richacl_chmod(struct inode *, umode_t);
 
 #endif /* __RICHACL_H */
-- 
2.7.4

