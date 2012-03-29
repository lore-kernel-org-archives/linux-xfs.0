Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TNQJTx207789 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 18:26:19 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	O6DS2rcV2ja4SwaP (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Mar 2012 16:26:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SDOjR-0000J8-1q
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 23:26:17 +0000
Date: Thu, 29 Mar 2012 19:26:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: remove xfs_inotobp
Message-ID: <20120329232616.GA1163@infradead.org>
References: <20120329232543.GA30033@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120329232543.GA30033@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

There is no need to keep this helper around, opencoding it in the only
caller is just as clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_inode.c |   70 ++++++++++++++---------------------------------------
 fs/xfs/xfs_inode.h |    3 --
 2 files changed, 19 insertions(+), 54 deletions(-)

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2012-03-29 16:14:23.223420421 -0700
+++ xfs/fs/xfs/xfs_inode.c	2012-03-29 16:15:37.309685727 -0700
@@ -202,47 +202,6 @@ xfs_imap_to_bp(
 }
 
 /*
- * This routine is called to map an inode number within a file
- * system to the buffer containing the on-disk version of the
- * inode.  It returns a pointer to the buffer containing the
- * on-disk inode in the bpp parameter, and in the dip parameter
- * it returns a pointer to the on-disk inode within that buffer.
- *
- * If a non-zero error is returned, then the contents of bpp and
- * dipp are undefined.
- *
- * Use xfs_imap() to determine the size and location of the
- * buffer to read from disk.
- */
-int
-xfs_inotobp(
-	xfs_mount_t	*mp,
-	xfs_trans_t	*tp,
-	xfs_ino_t	ino,
-	xfs_dinode_t	**dipp,
-	xfs_buf_t	**bpp,
-	int		*offset,
-	uint		imap_flags)
-{
-	struct xfs_imap	imap;
-	xfs_buf_t	*bp;
-	int		error;
-
-	imap.im_blkno = 0;
-	error = xfs_imap(mp, tp, ino, &imap, imap_flags);
-	if (error)
-		return error;
-
-	error = xfs_imap_to_bp(mp, tp, &imap, dipp, &bp, XBF_LOCK, imap_flags);
-	if (error)
-		return error;
-
-	*bpp = bp;
-	*offset = imap.im_boffset;
-	return 0;
-}
-
-/*
  * Move inode type and inode format specific information from the
  * on-disk inode to the in-core inode.  For fifos, devs, and sockets
  * this means set if_rdev to the proper value.  For files, directories,
@@ -1418,23 +1377,32 @@ xfs_iunlink_remove(
 		next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 		last_ibp = NULL;
 		while (next_agino != agino) {
-			/*
-			 * If the last inode wasn't the one pointing to
-			 * us, then release its buffer since we're not
-			 * going to do anything with it.
-			 */
-			if (last_ibp != NULL) {
+			struct xfs_imap	imap;
+
+			if (last_ibp)
 				xfs_trans_brelse(tp, last_ibp);
-			}
+
+			imap.im_blkno = 0;
 			next_ino = XFS_AGINO_TO_INO(mp, agno, next_agino);
-			error = xfs_inotobp(mp, tp, next_ino, &last_dip,
-					    &last_ibp, &last_offset, 0);
+
+			error = xfs_imap(mp, tp, next_ino, &imap, 0);
+			if (error) {
+				xfs_warn(mp,
+	"%s: xfs_imap returned error %d.",
+					 __func__, error);
+				return error;
+			}
+
+			error = xfs_imap_to_bp(mp, tp, &imap, &last_dip,
+					       &last_ibp, XBF_LOCK, 0);
 			if (error) {
 				xfs_warn(mp,
-					"%s: xfs_inotobp() returned error %d.",
+	"%s: xfs_imap_to_bp returned error %d.",
 					__func__, error);
 				return error;
 			}
+
+			last_offset = imap.im_boffset;
 			next_agino = be32_to_cpu(last_dip->di_next_unlinked);
 			ASSERT(next_agino != NULLAGINO);
 			ASSERT(next_agino != 0);
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-03-29 16:14:23.223420421 -0700
+++ xfs/fs/xfs/xfs_inode.h	2012-03-29 16:15:37.309685727 -0700
@@ -555,9 +555,6 @@ do { \
 #define XFS_IGET_UNTRUSTED	0x2
 #define XFS_IGET_DONTCACHE	0x4
 
-int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
-			    xfs_ino_t, struct xfs_dinode **,
-			    struct xfs_buf **, int *, uint);
 int		xfs_imap_to_bp(struct xfs_mount *, struct xfs_trans *,
 			       struct xfs_imap *, struct xfs_dinode **,
 			       struct xfs_buf **, uint, uint);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
