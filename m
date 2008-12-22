Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMEwwpc028067 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:58:58 -0600
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D71AF17702BD
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:58:56 -0800 (PST)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id BawpKyRC5euFCaBJ for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 06:58:56 -0800 (PST)
Date: Mon, 22 Dec 2008 09:58:25 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH] XFS: random cleanups of xfs_swap_extents
Message-ID: <20081222145825.GY15407@josefsipek.net>
References: <20081107230054.GH26208@josefsipek.net>
	<20081112100958.GB32567@infradead.org>
	<20081112153903.GE27125@josefsipek.net>
	<20081222130202.GB12367@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081222130202.GB12367@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Dec 22, 2008 at 08:02:02AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 12, 2008 at 10:39:03AM -0500, Josef 'Jeff' Sipek wrote:
> > > With the one case that does a trans_cancel with partially unlocked
> > > inodes handcoding most of it.
> > 
> > Ok, I'll do that.
> 
> Did you manage to actually do it? :)

I did, I just didn't have time to run it through xfsqa (well, set up a test
box for xfsqa). Use at your own risk :)

Josef 'Jeff' Sipek.

--

XFS: use multiple labels and gotos for error handling in xfs_swap_extents

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index 75b0cd4..ec832bc 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -132,19 +132,17 @@ xfs_swap_extents(
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
 	int		ilf_fields, tilf_fields;
-	static uint	lock_flags = XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL;
 	int		error = 0;
 	int		aforkblks = 0;
 	int		taforkblks = 0;
 	__uint64_t	tmp;
-	char		locked = 0;
 
 	mp = ip->i_mount;
 
 	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
 	if (!tempifp) {
 		error = XFS_ERROR(ENOMEM);
-		goto error0;
+		goto out;
 	}
 
 	sbp = &sxp->sx_stat;
@@ -157,25 +155,24 @@ xfs_swap_extents(
 	 */
 	xfs_lock_two_inodes(ip, tip, XFS_IOLOCK_EXCL);
 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
-	locked = 1;
 
 	/* Verify that both files have the same format */
 	if ((ip->i_d.di_mode & S_IFMT) != (tip->i_d.di_mode & S_IFMT)) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* Verify both files are either real-time or non-realtime */
 	if (XFS_IS_REALTIME_INODE(ip) != XFS_IS_REALTIME_INODE(tip)) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* Should never get a local format */
 	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
 	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	if (VN_CACHED(VFS_I(tip)) != 0) {
@@ -183,13 +180,13 @@ xfs_swap_extents(
 		error = xfs_flushinval_pages(tip, 0, -1,
 				FI_REMAPF_LOCKED);
 		if (error)
-			goto error0;
+			goto out_unlock;
 	}
 
 	/* Verify O_DIRECT for ftmp */
 	if (VN_CACHED(VFS_I(tip)) != 0) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* Verify all data are being swapped */
@@ -197,7 +194,7 @@ xfs_swap_extents(
 	    sxp->sx_length != ip->i_d.di_size ||
 	    sxp->sx_length != tip->i_d.di_size) {
 		error = XFS_ERROR(EFAULT);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/*
@@ -207,7 +204,7 @@ xfs_swap_extents(
 	 */
 	if ( XFS_IFORK_Q(ip) != XFS_IFORK_Q(tip) ) {
 		error = XFS_ERROR(EINVAL);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/*
@@ -222,7 +219,7 @@ xfs_swap_extents(
 	    (sbp->bs_mtime.tv_sec != ip->i_d.di_mtime.t_sec) ||
 	    (sbp->bs_mtime.tv_nsec != ip->i_d.di_mtime.t_nsec)) {
 		error = XFS_ERROR(EBUSY);
-		goto error0;
+		goto out_unlock;
 	}
 
 	/* We need to fail if the file is memory mapped.  Once we have tossed
@@ -233,7 +230,7 @@ xfs_swap_extents(
 	 */
 	if (VN_MAPPED(VFS_I(ip))) {
 		error = XFS_ERROR(EBUSY);
-		goto error0;
+		goto out_unlock;
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -256,8 +253,7 @@ xfs_swap_extents(
 		xfs_iunlock(ip,  XFS_IOLOCK_EXCL);
 		xfs_iunlock(tip, XFS_IOLOCK_EXCL);
 		xfs_trans_cancel(tp, 0);
-		locked = 0;
-		goto error0;
+		goto out;
 	}
 	xfs_lock_two_inodes(ip, tip, XFS_ILOCK_EXCL);
 
@@ -267,19 +263,15 @@ xfs_swap_extents(
 	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
 	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &aforkblks);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			goto error0;
-		}
+		if (error)
+			goto out_trans_cancel;
 	}
 	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
 	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK,
 			&taforkblks);
-		if (error) {
-			xfs_trans_cancel(tp, 0);
-			goto error0;
-		}
+		if (error)
+			goto out_trans_cancel;
 	}
 
 	/*
@@ -346,10 +338,10 @@ xfs_swap_extents(
 
 
 	IHOLD(ip);
-	xfs_trans_ijoin(tp, ip, lock_flags);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	IHOLD(tip);
-	xfs_trans_ijoin(tp, tip, lock_flags);
+	xfs_trans_ijoin(tp, tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 
 	xfs_trans_log_inode(tp, ip,  ilf_fields);
 	xfs_trans_log_inode(tp, tip, tilf_fields);
@@ -358,19 +350,19 @@ xfs_swap_extents(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC) {
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(tp);
-	}
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
-	locked = 0;
 
- error0:
-	if (locked) {
-		xfs_iunlock(ip,  lock_flags);
-		xfs_iunlock(tip, lock_flags);
-	}
-	if (tempifp != NULL)
-		kmem_free(tempifp);
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+out:
+	kmem_free(tempifp);
 	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp, 0);
+	goto out_unlock;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
