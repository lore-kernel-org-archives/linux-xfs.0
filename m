Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Aug 2008 20:00:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m742xuwH010286
	for <xfs@oss.sgi.com>; Sun, 3 Aug 2008 19:59:56 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA02331; Mon, 4 Aug 2008 13:01:07 +1000
Message-ID: <489670F3.7070706@sgi.com>
Date: Mon, 04 Aug 2008 13:01:07 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: [PING] do not test return value of xfs_bmap_*_count_leaves
References: <1217281149.5345.39.camel@marzo>
In-Reply-To: <1217281149.5345.39.camel@marzo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: xfs@oss.sgi.com

Ruben Porras wrote:
> http://oss.sgi.com/archives/xfs/2008-04/msg00087.html
> 

Got it, sorry we dropped it for so long.

Your second patch missed the int/void decleration changes, I've added
that to the patch. I'm also assuming the following Signed-off-by and
description, is that ok by you?


Make xfs_bmap_*_count_leaves void.

xfs_bmap_count_leaves and xfs_bmap_disk_count_leaves always
return always 0, make them void.

Signed-off-by: "Ruben Porras <nahoo82@gmail.com>"


--- fs/xfs/xfs_bmap.c.orig
+++ fs/xfs/xfs_bmap.c
@@ -384,14 +384,14 @@ xfs_bmap_count_tree(
  	int             levelin,
  	int		*count);

-STATIC int
+STATIC void
  xfs_bmap_count_leaves(
  	xfs_ifork_t		*ifp,
  	xfs_extnum_t		idx,
  	int			numrecs,
  	int			*count);

-STATIC int
+STATIC void
  xfs_bmap_disk_count_leaves(
  	xfs_extnum_t		idx,
  	xfs_bmbt_block_t	*block,
@@ -6367,13 +6367,9 @@ xfs_bmap_count_blocks(
  	mp = ip->i_mount;
  	ifp = XFS_IFORK_PTR(ip, whichfork);
  	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
-		if (unlikely(xfs_bmap_count_leaves(ifp, 0,
+		xfs_bmap_count_leaves(ifp, 0,
  			ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t),
-			count) < 0)) {
-			XFS_ERROR_REPORT("xfs_bmap_count_blocks(1)",
-					 XFS_ERRLEVEL_LOW, mp);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
+			count);
  		return 0;
  	}

@@ -6454,13 +6450,7 @@ xfs_bmap_count_tree(
  		for (;;) {
  			nextbno = be64_to_cpu(block->bb_rightsib);
  			numrecs = be16_to_cpu(block->bb_numrecs);
-			if (unlikely(xfs_bmap_disk_count_leaves(0,
-					block, numrecs, count) < 0)) {
-				xfs_trans_brelse(tp, bp);
-				XFS_ERROR_REPORT("xfs_bmap_count_tree(2)",
-						 XFS_ERRLEVEL_LOW, mp);
-				return XFS_ERROR(EFSCORRUPTED);
-			}
+			xfs_bmap_disk_count_leaves(0, block, numrecs, count);
  			xfs_trans_brelse(tp, bp);
  			if (nextbno == NULLFSBLOCK)
  				break;
@@ -6478,7 +6468,7 @@ xfs_bmap_count_tree(
  /*
   * Count leaf blocks given a range of extent records.
   */
-STATIC int
+STATIC void
  xfs_bmap_count_leaves(
  	xfs_ifork_t		*ifp,
  	xfs_extnum_t		idx,
@@ -6491,14 +6481,13 @@ xfs_bmap_count_leaves(
  		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, idx + b);
  		*count += xfs_bmbt_get_blockcount(frp);
  	}
-	return 0;
  }

  /*
   * Count leaf blocks given a range of extent records originally
   * in btree format.
   */
-STATIC int
+STATIC void
  xfs_bmap_disk_count_leaves(
  	xfs_extnum_t		idx,
  	xfs_bmbt_block_t	*block,
@@ -6512,5 +6501,4 @@ xfs_bmap_disk_count_leaves(
  		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, idx + b);
  		*count += xfs_bmbt_disk_get_blockcount(frp);
  	}
-	return 0;
  }
