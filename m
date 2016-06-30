Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 88A067CA0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 17:45:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2918AC002
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 15:45:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NDMIhxAJd1a6GMIh for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 15:44:59 -0700 (PDT)
Date: Fri, 1 Jul 2016 08:44:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160630224457.GT12670@dastard>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2016 at 08:53:49AM -0400, Brian Foster wrote:
> Newly allocated XFS metadata buffers are added to the LRU once the hold
> count is released, which typically occurs after I/O completion. There is
> no other mechanism at current that tracks the existence or I/O state of
> a new buffer. Further, readahead I/O tends to be submitted
> asynchronously by nature, which means the I/O can remain in flight and
> actually complete long after the calling context is gone. This means
> that file descriptors or any other holds on the filesystem can be
> released, allowing the filesystem to be unmounted while I/O is still in
> flight. When I/O completion occurs, core data structures may have been
> freed, causing completion to run into invalid memory accesses and likely
> to panic.
> 
> This problem is reproduced on XFS via directory readahead. A filesystem
> is mounted, a directory is opened/closed and the filesystem immediately
> unmounted. The open/close cycle triggers a directory readahead that if
> delayed long enough, runs buffer I/O completion after the unmount has
> completed.
> 
> To work around this problem, add readahead buffers to the LRU earlier
> than other buffers (when the buffer is allocated, specifically). The
> buffer hold count will ultimately remain until I/O completion, which
> means any shrinker activity will skip the buffer until then. This makes
> the buffer visible to xfs_wait_buftarg(), however, which ensures that an
> unmount or quiesce waits for I/O completion appropriately.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This addresses the problem reproduced by the recently posted xfstests
> test:
> 
>   http://thread.gmane.org/gmane.comp.file-systems.fstests/2740
> 
> This could probably be made more involved, i.e., to create another list
> of buffers in flight or some such. This seems more simple/sane to me,
> however, and survives my testing so far...
> 
> Brian
> 
>  fs/xfs/xfs_buf.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 4665ff6..3f03df9 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -590,8 +590,20 @@ xfs_buf_get_map(
>  		return NULL;
>  	}
>  
> +	/*
> +	 * If the buffer found doesn't match the one allocated above, somebody
> +	 * else beat us to insertion and we can toss the new one.
> +	 *
> +	 * If we did add the buffer and it happens to be readahead, add to the
> +	 * LRU now rather than waiting until the hold is released. Otherwise,
> +	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
> +	 * nothing else prevents an unmount before I/O completion.
> +	 */
>  	if (bp != new_bp)
>  		xfs_buf_free(new_bp);
> +	else if (flags & XBF_READ_AHEAD &&
> +		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
> +		atomic_inc(&bp->b_hold);

This doesn't sit right with me. The LRU is for "unused" objects, and
readahead objects are not unused until IO completes and nobody is
waiting on them.

As it is, this points out another problem with readahead buffers -
they aren't actually being cached properly because b_lru_ref == 0,
which means they are immediately reclaimed on IO completion rather
than being added to the LRU....

I also think that it's not sufficient to cover the generic case of
async IO that has no waiter. i.e. we could do get_buf, submit async
write, drop submitter reference, and now we have the same problem
but on a write.  i.e. this problem is and async IO issue, not a
readahead issue.

I think that it might be better to fix it by doing this:

	1. ensure async IO submission always has b_lru_ref set, and
	if it isn't, set it to 1. This ensures the buffer will be
	added to the LRU on completion if it isn't already there.

	2. keep a count of async buffer IO in progress. A per-cpu
	counter in the buftarg will be fine for this. Increment in
	xfs_buf_submit(), decrement in the xfs_buf_rele() call from
	xfs_buf_iodone() once we've determined if the buffer needs
	adding to the LRU or not.

	3. make xfs_wait_buftarg() wait until the async IO count
	goes to zero before it gives up trying to release buffers on
	the LRU.

That will ensure readahead buffers are cached, and we capture both
async read and async write buffers in xfs_wait_buftarg().

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
