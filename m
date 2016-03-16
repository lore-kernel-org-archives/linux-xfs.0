Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D12E7CEF
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 17:20:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 14A098F8050
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:20:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ClEOh8VSGICeruol (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 15:20:23 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v20 17/23] richacl: Create-time inheritance
Date: Wed, 16 Mar 2016 23:18:57 +0100
Message-Id: <1458166743-18488-18-git-send-email-agruenba@redhat.com>
In-Reply-To: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
References: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

When a new file is created, it can inherit an acl from its parent
directory; this is similar to how default acls work in POSIX ACLs.

As with POSIX ACLs, if a file inherits an acl from its parent directory,
the intersection between the create mode and the permissions granted by
the inherited acl determines the file masks and file permission bits,
and the umask is ignored.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/richacl.c            | 151 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/richacl.h |   2 +
 2 files changed, 153 insertions(+)

diff --git a/fs/richacl.c b/fs/richacl.c
index 0df359c..7c82bc2 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -718,3 +718,154 @@ richacl_equiv_mode(const struct richacl *acl, umode_t *mode_p)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(richacl_equiv_mode);
+
+static inline bool
+ace_inherits_to_directory(const struct richace *ace)
+{
+	if (ace->e_flags & RICHACE_DIRECTORY_INHERIT_ACE)
+		return true;
+	if ((ace->e_flags & RICHACE_FILE_INHERIT_ACE) &&
+	    !(ace->e_flags & RICHACE_NO_PROPAGATE_INHERIT_ACE))
+		return true;
+	return false;
+}
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
+			if (!ace_inherits_to_directory(dir_ace))
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
+			if (!ace_inherits_to_directory(dir_ace))
+				continue;
+			richace_copy(ace, dir_ace);
+			if (dir_ace->e_flags & RICHACE_NO_PROPAGATE_INHERIT_ACE)
+				ace->e_flags &= ~RICHACE_INHERITANCE_FLAGS;
+			else if (dir_ace->e_flags & RICHACE_DIRECTORY_INHERIT_ACE)
+				ace->e_flags &= ~RICHACE_INHERIT_ONLY_ACE;
+			else
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
index f61475b..199800a 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -187,5 +187,7 @@ extern void richacl_compute_max_masks(struct richacl *);
 extern int richacl_permission(struct inode *, const struct richacl *, int);
 extern int richacl_chmod(struct inode *, umode_t);
 extern int richacl_equiv_mode(const struct richacl *, umode_t *);
+extern struct richacl *richacl_inherit(const struct richacl *, int);
+extern struct richacl *richacl_create(umode_t *, struct inode *);
 
 #endif /* __RICHACL_H */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
