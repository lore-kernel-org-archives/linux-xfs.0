Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17542 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbcJCWIv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Oct 2016 18:08:51 -0400
Date: Tue, 4 Oct 2016 09:08:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] Release buffer locks in case of IO error
Message-ID: <20161003220845.GO27872@dastard>
References: <1475154199-28880-1-git-send-email-cmaiolino@redhat.com>
 <20160930000147.GH27872@dastard>
 <20160930145413.GB27528@bfoster.bfoster>
 <20161001002104.GK27872@dastard>
 <20161001132728.GA56484@bfoster.bfoster>
 <20161003140354.4tyaxkrczygu4bc5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161003140354.4tyaxkrczygu4bc5@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Oct 03, 2016 at 04:03:54PM +0200, Carlos Maiolino wrote:
> > > What you're now saying is that there is /another/ problem to do with
> > > the retry side of the code, were an item that is flush locked is not
> > > correctly resubmitted for IO, because the item is still flush
> > > locked.
> > > 
> > 
> > Well, that's the only issue that I'm actually aware of and that was the
> > target of the experiment. What I'm saying, specifically, is Carlos' test
> > reproduces an unmount hang due to the broken AIL retry problem for flush
> > locked buffers. For example:
> 
> This is basically all we are seeing, and is causing the problem, items that are
> flush locked are not being resubmitted for IO, and, in case of unmount, xfsaild
> keeps spinning on these locked items, once they can't be resubmitted.

Hi Carlos,

I understand the issue - I don't need more explanation of the
problem. Unfortunately, having the problem redescribed to me tends
to indicate that my explanation of the underlying cause and solution
was not sufficient for people to understand what I was describing...
:/ That's my fault for not explaining it clearly enough....

The basic problem is that we are not propagating error state from
the buffer to the objects attached to the buffer. In the case of
inodes and dquots, the primary item being controlled by the AIL is
the inode/dquot, not the buffer being submitted for IO. Hence for
the AIL to be able to issue a retry on IO failure on an inode or
dquot, we have to first mark those items as having failed. This is
necessary so the AIL push code can explicitly handle this state, and
not have to guess or infer whether a retry may be required or not.

> Just another example where this bug can be triggered, is still using dm-thin,
> but, instead of unmounting the filesystem and expect it to shutdown, we extend
> the POOL device, allowing more space, so the items can be properly flushed.
> 
> In this case, the following steps can trigger the problem (using fake values
> just for make it simpler to understand):
> 
> - Create a dm-thin POOL (ex: 100MB)
> - Create a dm-thin device overcommiting the POOL (ex: 200MB)
> - mkfs.xfs the dm-thin device
> - snapshot the dm-thin device
> - Mount the snapshot and fill it (using a single dd works here)
> 
> - dd command will fail with an EIO, dm-thin will report it back to XFS, which will
> trigger metadata IO errors, and keep the AIL items locked and 'theoretically'
> trying to resubmit the buffers.

XFS resubmits buffer items that fail from the AIL just fine - we've
got tests that trigger retries and shutdowns on this sort of
behaviour. The point is that these buffers are primary item that the
AIL is aware of, whilst the AIL is not aware of inode/dquot buffers
at all(*).

What we need to do is propagate the buffer error to the primary
items that are attached to the buffer and processed by the
bp->b_iodone callback. When we get an error and we need to retry,
the callback can mark the inodes/dquots with a "write fail" state
without unlocking the inode.  We can then check this state we find
the item flush locked when trying to push it. This takes all the
guess work out of determining if a retry is needed for any given
inode item.  Retry at this point is then simple - similar to what
what in the first patch that you sent.

However, if the buffer has expired all it's retries and we now
permanently fail the buffer, we also have to permanently fail
all the inodes/dquots. This involves triggering a shutdown, then
aborting all the inode/dquots on the buffer. This will remove the
inodes/dquots from the AIL and hence prevent the inodes/dquots from
getting stuck flush locked in the AIL after a shutdown has occurred.

IOWs, to be able to implement a reliable retry behaviour we first
need to have a solid error propagation model. Error propagation
comes first, retry logic comes second.

Cheers,

Dave.

(*) gross simplifiation - it is aware of them in certain situations such
as allocation and freeing, but these aren't relevant to the problem
at hand.
-- 
Dave Chinner
david@fromorbit.com
