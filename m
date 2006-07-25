Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 20:48:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6P3lUDW014120
	for <xfs@oss.sgi.com>; Mon, 24 Jul 2006 20:47:41 -0700
Date: Tue, 25 Jul 2006 13:46:51 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: rework bulkstat readahead
Message-ID: <20060725134651.D2116482@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: vapo@melbourne.sgi.com
Cc: xfs@oss.sgi.com

Hi all,
    
This patch rearranges the logic inside xfs_bulkstat to issue
readahead in a way that performs alot better.  The most critical 
piece is moving the readahead out of the final read-and-format
loop into the earlier build-up-irbuf-array loop.  This means:
    
- buffer readaheads are all issued at once, up front, before we 
start to issue the blocking reads waiting on each inode cluster;
    
- as a by-product, the readahead which is done for the internal
nodes of the AGI btree (from within xfs_inobt_increment) is now 
issued in the correct order relative to all the leaf readahead. 

I've also removed the incorrect endian swapping on the irbuf array
elements, that was always unnecessary as they're only ever held in
memory here.

cheers.

-- 
Nathan


Index: xfs-linux/xfs_itable.c
===================================================================
--- xfs-linux.orig/xfs_itable.c	2006-07-25 11:45:27.283811500 +1000
+++ xfs-linux/xfs_itable.c	2006-07-25 11:59:26.144649250 +1000
@@ -326,9 +326,9 @@ xfs_bulkstat(
 	int			i;	/* loop index */
 	int			icount;	/* count of inodes good in irbuf */
 	xfs_ino_t		ino;	/* inode number (filesystem) */
-	xfs_inobt_rec_t		*irbp;	/* current irec buffer pointer */
-	xfs_inobt_rec_t		*irbuf;	/* start of irec buffer */
-	xfs_inobt_rec_t		*irbufend; /* end of good irec buffer entries */
+	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
+	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
+	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
 	xfs_ino_t		lastino=0; /* last inode number returned */
 	int			nbcluster; /* # of blocks in a cluster */
 	int			nicluster; /* # of inodes in a cluster */
@@ -399,7 +399,7 @@ xfs_bulkstat(
 		 * Allocate and initialize a btree cursor for ialloc btree.
 		 */
 		cur = xfs_btree_init_cursor(mp, NULL, agbp, agno, XFS_BTNUM_INO,
-			(xfs_inode_t *)0, 0);
+						(xfs_inode_t *)0, 0);
 		irbp = irbuf;
 		irbufend = irbuf + nirbuf;
 		end_of_ag = 0;
@@ -436,9 +436,9 @@ xfs_bulkstat(
 						gcnt++;
 				}
 				gfree |= XFS_INOBT_MASKN(0, chunkidx);
-				irbp->ir_startino = cpu_to_be32(gino);
-				irbp->ir_freecount = cpu_to_be32(gcnt);
-				irbp->ir_free = cpu_to_be64(gfree);
+				irbp->ir_startino = gino;
+				irbp->ir_freecount = gcnt;
+				irbp->ir_free = gfree;
 				irbp++;
 				agino = gino + XFS_INODES_PER_CHUNK;
 				icount = XFS_INODES_PER_CHUNK - gcnt;
@@ -492,11 +492,27 @@ xfs_bulkstat(
 			}
 			/*
 			 * If this chunk has any allocated inodes, save it.
+			 * Also start read-ahead now for this chunk.
 			 */
 			if (gcnt < XFS_INODES_PER_CHUNK) {
-				irbp->ir_startino = cpu_to_be32(gino);
-				irbp->ir_freecount = cpu_to_be32(gcnt);
-				irbp->ir_free = cpu_to_be64(gfree);
+				/*
+				 * Loop over all clusters in the next chunk.
+				 * Do a readahead if there are any allocated
+				 * inodes in that cluster.
+				 */
+				for (agbno = XFS_AGINO_TO_AGBNO(mp, gino),
+				     chunkidx = 0;
+				     chunkidx < XFS_INODES_PER_CHUNK;
+				     chunkidx += nicluster,
+				     agbno += nbcluster) {
+					if (XFS_INOBT_MASKN(chunkidx,
+							    nicluster) & ~gfree)
+						xfs_btree_reada_bufs(mp, agno,
+							agbno, nbcluster);
+				}
+				irbp->ir_startino = gino;
+				irbp->ir_freecount = gcnt;
+				irbp->ir_free = gfree;
 				irbp++;
 				icount += XFS_INODES_PER_CHUNK - gcnt;
 			}
@@ -520,33 +536,11 @@ xfs_bulkstat(
 		for (irbp = irbuf;
 		     irbp < irbufend && ubleft >= statstruct_size; irbp++) {
 			/*
-			 * Read-ahead the next chunk's worth of inodes.
-			 */
-			if (&irbp[1] < irbufend) {
-				/*
-				 * Loop over all clusters in the next chunk.
-				 * Do a readahead if there are any allocated
-				 * inodes in that cluster.
-				 */
-				for (agbno = XFS_AGINO_TO_AGBNO(mp,
-							be32_to_cpu(irbp[1].ir_startino)),
-				     chunkidx = 0;
-				     chunkidx < XFS_INODES_PER_CHUNK;
-				     chunkidx += nicluster,
-				     agbno += nbcluster) {
-					if (XFS_INOBT_MASKN(chunkidx,
-							    nicluster) &
-					    ~(be64_to_cpu(irbp[1].ir_free)))
-						xfs_btree_reada_bufs(mp, agno,
-							agbno, nbcluster);
-				}
-			}
-			/*
 			 * Now process this chunk of inodes.
 			 */
-			for (agino = be32_to_cpu(irbp->ir_startino), chunkidx = 0, clustidx = 0;
+			for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
 			     ubleft > 0 &&
-				be32_to_cpu(irbp->ir_freecount) < XFS_INODES_PER_CHUNK;
+				irbp->ir_freecount < XFS_INODES_PER_CHUNK;
 			     chunkidx++, clustidx++, agino++) {
 				ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
 				/*
@@ -566,7 +560,7 @@ xfs_bulkstat(
 				 */
 				if ((chunkidx & (nicluster - 1)) == 0) {
 					agbno = XFS_AGINO_TO_AGBNO(mp,
-							be32_to_cpu(irbp->ir_startino)) +
+							irbp->ir_startino) +
 						((chunkidx & nimask) >>
 						 mp->m_sb.sb_inopblog);
 
@@ -606,13 +600,13 @@ xfs_bulkstat(
 				/*
 				 * Skip if this inode is free.
 				 */
-				if (XFS_INOBT_MASK(chunkidx) & be64_to_cpu(irbp->ir_free))
+				if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free)
 					continue;
 				/*
 				 * Count used inodes as free so we can tell
 				 * when the chunk is used up.
 				 */
-				be32_add(&irbp->ir_freecount, 1);
+				irbp->ir_freecount++;
 				ino = XFS_AGINO_TO_INO(mp, agno, agino);
 				bno = XFS_AGB_TO_DADDR(mp, agno, agbno);
 				if (!xfs_bulkstat_use_dinode(mp, flags, bp,
