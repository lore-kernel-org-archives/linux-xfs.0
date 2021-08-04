Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AC7C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 12:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2012460E8D
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 12:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhHDMha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 08:37:30 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44011 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhHDMha (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 08:37:30 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 3853F84A35;
        Wed,  4 Aug 2021 22:37:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBG94-00EPuA-83; Wed, 04 Aug 2021 22:37:14 +1000
Date:   Wed, 4 Aug 2021 22:37:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] xfs: inodegc needs to stop before freeze
Message-ID: <20210804123714.GQ2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804100328.GK2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804100328.GK2757197@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QfC-DXSB2V09ypwxJwMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 08:03:28PM +1000, Dave Chinner wrote:
> On Tue, Aug 03, 2021 at 08:20:30PM -0700, Darrick J. Wong wrote:
> > For everyone else following along at home, I've posted the current draft
> > version of this whole thing in:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.15
> > 
> > Here's Dave's patch reworked slightly to fix a deadlock between icreate
> > and inactivation; conversion to use m_opstate and related macro stamping
> > goodness; and some code reorganization to make it easier to add the
> > throttling bits in the back two thirds of the series.
> > 
> > IOWs, I like this patch.  The runtime for my crazy deltree benchmark
> > dropped from ~27 minutes to ~17 when the VM has 560M of RAM, and there's
> > no observable drop in performance when the VM has 16G of RAM.  I also
> > finally got it to run with 512M of RAM, whereas current TOT OOMs.
> > 
> > (Note: My crazy deltree benchmark is: I have a mdrestored sparse image
> > with 10m files that I use dm-snapshot so that I can repeatedly write to
> > it without needing to restore the image.  Then I mount the dm snapshot,
> > and try to delete every file in the fs.)
> ....
> 
> Ok, so xfs/517 fails with a freeze assert:
> 
> XFS: Assertion failed: mp->m_super->s_writers.frozen < SB_FREEZE_FS, file: fs/xfs/xfs_icache.c, line: 1861
> 
> > @@ -718,6 +729,25 @@ xfs_fs_sync_fs(
> >  		flush_delayed_work(&mp->m_log->l_work);
> >  	}
> >  
> > +	/*
> > +	 * Flush all deferred inode inactivation work so that the free space
> > +	 * counters will reflect recent deletions.  Do not force the log again
> > +	 * because log recovery can restart the inactivation from the info that
> > +	 * we just wrote into the ondisk log.
> > +	 *
> > +	 * For regular operation this isn't strictly necessary since we aren't
> > +	 * required to guarantee that unlinking frees space immediately, but
> > +	 * that is how XFS historically behaved.
> > +	 *
> > +	 * If, however, the filesystem is at FREEZE_PAGEFAULTS, this is our
> > +	 * last chance to complete the inactivation work before the filesystem
> > +	 * freezes and the log is quiesced.  The background worker will not
> > +	 * activate again until the fs is thawed because the VFS won't evict
> > +	 * any more inodes until freeze_super drops s_umount and we disable the
> > +	 * worker in xfs_fs_freeze.
> > +	 */
> > +	xfs_inodegc_flush(mp);
> 
> How does s_umount prevent __fput() from dropping the last reference
> to an unlinked inode and putting it through evict() and hence adding
> it to the deferred list that way?
> 
> Remember that the flush does not guarantee the per-cpu queues are
> empty when it returns, just that whatever is in each percpu queue at
> the time the per-cpu work is run has been completed.  We haven't yet
> gone to SB_FREEZE_FS, so the transaction subsystem won't be frozen
> at this point. Hence I can't see anything that would prevent unlinks
> racing with this flush and queueing work after the flush work drains
> the queues and starts processing the inodes it drained.
> 
> > +
> >  	return 0;
> >  }
> >  
> > @@ -832,6 +862,17 @@ xfs_fs_freeze(
> >  	 */
> >  	flags = memalloc_nofs_save();
> >  	xfs_blockgc_stop(mp);
> > +
> > +	/*
> > +	 * Stop the inodegc background worker.  freeze_super already flushed
> > +	 * all pending inodegc work when it sync'd the filesystem after setting
> > +	 * SB_FREEZE_PAGEFAULTS, and it holds s_umount, so we know that inodes
> > +	 * cannot enter xfs_fs_destroy_inode until the freeze is complete.
> > +	 * If the filesystem is read-write, inactivated inodes will queue but
> > +	 * the worker will not run until the filesystem thaws or unmounts.
> > +	 */
> > +	xfs_inodegc_stop(mp);
> 
> .... and so we end up with this flush blocked on the background work
> that assert failed and BUG()d:
> 
> [  219.511172] task:xfs_io          state:D stack:14208 pid:10238 ppid:  9089 flags:0x00004004
> [  219.513126] Call Trace:
> [  219.513768]  __schedule+0x310/0x9f0
> [  219.514628]  schedule+0x67/0xe0
> [  219.515405]  schedule_timeout+0x114/0x160
> [  219.516404]  ? _raw_spin_unlock_irqrestore+0x12/0x40
> [  219.517622]  ? do_raw_spin_unlock+0x57/0xb0
> [  219.518655]  __wait_for_common+0xc0/0x160
> [  219.519638]  ? usleep_range+0xa0/0xa0
> [  219.520545]  wait_for_completion+0x24/0x30
> [  219.521544]  flush_work+0x58/0x70
> [  219.522357]  ? flush_workqueue_prep_pwqs+0x140/0x140
> [  219.523553]  xfs_inodegc_flush+0x88/0x100
> [  219.524524]  xfs_inodegc_stop+0x28/0xb0
> [  219.525514]  xfs_fs_freeze+0x40/0x70
> [  219.526401]  freeze_super+0xd8/0x140
> [  219.527277]  do_vfs_ioctl+0x784/0x890
> [  219.528146]  __x64_sys_ioctl+0x6f/0xc0
> [  219.529062]  do_syscall_64+0x35/0x80
> [  219.529974]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> At this point, we are at SB_FREEZE_FS and the transaction system it
> shut down, so this is a hard fail.
> 
> ISTR a discussion about this in the past - I think we need to hook
> ->freeze_super() and run xfs_inodegc_stop() before we run
> freeze_super(). That way we end up just queuing pending
> inactivations while the freeze runs and completes.
> 
> The patch below does this (applied on top of you entire stack) and
> it seems to fix the 517 failure (0 failures in 50 runs vs 100% fail
> rate without the patch).

This doesn't work. g/390 does nested, racing freeze/thaw and so we
can have a start from an unfreeze racing with a stop for a freeze
about to run. IOWs, we can't stop the inodegc work until s_umount is
held and we know that there isn't another freeze in progress....

Back to the drawing board for this one.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
