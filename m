Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E33517FF7
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 08:40:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 639EDAC006
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 06:40:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wFDuctEFlK2TNH30 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 06:40:09 -0700 (PDT)
Date: Tue, 28 Jul 2015 09:40:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 1/2] xfs: return committed status from xfs_trans_roll()
Message-ID: <20150728134006.GD38784@bfoster.bfoster>
References: <1437682410-51778-3-git-send-email-bfoster@redhat.com>
	<1437682410-51778-2-git-send-email-bfoster@redhat.com>
	<20150728004009.GB24249@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150728004009.GB24249@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 28, 2015 at 10:40:09AM +1000, Dave Chinner wrote:
> [ reply to both patches in one reply, because it's related. ]
> 
> On Thu, Jul 23, 2015 at 04:13:29PM -0400, Brian Foster wrote:
> > Some callers need to make error handling decisions based on whether the
> > current transaction successfully committed or not. Rename
> > xfs_trans_roll(), add a new parameter and provide a wrapper to preserve
> > existing callers.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_trans.c | 15 +++++++++++++--
> >  fs/xfs/xfs_trans.h |  1 +
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 0582a27..a0ab1da 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -1019,9 +1019,10 @@ xfs_trans_cancel(
> >   * chunk we've been working on and get a new transaction to continue.
> >   */
> >  int
> > -xfs_trans_roll(
> > +__xfs_trans_roll(
> >  	struct xfs_trans	**tpp,
> > -	struct xfs_inode	*dp)
> > +	struct xfs_inode	*dp,
> > +	int			*committed)
> >  {
> >  	struct xfs_trans	*trans;
> >  	struct xfs_trans_res	tres;
> > @@ -1052,6 +1053,7 @@ xfs_trans_roll(
> >  	if (error)
> >  		return error;
> 
> So here we return committed = 0, error != 0.
> 
> >  
> > +	*committed = 1;
> >  	trans = *tpp;
> 
> And from here on in we return committed = 1 regardless of the error.
> 
> So looking at the next patch in xfs_bmap_finish():
> 
> >  			free->xbfi_blockcount);
> >  
> > -	error = xfs_trans_roll(tp, NULL);
> > -	*committed = 1;
> > +	error = __xfs_trans_roll(tp, NULL, committed);
> > +
> >  	/*
> > -	 * We have a new transaction, so we should return committed=1,
> > -	 * even though we're returning an error.
> > +	 * We have a new transaction, so we should return committed=1, even
> > +	 * though we're returning an error. If an error was returned after the
> > +	 * original transaction was committed, defer the error handling until
> > +	 * the EFD is logged. We do this because a committed EFI requires an EFD
> > +	 * transaction to be processed to ensure the EFI is released.
> >  	 */
> > -	if (error)
> > +	if (error && *committed == 0) {
> > +		*committed = 1;
> >  		return error;
> > +	}
> 
> So if we failed to commit the EFI, we say we did and then return.
> Why do we need to do that?
> 
> /me goes an looks at all the callers.
> 
> Hmm - only xfs_itruncate_extents() relies on that behaviour, but it
> could just as easily do an inode join on error, because on success
> the inode has already been joined to the new transaction by
> xfs_trans_roll().
> 

Interesting, though I don't follow why this caller even depends on it.
It doesn't transfer lock ownership to the transaction. What difference
does it make in the error path if the inode is joined?

> Looking further, we have quite a bit of inconsistency in the error
> handling of xfs_bmap_finish() - some callers issue a
> xfs_bmap_cancel() in the error path, and some don't. failing to
> cancel the freelist on error looks to me like a memory leak, because
> we don't free the extents from the free list until the EFD for the
> extent has been logged. If we error out earlier, we still have items
> on the free list that haven't been processed.
> 
> So it looks to me like we need fixes there.
> 

Heh, not too surprising. I'll make a note to make a pass through these.

> Further, it appears to me that there is really one xfs_bmap_finish()
> caller that requires the committed flag: xfs_qm_dqalloc(). All the
> others either use it for an assert or joining the inode to the
> transaction when committed = 1, which xfs_trans_roll() will have
> already done if we return committed = 1....
> 

Assuming xfs_trans_reserve() hasn't failed, which could cause *committed
== 1 without the inode joined. We could probably change this in
__xfs_trans_roll() since the inode is presumably already locked.

> 
> So xfs_qm_dqalloc(), on error, simply cancels the freelist and
> returns the error - it ignores the committed flag. So the committed
> flag is used to determine how to handle the dquot buffer:
> 
>         xfs_trans_bhold(tp, bp);
> 
>         if ((error = xfs_bmap_finish(tpp, &flist, &committed))) {
>                 goto error1;
>         }
> 
>         if (committed) {
>                 tp = *tpp;
>                 xfs_trans_bjoin(tp, bp);
>         } else {
>                 xfs_trans_bhold_release(tp, bp);
>         }
> 
> Now, xfs_trans_bhold() simply sets the BLI_HOLD flag on the buffer,
> and transaction commit clears it. That means we could call it
> unconditionally, and all we have to do is remove an assert(BLI_HOLD)
> from xfs_trans_bhold_release() to enable that. Given this is the
> only caller of xfs_trans_bhold_release(), I don't see a problem with
> doing that. Nor is there a problem with multiple joins of an object
> to a transaction, so we could simply make this:
> 
> 	xfs_trans_bhold(tp, bp);
> 	error = xfs_bmap_finish(tpp, &flist, &committed);
> 	if (error)
> 		goto error1;
> 	tp = *tpp;
> 	xfs_trans_bjoin(tp, bp);
> 	xfs_trans_bhold_release(tp, bp);
> 
> And the committed flag is not necessary. With this, we can hide
> everything to do with error on commit vs error after commit inside
> xfs_bmap_finish()...
> 

Seems reasonable at a glance.

> >  	efd = xfs_trans_get_efd(*tp, efi, flist->xbf_count);
> >  	for (free = flist->xbf_first; free != NULL; free = next) {
> >  		next = free->xbfi_next;
> > -		if ((error = xfs_free_extent(*tp, free->xbfi_startblock,
> > -				free->xbfi_blockcount))) {
> > +
> > +		/*
> > +		 * Free the extent if the above trans roll hasn't failed and log
> > +		 * the EFD before handling errors from either call to ensure the
> > +		 * EFI reference is accounted for in the tp. Otherwise, the EFI
> > +		 * is never released on abort and pins the AIL indefinitely.
> > +		 */
> > +		if (!error)
> > +			error = xfs_free_extent(*tp, free->xbfi_startblock,
> > +						free->xbfi_blockcount);
> > +		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
> > +					 free->xbfi_blockcount);
> > +		if (error) {
> >  			/*
> >  			 * The bmap free list will be cleaned up at a
> >  			 * higher level.  The EFI will be canceled when
> > @@ -118,11 +134,10 @@ xfs_bmap_finish(
> >  						   SHUTDOWN_META_IO_ERROR);
> >  			return error;
> >  		}
> > -		xfs_trans_log_efd_extent(*tp, efd, free->xbfi_startblock,
> > -			free->xbfi_blockcount);
> >  		xfs_bmap_del_free(flist, NULL, free);
> >  	}
> > -	return 0;
> > +
> > +	return error;
> 
> This loop doesn't obviously do the right thing now. It
> will log the first extent into the EFD and then trigger a shutdown
> and return. The extent count in the EFD may not match the
> extent count on the EFI, so releasing the EFD at this point may not
> release all the extents in the EFI and hence not release the EFI.
> 

The EFD unlock handler forcibly releases the EFI on abort. It drops the
EFI extent count reference by whatever the extent count on the EFD is,
and that is determined on EFD initialization (xfs_trans_get_efd())
regardless of how many extents were logged to the EFD.

That said, the error handling here is certainly not obvious because it
depends on the lifecycle of the associated log items. The broader goal
is to reduce that dependency so the code here is more straightforward...

> I think I'd prefer to see a xfs_trans_cancel_efi() call to handle
> this error path rather than having to go through the efd to release
> the reference on the EFI. i.e.
> 
> 	error = __xfs_trans_roll(tp, NULL, &committed);
> 	if (error) {
> 		if (committed) {
> 			if (!XFS_FORCED_SHUTDOWN(mp))
> 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> 			xfs_efi_cancel(tp, efi);
> 		}
> 		return error;
> 	}
> 

That's a nice idea. It pulls some error handling out of the log item
handling code explicitly. An EFD version might be useful for the
unlogged EFD error case as well. IMO, the more of these cases that are
handled explicitly in xfs_bmap_finish() rather than implicitly via the
transaction management code, the more reliable and robust to future
change it will be. I'll explore it further...

> /*
>  * Cancel a committed EFI after triggering a shutdown. We need to do
>  * this so that the committed EFI is removed from the AIL and freed,
>  * otherwise unmount will hang due to a non-empty AIL.
>  */
> xfs_efi_cancel()
> {
> 	ASSERT(XFS_FORCED_SHUTDOWN(mp));
> 	xfs_efi_release(efi, efi->nextents);
> }
> 
> Doing this means there's less complexity on the EFD abort side of
> things, as we don't have to now handle this failure case via
> transaction completion callback interface.
> 

Indeed.

> Hmmm - something I just noticed: if we only have one EFD per EFI,
> why do we do we have that layer of extent counting before dropping
> real references?
> 

I wondered this myself, but hadn't made it deep enough to see if we used
the reference count elsewhere.

> >  xfs_efd_item_unlock(
> >  	struct xfs_log_item	*lip)
> >  {
> > -	if (lip->li_flags & XFS_LI_ABORTED)
> > -		xfs_efd_item_free(EFD_ITEM(lip));
> > +	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
> > +
> > +	if (lip->li_flags & XFS_LI_ABORTED) {
> > +		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
> > +		xfs_efd_item_free(efdp);
> > +	}
> >  }
> 
> i.e. we always call xfs_efi_release() with efi_nextents or
> efd_nextents, which are always the same, and so we never partially
> complete an EFI. Should we just kill that layer, as it does tend to
> complicate the EFI release code?
> 

Yeah, that might be a good idea if we don't use the reference count
elsewhere. I'll look into that as a subsequent cleanup as well.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
