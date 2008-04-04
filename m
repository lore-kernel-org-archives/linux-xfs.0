Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Apr 2008 08:08:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m34F85ud019609
	for <xfs@oss.sgi.com>; Fri, 4 Apr 2008 08:08:06 -0700
Received: from mail.pawisda.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EB92741D50
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2008 08:08:39 -0700 (PDT)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156]) by cuda.sgi.com with ESMTP id hXUW3c4GMgAPMjao for <xfs@oss.sgi.com>; Fri, 04 Apr 2008 08:08:39 -0700 (PDT)
Subject: Re: [PATCH] do not test return value of xfs_bmap_*_count_leaves
From: Ruben Porras <ruben.porras@linworks.de>
In-Reply-To: <20080328154605.GA28322@josefsipek.net>
References: <1206719011.8339.6.camel@marzo>
	 <20080328154605.GA28322@josefsipek.net>
Content-Type: multipart/mixed; boundary="=-yT0AAyVBBcP+RhUUuHTG"
Date: Fri, 04 Apr 2008 17:08:30 +0200
Message-Id: <1207321711.1043.9.camel@lw-pc002.intra.pawisda.de>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com

--=-yT0AAyVBBcP+RhUUuHTG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit


Am Freitag, den 28.03.2008, 11:46 -0400 schrieb Josef 'Jeff' Sipek:
> On Fri, Mar 28, 2008 at 04:43:31PM +0100, Ruben Porras wrote:
> > These functions, xfs_bmap_count_leaves and xfs_bmap_disk_count_leaves,
> > return always 0. Therefore it is not necessary to test the return value.
>  
> If it always returns 0, why not make it void?

better, patch attached.

-- 
Rubén Porras Campo
Telekommunikation Engineer

LinWorks GmbH
Robert-Koch-Straße 9; 64331 Weiterstadt
http://www.linworks.de

--=-yT0AAyVBBcP+RhUUuHTG
Content-Disposition: attachment; filename=xfs_bmap.patch
Content-Type: text/x-patch; name=xfs_bmap.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Index: fs/xfs/xfs_bmap.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_bmap.c,v
retrieving revision 1.387
diff -u -r1.387 xfs_bmap.c
--- fs/xfs/xfs_bmap.c	26 Mar 2008 15:25:15 -0000	1.387
+++ fs/xfs/xfs_bmap.c	4 Apr 2008 15:05:14 -0000
@@ -6356,13 +6356,9 @@
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
 
@@ -6443,13 +6439,7 @@
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
@@ -6467,7 +6457,7 @@
 /*
  * Count leaf blocks given a range of extent records.
  */
-STATIC int
+STATIC void
 xfs_bmap_count_leaves(
 	xfs_ifork_t		*ifp,
 	xfs_extnum_t		idx,
@@ -6480,14 +6470,13 @@
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
@@ -6501,5 +6490,4 @@
 		frp = XFS_BTREE_REC_ADDR(xfs_bmbt, block, idx + b);
 		*count += xfs_bmbt_disk_get_blockcount(frp);
 	}
-	return 0;
 }

--=-yT0AAyVBBcP+RhUUuHTG--
