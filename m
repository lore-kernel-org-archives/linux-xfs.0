Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02E2429E1F
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:19:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D472A304039
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:19:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9yex0y3R23sENT7C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:19:20 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 15/51] richacl: Create-time inheritance
Date: Tue,  3 Nov 2015 16:16:51 +0100
Message-Id: <1446563847-14005-16-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

When a new file is created, it can inherit an acl from its parent
directory; this is similar to how default acls work in POSIX (draft)
ACLs.

As with POSIX ACLs, if a file inherits an acl from its parent directory,
the intersection between the create mode and the permissions granted by
the inherited acl determines the file masks and file permission bits,
and the umask is ignored.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/richacl_base.c       | 68 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/richacl_inode.c      | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |  2 ++
 3 files changed, 140 insertions(+)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index 56b5ad6..9f7d91d 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -486,3 +486,71 @@ richacl_equiv_mode(const struct richacl *acl, umode_t *mode_p)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(richacl_equiv_mode);
+
+/**
+ * richacl_inherit  -  compute the inherited acl of a new file
+ * @dir_acl:	acl of the containing directory
+ * @isdir:	inherit by a directory or non-directory?
+ *
+ * A directory can have acl entries which files and/or directories created
+ * inside the directory will inherit.  This function computes the acl for such
+ * a new file.  If there is no inheritable acl, it will return %NULL.
+ */
+struct richacl *
+richacl_inherit(const struct richacl *dir_acl, int isdir)
+{
+	const struct richace *dir_ace;
+	struct richacl *acl = NULL;
+	struct richace *ace;
+	int count = 0;
+
+	if (isdir) {
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!richace_is_inheritable(dir_ace))
+				continue;
+			count++;
+		}
+		if (!count)
+			return NULL;
+		acl = richacl_alloc(count, GFP_KERNEL);
+		if (!acl)
+			return ERR_PTR(-ENOMEM);
+		ace = acl->a_entries;
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!richace_is_inheritable(dir_ace))
+				continue;
+			richace_copy(ace, dir_ace);
+			if (dir_ace->e_flags & RICHACE_NO_PROPAGATE_INHERIT_ACE)
+				ace->e_flags &= ~RICHACE_INHERITANCE_FLAGS;
+			else if (!(dir_ace->e_flags & RICHACE_DIRECTORY_INHERIT_ACE))
+				ace->e_flags |= RICHACE_INHERIT_ONLY_ACE;
+			ace++;
+		}
+	} else {
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!(dir_ace->e_flags & RICHACE_FILE_INHERIT_ACE))
+				continue;
+			count++;
+		}
+		if (!count)
+			return NULL;
+		acl = richacl_alloc(count, GFP_KERNEL);
+		if (!acl)
+			return ERR_PTR(-ENOMEM);
+		ace = acl->a_entries;
+		richacl_for_each_entry(dir_ace, dir_acl) {
+			if (!(dir_ace->e_flags & RICHACE_FILE_INHERIT_ACE))
+				continue;
+			richace_copy(ace, dir_ace);
+			ace->e_flags &= ~RICHACE_INHERITANCE_FLAGS;
+			/*
+			 * RICHACE_DELETE_CHILD is meaningless for
+			 * non-directories, so clear it.
+			 */
+			ace->e_mask &= ~RICHACE_DELETE_CHILD;
+			ace++;
+		}
+	}
+
+	return acl;
+}
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index 301f246..d2bf076 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -252,3 +252,73 @@ richacl_chmod(struct inode *inode, umode_t mode)
 	return retval;
 }
 EXPORT_SYMBOL(richacl_chmod);
+
+/*
+ * richacl_inherit_inode  -  compute inherited acl and file mode
+ * @dir_acl:	acl of the containing directory
+ * @mode_p:	mode of the new inode
+ *
+ * The file permission bits in @mode_p must be set to the create mode by the
+ * caller.
+ *
+ * If there is an inheritable acl, the maximum permissions that the acl grants
+ * are computed and the file masks of the new acl are set accordingly.
+ */
+static struct richacl *
+richacl_inherit_inode(const struct richacl *dir_acl, umode_t *mode_p)
+{
+	struct richacl *acl;
+	umode_t mode = *mode_p;
+
+	acl = richacl_inherit(dir_acl, S_ISDIR(mode));
+	if (acl) {
+		if (richacl_equiv_mode(acl, &mode) == 0) {
+			*mode_p &= mode;
+			richacl_put(acl);
+			acl = NULL;
+		} else {
+			richacl_compute_max_masks(acl);
+			/*
+			 * Ensure that the acl will not grant any permissions
+			 * beyond the create mode.
+			 */
+			acl->a_flags |= RICHACL_MASKED;
+			acl->a_owner_mask &=
+				richacl_mode_to_mask(mode >> 6);
+			acl->a_group_mask &=
+				richacl_mode_to_mask(mode >> 3);
+			acl->a_other_mask &=
+				richacl_mode_to_mask(mode);
+		}
+	} else
+		*mode_p &= ~current_umask();
+
+	return acl;
+}
+
+/**
+ * richacl_create  -  filesystem create helper
+ * @mode_p:	mode of the new inode
+ * @dir:	containing directory
+ *
+ * Compute the inherited acl for a new inode.  If there is no acl to inherit,
+ * apply the umask.  Use when creating a new inode on a richacl enabled file
+ * system.
+ */
+struct richacl *richacl_create(umode_t *mode_p, struct inode *dir)
+{
+	struct richacl *dir_acl, *acl = NULL;
+
+	if (S_ISLNK(*mode_p))
+		return NULL;
+	dir_acl = get_richacl(dir);
+	if (dir_acl) {
+		if (IS_ERR(dir_acl))
+			return dir_acl;
+		acl = richacl_inherit_inode(dir_acl, mode_p);
+		richacl_put(dir_acl);
+	} else
+		*mode_p &= ~current_umask();
+	return acl;
+}
+EXPORT_SYMBOL_GPL(richacl_create);
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index ddd5aa6..302872b 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -186,9 +186,11 @@ extern unsigned int richacl_want_to_mask(unsigned int);
 extern void richacl_compute_max_masks(struct richacl *);
 extern struct richacl *__richacl_chmod(struct richacl *, umode_t);
 extern int richacl_equiv_mode(const struct richacl *, umode_t *);
+extern struct richacl *richacl_inherit(const struct richacl *, int);
 
 /* richacl_inode.c */
 extern int richacl_permission(struct inode *, const struct richacl *, int);
 extern int richacl_chmod(struct inode *, umode_t);
+extern struct richacl *richacl_create(umode_t *, struct inode *);
 
 #endif /* __RICHACL_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
