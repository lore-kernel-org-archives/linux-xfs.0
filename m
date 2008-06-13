Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 00:34:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5D7Y48Q010792
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 00:34:06 -0700
Message-ID: <485223E4.6030404@sgi.com>
Date: Fri, 13 Jun 2008 17:38:12 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: [PATCH] Prevent extent btree block allocation failures
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

When at ENOSPC conditions extent btree block allocations can fail and we
have no error handling to undo partial btree operations.  Prior to extent
btree operations we reserve enough disk blocks somewhere in the filesystem
to satisfy the operation but in some conditions we require the blocks to
come from specific AGs and if those AGs are full the allocation fails.

This change fixes xfs_bmap_extents_to_btree(), xfs_bmap_local_to_extents(),
xfs_bmbt_split() and xfs_bmbt_newroot() so that they can search other AGs
for the space needed.  Since we have reserved the space these allocations
are now guaranteed to succeed.  In order to search all AGs I had to revert
a change made to xfs_alloc_vextent() that prevented a search from looking
at AGs lower than the starting AG.  This original change was made to prevent
out of order AG locking when allocating multiple extents on data writeout
but since we only allocate one extent at a time now this particular problem
can't happen.

Lachlan

--- fs/xfs/xfs_alloc.c_1.193	2008-06-03 11:28:55.000000000 +1000
+++ fs/xfs/xfs_alloc.c	2008-06-02 18:40:47.000000000 +1000
@@ -2376,19 +2376,9 @@ xfs_alloc_vextent(
 			if (args->agno == sagno &&
 			    type == XFS_ALLOCTYPE_START_BNO)
 				args->type = XFS_ALLOCTYPE_THIS_AG;
-			/*
-			* For the first allocation, we can try any AG to get
-			* space.  However, if we already have allocated a
-			* block, we don't want to try AGs whose number is below
-			* sagno. Otherwise, we may end up with out-of-order
-			* locking of AGF, which might cause deadlock.
-			*/
-			if (++(args->agno) == mp->m_sb.sb_agcount) {
-				if (args->firstblock != NULLFSBLOCK)
-					args->agno = sagno;
-				else
-					args->agno = 0;
-			}
+
+			if (++(args->agno) == mp->m_sb.sb_agcount)
+				args->agno = 0;
 			/*
 			 * Reached the starting a.g., must either be done
 			 * or switch to non-trylock mode.
--- fs/xfs/xfs_bmap.c_1.392	2008-06-03 12:20:14.000000000 +1000
+++ fs/xfs/xfs_bmap.c	2008-06-03 15:57:40.000000000 +1000
@@ -3445,16 +3452,10 @@ xfs_bmap_extents_to_btree(
 	args.tp = tp;
 	args.mp = mp;
 	args.firstblock = *firstblock;
-	if (*firstblock == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
+	args.fsbno = *firstblock;
+	if (*firstblock == NULLFSBLOCK)
 		args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
-	} else if (flist->xbf_low) {
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = *firstblock;
-	} else {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.fsbno = *firstblock;
-	}
+	args.type = XFS_ALLOCTYPE_START_BNO;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.total = args.minleft = args.alignment = args.mod = args.isfl =
 		args.minalignslop = 0;
@@ -3585,13 +3586,10 @@ xfs_bmap_local_to_extents(
 		 * Allocate a block.  We know we need only one, since the
 		 * file currently fits in an inode.
 		 */
-		if (*firstblock == NULLFSBLOCK) {
+		args.fsbno = *firstblock;
+		if (*firstblock == NULLFSBLOCK)
 			args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
-			args.type = XFS_ALLOCTYPE_START_BNO;
-		} else {
-			args.fsbno = *firstblock;
-			args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		}
+		args.type = XFS_ALLOCTYPE_START_BNO;
 		args.total = total;
 		args.mod = args.minleft = args.alignment = args.wasdel =
 			args.isfl = args.minalignslop = 0;
--- fs/xfs/xfs_bmap_btree.c_1.169	2008-06-03 11:28:56.000000000 +1000
+++ fs/xfs/xfs_bmap_btree.c	2008-06-06 14:48:14.000000000 +1000
@@ -1493,11 +1493,9 @@ xfs_bmbt_split(
 	left = XFS_BUF_TO_BMBT_BLOCK(lbp);
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
-	if (args.fsbno == NULLFSBLOCK) {
+	if (args.fsbno == NULLFSBLOCK)
 		args.fsbno = lbno;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.type = XFS_ALLOCTYPE_START_BNO;
 	args.mod = args.minleft = args.alignment = args.total = args.isfl =
 		args.userdata = args.minalignslop = 0;
 	args.minlen = args.maxlen = args.prod = 1;
@@ -2253,9 +2251,8 @@ xfs_bmbt_newroot(
 		}
 #endif
 		args.fsbno = be64_to_cpu(*pp);
-		args.type = XFS_ALLOCTYPE_START_BNO;
-	} else
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	}
+	args.type = XFS_ALLOCTYPE_START_BNO;
 	if ((error = xfs_alloc_vextent(&args))) {
 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
 		return error;
