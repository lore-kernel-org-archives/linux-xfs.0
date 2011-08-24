Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66jbK014487 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E85E139758C
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:09:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OQg6w9ab0n3DayIN for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:09:29 -0700 (PDT)
Message-Id: <20110824060643.660514652@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/25] xfs: pass bmalloca structure to xfs_bmap_isaeof
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmalloca-isaeof
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Dave Chinner <dchinner@redhat.com>

All the variables xfs_bmap_isaeof() is passed are contained within
the xfs_bmalloca structure. Pass that instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:33.735424450 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:35.358748989 +0200
@@ -3869,17 +3869,16 @@ xfs_bmap_last_extent(
  */
 STATIC int
 xfs_bmap_isaeof(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		off,
-	int			whichfork,
-	char			*aeof)
+	struct xfs_bmalloca	*bma,
+	int			whichfork)
 {
 	struct xfs_bmbt_irec	rec;
 	int			is_empty;
 	int			error;
 
-	*aeof = 0;
-	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
+	bma->aeof = 0;
+	error = xfs_bmap_last_extent(bma->tp, bma->ip, whichfork, &rec,
+				     &is_empty);
 	if (error || is_empty)
 		return error;
 
@@ -3887,10 +3886,10 @@ xfs_bmap_isaeof(
 	 * Check we are allocating in the last extent (for delayed allocations)
 	 * or past the last extent for non-delayed allocations.
 	 */
-	*aeof = (off >= rec.br_startoff &&
-		 off < rec.br_startoff + rec.br_blockcount &&
-		 isnullstartblock(rec.br_startblock)) ||
-		off >= rec.br_startoff + rec.br_blockcount;
+	bma->aeof = (bma->off >= rec.br_startoff &&
+		     bma->off < rec.br_startoff + rec.br_blockcount &&
+		     isnullstartblock(rec.br_startblock)) ||
+		    bma->off >= rec.br_startoff + rec.br_blockcount;
 	return 0;
 }
 
@@ -4653,7 +4652,7 @@ xfs_bmapi_allocate(
 	 */
 	if (mp->m_dalign && alen >= mp->m_dalign &&
 	    !(flags & XFS_BMAPI_METADATA) && whichfork == XFS_DATA_FORK) {
-		error = xfs_bmap_isaeof(bma->ip, aoff, whichfork, &bma->aeof);
+		error = xfs_bmap_isaeof(bma, whichfork);
 		if (error)
 			return error;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
