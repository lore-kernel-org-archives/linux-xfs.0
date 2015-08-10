Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D77F7F47
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 13:55:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 46CF28F8059
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 11:55:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zneCbmqgHsP98Q6p (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 11:55:41 -0700 (PDT)
Date: Mon, 10 Aug 2015 14:55:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 1/2] xfs: return committed status from xfs_trans_roll()
Message-ID: <20150810185539.GB33960@bfoster.bfoster>
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
...
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

I'm starting to look back at this and try to understand the intent here
(FYI, I've appended some of the xfs_bmap_cancel() fixes to v3 of the
EFI/EFD series, to be posted shortly). Is the proposition that we should
be able to remove the committed parameter from xfs_bmap_finish()
entirely?

If so, the buffer hold technique makes some sense here, but not
necessarily the potential for multiple joins of the object to the
transaction that this kind of usage introduces. At least, there are
currently assertions to protect against that kind of thing in the
buffer/inode join handlers that would have to be removed. In the case of
a buffer join, it looks like there's some reference counting that would
have to be rectified against this type of usage (I take it there is some
appropriate use for this that I'm not familiar with). Both the buffer
and inode cases also look like they'd introduce multiple calls to
xfs_trans_add_item(), which I'm not sure is totally safe at a glance.
The fact that an xfs_log_item points to a single xfs_log_item_desc looks
a bit suspicious to me, but I'd have to take a harder look at that.

Even if it were completely safe, IMO we obfuscate the context of code as
shown above because the object could be added to the new transaction or
re-added to the original depending on whether the previous transaction
freed some blocks or not. In other words, I think a multiple join of an
object has to be made completely idempotent in order to justify use of a
pattern like that shown above. I'm not sure it's worth doing that just
to kill a flag. Thoughts?

Brian

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
> Hmmm - something I just noticed: if we only have one EFD per EFI,
> why do we do we have that layer of extent counting before dropping
> real references?
> 
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
