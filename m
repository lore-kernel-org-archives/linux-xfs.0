Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4AI2CQI195480 for <xfs@oss.sgi.com>; Sun, 10 May 2009 13:02:12 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFDF527631F
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 11:02:17 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id yIiIgKuW6uMqlMDj for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 11:02:17 -0700 (PDT)
Message-ID: <4A0716A8.1040108@sandeen.net>
Date: Sun, 10 May 2009 13:02:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] xfs: make inodes dirty before issuing I/O
References: <20090426140305.113371000@bombadil.infradead.org>
	<20090426140707.884922000@bombadil.infradead.org>
In-Reply-To: <20090426140707.884922000@bombadil.infradead.org>
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
> To make sure they get properly waited on in sync when I/O is in flight and
> we latter need to update the inode size.
> 

maybe mention the new helper in the changelog just for completeness...

> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-04-26 10:33:05.556127371 +0200
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-04-26 10:37:23.137953826 +0200
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

It strikes me as a little odd to potentially get back "isize == 0" here
when nothing about the size is 0.  Would it make more sense to rename
this variable to "new_isize" or something?

>  		ip->i_d.di_size = isize;
>  		ip->i_update_core = 1;
>  		ip->i_update_size = 1;
> @@ -405,10 +418,16 @@ xfs_submit_ioend_bio(
>  	struct bio	*bio)
>  {
>  	atomic_inc(&ioend->io_remaining);
> -
>  	bio->bi_private = ioend;
>  	bio->bi_end_io = xfs_end_bio;
>  
> +	/*
> +	 * if the I/O is beyond EOF we mark the inode dirty immediately
           ^If (uber-nitpick, in akpm-mode today I guess!)

> +	 * but don't update the inode size until I/O completion.
> +	 */

Maybe extend this comment a bit to say -why- you are doing this, not
just -what- you are doing?

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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
