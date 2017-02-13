Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753663AbdBMPeW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:34:22 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v28 21/21] ext4: Add richacl feature flag
Date: Mon, 13 Feb 2017 16:32:37 +0100
Message-Id: <1486999957-2381-22-git-send-email-agruenba@redhat.com>
In-Reply-To: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
References: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This feature flag selects richacl instead of POSIX ACL support on the
filesystem.  When this feature is off, the "acl" and "noacl" mount options
control whether POSIX ACLs are enabled.  When it is on, richacls are
automatically enabled and using the "noacl" mount option leads to an error.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  |  7 +++++--
 fs/ext4/super.c | 48 +++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2163c1e..985863a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1119,7 +1119,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_UPDATE_JOURNAL	0x01000	/* Update the journal format */
 #define EXT4_MOUNT_NO_UID32		0x02000  /* Disable 32-bit UIDs */
 #define EXT4_MOUNT_XATTR_USER		0x04000	/* Extended user attributes */
-#define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
+#define EXT4_MOUNT_ACL			0x08000	/* Access Control Lists */
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
 #define EXT4_MOUNT_QUOTA		0x40000 /* Some quota option set */
@@ -1683,6 +1683,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_RICHACL		0x20000
 
 #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline bool ext4_has_feature_##name(struct super_block *sb) \
@@ -1771,6 +1772,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
+EXT4_FEATURE_INCOMPAT_FUNCS(richacl,		RICHACL)
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1797,7 +1799,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
 					 EXT4_FEATURE_INCOMPAT_MMP | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
-					 EXT4_FEATURE_INCOMPAT_CSUM_SEED)
+					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
+					 EXT4_FEATURE_INCOMPAT_RICHACL)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66845a0..089eff9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1408,6 +1408,27 @@ static ext4_fsblk_t get_sb_block(void **data)
 	return sb_block;
 }
 
+static int enable_acl(struct super_block *sb)
+{
+	sb->s_flags &= ~(MS_POSIXACL | MS_RICHACL);
+	if (test_opt(sb, ACL)) {
+		if (ext4_has_feature_richacl(sb)) {
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
@@ -1554,9 +1575,9 @@ static const struct mount_opts {
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
@@ -1607,6 +1628,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 #endif
 	switch (token) {
 	case Opt_noacl:
+#ifdef CONFIG_EXT4_FS_RICHACL
+	if (ext4_has_feature_richacl(sb)) {
+		ext4_msg(sb, KERN_ERR, "Mount option \"%s\" incompatible "
+			 "with richacl feature", opt);
+		return -1;
+	}
+#endif
 	case Opt_nouser_xattr:
 		ext4_msg(sb, KERN_WARNING, deprecated_msg, opt, "3.5");
 		break;
@@ -3444,8 +3472,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -3541,8 +3569,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_iflags |= SB_I_CGROUPWB;
 	}
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
+	err = enable_acl(sb);
+	if (err)
+		goto failed_mount;
 
 	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV &&
 	    (ext4_has_compat_features(sb) ||
@@ -4922,8 +4951,9 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, "Abort forced by user");
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
-		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
+	err = enable_acl(sb);
+	if (err)
+		goto restore_opts;
 
 	es = sbi->s_es;
 
-- 
2.7.4

