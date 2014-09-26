Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8BF62802D
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 18:20:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28DF5AC00B
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 16:20:23 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gkbXxeby00eyBZwf for <xfs@oss.sgi.com>;
	Fri, 26 Sep 2014 16:20:18 -0700 (PDT)
Date: Sat, 27 Sep 2014 09:20:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/11 v2] xfs: check xfs_buf_read_uncached returns correctly
Message-ID: <20140926232012.GQ4945@dastard>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
	<1411648461-29003-11-git-send-email-david@fromorbit.com>
	<20140926102148.GF22194@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140926102148.GF22194@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Sep 26, 2014 at 03:21:48AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 25, 2014 at 10:34:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_buf_read_uncached() has two failure modes. If can either return
> > NULL or bp->b_error != 0 depending on the type of failure, and not
> > all callers check for both. Fix it up.
> 
> This changelog still seems to be for your previous version and needs
> an update now tha xfs_buf_read_uncached always returns the error
> directly.

Fixed.

> 
> > -		return NULL;
> > +		return ENOMEM;
> 
> Should be -ENOMEM these days, shouldn't it?

Yes, good catch.

> >  release_buf:
> > -	xfs_buf_relse(bp);
> > +	if (bp)
> > +		xfs_buf_relse(bp);
> 
> Shouldn't bp always be valid at this point?

It is. Fixed.

Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: check xfs_buf_read_uncached returns correctly

From: Dave Chinner <dchinner@redhat.com>

xfs_buf_read_uncached() has two failure modes. If can either return
NULL or bp->b_error != 0 depending on the type of failure, and not
all callers check for both. Fix it so that xfs_buf_read_uncached()
always returns the error status, and the buffer is returned as a
function parameter. The buffer will only be returned on success.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c     | 18 +++++++++++++----
 fs/xfs/xfs_buf.h     |  6 +++---
 fs/xfs/xfs_fsops.c   | 11 +++--------
 fs/xfs/xfs_mount.c   | 55 +++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_rtalloc.c | 30 ++++++++++++----------------
 5 files changed, 58 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d1d3fe6..017b6af 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -688,29 +688,39 @@ xfs_buf_readahead_map(
  * Read an uncached buffer from disk. Allocates and returns a locked
  * buffer containing the disk contents or nothing.
  */
-struct xfs_buf *
+int
 xfs_buf_read_uncached(
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		daddr,
 	size_t			numblks,
 	int			flags,
+	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
 
+	*bpp = NULL;
+
 	bp = xfs_buf_get_uncached(target, numblks, flags);
 	if (!bp)
-		return NULL;
+		return -ENOMEM;
 
 	/* set up the buffer for a read IO */
 	ASSERT(bp->b_map_count == 1);
-	bp->b_bn = daddr;
+	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
 	bp->b_maps[0].bm_bn = daddr;
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = ops;
 
 	xfs_buf_submit_wait(bp);
-	return bp;
+	if (bp->b_error) {
+		int	error = bp->b_error;
+		xfs_buf_relse(bp);
+		return error;
+	}
+
+	*bpp = bp;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 0acfc30..82002c0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -269,9 +269,9 @@ int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
 
 struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 				int flags);
-struct xfs_buf *xfs_buf_read_uncached(struct xfs_buftarg *target,
-				xfs_daddr_t daddr, size_t numblks, int flags,
-				const struct xfs_buf_ops *ops);
+int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
+			  size_t numblks, int flags, struct xfs_buf **bpp,
+			  const struct xfs_buf_ops *ops);
 void xfs_buf_hold(struct xfs_buf *bp);
 
 /* Releasing Buffers */
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 126b4b3..ece69c2 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -172,16 +172,11 @@ xfs_growfs_data_private(
 	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
 		return error;
 	dpct = pct - mp->m_sb.sb_imax_pct;
-	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
+	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
-				XFS_FSS_TO_BB(mp, 1), 0, NULL);
-	if (!bp)
-		return -EIO;
-	if (bp->b_error) {
-		error = bp->b_error;
-		xfs_buf_relse(bp);
+				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
 		return error;
-	}
 	xfs_buf_relse(bp);
 
 	new = nb;	/* use new as a temporary here */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 78a2799..d731035 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -300,21 +300,15 @@ xfs_readsb(
 	 * access to the superblock.
 	 */
 reread:
-	bp = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
-				   BTOBB(sector_size), 0, buf_ops);
-	if (!bp) {
-		if (loud)
-			xfs_warn(mp, "SB buffer read failed");
-		return -EIO;
-	}
-	if (bp->b_error) {
-		error = bp->b_error;
+	error = xfs_buf_read_uncached(mp->m_ddev_targp, XFS_SB_DADDR,
+				   BTOBB(sector_size), 0, &bp, buf_ops);
+	if (error) {
 		if (loud)
 			xfs_warn(mp, "SB validate failed with error %d.", error);
 		/* bad CRC means corrupted metadata */
 		if (error == -EFSBADCRC)
 			error = -EFSCORRUPTED;
-		goto release_buf;
+		return error;
 	}
 
 	/*
@@ -544,40 +538,43 @@ xfs_set_inoalignment(xfs_mount_t *mp)
  * Check that the data (and log if separate) is an ok size.
  */
 STATIC int
-xfs_check_sizes(xfs_mount_t *mp)
+xfs_check_sizes(
+	struct xfs_mount *mp)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf	*bp;
 	xfs_daddr_t	d;
+	int		error;
 
 	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
 		xfs_warn(mp, "filesystem size mismatch detected");
 		return -EFBIG;
 	}
-	bp = xfs_buf_read_uncached(mp->m_ddev_targp,
+	error = xfs_buf_read_uncached(mp->m_ddev_targp,
 					d - XFS_FSS_TO_BB(mp, 1),
-					XFS_FSS_TO_BB(mp, 1), 0, NULL);
-	if (!bp) {
+					XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
 		xfs_warn(mp, "last sector read failed");
-		return -EIO;
+		return error;
 	}
 	xfs_buf_relse(bp);
 
-	if (mp->m_logdev_targp != mp->m_ddev_targp) {
-		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
-		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
-			xfs_warn(mp, "log size mismatch detected");
-			return -EFBIG;
-		}
-		bp = xfs_buf_read_uncached(mp->m_logdev_targp,
+	if (mp->m_logdev_targp == mp->m_ddev_targp)
+		return 0;
+
+	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
+		xfs_warn(mp, "log size mismatch detected");
+		return -EFBIG;
+	}
+	error = xfs_buf_read_uncached(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL);
-		if (!bp) {
-			xfs_warn(mp, "log device read failed");
-			return -EIO;
-		}
-		xfs_buf_relse(bp);
+					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
+		xfs_warn(mp, "log device read failed");
+		return error;
 	}
+	xfs_buf_relse(bp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d45aebe..e1175ea 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -921,16 +921,11 @@ xfs_growfs_rt(
 	/*
 	 * Read in the last block of the device, make sure it exists.
 	 */
-	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
 				XFS_FSB_TO_BB(mp, nrblocks - 1),
-				XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (!bp)
-		return -EIO;
-	if (bp->b_error) {
-		error = bp->b_error;
-		xfs_buf_relse(bp);
+				XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
 		return error;
-	}
 	xfs_buf_relse(bp);
 
 	/*
@@ -1184,11 +1179,12 @@ xfs_rtallocate_extent(
  */
 int				/* error */
 xfs_rtmount_init(
-	xfs_mount_t	*mp)	/* file system mount structure */
+	struct xfs_mount	*mp)	/* file system mount structure */
 {
-	xfs_buf_t	*bp;	/* buffer for last block of subvolume */
-	xfs_daddr_t	d;	/* address of last block of subvolume */
-	xfs_sb_t	*sbp;	/* filesystem superblock copy in mount */
+	struct xfs_buf		*bp;	/* buffer for last block of subvolume */
+	struct xfs_sb		*sbp;	/* filesystem superblock copy in mount */
+	xfs_daddr_t		d;	/* address of last block of subvolume */
+	int			error;
 
 	sbp = &mp->m_sb;
 	if (sbp->sb_rblocks == 0)
@@ -1214,14 +1210,12 @@ xfs_rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -EFBIG;
 	}
-	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
-					XFS_FSB_TO_BB(mp, 1), 0, NULL);
-	if (!bp || bp->b_error) {
+					XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
 		xfs_warn(mp, "realtime device size check failed");
-		if (bp)
-			xfs_buf_relse(bp);
-		return -EIO;
+		return error;
 	}
 	xfs_buf_relse(bp);
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
