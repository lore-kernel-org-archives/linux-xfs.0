Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 509ED29DFB
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 15:22:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D02C8F8089
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 13:22:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Tf77NxbRqXnOsfIa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 13:22:26 -0700 (PDT)
Date: Fri, 10 Apr 2015 16:22:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: using generic_file_direct_write() is unnecessary
Message-ID: <20150410202222.GE2846@laptop.bfoster>
References: <1428673080-23052-1-git-send-email-david@fromorbit.com>
	<1428673080-23052-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1428673080-23052-6-git-send-email-david@fromorbit.com>
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

On Fri, Apr 10, 2015 at 11:38:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic_file_direct_write() does all sorts of things to make DIO
> work "sorta ok" with mixed buffered IO workloads. We already do
> most of this work in xfs_file_aio_dio_write() because of the locking
> requirements, so there's only a couple of things it does for us.
> 
> The first thing is that it does a page cache invalidation after the
> ->direct_IO callout. This can easily be added to the XFS code.
> 
> The second thing it does is that if data was written, it updates the
> iov_iter structure to reflect the data written, and then does EOF
> size updates if necessary. For XFS, these EOF size updates are now
> not necessary, as we do them safely and race-free in IO completion
> context. That leaves just the iov_iter update, and that's also exily
> moved to the XFS code.
> 
> The result is that we don't need to call
> generic_file_direct_write(), and hence remove a redundant buffered
> writeback call and a redundant page cache invalidation call from the
> DIO submission path. We also remove a racy EOF size update, and make
> the DIO submission code in XFS much easier to follow. Wins all
> round, really.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Seems fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7b872f4..7182cd2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -665,6 +665,8 @@ xfs_file_dio_aio_write(
>  	int			iolock;
>  	size_t			count = iov_iter_count(from);
>  	loff_t			pos = iocb->ki_pos;
> +	loff_t			end;
> +	struct iov_iter		data;
>  	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
>  					mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> @@ -704,10 +706,11 @@ xfs_file_dio_aio_write(
>  	if (ret)
>  		goto out;
>  	iov_iter_truncate(from, count);
> +	end = pos + count - 1;
>  
>  	if (mapping->nrpages) {
>  		ret = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> -						    pos, pos + count - 1);
> +						   pos, end);
>  		if (ret)
>  			goto out;
>  		/*
> @@ -717,7 +720,7 @@ xfs_file_dio_aio_write(
>  		 */
>  		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
>  					pos >> PAGE_CACHE_SHIFT,
> -					(pos + count - 1) >> PAGE_CACHE_SHIFT);
> +					end >> PAGE_CACHE_SHIFT);
>  		WARN_ON_ONCE(ret);
>  		ret = 0;
>  	}
> @@ -734,8 +737,22 @@ xfs_file_dio_aio_write(
>  	}
>  
>  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> -	ret = generic_file_direct_write(iocb, from, pos);
>  
> +	data = *from;
> +	ret = mapping->a_ops->direct_IO(WRITE, iocb, &data, pos);
> +
> +	/* see generic_file_direct_write() for why this is necessary */
> +	if (mapping->nrpages) {
> +		invalidate_inode_pages2_range(mapping,
> +					      pos >> PAGE_CACHE_SHIFT,
> +					      end >> PAGE_CACHE_SHIFT);
> +	}
> +
> +	if (ret > 0) {
> +		pos += ret;
> +		iov_iter_advance(from, ret);
> +		iocb->ki_pos = pos;
> +	}
>  out:
>  	xfs_rw_iunlock(ip, iolock);
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
