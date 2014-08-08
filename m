Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E17D17F73
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 15:39:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3783304059
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 13:39:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id H3n6n0N95JEaQbG6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 13:39:42 -0700 (PDT)
Date: Fri, 8 Aug 2014 16:39:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't zero partial page cache pages during O_DIRECT
Message-ID: <20140808203928.GA64279@bfoster.bfoster>
References: <53E4E03A.7050101@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53E4E03A.7050101@fb.com>
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

On Fri, Aug 08, 2014 at 10:35:38AM -0400, Chris Mason wrote:
> 
> xfs is using truncate_pagecache_range to invalidate the page cache
> during DIO reads.  This is different from the other filesystems who only
> invalidate pages during DIO writes.
> 
> truncate_pagecache_range is meant to be used when we are freeing the
> underlying data structs from disk, so it will zero any partial ranges
> in the page.  This means a DIO read can zero out part of the page cache
> page, and it is possible the page will stay in cache.
> 
> buffered reads will find an up to date page with zeros instead of the
> data actually on disk.
> 
> This patch fixes things by leaving the page cache alone during DIO
> reads.
> 
> We discovered this when our buffered IO program for distributing
> database indexes was finding zero filled blocks.  I think writes
> are broken too, but I'll leave that for a separate patch because I don't
> fully understand what XFS needs to happen during a DIO write.
> 
> Test program:
> 
...
> 
> Signed-off-by: Chris Mason <clm@fb.com>
> cc: stable@vger.kernel.org
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 1f66779..8d25d98 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -295,7 +295,11 @@ xfs_file_read_iter(
>  				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
>  				return ret;
>  			}
> -			truncate_pagecache_range(VFS_I(ip), pos, -1);
> +
> +			/* we don't remove any pages here.  A direct read
> +			 * does not invalidate any contents of the page
> +			 * cache
> +			 */
>  		}

That seems sane to me at first glance. I don't know why we would need to
completely kill the cache on a dio read. I'm not a fan of the additional
comment though. We should probably just fix up the existing comment
instead. It also seems like we might be able to kill the XFS_IOLOCK_EXCL
dance here if the truncate goes away.. Dave?

FWIW, I had to go back to the following commit to see where this
originates from:

commit 9cea236492ebabb9545564eb039aa0f477a05c96
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Mar 17 17:26:41 2006 +1100

    [XFS] Flush and invalidate dirty pages at the start of a direct read also,
    else we can hit a delalloc-extents-via-direct-io BUG.
    
    SGI-PV: 949916
    SGI-Modid: xfs-linux-melb:xfs-kern:25483a
    
    Signed-off-by: Nathan Scott <nathans@sgi.com>
    ...

That adds a VOP_FLUSHINVAL_PAGES() call that looks like it's some kind
of portability API. I would expect the flush to deal with any delalloc
conversion issues vs. the invalidation, so perhaps the invalidation part
is a historical artifact of the api. Then again, there's also a straight
'flushpages' call so perhaps there's more to it than that.

Brian

>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  	}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
