Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2328A7F4E
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 08:29:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E66018F8059
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 06:29:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LQfHpExHioFPUH9Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 06:29:30 -0700 (PDT)
Date: Mon, 11 Aug 2014 09:29:19 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: don't zero partial page cache pages during
	O_DIRECT
Message-ID: <20140811132919.GB1186@bfoster.bfoster>
References: <53E4E03A.7050101@fb.com>
 <53E61A9C.4020807@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53E61A9C.4020807@fb.com>
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
To: Chris Mason <clm@fb.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Sat, Aug 09, 2014 at 08:57:00AM -0400, Chris Mason wrote:
> 
> xfs is using truncate_pagecache_range to invalidate the page cache
> during DIO reads.  This is different from the other filesystems who only
> invalidate pages during DIO writes.
> 
> truncate_pagecache_range is meant to be used when we are freeing the
> underlying data structs from disk, so it will zero any partial ranges in
> the page.  This means a DIO read can zero out part of the page cache
> page, and it is possible the page will stay in cache.
> 
> buffered reads will find an up to date page with zeros instead of the
> data actually on disk.
> 
> This patch fixes things by using invalidate_inode_pages2_range instead.
> It preserves the page cache invalidation, but won't zero any pages.
> 
> Signed-off-by: Chris Mason <clm@fb.com>
> cc: stable@vger.kernel.org
> 
> ---

I can't say I grok the risk of removing the invalidation entirely, but
this is certainly a more isolated fix:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1f66779..023d575 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -295,7 +295,8 @@ xfs_file_read_iter(
>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
>  				return ret;
>  			}
> -			truncate_pagecache_range(VFS_I(ip), pos, -1);
> +			invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> +					      pos >> PAGE_CACHE_SHIFT, -1);
>  		}
>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  	}
> -- 
> 1.8.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
