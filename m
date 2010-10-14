Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EHMC8q056639 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 12:22:12 -0500
Subject: Re: [PATCH 1/2] xfs: dynamic speculative EOF preallocation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1286187236-16682-2-git-send-email-david@fromorbit.com>
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
	<1286187236-16682-2-git-send-email-david@fromorbit.com>
Date: Thu, 14 Oct 2010 12:22:45 -0500
Message-ID: <1287076965.2362.520.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2010-10-04 at 21:13 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the size of the speculative preallocation during delayed
> allocation is fixed by either the allocsize mount option of a
> default size. We are seeing a lot of cases where we need to
> recommend using the allocsize mount option to prevent fragmentation
> when buffered writes land in the same AG.
> 
> Rather than using a fixed preallocation size by default (up to 64k),
> make it dynamic by exponentially increasing it on each subsequent
> preallocation. This will result in the preallocation size increasing
> as the file increases, so for streaming writes we are much more
> likely to get large preallocations exactly when we need it to reduce
> fragementation. It should also prevent the need for using the
> allocsize mount option for most workloads involving concurrent
> streaming writes.

I have some comments, below.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

. . .

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 2057614..b2e4782 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c

. . .

> @@ -427,11 +431,25 @@ xfs_iomap_eof_want_preallocate(
>  			if ((imap[n].br_startblock != HOLESTARTBLOCK) &&
>  			    (imap[n].br_startblock != DELAYSTARTBLOCK))
>  				return 0;
> +
>  			start_fsb += imap[n].br_blockcount;
>  			count_fsb -= imap[n].br_blockcount;
> +
> +			/* count delalloc blocks beyond EOF */
> +			if (imap[n].br_startblock == DELAYSTARTBLOCK)
> +				found_delalloc += imap[n].br_blockcount;
>  		}
>  	}
> -	*prealloc = 1;

At this point, count_fsb will be 0 (a necessary condition
for loop termination, since count_fsb is unsigned).  Since
found_delalloc is initially 0 (and is also unsigned), we
can safely assume that found_delalloc >= count_fsb.  The
only case in which found_delalloc <= count_fsb is if
found_delalloc is also 0 (a case you cover separately,
first, below).

Furthermore, *prealloc was assigned the value 0 at the top.
So I think this bottom section can be simplified to:
	if (!found_delalloc)
		*prealloc = 1;

But if that's the case, then maybe the loop can simply
return as soon as it finds a delayed allocation entry.

In other words, the net effect of this is that you
only tell the caller we want preallocation if *no*
preallocated blocks beyond EOF exist.  That may be
fine, but it doesn't seem to match your understanding
based on your code, so I just wanted to call your
attention to it.

> +	if (!found_delalloc) {
> +		/* haven't got any prealloc, so need some */
> +		*prealloc = 1;
> +	} else if (found_delalloc <= count_fsb) {
> +		/* almost run out of prealloc */
> +		*prealloc = 1;
> +	} else {
> +		/* still lots of prealloc left */
> +		*prealloc = 0;
> +	}
>  	return 0;
>  }
>  
> @@ -469,6 +487,7 @@ xfs_iomap_write_delay(
>  	extsz = xfs_get_extsz_hint(ip);
>  	offset_fsb = XFS_B_TO_FSBT(mp, offset);
>  
> +

This is hunk should be killed.  It just adds an unwanted
blank line.

>  	error = xfs_iomap_eof_want_preallocate(mp, ip, offset, count,
>  				ioflag, imap, XFS_WRITE_IMAPS, &prealloc);
>  	if (error)
> @@ -476,9 +495,25 @@ xfs_iomap_write_delay(
>  
>  retry:
>  	if (prealloc) {
> +		xfs_fileoff_t	alloc_blocks = 0;
> +		/*
> +		 * If we don't have a user specified preallocation size, dynamically
> +		 * increase the preallocation size as we do more preallocation.
> +		 * Cap the maximum size at a single extent.
> +		 */
> +		if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {

I note that this is circumventing the special code in
xfs_set_rw_sizes() that tries to set up a different (smaller)
size in the event the "sync" (generic) mount option was supplied
(indicated by XFS_MOUNT_SYNC).  If that is a good thing, then I
suggest the code in xfs_set_rw_sizes() go away.  But it would be
good to have the case for making that change stated.

> +			alloc_blocks = XFS_FILEOFF_MIN(MAXEXTLEN,
> +						(ip->i_last_prealloc * 4));
> +		}

So this is the spot that begs the question of whether the
the default I/O size mount option is needed any more.  The
net effect of your change (assuming no "allocsize" mount
option is in effect) is:
- Initially, ip->i_last_prealloc will be 0.  Therefore the
  first time through, the preallocated blocks beyond the
  end will be based on m_writeio_blocks (either 16KB or
  64KB, dependent on whether XFS_MOUNT_WSYNC was specified).
- Thereafter, whenever more preallocated-at-EOF blocks
  are needed, the number allocated will be 4 times more
  than the last time (growing exponentially), limited by
  the maximum extent size.

I guess the reason one might want the "allocsize" mount
option now becomes the opposite of why one might have
wanted it before.  I.e., it would be used to *reduce*
the size of the preallocated range beyond EOF, which I
could envision might be reasonable in some circumstances.

> +		if (alloc_blocks == 0)
> +			alloc_blocks = mp->m_writeio_blocks;
> +		ip->i_last_prealloc = alloc_blocks;
> +
>  		aligned_offset = XFS_WRITEIO_ALIGN(mp, (offset + count - 1));
>  		ioalign = XFS_B_TO_FSBT(mp, aligned_offset);
> -		last_fsb = ioalign + mp->m_writeio_blocks;
> +		last_fsb = ioalign + alloc_blocks;
> +		printk("ino %lld, ioalign 0x%llx, alloc_blocks 0x%llx\n",
> +				ip->i_ino, ioalign, alloc_blocks);

Kill the debug printk() call.

>  	} else {
>  		last_fsb = XFS_B_TO_FSB(mp, ((xfs_ufsize_t)(offset + count)));
>  	}



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
