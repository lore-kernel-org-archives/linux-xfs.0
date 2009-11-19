Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAJ4aFNj234056 for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 22:36:16 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C91099A2D6
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:36:38 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id H5sbKFz5Yh7gSuVu for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2009 20:36:38 -0800 (PST)
Message-ID: <4B04CB54.9060308@sandeen.net>
Date: Wed, 18 Nov 2009 22:36:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/7] xfs: remove IO_ISAIO
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.238873282@bombadil.infradead.org>
In-Reply-To: <20091114161801.238873282@bombadil.infradead.org>
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

Looks fine to me.

> We set this flag for all read/write I/O since early Linux 2.6.x.
> Remove it as it has lost it's purpose long ago.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
> Index: xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2009-10-11 14:25:17.496003686 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_file.c	2009-11-12 17:14:06.160023109 +0100
> @@ -52,7 +52,7 @@ xfs_file_aio_read(
>  	loff_t			pos)
>  {
>  	struct file		*file = iocb->ki_filp;
> -	int			ioflags = IO_ISAIO;
> +	int			ioflags = 0;
>  
>  	BUG_ON(iocb->ki_pos != pos);
>  	if (unlikely(file->f_flags & O_DIRECT))
> @@ -71,7 +71,7 @@ xfs_file_aio_write(
>  	loff_t			pos)
>  {
>  	struct file		*file = iocb->ki_filp;
> -	int			ioflags = IO_ISAIO;
> +	int			ioflags = 0;
>  
>  	BUG_ON(iocb->ki_pos != pos);
>  	if (unlikely(file->f_flags & O_DIRECT))
> Index: xfs/fs/xfs/linux-2.6/xfs_lrw.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2009-11-12 17:10:19.909278501 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_lrw.c	2009-11-12 17:14:06.161003891 +0100
> @@ -255,8 +255,6 @@ xfs_read(
>  
>  	iocb->ki_pos = *offset;
>  	ret = generic_file_aio_read(iocb, iovp, segs, *offset);
> -	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
> -		ret = wait_on_sync_kiocb(iocb);
>  	if (ret > 0)
>  		XFS_STATS_ADD(xs_read_bytes, ret);
>  
> @@ -774,9 +772,6 @@ write_retry:
>  
>  	current->backing_dev_info = NULL;
>  
> -	if (ret == -EIOCBQUEUED && !(ioflags & IO_ISAIO))
> -		ret = wait_on_sync_kiocb(iocb);
> -
>  	isize = i_size_read(inode);
>  	if (unlikely(ret < 0 && ret != -EFAULT && *offset > isize))
>  		*offset = isize;
> Index: xfs/fs/xfs/linux-2.6/xfs_vnode.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2009-11-12 17:10:19.942276910 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_vnode.h	2009-11-12 17:14:06.161003891 +0100
> @@ -36,7 +36,6 @@ struct attrlist_cursor_kern;
>  /*
>   * Flags for read/write calls - same values as IRIX
>   */
> -#define IO_ISAIO	0x00001		/* don't wait for completion */
>  #define IO_ISDIRECT	0x00004		/* bypass page cache */
>  #define IO_INVIS	0x00020		/* don't update inode timestamps */
>  
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
