Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08J016o022725 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 13:00:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9876B7105E
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 11:00:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eXSihg3CNBAwxstF for
	<xfs@oss.sgi.com>; Thu, 08 Jan 2009 11:00:01 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LL06q-0002DU-Vi
	for xfs@oss.sgi.com; Thu, 08 Jan 2009 19:00:01 +0000
Date: Thu, 8 Jan 2009 14:00:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: truncate readdir offsets to signed 32 bit values
Message-ID: <20090108190000.GA8440@infradead.org>
References: <20090108184222.244013000@bombadil.infradead.org>
	<20090108184430.165424000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090108184430.165424000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Thu, Jan 08, 2009 at 01:42:24PM -0500, Christoph Hellwig wrote:
> John Stanley reported EOVERFLOW errors in readdir from his self-build
> glibc.  I traced this down to glibc enabling d_off overflow checks
> in one of the about five million different getdents implementations.
> 
> In 2.6.28 Dave Woodhouse moved our readdir double buffering required
> for NFS4 readdirplus into nfsd and at that point we lost the capping
> of the directory offsets to 32 bit signed values.  Johns glibc used
> getdents64 to even implement readdir for normal 32 bit offset dirents,
> and failed with EOVERFLOW only if this happens on the first dirent in
> a getdents call.  I managed to come up with a testcase that uses
> raw getdents and does the EOVERFLOW check manually.  We always hit
> it with our last entry due to the special end of directory marker.
> 
> The patch below is a dumb version of just putting back the masking,
> to make sure we have the same behavior as in 2.6.27 and earlier.
> 
> I will work on a better and cleaner fix for 2.6.30.
> 
> Reported-by: John Stanley <jpsinthemix@verizon.net>
> Tested-by: John Stanley <jpsinthemix@verizon.net>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

As arkem noticed I should not have sent out some half-mangled version
but the first crude patch.  Here it is:


Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2008-12-29 21:25:29.680613664 +0100
+++ xfs/fs/xfs/xfs_dir2_block.c	2008-12-29 21:29:57.341627581 +0100
@@ -517,9 +517,9 @@ xfs_dir2_block_getdents(
 		/*
 		 * If it didn't fit, set the final offset to here & return.
 		 */
-		if (filldir(dirent, dep->name, dep->namelen, cook,
+		if (filldir(dirent, dep->name, dep->namelen, cook & 0x7fffffff,
 			    ino, DT_UNKNOWN)) {
-			*offset = cook;
+			*offset = cook & 0x7fffffff;
 			xfs_da_brelse(NULL, bp);
 			return 0;
 		}
@@ -529,7 +529,8 @@ xfs_dir2_block_getdents(
 	 * Reached the end of the block.
 	 * Set the offset to a non-existent block 1 and return.
 	 */
-	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
+			0x7fffffff;
 	xfs_da_brelse(NULL, bp);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_dir2_leaf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2008-12-29 21:25:13.899613482 +0100
+++ xfs/fs/xfs/xfs_dir2_leaf.c	2008-12-29 21:29:36.125616996 +0100
@@ -1092,7 +1092,7 @@ xfs_dir2_leaf_getdents(
 		 * Won't fit.  Return to caller.
 		 */
 		if (filldir(dirent, dep->name, dep->namelen,
-			    xfs_dir2_byte_to_dataptr(mp, curoff),
+			    xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff,
 			    ino, DT_UNKNOWN))
 			break;
 
@@ -1108,9 +1108,9 @@ xfs_dir2_leaf_getdents(
 	 * All done.  Set output offset value to current offset.
 	 */
 	if (curoff > xfs_dir2_dataptr_to_byte(mp, XFS_DIR2_MAX_DATAPTR))
-		*offset = XFS_DIR2_MAX_DATAPTR;
+		*offset = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
 	else
-		*offset = xfs_dir2_byte_to_dataptr(mp, curoff);
+		*offset = xfs_dir2_byte_to_dataptr(mp, curoff) & 0x7fffffff;
 	kmem_free(map);
 	if (bp)
 		xfs_da_brelse(NULL, bp);
Index: xfs/fs/xfs/xfs_dir2_sf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_sf.c	2008-12-29 21:23:55.174613820 +0100
+++ xfs/fs/xfs/xfs_dir2_sf.c	2008-12-29 21:29:00.721617384 +0100
@@ -752,8 +752,8 @@ xfs_dir2_sf_getdents(
 #if XFS_BIG_INUMS
 		ino += mp->m_inoadd;
 #endif
-		if (filldir(dirent, ".", 1, dot_offset, ino, DT_DIR)) {
-			*offset = dot_offset;
+		if (filldir(dirent, ".", 1, dot_offset & 0x7fffffff, ino, DT_DIR)) {
+			*offset = dot_offset & 0x7fffffff;
 			return 0;
 		}
 	}
@@ -766,8 +766,8 @@ xfs_dir2_sf_getdents(
 #if XFS_BIG_INUMS
 		ino += mp->m_inoadd;
 #endif
-		if (filldir(dirent, "..", 2, dotdot_offset, ino, DT_DIR)) {
-			*offset = dotdot_offset;
+		if (filldir(dirent, "..", 2, dotdot_offset & 0x7fffffff, ino, DT_DIR)) {
+			*offset = dotdot_offset & 0x7fffffff;
 			return 0;
 		}
 	}
@@ -791,14 +791,15 @@ xfs_dir2_sf_getdents(
 #endif
 
 		if (filldir(dirent, sfep->name, sfep->namelen,
-					    off, ino, DT_UNKNOWN)) {
-			*offset = off;
+			    off & 0x7fffffff, ino, DT_UNKNOWN)) {
+			*offset = off & 0x7fffffff;
 			return 0;
 		}
 		sfep = xfs_dir2_sf_nextentry(sfp, sfep);
 	}
 
-	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0);
+	*offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk + 1, 0) &
+			0x7fffffff;
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
