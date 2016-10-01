Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750818AbcJAN1b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Oct 2016 09:27:31 -0400
Date: Sat, 1 Oct 2016 09:27:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20161001132728.GA56484@bfoster.bfoster>
References: <1475154199-28880-1-git-send-email-cmaiolino@redhat.com>
 <20160930000147.GH27872@dastard>
 <20160930145413.GB27528@bfoster.bfoster>
 <20161001002104.GK27872@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161001002104.GK27872@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Sat, Oct 01, 2016 at 10:21:04AM +1000, Dave Chinner wrote:
> On Fri, Sep 30, 2016 at 10:54:13AM -0400, Brian Foster wrote:
> > On Fri, Sep 30, 2016 at 10:01:47AM +1000, Dave Chinner wrote:
> > > On Thu, Sep 29, 2016 at 03:03:19PM +0200, Carlos Maiolino wrote:
> > > > I have been working in a bug still regarding xfs fail_at_unmount configuration,
> > > > where, even though the configuration is enable, an unmount attempt will still
> > > > hang if the AIL buf items are locked as a result of a previous failed attempt to
> > > > flush these items.
> > > > 
> > > > Currently, if there is a failure while trying to flush inode buffers to disk,
> > > > these items are kept in AIL with FLUSHING status and with the locks held, making
> > > > them unable to be retried. Either during unmount, where they will be retried and
> > > > 'failed', or if using a thin provisioned device, the pool is actually extended, to
> > > > accomodate these not-yet-flushed items, instead of retrying to flush such items,
> > > > xfs is unable to retry them, once they are already locked.
> > > 
> > > [....]
> > > 
> > 
> > So this was originally written simply as a hack/experiment to test a
> > theory about what could be going wrong here, based on Carlos'
> > investigation so far into the issue. It wasn't really intended to be
> > posted as a proposed fix, so I'm going to skip over the details...
> > 
> > ...
> > > 
> > > Ok, I'm pretty sure that this just addresses a symptom of the
> > > underlying problem, not solve the root cause. e.g. dquot flushing
> > > has exactly the same problem.
> > > 
> > 
> > Agree.
> > 
> > > The underlying problem is that when the buffer was failed, the
> > > callbacks attached to the buffer were not run. Hence the inodes
> > > locked and attached to the buffer were not aborted and unlocked
> > > when the buffer IO was failed. That's the underlying problem that
> > > needs fixing - this cannot be solved sanely by trying to guess why
> > > an inode is flush locked when walking the AIL....
> > > 
> > 
> > Are you making the assumption that the filesystem is already shutdown in
> > this scenario? I assume so, otherwise I'm not sure simply running the
> > callbacks (that remove items from the AIL) is really appropriate.
> 
> No, I'm not. If we end up permanently failing /any/ metadata
> writeback, we need to trigger a shutdown. That's the whole point of
> these failure configurations - to avoid retrying forever in the hope
> that the error goes away and we can avoid a shutdown.
> 
> IOWs, on permanent inode buffer writeback failure, we should be:
> 
> 	a) shutting down the filesystem if it isn't already; and
> 	b) calling xfs_iflush_abort() to unlock the attached inodes
> 	   and remove them from the AIL.
> 

Ok. All I'm suggesting here is that the filesystem is shutdown before we
run the callbacks in this (error) case, which is what you're saying, so
I think we're saying the same thing. ;)

> > My _unconfirmed suspicion_ is that the core problem is that any
> > log items that are flush locked upon AIL push remain flush locked
> > in the event of I/O error (independent of fs shutdown, which is
> > not guaranteed after a metadata I/O error).  E.g., consider the
> > case of a transient error or error configuration that expects more
> > than one retry cycle through xfsaild. IOW, the current AIL error
> > retry mechanism doesn't work for flush locked items.
> 
> So, that's different to the context the patch description set, which
> was "testing fail_at_unmount configurations". i.e. there were hangs
> at unmount because failed IO was not unlocking the inodes that were
> attached. This "abort on permanent failure" problem exists and needs
> fixing.
> 
> What you're now saying is that there is /another/ problem to do with
> the retry side of the code, were an item that is flush locked is not
> correctly resubmitted for IO, because the item is still flush
> locked.
> 

Well, that's the only issue that I'm actually aware of and that was the
target of the experiment. What I'm saying, specifically, is Carlos' test
reproduces an unmount hang due to the broken AIL retry problem for flush
locked buffers. For example:

- Filesystem is humming along normally until the dm device shuts down,
  as expected, and metadata writeback begins to fail.
- One of such failed items is a flush locked inode. We hit
  xfs_buf_iodone_callback_error() and do not shut down the fs because
  we're using the default error config (retry forever).
- The inode log item ends up back on the AIL in the flush locked state.
- An unmount occurs, some other item is retried, fails and triggers the
  shutdown on umount check in *_iodone_callback_error().
- The unmount remains hung, despite the shutdown, because the AIL is
  spinning on the flush locked inode item. It can't abort the item
  because it cannot be retried, which would detect the shutdown state in
  the iodone handler, issue the callbacks and remove it from the AIL.

This is the state I seemed to reproduce in the handful of times I ran
Carlos' reproducer. E.g., the filesystem does actually shut down
correctly on unmount, but the umount was still hung spinning on a flush
locked item. Hence the experiment to retry the apparently stuck inode
buffer. This tests the broken retry theory and seemingly works around
(not fixes) the problem.

With that (hopefully clarified), you're losing me with regard to the
separate "abort on permanent failure" problem. It's not clear to me
whether we're confusing the root cause of the same fundamental issue or
there is just another problem that I'm just not aware of. Assuming the
latter, could you please elaborate on that issue to clarify it from the
one described above?

> Ok, yes, now that it's clear this isn't actually addressing
> fail_at_unmount permanent errors, I can see that there is a retry
> problem here. However, I don't think this patch is
> the correct way to address that, either, because the buffer lookup
> cost is prohibitive.
> 

As mentioned, this was just a test to see if a resubmission would
unstick the fs and if so, start a discussion on a proper fix.

> I think the correct thing to do - again - is to run the iodone
> callbacks on a "retriable error". i.e. on an error that needs to be
> retried, we:
> 
> 	- run callbacks on each object attached to buffer
> 	- each object gets marked as "write fail"
> 	- each object remains flush locked
> 	- the position in the AI lof each object is unchanged
> 	- buffer remains marked with _XBF_WRITE_FAIL
> 
> We cannot unlock the flush lock until the state on disk
> matches the state we flushed from the in-memory object to the buffer
> that is failing, hence we need some other method for indicating a
> new submission is required.
> 
> If we then find an object flush locked on an AIL push, we:
> 
> 	- check the object for the "write fail" flag. If not set,
> 	  there's nothing more to do.
> 	- look up the underlying buffer, check the _XBF_WRITE_FAIL
> 	  flag. If that's not set, we've raced with another IO doing
> 	  a retry or new submission. Nothing more to do.
> 	- with the buffer now locked, walk all the objects attached
> 	  and clear the "write fail" flags. This is needed to
> 	  prevent attempting to resubmit the buffer for every object
> 	  attached to the buffer as the AIL push walks down the
> 	  list.
> 	- add the buffer to the delwri list.
> 
> At that point, the buffer will be retried, and if it succeeds the
> inodes will be unlocked and on we'll go. If the buffer runs out of
> retries, then we need to shut down the filesystem and abort all the
> objects attached to it.....
> 

This all sounds like a good idea to me, but I'll defer to Carlos and
whether he groks it enough to cook up a prototype. :)

Brian

> i.e. there are multiple problems here that need fixing, not one...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
