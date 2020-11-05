Return-Path: <SRS0=J5OL=EL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C4DC388F7
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Nov 2020 22:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC9A920735
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Nov 2020 22:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgKEWIx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Nov 2020 17:08:53 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:54452 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731508AbgKEWIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Nov 2020 17:08:52 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A05F558C109;
        Fri,  6 Nov 2020 09:08:47 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kanQv-0085r4-H4; Fri, 06 Nov 2020 09:08:41 +1100
Date:   Fri, 6 Nov 2020 09:08:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Pavel Reichl <preichl@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 4/4] xfs: replace mrlock_t with rw_semaphores
Message-ID: <20201105220841.GE7391@dread.disaster.area>
References: <20201102194135.174806-1-preichl@redhat.com>
 <20201102194135.174806-5-preichl@redhat.com>
 <20201104005345.GC7115@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104005345.GC7115@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=nNwsprhYR40A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=S5iXoW4Jh1Qx-i4SNkQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 03, 2020 at 04:53:45PM -0800, Darrick J. Wong wrote:
> On Mon, Nov 02, 2020 at 08:41:35PM +0100, Pavel Reichl wrote:
> > Remove mrlock_t as it does not provide any extra value over
> > rw_semaphores. Make i_lock and i_mmaplock native rw_semaphores and
> > replace mr*() functions with native rwsem calls.
> > 
> > Release the lock in xfs_btree_split() just before the work-queue
> > executing xfs_btree_split_worker() is scheduled and make
> > xfs_btree_split_worker() to acquire the lock as a first thing and
> > release it just before returning from the function. This it done so the
> > ownership of the lock is transfered between kernel threads and thus
> > lockdep won't complain about lock being held by a different kernel
> > thread.
> > 
> > Signed-off-by: Pavel Reichl <preichl@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > 
> > ---
> >  fs/xfs/libxfs/xfs_btree.c | 16 ++++++++
> >  fs/xfs/mrlock.h           | 78 ---------------------------------------
> >  fs/xfs/xfs_inode.c        | 52 ++++++++++++++------------
> >  fs/xfs/xfs_inode.h        |  4 +-
> >  fs/xfs/xfs_iops.c         |  4 +-
> >  fs/xfs/xfs_linux.h        |  2 +-
> >  fs/xfs/xfs_super.c        |  6 +--
> >  7 files changed, 51 insertions(+), 111 deletions(-)
> >  delete mode 100644 fs/xfs/mrlock.h
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 2d25bab68764..181d5797c97b 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -2816,6 +2816,10 @@ xfs_btree_split_worker(
> w  	unsigned long		pflags;
> >  	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
> >  
> > +	/*
> > +	 * Tranfer lock ownership to workqueue task.
> > +	 */
> > +	rwsem_acquire(&args->cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
> >  	/*
> >  	 * we are in a transaction context here, but may also be doing work
> >  	 * in kswapd context, and hence we may need to inherit that state
> > @@ -2829,6 +2833,7 @@ xfs_btree_split_worker(
> >  
> >  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
> >  					 args->key, args->curp, args->stat);
> > +	rwsem_release(&args->cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
> >  	complete(args->done);
> >  
> >  	current_restore_flags_nested(&pflags, new_pflags);
> > @@ -2863,8 +2868,19 @@ xfs_btree_split(
> >  	args.done = &done;
> >  	args.kswapd = current_is_kswapd();
> >  	INIT_WORK_ONSTACK(&args.work, xfs_btree_split_worker);
> > +	/*
> > +	 * Update lockdep's ownership information to reflect transfer of the
> > +	 * ilock from the current task to the worker. Otherwise assertions that
> > +	 * the lock is held (such as when logging the inode) might fail due to
> > +	 * incorrect task owner state.
> > +	 */
> > +	rwsem_release(&cur->bc_ino.ip->i_lock.dep_map, _THIS_IP_);
> >  	queue_work(xfs_alloc_wq, &args.work);
> >  	wait_for_completion(&done);
> > +	/*
> > +	 * Tranfer lock ownership back to the thread.
> > +	 */
> > +	rwsem_acquire(&cur->bc_ino.ip->i_lock.dep_map, 0, 0, _RET_IP_);
> 
> So I ran all this through fstests.  On generic/324 on a fstests run with
> reasonable recent xfsprogs and all the features turned on (rmap in
> particular) I see the following lockdep report:

Why, exactly do we need to transfer the ownership of the inode lock
here? 

The code that runs in the workqueue does not attempt to lock the
inode in any way, nor should it be trying to assert that the inode
is locked because it's just doing btree work that -requires- the
inode to be locked long before we get to these layers. If anything
deep in the BMBT split code is trying to assert that the inode is
locked, just remove those assertions as we've already run these
asserts long before we hand this work off to another thread.

[....]

> Just like in the first scenario, we hold two ILOCKs -- a directory, and
> a file that we're removing from the directory.  The removal triggers the
> same bmbt split worker because we're shrinking the directory, and upon
> its completion we call rwsem_acquire to reset the lockdep maps.
> 
> Unfortunately, in this case, we actually /are/ feeding the correct
> subclass information to rwsem_acquire.  This time it's pointing out what
> it thinks is an inconsistency in our locking order: the first time we
> locked the directory and then the regular file inode, but now we hold
> the regular file inode and we're asking it for the directory ILOCK.
> 
> (Note that we don't actually deadlock here because pid 25035 has
> maintained ownership of the directory ILOCK rwsem this whole time, but
> lockdep doesn't know that.)
> 
> A crappy way to bypass this problem is the following garbage patch
> which disables lockdep chain checking since we never actually dropped
> any of the ILOCKs that are being complained about.  Messing with low
> level lockdep internals seems sketchy to me, but so it goes.
> 
> The patch also has the major flaw that it doesn't recapture the subclass
> information, but doing that is left as an exercise to the reader. ;)

lockdep is a PITA when it comes to using semaphores as they were
intended because lockdep is task context centric and semaphores are
data object centric. i.e. with semaphores, the data object owns the
lock, not the task context, and that creates a horrible impedence
mismatch between the semaphore locking and lockdep tracking models.
IOWs, lockdep has major issues with this, so the two options here are:

	1. get rid of lockdep checks in the paths where we pass
	locked semaphores to other task contexts; or

	2. add lockdep checks for "lockdep_assert_held_non_owner()"
	where it just checks that the lock is held read/write but
	without checking the owner matches.

#2 matches how our existing inode locking assert checks work - we
don't care who locked the inode, just that it is locked in the
correct mode.

This would get rid of the need to pass rwsem lockdep contexts
between tasks. That, in turn, gets rid of all the nesting and
annotation problems that this attmept to pass lockdep contexts to
non-owner tasks introduces....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
