Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41CD97F7C
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 18:13:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 13DFA8F8073
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 16:13:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BF2Rz2nhlRJdRTHC for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2015 16:13:17 -0700 (PDT)
Date: Wed, 10 Jun 2015 09:12:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150609231244.GR9143@dastard>
References: <CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard> <20150604012530.GG9143@dastard>
	<20150604020339.GI9143@dastard> <20150604062337.GK9143@dastard>
	<CABppvi5wNHA18nY497YK0fj4GU+3VLC8VntQ1JKNDR6EErrKxg@mail.gmail.com>
	<CABppvi7ccK_QVubBhG18P6Xp-xXirUHQc+Wd4+EdTStLPqbQRg@mail.gmail.com>
	<CABppvi5K1CZgHqbJqA_MhwnL76QQ77Lkc2vA4C0HPgMx50rn3A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi5K1CZgHqbJqA_MhwnL76QQ77Lkc2vA4C0HPgMx50rn3A@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 08, 2015 at 02:56:10PM -0700, Shrinand Javadekar wrote:
> I gave this another shot after understanding it better. I now have a
> version that doesn't crash. I'm attaching the diff and the new
> xfs_buf.c file.
> However, in the new version the io_list list doesn't get populated at
> all in __xfs_buf_delwri_submit(). I haven't completely familiarized
> myself with what callers do with this list. Callers initialize this
> list and send a pointer to __xfs_buf_delwri_submit() and expect a
> populated list back.

Better to send diffs than the entire file...

I'd also prefer that you don't top post, because it makes it hard to
follow the thread and comment on the relevant issues...

> Nonetheless, I ran my experiments after building and inserting the XFS
> module with this change. Strangely enough, I see the performance going
> down by ~25% compared to the original XFS module.

So perhaps you are seeing a different problem.

....

> /*
>  * Add a buffer to the delayed write list.
>  *
>  * This queues a buffer for writeout if it hasn't already been.  Note that
>  * neither this routine nor the buffer list submission functions perform
>  * any internal synchronization.  It is expected that the lists are thread-local
>  * to the callers.
>  *
>  * Returns true if we queued up the buffer, or false if it already had
>  * been on the buffer list.
>  */
> bool
> xfs_buf_delwri_queue(
> 	struct xfs_buf		*bp,
> 	struct list_head	*list)
> {
> 	ASSERT(xfs_buf_islocked(bp));
> 	ASSERT(!(bp->b_flags & XBF_READ));
> 
> 	/*
> 	 * If the buffer is already marked delwri it already is queued up
> 	 * by someone else for imediate writeout.  Just ignore it in that
> 	 * case.
> 	 */
> 	if (bp->b_flags & _XBF_DELWRI_Q) {
> 		trace_xfs_buf_delwri_queued(bp, _RET_IP_);
> 		return false;
> 	}
> 
> 	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
> 
> 	/*
> 	 * If a buffer gets written out synchronously or marked stale while it
> 	 * is on a delwri list we lazily remove it. To do this, the other party
> 	 * clears the  _XBF_DELWRI_Q flag but otherwise leaves the buffer alone.
> 	 * It remains referenced and on the list.  In a rare corner case it
> 	 * might get readded to a delwri list after the synchronous writeout, in
> 	 * which case we need just need to re-add the flag here.
> 	 */
> 	bp->b_flags |= _XBF_DELWRI_Q;
> 	if (list_empty(&bp->b_list)) {
> 		atomic_inc(&bp->b_hold);
> 		list_add_tail(&bp->b_list, list);
> 	}
> 
> 	return true;
> }
> 
> /*
>  * Compare function is more complex than it needs to be because
>  * the return value is only 32 bits and we are doing comparisons
>  * on 64 bit values
>  */
> static int
> xfs_buf_cmp(
> 	void		*priv,
> 	struct list_head *a,
> 	struct list_head *b)
> {
> 	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
> 	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
> 	xfs_daddr_t		diff;
> 
> 	diff = ap->b_maps[0].bm_bn - bp->b_maps[0].bm_bn;
> 	if (diff < 0)
> 		return -1;
> 	if (diff > 0)
> 		return 1;
> 	return 0;
> }
> 
> 
> static void
> xfs_buf_delwri_submit_buffers(
>        struct list_head        *buffer_list,
>        bool                    wait)
> {
>        struct xfs_buf          *bp, *n;
>        struct blk_plug         plug;
> 
>        blk_start_plug(&plug);
>        list_for_each_entry_safe(bp, n, buffer_list, b_list) {
>            bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC | XBF_WRITE_FAIL);
>  	   bp->b_flags |= XBF_WRITE;
> 
> 	   if (!wait) {
>  	       bp->b_flags |= XBF_ASYNC;
> 	       list_del_init(&bp->b_list);
> 	   }
>            xfs_bdstrat_cb(bp);
> 	}
> 	blk_finish_plug(&plug);
> }

You need to build the iolist here for the wait == true case, as per
the original patch I sent. Otherwise, you aren't clearing buffers
from the submit list correctly so iterated calls will attempt to
submit the same buffers repeatedly.

(FWIW, you've got some wacky whitepsace issues there...)

Other than the iolist building, there's nothing obviously wrong
here. But given you weren't able to capture anything blocked stack
traces when the delays were happening, this was really jus a shot in
the dark.

To move on, I need to know what is actually blocking on metadata
writeback, so I need blocked process stack traces from 'echo w >
/proc/sysrq-trigger' when the system is in that slow state.

> /*
>  * Write out a buffer list asynchronously.
>  *
>  * This will take the @buffer_list, write all non-locked and non-pinned buffers
>  * out and not wait for I/O completion on any of the buffers.  This interface
>  * is only safely useable for callers that can track I/O completion by higher
>  * level means, e.g. AIL pushing as the @buffer_list is consumed in this
>  * function.
>  */
> int
> xfs_buf_delwri_submit_nowait(
> 	struct list_head	*buffer_list)
> {
> 	LIST_HEAD		(io_list);
> 	return __xfs_buf_delwri_submit(buffer_list, &io_list, false);
> }

This is where the AIL pushing enters, so not building the iolist
here isn't an issue. However...

> /*
>  * Write out a buffer list synchronously.
>  *
>  * This will take the @buffer_list, write all buffers out and wait for I/O
>  * completion on all of the buffers. @buffer_list is consumed by the function,
>  * so callers must have some other way of tracking buffers if they require such
>  * functionality.
>  */
> int
> xfs_buf_delwri_submit(
> 	struct list_head	*buffer_list)
> {
> 	LIST_HEAD		(io_list);
> 	int			error = 0, error2;
> 	struct xfs_buf		*bp;
> 
> 	__xfs_buf_delwri_submit(buffer_list, &io_list, true);
> 
> 	/* Wait for IO to complete. */
> 	while (!list_empty(&io_list)) {
> 		bp = list_first_entry(&io_list, struct xfs_buf, b_list);
> 
> 		list_del_init(&bp->b_list);
> 		error2 = xfs_buf_iowait(bp);
> 		xfs_buf_relse(bp);
> 		if (!error)
> 			error = error2;
> 	}
> 
> 	return error;

unmount enters here, and so not waiting because the iolist is not
built will result in use-after-free bugs on unmount as IO is not
correctly waited for...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
