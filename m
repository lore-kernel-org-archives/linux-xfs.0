Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35170 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbeHAU5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 16:57:43 -0400
Date: Wed, 1 Aug 2018 12:10:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 13/15] xfs: pass transaction to xfs_defer_add()
Message-ID: <20180801191025.GI30972@magnolia>
References: <20180801131952.60250-1-bfoster@redhat.com>
 <20180801131952.60250-14-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801131952.60250-14-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 01, 2018 at 09:19:50AM -0400, Brian Foster wrote:
> The majority of remaining references to struct xfs_defer_ops in XFS
> are associated with xfs_defer_add(). At this point, there are no
> more external xfs_defer_ops users left. All instances of
> xfs_defer_ops are embedded in the transaction, which means we can
> safely pass the transaction down to the dfops add interface.
> 
> Update xfs_defer_add() to receive the transaction as a parameter.
> Various subsystems implement wrappers to allocate and construct the
> context specific data structures for the associated deferred
> operation type. Update these to also carry the transaction down as
> needed and clean up unused dfops parameters along the way.
> 
> This removes most of the remaining references to struct
> xfs_defer_ops throughout the code and facilitates removal of the
> structure.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

FWIW I've made the following edits to this patch to get rid of the
compiler warnings in xfsprogs and with CONFIG_FTRACE=n because our
tracepoints don't do anything with the *mp local variable.  There aren't
any functional changes.

--D

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f5f1fc47923e..c9fec0443f38 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -539,11 +539,11 @@ __xfs_bmap_add_free(
 	struct xfs_owner_info		*oinfo,
 	bool				skip_discard)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent_free_item	*new;		/* new element */
 #ifdef DEBUG
-	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
+	struct xfs_mount		*mp = tp->t_mountp;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
 
 	ASSERT(bno != NULLFSBLOCK);
 	ASSERT(len > 0);
@@ -566,8 +566,9 @@ __xfs_bmap_add_free(
 	else
 		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
 	new->xefi_skip_discard = skip_discard;
-	trace_xfs_bmap_free_defer(mp, XFS_FSB_TO_AGNO(mp, bno), 0,
-			XFS_FSB_TO_AGBNO(mp, bno), len);
+	trace_xfs_bmap_free_defer(tp->t_mountp,
+			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
+			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
 }
 
@@ -5980,13 +5981,12 @@ __xfs_bmap_add(
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_bmap_intent		*bi;
 
-	trace_xfs_bmap_defer(mp,
-			XFS_FSB_TO_AGNO(mp, bmap->br_startblock),
+	trace_xfs_bmap_defer(tp->t_mountp,
+			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
 			type,
-			XFS_FSB_TO_AGBNO(mp, bmap->br_startblock),
+			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
 			ip->i_ino, whichfork,
 			bmap->br_startoff,
 			bmap->br_blockcount,
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index c713c49200d3..542aa1475b5f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1183,11 +1183,11 @@ __xfs_refcount_add(
 	xfs_fsblock_t			startblock,
 	xfs_extlen_t			blockcount)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_refcount_intent	*ri;
 
-	trace_xfs_refcount_defer(mp, XFS_FSB_TO_AGNO(mp, startblock),
-			type, XFS_FSB_TO_AGBNO(mp, startblock),
+	trace_xfs_refcount_defer(tp->t_mountp,
+			XFS_FSB_TO_AGNO(tp->t_mountp, startblock),
+			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
 			blockcount);
 
 	ri = kmem_alloc(sizeof(struct xfs_refcount_intent),
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index aa683eda6b70..245af452840e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2283,12 +2283,12 @@ __xfs_rmap_add(
 	int				whichfork,
 	struct xfs_bmbt_irec		*bmap)
 {
-	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rmap_intent		*ri;
 
-	trace_xfs_rmap_defer(mp, XFS_FSB_TO_AGNO(mp, bmap->br_startblock),
+	trace_xfs_rmap_defer(tp->t_mountp,
+			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
 			type,
-			XFS_FSB_TO_AGBNO(mp, bmap->br_startblock),
+			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
 			owner, whichfork,
 			bmap->br_startoff,
 			bmap->br_blockcount,
