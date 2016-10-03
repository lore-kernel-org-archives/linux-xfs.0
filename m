Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752791AbcJCOD7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Oct 2016 10:03:59 -0400
Date: Mon, 3 Oct 2016 16:03:54 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20161003140354.4tyaxkrczygu4bc5@redhat.com>
References: <1475154199-28880-1-git-send-email-cmaiolino@redhat.com>
 <20160930000147.GH27872@dastard>
 <20160930145413.GB27528@bfoster.bfoster>
 <20161001002104.GK27872@dastard>
 <20161001132728.GA56484@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161001132728.GA56484@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Hi folks,

First I apologize if I caused any confusion with the root cause here, I will try
to clear it a bit on the lines below, and I'll try to write some more detailed
e-mail later explaining what I have until now, I just need to compact it and put
my investigation notes in some way everybody else will understand;


> > What you're now saying is that there is /another/ problem to do with
> > the retry side of the code, were an item that is flush locked is not
> > correctly resubmitted for IO, because the item is still flush
> > locked.
> > 
> 
> Well, that's the only issue that I'm actually aware of and that was the
> target of the experiment. What I'm saying, specifically, is Carlos' test
> reproduces an unmount hang due to the broken AIL retry problem for flush
> locked buffers. For example:

This is basically all we are seeing, and is causing the problem, items that are
flush locked are not being resubmitted for IO, and, in case of unmount, xfsaild
keeps spinning on these locked items, once they can't be resubmitted.

Just another example where this bug can be triggered, is still using dm-thin,
but, instead of unmounting the filesystem and expect it to shutdown, we extend
the POOL device, allowing more space, so the items can be properly flushed.

In this case, the following steps can trigger the problem (using fake values
just for make it simpler to understand):

- Create a dm-thin POOL (ex: 100MB)
- Create a dm-thin device overcommiting the POOL (ex: 200MB)
- mkfs.xfs the dm-thin device
- snapshot the dm-thin device
- Mount the snapshot and fill it (using a single dd works here)

- dd command will fail with an EIO, dm-thin will report it back to XFS, which will
trigger metadata IO errors, and keep the AIL items locked and 'theoretically'
trying to resubmit the buffers.

- Extend dm-thin POOL to something big enough (let's say 500MB)



At this point, the metadata IO errors stop to be reported by XFS, but even
though we now have enough space, the AIL flush locked items are never
resubmitted and xfsaild keeps spinning on them and they are never flushed.


Here though, we might have 2 different behaviors

-xfs will lock up spinning in xfsaild if anyone tries to unmount the filesystem,
the same behavior as before (without extending the dm-thin POOL)

- If any IO is issued to the filesystem, after extending this (a simple `touch
  /mnt/foobar` works), everything goes back to normal, items in AIL are
  resubmitted, and the filesystem can be unmounted normally.

I will try to explain it with call paths later, as soon as I reorganize my logs
here.



> 
> - Filesystem is humming along normally until the dm device shuts down,
>   as expected, and metadata writeback begins to fail.
> - One of such failed items is a flush locked inode. We hit
>   xfs_buf_iodone_callback_error() and do not shut down the fs because
>   we're using the default error config (retry forever).
> - The inode log item ends up back on the AIL in the flush locked state.
> - An unmount occurs, some other item is retried, fails and triggers the
>   shutdown on umount check in *_iodone_callback_error().
> - The unmount remains hung, despite the shutdown, because the AIL is
>   spinning on the flush locked inode item. It can't abort the item
>   because it cannot be retried, which would detect the shutdown state in
>   the iodone handler, issue the callbacks and remove it from the AIL.
> 
> This is the state I seemed to reproduce in the handful of times I ran
> Carlos' reproducer. E.g., the filesystem does actually shut down
> correctly on unmount, but the umount was still hung spinning on a flush
> locked item. Hence the experiment to retry the apparently stuck inode
> buffer. This tests the broken retry theory and seemingly works around
> (not fixes) the problem.
> 
> With that (hopefully clarified), you're losing me with regard to the
> separate "abort on permanent failure" problem. It's not clear to me
> whether we're confusing the root cause of the same fundamental issue or
> there is just another problem that I'm just not aware of. Assuming the
> latter, could you please elaborate on that issue to clarify it from the
> one described above?
> 
> > Ok, yes, now that it's clear this isn't actually addressing
> > fail_at_unmount permanent errors, I can see that there is a retry
> > problem here. However, I don't think this patch is
> > the correct way to address that, either, because the buffer lookup
> > cost is prohibitive.
> > 
> 
> As mentioned, this was just a test to see if a resubmission would
> unstick the fs and if so, start a discussion on a proper fix.
> 
> > I think the correct thing to do - again - is to run the iodone
> > callbacks on a "retriable error". i.e. on an error that needs to be
> > retried, we:
> > 
> > 	- run callbacks on each object attached to buffer
> > 	- each object gets marked as "write fail"
> > 	- each object remains flush locked
> > 	- the position in the AI lof each object is unchanged
> > 	- buffer remains marked with _XBF_WRITE_FAIL
> > 
> > We cannot unlock the flush lock until the state on disk
> > matches the state we flushed from the in-memory object to the buffer
> > that is failing, hence we need some other method for indicating a
> > new submission is required.
> > 
> > If we then find an object flush locked on an AIL push, we:
> > 
> > 	- check the object for the "write fail" flag. If not set,
> > 	  there's nothing more to do.
> > 	- look up the underlying buffer, check the _XBF_WRITE_FAIL
> > 	  flag. If that's not set, we've raced with another IO doing
> > 	  a retry or new submission. Nothing more to do.
> > 	- with the buffer now locked, walk all the objects attached
> > 	  and clear the "write fail" flags. This is needed to
> > 	  prevent attempting to resubmit the buffer for every object
> > 	  attached to the buffer as the AIL push walks down the
> > 	  list.
> > 	- add the buffer to the delwri list.
> > 
> > At that point, the buffer will be retried, and if it succeeds the
> > inodes will be unlocked and on we'll go. If the buffer runs out of
> > retries, then we need to shut down the filesystem and abort all the
> > objects attached to it.....
> > 
> 
> This all sounds like a good idea to me, but I'll defer to Carlos and
> whether he groks it enough to cook up a prototype. :)
> 
> Brian
> 
> > i.e. there are multiple problems here that need fixing, not one...
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
