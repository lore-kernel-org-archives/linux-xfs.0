Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:31971 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751439AbdHKCWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 22:22:07 -0400
Date: Fri, 11 Aug 2017 12:22:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170811022204.GQ21024@dastard>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
 <20170810183233.GG3777@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810183233.GG3777@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Thu, Aug 10, 2017 at 02:32:33PM -0400, Brian Foster wrote:
> On Thu, Aug 10, 2017 at 10:55:48AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 10, 2017 at 10:52:49AM -0400, Brian Foster wrote:
> > > On Thu, Aug 10, 2017 at 03:09:09PM +0300, Alex Lyakas wrote:
> ...
> > > OTOH, just adding deferred ops buffer relogging might not be too much
> > > trouble either. ;) Anyways, thoughts?
> > 
> > I don't think it'd be difficult to add a _defer_bjoin operation that
> > maintains a list of buffers that we need to bhold across rolls.
> > 
> > I think xfs_buf->b_list is only used for delwri buffers, and a buffer
> > cannot be part of a transaction /and/ on a delwri list at the same time,
> > right?  So it shouldn't be hard to whip something up and couple this
> > patch to that.
> > 
> 
> Hmm.. so if a buffer is modified, logged, committed, put on the AIL and
> pushed, xfs_buf_item_push() locks it, puts it on the delwri queue and
> unlocks. At that point, I _think_ it may be possible for another thread
> to lock the buffer and join it to a new transaction. The delwri submit
> skips the buffer if it has become pinned or locked since the delwri
> queue (though I'm wondering if that unlocked pin check is racy against
> locked buffer modifications. I suppose that would require a full
> lock->pin->unlock cycle between the pin check and trylock however).

If it does race, we still catch pinned buffers in xfs_buf_submit() and
block there on them. SO a race is just sub-optimal behaviour, not a
bug.

> The question I have for buffer relogging is what's the best way to track
> the parts of the buffer that need to be relogged after a roll?
> Copy/translate the dirty (xfs_buf_log_format) segment map(s)?

Just mark it ordered?

That way it goes through the transaction commit, pinned and put into
the CIL and  gets moved forward in the AIL when the log checkpoints.
We don't need to relog the actual contents in this case, just ensure
it moves forward in the AIL appropriately while we hold it locked.
The ordered flag is removed at each commit the buffer goes through,
so as soon as we commit the final transaction it'll go back to
behaving like a normal buffer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
