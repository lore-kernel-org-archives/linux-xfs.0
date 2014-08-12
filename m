Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 315ED7F63
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 20:17:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5C06304032
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 18:17:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qaMW2Wn2wU4adZ2s for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 18:17:56 -0700 (PDT)
Date: Tue, 12 Aug 2014 11:17:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: don't zero partial page cache pages during
	O_DIRECT
Message-ID: <20140812011743.GU20518@dastard>
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

I added the WARN_ON_ONCE(ret) check to this and I am seeing it fire
occasionally. It always fires immediately before some other ASSERT()
they fires with a block map/page cache inconsistency. It usually
fires in a test that runs fsx or fsstress. The fsx failures are new
regressions caused by this patch. e.g. generic/263 hasn't failed for
months on any of my systems and this patch causes it to fail
reliably on my 1k block size test config.

I'm going to assume at this point that this is uncovering some other
existing bug, but it means I'm not going to push this fix until I
understand what is actually happening here. It is possible that what
I'm seeing is related to Brian's collapse range bug fixes, but until
I applied this direct IO patch I'd never seen fsx throw ASSERTs in
xfs_bmap_shift_extents()....

Either way, more testing and understanding is needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
