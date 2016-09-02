Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F74B7CA7
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:28:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 928C3AC005
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:28:03 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0ZS3MqGxfHEmMeQL for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:28:01 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: clean up XFS_AGFL_SIZE
Date: Fri,  2 Sep 2016 12:27:32 +1000
Message-Id: <1472783257-15941-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1472783257-15941-1-git-send-email-david@fromorbit.com>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
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
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The AGFL size calculation is about to get more complex, so lets turn
the macro into a function first and remove the macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  | 33 ++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_alloc.h  |  2 ++
 fs/xfs/libxfs/xfs_format.h | 13 +------------
 fs/xfs/xfs_fsops.c         |  2 +-
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 05b5243..23559b9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -63,6 +63,24 @@ xfs_prealloc_blocks(
 }
 
 /*
+ * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
+ * the beginning of the block for a proper header with the location information
+ * and CRC.
+ */
+int
+xfs_agfl_size(
+	struct xfs_mount	*mp)
+
+{
+	int			size = mp->m_sb.sb_sectsize;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return size / sizeof(xfs_agblock_t);
+
+	return (size - sizeof(struct xfs_agfl)) / sizeof(xfs_agblock_t);
+}
+
+/*
  * In order to avoid ENOSPC-related deadlock caused by out-of-order locking of
  * AGF buffer (PV 947395), we place constraints on the relationship among
  * actual allocations for data blocks, freelist blocks, and potential file data
@@ -554,7 +572,7 @@ xfs_agfl_verify(
 	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
 		return false;
 
-	for (i = 0; i < XFS_AGFL_SIZE(mp); i++) {
+	for (i = 0; i < xfs_agfl_size(mp); i++) {
 		if (be32_to_cpu(agfl->agfl_bno[i]) != NULLAGBLOCK &&
 		    be32_to_cpu(agfl->agfl_bno[i]) >= mp->m_sb.sb_agblocks)
 			return false;
@@ -2230,7 +2248,7 @@ xfs_alloc_get_freelist(
 	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
 	be32_add_cpu(&agf->agf_flfirst, 1);
 	xfs_trans_brelse(tp, agflbp);
-	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
+	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
 	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
@@ -2338,7 +2356,7 @@ xfs_alloc_put_freelist(
 			be32_to_cpu(agf->agf_seqno), &agflbp)))
 		return error;
 	be32_add_cpu(&agf->agf_fllast, 1);
-	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
+	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
 
 	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
@@ -2356,7 +2374,7 @@ xfs_alloc_put_freelist(
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
-	ASSERT(be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp));
+	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
 	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
@@ -2377,6 +2395,7 @@ xfs_agf_verify(
 	struct xfs_buf	*bp)
  {
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
+	int32_t		agfl_size = xfs_agfl_size(mp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2389,9 +2408,9 @@ xfs_agf_verify(
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
 	      be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
-	      be32_to_cpu(agf->agf_flfirst) < XFS_AGFL_SIZE(mp) &&
-	      be32_to_cpu(agf->agf_fllast) < XFS_AGFL_SIZE(mp) &&
-	      be32_to_cpu(agf->agf_flcount) <= XFS_AGFL_SIZE(mp)))
+	      be32_to_cpu(agf->agf_flfirst) < agfl_size &&
+	      be32_to_cpu(agf->agf_fllast) < agfl_size &&
+	      be32_to_cpu(agf->agf_flcount) <= agfl_size))
 		return false;
 
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6fe2d6b..cfdd02f 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -202,6 +202,8 @@ xfs_alloc_get_rec(
 
 int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
 			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_agfl_size(struct xfs_mount *mp);
+
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 		struct xfs_buf **agbp);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 270fb5c..60085f3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -781,24 +781,13 @@ typedef struct xfs_agi {
 		&(XFS_BUF_TO_AGFL(bp)->agfl_bno[0]) : \
 		(__be32 *)(bp)->b_addr)
 
-/*
- * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of
- * slots in the beginning of the block for a proper header with the
- * location information and CRC.
- */
-#define XFS_AGFL_SIZE(mp) \
-	(((mp)->m_sb.sb_sectsize - \
-	 (xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
-		sizeof(struct xfs_agfl) : 0)) / \
-	  sizeof(xfs_agblock_t))
-
 typedef struct xfs_agfl {
 	__be32		agfl_magicnum;
 	__be32		agfl_seqno;
 	uuid_t		agfl_uuid;
 	__be64		agfl_lsn;
 	__be32		agfl_crc;
-	__be32		agfl_bno[];	/* actually XFS_AGFL_SIZE(mp) */
+	__be32		agfl_bno[];	/* actually xfs_agfl_size(mp) */
 } __attribute__((packed)) xfs_agfl_t;
 
 #define XFS_AGFL_CRC_OFF	offsetof(struct xfs_agfl, agfl_crc)
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 0b7f986..622ca71 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -285,7 +285,7 @@ xfs_growfs_data_private(
 		}
 
 		agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, bp);
-		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
+		for (bucket = 0; bucket < xfs_agfl_size(mp); bucket++)
 			agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 
 		error = xfs_bwrite(bp);
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
