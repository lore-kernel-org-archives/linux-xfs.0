Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697B1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 17:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242857AbiCPRaX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiCPRaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 13:30:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F11A5B3C1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647451746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d08q9SR6vUi+44+0B+TaH8f09GGk50vJORMYUPsGbdE=;
        b=XQpN4e8pA0QNFb0lBKJ7jGTHpkxNdFQH93EUF0S+1VwFkeCripbQxKIpl44s46IiurqqUW
        7Lt4/TUqbV7eU6jhguHFC1u8ugoSoUC1688jQdj7me2I8uWAmC2q2Lnlzq8hlAW/fZ3b65
        Fk/OyqGogRoyttTKygoq7LbuSnuUxiI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-ygchpg20MV2n0NxlQQQR2w-1; Wed, 16 Mar 2022 13:29:05 -0400
X-MC-Unique: ygchpg20MV2n0NxlQQQR2w-1
Received: by mail-qk1-f198.google.com with SMTP id w200-20020a3762d1000000b0067d2149318dso1879485qkb.1
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 10:29:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d08q9SR6vUi+44+0B+TaH8f09GGk50vJORMYUPsGbdE=;
        b=Yv4xxKHqeBQ9gkt8H49myj4NBcdHDBGsjmYEpEAaw8kltkbYu5kYV48D+C/WHAcdYX
         FzuegV+ADq92v0/jovNo9OckJk2PGP3AuVu89COtvgCqKVX+buslzoJlA+/wFBxlSB1E
         8p+Rm7oRgKk9gHGzBybMa+Fss+xLGllocJ7qMcilHlU24mjo5M6jm36VGyp3beMCWK39
         zjc7DuCMSiWawlebnj2EQp3MwPbBcoCpHj+lZW5CF+Jik/WV2s5Y+ZXuWOWzf8fKp5Zo
         3z/MZrAY6P/pTk+ZxLqcmDmsZT/cQNf6Dc9MUg8qsSZEnDdHpP1S+XHGaIcA1Pw47vnF
         HGfw==
X-Gm-Message-State: AOAM531eZTdt2eyEJNskgjVf/sq69FxALyxrv0Yc+GAyNgYQon3fWvjO
        VS7lFcXGT12XTp37FWnbKJJAToYGx/2liBt1mCh1Hou0H7aPWf7Tqf1Vqq8QNoKeE2rNDuZ3VkD
        ut5QnU09iJim2qnvpUv07
X-Received: by 2002:a37:a988:0:b0:67b:1302:6c38 with SMTP id s130-20020a37a988000000b0067b13026c38mr613438qke.298.1647451744309;
        Wed, 16 Mar 2022 10:29:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOSZsT/83P/pGeIy1YOmKc6KEgtsfL+czTZgG5H7SQSkNZMUfUduvH2c+LLt0TAQmSwvjMIw==
X-Received: by 2002:a37:a988:0:b0:67b:1302:6c38 with SMTP id s130-20020a37a988000000b0067b13026c38mr613430qke.298.1647451743909;
        Wed, 16 Mar 2022 10:29:03 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id o21-20020ac85a55000000b002e16389b501sm1657615qta.96.2022.03.16.10.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 10:29:03 -0700 (PDT)
Date:   Wed, 16 Mar 2022 13:29:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <YjIeXX6XeX36bmXx@bfoster>
References: <20220314180847.GM8224@magnolia>
 <YjHJ0qOUnmAUEgoV@bfoster>
 <20220316163216.GU8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316163216.GU8224@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 09:32:16AM -0700, Darrick J. Wong wrote:
> On Wed, Mar 16, 2022 at 07:28:18AM -0400, Brian Foster wrote:
> > On Mon, Mar 14, 2022 at 11:08:47AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > xfs_reserve_blocks controls the size of the user-visible free space
> > > reserve pool.  Given the difference between the current and requested
> > > pool sizes, it will try to reserve free space from fdblocks.  However,
> > > the amount requested from fdblocks is also constrained by the amount of
> > > space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> > > reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> > > 
> > > In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> > > out the "free space" used by the free space btrees, because some portion
> > > of the free space btrees hold in reserve space for future btree
> > > expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> > > of blocks that it could request from xfs_mod_fdblocks was not updated to
> > > include m_allocbt_blks, so if space is extremely low, the caller hangs.
> > > 
> > > Fix this by including m_allocbt_blks in the estimation, and modify the
> > > loop so that it will not retry infinitely.
> > > 
> > > Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> > > with an fstests configuration that specifies a 1k blocksize and a
> > > specially crafted log size that will consume 7/8 of the space (17920
> > > blocks, specifically) in that AG.
> > > 
> > > Cc: Brian Foster <bfoster@redhat.com>
> > > Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_fsops.c |   16 ++++++++++++----
> > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > index 33e26690a8c4..78b6982ea5b0 100644
> > > --- a/fs/xfs/xfs_fsops.c
> > > +++ b/fs/xfs/xfs_fsops.c
> > > @@ -379,6 +379,7 @@ xfs_reserve_blocks(
> > >  	int64_t			fdblks_delta = 0;
> > >  	uint64_t		request;
> > >  	int64_t			free;
> > > +	unsigned int		tries;
> > >  	int			error = 0;
> > >  
> > >  	/* If inval is null, report current values and return */
> > > @@ -432,9 +433,16 @@ xfs_reserve_blocks(
> > >  	 * perform a partial reservation if the request exceeds free space.
> > >  	 */
> > >  	error = -ENOSPC;
> > > -	do {
> > > -		free = percpu_counter_sum(&mp->m_fdblocks) -
> > > -						mp->m_alloc_set_aside;
> > > +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
> > 
> > Any reason for the magic number of retries as opposed to perhaps just
> > not retrying at all?
> 
> I /think/ the origins of the loop was commit dbcabad19aa9 ("[XFS] Fix
> block reservation mechanism."), where I guess Dave decided that we
> should loop forever trying to satisfy a request from userspace to
> increase the reserve pool.  OFC you and I have been patching this
> function to fix all its horrible warts over the years, so maybe you're
> right that this should only try once...
> 
> (For the mount time default reservation, we should only iterate the loop
> once (provided the accounting is correct ;) since nobody else is
> touching the free space counters.)
> 
> > This seems a little odd when you think about it
> > given that the request is already intended to take available space into
> > account and modify the request from userspace. OTOH, another
> > consideration could be to retry some (really large?) number of times and
> > then bail out if we happen to iterate without an observable change in
> > free space (i.e., something is wrong), however I suppose that could be
> > racy as well. *shrug*
> 
> ...but if you're the sysadmin desperately trying to increase the size of
> the reserve pool when the fs is running near ENOSPC, you're going to be
> racing with fdblocks bouncing up and down.  The @free samples that we
> take here in the loop body are indeed racy since we can't tell the
> difference between @free being unchanged from the last iteration because
> someone freed a block and someone else immediately consumed it, or a
> totally idle system.
> 
> Either way, it's better than hanging the whole system. :)
> 

Yeah.. I'm not bothered much by whether we retry once, 42 times or
forever. I think what this boils down to for me is whether it's worth
the risk of a behavior change of an -ENOSPC return causing something
unexpected for some random user or use case. Could we just do this in
two separate patches? Patch 1 fixes the calculation and targets stable,
patch 2 does whatever to the retry loop that potentially changes retry
semantics (and doesn't really need backporting)..?

> What if I augment the loop control with a comment capturing some of this:
> 
> 	/*
> 	 * The loop body estimates how many blocks it can request from
> 	 * fdblocks to stash in the reserve pool.  This is a classic
> 	 * TOCTOU race since fdblocks updates are not always coordinated
> 	 * via m_sb_lock.  We also cannot tell if @free remaining
> 	 * unchanged between iterations is due to an idle system or
> 	 * freed blocks being consumed immediately, so we'll try a
> 	 * finite number of times to satisfy the request.
> 	 */
> 	for (tries = 0; tries < 30...) {
> 
> > 
> > > +		/*
> > > +		 * The reservation pool cannot take space that xfs_mod_fdblocks
> > > +		 * will not give us.  This includes the per-AG set-aside space
> > > +		 * and free space btree blocks that are not available for
> > > +		 * allocation due to per-AG metadata reservations.
> > > +		 */
> > > +		free = percpu_counter_sum(&mp->m_fdblocks);
> > > +		free -= mp->m_alloc_set_aside;
> > > +		free -= atomic64_read(&mp->m_allocbt_blks);
> > 
> > Seems reasonable. Do we want to consider ->m_allocbt_blks in other
> > places where ->m_alloc_set_aside is used (i.e. xfs_fs_statfs(), etc.)?
> > Not sure how much it matters for space reporting purposes, but if so, it
> > might also be worth reconsidering the usefulness of a static field and
> > initialization helper (i.e. xfs_alloc_set_aside()) if the majority of
> > uses involve a dynamic calculation (due to ->m_allocbt_blks).
> 
> When I was writing this patch, I very nearly decided to make those three
> lines above their own helper.  I didn't see any other spots that looked
> like obvious candidates for such a calculation outside of statfs.
> 

Indeed..

> Subtracting m_allocbt_blks from statfs' avail field is a behavior
> change, since we always used to consider bnobt blocks as available.  We
> don't have an exact count of how many blocks are needed to hide the
> per-ag reserved extents, so in the end we have to decide whether we want
> to hear complaints about over- or under-estimation of available blocks.
> 
> So I think the statfs stuff is a separate patch. :)
> 

Similar deal as above.. I'm more interested in a potential cleanup of
the code that helps prevent this sort of buglet for the next user of
->m_alloc_set_aside that will (expectedly) have no idea about this
subtle quirk than I am about what's presented in the free space
counters. ISTM that we ought to just ditch ->m_alloc_set_aside, replace
the existing xfs_alloc_set_aside() with an XFS_ALLOC_FS_RESERVED() macro
or something that just does the (agcount << 3) thing, and then define a
new xfs_alloc_set_aside() that combines the macro calculation with
->m_allocbt_blks. Then the whole "set aside" concept is calculated and
documented in one place. Hm?

Brian

> --D
> 
> > 
> > Brian
> > 
> > >  		if (free <= 0)
> > >  			break;
> > >  
> > > @@ -459,7 +467,7 @@ xfs_reserve_blocks(
> > >  		spin_unlock(&mp->m_sb_lock);
> > >  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> > >  		spin_lock(&mp->m_sb_lock);
> > > -	} while (error == -ENOSPC);
> > > +	}
> > >  
> > >  	/*
> > >  	 * Update the reserve counters if blocks have been successfully
> > > 
> > 
> 

