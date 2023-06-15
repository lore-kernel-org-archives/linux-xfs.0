Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB87EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 14:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343786AbjFOOl5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 10:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240102AbjFOOlx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 10:41:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FE21707
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 07:41:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C66F6100E
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 14:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE129C433C8;
        Thu, 15 Jun 2023 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686840111;
        bh=rqqTa2oIgan5LWNBDfgR3ZB+ROuNjBlQQE5SCyALJfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Trq/fRqZdBuy9kDbVzzBDxNsjFRy4r+2hC7gTjNB0B7e7gLpnAxbmTXBuzia1I+cb
         9hrnLDzLGEZsKc5xb7PUISnVJQsZorumw6CR+vIh7hr1Hz6CmD/Ged3rwec6H0qsib
         o9WhI1HHO/4nCb2SLE6d9ylRRTE3mSy9YwoWuMAe71nc5iwtCpxHx8R4DNQhT18HzQ
         YYfjnLCLY8dg2UE/YEeEEjBqT4mTbPZ/JuK/tvyBNTTlafg2sYK3HvZhts8ncBfiE1
         vfegQ/P/tqJxQqLrriCqA4T+6vfoVx+lSvOBWf1U6SnNaji7s1NhHyj2NVTuthuxQR
         C7xFPS4923hig==
Date:   Thu, 15 Jun 2023 07:41:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/3] xfs: allow extent free intents to be retried
Message-ID: <20230615144150.GO11441@frogsfrogsfrogs>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-3-david@fromorbit.com>
 <20230615033837.GM11441@frogsfrogsfrogs>
 <ZIqMIgyHBmZu4jxb@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIqMIgyHBmZu4jxb@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 01:57:22PM +1000, Dave Chinner wrote:
> On Wed, Jun 14, 2023 at 08:38:37PM -0700, Darrick J. Wong wrote:
> > On Thu, Jun 15, 2023 at 11:42:00AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Extent freeing neeeds to be able to avoid a busy extent deadlock
> > > when the transaction itself holds the only busy extents in the
> > > allocation group. This may occur if we have an EFI that contains
> > > multiple extents to be freed, and the freeing the second intent
> > > requires the space the first extent free released to expand the
> > > AGFL. If we block on the busy extent at this point, we deadlock.
> > > 
> > > We hold a dirty transaction that contains a entire atomic extent
> > > free operations within it, so if we can abort the extent free
> > > operation and commit the progress that we've made, the busy extent
> > > can be resolved by a log force. Hence we can restart the aborted
> > > extent free with a new transaction and continue to make
> > > progress without risking deadlocks.
> > > 
> > > To enable this, we need the EFI processing code to be able to handle
> > > an -EAGAIN error to tell it to commit the current transaction and
> > > retry again. This mechanism is already built into the defer ops
> > > processing (used bythe refcount btree modification intents), so
> > > there's relatively little handling we need to add to the EFI code to
> > > enable this.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_extfree_item.c | 64 +++++++++++++++++++++++++++++++++++++--
> > >  1 file changed, 61 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > > index f9e36b810663..3b33d27efdce 100644
> > > --- a/fs/xfs/xfs_extfree_item.c
> > > +++ b/fs/xfs/xfs_extfree_item.c
> > > @@ -336,6 +336,29 @@ xfs_trans_get_efd(
> > >  	return efdp;
> > >  }
> > >  
> > > +/*
> > > + * Fill the EFD with all extents from the EFI when we need to roll the
> > > + * transaction and continue with a new EFI.
> > > + */
> > > +static void
> > > +xfs_efd_from_efi(
> > > +	struct xfs_efd_log_item	*efdp)
> > > +{
> > > +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> > > +	uint                    i;
> > > +
> > > +	ASSERT(efip->efi_format.efi_nextents > 0);
> > > +
> > > +	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> > > +		return;
> > > +
> > > +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> > > +	       efdp->efd_format.efd_extents[i] =
> > > +		       efip->efi_format.efi_extents[i];
> > > +	}
> > > +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> > 
> > Odd question -- if we managed to free half the extents mentioned in an
> > EFI before hitting -EAGAIN, then efdp->efd_next_extent should already be
> > half of efip->efi_format.efi_nextents, right?
> 
> Yes, on success we normally update the EFD with the extent we just
> completed and move the EFI/EFD cursors forwards.
> 
> > I suppose it's duplicative (or maybe just careful) to recopy the entire
> > thing... but maybe that doesn't even really matter since no modern xlog
> > code actually pays attention to what's in the EFD aside from the ID
> > number.
> 
> *nod*
> 
> On second thoughts, now that you've questioned this behaviour, I
> need to go back and check my assumptions about what the intent
> creation is doing vs the current EFI vs the XEFI we are processing.
> The new EFI we log shouldn't have the extents we've completed in it,
> just the ones we haven't run, and I need to make sure that is
> actually what is happening here.

That shouldn't be happening -- each of the xfs_free_extent_later calls
below adds new incore EFIs to an xfs_defer_pending.dfp_work list and
each xfs_defer_pending itself gets added to xfs_trans.t_dfops.  The
defer_capture_and_commit function will turn the xfs_defer_pending into a
new EFI log item with the queued dfp_work items attached.

IOWs, as long as you don't call xfs_free_extent_later on any of the
xefi_startblock/blockcount pairs where xfs_trans_free_extent returned 0,
your assumptions are correct.

The code presented in this patch is correct.

--D

> > > @@ -652,9 +694,25 @@ xfs_efi_item_recover(
> > >  		fake.xefi_startblock = extp->ext_start;
> > >  		fake.xefi_blockcount = extp->ext_len;
> > >  
> > > -		xfs_extent_free_get_group(mp, &fake);
> > > -		error = xfs_trans_free_extent(tp, efdp, &fake);
> > > -		xfs_extent_free_put_group(&fake);
> > > +		if (!requeue_only) {
> > > +			xfs_extent_free_get_group(mp, &fake);
> > > +			error = xfs_trans_free_extent(tp, efdp, &fake);
> > > +			xfs_extent_free_put_group(&fake);
> > > +		}
> > > +
> > > +		/*
> > > +		 * If we can't free the extent without potentially deadlocking,
> > > +		 * requeue the rest of the extents to a new so that they get
> > > +		 * run again later with a new transaction context.
> > > +		 */
> > > +		if (error == -EAGAIN || requeue_only) {
> > > +			xfs_free_extent_later(tp, fake.xefi_startblock,
> > > +				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> > 
> > Shouldn't we check the return value of xfs_free_extent_later now?
> > I think we already did that above, but since you just plumbed in the
> > extra checks, we ought to use it. :)
> 
> Oh, right, my cscope tree needs updating, so I was thinking it is
> still a void function.
> 
> > (Also the indenting here isn't the usual two tabs)
> 
> I'll fix that too.
> 
> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
