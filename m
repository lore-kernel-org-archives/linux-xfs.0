Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55830 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757294AbdELLhP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 07:37:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE9F77AE95
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2017 11:37:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AE01784BF
        for <linux-xfs@vger.kernel.org>; Fri, 12 May 2017 11:37:14 +0000 (UTC)
Date: Fri, 12 May 2017 07:37:13 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: Add infrastructure needed for error propagation
 during buffer IO failure
Message-ID: <20170512113713.GA15623@bfoster.bfoster>
References: <20170511135733.21765-1-cmaiolino@redhat.com>
 <20170511135733.21765-2-cmaiolino@redhat.com>
 <20170511165124.GA14148@localhost.localdomain>
 <20170512084115.rs3ufqbagffevivc@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512084115.rs3ufqbagffevivc@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, May 12, 2017 at 10:41:15AM +0200, Carlos Maiolino wrote:
> Howdy!
> 
> On Thu, May 11, 2017 at 12:51:24PM -0400, Brian Foster wrote:
> > On Thu, May 11, 2017 at 03:57:32PM +0200, Carlos Maiolino wrote:
> > > To be able to resubmit an log item for IO, we need a way to mark an item
> > > as failed, if, for any reason the buffer which the item belonged to
> > > failed during writeback.
> > > 
> > > Add a new log item callback to be used after an IO completion failure
> > > and make the needed clean ups.
> > > 
> > 
> > I think the commit log description should call out the problem with
> > flush locked items (i.e., that we will currently never resubmit their
> > buffers) as the motiviation for the patch.
> >
> 
> I believe this patch is more a generic way to handle failed writebacks than
> related to the never re-submitted buffers, although, I agree that the main
> reason for this patch is the failed buffer resubmission, I don't think this
> patch deals with it directly, that's why I didn't comment it in this patch,
> but in patch two.
> 
> I have no objection in mentioning it here though if required.
> 

The commit log currently just says "To be able to resubmit an log item
for IO, ...", which is something the AIL does today. So why do we need
this patch? :)

IOWs, I'm just asking that the commit log include a couple sentences or
so on the purpose of the patch. E.g., why is what the AIL does today
insufficient? (You could point out explicitly that it doesn't handle
certain cases correctly and we need a more generic mechanism in place to
handle those cases, citing the flush lock example).

> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  fs/xfs/xfs_buf_item.c | 27 ++++++++++++++++++++++++++-
> > >  fs/xfs/xfs_trans.h    |  5 ++++-
> > >  2 files changed, 30 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > index 0306168..026aed4 100644
> > > --- a/fs/xfs/xfs_buf_item.c
> > > +++ b/fs/xfs/xfs_buf_item.c
> > > @@ -1051,6 +1051,24 @@ xfs_buf_do_callbacks(
> > >  	}
> > >  }
> > >  
> > > +STATIC void
> > > +xfs_buf_do_callbacks_fail(
> > > +	struct xfs_buf		*bp)
> > > +{
> > > +	struct xfs_log_item	*lip, *next;
> > > +	unsigned int		bflags = bp->b_flags;
> > > +
> > > +	lip = bp->b_fspriv;
> > > +	while (lip != NULL) {
> > > +		next = lip->li_bio_list;
> > > +
> > > +		if (lip->li_ops->iop_error)
> > > +			lip->li_ops->iop_error(lip, bflags);
> > 
> > I still don't see why we need the iop callback here. This type of
> > callback is typically required when an operation requires some action on
> > the specific subtype (e.g., _inode_item_error() does one particular
> > thing to an inode, buf_item_error() might do something different to an
> > xfs_buf, etc.), but that doesn't appear to be the case here. Indeed, the
> > next patch shows that the inode item error handler does:
> > 
> > 	lip->li_flags |= XFS_LI_FAILED;
> > 
> > ... which doesn't even require to dereference the inode_log_item type.
> > 
> > So can we just set the flag directly from xfs_buf_do_callbacks_fail()
> > and kill of ->iop_error() until/unless we come to a point where it is
> > actually needed?
> 
> Well, I really have no preference here, this could also be handled directly into
> xfs_inode_callback_error(), but seems like the idea is to keep those changes
> into item-type specific callbacks, but I won't oppose to any approach, at this
> point in time, I just want to have his fixed :)
> 

Heh, I feel your pain (and sorry :P). I'd care less if it we were
discussing details of a helper function or something like that, but I
really don't think we should be expanding ->li_ops for calls that don't
care about the type-specific log item or otherwise have a specific
purpose.

> Although, after giving it some thought, I tend to agree that leaving it into
> their all callback error handler looks more correct, and more convenient, but,
> that's just my opinion.
> 

AFAICT, the only side effect it has currently is to enable selective
appropriation of the flag (e.g., we only currently set it for inodes,
and soon dquots). That in and of itself seems inappropriate if we're
using a generic xfs_log_item flag. Put another way, if this is truly a
generic mechanism, then the new XFS_LI_FAILED state that we are creating
should apply generically to all xfs_log_item objects rather than
selectively to the ones where we need it to solve a specific deadlock
problem. Otherwise, anybody looking at XFS_LI_FAILED usage years down
the road is probably just going to be confused.

We've basically defined a metadata type-specific callback handler (e.g.,
xfs_inode_log_item) for something that doesn't even need to look at the
specific log item type. It looks to me like unnecessary code, an
unnecessary level of indirection and probably something that somebody
else will just end up removing after the fact.

> > 
> > > +
> > > +		lip = next;
> > > +	}
> > > +}
> > > +
> > >  static bool
> > >  xfs_buf_iodone_callback_error(
> > >  	struct xfs_buf		*bp)
> > > @@ -1153,8 +1171,15 @@ xfs_buf_iodone_callbacks(
> > >  	 * to run callbacks after failure processing is done so we
> > >  	 * detect that and take appropriate action.
> > >  	 */
> > > -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> > > +	if (bp->b_error && xfs_buf_iodone_callback_error(bp)) {
> > > +
> > > +		/*
> > > +		 * We've got an error during buffer writeback, we need to notify
> > > +		 * the items in the buffer
> > > +		 */
> > > +		xfs_buf_do_callbacks_fail(bp);
> > 
> > xfs_buf_iodone_callback_error() returns true when the I/O has failed. It
> > also returns true when it has submitted the internal retry[1], however,
> > so I don't think this is quite correct. We should only mark items as
> > failed once this internal sequence has completed and the buffer is no
> > longer under I/O. As it is, this looks like it would mark the items as
> > failed while they are still under the internal retry I/O (and possibly
> > leave them marked as such if this retry actually succeeds..?).
> > 
> 
> > Side note: I really dislike the semantics of
> > xfs_buf_iodone_callback_error() in that I have to read it and the only
> > call site to re-understand what the return value means every time I look
> > at it. Could we add a comment above that function that explains the
> > return value dictates whether to run callbacks while we're working in
> > this area?
> > 
> > Brian
> > 
> > [1] Recall that every buffer submitted through xfsaild() is quietly
> > retried one time in the event of I/O error (via XBF_WRITE_FAIL) before
> > the buffer is unlocked and effectively released back to the AIL. This is
> > presumably to help deal with transient errors. It is only when this
> > second I/O fails that the buffer is unlocked and it is up to the AIL to
> > resubmit the buffer on a subsequent push.
> > 
> Yeah, I agree here, I wonder if wouldn't be a good approach to change the
> xfs_buf_iodone_callback_error to return something other than a bool, so we can
> properly check what happened, i.e. internal retry, retry based on configuration,
> or whatever. I will write some POC for this, I just wonder though, if, after
> having the configuration handlers available, do we really need to do this first
> forced retry.
> 

Perhaps not, but that's something that should probably be evaluated
separately and after this issue is resolved.

WRT xfs_buf_iodone_callback_error(), I personally think returning void
and setting a do_callbacks bool as a parameter would be notably more
clear than the current semantics. It could be expanded in the future to
return more specific state, if necessary.

But xfs_buf_do_callbacks_fail() should probably be called directly from
xfs_buf_iodone_callback_error() before the buffer lock is released and
the buffer implicitly released back to the AIL. Otherwise, an xfsaild
race can lead to observing the log item in a spurious flushing state
after the I/O had failed, or worse, possibly set XFS_LI_FAILED on some
items after the buffer has been resubmitted.

> 
> Thanks, for the review, I'll wait Dave's comments before sending a V2 though
> once the callbacks idea came from him, in the meantime I'll take a look how can
> I improve the callback_error stuff.
> 

Sounds good.

Brian

> Cheers
> 
> > >  		return;
> > > +	}
> > >  
> > >  	/*
> > >  	 * Successful IO or permanent error. Either way, we can clear the
> > > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > > index a07acbf..c57181a 100644
> > > --- a/fs/xfs/xfs_trans.h
> > > +++ b/fs/xfs/xfs_trans.h
> > > @@ -65,10 +65,12 @@ typedef struct xfs_log_item {
> > >  
> > >  #define	XFS_LI_IN_AIL	0x1
> > >  #define XFS_LI_ABORTED	0x2
> > > +#define XFS_LI_FAILED	0x3
> > >  
> > >  #define XFS_LI_FLAGS \
> > >  	{ XFS_LI_IN_AIL,	"IN_AIL" }, \
> > > -	{ XFS_LI_ABORTED,	"ABORTED" }
> > > +	{ XFS_LI_ABORTED,	"ABORTED" }, \
> > > +	{ XFS_LI_FAILED,	"FAILED" }
> > >  
> > >  struct xfs_item_ops {
> > >  	void (*iop_size)(xfs_log_item_t *, int *, int *);
> > > @@ -79,6 +81,7 @@ struct xfs_item_ops {
> > >  	void (*iop_unlock)(xfs_log_item_t *);
> > >  	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
> > >  	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
> > > +	void (*iop_error)(xfs_log_item_t *, unsigned int bflags);
> > >  };
> > >  
> > >  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
> > > -- 
> > > 2.9.3
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
