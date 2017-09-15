Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50895 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdIOOy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 10:54:28 -0400
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dss0i-0003IT-5m
        for linux-xfs@vger.kernel.org; Fri, 15 Sep 2017 14:54:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/18] xfs: refactor xfs_del_extent_real
Date: Fri, 15 Sep 2017 07:54:17 -0700
Message-Id: <20170915145426.26194-10-hch@lst.de>
In-Reply-To: <20170915145426.26194-1-hch@lst.de>
References: <20170915145426.26194-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Use xfs_iext_update_extent to update entries in the in-core extent list.
This isolates the function from the detailed layout of the extent list,
and generally makes the code a lot more readable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 60 ++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 037efc97499f..bd00f4d135af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5078,10 +5078,9 @@ xfs_bmap_del_extent_real(
 	xfs_fsblock_t		del_endblock=0;	/* first block past del */
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			do_fx;	/* free extent at end of routine */
-	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
 	int			error;	/* error return value */
 	int			flags = 0;/* inode logging flags */
-	xfs_bmbt_irec_t		got;	/* current extent entry */
+	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
@@ -5090,9 +5089,8 @@ xfs_bmap_del_extent_real(
 	xfs_bmbt_irec_t		new;	/* new record to be inserted */
 	/* REFERENCED */
 	uint			qfield;	/* quota field to update */
-	xfs_filblks_t		temp;	/* for indirect length calculations */
-	xfs_filblks_t		temp2;	/* for indirect length calculations */
 	int			state = 0;
+	struct xfs_bmbt_irec	old;
 
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
@@ -5105,8 +5103,7 @@ xfs_bmap_del_extent_real(
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	ASSERT((*idx >= 0) && (*idx < xfs_iext_count(ifp)));
 	ASSERT(del->br_blockcount > 0);
-	ep = xfs_iext_get_ext(ifp, *idx);
-	xfs_bmbt_get_all(ep, &got);
+	xfs_iext_get_extent(ifp, *idx, &got);
 	ASSERT(got.br_startoff <= del->br_startoff);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got.br_startoff + got.br_blockcount;
@@ -5193,54 +5190,56 @@ xfs_bmap_del_extent_real(
 		 * Deleting the first part of the extent.
 		 */
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_startoff(ep, del_endoff);
-		temp = got.br_blockcount - del->br_blockcount;
-		xfs_bmbt_set_blockcount(ep, temp);
-		xfs_bmbt_set_startblock(ep, del_endblock);
+		got.br_startoff = del_endoff;
+		got.br_startblock = del_endblock;
+		got.br_blockcount -= del->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &got);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
-		if ((error = xfs_bmbt_update(cur, del_endoff, del_endblock,
-				got.br_blockcount - del->br_blockcount,
-				got.br_state)))
+		error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
+				got.br_blockcount, got.br_state);
+		if (error)
 			goto done;
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
 		 * Deleting the last part of the extent.
 		 */
-		temp = got.br_blockcount - del->br_blockcount;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep, temp);
+		got.br_blockcount -= del->br_blockcount;
+		xfs_iext_update_extent(ifp, *idx, &got);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
 		}
-		if ((error = xfs_bmbt_update(cur, got.br_startoff,
-				got.br_startblock,
-				got.br_blockcount - del->br_blockcount,
-				got.br_state)))
+		error = xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
+				got.br_blockcount, got.br_state);
+		if (error)
 			goto done;
 		break;
 	case 0:
 		/*
 		 * Deleting the middle of the extent.
 		 */
-		temp = del->br_startoff - got.br_startoff;
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_blockcount(ep, temp);
+
+		old = got;
+		got.br_blockcount = del->br_startoff - got.br_startoff;
+		xfs_iext_update_extent(ifp, *idx, &got);
+
 		new.br_startoff = del_endoff;
-		temp2 = got_endoff - del_endoff;
-		new.br_blockcount = temp2;
+		new.br_blockcount = got_endoff - del_endoff;
 		new.br_state = got.br_state;
 		new.br_startblock = del_endblock;
+
 		flags |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, got.br_startoff,
-					got.br_startblock, temp,
+					got.br_startblock, got.br_blockcount,
 					got.br_state);
 			if (error)
 				goto done;
@@ -5262,7 +5261,8 @@ xfs_bmap_del_extent_real(
 				 * insert operation.
 				 */
 				error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-						got.br_startblock, temp, &i);
+						got.br_startblock,
+						got.br_blockcount, &i);
 				if (error)
 					goto done;
 				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
@@ -5270,17 +5270,17 @@ xfs_bmap_del_extent_real(
 				 * Update the btree record back
 				 * to the original value.
 				 */
-				error = xfs_bmbt_update(cur, got.br_startoff,
-						got.br_startblock,
-						got.br_blockcount,
-						got.br_state);
+				error = xfs_bmbt_update(cur, old.br_startoff,
+						old.br_startblock,
+						old.br_blockcount,
+						old.br_state);
 				if (error)
 					goto done;
 				/*
 				 * Reset the extent record back
 				 * to the original value.
 				 */
-				xfs_bmbt_set_blockcount(ep, got.br_blockcount);
+				xfs_iext_update_extent(ifp, *idx, &old);
 				flags = 0;
 				error = -ENOSPC;
 				goto done;
-- 
2.14.1

