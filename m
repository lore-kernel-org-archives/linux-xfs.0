Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Apr 2008 18:05:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3315oWx001067
	for <xfs@oss.sgi.com>; Wed, 2 Apr 2008 18:05:50 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95BB0731FE1
	for <xfs@oss.sgi.com>; Wed,  2 Apr 2008 18:06:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id IVcFAq3MqrmmpOkK for <xfs@oss.sgi.com>; Wed, 02 Apr 2008 18:06:23 -0700 (PDT)
Message-ID: <47F42D8D.3030406@sandeen.net>
Date: Wed, 02 Apr 2008 20:06:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] combined features2 fixup patches (updating/rewriting what
 was sent in other threads)
References: <47F0546C.9070709@sandeen.net> <20080402002940.GZ103491721@sgi.com>
In-Reply-To: <20080402002940.GZ103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

(Addressing Dave's review point)

Ensure "both" features2 slots are consistent, and set mp attr2 flag.

Since older kernels may look in the sb_bad_features2 slot for
flags, rather than zeroing it out on fixup, we should make it 
equal to the sb_features2 value.

Also, if the ATTR2 flag was not found prior to features2
fixup, it was not set in the mount flags, so re-check after the
fixup so that the current session will use the feature.

Also fix up the comments to reflect these changes.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c
@@ -967,23 +967,32 @@ xfs_mountfs(
 	xfs_mount_common(mp, sbp);
 
 	/*
-	 * Check for a bad features2 field alignment. This happened on
-	 * some platforms due to xfs_sb_t not being 64bit size aligned
-	 * when sb_features was added and hence the compiler put it in
-	 * the wrong place.
+	 * Check for a mismatched features2 values.  Older kernels
+	 * read & wrote into the wrong sb offset for sb_features2
+	 * on some platforms due to xfs_sb_t not being 64bit size aligned
+	 * when sb_features2 was added, which made older superblock
+	 * reading/writing routines swap it as a 64-bit value.
 	 *
-	 * If we detect a bad field, we or the set bits into the existing
-	 * features2 field in case it has already been modified and we
-	 * don't want to lose any features. Zero the bad one and mark
-	 * the two fields as needing updates once the transaction subsystem
-	 * is online.
+	 * For backwards compatibility, we make both slots equal.
+	 *
+	 * If we detect a mismatched field, we OR the set bits into the
+	 * existing features2 field in case it has already been modified; we
+	 * don't want to lose any features.  We then update the bad location
+	 * with the ORed value so that older kernels will see any features2
+	 * flags, and mark the two fields as needing updates once the
+	 * transaction subsystem is online.
 	 */
-	if (xfs_sb_has_bad_features2(sbp)) {
+	if (xfs_sb_has_mismatched_features2(sbp)) {
 		cmn_err(CE_WARN,
 			"XFS: correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
-		sbp->sb_bad_features2 = 0;
+		sbp->sb_bad_features2 = sbp->sb_features2;
 		update_flags |= XFS_SB_FEATURES2 | XFS_SB_BAD_FEATURES2;
+		/*
+		 * Re-check for ATTR2 from the bad_features2 slot.
+		 */
+		if (xfs_sb_version_hasattr2(&mp->m_sb))
+			mp->m_flags |= XFS_MOUNT_ATTR2;
 	}
 
 	/*
@@ -1890,7 +1899,8 @@ xfs_uuid_unmount(
 
 /*
  * Used to log changes to the superblock unit and width fields which could
- * be altered by the mount options. Only the first superblock is updated.
+ * be altered by the mount options, as well as any potential sb_features2
+ * fixup. Only the first superblock is updated.
  */
 STATIC void
 xfs_mount_log_sb(
Index: linux-2.6-xfs/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_sb.h
+++ linux-2.6-xfs/fs/xfs/xfs_sb.h
@@ -320,11 +320,12 @@ static inline int xfs_sb_good_version(xf
 #endif /* __KERNEL__ */
 
 /*
- * Detect a bad features2 field
+ * Detect a mismatched features2 field.  Older kernels read/wrote
+ * this into the wrong slot, so to be safe we keep them in sync.
  */
-static inline int xfs_sb_has_bad_features2(xfs_sb_t *sbp)
+static inline int xfs_sb_has_mismatched_features2(xfs_sb_t *sbp)
 {
-	return (sbp->sb_bad_features2 != 0);
+	return (sbp->sb_bad_features2 != sbp->sb_features2);
 }
 
 static inline unsigned xfs_sb_version_tonew(unsigned v)
