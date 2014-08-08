Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EAFB7F73
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 10:18:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7DAE130404E
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 08:17:59 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id LUukCEMFX3aNZ2Yc
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 08:17:58 -0700 (PDT)
Message-ID: <53E4EA1C.6030009@fb.com>
Date: Fri, 8 Aug 2014 11:17:48 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't zero partial page cache pages during O_DIRECT
References: <53E4E03A.7050101@fb.com>
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>

On 08/08/2014 10:35 AM, Chris Mason wrote:
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

I stuck a cc: stable@vger.kernel.org after my sob, but then inserted a
giant test program.  Just realized the cc might get lost...sorry I
wasn't trying to sneak it in.

I've been trying to figure out why this bug doesn't show up in our 3.2
kernels but does show up now.  Today xfs does this:

     truncate_pagecache_range(VFS_I(ip), pos, -1);

But in 3.2 we did this:

     ret = -xfs_flushinval_pages(ip,
                              (iocb->ki_pos & PAGE_CACHE_MASK),
                              -1, FI_REMAPF_LOCKED);


Since we've done pos & PAGE_CACHE_MASK, the 3.2 code never sent a
partial offset.  So it never zero'd partial pages.

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
>  		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
>  	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
