Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SNI1cJ183346 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 18:18:12 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 717DA3040D8
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 16:18:56 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 1/4] xfs: mark inodes dirty before issuing I/O
Date: Fri, 28 Aug 2009 18:17:43 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ABF2@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090827231557.717120121@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> From: Dave Chinner <david@fromorbit.com>
> 
> To make sure they get properly waited on in sync when I/O is in flight and
> we latter need to update the inode size.  Requires a new helper to check if an
> ioend structure is beyond the current EOF.
> 
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-08-26 20:06:07.105357325 -0300
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-08-26 20:08:09.017355358 -0300
> @@ -186,19 +186,37 @@ xfs_destroy_ioend(
>  }
> 
>  /*
> + * If the end of the current ioend is beyond the current EOF,
> + * return the new EOF value, otherwise zero.
> + */
> +STATIC xfs_fsize_t
> +xfs_ioend_new_eof(
> +	xfs_ioend_t		*ioend)
> +{
> +	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
> +	xfs_fsize_t		isize;
> +	xfs_fsize_t		bsize;
> +
> +	bsize = ioend->io_offset + ioend->io_size;
> +	isize = MAX(ip->i_size, ip->i_new_size);
> +	isize = MIN(isize, bsize);
> +	return isize > ip->i_d.di_size ? isize : 0;
> +}
> +
> +/*
>   * Update on-disk file size now that data has been written to disk.
>   * The current in-memory file size is i_size.  If a write is beyond
>   * eof i_new_size will be the intended file size until i_size is
>   * updated.  If this write does not extend all the way to the valid
>   * file size then restrict this update to the end of the write.
>   */
> +
>  STATIC void
>  xfs_setfilesize(
>  	xfs_ioend_t		*ioend)
>  {
>  	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
>  	xfs_fsize_t		isize;
> -	xfs_fsize_t		bsize;
> 
>  	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
>  	ASSERT(ioend->io_type != IOMAP_READ);
> @@ -206,14 +224,9 @@ xfs_setfilesize(
>  	if (unlikely(ioend->io_error))
>  		return;
> 
> -	bsize = ioend->io_offset + ioend->io_size;
> -
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -
> -	isize = MAX(ip->i_size, ip->i_new_size);
> -	isize = MIN(isize, bsize);
> -
> -	if (ip->i_d.di_size < isize) {
> +	isize = xfs_ioend_new_eof(ioend);
> +	if (isize) {
>  		ip->i_d.di_size = isize;
>  		xfs_mark_inode_dirty_sync(ip);
>  	}
> @@ -403,10 +416,16 @@ xfs_submit_ioend_bio(
>  	struct bio	*bio)
>  {
>  	atomic_inc(&ioend->io_remaining);
> -
>  	bio->bi_private = ioend;
>  	bio->bi_end_io = xfs_end_bio;
> 
> +	/*
> +	 * If the I/O is beyond EOF we mark the inode dirty immediately
> +	 * but don't update the inode size until I/O completion.
> +	 */
> +	if (xfs_ioend_new_eof(ioend))
> +		xfs_mark_inode_dirty_sync(XFS_I(ioend->io_inode));
> +
>  	submit_bio(WRITE, bio);
>  	ASSERT(!bio_flagged(bio, BIO_EOPNOTSUPP));
>  	bio_put(bio);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
