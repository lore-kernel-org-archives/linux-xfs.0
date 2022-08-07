Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF086C19F2A
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Aug 2022 22:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbiHGWlO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Aug 2022 18:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236959AbiHGWkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Aug 2022 18:40:31 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2B9DE61
        for <linux-xfs@vger.kernel.org>; Sun,  7 Aug 2022 15:33:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3C29610C8E25;
        Mon,  8 Aug 2022 08:33:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oKopZ-00APqj-71; Mon, 08 Aug 2022 08:33:09 +1000
Date:   Mon, 8 Aug 2022 08:33:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix intermittent hang during quotacheck
Message-ID: <20220807223309.GH3600936@dread.disaster.area>
References: <165963638241.1272632.9852314965190809423.stgit@magnolia>
 <165963639392.1272632.16910716528071046151.stgit@magnolia>
 <20220805015752.GF3600936@dread.disaster.area>
 <YuyunqW74KBGAu+i@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuyunqW74KBGAu+i@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62f03da7
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=RlZdigvJr217m6nk9OAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 04, 2022 at 10:46:06PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 05, 2022 at 11:57:52AM +1000, Dave Chinner wrote:
> > Now, onto the real problem:
> > 
> > >  		xfs_buf_delwri_pushbuf(bp, buffer_list);
> > 
> > I don't think what xfs_buf_delwri_pushbuf() is doing is safe, It's
> > removing the buffer from whatever dewlri list it is already on,
> > whilst only holding the buffer lock. That's *not safe* as it's
> > accessing and modifying buffers on the list that has a local stack
> > context. It's modifying that local stack delwri list context from
> > another task, and holding the buffer locked does not make that safe.
> > 
> > i.e. the only reason local stack contexts work without list locking
> > or having to worry about whether the objects on the list are locked
> > is that they are local and no other thread can access or modify
> > objects them.
> 
> Hmmm.  I think you're right -- although we hold the buffer lock when
> setting or clearing DELWRI_Q and updating b_list, there isn't any lock
> on the two list heads that point at b_list.

Yup, exactly the problem.

> Not to go too far down the rabbithole, but there's a related topic on
> the horizon -- online repair uses delwri lists to write new btree
> buffers to disk.  A few months ago I noticed that once in a while, the
> new btree blocks didn't all get written before the new root was
> committed via transaction.
> 
> It turned out that the new btree blocks were actually recently freed
> metadata blocks.  The buffers were marked stale (DELWRI_Q was clear) but
> were still sitting in the AIL's buffer list.

*nod*

Because it's unsafe to remove it from the local delwri list....

> The btree bulk loading
> code would try to xfs_buf_delwri_queue, which would re-set DELWRI_Q, but
> because b_list was still linked into the AIL's list, the buffer would
> not actually be put on xfs_btree_bload's buffer list.  Hence the
> writeout would not be complete.

*nod*

> I fixed this (for now) by detecting this buffer state (no DELWRI_Q but
> b_list points elsehwere) and cycling the buffer lock until that state
> clears.  After that, we're free to set DELWRI_Q and put the buffer on
> the bulk loader's list.  Does that sound like a reasonable use?

I suspect we need to handle stale vs delwri differently - I don't
really like the idea of every delwri list user needing to work
around this stale buffer issue.

Hence I think the right thing to do is wait in xfs_buf_find() if the
buffer is stale and still on a delwri queue until it is removed from
the delwri queue - we can probably use the existing iowait
infrastructure for this. We can issue a wakeup in the delwri
submission when a removed buffer is detected, and then nobody will
ever see a recycled stale buffer still on a delwri queue....

> Hm, now that I think about xfs_btree_bload, I realize that it also pins
> all the btree buffers in memory while it's loading the tree.  Maybe it
> also needs to be able to dump buffers to disk in smaller batches?  Once
> it puts a buffer on the delwri list, I don't think it ever dirties the
> buffer again.

Probably.

[....]

> > However, even doing this doesn't address the root cause of the
> > problem - it ignores why the race condition exists in the first
> > place.
> > 
> > That is, quotacheck tries to optimise the dquot buffer writing code
> > down to a single disk write for every dquot. It first zeros all the
> > dquots by accessing the buffers directly, pinning them in memory via
> > the delwri list. It then runs a bulkstat of the filesystem runs to
> > updates the in-memory dquots (not the on disk dquots that are
> > pinning in memory).  Then once that is done, it
> > flushes the in memory dquots to the buffers via a dquot cache walk
> > and writes them back.
> > 
> > Which seems like a decent enough optimisation, but it ignores the
> > fact that when we have millions of inodes, the bulkstat to update
> > the in memory dquots can do millions of IO and generate many
> > gigabytes of memory pressure. dquot buffer writeback is essentially
> > sequential IO due to delwri list sorting and block layer bio
> > merging, so even with tens of thousands of dquots, the amount of IO
> > to write these back multiple times is miniscule compared to the
> > amount of IO the bulkstat to update the dquots has generated.
> 
> [At this point I wondered if we could perhaps just use online fsck's
> version of quotacheck, which runs concurrently with the system and is
> not so resource intensive.  But it's less efficient because it deals
> only with xfs_dquots, not the dquot buffers.  One potential advantage is
> that it doesn't need to block mount() from finishing, but then that
> could expose wrong quota counts to users.]

Possibly, but with the concurrent bulkstat during quotacheck now,
the mount delay is somewhat minimised. The limiting factor on
quotacheck performance now is lock contention dquot lookups
(radix tree is protected by a mutex, needs to be lockless).

Hence if we move to the online fsck version, we're still going to
have that contention problem (maybe worse!). Fixing the contention
issue will be easier with the current version of quotacheck because
that is all that is running, but it should translate across to the
online fsck code, too.

> > IOWs, it's an optimisation that might save a few IOs and be
> > measurable on small filesystems, but when we scale up the IO
> > optimisation is completely lost in the noise of walking the inodes.
> > 
> > Given that this IO optimisation is the root of the race condition
> > that causes the delwri queue writeback deadlocks and problems, let's
> > just get rid of it. Submit the buffer list once all the dquots are
> > zeroed, and that unpins them all and clears all the existing dquot
> > state on disk. Now the inode walk can run and dirty dquots can be
> > flushed and reclaimed by memory reclaimed as per normal runtime
> > behaviour, and the final writeback of all the dirty dquots doesn't
> > need to care that memory reclaim might have flush locked some of the
> > dquots and not been able to write them back....
> 
> Aha, and now I remembered something -- at one point I enabled the online
> fsck stress tests to set random [ugp]ids without restricting the range
> of quota ids.  It proceeded with the entire 32-bit id space, and a
> quotacheck running after the test would OOM the box.  This might help
> with that, if I can remember the magic incantation to reproduce that.

*nod*

> > @@ -1219,30 +1228,7 @@ xfs_qm_flush_one(
> >  	if (!XFS_DQ_IS_DIRTY(dqp))
> >  		goto out_unlock;
> >  
> > -	/*
> > -	 * The only way the dquot is already flush locked by the time quotacheck
> > -	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
> > -	 * it for the final time. Quotacheck collects all dquot bufs in the
> > -	 * local delwri queue before dquots are dirtied, so reclaim can't have
> > -	 * possibly queued it for I/O. The only way out is to push the buffer to
> > -	 * cycle the flush lock.
> > -	 */
> > -	if (!xfs_dqflock_nowait(dqp)) {
> > -		/* buf is pinned in-core by delwri list */
> > -		error = xfs_buf_incore(mp->m_ddev_targp, dqp->q_blkno,
> > -				mp->m_quotainfo->qi_dqchunklen, 0, &bp);
> > -		if (error)
> > -			goto out_unlock;
> > -
> > -		xfs_buf_unlock(bp);
> > -
> > -		xfs_buf_delwri_pushbuf(bp, buffer_list);
> > -		xfs_buf_rele(bp);
> > -
> > -		error = -EAGAIN;
> > -		goto out_unlock;
> > -	}
> -
> > +	xfs_dqflock(dqp);
> >  	error = xfs_qm_dqflush(dqp, &bp);
> >  	if (error)
> >  		goto out_unlock;
> > @@ -1305,6 +1291,17 @@ xfs_qm_quotacheck(
> >  		flags |= XFS_PQUOTA_CHKD;
> >  	}
> >  
> > +	/*
> > +	 * Write back all the zeroed buffers now so that they aren't pinned in
> > +	 * memory by the delwri list. Holding them pinned while walking the
> > +	 * inodes to update in memory dquots opens us up to races with memory
> > +	 * reclaim attempting to flush dirty dquots, and actually prevents
> > +	 * memory reclaim from bein able to reclaim dirty dquots at all.
> > +	 */
> > +	error = xfs_buf_delwri_submit(&buffer_list);
> 
> Summarizing what we chatted about on IRC:
> 
> Why do we wait until after all three xfs_qm_reset_dqcounts_buf calls to
> submit the delwri list?  Doesn't that pin /every/ dquot buffer in
> memory?  If the system actually has all 4.3 billion dquots defined, then
> we can end up pinning ~570MB of memory per quota type, or ~1800M of
> buffers in memory.

Yes, I think it will.

> Maybe we ought to promote delwri lists to an explicit type instead of
> passing around list_heads?
> 
> struct xfs_buf_delwri_list {
> 	struct list_head	list;
> 	unsigned int		nr_bufs;
> };
> 
> So that we can submit the list (and unpin the buffers) every 10000 items
> or so?

Perhaps so, I haven't thought much past the "oh, it can pin ever
dquot buffer in memory" point yet.

> Maybe the quot flush locking ought to be straightened out a bit like we
> did for inodes?  i.e. pin the dquot buffer when the dquot gets dirtied,
> and then flushing will lock the buffer, the dquot, and finally the
> dqf(lush)?

That will help, too, especially if we move the dquot lookup to be
lockless and then we can do the buffer -> dquot lookup and lock loop
without causing all sorts of new lock contention points.

With that in mind, I've added a 'umount; mount -o <all quotas> ;
umount" step to my scalability test script after the bulkstat pass.
This exposes all the dquot lookup contention issues in a nice,
simple test, so it's going to continually remind me that this is an
issue that needs fixing now.

One step at a time, eh?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
