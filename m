Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 43BF77FA8
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 06:47:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B983BAC008
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 04:47:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ku4IBKEOKrm2oSbB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 04:47:53 -0700 (PDT)
Date: Wed, 29 Jul 2015 07:47:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 1/2] xfs: return committed status from xfs_trans_roll()
Message-ID: <20150729114751.GB61108@bfoster.bfoster>
References: <1437682410-51778-3-git-send-email-bfoster@redhat.com>
	<1437682410-51778-2-git-send-email-bfoster@redhat.com>
	<20150728004009.GB24249@dastard>
	<20150728134006.GD38784@bfoster.bfoster>
	<20150728215140.GC24249@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150728215140.GC24249@dastard>
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

On Wed, Jul 29, 2015 at 07:51:40AM +1000, Dave Chinner wrote:
> On Tue, Jul 28, 2015 at 09:40:06AM -0400, Brian Foster wrote:
> > On Tue, Jul 28, 2015 at 10:40:09AM +1000, Dave Chinner wrote:
> > > [ reply to both patches in one reply, because it's related. ]
> > > 
> > > On Thu, Jul 23, 2015 at 04:13:29PM -0400, Brian Foster wrote:
...
> > > >  			free->xbfi_blockcount);
> > > >  
> > > > -	error = xfs_trans_roll(tp, NULL);
> > > > -	*committed = 1;
> > > > +	error = __xfs_trans_roll(tp, NULL, committed);
> > > > +
> > > >  	/*
> > > > -	 * We have a new transaction, so we should return committed=1,
> > > > -	 * even though we're returning an error.
> > > > +	 * We have a new transaction, so we should return committed=1, even
> > > > +	 * though we're returning an error. If an error was returned after the
> > > > +	 * original transaction was committed, defer the error handling until
> > > > +	 * the EFD is logged. We do this because a committed EFI requires an EFD
> > > > +	 * transaction to be processed to ensure the EFI is released.
> > > >  	 */
> > > > -	if (error)
> > > > +	if (error && *committed == 0) {
> > > > +		*committed = 1;
> > > >  		return error;
> > > > +	}
> > > 
> > > So if we failed to commit the EFI, we say we did and then return.
> > > Why do we need to do that?
> > > 
> > > /me goes an looks at all the callers.
> > > 
> > > Hmm - only xfs_itruncate_extents() relies on that behaviour, but it
> > > could just as easily do an inode join on error, because on success
> > > the inode has already been joined to the new transaction by
> > > xfs_trans_roll().
> > > 
> > 
> > Interesting, though I don't follow why this caller even depends on it.
> > It doesn't transfer lock ownership to the transaction. What difference
> > does it make in the error path if the inode is joined?
> 
> Callers of xfs_itruncate_extents() expect it to be locked and joined
> on return, even on error.
> 

All of the callers I see cancel the transaction and unlock the inode
separately on error. I could be glossing over some obvious point here,
but so far I'm not seeing it...

> > > Looking further, we have quite a bit of inconsistency in the error
> > > handling of xfs_bmap_finish() - some callers issue a
> > > xfs_bmap_cancel() in the error path, and some don't. failing to
> > > cancel the freelist on error looks to me like a memory leak, because
> > > we don't free the extents from the free list until the EFD for the
> > > extent has been logged. If we error out earlier, we still have items
> > > on the free list that haven't been processed.
> > > 
> > > So it looks to me like we need fixes there.
> > > 
> > 
> > Heh, not too surprising. I'll make a note to make a pass through these.
> > 
> > > Further, it appears to me that there is really one xfs_bmap_finish()
> > > caller that requires the committed flag: xfs_qm_dqalloc(). All the
> > > others either use it for an assert or joining the inode to the
> > > transaction when committed = 1, which xfs_trans_roll() will have
> > > already done if we return committed = 1....
> > > 
> > 
> > Assuming xfs_trans_reserve() hasn't failed, which could cause *committed
> > == 1 without the inode joined. We could probably change this in
> > __xfs_trans_roll() since the inode is presumably already locked.
> 
> I don't think we can join the inode until after the reservation is
> done. It could still be done in __xfs_trans_roll() regardless.
> 

Hmm, I don't see anything obvious that prevents it. It probably defies
convention though. Anyways, we're probably a few levels of indirection
away from the bug fixes and work that we know needs to happen at this
point. I'll try to get the EFI/EFD stuff worked out, along with some of
the other issues I'm reproducing, then we can go from there...

Brian

> > > > +	return error;
> > > 
> > > This loop doesn't obviously do the right thing now. It
> > > will log the first extent into the EFD and then trigger a shutdown
> > > and return. The extent count in the EFD may not match the
> > > extent count on the EFI, so releasing the EFD at this point may not
> > > release all the extents in the EFI and hence not release the EFI.
> > > 
> > 
> > The EFD unlock handler forcibly releases the EFI on abort. It drops the
> > EFI extent count reference by whatever the extent count on the EFD is,
> > and that is determined on EFD initialization (xfs_trans_get_efd())
> > regardless of how many extents were logged to the EFD.
> > 
> > That said, the error handling here is certainly not obvious because it
> > depends on the lifecycle of the associated log items. The broader goal
> > is to reduce that dependency so the code here is more straightforward...
> 
> *nod*
> 
> > > I think I'd prefer to see a xfs_trans_cancel_efi() call to handle
> > > this error path rather than having to go through the efd to release
> > > the reference on the EFI. i.e.
> > > 
> > > 	error = __xfs_trans_roll(tp, NULL, &committed);
> > > 	if (error) {
> > > 		if (committed) {
> > > 			if (!XFS_FORCED_SHUTDOWN(mp))
> > > 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > 			xfs_efi_cancel(tp, efi);
> > > 		}
> > > 		return error;
> > > 	}
> > > 
> > 
> > That's a nice idea. It pulls some error handling out of the log item
> > handling code explicitly. An EFD version might be useful for the
> > unlogged EFD error case as well. IMO, the more of these cases that are
> > handled explicitly in xfs_bmap_finish() rather than implicitly via the
> > transaction management code, the more reliable and robust to future
> > change it will be. I'll explore it further...
> 
> Yes, that mirrors my thinking exactly - the EFI/EFD error handling
> has always been problematic with the reliance on reference counting
> via transaction commit/abort callbacks to handle it.
> 
> > > Hmmm - something I just noticed: if we only have one EFD per EFI,
> > > why do we do we have that layer of extent counting before dropping
> > > real references?
> > > 
> > 
> > I wondered this myself, but hadn't made it deep enough to see if we used
> > the reference count elsewhere.
> > 
> > > >  xfs_efd_item_unlock(
> > > >  	struct xfs_log_item	*lip)
> > > >  {
> > > > -	if (lip->li_flags & XFS_LI_ABORTED)
> > > > -		xfs_efd_item_free(EFD_ITEM(lip));
> > > > +	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
> > > > +
> > > > +	if (lip->li_flags & XFS_LI_ABORTED) {
> > > > +		xfs_efi_release(efdp->efd_efip, efdp->efd_format.efd_nextents);
> > > > +		xfs_efd_item_free(efdp);
> > > > +	}
> > > >  }
> > > 
> > > i.e. we always call xfs_efi_release() with efi_nextents or
> > > efd_nextents, which are always the same, and so we never partially
> > > complete an EFI. Should we just kill that layer, as it does tend to
> > > complicate the EFI release code?
> > > 
> > 
> > Yeah, that might be a good idea if we don't use the reference count
> > elsewhere. I'll look into that as a subsequent cleanup as well.
> 
> Excellent!
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
