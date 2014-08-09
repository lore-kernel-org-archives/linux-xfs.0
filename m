Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A06287F8C
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 19:49:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49BD4AC003
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 17:49:13 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kGtUTAvS8lbwuKbR for <xfs@oss.sgi.com>;
	Fri, 08 Aug 2014 17:49:10 -0700 (PDT)
Date: Sat, 9 Aug 2014 10:48:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] xfs: use invalidate_inode_pages2_range for DIO writes
Message-ID: <20140809004857.GF26465@dastard>
References: <53E4E03A.7050101@fb.com>
 <53E4F518.9030107@fb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53E4F518.9030107@fb.com>
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

On Fri, Aug 08, 2014 at 12:04:40PM -0400, Chris Mason wrote:
> 
> xfs is using truncate_pagecache_range to invalidate the page cache
> during DIO writes.  The other filesystems are calling
> invalidate_inode_pages2_range
>  
> truncate_pagecache_range is meant to be used when we are freeing the
> underlying data structs from disk, so it will zero any partial ranges
> in the page.  This means a DIO write can zero out part of the page cache
> page, and it is possible the page will stay in cache.
> 
> This one is an RFC because it is untested and because I don't understand
> how XFS is dealing with pages the truncate was unable to clear away.
> I'm not able to actually trigger zeros by mixing DIO writes with
> buffered reads.
> 
> Signed-off-by: Chris Mason <clm@fb.com>
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 8d25d98..c30c112 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -638,7 +638,10 @@ xfs_file_dio_aio_write(
>  						    pos, -1);
>  		if (ret)
>  			goto out;
> -		truncate_pagecache_range(VFS_I(ip), pos, -1);
> +
> +		/* what do we do if we can't invalidate the pages? */
> +		invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
> +					      pos >> PAGE_CACHE_SHIFT, -1);

I don't think it can on XFS.

We're holding the XFS_IOLOCK_EXCL, so no other syscall based IO can
dirty pages, all the pages are clean, try_to_free_buffers() will
never fail, no-one can run a truncate operation concurently, and
so on.

The only thing that could cause an issue is a racing mmap page fault
dirtying the page. But if you are mixing mmap+direct IO on the same
file, you lost a long time ago so that's nothing new at all.

So, I'd just do:

		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
						pos >> PAGE_CACHE_SHIFT, -1);
		WARN_ON_ONCE(ret);
		ret = 0;

That way we'll find out if it does ever fail, and if it does we can
take it from there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
