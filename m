Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933840AbdDGSiR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Apr 2017 14:38:17 -0400
Date: Fri, 7 Apr 2017 14:38:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: fix up quotacheck buffer list error handling
Message-ID: <20170407183806.GE55851@bfoster.bfoster>
References: <1487966001-63263-1-git-send-email-bfoster@redhat.com>
 <1487966001-63263-2-git-send-email-bfoster@redhat.com>
 <20170406223921.GB4864@birch.djwong.org>
 <20170407120229.GA54992@bfoster.bfoster>
 <20170407182042.GM4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170407182042.GM4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Martin Svec <martin.svec@zoner.cz>

On Fri, Apr 07, 2017 at 11:20:42AM -0700, Darrick J. Wong wrote:
> On Fri, Apr 07, 2017 at 08:02:30AM -0400, Brian Foster wrote:
> > On Thu, Apr 06, 2017 at 03:39:21PM -0700, Darrick J. Wong wrote:
> > > On Fri, Feb 24, 2017 at 02:53:19PM -0500, Brian Foster wrote:
> > > > The quotacheck error handling of the delwri buffer list assumes the
> > > > resident buffers are locked and doesn't clear the _XBF_DELWRI_Q flag
> > > > on the buffers that are dequeued. This can lead to assert failures
> > > > on buffer release and possibly other locking problems.
> > > > 
> > > > Update the error handling code to lock each buffer as it is removed
> > > > from the buffer list and clear the delwri queue flag.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_buf.c | 2 ++
> > > >  fs/xfs/xfs_qm.c  | 2 ++
> > > >  2 files changed, 4 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index ac3b4db..e566510 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -1078,6 +1078,8 @@ void
> > > >  xfs_buf_unlock(
> > > >  	struct xfs_buf		*bp)
> > > >  {
> > > > +	ASSERT(xfs_buf_islocked(bp));
> > > > +
> > > >  	XB_CLEAR_OWNER(bp);
> > > >  	up(&bp->b_sema);
> > > >  
> > > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > > index b669b12..4ff993c 100644
> > > > --- a/fs/xfs/xfs_qm.c
> > > > +++ b/fs/xfs/xfs_qm.c
> > > > @@ -1387,6 +1387,8 @@ xfs_qm_quotacheck(
> > > >  	while (!list_empty(&buffer_list)) {
> > > >  		struct xfs_buf *bp =
> > > >  			list_first_entry(&buffer_list, struct xfs_buf, b_list);
> > > > +		xfs_buf_lock(bp);
> > > > +		bp->b_flags &= ~_XBF_DELWRI_Q;
> > > >  		list_del_init(&bp->b_list);
> > > >  		xfs_buf_relse(bp);
> > > 
> > > Hmm, was this the only place we ever _buf_unlock'd an unlocked buffer?
> > > 
> > 
> > I'm not aware of any other places (otherwise I would try to fix them :).
> > Or perhaps I'm not following the question...
> > 
> > I do recall a similar problem with flush locks fixed in commit 98efe8a
> > ("xfs: fix unbalanced inode reclaim flush locking").
> 
> So... the previous quotacheck code reads the buffer, fiddles with it,
> and _buf_relse's the buffer, which unlocks it.  When we end up in this
> error path, we've previously been unlocking an already unlocked buffer,
> right?  So have we just been screwing up the semaphore all this time and
> just never noticed because quotacheck probably doesn't fail all that
> often?  I think it's a good idea (in general) to check for unlocking
> buffers that are already unlocked, but I worry about the side effects.
> 

Pretty much...

> Granted, if there /are/ other places in the regular code path where we
> screw up the buffer locking I imagine we'd have noticed; and if there
> are bugs lurking, better to ASSERT them into the light.  I ran the
> auto group and didn't see anything, so perhaps we're ok enough?
> 

IME, we don't get very far after screwing up mechanisms critical to core
functionality such as a buffer lock or flush lock, at least with asserts
enabled. The new assert just makes the problem more obvious rather than
having to backtrack from a more vague error or crash and locate an
unbalanced locking pattern. This and the other example mentioned above
both occur in rare error/shutdown cases.

Brian

> --D
> 
> > 
> > Brian
> > 
> > > --D
> > > 
> > > >  	}
> > > > -- 
> > > > 2.7.4
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
