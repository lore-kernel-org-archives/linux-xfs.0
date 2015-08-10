Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEA8F7F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 629CAAC009
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cvM1zSWjzgSp3vX7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 8DA28461EA
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1pAr002512
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 13/13] xfs: add missing bmap cancel calls in error paths
Date: Mon, 10 Aug 2015 15:01:49 -0400
Message-Id: <1439233309-19959-14-git-send-email-bfoster@redhat.com>
In-Reply-To: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
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

If a failure occurs after the bmap free list is populated and before
xfs_bmap_finish() completes successfully (which returns a partial list
on failure), the bmap free list must be cancelled. Otherwise, the extent
items on the list are never freed and a memory leak occurs.

Several random error paths throughout the code suffer this problem. Fix
these up such that xfs_bmap_cancel() is always called on error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  1 +
 fs/xfs/xfs_bmap_util.c   | 10 +++++----
 fs/xfs/xfs_inode.c       |  9 ++++----
 fs/xfs/xfs_rtalloc.c     | 57 ++++++++++++++++++++++++------------------------
 4 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 63e05b6..8e2010d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5945,6 +5945,7 @@ xfs_bmap_split_extent(
 	return xfs_trans_commit(tp);
 
 out:
+	xfs_bmap_cancel(&free_list);
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73aab0d..3bf4ad0 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1474,7 +1474,7 @@ xfs_shift_file_space(
 				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0,
 				XFS_QMOPT_RES_REGBLKS);
 		if (error)
-			goto out;
+			goto out_trans_cancel;
 
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
@@ -1488,18 +1488,20 @@ xfs_shift_file_space(
 				&done, stop_fsb, &first_block, &free_list,
 				direction, XFS_BMAP_MAX_SHIFT_EXTENTS);
 		if (error)
-			goto out;
+			goto out_bmap_cancel;
 
 		error = xfs_bmap_finish(&tp, &free_list, &committed);
 		if (error)
-			goto out;
+			goto out_bmap_cancel;
 
 		error = xfs_trans_commit(tp);
 	}
 
 	return error;
 
-out:
+out_bmap_cancel:
+	xfs_bmap_cancel(&free_list);
+out_trans_cancel:
 	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d22a984..d8230ba 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1785,14 +1785,15 @@ xfs_inactive_ifree(
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
 
 	/*
-	 * Just ignore errors at this point.  There is nothing we can
-	 * do except to try to keep going. Make sure it's not a silent
-	 * error.
+	 * Just ignore errors at this point.  There is nothing we can do except
+	 * to try to keep going. Make sure it's not a silent error.
 	 */
 	error = xfs_bmap_finish(&tp,  &free_list, &committed);
-	if (error)
+	if (error) {
 		xfs_notice(mp, "%s: xfs_bmap_finish returned error %d",
 			__func__, error);
+		xfs_bmap_cancel(&free_list);
+	}
 	error = xfs_trans_commit(tp);
 	if (error)
 		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index f4e8c06..ab1bac6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -757,31 +757,30 @@ xfs_rtallocate_extent_size(
 /*
  * Allocate space to the bitmap or summary file, and zero it, for growfs.
  */
-STATIC int				/* error */
+STATIC int
 xfs_growfs_rt_alloc(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_extlen_t	oblocks,	/* old count of blocks */
-	xfs_extlen_t	nblocks,	/* new count of blocks */
-	xfs_inode_t	*ip)		/* inode (bitmap/summary) */
+	struct xfs_mount	*mp,		/* file system mount point */
+	xfs_extlen_t		oblocks,	/* old count of blocks */
+	xfs_extlen_t		nblocks,	/* new count of blocks */
+	struct xfs_inode	*ip)		/* inode (bitmap/summary) */
 {
-	xfs_fileoff_t	bno;		/* block number in file */
-	xfs_buf_t	*bp;		/* temporary buffer for zeroing */
-	int		committed;	/* transaction committed flag */
-	xfs_daddr_t	d;		/* disk block address */
-	int		error;		/* error return value */
-	xfs_fsblock_t	firstblock;	/* first block allocated in xaction */
-	xfs_bmap_free_t	flist;		/* list of freed blocks */
-	xfs_fsblock_t	fsbno;		/* filesystem block for bno */
-	xfs_bmbt_irec_t	map;		/* block map output */
-	int		nmap;		/* number of block maps */
-	int		resblks;	/* space reservation */
+	xfs_fileoff_t		bno;		/* block number in file */
+	struct xfs_buf		*bp;	/* temporary buffer for zeroing */
+	int			committed;	/* transaction committed flag */
+	xfs_daddr_t		d;		/* disk block address */
+	int			error;		/* error return value */
+	xfs_fsblock_t		firstblock;/* first block allocated in xaction */
+	struct xfs_bmap_free	flist;		/* list of freed blocks */
+	xfs_fsblock_t		fsbno;		/* filesystem block for bno */
+	struct xfs_bmbt_irec	map;		/* block map output */
+	int			nmap;		/* number of block maps */
+	int			resblks;	/* space reservation */
+	struct xfs_trans	*tp;
 
 	/*
 	 * Allocate space to the file, as necessary.
 	 */
 	while (oblocks < nblocks) {
-		xfs_trans_t	*tp;
-
 		tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFSRT_ALLOC);
 		resblks = XFS_GROWFSRT_SPACE_RES(mp, nblocks - oblocks);
 		/*
@@ -790,7 +789,7 @@ xfs_growfs_rt_alloc(
 		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtalloc,
 					  resblks, 0);
 		if (error)
-			goto error_cancel;
+			goto out_trans_cancel;
 		/*
 		 * Lock the inode.
 		 */
@@ -808,16 +807,16 @@ xfs_growfs_rt_alloc(
 		if (!error && nmap < 1)
 			error = -ENOSPC;
 		if (error)
-			goto error_cancel;
+			goto out_bmap_cancel;
 		/*
 		 * Free any blocks freed up in the transaction, then commit.
 		 */
 		error = xfs_bmap_finish(&tp, &flist, &committed);
 		if (error)
-			goto error_cancel;
+			goto out_bmap_cancel;
 		error = xfs_trans_commit(tp);
 		if (error)
-			goto error;
+			return error;
 		/*
 		 * Now we need to clear the allocated blocks.
 		 * Do this one block per transaction, to keep it simple.
@@ -832,7 +831,7 @@ xfs_growfs_rt_alloc(
 			error = xfs_trans_reserve(tp, &M_RES(mp)->tr_growrtzero,
 						  0, 0);
 			if (error)
-				goto error_cancel;
+				goto out_trans_cancel;
 			/*
 			 * Lock the bitmap inode.
 			 */
@@ -846,9 +845,7 @@ xfs_growfs_rt_alloc(
 				mp->m_bsize, 0);
 			if (bp == NULL) {
 				error = -EIO;
-error_cancel:
-				xfs_trans_cancel(tp);
-				goto error;
+				goto out_trans_cancel;
 			}
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
@@ -857,16 +854,20 @@ error_cancel:
 			 */
 			error = xfs_trans_commit(tp);
 			if (error)
-				goto error;
+				return error;
 		}
 		/*
 		 * Go on to the next extent, if any.
 		 */
 		oblocks = map.br_startoff + map.br_blockcount;
 	}
+
 	return 0;
 
-error:
+out_bmap_cancel:
+	xfs_bmap_cancel(&flist);
+out_trans_cancel:
+	xfs_trans_cancel(tp);
 	return error;
 }
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
