Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 620057F89
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 19:36:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6518AC003
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 17:36:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7ihn50gHa5qb8Jbk for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 17:36:43 -0700 (PDT)
Date: Sat, 9 Aug 2014 10:36:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't zero partial page cache pages during O_DIRECT
Message-ID: <20140809003628.GE26465@dastard>
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

Historical oddity thanks to wrapper functions that were kept way
longer than they should have been.

> truncate_pagecache_range is meant to be used when we are freeing the
> underlying data structs from disk, so it will zero any partial ranges
> in the page.  This means a DIO read can zero out part of the page cache
> page, and it is possible the page will stay in cache.

commit fb59581 ("xfs: remove xfs_flushinval_pages").  also removed
the offset masks that seem to be the issue here. Classic case of a
regression caused by removing 10+ year old code that was not clearly
documented and didn't appear important.

The real question is why isn't fsx and other corner case data
integrity tools tripping over this?

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

Encapsulate it in a generic xfstest, please, and send it to
fstests@vger.kernel.org.

...

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

I guarantee you that there are applications out there that rely on
the implicit invalidation behaviour for performance. There are also
applications out that rely on it for correctness, too, because the
OS is not the only source of data in the filesystem the OS has
mounted.

Besides, XFS's direct IO semantics are far saner, more predictable
and hence are more widely useful than the generic code. As such,
we're not going to regress semantics that have been unchanged
over 20 years just to match whatever insanity the generic Linux code
does right now.

Go on, call me a deranged monkey on some serious mind-controlling
substances. I don't care. :)

I think the fix should probably just be:

-			truncate_pagecache_range(VFS_I(ip), pos, -1);
+			invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+					pos >> PAGE_CACHE_SHIFT, -1);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
