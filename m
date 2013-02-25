Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C2BA17F58
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 19:32:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FB9FAC005
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 17:32:28 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	CNAhMbBKcgjImdYK for <xfs@oss.sgi.com>;
	Sun, 24 Feb 2013 17:32:25 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1U9mv3-0002tB-68
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:53 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1U9mut-0003I2-2T
	for xfs@oss.sgi.com; Mon, 25 Feb 2013 12:31:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/16] xfs: add CRC checks to the AGFL
Date: Mon, 25 Feb 2013 12:31:30 +1100
Message-Id: <1361755901-12453-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1361755901-12453-1-git-send-email-david@fromorbit.com>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Add CRC checks, location information and a magic number to the AGFL.
Previously the AGFL was just a block containing nothing but the
free block pointers.  The new AGFL has a real header with the usual
boilerplate instead, so that we can verify it's not corrupted and
written into the right place.

[dchinner@redhat.com] Added LSN field, reworked significantly to fit
into new verifier structure and growfs structure, enabled full
verifier functionality now there is a header to verify and we can
guarantee an initialised AGFL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h          |   25 +++++++++-
 fs/xfs/xfs_alloc.c       |  119 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_buf_item.h    |    4 +-
 fs/xfs/xfs_fsops.c       |    5 ++
 fs/xfs/xfs_log_recover.c |   10 ++++
 5 files changed, 119 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index 9f4815e..272ef09 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -30,6 +30,7 @@ struct xfs_trans;
 
 #define	XFS_AGF_MAGIC	0x58414746	/* 'XAGF' */
 #define	XFS_AGI_MAGIC	0x58414749	/* 'XAGI' */
+#define	XFS_AGFL_MAGIC	0x5841464c	/* 'XAFL' */
 #define	XFS_AGF_VERSION	1
 #define	XFS_AGI_VERSION	1
 
@@ -190,11 +191,31 @@ extern const struct xfs_buf_ops xfs_agi_buf_ops;
  */
 #define XFS_AGFL_DADDR(mp)	((xfs_daddr_t)(3 << (mp)->m_sectbb_log))
 #define	XFS_AGFL_BLOCK(mp)	XFS_HDR_BLOCK(mp, XFS_AGFL_DADDR(mp))
-#define XFS_AGFL_SIZE(mp)	((mp)->m_sb.sb_sectsize / sizeof(xfs_agblock_t))
 #define	XFS_BUF_TO_AGFL(bp)	((xfs_agfl_t *)((bp)->b_addr))
 
+#define XFS_BUF_TO_AGFL_BNO(mp, bp) \
+	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
+		(__be32 *)(bp)->b_addr)
+
+/*
+ * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
+ * slots in the beginning of the block for a proper header with the
+ * location information and CRC.
+ */
+#define XFS_AGFL_SIZE(mp) \
+	(((mp)->m_sb.sb_sectsize - \
+	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
+		sizeof(struct xfs_agfl) : 0)) / \
+	  sizeof(xfs_agblock_t))
+
 typedef struct xfs_agfl {
-	__be32		agfl_bno[1];	/* actually XFS_AGFL_SIZE(mp) */
+	__be32		agfl_magicnum;
+	__be32		agfl_seqno;
+	uuid_t		agfl_uuid;
+	__be64		agfl_lsn;
+	__be32		agfl_crc;
+	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
 } xfs_agfl_t;
 
 /*
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 1d2e9c3..53e699e 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -432,53 +432,84 @@ xfs_alloc_fixup_trees(
 	return 0;
 }
 
-static void
+static bool
 xfs_agfl_verify(
 	struct xfs_buf	*bp)
 {
-#ifdef WHEN_CRCS_COME_ALONG
-	/*
-	 * we cannot actually do any verification of the AGFL because mkfs does
-	 * not initialise the AGFL to zero or NULL. Hence the only valid part of
-	 * the AGFL is what the AGF says is active. We can't get to the AGF, so
-	 * we can't verify just those entries are valid.
-	 *
-	 * This problem goes away when the CRC format change comes along as that
-	 * requires the AGFL to be initialised by mkfs. At that point, we can
-	 * verify the blocks in the agfl -active or not- lie within the bounds
-	 * of the AG. Until then, just leave this check ifdef'd out.
-	 */
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agfl	*agfl = XFS_BUF_TO_AGFL(bp);
-	int		agfl_ok = 1;
-
 	int		i;
 
+	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
+		return false;
+	/*
+	 * during growfs operations, the perag is not fully initialised,
+	 * so we can't use it for any useful checking. growfs ensures we can't
+	 * use it by using uncached buffers that don't have the perag attached
+	 * so we can detect and avoid this problem.
+	 */
+	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
+		return false;
+
 	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
-		if (be32_to_cpu(agfl->agfl_bno[i]) == NULLAGBLOCK ||
+		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
-			agfl_ok = 0;
+			return false;
 	}
+	return true;
+}
+
+static void
+xfs_agfl_read_verify(
+	struct xfs_buf	*bp)
+{
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	int		agfl_ok = 1;
+
+	/*
+	 * There is no verification of non-crc AGFLs because mkfs does not
+	 * initialise the AGFL to zero or NULL. Hence the only valid part of the
+	 * AGFL is what the AGF says is active. We can't get to the AGF, so we
+	 * can't verify just those entries are valid.
+	 */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	agfl_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+				   offsetof(struct xfs_agfl, agfl_crc));
+
+	agfl_ok = agfl_ok && xfs_agfl_verify(bp);
 
 	if (!agfl_ok) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agfl);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
 	}
-#endif
 }
 
 static void
 xfs_agfl_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agfl_verify(bp);
-}
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
-static void
-xfs_agfl_read_verify(
-	struct xfs_buf	*bp)
-{
-	xfs_agfl_verify(bp);
+	/* no verification of non-crc AGFLs */
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (!xfs_agfl_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (bip)
+		XFS_BUF_TO_AGFL(bp)->agfl_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_agfl, agfl_crc));
 }
 
 const struct xfs_buf_ops xfs_agfl_buf_ops = {
@@ -1984,18 +2015,18 @@ xfs_alloc_get_freelist(
 	int		btreeblk) /* destination is a AGF btree */
 {
 	xfs_agf_t	*agf;	/* a.g. freespace structure */
-	xfs_agfl_t	*agfl;	/* a.g. freelist structure */
 	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
 	xfs_agblock_t	bno;	/* block number returned */
+	__be32		*agfl_bno;
 	int		error;
 	int		logflags;
-	xfs_mount_t	*mp;	/* mount structure */
+	xfs_mount_t	*mp = tp->t_mountp;
 	xfs_perag_t	*pag;	/* per allocation group data */
 
-	agf = XFS_BUF_TO_AGF(agbp);
 	/*
 	 * Freelist is empty, give up.
 	 */
+	agf = XFS_BUF_TO_AGF(agbp);
 	if (!agf->agf_flcount) {
 		*bnop = NULLAGBLOCK;
 		return 0;
@@ -2003,15 +2034,17 @@ xfs_alloc_get_freelist(
 	/*
 	 * Read the array of free blocks.
 	 */
-	mp = tp->t_mountp;
-	if ((error = xfs_alloc_read_agfl(mp, tp,
-			be32_to_cpu(agf->agf_seqno), &agflbp)))
+	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
+				    &agflbp);
+	if (error)
 		return error;
-	agfl = XFS_BUF_TO_AGFL(agflbp);
+
+
 	/*
 	 * Get the block number and update the data structures.
 	 */
-	bno = be32_to_cpu(agfl->agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
 	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
@@ -2104,12 +2137,13 @@ xfs_alloc_put_freelist(
 	int			btreeblk) /* block came from a AGF btree */
 {
 	xfs_agf_t		*agf;	/* a.g. freespace structure */
-	xfs_agfl_t		*agfl;	/* a.g. free block array */
 	__be32			*blockp;/* pointer to array entry */
 	int			error;
 	int			logflags;
 	xfs_mount_t		*mp;	/* mount structure */
 	xfs_perag_t		*pag;	/* per allocation group data */
+	__be32			*agfl_bno;
+	int			startoff;
 
 	agf = XFS_BUF_TO_AGF(agbp);
 	mp = tp->t_mountp;
@@ -2117,7 +2151,6 @@ xfs_alloc_put_freelist(
 	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
-	agfl = XFS_BUF_TO_AGFL(agflbp);
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
@@ -2138,13 +2171,17 @@ xfs_alloc_put_freelist(
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
 	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
-	blockp = &agfl->agfl_bno[be32_to_cpu(agf->agf_fllast)];
+
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
 	*blockp = cpu_to_be32(bno);
+	startoff = (char *)blockp - (char *)agflbp->b_addr;
+
 	xfs_alloc_log_agf(tp, agbp, logflags);
-	xfs_trans_log_buf(tp, agflbp,
-		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl),
-		(int)((xfs_caddr_t)blockp - (xfs_caddr_t)agfl +
-			sizeof(xfs_agblock_t) - 1));
+
+	xfs_trans_buf_set_type(tp, agflbp, XFS_BLF_AGFL_BUF);
+	xfs_trans_log_buf(tp, agflbp, startoff,
+			  startoff + sizeof(xfs_agblock_t) - 1);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 76bd7a1..067d5f0 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -46,13 +46,15 @@ extern kmem_zone_t	*xfs_buf_item_zone;
  */
 #define XFS_BLF_BTREE_BUF	(1<<5)
 #define XFS_BLF_AGF_BUF		(1<<6)
+#define XFS_BLF_AGFL_BUF	(1<<7)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
 		 XFS_BLF_PDQUOT_BUF | \
 		 XFS_BLF_GDQUOT_BUF | \
 		 XFS_BLF_BTREE_BUF | \
-		 XFS_BLF_AGF_BUF)
+		 XFS_BLF_AGF_BUF | \
+		 XFS_BLF_AGFL_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b6cca27..a693a54 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -268,6 +268,11 @@ xfs_growfs_data_private(
 		}
 
 		agfl = XFS_BUF_TO_AGFL(bp);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+			agfl->agfl_seqno = cpu_to_be32(agno);
+			uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
+		}
 		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
 			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c9f1c6d..b256cc7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1962,6 +1962,16 @@ xlog_recover_do_reg_buffer(
 		}
 		bp->b_ops = &xfs_agf_buf_ops;
 		break;
+	case XFS_BLF_AGFL_BUF:
+		if (!xfs_sb_version_hascrc(&mp->m_sb))
+			break;
+		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGFL_MAGIC)) {
+			xfs_warn(mp, "Bad AGFL block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_agfl_buf_ops;
+		break;
 	default:
 		break;
 	}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
