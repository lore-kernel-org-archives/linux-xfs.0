Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 663BF7F54
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 14:31:29 -0500 (CDT)
Message-ID: <51C35891.7000501@sgi.com>
Date: Thu, 20 Jun 2013 14:31:29 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/60] xfs: don't use speculative prealloc for small files
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
	<1371617468-32559-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/18/13 23:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Dedicated small file workloads have been seeing significant free
> space fragmentation causing premature inode allocation failure
> when large inode sizes are in use. A particular test case showed
> that a workload that runs to a real ENOSPC on 256 byte inodes would
> fail inode allocation with ENOSPC about about 80% full with 512 byte
> inodes, and at about 50% full with 1024 byte inodes.
>
> The same workload, when run with -o allocsize=4096 on 1024 byte
> inodes would run to being 100% full before giving ENOSPC. That is,
> no freespace fragmentation at all.
>
> The issue was caused by the specific IO pattern the application had
> - the framework it was using did not support direct IO, and so it
> was emulating it by using fadvise(DONT_NEED). The result was that
> the data was getting written back before the speculative prealloc
> had been trimmed from memory by the close(), and so small single
> block files were being allocated with 2 blocks, and then having one
> truncated away. The result was lots of small 4k free space extents,
> and hence each new 8k allocation would take another 8k from
> contiguous free space and turn it into 4k of allocated space and 4k
> of free space.
>
> Hence inode allocation, which requires contiguous, aligned
> allocation of 16k (256 byte inodes), 32k (512 byte inodes) or 64k
> (1024 byte inodes) can fail to find sufficiently large freespace and
> hence fail while there is still lots of free space available.
>
> There's a simple fix for this, and one that has precendence in the
> allocator code already - don't do speculative allocation unless the
> size of the file is larger than a certain size. In this case, that
> size is the minimum default preallocation size:
> mp->m_writeio_blocks. And to keep with the concept of being nice to
> people when the files are still relatively small, cap the prealloc
> to mp->m_writeio_blocks until the file goes over a stripe unit is
> size, at which point we'll fall back to the current behaviour based
> on the last extent size.
>
> This will effectively turn off speculative prealloc for very small
> files, keep preallocation low for small files, and behave as it
> currently does for any file larger than a stripe unit. This
> completely avoids the freespace fragmentation problem this
> particular IO pattern was causing.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

I agree with Brian, it looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
