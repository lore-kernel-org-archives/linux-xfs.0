Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C7707F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 08:08:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F24DD304048
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 06:08:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eCRsWUL89heUrWLY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 06:08:53 -0700 (PDT)
Date: Thu, 21 Aug 2014 09:08:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: don't zero partial page cache pages during
	O_DIRECT writes
Message-ID: <20140821130847.GC64112@bfoster.bfoster>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1408597754-13526-3-git-send-email-david@fromorbit.com>
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

On Thu, Aug 21, 2014 at 03:09:10PM +1000, Dave Chinner wrote:
> From: Chris Mason <clm@fb.com>
> 
> xfs is using truncate_pagecache_range to invalidate the page cache
> during DIO reads.  This is different from the other filesystems who
> only invalidate pages during DIO writes.
> 
> truncate_pagecache_range is meant to be used when we are freeing the
> underlying data structs from disk, so it will zero any partial
> ranges in the page.  This means a DIO read can zero out part of the
> page cache page, and it is possible the page will stay in cache.
> 
> buffered reads will find an up to date page with zeros instead of
> the data actually on disk.
> 
> This patch fixes things by using invalidate_inode_pages2_range
> instead.  It preserves the page cache invalidation, but won't zero
> any pages.
> 
> [dchinner: catch error and warn if it fails. Comment.]
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <clm@fb.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 076b170..827cfb2 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -296,7 +296,16 @@ xfs_file_read_iter(
>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
>  				return ret;
>  			}
> -			truncate_pagecache_range(VFS_I(ip), pos, -1);
> +
> +			/*
> +			 * Invalidate whole pages. This can return an error if
> +			 * we fail to invalidate a page, but this should never
> +			 * happen on XFS. Warn if it does fail.
> +			 */
> +			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> +						pos >> PAGE_CACHE_SHIFT, -1);
> +			WARN_ON_ONCE(ret);
> +			ret = 0;
>  		}
>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
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
