Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A4817FA4
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:11:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09C30304082
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:11:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	am9pR5UQgEMB5bu8 for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:11:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFz2-0000LM-5h
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:40 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFyx-0005Aw-1C
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/22] xfs: add CRC checks to the AGF
Date: Wed,  3 Apr 2013 16:11:13 +1100
Message-Id: <1364965892-19623-4-git-send-email-david@fromorbit.com>
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

The AGF already has some self identifying fields (e.g. the sequence
number) so we only need to add the uuid to it to identify the
filesystem it belongs to. The location is fixed based on the
sequence number, so there's no need to add a block number, either.

Hence the only additional fields are the CRC and LSN fields. These
are unlogged, so place some space between the end of the logged
fields and them so that future expansion of the AGF for logged
fields can be placed adjacent to the existing logged fields and
hence not complicate the field-derived range based logging we
currently have.

Based originally on a patch from myself, modified further by
Christoph Hellwig and then modified again to fit into the
verifier structure with additional fields by myself. The multiple
signed-off-by tags indicate the age and history of this patch.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ag.h          |   23 +++++++++++--
 fs/xfs/xfs_alloc.c       |   80 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_buf_item.h    |    4 ++-
 fs/xfs/xfs_fsops.c       |    3 ++
 fs/xfs/xfs_log_recover.c |    8 +++++
 5 files changed, 91 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
index f2aeedb..9f4815e 100644
--- a/fs/xfs/xfs_ag.h
+++ b/fs/xfs/xfs_ag.h
@@ -63,12 +63,29 @@ typedef struct xfs_agf {
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
@@ -83,7 +100,8 @@ typedef struct xfs_agf {
 #define	XFS_AGF_FREEBLKS	0x00000200
 #define	XFS_AGF_LONGEST		0x00000400
 #define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_NUM_BITS	12
+#define	XFS_AGF_UUID		0x00001000
+#define	XFS_AGF_NUM_BITS	13
 #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
@@ -98,7 +116,8 @@ typedef struct xfs_agf {
 	{ XFS_AGF_FLCOUNT,	"FLCOUNT" }, \
 	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
 	{ XFS_AGF_LONGEST,	"LONGEST" }, \
-	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }
+	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
+	{ XFS_AGF_UUID,		"UUID" }
 
 /* disk block (xfs_daddr_t) in the AG */
 #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index a8beb5c..c34f799 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -33,7 +33,9 @@
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_error.h"
+#include "xfs_cksum.h"
 #include "xfs_trace.h"
+#include "xfs_buf_item.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -2058,11 +2060,14 @@ xfs_alloc_log_agf(
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
@@ -2143,22 +2148,24 @@ xfs_alloc_put_freelist(
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
@@ -2166,33 +2173,58 @@ xfs_agf_verify(
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
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 101ef83..76bd7a1 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -45,12 +45,14 @@ extern kmem_zone_t	*xfs_buf_item_zone;
  * once the changes have been replayed into the buffer.
  */
 #define XFS_BLF_BTREE_BUF	(1<<5)
+#define XFS_BLF_AGF_BUF		(1<<6)
 
 #define XFS_BLF_TYPE_MASK	\
 		(XFS_BLF_UDQUOT_BUF | \
 		 XFS_BLF_PDQUOT_BUF | \
 		 XFS_BLF_GDQUOT_BUF | \
-		 XFS_BLF_BTREE_BUF)
+		 XFS_BLF_BTREE_BUF | \
+		 XFS_BLF_AGF_BUF)
 
 #define	XFS_BLF_CHUNK		128
 #define	XFS_BLF_SHIFT		7
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6fe286a..b6cca27 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -247,6 +247,9 @@ xfs_growfs_data_private(
 		tmpsize = agsize - XFS_PREALLOC_BLOCKS(mp);
 		agf->agf_freeblks = cpu_to_be32(tmpsize);
 		agf->agf_longest = cpu_to_be32(tmpsize);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
 		if (error)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3762ce2..dadf245 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1953,6 +1953,14 @@ xlog_recover_do_reg_buffer(
 			break;
 		}
 		break;
+	case XFS_BLF_AGF_BUF:
+		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_AGF_MAGIC)) {
+			xfs_warn(mp, "Bad AGF block magic!");
+			ASSERT(0);
+			break;
+		}
+		bp->b_ops = &xfs_agf_buf_ops;
+		break;
 	default:
 		break;
 	}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
