Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Aug 2008 15:08:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7FM8fcW022723
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:08:41 -0700
Date: Fri, 15 Aug 2008 18:09:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Prevent direct I/O from mapping extents beyond eof
Message-ID: <20080815220958.GB13770@infradead.org>
References: <48A50152.8020104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A50152.8020104@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org

On Fri, Aug 15, 2008 at 02:08:50PM +1000, Lachlan McIlroy wrote:
> With the help from some tracing I found that we try to map extents beyond
> eof when doing a direct I/O read.  It appears that the way to inform the
> generic direct I/O path (ie do_direct_IO()) that we have breached eof is
> to return an unmapped buffer from xfs_get_blocks_direct().  This will cause
> do_direct_IO() to jump to the hole handling code where is will check for
> eof and then abort.
>
> This problem was found because a direct I/O read was trying to map beyond
> eof and was encountering delayed allocations.  The delayed allocations beyond
> eof are speculative allocations and they didn't get converted when the direct
> I/O flushed the file because there was only enough space in the current AG
> to convert and write out the dirty pages within eof.  Note that
> xfs_iomap_write_allocate() wont necessarily convert all the delayed allocation
> passed to it - it will return after allocating the first extent - so if the
> delayed allocation extends beyond eof then it will stay that way.
>
> This change will detect a direct I/O read beyond eof:

The change looks good to me, but I really think the direct I/O could
should never send down requests like this down to the filesystems.  akpm
and -fsdevel Cc'ed.

> --- a/fs/xfs/linux-2.6/xfs_aops.c	2008-08-15 13:30:03.000000000 +1000
> +++ b/fs/xfs/linux-2.6/xfs_aops.c	2008-08-11 16:51:07.000000000 +1000
> @@ -1338,6 +1338,10 @@ __xfs_get_blocks(
> 	offset = (xfs_off_t)iblock << inode->i_blkbits;
> 	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
> 	size = bh_result->b_size;
> +
> +	if (!create && direct && offset >= i_size_read(inode))
> +		return 0;
> +
> 	error = xfs_iomap(XFS_I(inode), offset, size,
> 			     create ? flags : BMAPI_READ, &iomap, &niomap);
> 	if (error)
>
>
---end quoted text---
