Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfkvJ200938 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10D9017205C
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	oXMMjVvBKdsY1Ayc for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:45 -0700 (PDT)
Message-Id: <20110918204145.403773861@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 15/27] xfs: pass bmalloca structure to xfs_bmap_isaeof
References: <20110918204040.266805129@bombadil.infradead.org>
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

From: Dave Chinner <dchinner@redhat.com>

All the variables xfs_bmap_isaeof() is passed are contained within
the xfs_bmalloca structure. Pass that instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:45:06.206455848 -0400
+++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 08:45:07.546455840 -0400
@@ -3867,22 +3867,21 @@ xfs_bmap_last_extent(
  * blocks at the end of the file which do not start at the previous data block,
  * we will try to align the new blocks at stripe unit boundaries.
  *
- * Returns 0 in *aeof if the file (fork) is empty as any new write will be at,
- * or past the EOF.
+ * Returns 0 in bma->aeof if the file (fork) is empty as any new write will be
+ * at, or past the EOF.
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
+	error = xfs_bmap_last_extent(NULL, bma->ip, whichfork, &rec,
+				     &is_empty);
 	if (error || is_empty)
 		return error;
 
@@ -3890,8 +3889,9 @@ xfs_bmap_isaeof(
 	 * Check if we are allocation or past the last extent, or at least into
 	 * the last delayed allocated extent.
 	 */
-	*aeof = off >= rec.br_startoff + rec.br_blockcount ||
-		(off >= rec.br_startoff && isnullstartblock(rec.br_startblock));
+	bma->aeof = bma->off >= rec.br_startoff + rec.br_blockcount ||
+		(bma->off >= rec.br_startoff &&
+		 isnullstartblock(rec.br_startblock));
 	return 0;
 }
 
@@ -4658,7 +4658,7 @@ xfs_bmapi_allocate(
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
