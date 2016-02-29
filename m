Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 701E77F6C
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 02:18:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02A4EAC001
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 00:18:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id H6IZBE0gAkKeRsU5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 00:18:24 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v18 14/22] richacl: Update the file masks in chmod()
Date: Mon, 29 Feb 2016 09:17:19 +0100
Message-Id: <1456733847-17982-15-git-send-email-agruenba@redhat.com>
In-Reply-To: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

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
---
 fs/richacl_base.c       | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/richacl_inode.c      | 30 ++++++++++++++++++++++++++++++
 include/linux/richacl.h |  2 ++
 3 files changed, 74 insertions(+)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 5826842..e4dd779 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -340,3 +340,45 @@ restart:
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
+struct richacl *
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
+EXPORT_SYMBOL_GPL(__richacl_chmod);
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index 52c1595..e329826 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -224,3 +224,33 @@ out:
 	return denied ? -EACCES : 0;
 }
 EXPORT_SYMBOL_GPL(richacl_permission);
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
index 7bf912b6..a2d5600 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -184,8 +184,10 @@ extern int richacl_masks_to_mode(const struct richacl *);
 extern unsigned int richacl_mode_to_mask(umode_t);
 extern unsigned int richacl_want_to_mask(unsigned int);
 extern void richacl_compute_max_masks(struct richacl *);
+extern struct richacl *__richacl_chmod(struct richacl *, umode_t);
 
 /* richacl_inode.c */
 extern int richacl_permission(struct inode *, const struct richacl *, int);
+extern int richacl_chmod(struct inode *, umode_t);
 
 #endif /* __RICHACL_H */
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
