Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62A2D7F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 08:09:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 42A468F804B
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 06:09:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GCJXXyST8W402qmi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 06:09:17 -0700 (PDT)
Date: Thu, 21 Aug 2014 09:09:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs: don't zero partial page cache pages during
	O_DIRECT writes
Message-ID: <20140821130910.GD64112@bfoster.bfoster>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408597754-13526-4-git-send-email-david@fromorbit.com>
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

On Thu, Aug 21, 2014 at 03:09:11PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to direct IO reads, direct IO writes are using
> truncate_pagecache_range to invalidate the page cache. This is
> incorrect due to the sub-block zeroing in the page cache that
> truncate_pagecache_range() triggers.
> 
> This patch fixes things by using invalidate_inode_pages2_range
> instead.  It preserves the page cache invalidation, but won't zero
> any pages.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 827cfb2..19917fa 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -644,7 +644,15 @@ xfs_file_dio_aio_write(
>  						    pos, -1);
>  		if (ret)
>  			goto out;
> -		truncate_pagecache_range(VFS_I(ip), pos, -1);
> +		/*
> +		 * Invalidate whole pages. This can return an error if
> +		 * we fail to invalidate a page, but this should never
> +		 * happen on XFS. Warn if it does fail.
> +		 */
> +		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> +						pos >> PAGE_CACHE_SHIFT, -1);
> +		WARN_ON_ONCE(ret);
> +		ret = 0;
>  	}
>  
>  	/*
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
