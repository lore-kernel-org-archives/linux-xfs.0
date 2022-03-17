Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9732C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 12:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiCQM72 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 08:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235331AbiCQM6y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 08:58:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67D8F133654
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 05:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647521820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o1jUkqSyzgx0wfrGxouVQ5ubLNTnzwTd8sKlrFvRuWs=;
        b=fV9SJgqHcUjFb5kIXGHy3dK7tq38lwV3TV4oJVcuuImAU2Y6oXIVG/NwH9dWlh65EeaJ4R
        s1Ds2xQQ1jWhgZOxj0FjLQpur4TlRVmHrl2GmsxHYDKYsWsLWOOCNxBCI2tQebhYt6lfIy
        RyEFeOBcaIXEyvFMZEmmIYTwnsFkTIc=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-Bf7M7dD7OV-74tQoWy9Wrg-1; Thu, 17 Mar 2022 08:56:58 -0400
X-MC-Unique: Bf7M7dD7OV-74tQoWy9Wrg-1
Received: by mail-qk1-f197.google.com with SMTP id d12-20020a379b0c000000b0067d8cda1aaaso3276727qke.8
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 05:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o1jUkqSyzgx0wfrGxouVQ5ubLNTnzwTd8sKlrFvRuWs=;
        b=Q3bNpswjLYipsXAYzjMhgROpYPqouPDA68A4NENTbifssMCe3zWkkkjcKO5mQxwaf6
         8U1yROaOarnVEkv4Xa2NSOLz+sKd3jWYhREIewV+UZTg+oPGxJq2DCkKV92wLy5ewB4F
         xkXbUs6Uk4clir+R11qhK/FfyezWaxj8cCD/R8ZQhaolzZ561wUAQUfJyuGyT6fcA4Kf
         YAEI7SjActaY94Q52m3qgAMH5md6zjuI5Vv33P4eyXt9pavU2gVqWL2i7TMojXnMz7YR
         fqpXnZ0Pn4PczPSjAJyXCbnd53mTqBOHnKR7RTcdESY8Ay8Sr8KCWjY4u2FkFL/+JogR
         snUg==
X-Gm-Message-State: AOAM531INIsPRSJ6BmuhyENQBDdE+XmPyac2+whzuA6vMgeEG0tYWsdH
        uKpRQpsYqMcyNBrQV2oSD6UgUi9Hfi/YvhJaUmav770xCP5eeayhl5uPDuXx3PxC5jW18wbafXC
        0Vst0DCRMi6YSunM100/S
X-Received: by 2002:a05:620a:1714:b0:67d:7568:c5e1 with SMTP id az20-20020a05620a171400b0067d7568c5e1mr2689329qkb.558.1647521817638;
        Thu, 17 Mar 2022 05:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAPCirLApOnZr0TZIlGUnl7Pq9qI71gyQdjWUYd+rHtPdfVshL8ZoLMULpBNZFYUnnW/xSFw==
X-Received: by 2002:a05:620a:1714:b0:67d:7568:c5e1 with SMTP id az20-20020a05620a171400b0067d7568c5e1mr2689316qkb.558.1647521817299;
        Thu, 17 Mar 2022 05:56:57 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id m4-20020ac85b04000000b002e1dcaed228sm3472282qtw.7.2022.03.17.05.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 05:56:56 -0700 (PDT)
Date:   Thu, 17 Mar 2022 08:56:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <YjMwF8Sh231vjjde@bfoster>
References: <20220314180847.GM8224@magnolia>
 <YjHJ0qOUnmAUEgoV@bfoster>
 <20220316163216.GU8224@magnolia>
 <YjIeXX6XeX36bmXx@bfoster>
 <20220316181726.GV8224@magnolia>
 <20220317020526.GV3927073@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317020526.GV3927073@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 01:05:26PM +1100, Dave Chinner wrote:
> On Wed, Mar 16, 2022 at 11:17:26AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 16, 2022 at 01:29:01PM -0400, Brian Foster wrote:
> > > On Wed, Mar 16, 2022 at 09:32:16AM -0700, Darrick J. Wong wrote:
> > > > On Wed, Mar 16, 2022 at 07:28:18AM -0400, Brian Foster wrote:
> > > > > On Mon, Mar 14, 2022 at 11:08:47AM -0700, Darrick J. Wong wrote:
> > > Similar deal as above.. I'm more interested in a potential cleanup of
> > > the code that helps prevent this sort of buglet for the next user of
> > > ->m_alloc_set_aside that will (expectedly) have no idea about this
> > > subtle quirk than I am about what's presented in the free space
> > > counters. ISTM that we ought to just ditch ->m_alloc_set_aside, replace
> > > the existing xfs_alloc_set_aside() with an XFS_ALLOC_FS_RESERVED() macro
> > > or something that just does the (agcount << 3) thing, and then define a
> > 
> > I'm not sure that the current xfs_alloc_set_aside code is correct.
> > Right now it comes with this comment:
> > 
> > "We need to reserve 4 fsbs _per AG_ for the freelist and 4 more to
> > handle a potential split of the file's bmap btree."
> >
> > I think the first part ("4 fsbs _per AG_ for the freelist") is wrong.
> > AFAICT, that part refers to the number of blocks we need to keep free in
> > case we have to replenish a completely empty AGFL.  The hardcoded value
> > of 4 seems wrong, since xfs_alloc_min_freelist() is what _fix_freelist
> > uses to decide how big the AGFL needs to be, and it returns 6 on a
> > filesystem that has rmapbt enabled.  So I think XFS_ALLOC_AGFL_RESERVE
> > is wrong here and should be replaced with the function call.
> 
> Back when I wrote that code (circa 2007, IIRC), that was actually
> correct according to the reservations that were made when freeing
> an extent at ENOSPC.
> 
> We needed 4 blocks for the AGFL fixup to always succeed  - 2 blocks
> for each BNO and CNT btrees, and, IIRC, the extent free reservation
> was just 4 blocks at that time. Hence the 4+4 value.
> 
> However, you are right that rmap also adds another per-ag btree that
> is allocated from the agfl and that set_aside() should be taking
> that into accout. That said, I think that xfs_alloc_min_freelist()
> might even be wrong by just adding 2 blocks to the AGFL for the
> rmapbt.
> 
> That is, at ENOSPC the rmapbt can be a *big* btree. It's not like
> the BNO and CNT btrees which are completely empty at that point in
> time; the RMAP tree could be one level below max height, and freeing
> a single block could split a rmap rec and trigger a full height RMAP
> split.
> 
> So the minimum free list length in that case is 2 + 2 + MAX_RMAP_HEIGHT.
> 
> > I also think the second part ("and 4 more to handle a split of the
> > file's bmap btree") is wrong.  If we're really supposed to save enough
> > blocks to handle a bmbt split, then I think this ought to be
> > (mp->m_bm_maxlevels[0] - 1), not 4, right?  According to xfs_db, bmap
> > btrees can be 9 levels tall:
> 
> Yes, we've changed the BMBT reservations in the years since that
> code was written to handle max height reservations correctly, too.
> So, like the RMAP btree reservation, we probably should be reserving
> MAX_BMAP_HEIGHT in the set-aside calculation.
> 
> refcount btree space is handled by the ag_resv code and blocks
> aren't allocated from the AGFL, so I don't think we need to take
> taht into account for xfs_alloc_set_aside().
> 
> > So in the end, I think that calculation should become:
> > 
> > unsigned int
> > xfs_alloc_set_aside(
> > 	struct xfs_mount	*mp)
> > {
> > 	unsigned int		min-agfl = xfs_alloc_min_freelist(mp, NULL);
> > 
> > 	return mp->m_sb.sb_agcount * (min_agfl + mp->m_bm_maxlevels[0] - 1);
> > }
> 
> *nod*, but with the proviso that xfs_alloc_min_freelist() doesn't
> appear to be correct, either....
> 
> Also, that's a fixed value for the physical geometry of the
> filesystem, so it should be calculated once at mount time and stored
> in the xfs_mount (and only updated if needed at growfs time)...
> 

To my earlier point... please just don't call this fixed mount value
"set_aside" if that's not what it actually is. Rename the field and
helper to something self-descriptive based on whatever fixed components
it's made up of (you could even qualify it as a subcomponent of
set_aside with something like ".._agfl_bmap_set_aside" or whatever) then
reserve the _set_aside() name for the helper that calculates and
documents what the actual/final/dynamic "set aside" value is.

Brian

> > > new xfs_alloc_set_aside() that combines the macro calculation with
> > > ->m_allocbt_blks. Then the whole "set aside" concept is calculated and
> > > documented in one place. Hm?
> > 
> > I think I'd rather call the new function xfs_fdblocks_avail() over
> > reusing an existing name, because I fear that zapping an old function
> > and replacing it with a new function with the same name will cause
> > confusion for anyone backporting patches or reading code after an
> > absence.
> > 
> > Also the only reason we have a mount variable and a function (instead of
> > a macro) is that Dave asked me to change the codebase away from the
> > XFS_ALLOC_AG_MAX_USABLE/XFS_ALLOC_SET_ASIDE macros as part of merging
> > reflink.
> 
> Yeah, macros wrapping a variable or repeated constant calculation
> are bad, and it's something we've been cleaning up for a long
> time...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

