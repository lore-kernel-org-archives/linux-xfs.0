Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N1vrQd099667 for <xfs@oss.sgi.com>; Sun, 22 Apr 2012 20:57:53 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wi1zIysiLTUt4UWg for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 18:57:50 -0700 (PDT)
Date: Mon, 23 Apr 2012 11:57:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] xfs: on-stack delayed write buffer lists
Message-ID: <20120423015738.GL9541@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164646.975031281@bombadil.infradead.org>
	<4F91A8C2.3050907@sgi.com> <20120421004256.GI9541@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120421004256.GI9541@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Apr 21, 2012 at 10:42:56AM +1000, Dave Chinner wrote:
> On Fri, Apr 20, 2012 at 01:19:46PM -0500, Mark Tinguely wrote:
> > On 03/27/12 11:44, Christoph Hellwig wrote:
> > >Queue delwri buffers on a local on-stack list instead of a per-buftarg one,
> > >and write back the buffers per-process instead of by waking up xfsbufd.
.....
> > >Given that xfsailds now also handles writing out buffers the conditions for
> > >log forcing and the sleep times needed some small changes.  The most
> > >important one is that we consider an AIL busy as long we still have buffers
> > >to push, and the other one is that we do increment the pushed LSN for
> > >buffers that are under flushing at this moment, but still count them towards
> > >the stuck items for restart purposes.  Without this we could hammer on stuck
> > >items without ever forcing the log and not make progress under heavy random
> > >delete workloads on fast flash storage devices.
> > >
> > >Signed-off-by: Christoph Hellwig<hch@lst.de>
> > 
> > Test 106 runs to completion with patch 06.
> > 
> > Patch 07 and 08 do not compile without patch 09.
> > 
> > Starting with patch 09, I get the following hang on every test 106:
> 
> FYI, test 106 is not in the auto group, which means it typically
> isn't run on regression test runs by anyone who isn't modifying
> quota code. That'll be why nobody else is seeing this.

And I can reporduce it easily enough w/ 106.

> > ID: 27992  TASK: ffff8808310d00c0  CPU: 2   COMMAND: "mount"
> >  #0 [ffff880834237938] __schedule at ffffffff81417200
> >  #1 [ffff880834237a80] schedule at ffffffff81417574
> >  #2 [ffff880834237a90] schedule_timeout at ffffffff81415805
> >  #3 [ffff880834237b30] wait_for_common at ffffffff81416a67
> >  #4 [ffff880834237bc0] wait_for_completion at ffffffff81416bd8
> >  #5 [ffff880834237bd0] xfs_buf_iowait at ffffffffa04fc5a5 [xfs]
> >  #6 [ffff880834237c00] xfs_buf_delwri_submit at ffffffffa04fe4b9 [xfs]
> >  #7 [ffff880834237c40] xfs_qm_quotacheck at ffffffffa055cb2d [xfs]
> >  #8 [ffff880834237cc0] xfs_qm_mount_quotas at ffffffffa055cdf0 [xfs]
> >  #9 [ffff880834237cf0] xfs_mountfs at ffffffffa054c041 [xfs]
> > #10 [ffff880834237d40] xfs_fs_fill_super at ffffffffa050ca80 [xfs]
> > #11 [ffff880834237d70] mount_bdev at ffffffff81150c5c
> > #12 [ffff880834237de0] xfs_fs_mount at ffffffffa050ac00 [xfs]
> > #13 [ffff880834237df0] mount_fs at ffffffff811505f8
> > #14 [ffff880834237e40] vfs_kern_mount at ffffffff8116c070
> > #15 [ffff880834237e80] do_kern_mount at ffffffff8116c16e
> > #16 [ffff880834237ec0] do_mount at ffffffff8116d6f0
> > #17 [ffff880834237f20] sys_mount at ffffffff8116d7f3
> > #18 [ffff880834237f80] system_call_fastpath at ffffffff814203b9
> 
> And event trace is going to be the only way to find out why it is
> still waiting.....

Interesting. The buffer that we have hung on looks strange:

xfs_buf_read:         dev 253:16 bno 0x4d8 len 0x1000 hold 1 pincount 0
		      lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK
		      caller xfs_buf_readahead
xfs_buf_iorequest:    dev 253:16 bno 0x4d8 nblks 0x8 hold 1 pincount 0
		      lock 0 flags READ|READ_AHEAD|ASYNC|TRYLOCK|PAGES
		      caller _xfs_buf_read

What's really strange about that is the flags. The first trace is
the IO request type trace - the flags indicate the type of IO to be
done, and here is it clearly readahead. The second is the IO
dispatch, where the flags come from the *buffer*, and according to
the xfs_buf_alloc code:

        /*
         * We don't want certain flags to appear in b_flags.
         */
        flags &= ~(XBF_LOCK|XBF_MAPPED|XBF_DONT_BLOCK|XBF_READ_AHEAD);

And according to the xfs_buf.h code:

        { XBF_LOCK,             "LOCK" },       /* should never be set */\
	{ XBF_TRYLOCK,          "TRYLOCK" },    /* ditto */\
	{ XBF_DONT_BLOCK,       "DONT_BLOCK" }, /* ditto */\

So clearly these don't all match up. We're letting the trylock flag
slip through, but this should be harmless. However, the
XBF_READ_AHEAD flag is clearly showing up, but it is supposed to be
there across the IO (set in _xfs_buf_read, cleared in xfs_buf_ioend)
so we can ignore that. The trylock is slipping through because it is
not blocked like it should be xfs_buf_alloc(), but it is otherwise
unused so that isn't an issue. That leaves the only possible source
of the problem being the ASYNC flag.

We don't clear the async flag during IO completion because it is
used throughout IO completion to determine exactly what to do, and
completion has no idea if it is the final completion or not, and
hence we can't sanely clear it. hence it has to be cleared on IO
submission. That's the bug.

In __xfs_buf_delwri_submit(), the buffer submit does:

                if (!wait) {
                        bp->b_flags |= XBF_ASYNC;
                        list_del_init(&bp->b_list);
                }

whereas teh old xfs_flush_buftarg() code does:

                if (wait) {
                        bp->b_flags &= ~XBF_ASYNC;
                        list_add(&bp->b_list, &wait_list);
                }

Subtle difference, and one that I missed on review. That is, the old
code assumes that the XBF_ASYNC flag is already set because it is,
in fact, set in xfs_buf_delwri_queue().

		bp->b_flags |= XBF_DELWRI | _XBF_DELWRI_Q | XBF_ASYNC;

That is, for a buffer to be on the delwri queue, it has to have
XBF_ASYNC set on it. Hence for a blocking flush, we need to clear
that flag for IO completion to send wakeups.

The new code only does this in xfs_buf_delwri_queue() now:

	bp->b_flags |= _XBF_DELWRI_Q;

so the flushing code can make no assumption about the state of
XBF_ASYNC flag at all. Hence the new code in
__xfs_buf_delwri_submit() must clear the XBF_ASYNC flag to get it
into a known state for both blocking and async flushes:

        list_for_each_entry_safe(bp, n, submit_list, b_list) {
-               bp->b_flags &= ~_XBF_DELWRI_Q;
+               bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
                bp->b_flags |= XBF_WRITE;

                if (!wait) {
                        bp->b_flags |= XBF_ASYNC;
                        list_del_init(&bp->b_list);
                }
                xfs_bdstrat_cb(bp);
        }

I'll update the patch in my stack to make this change, and write a
new patch on top of my buffer flag cleanups to clean up the flag
exclusion code (because XBF_LOCK is already gone!).

With the above fix, 106 runs to completion, but it still fails
because the golden output is full of unfiltered numbers and
irrelevant stuff. I'd say that's why the test is not in the auto
group - it needs work to give reliable, machine independent
output...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
