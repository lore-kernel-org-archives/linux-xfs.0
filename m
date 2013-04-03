Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CA2A29E25
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:12:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FE2FAC002
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:12:50 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	6NWmBH37hfqrmXfc for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:12:47 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFzR-0000Lx-WA
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:12:06 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFzH-0005CN-Nj
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 21/22] xfs: add CRC checks to the superblock
Date: Wed,  3 Apr 2013 16:11:31 +1100
Message-Id: <1364965892-19623-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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

With the addition of CRCs, there is such a wide and varied change to
the on disk format that it makes sense to bump the superblock
version number rather than try to use feature bits for all the new
functionality.

This commit introduces all the new superblock fields needed for all
the new functionality: feature masks similar to ext4, separate
project quota inodes, a LSN field for recovery and the CRC field.

This commit does not bump the superblock version number, however.
That will be done as a separate commit at the end of the series
after all the new functionality is present so we switch it all on in
one commit. This means that we can slowly introduce the changes
without them being active and hence maintain bisectability of the
tree.

This patch is based on a patch originally written by myself back
from SGI days, which was subsequently modified by Christoph Hellwig.
There is relatively little of that patch remaining, but the history
of the patch still should be acknowledged here.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |    8 ++++
 fs/xfs/xfs_mount.c       |  108 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_mount.h       |    1 +
 fs/xfs/xfs_sb.h          |  100 +++++++++++++++++++++++++++++-------------
 4 files changed, 172 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 8628507..5303b3d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2040,6 +2040,14 @@ xlog_recovery_validate_buf_type(
 		}
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 		break;
+	case XFS_BLFT_SB_BUF:
+		if (magic32 != XFS_SB_MAGIC) {
+			xfs_warn(mp, "Bad SB block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_sb_buf_ops;
+		break;
 	default:
 		xfs_warn(mp, "Unknown buffer type %d!",
 			 xfs_blft_from_flags(buf_f));
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3806088..140136c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -43,6 +43,8 @@
 #include "xfs_utils.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
+#include "xfs_cksum.h"
+#include "xfs_buf_item.h"
 
 
 #ifdef HAVE_PERCPU_SB
@@ -109,6 +111,12 @@ static const struct {
     { offsetof(xfs_sb_t, sb_logsunit),	 0 },
     { offsetof(xfs_sb_t, sb_features2),	 0 },
     { offsetof(xfs_sb_t, sb_bad_features2), 0 },
+    { offsetof(xfs_sb_t, sb_features_compat), 0 },
+    { offsetof(xfs_sb_t, sb_features_ro_compat), 0 },
+    { offsetof(xfs_sb_t, sb_features_incompat), 0 },
+    { offsetof(xfs_sb_t, sb_crc),	 0 },
+    { offsetof(xfs_sb_t, sb_pquotino),	 0 },
+    { offsetof(xfs_sb_t, sb_lsn),	 0 },
     { sizeof(xfs_sb_t),			 0 }
 };
 
@@ -319,11 +327,23 @@ xfs_mount_validate_sb(
 		return XFS_ERROR(EWRONGFS);
 	}
 
+
 	if (!xfs_sb_good_version(sbp)) {
 		xfs_warn(mp, "bad version");
 		return XFS_ERROR(EWRONGFS);
 	}
 
+	/*
+	 * Do not allow Version 5 superblocks to mount right now, even though
+	 * support is in place. We need to implement the proper feature masks
+	 * first.
+	 */
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
+		xfs_alert(mp,
+	"Version 5 superblock detected. Experimental support not yet enabled!");
+		return XFS_ERROR(EINVAL);
+	}
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
@@ -557,6 +577,11 @@ xfs_sb_from_disk(
 	to->sb_logsunit = be32_to_cpu(from->sb_logsunit);
 	to->sb_features2 = be32_to_cpu(from->sb_features2);
 	to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
+	to->sb_features_compat = be32_to_cpu(from->sb_features_compat);
+	to->sb_features_ro_compat = be32_to_cpu(from->sb_features_ro_compat);
+	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
+	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
+	to->sb_lsn = be64_to_cpu(from->sb_lsn);
 }
 
 /*
@@ -612,13 +637,12 @@ xfs_sb_to_disk(
 	}
 }
 
-static void
+static int
 xfs_sb_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
-	int		error;
 
 	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
@@ -626,16 +650,46 @@ xfs_sb_verify(
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
 	 */
-	error = xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR);
-	if (error)
-		xfs_buf_ioerror(bp, error);
+	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR);
 }
 
+/*
+ * If the superblock has the CRC feature bit set or the CRC field is non-null,
+ * check that the CRC is valid.  We check the CRC field is non-null because a
+ * single bit error could clear the feature bit and unused parts of the
+ * superblock are supposed to be zero. Hence a non-null crc field indicates that
+ * we've potentially lost a feature bit and we should check it anyway.
+ */
 static void
 xfs_sb_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_sb_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+	int		error;
+
+	/*
+	 * open code the version check to avoid needing to convert the entire
+	 * superblock from disk order just to check the version number
+	 */
+	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC) &&
+	    (((be16_to_cpu(dsb->sb_versionnum) & XFS_SB_VERSION_NUMBITS) ==
+						XFS_SB_VERSION_5) ||
+	     dsb->sb_crc != 0)) {
+
+		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
+				      offsetof(struct xfs_sb, sb_crc))) {
+			error = EFSCORRUPTED;
+			goto out_error;
+		}
+	}
+	error = xfs_sb_verify(bp);
+
+out_error:
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, error);
+	}
 }
 
 /*
@@ -648,11 +702,10 @@ static void
 xfs_sb_quiet_read_verify(
 	struct xfs_buf	*bp)
 {
-	struct xfs_sb	sb;
+	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
 
-	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
 
-	if (sb.sb_magicnum == XFS_SB_MAGIC) {
+	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {
 		/* XFS filesystem, verify noisily! */
 		xfs_sb_read_verify(bp);
 		return;
@@ -663,9 +716,27 @@ xfs_sb_quiet_read_verify(
 
 static void
 xfs_sb_write_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	xfs_sb_verify(bp);
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	int			error;
+
+	error = xfs_sb_verify(bp);
+	if (error) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, error);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		XFS_BUF_TO_SBP(bp)->sb_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_sb, sb_crc));
 }
 
 const struct xfs_buf_ops xfs_sb_buf_ops = {
@@ -687,7 +758,8 @@ int
 xfs_readsb(xfs_mount_t *mp, int flags)
 {
 	unsigned int	sector_size;
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
+	struct xfs_sb	*sbp = &mp->m_sb;
 	int		error;
 	int		loud = !(flags & XFS_MFSI_QUIET);
 
@@ -726,10 +798,10 @@ reread:
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
 	 */
-	if (sector_size > mp->m_sb.sb_sectsize) {
+	if (sector_size > sbp->sb_sectsize) {
 		if (loud)
 			xfs_warn(mp, "device supports %u byte sectors (not %u)",
-				sector_size, mp->m_sb.sb_sectsize);
+				sector_size, sbp->sb_sectsize);
 		error = ENOSYS;
 		goto release_buf;
 	}
@@ -738,15 +810,18 @@ reread:
 	 * If device sector size is smaller than the superblock size,
 	 * re-read the superblock so the buffer is correctly sized.
 	 */
-	if (sector_size < mp->m_sb.sb_sectsize) {
+	if (sector_size < sbp->sb_sectsize) {
 		xfs_buf_relse(bp);
-		sector_size = mp->m_sb.sb_sectsize;
+		sector_size = sbp->sb_sectsize;
 		goto reread;
 	}
 
 	/* Initialize per-cpu counters */
 	xfs_icsb_reinit_counters(mp);
 
+	/* no need to be quiet anymore, so reset the buf ops */
+	bp->b_ops = &xfs_sb_buf_ops;
+
 	mp->m_sb_bp = bp;
 	xfs_buf_unlock(bp);
 	return 0;
@@ -1633,6 +1708,7 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
+	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 687c171..b004cec 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -391,6 +391,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 
 #endif	/* __KERNEL__ */
 
+extern void	xfs_sb_calc_crc(struct xfs_buf	*);
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);
 extern int	xfs_initialize_perag(struct xfs_mount *, xfs_agnumber_t,
 					xfs_agnumber_t *);
diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
index a05b451..457fefa 100644
--- a/fs/xfs/xfs_sb.h
+++ b/fs/xfs/xfs_sb.h
@@ -32,6 +32,7 @@ struct xfs_mount;
 #define	XFS_SB_VERSION_2	2		/* 6.2 - attributes */
 #define	XFS_SB_VERSION_3	3		/* 6.2 - new inode version */
 #define	XFS_SB_VERSION_4	4		/* 6.2+ - bitmask version */
+#define	XFS_SB_VERSION_5	5		/* CRC enabled filesystem */
 #define	XFS_SB_VERSION_NUMBITS		0x000f
 #define	XFS_SB_VERSION_ALLFBITS		0xfff0
 #define	XFS_SB_VERSION_SASHFBITS	0xf000
@@ -161,6 +162,18 @@ typedef struct xfs_sb {
 	 */
 	__uint32_t	sb_bad_features2;
 
+	/* version 5 superblock fields start here */
+
+	/* feature masks */
+	__uint32_t	sb_features_compat;
+	__uint32_t	sb_features_ro_compat;
+	__uint32_t	sb_features_incompat;
+
+	__uint32_t	sb_crc;		/* superblock crc */
+
+	xfs_ino_t	sb_pquotino;	/* project quota inode */
+	xfs_lsn_t	sb_lsn;		/* last write sequence */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -229,7 +242,19 @@ typedef struct xfs_dsb {
 	 * for features2 bits. Easiest just to mark it bad and not use
 	 * it for anything else.
 	 */
-	__be32	sb_bad_features2;
+	__be32		sb_bad_features2;
+
+	/* version 5 superblock fields start here */
+
+	/* feature masks */
+	__be32		sb_features_compat;
+	__be32		sb_features_ro_compat;
+	__be32		sb_features_incompat;
+
+	__le32		sb_crc;		/* superblock crc */
+
+	__be64		sb_pquotino;	/* project quota inode */
+	__be64		sb_lsn;		/* last write sequence */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -250,7 +275,9 @@ typedef enum {
 	XFS_SBS_GQUOTINO, XFS_SBS_QFLAGS, XFS_SBS_FLAGS, XFS_SBS_SHARED_VN,
 	XFS_SBS_INOALIGNMT, XFS_SBS_UNIT, XFS_SBS_WIDTH, XFS_SBS_DIRBLKLOG,
 	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
-	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2,
+	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
+	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT, XFS_SBS_CRC,
+	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
 	XFS_SBS_FIELDCOUNT
 } xfs_sb_field_t;
 
@@ -276,6 +303,11 @@ typedef enum {
 #define XFS_SB_FDBLOCKS		XFS_SB_MVAL(FDBLOCKS)
 #define XFS_SB_FEATURES2	XFS_SB_MVAL(FEATURES2)
 #define XFS_SB_BAD_FEATURES2	XFS_SB_MVAL(BAD_FEATURES2)
+#define XFS_SB_FEATURES_COMPAT	XFS_SB_MVAL(FEATURES_COMPAT)
+#define XFS_SB_FEATURES_RO_COMPAT XFS_SB_MVAL(FEATURES_RO_COMPAT)
+#define XFS_SB_FEATURES_INCOMPAT XFS_SB_MVAL(FEATURES_INCOMPAT)
+#define XFS_SB_CRC		XFS_SB_MVAL(CRC)
+#define XFS_SB_PQUOTINO		XFS_SB_MVAL(PQUOTINO)
 #define	XFS_SB_NUM_BITS		((int)XFS_SBS_FIELDCOUNT)
 #define	XFS_SB_ALL_BITS		((1LL << XFS_SB_NUM_BITS) - 1)
 #define	XFS_SB_MOD_BITS		\
@@ -283,7 +315,8 @@ typedef enum {
 	 XFS_SB_VERSIONNUM | XFS_SB_UQUOTINO | XFS_SB_GQUOTINO | \
 	 XFS_SB_QFLAGS | XFS_SB_SHARED_VN | XFS_SB_UNIT | XFS_SB_WIDTH | \
 	 XFS_SB_ICOUNT | XFS_SB_IFREE | XFS_SB_FDBLOCKS | XFS_SB_FEATURES2 | \
-	 XFS_SB_BAD_FEATURES2)
+	 XFS_SB_BAD_FEATURES2 | XFS_SB_FEATURES_COMPAT | \
+	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | XFS_SB_PQUOTINO)
 
 
 /*
@@ -325,6 +358,8 @@ static inline int xfs_sb_good_version(xfs_sb_t *sbp)
 
 		return 1;
 	}
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
+		return 1;
 
 	return 0;
 }
@@ -365,7 +400,7 @@ static inline int xfs_sb_version_hasattr(xfs_sb_t *sbp)
 {
 	return sbp->sb_versionnum == XFS_SB_VERSION_2 ||
 		sbp->sb_versionnum == XFS_SB_VERSION_3 ||
-		(XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
 		 (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT));
 }
 
@@ -373,7 +408,7 @@ static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 {
 	if (sbp->sb_versionnum == XFS_SB_VERSION_1)
 		sbp->sb_versionnum = XFS_SB_VERSION_2;
-	else if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+	else if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	else
 		sbp->sb_versionnum = XFS_SB_VERSION_4 | XFS_SB_VERSION_ATTRBIT;
@@ -382,7 +417,7 @@ static inline void xfs_sb_version_addattr(xfs_sb_t *sbp)
 static inline int xfs_sb_version_hasnlink(xfs_sb_t *sbp)
 {
 	return sbp->sb_versionnum == XFS_SB_VERSION_3 ||
-		 (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		 (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
 		  (sbp->sb_versionnum & XFS_SB_VERSION_NLINKBIT));
 }
 
@@ -396,13 +431,13 @@ static inline void xfs_sb_version_addnlink(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_hasquota(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
 }
 
 static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 {
-	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
+	if (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4)
 		sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
 	else
 		sbp->sb_versionnum = xfs_sb_version_tonew(sbp->sb_versionnum) |
@@ -411,13 +446,14 @@ static inline void xfs_sb_version_addquota(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_hasalign(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
 }
 
 static inline int xfs_sb_version_hasdalign(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
 }
 
@@ -429,38 +465,42 @@ static inline int xfs_sb_version_hasshared(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_hasdirv2(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT));
 }
 
 static inline int xfs_sb_version_haslogv2(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT));
 }
 
 static inline int xfs_sb_version_hasextflgbit(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT));
 }
 
 static inline int xfs_sb_version_hassector(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
 }
 
 static inline int xfs_sb_version_hasasciici(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+	return XFS_SB_VERSION_NUM(sbp) >= XFS_SB_VERSION_4 &&
 		(sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
 }
 
 static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 {
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
-		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4 &&
+		(sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT));
 }
 
 /*
@@ -475,14 +515,16 @@ static inline int xfs_sb_version_hasmorebits(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_haslazysbcount(xfs_sb_t *sbp)
 {
-	return xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
 }
 
 static inline int xfs_sb_version_hasattr2(xfs_sb_t *sbp)
 {
-	return xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
 }
 
 static inline void xfs_sb_version_addattr2(xfs_sb_t *sbp)
@@ -500,14 +542,14 @@ static inline void xfs_sb_version_removeattr2(xfs_sb_t *sbp)
 
 static inline int xfs_sb_version_hasprojid32bit(xfs_sb_t *sbp)
 {
-	return xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT);
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
+	       (xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
 }
 
 static inline int xfs_sb_version_hascrc(xfs_sb_t *sbp)
 {
-	return (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_CRCBIT));
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
