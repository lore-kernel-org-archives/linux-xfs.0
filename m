Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C7DC47FA8
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:10:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7350304059
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 08:10:47 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 1tKJDCcyRNMiPPRl (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 08:10:46 -0700 (PDT)
Date: Thu, 31 Oct 2013 08:10:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/30] db: rewrite IO engine to use libxfs
Message-ID: <20131031151046.GB7457@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-18-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 03:31:08PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have buffers and xfs_buf_maps, it is relatively easy to
> convert the IO engine to use libxfs routines. This gets rid of the
> most of the differences between mapped and straight buffer reads,
> and tracks xfs_bufs directly in the IO context that is being used.
> 
> This is not yet a perfect solution, as xfs_db does different sized
> IOs for the same block range which will throw warnings like:
> 
> xfs_db> inode 64
> 7ffff7fde740: Badness in key lookup (length)
> bp=(bno 0x40, len 8192 bytes) key=(bno 0x40, len 4096 bytes)
> xfs_db>

Maybe we should use uncached buffer I/O in xfs_db, similar to what we do
in the mount path in the kernel?

>  	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
> +	if (flags & LIBXFS_MOUNT_ROOTINOS)
> +		mp->m_flags |= LIBXFS_MOUNT_ROOTINOS;
> +
>  	mp->m_sb = *sb;
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
>  	sbp = &(mp->m_sb);
> @@ -866,6 +869,8 @@ libxfs_umount(xfs_mount_t *mp)
>  	int			agno;
>  
>  	libxfs_rtmount_destroy(mp);
> +	if ((mp->m_flags & LIBXFS_MOUNT_ROOTINOS) && mp->m_rootip)
> +		libxfs_iput(mp->m_rootip, 0);

Seems like the patch to remove m_rootip should go before this one?

> -struct xfs_buf *
> -libxfs_readbuf_map(struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps,
> -		int flags, const struct xfs_buf_ops *ops)
> +int
> +libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
> +		    struct xfs_buf_map *map, int nmaps, int flags)

Shouldn't these sort of changes go into a separate patch?


Otherwise looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
