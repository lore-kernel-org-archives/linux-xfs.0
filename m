Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B9027CB5
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 21:28:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2100AC003
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2016 19:28:04 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gDyq995Yd5OuhOI7 for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2016 19:28:02 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: use per-ag AGFL indexes everywhere
Date: Fri,  2 Sep 2016 12:27:37 +1000
Message-Id: <1472783257-15941-7-git-send-email-david@fromorbit.com>
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

Now we have the AGFL indexes in the struct xfs_perag, use them
everywhere rather than having to decode them directly from the AGF
buffer. This essentially makes the values in the perag the primary
in-memory copy of the free list state, so we operate on that first
then copy them to the on-disk structure just before logging them.

This removes a lot of endian conversions that are done to manipulate
the on-disk structures, making the frequently called
xfs_alloc_get/put_freelist() substantially more compact and faster.

text	   data	    bss	    dec	    hex	filename
 835459	 157358	   1008	 993825	  f2a21	fs/xfs/xfs.o.old
 835299	 157358	   1008	 993665	  f2981	fs/xfs/xfs.o.new

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 135 ++++++++++++++++++++++------------------------
 1 file changed, 64 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 8deb736..554f033 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2220,66 +2220,62 @@ out_no_agbp:
  * Get a block from the freelist.
  * Returns with the buffer for the block gotten.
  */
-int				/* error */
+int
 xfs_alloc_get_freelist(
-	xfs_trans_t	*tp,	/* transaction pointer */
-	xfs_buf_t	*agbp,	/* buffer containing the agf structure */
-	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
+	struct xfs_trans *tp,
+	struct xfs_buf	*agbp,
+	xfs_agblock_t	*bnop,
 	int		btreeblk) /* destination is a AGF btree */
 {
-	xfs_agf_t	*agf;	/* a.g. freespace structure */
-	xfs_buf_t	*agflbp;/* buffer for a.g. freelist structure */
-	xfs_agblock_t	bno;	/* block number returned */
+	struct xfs_mount *mp = tp->t_mountp;
+	struct xfs_agf	*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_buf	*agflbp;
+	struct xfs_perag *pag;
+	xfs_agnumber_t	agno = be32_to_cpu(agf->agf_seqno);
+	xfs_agblock_t	bno = NULLAGBLOCK;
 	__be32		*agfl_bno;
 	int		error;
 	int		logflags;
-	xfs_mount_t	*mp = tp->t_mountp;
-	xfs_perag_t	*pag;	/* per allocation group data */
 
-	/*
-	 * Freelist is empty, give up.
-	 */
-	agf = XFS_BUF_TO_AGF(agbp);
-	if (!agf->agf_flcount) {
-		*bnop = NULLAGBLOCK;
-		return 0;
-	}
+	/* Freelist is empty, give up. */
+	pag = xfs_perag_get(mp, agno);
+	if (!pag->pagf_flcount)
+		goto out_put_perag;
+
 	/*
 	 * Read the array of free blocks.
 	 */
-	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
-				    &agflbp);
+	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
 	if (error)
 		return error;
 
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
 
 	/*
 	 * Get the block number and update the data structures.
 	 */
-	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
-	bno = be32_to_cpu(agfl_bno[be32_to_cpu(agf->agf_flfirst)]);
-	be32_add_cpu(&agf->agf_flfirst, 1);
-	xfs_trans_brelse(tp, agflbp);
-	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
-		agf->agf_flfirst = 0;
-
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
-	be32_add_cpu(&agf->agf_flcount, -1);
-	xfs_trans_agflist_delta(tp, -1);
+	bno = be32_to_cpu(agfl_bno[pag->pagf_flfirst]);
+	if (++pag->pagf_flfirst == xfs_agfl_size(mp))
+		pag->pagf_flfirst = 0;
 	pag->pagf_flcount--;
-	pag->pagf_flfirst = be32_to_cpu(agf->agf_flfirst);
-	xfs_perag_put(pag);
+	xfs_trans_agflist_delta(tp, -1);
 
-	logflags = XFS_AGF_FLFIRST | XFS_AGF_FLCOUNT;
 	if (btreeblk) {
-		be32_add_cpu(&agf->agf_btreeblks, 1);
 		pag->pagf_btreeblks++;
+		agf->agf_btreeblks = cpu_to_be32(pag->pagf_btreeblks);
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
 
+	agf->agf_flfirst = cpu_to_be32(pag->pagf_flfirst);
+	agf->agf_flcount = cpu_to_be32(pag->pagf_flcount);
+
+	xfs_trans_brelse(tp, agflbp);
 	xfs_alloc_log_agf(tp, agbp, logflags);
-	*bnop = bno;
 
+out_put_perag:
+	xfs_perag_put(pag);
+	*bnop = bno;
 	return 0;
 }
 
@@ -2345,53 +2341,51 @@ xfs_alloc_pagf_init(
 /*
  * Put the block on the freelist for the allocation group.
  */
-int					/* error */
+int
 xfs_alloc_put_freelist(
-	xfs_trans_t		*tp,	/* transaction pointer */
-	xfs_buf_t		*agbp,	/* buffer for a.g. freelist header */
-	xfs_buf_t		*agflbp,/* buffer for a.g. free block array */
-	xfs_agblock_t		bno,	/* block being freed */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	struct xfs_buf		*agflbp,
+	xfs_agblock_t		bno,
 	int			btreeblk) /* block came from a AGF btree */
 {
-	xfs_agf_t		*agf;	/* a.g. freespace structure */
-	__be32			*blockp;/* pointer to array entry */
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno = be32_to_cpu(agf->agf_seqno);
+	__be32			*agfl_bno;
+	__be32			*blockp;
 	int			error;
 	int			logflags;
-	xfs_mount_t		*mp;	/* mount structure */
-	xfs_perag_t		*pag;	/* per allocation group data */
-	__be32			*agfl_bno;
 	int			startoff;
 
-	agf = XFS_BUF_TO_AGF(agbp);
-	mp = tp->t_mountp;
+	if (!agflbp) {
+		error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
+		if (error)
+			return error;
+	}
 
-	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
-			be32_to_cpu(agf->agf_seqno), &agflbp)))
-		return error;
-	be32_add_cpu(&agf->agf_fllast, 1);
-	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
-		agf->agf_fllast = 0;
+	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
-	be32_add_cpu(&agf->agf_flcount, 1);
-	xfs_trans_agflist_delta(tp, 1);
+	pag = xfs_perag_get(mp, agno);
 	pag->pagf_flcount++;
-	pag->pagf_fllast = be32_to_cpu(agf->agf_fllast);
+	ASSERT(pag->pagf_flcount <= xfs_agfl_size(mp));
 
-	logflags = XFS_AGF_FLLAST | XFS_AGF_FLCOUNT;
+	if (++pag->pagf_fllast == xfs_agfl_size(mp))
+		pag->pagf_fllast = 0;
+	xfs_trans_agflist_delta(tp, 1);
 	if (btreeblk) {
-		be32_add_cpu(&agf->agf_btreeblks, -1);
 		pag->pagf_btreeblks--;
+		agf->agf_btreeblks = cpu_to_be32(pag->pagf_btreeblks);
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
-	xfs_perag_put(pag);
 
-	xfs_alloc_log_agf(tp, agbp, logflags);
+	agf->agf_fllast = cpu_to_be32(pag->pagf_fllast);
+	agf->agf_flcount = cpu_to_be32(pag->pagf_flcount);
 
-	ASSERT(be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp));
 
 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
-	blockp = &agfl_bno[be32_to_cpu(agf->agf_fllast)];
+	blockp = &agfl_bno[pag->pagf_fllast];
 	*blockp = cpu_to_be32(bno);
 	startoff = (char *)blockp - (char *)agflbp->b_addr;
 
@@ -2400,6 +2394,7 @@ xfs_alloc_put_freelist(
 	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(tp, agflbp, startoff,
 			  startoff + sizeof(xfs_agblock_t) - 1);
+	xfs_perag_put(pag);
 	return 0;
 }
 
@@ -2612,18 +2607,14 @@ xfs_agf_fixup_freelist_count(
 			   pag->pag_agno);
 		if (pag->pagf_flcount) {
 			pag->pagf_flcount--;
-			be32_add_cpu(&agf->agf_flcount, -1);
-			be32_add_cpu(&agf->agf_fllast, -1);
 			pag->pagf_fllast--;
 		} else {
 			/* empty free list, move the both pointers back one */
 			ASSERT(pag->pagf_flfirst == pag->pagf_fllast);
-			be32_add_cpu(&agf->agf_fllast, -1);
-			be32_add_cpu(&agf->agf_flfirst, -1);
 			pag->pagf_flfirst--;
 			pag->pagf_fllast--;
 		}
-		return;
+		goto out_update_agf;
 	}
 
 	/* if first is invalid, wrap it, reset count and return */
@@ -2633,10 +2624,8 @@ xfs_agf_fixup_freelist_count(
 		ASSERT(pag->pagf_flfirst != pag->pagf_fllast);
 		ASSERT(pag->pagf_flcount);
 		pag->pagf_flcount = pag->pagf_fllast + 1;
-		agf->agf_flcount = cpu_to_be32(pag->pagf_flcount);
-		agf->agf_flfirst = 0;
 		pag->pagf_flfirst = 0;
-		return;
+		goto out_update_agf;
 	}
 
 	/*
@@ -2662,7 +2651,11 @@ xfs_agf_fixup_freelist_count(
 	xfs_notice(mp, "AGF %d: wrapped count fixup being performed",
 		   pag->pag_agno);
 	pag->pagf_flcount--;
-	be32_add_cpu(&agf->agf_flcount, -1);
+
+out_update_agf:
+	agf->agf_flfirst = cpu_to_be32(pag->pagf_flfirst);
+	agf->agf_fllast = cpu_to_be32(pag->pagf_fllast);
+	agf->agf_flcount = cpu_to_be32(pag->pagf_flcount);
 }
 
 /*
-- 
2.8.0.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
