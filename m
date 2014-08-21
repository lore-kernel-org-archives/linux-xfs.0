Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8057A7F5D
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 08:09:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F06F8F804B
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 06:09:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ctrTrZI8dOjNNE8H (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 06:09:24 -0700 (PDT)
Date: Thu, 21 Aug 2014 09:09:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: use ranged writeback and invalidation for
	direct IO
Message-ID: <20140821130918.GE64112@bfoster.bfoster>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408597754-13526-5-git-send-email-david@fromorbit.com>
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
Cc: clm@fb.com, xfs@oss.sgi.com

On Thu, Aug 21, 2014 at 03:09:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now we are not doing silly things with dirtying buffers beyond EOF
> and using invalidation correctly, we can finally reduce the ranges of
> writeback and invalidation used by direct IO to match that of the IO
> being issued.
> 
> Bring the writeback and invalidation ranges back to match the
> generic direct IO code - this will greatly reduce the perturbation
> of cached data when direct IO and buffered IO are mixed, but still
> provide the same buffered vs direct IO coherency behaviour we
> currently have.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 19917fa..de5368c 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -291,7 +291,7 @@ xfs_file_read_iter(
>  		if (inode->i_mapping->nrpages) {
>  			ret = filemap_write_and_wait_range(
>  							VFS_I(ip)->i_mapping,
> -							pos, -1);
> +							pos, pos + size - 1);
>  			if (ret) {
>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
>  				return ret;
> @@ -303,7 +303,8 @@ xfs_file_read_iter(
>  			 * happen on XFS. Warn if it does fail.
>  			 */
>  			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> -						pos >> PAGE_CACHE_SHIFT, -1);
> +					pos >> PAGE_CACHE_SHIFT,
> +					(pos + size - 1) >> PAGE_CACHE_SHIFT);
>  			WARN_ON_ONCE(ret);
>  			ret = 0;
>  		}
> @@ -641,7 +642,7 @@ xfs_file_dio_aio_write(
>  
>  	if (mapping->nrpages) {
>  		ret = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
> -						    pos, -1);
> +						    pos, pos + count - 1);
>  		if (ret)
>  			goto out;
>  		/*
> @@ -650,7 +651,8 @@ xfs_file_dio_aio_write(
>  		 * happen on XFS. Warn if it does fail.
>  		 */
>  		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> -						pos >> PAGE_CACHE_SHIFT, -1);
> +					pos >> PAGE_CACHE_SHIFT,
> +					(pos + count - 1) >> PAGE_CACHE_SHIFT);
>  		WARN_ON_ONCE(ret);
>  		ret = 0;
>  	}
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
