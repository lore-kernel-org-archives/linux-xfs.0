Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbeKTSk1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 13:40:27 -0500
Date: Tue, 20 Nov 2018 00:12:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: zero length symlinks are not valid
Message-ID: <20181120081235.GA30481@infradead.org>
References: <20181119210459.8506-1-david@fromorbit.com>
 <20181119210459.8506-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119210459.8506-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>  	/*
> -	 * Lock the inode, fix the size, and join it to the transaction.
> -	 * Hold it so in the normal path, we still have it locked for
> -	 * the second transaction.  In the error paths we need it
> +	 * Lock the inode, fix the size, turn it into a regular file and join it
> +	 * to the transaction.  Hold it so in the normal path, we still have it
> +	 * locked for the second transaction.  In the error paths we need it
>  	 * held so the cancel won't rele it, see below.
>  	 */

Most of this comment seems rather pointless as it explains the how and
not the why.  Additionally it is out of data (we don't hold inodes for
transactions anymore), and partially below the code it claims to
document.  Given that you explain the why pretty well in the top of the
function document I'd drop this entirely.

> +	/*
> +	 * Inline fork state gets removed by xfs_difree() so we have nothing to
> +	 * do here in that case.
> +	 */
>  	if (ip->i_df.if_flags & XFS_IFINLINE) {
> -		if (ip->i_df.if_bytes > 0) 
> -			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
> -					  XFS_DATA_FORK);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		ASSERT(ip->i_df.if_bytes == 0);
>  		return 0;
>  	}

The ilock here is rather pointless now that we do nothing underneath
it but checking two different integral values.

Something like this additional cleanup might be nice now, with
the function split being rather pointless now:

diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b2c1177c717f..8e2e12e34098 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -386,29 +386,41 @@ xfs_symlink(
  * userspace cannot find this inode anymore, so this change is not user visible
  * but allows us to catch corrupt zero-length symlinks in the verifiers.
  */
-STATIC int
-xfs_inactive_symlink_rmt(
-	struct xfs_inode *ip)
+
+int
+xfs_inactive_symlink(
+	struct xfs_inode	*ip)
 {
-	xfs_buf_t	*bp;
-	int		done;
-	int		error;
-	int		i;
-	xfs_mount_t	*mp;
-	xfs_bmbt_irec_t	mval[XFS_SYMLINK_MAPS];
-	int		nmaps;
-	int		size;
-	xfs_trans_t	*tp;
-
-	mp = ip->i_mount;
-	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	int			done;
+	int			error;
+	int			i;
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	int			nmaps;
+	int			size;
+	struct xfs_trans	*tp;
+
+	trace_xfs_inactive_symlink(ip);
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	ASSERT(ip->i_d.di_size > 0 && ip->i_d.di_size <= XFS_SYMLINK_MAXLEN);
+
 	/*
-	 * We're freeing a symlink that has some
-	 * blocks allocated to it.  Free the
-	 * blocks here.  We know that we've got
-	 * either 1 or 2 extents and that we can
-	 * free them all in one bunmapi call.
+	 * Inline fork state gets removed by xfs_difree() so we have nothing to
+	 * do here in that case.
 	 */
+	if (ip->i_df.if_flags & XFS_IFINLINE)
+		return 0;
+
+	/*
+	 * We're freeing a symlink that has some blocks allocated to it.  Free
+	 * the blocks here.  We know that we've got either 1 or 2 extents and
+	 * that we can free them all in one bunmapi call.
+	 */
+	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
 	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
@@ -419,10 +431,7 @@ xfs_inactive_symlink_rmt(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
-	 * Lock the inode, fix the size, turn it into a regular file and join it
-	 * to the transaction.  Hold it so in the normal path, we still have it
-	 * locked for the second transaction.  In the error paths we need it
-	 * held so the cancel won't rele it, see below.
+	 * Fix the size, turn it into a regular file in the same transaction.
 	 */
 	size = (int)ip->i_d.di_size;
 	ip->i_d.di_size = 0;
@@ -485,45 +494,3 @@ xfs_inactive_symlink_rmt(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
-
-/*
- * xfs_inactive_symlink - free a symlink
- */
-int
-xfs_inactive_symlink(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	int			pathlen;
-
-	trace_xfs_inactive_symlink(ip);
-
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return -EIO;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	pathlen = (int)ip->i_d.di_size;
-	ASSERT(pathlen);
-
-	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
-		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
-			 __func__, (unsigned long long)ip->i_ino, pathlen);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Inline fork state gets removed by xfs_difree() so we have nothing to
-	 * do here in that case.
-	 */
-	if (ip->i_df.if_flags & XFS_IFINLINE) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		return 0;
-	}
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	/* remove the remote symlink */
-	return xfs_inactive_symlink_rmt(ip);
-}
