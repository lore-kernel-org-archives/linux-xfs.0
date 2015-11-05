Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41BE27FD7
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 05:42:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3339A304053
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 03:42:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pNszCi1PzXGjEZpN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 03:42:23 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v14 22/22] ext4: Add richacl feature flag
Date: Thu,  5 Nov 2015 12:39:40 +0100
Message-Id: <1446723580-3747-23-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
References: <1446723580-3747-1-git-send-email-agruenba@redhat.com>
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andreas Gruenbacher <agruenba@redhat.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This feature flag selects richacl instead of POSIX ACL support on the
filesystem.  When this feature is off, the "acl" and "noacl" mount options
control whether POSIX ACLs are enabled.  When it is on, richacls are
automatically enabled and using the "noacl" mount option leads to an error.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ext4/ext4.h  |  6 ++++--
 fs/ext4/super.c | 49 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fd1f28b..b97a3b1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -991,7 +991,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
 #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
 #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
-#define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
+#define EXT4_MOUNT_ACL			0x08000	/* Access Control Lists */
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
 #define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
@@ -1582,6 +1582,7 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_RICHACL		0x20000
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1607,7 +1608,8 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
 					 EXT4_FEATURE_INCOMPAT_MMP | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
-					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
+					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
+					 EXT4_FEATURE_INCOMPAT_RICHACL)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a63c7b0..7457ea8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1270,6 +1270,28 @@ static ext4_fsblk_t get_sb_block(void **data)
 	return sb_block;
 }
 
+static int enable_acl(struct super_block *sb)
+{
+	sb->s_flags &= ~(MS_POSIXACL | MS_RICHACL);
+	if (test_opt(sb, ACL)) {
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					      EXT4_FEATURE_INCOMPAT_RICHACL)) {
+#ifdef CONFIG_EXT4_FS_RICHACL
+			sb->s_flags |= MS_RICHACL;
+#else
+			return -EOPNOTSUPP;
+#endif
+		} else {
+#ifdef CONFIG_EXT4_FS_POSIX_ACL
+			sb->s_flags |= MS_POSIXACL;
+#else
+			return -EOPNOTSUPP;
+#endif
+		}
+	}
+	return 0;
+}
+
 #define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
 static char deprecated_msg[] = "Mount option \"%s\" will be removed by %s\n"
 	"Contact linux-ext4@vger.kernel.org if you think we should keep it.\n";
@@ -1416,9 +1438,9 @@ static const struct mount_opts {
 	 MOPT_NO_EXT2 | MOPT_DATAJ},
 	{Opt_user_xattr, EXT4_MOUNT_XATTR_USER, MOPT_SET},
 	{Opt_nouser_xattr, EXT4_MOUNT_XATTR_USER, MOPT_CLEAR},
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
-	{Opt_acl, EXT4_MOUNT_POSIX_ACL, MOPT_SET},
-	{Opt_noacl, EXT4_MOUNT_POSIX_ACL, MOPT_CLEAR},
+#if defined(CONFIG_EXT4_FS_POSIX_ACL) || defined(CONFIG_EXT4_FS_RICHACL)
+	{Opt_acl, EXT4_MOUNT_ACL, MOPT_SET},
+	{Opt_noacl, EXT4_MOUNT_ACL, MOPT_CLEAR},
 #else
 	{Opt_acl, 0, MOPT_NOSUPPORT},
 	{Opt_noacl, 0, MOPT_NOSUPPORT},
@@ -1466,6 +1488,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 #endif
 	switch (token) {
 	case Opt_noacl:
+#ifdef CONFIG_EXT4_FS_RICHACL
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RICHACL)) {
+		ext4_msg(sb, KERN_ERR, "Mount option \"%s\" incompatible "
+			 "with richacl feature", opt);
+		return -1;
+	}
+#endif
 	case Opt_nouser_xattr:
 		ext4_msg(sb, KERN_WARNING, deprecated_msg, opt, "3.5");
 		break;
@@ -3576,8 +3605,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		set_opt(sb, NO_UID32);
 	/* xattr user namespace & acls are now defaulted on */
 	set_opt(sb, XATTR_USER);
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
-	set_opt(sb, POSIX_ACL);
+#if defined(CONFIG_EXT4_FS_POSIX_ACL) || defined(CONFIG_EXT4_FS_RICHACL)
+	set_opt(sb, ACL);
 #endif
 	/* don't forget to enable journal_csum when metadata_csum is enabled. */
 	if (ext4_has_metadata_csum(sb))
@@ -3660,8 +3689,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_iflags |= SB_I_CGROUPWB;
 	}
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
+	err = enable_acl(sb);
+	if (err)
+		goto failed_mount;
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (EXT4_HAS_COMPAT_FEATURE(sb, ~0U) ||
@@ -4981,8 +5011,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, "Abort forced by user");
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
+	err = enable_acl(sb);
+	if (err)
+		goto restore_opts;
 
 	es = sbi->s_es;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
