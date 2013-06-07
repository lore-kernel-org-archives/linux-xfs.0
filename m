Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 129AA7F63
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9FBE8F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	spCz6Vwf9jw847Cl for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:30 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVW-0003tz-Rz
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVW-0001Jh-P0
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/48] xfsprogs: add crc format chagnes to ag headers
Date: Fri,  7 Jun 2013 10:25:27 +1000
Message-Id: <1370564771-4929-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_ag.h       |   54 ++++++++++++-
 include/xfs_buf_item.h |    8 +-
 libxfs/xfs_alloc.c     |  197 ++++++++++++++++++++++++++++++++----------------
 libxfs/xfs_ialloc.c    |   55 ++++++++++----
 4 files changed, 231 insertions(+), 83 deletions(-)

diff --git a/include/xfs_ag.h b/include/xfs_ag.h
index f2aeedb..1e0fa34 100644
--- a/include/xfs_ag.h
+++ b/include/xfs_ag.h
@@ -30,6 +30,7 @@ struct xfs_trans;
 
 #define	XFS_AGF_MAGIC	0x58414746	/* 'XAGF' */
 #define	XFS_AGI_MAGIC	0x58414749	/* 'XAGI' */
+#define	XFS_AGFL_MAGIC	0x5841464c	/* 'XAFL' */
 #define	XFS_AGF_VERSION	1
 #define	XFS_AGI_VERSION	1
 
@@ -63,12 +64,29 @@ typedef struct xfs_agf {
 	__be32		agf_spare0;	/* spare field */
 	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
 	__be32		agf_spare1;	/* spare field */
+
 	__be32		agf_flfirst;	/* first freelist block's index */
 	__be32		agf_fllast;	/* last freelist block's index */
 	__be32		agf_flcount;	/* count of blocks in freelist */
 	__be32		agf_freeblks;	/* total free blocks */
+
 	__be32		agf_longest;	/* longest free space */
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
+	uuid_t		agf_uuid;	/* uuid of filesystem */
+
+	/*
+	 * reserve some contiguous space for future logged fields before we add
+	 * the unlogged fields. This makes the range logging via flags and
+	 * structure offsets much simpler.
+	 */
+	__be64		agf_spare64[16];
+
+	/* unlogged fields, written during buffer writeback. */
+	__be64		agf_lsn;	/* last write sequence */
+	__be32		agf_crc;	/* crc of agf sector */
+	__be32		agf_spare2;
+
+	/* structure must be padded to 64 bit alignment */
 } xfs_agf_t;
 
 #define	XFS_AGF_MAGICNUM	0x00000001
@@ -83,6 +101,7 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
+#define	XFS_AGF_UUID		0x00001000
 #define	XFS_AGF_NUM_BITS	12
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
@@ -98,7 +117,8 @@ typedef struct xfs_agf {
 	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
 	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
 	{ XFS_AGF_LONGEST,	"LONGEST" }, \
-	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
+	{ XFS_AGF_UUID,		"UUID" }
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
@@ -132,6 +152,7 @@ typedef struct xfs_agi {
 	__be32		agi_root;	/* root of inode btree */
 	__be32		agi_level;	/* levels in inode btree */
 	__be32		agi_freecount;	/* number of free inodes */
+
 	__be32		agi_newino;	/* new inode just allocated */
 	__be32		agi_dirino;	/* last directory inode chunk */
 	/*
@@ -139,6 +160,13 @@ typedef struct xfs_agi {
 	 * still being referenced.
 	 */
 	__be32		agi_unlinked[XFS_AGI_UNLINKED_BUCKETS];
+
+	uuid_t		agi_uuid;	/* uuid of filesystem */
+	__be32		agi_crc;	/* crc of agi sector */
+	__be32		agi_pad32;
+	__be64		agi_lsn;	/* last write sequence */
+
+	/* structure must be padded to 64 bit alignment */
 } xfs_agi_t;
 
 #define	XFS_AGI_MAGICNUM	0x00000001
@@ -171,11 +199,31 @@ extern const struct xfs_buf_ops xfs_agi_buf_ops;
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
diff --git a/include/xfs_buf_item.h b/include/xfs_buf_item.h
index 101ef83..c256606 100644
--- a/include/xfs_buf_item.h
+++ b/include/xfs_buf_item.h
@@ -45,12 +45,18 @@ extern kmem_zone_t	*xfs_buf_item_zone;
  * once the changes have been replayed into the buffer.
  */
 #define XFS_BLF_BTREE_BUF	(1<<5)
+#define XFS_BLF_AGF_BUF		(1<<6)
+#define XFS_BLF_AGFL_BUF	(1<<7)
+#define XFS_BLF_AGI_BUF		(1<<8)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
 		 XFS_BLF_PDQUOT_BUF | \
 		 XFS_BLF_GDQUOT_BUF | \
-		 XFS_BLF_BTREE_BUF)
+		 XFS_BLF_BTREE_BUF | \
+		 XFS_BLF_AGF_BUF | \
+		 XFS_BLF_AGFL_BUF | \
+		 XFS_BLF_AGI_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index e59fdac..30fc5f4 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -410,53 +410,84 @@ xfs_alloc_fixup_trees(
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
@@ -1964,18 +1995,18 @@ xfs_alloc_get_freelist(
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
@@ -1983,15 +2014,17 @@ xfs_alloc_get_freelist(
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
@@ -2040,11 +2073,14 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_freeblks),
 		offsetof(xfs_agf_t, agf_longest),
 		offsetof(xfs_agf_t, agf_btreeblks),
+		offsetof(xfs_agf_t, agf_uuid),
 		sizeof(xfs_agf_t)
 	};
 
 	trace_xfs_agf(tp->t_mountp, XFS_BUF_TO_AGF(bp), fields, _RET_IP_);
 
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGF_BUF);
+
 	xfs_btree_offsets(fields, offsets, XFS_AGF_NUM_BITS, &first, &last);
 	xfs_trans_log_buf(tp, bp, (uint)first, (uint)last);
 }
@@ -2081,12 +2117,13 @@ xfs_alloc_put_freelist(
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
@@ -2094,7 +2131,6 @@ xfs_alloc_put_freelist(
 	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
-	agfl = XFS_BUF_TO_AGFL(agflbp);
 	be32_add_cpu(&agf->agf_fllast, 1);
 	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
 		agf->agf_fllast = 0;
@@ -2115,32 +2151,38 @@ xfs_alloc_put_freelist(
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
 
-static void
+static bool
 xfs_agf_verify(
+	struct xfs_mount *mp,
 	struct xfs_buf	*bp)
  {
-	struct xfs_mount *mp = bp->b_target->bt_mount;
-	struct xfs_agf	*agf;
-	int		agf_ok;
+	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
-	agf = XFS_BUF_TO_AGF(bp);
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
+			return false;
 
-	agf_ok = agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
-		XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-		be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-		be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-		be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp);
+	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
+	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
+	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
+	      be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
+	      be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
+	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
+		return false;
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -2148,33 +2190,58 @@ xfs_agf_verify(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag)
-		agf_ok = agf_ok && be32_to_cpu(agf->agf_seqno) ==
-						bp->b_pag->pag_agno;
+	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
+		return false;
 
-	if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-		agf_ok = agf_ok && be32_to_cpu(agf->agf_btreeblks) <=
-						be32_to_cpu(agf->agf_length);
+	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
+		return false;
+
+	return true;;
 
-	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
-			XFS_RANDOM_ALLOC_READ_AGF))) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agf);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
 }
 
 static void
 xfs_agf_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agf_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	int		agf_ok = 1;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		agf_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  offsetof(struct xfs_agf, agf_crc));
+
+	agf_ok = agf_ok && xfs_agf_verify(mp, bp);
+
+	if (unlikely(XFS_TEST_ERROR(!agf_ok, mp, XFS_ERRTAG_ALLOC_READ_AGF,
+			XFS_RANDOM_ALLOC_READ_AGF))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 static void
 xfs_agf_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agf_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	if (!xfs_agf_verify(mp, bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		XFS_BUF_TO_AGF(bp)->agf_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_agf, agf_crc));
 }
 
 const struct xfs_buf_ops xfs_agf_buf_ops = {
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index f0322c9..feb4a4e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1267,6 +1267,7 @@ xfs_ialloc_log_agi(
 	/*
 	 * Log the allocation group inode header buffer.
 	 */
+	xfs_trans_buf_set_type(tp, bp, XFS_BLF_AGI_BUF);
 	xfs_trans_log_buf(tp, bp, first, last);
 }
 
@@ -1284,19 +1285,23 @@ xfs_check_agi_unlinked(
 #define xfs_check_agi_unlinked(agi)
 #endif
 
-static void
+static bool
 xfs_agi_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_agi	*agi = XFS_BUF_TO_AGI(bp);
-	int		agi_ok;
 
+	if (xfs_sb_version_hascrc(&mp->m_sb) &&
+	    !uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_uuid))
+			return false;
 	/*
 	 * Validate the magic number of the agi block.
 	 */
-	agi_ok = agi->agi_magicnum == cpu_to_be32(XFS_AGI_MAGIC) &&
-		XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum));
+	if (agi->agi_magicnum != cpu_to_be32(XFS_AGI_MAGIC))
+		return false;
+	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
+		return false;
 
 	/*
 	 * during growfs operations, the perag is not fully initialised,
@@ -1304,30 +1309,52 @@ xfs_agi_verify(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag)
-		agi_ok = agi_ok && be32_to_cpu(agi->agi_seqno) ==
-						bp->b_pag->pag_agno;
+	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
+		return false;
 
-	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
-			XFS_RANDOM_IALLOC_READ_AGI))) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, agi);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
 	xfs_check_agi_unlinked(agi);
+	return true;
 }
 
 static void
 xfs_agi_read_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agi_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	int		agi_ok = 1;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		agi_ok = xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
+					  offsetof(struct xfs_agi, agi_crc));
+	agi_ok = agi_ok && xfs_agi_verify(bp);
+
+	if (unlikely(XFS_TEST_ERROR(!agi_ok, mp, XFS_ERRTAG_IALLOC_READ_AGI,
+			XFS_RANDOM_IALLOC_READ_AGI))) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+	}
 }
 
 static void
 xfs_agi_write_verify(
 	struct xfs_buf	*bp)
 {
-	xfs_agi_verify(bp);
+	struct xfs_mount *mp = bp->b_target->bt_mount;
+	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+
+	if (!xfs_agi_verify(bp)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+		xfs_buf_ioerror(bp, EFSCORRUPTED);
+		return;
+	}
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return;
+
+	if (bip)
+		XFS_BUF_TO_AGI(bp)->agi_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
+			 offsetof(struct xfs_agi, agi_crc));
 }
 
 const struct xfs_buf_ops xfs_agi_buf_ops = {
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
