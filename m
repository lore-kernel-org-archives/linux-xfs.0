Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752658AbdHJScf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 10 Aug 2017 14:32:35 -0400
Date: Thu, 10 Aug 2017 14:32:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170810183233.GG3777@bfoster.bfoster>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
 <20170809213307.GJ21024@dastard>
 <185A1C4516684B439A3711999ABACA79@alyakaslap>
 <20170810113322.GM21024@dastard>
 <63920C3663124B75BC0983A17533395A@alyakaslap>
 <20170810145248.GE3777@bfoster.bfoster>
 <20170810175548.GX24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810175548.GX24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, libor.klepac@bcom.cz

On Thu, Aug 10, 2017 at 10:55:48AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 10, 2017 at 10:52:49AM -0400, Brian Foster wrote:
> > On Thu, Aug 10, 2017 at 03:09:09PM +0300, Alex Lyakas wrote:
...
> > OTOH, just adding deferred ops buffer relogging might not be too much
> > trouble either. ;) Anyways, thoughts?
> 
> I don't think it'd be difficult to add a _defer_bjoin operation that
> maintains a list of buffers that we need to bhold across rolls.
> 
> I think xfs_buf->b_list is only used for delwri buffers, and a buffer
> cannot be part of a transaction /and/ on a delwri list at the same time,
> right?  So it shouldn't be hard to whip something up and couple this
> patch to that.
> 

Hmm.. so if a buffer is modified, logged, committed, put on the AIL and
pushed, xfs_buf_item_push() locks it, puts it on the delwri queue and
unlocks. At that point, I _think_ it may be possible for another thread
to lock the buffer and join it to a new transaction. The delwri submit
skips the buffer if it has become pinned or locked since the delwri
queue (though I'm wondering if that unlocked pin check is racy against
locked buffer modifications. I suppose that would require a full
lock->pin->unlock cycle between the pin check and trylock however).

All that said, it looks like xfs_defer_ops uses a fixed size array for
relogged inodes. Perhaps use something similar for buffers?

The question I have for buffer relogging is what's the best way to track
the parts of the buffer that need to be relogged after a roll?
Copy/translate the dirty (xfs_buf_log_format) segment map(s)?

Brian

> --D
> 
> > 
> > Brian
> > 
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > 
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
