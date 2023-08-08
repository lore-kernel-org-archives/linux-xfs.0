Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1370DC04FDF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 19:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbjHHTmd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbjHHTmS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 15:42:18 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560C36AA2
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 09:59:12 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id e9e14a558f8ab-3490cce32c4so26892625ab.0
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 09:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691513951; x=1692118751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J3E9yDvYn8hoYkIBIRCUsGOik7L2fG1e+uVyDfaHvpY=;
        b=IeXidqoAg+3ZK///5h9QdbW0YR8fcpiqN5Pf643zwyR0xjwnKSVZ7Sz0ZQ1FoBT6Bo
         Th1uOb1HeQ9sq+rIwrXnQ0xVREPS0ZiNfKrpwz5WFWqjYJIKMcxGq6jplmwRpdK9Sqaz
         E1z5lvyLmkw5TLz1GcyQZpiG1ur645TT4IbAzAPGfg0cmtv6t9Qm7/Nx//gRCX+SS9NR
         +j8OTpDQWu0IVMJSqSnzuMIAP8xyvUz6gMxGTK/vuhdwCeJOJK132oME/nG60zuxiig0
         9nmSPgesTxkEdMuWGLB4VqkKP4C06hsaM6ytPvvA6kgHCWmyZ9wZ4ShyxIoMHdAYI07z
         FMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691513951; x=1692118751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J3E9yDvYn8hoYkIBIRCUsGOik7L2fG1e+uVyDfaHvpY=;
        b=bSwRCErIK+BxGfrQzE1E7ZS5NZ45ZdfZPd+m3ukg7HQKFyPm4HbWwE/IZrWwZuzOdh
         uJUbhuIONn1p0941uOrft7LOL3vVHs6yg6a4ALWc3ocPNXHc9zBpW5B8P86SCv5qp1ED
         GepEfgCcGumnMP1dBunOtb6Vd8vk10CTj5uE/PDnE+lbfH6/NWooFWlHkD31I4XYUo+8
         arwHpx4imBvyqqxbhLfReiCIsYTu9Ds8A3plaY4Jkifbzy8CN7s3ycfMFg8mJRsrTpnX
         9OE7c+DmJa0oZcmgzXrDCILAylakK4uGtbmE0qBCj39PjP28/ogrKcaT1a/LMNKAqgWL
         VFQQ==
X-Gm-Message-State: AOJu0YyAXppN4jduj7ugflIpwV3GJp1tOK+SkOU0Iq5Hya89fZrKgiOC
        1bNDAORLMRf3xJwzGQDwTo1crm7rGlDWr6ROMCY=
X-Google-Smtp-Source: AGHT+IGcBHYf3mcD/G8g3nrwdFGfkiHBPrWxKdkhYWgDbmEfaYtmU2B83vTJdGpKdwK3+U7vyra8vQ==
X-Received: by 2002:a05:6870:819e:b0:1b7:72bb:c67b with SMTP id k30-20020a056870819e00b001b772bbc67bmr14741671oae.29.1691475076942;
        Mon, 07 Aug 2023 23:11:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id v5-20020a17090a898500b00265c9062f94sm7140851pjn.21.2023.08.07.23.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Aug 2023 23:11:16 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTFw1-002b28-2r;
        Tue, 08 Aug 2023 16:11:13 +1000
Date:   Tue, 8 Aug 2023 16:11:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: log EFIs for all btree blocks being used to
 stage a btree
Message-ID: <ZNHcgXhda8KUqOl8@dread.disaster.area>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
 <169049623218.921279.10028914723578681696.stgit@frogsfrogsfrogs>
 <ZNCuQ/mxsHQ67vjz@dread.disaster.area>
 <20230808005452.GN11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808005452.GN11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 07, 2023 at 05:54:52PM -0700, Darrick J. Wong wrote:
> On Mon, Aug 07, 2023 at 06:41:39PM +1000, Dave Chinner wrote:
> > On Thu, Jul 27, 2023 at 03:24:32PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > We need to log EFIs for every extent that we allocate for the purpose of
> > > staging a new btree so that if we fail then the blocks will be freed
> > > during log recovery.  Add a function to relog the EFIs, so that repair
> > > can relog them all every time it creates a new btree block, which will
> > > help us to avoid pinning the log tail.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > .....
> > > +/*
> > > + * Set up automatic reaping of the blocks reserved for btree reconstruction in
> > > + * case we crash by logging a deferred free item for each extent we allocate so
> > > + * that we can get all of the space back if we crash before we can commit the
> > > + * new btree.  This function returns a token that can be used to cancel
> > > + * automatic reaping if repair is successful.
> > > + */
> > > +static int
> > > +xrep_newbt_schedule_autoreap(
> > > +	struct xrep_newbt		*xnr,
> > > +	struct xrep_newbt_resv		*resv)
> > > +{
> > > +	struct xfs_extent_free_item	efi_item = {
> > > +		.xefi_blockcount	= resv->len,
> > > +		.xefi_owner		= xnr->oinfo.oi_owner,
> > > +		.xefi_flags		= XFS_EFI_SKIP_DISCARD,
> > > +		.xefi_pag		= resv->pag,
> > > +	};
> > > +	struct xfs_scrub		*sc = xnr->sc;
> > > +	struct xfs_log_item		*lip;
> > > +	LIST_HEAD(items);
> > > +
> > > +	ASSERT(xnr->oinfo.oi_offset == 0);
> > > +
> > > +	efi_item.xefi_startblock = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno,
> > > +			resv->agbno);
> > > +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_ATTR_FORK)
> > > +		efi_item.xefi_flags |= XFS_EFI_ATTR_FORK;
> > > +	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
> > > +		efi_item.xefi_flags |= XFS_EFI_BMBT_BLOCK;
> > > +
> > > +	INIT_LIST_HEAD(&efi_item.xefi_list);
> > > +	list_add(&efi_item.xefi_list, &items);
> > > +
> > > +	xfs_perag_intent_hold(resv->pag);
> > > +	lip = xfs_extent_free_defer_type.create_intent(sc->tp, &items, 1,
> > > +			false);
> > 
> > Hmmmm.
> > 
> > That triggered flashing lights and sirens - I'm not sure I really
> > like the usage of the defer type arrays like this, nor the
> > duplication of the defer mechanisms for relogging, etc.
> 
> Yeah, I don't quite like manually tromping through the defer ops state
> machine here either.  Everywhere /else/ in XFS logs an EFI and finishes
> it to free the space.  Just to make sure we're on the same page, newbt
> will allocate space, log an EFI, and then:
> 
> 1. Use the space and log an EFD for the space to cancel the EFI
> 2. Use some of the space, log an EFD for the space we used, immediately
>    log a new EFI for the unused parts, and finish the new EFI manually
> 3. Don't use any of the space at all, and finish the EFI manually
> 
> Initially, I tried using the regular defer ops mechanism, but this got
> messy on account of having to extern most of xfs_defer.c so that I could
> manually modify the defer ops state.  It's hard to generalize this,
> since there's only *one* place that actually needs manual flow control.

*nod*

But I can't help but think it's a manifestation of a generic
optimisation that could allow us to avoid needing to use unwritten
extents for new data alloations...

> ISTR that was around the time bfoster and I were reworking log intent
> item recovery, and it was easier to do this outside of the defer ops
> code than try to refactor it and keep this exceptional piece working
> too.
> 
> > Not that I have a better idea right now - is this the final form of
> > this code, or is more stuff built on top of it or around it?
> 
> That's the final form of it.  The good news is that it's been stable
> enough despite me tearing into the EFI code again in the rt
> modernization patchset.  Do you have any further suggestions?

Not for the patchset as it stands.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
