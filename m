Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B45C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 09:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbiKVJ4F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Nov 2022 04:56:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiKVJzt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2022 04:55:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453174FF9D
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 01:55:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F20EFB81601
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 09:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BA9C433D6;
        Tue, 22 Nov 2022 09:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669110942;
        bh=GWvqlGhmN65DatBJtjUy1hUJXkP7ig0c43G3NGC2MEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c22FLxr0kwYxQfmzvFg9jkqqevIBe+KYaSIlXAfs2QaKgq5lpnT7yp9hGzaJDF0zX
         GGuTgPyq4Gzzk0Wsyvmb8rz3mF7ZcB4UDwpCvYwX9fZDYn+s6YAS795xE9buEBfr0+
         +a6YnSwnHZ8M9Fvv7+PGdhrnt4ZDbGPX0Bvv7lOrLbfEQ3X6WAG+BiURCEucWXMfeu
         FP335/l7WSIWNYisPzwKUHhjbHN6UMuGOhVVDQsc+N5fOZhFODpIz5gETdzWfqQMNT
         1U76qqDHqWSiFwf0V0OEm853F42DqVYyUoctTDoRuizJeDMD36UqvqOAn4oxxxkGY1
         Y2bI4Gjj7JlYQ==
Date:   Tue, 22 Nov 2022 10:55:38 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
Message-ID: <20221122095538.xkveruwfxiwaoxud@andromeda>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
 <m2rVnmn7L8ESQIs1XdwOJFBEBbM4JZ0aXcCk-AV6m_YxUkA2WQXWRSPhC20i-ShoVrp554Ki35iUU-crDqih2A==@protonmail.internalid>
 <166795962631.3761583.16845808206856458930.stgit@magnolia>
 <20221118101714.vnsh7dkbctgthx7p@andromeda>
 <dE0WiHCV6f47VEbvGEPqE-kNwtZujXsJ_e6q31TBxdPMwOELDgIrpW6gBpruHqXgTeMjz9B36F83Lyvph48rCQ==@protonmail.internalid>
 <Y3uvzC74U3NpZtGh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3uvzC74U3NpZtGh@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2022 at 09:05:16AM -0800, Darrick J. Wong wrote:
> On Fri, Nov 18, 2022 at 11:17:14AM +0100, Carlos Maiolino wrote:
> > Hi Darrick.
> >
> > > diff --git a/repair/rmap.c b/repair/rmap.c
> > > index a7c4b25b1f..2c809fd4f2 100644
> > > --- a/repair/rmap.c
> > > +++ b/repair/rmap.c
> > > @@ -734,6 +734,8 @@ refcount_emit(
> > >  	rlrec.rc_startblock = agbno;
> > >  	rlrec.rc_blockcount = len;
> > >  	rlrec.rc_refcount = REFCOUNT_CLAMP(nr_rmaps);
> > > +	rlrec.rc_domain = XFS_REFC_DOMAIN_SHARED;
> > > +
> > >  	error = slab_add(rlslab, &rlrec);
> > >  	if (error)
> > >  		do_error(
> > > @@ -1393,7 +1395,8 @@ check_refcounts(
> > >  	while (rl_rec) {
> > >  		/* Look for a refcount record in the btree */
> > >  		error = -libxfs_refcount_lookup_le(bt_cur,
> > > -				rl_rec->rc_startblock, &have);
> > > +				XFS_REFC_DOMAIN_SHARED, rl_rec->rc_startblock,
> > > +				&have);
> >
> > Out of curiosity, why did you pass XFS_REFC_DOMAIN_SHARED directly here, other
> > than just rl_rec->rc_domain?
> 
> I did that to make it more directly obvious that we're comparing ondisk
> records for shared (and not cow) blocks.  One could trace
> rl_rec->rc_domain from refcount_emit() all the way through to here, but
> that's more work.

Seconded, thanks for the heads up.

> 
> --D
> 
> >
> >
> > Cheers.
> >
> > >  		if (error) {
> > >  			do_warn(
> > >  _("Could not read reference count record for (%u/%u).\n"),
> > > @@ -1424,14 +1427,21 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
> > >  		}
> > >
> > >  		/* Compare each refcount observation against the btree's */
> > > -		if (tmp.rc_startblock != rl_rec->rc_startblock ||
> > > +		if (tmp.rc_domain != rl_rec->rc_domain ||
> > > +		    tmp.rc_startblock != rl_rec->rc_startblock ||
> > >  		    tmp.rc_blockcount != rl_rec->rc_blockcount ||
> > > -		    tmp.rc_refcount != rl_rec->rc_refcount)
> > > +		    tmp.rc_refcount != rl_rec->rc_refcount) {
> > > +			unsigned int	start;
> > > +
> > > +			start = xfs_refcount_encode_startblock(
> > > +					tmp.rc_startblock, tmp.rc_domain);
> > > +
> > >  			do_warn(
> > >  _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) len %u nlinks %u\n"),
> > > -				agno, tmp.rc_startblock, tmp.rc_blockcount,
> > > +				agno, start, tmp.rc_blockcount,
> > >  				tmp.rc_refcount, agno, rl_rec->rc_startblock,
> > >  				rl_rec->rc_blockcount, rl_rec->rc_refcount);
> > > +		}
> > >  next_loop:
> > >  		rl_rec = pop_slab_cursor(rl_cur);
> > >  	}
> > >
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
