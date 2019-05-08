Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38494 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbfEHVcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 17:32:50 -0400
Date: Thu, 9 May 2019 07:32:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190508213244.GP29573@dread.disaster.area>
References: <20190507130528.1d3d471b@imladris.surriel.com>
 <20190507212213.GO29573@dread.disaster.area>
 <3985b9feffe11dcdbb86fa8c2d9ffc4bd7ab8458.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3985b9feffe11dcdbb86fa8c2d9ffc4bd7ab8458.camel@surriel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rik van Riel <riel@surriel.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <dchinner@redhat.com>

On Wed, May 08, 2019 at 10:08:59AM -0400, Rik van Riel wrote:
> On Wed, 2019-05-08 at 07:22 +1000, Dave Chinner wrote:
> > On Tue, May 07, 2019 at 01:05:28PM -0400, Rik van Riel wrote:
> > > The code in xlog_wait uses the spinlock to make adding the task to
> > > the wait queue, and setting the task state to UNINTERRUPTIBLE
> > > atomic
> > > with respect to the waker.
> > > 
> > > Doing the wakeup after releasing the spinlock opens up the
> > > following
> > > race condition:
> > > 
> > > - add task to wait queue
> > > 
> > > -                                      wake up task
> > > 
> > > - set task state to UNINTERRUPTIBLE
> > > 
> > > Simply moving the spin_unlock to after the wake_up_all results
> > > in the waker not being able to see a task on the waitqueue before
> > > it has set its state to UNINTERRUPTIBLE.
> > 
> > Yup, seems like an issue. Good find, Rik.
> > 
> > So, what problem is this actually fixing? Was it noticed by
> > inspection, or is it actually manifesting on production machines?
> > If it is manifesting IRL, what are the symptoms (e.g. hang running
> > out of log space?) and do you have a test case or any way to
> > exercise it easily?
> 
> Chris spotted a hung kworker task, in UNINTERRUPTIBLE
> state, but with an empty wait queue. This does not seem
> like something that is easily reproducible.

Yeah, I just read that, not something we can trigger with a
regression test :P

> > And, FWIW, did you check all the other xlog_wait() users for the
> > same problem?
> 
> I did not, but am looking now. The xlog_wait code itself
> is fine, but it seems there are a few other wakers that
> are doing the wakeup after releasing the lock.
> 
> It looks like xfs_log_force_umount() and the other wakeup 
> in xlog_state_do_callback() suffer from the same issue.

Hmmm, the first wakeup in xsdc is this one, right:

	       /* wake up threads waiting in xfs_log_force() */
	       wake_up_all(&iclog->ic_force_wait);

At the end of the iclog iteration loop? That one is under the
ic_loglock - the lock is dropped to run callbacks, then picked up
again once the callbacks are done and before the ic_callback_lock is
dropped (about 10 lines above the wakeup). So unless I'm missing
something (like enough coffee!) that one look fine.

.....

> I am not sure about xfs_log_force_umount(). Could the unlock 
> be moved to after the wake_up_all, or does that create lock
> ordering issues with the xlog_grant_head_wake_all calls?
> Could a simple lock + unlock of log->l_icloglock around the
> wake_up_all do the trick, or is there some other state that
> also needs to stay locked?

Need to be careful which lock is used with which wait queue :)

This one is waking the the xc_commit_wait queue (CIL push commit
sequencing wait queue), which is protected by the
log->l_cilp->xc_push_lock. That should nest jsut fine inside any
locks we are holding at this point, so you should just be able to
wrap it.  It's not a common code path, though, it'll only hit this
code when the filesystem is already considered to be in an
unrecoverable state.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
