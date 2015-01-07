Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3F107FB0
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:51:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3163304051
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:51:12 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ENpykHRaZzYzRMMo for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:51:10 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yVP-0005JI-2t
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:51:07 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yVP-0001xe-25
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:51:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: sanitise sb_bad_features2 handling
Date: Thu,  8 Jan 2015 08:51:05 +1100
Message-Id: <1420667465-7453-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1420667465-7453-1-git-send-email-david@fromorbit.com>
References: <1420667465-7453-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

We currently have to ensure that every time we update sb_features2
that we update sb_bad_features2. Now that we log and format the
superblock in it's entirety we actually don't have to care because
we can simply update the sb_bad_features2 when we format it into the
buffer. This removes the need for anything but the mount and
superblock formatting code to care about sb_bad_features2, and
hence removes the possibility that we forget to update bad_features2
when necessary in the future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 14 +++++++-------
 fs/xfs/libxfs/xfs_sb.c     |  8 +++++++-
 fs/xfs/xfs_mount.c         | 23 +++++++++++------------
 3 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4762732..8eb7189 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -151,10 +151,13 @@ typedef struct xfs_sb {
 	__uint32_t	sb_features2;	/* additional feature bits */
 
 	/*
-	 * bad features2 field as a result of failing to pad the sb
-	 * structure to 64 bits. Some machines will be using this field
-	 * for features2 bits. Easiest just to mark it bad and not use
-	 * it for anything else.
+	 * bad features2 field as a result of failing to pad the sb structure to
+	 * 64 bits. Some machines will be using this field for features2 bits.
+	 * Easiest just to mark it bad and not use it for anything else.
+	 *
+	 * This is not kept up to date in memory; it is always overwritten by
+	 * the value in sb_features2 when formatting the incore superblock to
+	 * the disk buffer.
 	 */
 	__uint32_t	sb_bad_features2;
 
@@ -453,13 +456,11 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
-	sbp->sb_bad_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
 static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
-	sbp->sb_bad_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
 	if (!sbp->sb_features2)
 		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
 }
@@ -475,7 +476,6 @@ static inline void xfs_sb_version_addprojid32bit(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
-	sbp->sb_bad_features2 |= XFS_SB_VERSION2_PROJID32BIT;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6ee3af6..b440839 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -488,7 +488,6 @@ xfs_sb_to_disk(
 	to->sb_fdblocks = cpu_to_be64(from->sb_fdblocks);
 	to->sb_frextents = cpu_to_be64(from->sb_frextents);
 
-
 	to->sb_flags = from->sb_flags;
 	to->sb_shared_vn = from->sb_shared_vn;
 	to->sb_inoalignmt = cpu_to_be32(from->sb_inoalignmt);
@@ -498,6 +497,13 @@ xfs_sb_to_disk(
 	to->sb_logsectlog = from->sb_logsectlog;
 	to->sb_logsectsize = cpu_to_be16(from->sb_logsectsize);
 	to->sb_logsunit = cpu_to_be32(from->sb_logsunit);
+
+	/*
+	 * We need to ensure that bad_features2 always matches features2.
+	 * Hence we enforce that here rather than having to remember to do it
+	 * everywhere else that updates features2.
+	 */
+	from->sb_bad_features2 = from->sb_features2;
 	to->sb_features2 = cpu_to_be32(from->sb_features2);
 	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 5ef9aa2..4fa80e6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -640,25 +640,24 @@ xfs_mountfs(
 	xfs_sb_mount_common(mp, sbp);
 
 	/*
-	 * Check for a mismatched features2 values.  Older kernels
-	 * read & wrote into the wrong sb offset for sb_features2
-	 * on some platforms due to xfs_sb_t not being 64bit size aligned
-	 * when sb_features2 was added, which made older superblock
-	 * reading/writing routines swap it as a 64-bit value.
+	 * Check for a mismatched features2 values.  Older kernels read & wrote
+	 * into the wrong sb offset for sb_features2 on some platforms due to
+	 * xfs_sb_t not being 64bit size aligned when sb_features2 was added,
+	 * which made older superblock reading/writing routines swap it as a
+	 * 64-bit value.
 	 *
 	 * For backwards compatibility, we make both slots equal.
 	 *
-	 * If we detect a mismatched field, we OR the set bits into the
-	 * existing features2 field in case it has already been modified; we
-	 * don't want to lose any features.  We then update the bad location
-	 * with the ORed value so that older kernels will see any features2
-	 * flags, and mark the two fields as needing updates once the
-	 * transaction subsystem is online.
+	 * If we detect a mismatched field, we OR the set bits into the existing
+	 * features2 field in case it has already been modified; we don't want
+	 * to lose any features.  We then update the bad location with the ORed
+	 * value so that older kernels will see any features2 flags. The
+	 * superblock writeback code ensures the new sb_features2 is copied to
+	 * sb_bad_features2 before it is logged or written to disk.
 	 */
 	if (xfs_sb_has_mismatched_features2(sbp)) {
 		xfs_warn(mp, "correcting sb_features alignment problem");
 		sbp->sb_features2 |= sbp->sb_bad_features2;
-		sbp->sb_bad_features2 = sbp->sb_features2;
 		mp->m_update_sb = true;
 
 		/*
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
