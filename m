Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6306129E3A
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 09:56:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD189AC005
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:56:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sS7iFuYnc46PDQi4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:56:44 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v19 18/23] richacl: Automatic Inheritance
Date: Mon, 14 Mar 2016 15:55:17 +0100
Message-Id: <1457967322-14886-19-git-send-email-agruenba@redhat.com>
In-Reply-To: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
References: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
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

Automatic Inheritance (AI) allows changes to the acl of a directory to
propagate down to children.

This is mostly implemented in user space: when a process changes the
permissions of a directory and Automatic Inheritance is enabled for that
directory, the process must propagate those changes to all children,
recursively.

The kernel enables this by keeping track of which permissions have been
inherited at create time.  In addition, it makes sure that permission
propagation is turned off when the permissions are set explicitly (for
example, upon create or chmod).

Automatic Inheritance works as follows:

 - When the RICHACL_AUTO_INHERIT flag in the acl of a file or directory
   is not set, the file or directory is not affected by AI.

 - When the RICHACL_AUTO_INHERIT flag in the acl of a directory is set
   and a file or subdirectory is created in that directory, the
   inherited acl will have the RICHACL_AUTO_INHERIT flag set, and all
   inherited aces will have the RICHACE_INHERITED_ACE flag set.  This
   allows user space to distinguish between aces which have been
   inherited and aces which have been explicitly added.

 - When the RICHACL_PROTECTED acl flag in the acl of a file or directory
   is set, AI will not modify the acl.  This does not affect propagation
   of permissions from the file to its children (if the file is a
   directory).

Linux does not have a way of creating files or directories without setting the
file permission bits, so all files created inside a directory with
RICHACL_AUTO_INHERIT set will have the RICHACL_PROTECTED flag set.  This
effectively disables Automatic Inheritance.

Protocols which support creating files without specifying permissions can
explicitly clear the RICHACL_PROTECTED flag after creating a file and reset the
file masks to "undo" applying the create mode; see richacl_compute_max_masks().
They should set the RICHACL_DEFAULTED flag.  (A mechanism that would allow to
indicate to the kernel to ignore the create mode in the first place when there
are inherited permissions would be nice to have.)

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/richacl_base.c            | 13 ++++++++++++-
 fs/richacl_inode.c           |  7 +++++++
 include/linux/richacl.h      | 12 ++++++++++++
 include/uapi/linux/richacl.h | 11 ++++++++++-
 4 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/richacl_base.c b/fs/richacl_base.c
index b66d940..724b5e0 100644
--- a/fs/richacl_base.c
+++ b/fs/richacl_base.c
@@ -364,7 +364,8 @@ __richacl_chmod(struct richacl *acl, umode_t mode)
 	    acl->a_group_mask == group_mask &&
 	    acl->a_other_mask == other_mask &&
 	    (acl->a_flags & RICHACL_MASKED) &&
-	    (acl->a_flags & RICHACL_WRITE_THROUGH))
+	    (acl->a_flags & RICHACL_WRITE_THROUGH) &&
+	    (!richacl_is_auto_inherit(acl) || richacl_is_protected(acl)))
 		return acl;
 
 	clone = richacl_clone(acl, GFP_KERNEL);
@@ -376,6 +377,8 @@ __richacl_chmod(struct richacl *acl, umode_t mode)
 	clone->a_owner_mask = owner_mask;
 	clone->a_group_mask = group_mask;
 	clone->a_other_mask = other_mask;
+	if (richacl_is_auto_inherit(clone))
+		clone->a_flags |= RICHACL_PROTECTED;
 
 	return clone;
 }
@@ -562,6 +565,14 @@ richacl_inherit(const struct richacl *dir_acl, int isdir)
 			ace++;
 		}
 	}
+	if (richacl_is_auto_inherit(dir_acl)) {
+		acl->a_flags = RICHACL_AUTO_INHERIT;
+		richacl_for_each_entry(ace, acl)
+			ace->e_flags |= RICHACE_INHERITED_ACE;
+	} else {
+		richacl_for_each_entry(ace, acl)
+			ace->e_flags &= ~RICHACE_INHERITED_ACE;
+	}
 
 	return acl;
 }
diff --git a/fs/richacl_inode.c b/fs/richacl_inode.c
index ec3d2c8..99a1ab6 100644
--- a/fs/richacl_inode.c
+++ b/fs/richacl_inode.c
@@ -279,6 +279,13 @@ richacl_inherit_inode(const struct richacl *dir_acl, umode_t *mode_p)
 			richacl_put(acl);
 			acl = NULL;
 		} else {
+			/*
+			 * We need to set RICHACL_PROTECTED because we are
+			 * doing an implicit chmod
+			 */
+			if (richacl_is_auto_inherit(acl))
+				acl->a_flags |= RICHACL_PROTECTED;
+
 			richacl_compute_max_masks(acl);
 			/*
 			 * Ensure that the acl will not grant any permissions
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index c8fae91a..c524a4b 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -76,6 +76,18 @@ extern void set_cached_richacl(struct inode *, struct richacl *);
 extern void forget_cached_richacl(struct inode *);
 extern struct richacl *get_richacl(struct inode *);
 
+static inline int
+richacl_is_auto_inherit(const struct richacl *acl)
+{
+	return acl->a_flags & RICHACL_AUTO_INHERIT;
+}
+
+static inline int
+richacl_is_protected(const struct richacl *acl)
+{
+	return acl->a_flags & RICHACL_PROTECTED;
+}
+
 /**
  * richace_is_owner  -  check if @ace is an OWNER@ entry
  */
diff --git a/include/uapi/linux/richacl.h b/include/uapi/linux/richacl.h
index 1ed48ac..8849a53 100644
--- a/include/uapi/linux/richacl.h
+++ b/include/uapi/linux/richacl.h
@@ -18,6 +18,9 @@
 #define __UAPI_RICHACL_H
 
 /* a_flags values */
+#define RICHACL_AUTO_INHERIT			0x01
+#define RICHACL_PROTECTED			0x02
+#define RICHACL_DEFAULTED			0x04
 #define RICHACL_WRITE_THROUGH			0x40
 #define RICHACL_MASKED				0x80
 
@@ -31,6 +34,7 @@
 #define RICHACE_NO_PROPAGATE_INHERIT_ACE	0x0004
 #define RICHACE_INHERIT_ONLY_ACE		0x0008
 #define RICHACE_IDENTIFIER_GROUP		0x0040
+#define RICHACE_INHERITED_ACE			0x0080
 #define RICHACE_SPECIAL_WHO			0x4000
 
 /* e_mask bitflags */
@@ -60,6 +64,9 @@
 #define RICHACE_EVERYONE_SPECIAL_ID		2
 
 #define RICHACL_VALID_FLAGS (					\
+	RICHACL_AUTO_INHERIT |					\
+	RICHACL_PROTECTED |					\
+	RICHACL_DEFAULTED |					\
 	RICHACL_WRITE_THROUGH |					\
 	RICHACL_MASKED )
 
@@ -69,13 +76,15 @@
 	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
 	RICHACE_INHERIT_ONLY_ACE |				\
 	RICHACE_IDENTIFIER_GROUP |				\
+	RICHACE_INHERITED_ACE |					\
 	RICHACE_SPECIAL_WHO )
 
 #define RICHACE_INHERITANCE_FLAGS (				\
 	RICHACE_FILE_INHERIT_ACE |				\
 	RICHACE_DIRECTORY_INHERIT_ACE |				\
 	RICHACE_NO_PROPAGATE_INHERIT_ACE |			\
-	RICHACE_INHERIT_ONLY_ACE )
+	RICHACE_INHERIT_ONLY_ACE |				\
+	RICHACE_INHERITED_ACE )
 
 /* Valid RICHACE_* flags for directories and non-directories */
 #define RICHACE_VALID_MASK (					\
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
