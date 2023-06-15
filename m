Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3C7EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 03:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbjFOD52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 23:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjFOD51 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 23:57:27 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4D92122
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:57:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-655fce0f354so5820691b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 20:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686801446; x=1689393446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2+LEZEk6+Z4apY9LpIdevUT3e8rTKz1un3IyEfRk3fg=;
        b=aO3FUbTnL40X+dtQtTYNFRisWdUQ4Lc0y4UyYd9eFfaOWTUe9Dzz9ai3Degf5VFegv
         BajY+PG1VFqNvlPVYTEtLZLQJZktTQ/0DPH5gGrG75IopufOWQzU8Q20NNFnTgZdWvYD
         rUxT7T1vZmK1y0Dmn6GttmmO4ucEO04DXT3rd2qrRg01SlORfGJC3+ugrfvDPPiKjKR3
         rxEd8Aq4UlHUdnsYAqeXP+4iycfsTTS2Vw2Rd9IIsYgEh2trhhk4F2Ail/GTmB+XG3aA
         Yut2ibhr2HIzJKYAjUTQY/6QOev33fGD7tK7E9dcnzmDy6/8nlrSCQYULopI59aEKE2X
         z7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686801446; x=1689393446;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2+LEZEk6+Z4apY9LpIdevUT3e8rTKz1un3IyEfRk3fg=;
        b=UMV13Jz7idd8XOMkLk6SCwoF81nb4MbPzqkEEn1cBAeSMjFedEWkXVZGV0S0HDyxr1
         wGUZzj+ORretrZrt2uvDR5Uw4yuCHrIIVaOi7JRh3JG1854qwTO+9DepLccwdFDgUMtv
         f4cSw66T+jdgnyoejx5N7sXKhsqaLL8iuEy6bP5u8Vb35BMRSW08RdDwT7fWu2dY2Lb7
         VXigZo3du/ojaZtYf4ERsOzxPaCaXDxBX+i4KBCaRbuph8D7awlCG6FVZaYCOZuseVzM
         Sk1mdSwl29sOyV5x4bouDcd8eV7deIhifF3QirIg+l//YGjR7k7/5Fizo83C5mSxJCK9
         VyVg==
X-Gm-Message-State: AC+VfDx5BQhVZuiH8pQa0dtLREd3n5Tqw4BCovZs1ZAUjqBrd3LkH/Ad
        PrMsJm7YuqnPzRT5QZVh0IfgpmqV3qBhUbFCx8s=
X-Google-Smtp-Source: ACHHUZ4wcllTGGGTc6xfj9iEfGkatjUI0bi4LWNDE7L22rm0Fy3nAlZAtJocV+Fkkdr5hKhbIg8a5Q==
X-Received: by 2002:a05:6a20:3d16:b0:11d:5b5d:ddf0 with SMTP id y22-20020a056a203d1600b0011d5b5dddf0mr3629512pzi.49.1686801445702;
        Wed, 14 Jun 2023 20:57:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902748400b001ab0d815dbbsm12908281pll.23.2023.06.14.20.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 20:57:25 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9e6s-00Bvmv-2z;
        Thu, 15 Jun 2023 13:57:22 +1000
Date:   Thu, 15 Jun 2023 13:57:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com,
        wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/3] xfs: allow extent free intents to be retried
Message-ID: <ZIqMIgyHBmZu4jxb@dread.disaster.area>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-3-david@fromorbit.com>
 <20230615033837.GM11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615033837.GM11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 14, 2023 at 08:38:37PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 15, 2023 at 11:42:00AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Extent freeing neeeds to be able to avoid a busy extent deadlock
> > when the transaction itself holds the only busy extents in the
> > allocation group. This may occur if we have an EFI that contains
> > multiple extents to be freed, and the freeing the second intent
> > requires the space the first extent free released to expand the
> > AGFL. If we block on the busy extent at this point, we deadlock.
> > 
> > We hold a dirty transaction that contains a entire atomic extent
> > free operations within it, so if we can abort the extent free
> > operation and commit the progress that we've made, the busy extent
> > can be resolved by a log force. Hence we can restart the aborted
> > extent free with a new transaction and continue to make
> > progress without risking deadlocks.
> > 
> > To enable this, we need the EFI processing code to be able to handle
> > an -EAGAIN error to tell it to commit the current transaction and
> > retry again. This mechanism is already built into the defer ops
> > processing (used bythe refcount btree modification intents), so
> > there's relatively little handling we need to add to the EFI code to
> > enable this.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_extfree_item.c | 64 +++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 61 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> > index f9e36b810663..3b33d27efdce 100644
> > --- a/fs/xfs/xfs_extfree_item.c
> > +++ b/fs/xfs/xfs_extfree_item.c
> > @@ -336,6 +336,29 @@ xfs_trans_get_efd(
> >  	return efdp;
> >  }
> >  
> > +/*
> > + * Fill the EFD with all extents from the EFI when we need to roll the
> > + * transaction and continue with a new EFI.
> > + */
> > +static void
> > +xfs_efd_from_efi(
> > +	struct xfs_efd_log_item	*efdp)
> > +{
> > +	struct xfs_efi_log_item *efip = efdp->efd_efip;
> > +	uint                    i;
> > +
> > +	ASSERT(efip->efi_format.efi_nextents > 0);
> > +
> > +	if (efdp->efd_next_extent == efip->efi_format.efi_nextents)
> > +		return;
> > +
> > +	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
> > +	       efdp->efd_format.efd_extents[i] =
> > +		       efip->efi_format.efi_extents[i];
> > +	}
> > +	efdp->efd_next_extent = efip->efi_format.efi_nextents;
> 
> Odd question -- if we managed to free half the extents mentioned in an
> EFI before hitting -EAGAIN, then efdp->efd_next_extent should already be
> half of efip->efi_format.efi_nextents, right?

Yes, on success we normally update the EFD with the extent we just
completed and move the EFI/EFD cursors forwards.

> I suppose it's duplicative (or maybe just careful) to recopy the entire
> thing... but maybe that doesn't even really matter since no modern xlog
> code actually pays attention to what's in the EFD aside from the ID
> number.

*nod*

On second thoughts, now that you've questioned this behaviour, I
need to go back and check my assumptions about what the intent
creation is doing vs the current EFI vs the XEFI we are processing.
The new EFI we log shouldn't have the extents we've completed in it,
just the ones we haven't run, and I need to make sure that is
actually what is happening here.

> > @@ -652,9 +694,25 @@ xfs_efi_item_recover(
> >  		fake.xefi_startblock = extp->ext_start;
> >  		fake.xefi_blockcount = extp->ext_len;
> >  
> > -		xfs_extent_free_get_group(mp, &fake);
> > -		error = xfs_trans_free_extent(tp, efdp, &fake);
> > -		xfs_extent_free_put_group(&fake);
> > +		if (!requeue_only) {
> > +			xfs_extent_free_get_group(mp, &fake);
> > +			error = xfs_trans_free_extent(tp, efdp, &fake);
> > +			xfs_extent_free_put_group(&fake);
> > +		}
> > +
> > +		/*
> > +		 * If we can't free the extent without potentially deadlocking,
> > +		 * requeue the rest of the extents to a new so that they get
> > +		 * run again later with a new transaction context.
> > +		 */
> > +		if (error == -EAGAIN || requeue_only) {
> > +			xfs_free_extent_later(tp, fake.xefi_startblock,
> > +				fake.xefi_blockcount, &XFS_RMAP_OINFO_ANY_OWNER);
> 
> Shouldn't we check the return value of xfs_free_extent_later now?
> I think we already did that above, but since you just plumbed in the
> extra checks, we ought to use it. :)

Oh, right, my cscope tree needs updating, so I was thinking it is
still a void function.

> (Also the indenting here isn't the usual two tabs)

I'll fix that too.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
