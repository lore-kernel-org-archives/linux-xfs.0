Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935594AbeF1Qgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 242D24075741
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E0B1111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:38 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 12/24] xfs: remove xfs_bmapi_write() dfops param
Date: Thu, 28 Jun 2018 12:36:24 -0400
Message-Id: <20180628163636.52564-13-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that all callers use ->t_dfops, the xfs_bmapi_write() dfops
parameter is no longer necessary. Remove it and access ->t_dfops
directly. This patch does not change behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c |  3 +--
 fs/xfs/libxfs/xfs_bmap.c        | 10 +++++-----
 fs/xfs/libxfs/xfs_bmap.h        |  3 +--
 fs/xfs/libxfs/xfs_da_btree.c    |  6 ++----
 fs/xfs/xfs_bmap_util.c          |  2 +-
 fs/xfs/xfs_dquot.c              |  2 +-
 fs/xfs/xfs_iomap.c              |  7 +++----
 fs/xfs/xfs_reflink.c            |  8 ++++----
 fs/xfs/xfs_rtalloc.c            |  2 +-
 fs/xfs/xfs_symlink.c            |  2 +-
 10 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 577c4c372265..1f2bc86a28ed 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -484,8 +484,7 @@ xfs_attr_rmtval_set(
 		nmap = 1;
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
 				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
-				  args->total, &map, &nmap,
-				  args->trans->t_dfops);
+				  args->total, &map, &nmap);
 		if (error)
 			goto out_defer_cancel;
 		xfs_defer_ijoin(args->trans->t_dfops, dp);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 93dbcf678e54..eabf9a151d6d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4246,8 +4246,7 @@ xfs_bmapi_write(
 						   controls a.g. for allocs */
 	xfs_extlen_t		total,		/* total blocks needed */
 	struct xfs_bmbt_irec	*mval,		/* output: map values */
-	int			*nmap,		/* i/o: mval size/count */
-	struct xfs_defer_ops	*dfops)		/* i/o: list extents to free */
+	int			*nmap)		/* i/o: mval size/count */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
@@ -4339,7 +4338,7 @@ xfs_bmapi_write(
 	bma.ip = ip;
 	bma.total = total;
 	bma.datatype = 0;
-	bma.dfops = dfops;
+	bma.dfops = tp ? tp->t_dfops : NULL;
 	bma.firstblock = firstblock;
 
 	while (bno < end && n < *nmap) {
@@ -4416,8 +4415,9 @@ xfs_bmapi_write(
 			 * the refcount btree for orphan recovery.
 			 */
 			if (whichfork == XFS_COW_FORK) {
-				error = xfs_refcount_alloc_cow_extent(mp, dfops,
-						bma.blkno, bma.length);
+				error = xfs_refcount_alloc_cow_extent(mp,
+						tp->t_dfops, bma.blkno,
+						bma.length);
 				if (error)
 					goto error0;
 			}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 9b49ddf99c41..4bd7eeebb6d9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -206,8 +206,7 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, int flags,
 		xfs_fsblock_t *firstblock, xfs_extlen_t total,
-		struct xfs_bmbt_irec *mval, int *nmap,
-		struct xfs_defer_ops *dfops);
+		struct xfs_bmbt_irec *mval, int *nmap);
 int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t *rlen, int flags,
 		xfs_extnum_t nexts, xfs_fsblock_t *firstblock,
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index d2048e4e93ec..e43f1dda02e4 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2062,8 +2062,7 @@ xfs_da_grow_inode_int(
 	ASSERT(args->firstblock != NULL);
 	error = xfs_bmapi_write(tp, dp, *bno, count,
 			xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA|XFS_BMAPI_CONTIG,
-			args->firstblock, args->total, &map, &nmap,
-			args->trans->t_dfops);
+			args->firstblock, args->total, &map, &nmap);
 	if (error)
 		return error;
 
@@ -2086,8 +2085,7 @@ xfs_da_grow_inode_int(
 			error = xfs_bmapi_write(tp, dp, b, c,
 					xfs_bmapi_aflag(w)|XFS_BMAPI_METADATA,
 					args->firstblock, args->total,
-					&mapp[mapi], &nmap,
-					args->trans->t_dfops);
+					&mapp[mapi], &nmap);
 			if (error)
 				goto out_free_map;
 			if (nmap < 1)
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e6036f56241c..c40cb711447f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -975,7 +975,7 @@ xfs_alloc_file_space(
 		tp->t_dfops = &dfops;
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 					allocatesize_fsb, alloc_type, &firstfsb,
-					resblks, imapp, &nimaps, tp->t_dfops);
+					resblks, imapp, &nimaps);
 		if (error)
 			goto error0;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index aa62f8b17376..1ef38e1df679 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -313,7 +313,7 @@ xfs_dquot_disk_alloc(
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
 			&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
-			&map, &nmaps, tp->t_dfops);
+			&map, &nmaps);
 	if (error)
 		goto error0;
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8e1f3b451ee4..1b3177ee6896 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -259,7 +259,7 @@ xfs_iomap_write_direct(
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 				bmapi_flags, &firstfsb, resblks, imap,
-				&nimaps, tp->t_dfops);
+				&nimaps);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -773,8 +773,7 @@ xfs_iomap_write_allocate(
 			 */
 			error = xfs_bmapi_write(tp, ip, map_start_fsb,
 						count_fsb, flags, &first_block,
-						nres, imap, &nimaps,
-						tp->t_dfops);
+						nres, imap, &nimaps);
 			if (error)
 				goto trans_cancel;
 
@@ -884,7 +883,7 @@ xfs_iomap_write_unwritten(
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
 					XFS_BMAPI_CONVERT, &firstfsb, resblks,
-					&imap, &nimaps, tp->t_dfops);
+					&imap, &nimaps);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1ff9ef1d65ba..3b2b8f5851c0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -326,7 +326,7 @@ xfs_reflink_convert_cow_extent(
 		return 0;
 	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, &first_block,
-			0, imap, &nimaps, NULL);
+			0, imap, &nimaps);
 }
 
 /* Convert all of the unwritten CoW extents in a file's range to real ones. */
@@ -349,8 +349,8 @@ xfs_reflink_convert_cow(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
-			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap, &nimaps,
-			NULL);
+			XFS_BMAPI_CONVERT_ONLY, &first_block, 0, &imap,
+			&nimaps);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -435,7 +435,7 @@ xfs_reflink_allocate_cow(
 	/* Allocate the entire reservation as unwritten blocks. */
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
-			resblks, imap, &nimaps, tp->t_dfops);
+			resblks, imap, &nimaps);
 	if (error)
 		goto out_bmap_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 312d410d91fb..1c7d1238ff3b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -795,7 +795,7 @@ xfs_growfs_rt_alloc(
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
 					XFS_BMAPI_METADATA, &firstblock,
-					resblks, &map, &nmap, tp->t_dfops);
+					resblks, &map, &nmap);
 		if (!error && nmap < 1)
 			error = -ENOSPC;
 		if (error)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 6825a31727d1..2b6bcfd39c14 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -291,7 +291,7 @@ xfs_symlink(
 
 		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
 				  XFS_BMAPI_METADATA, &first_block, resblks,
-				  mval, &nmaps, tp->t_dfops);
+				  mval, &nmaps);
 		if (error)
 			goto out_bmap_cancel;
 
-- 
2.17.1

