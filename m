Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9EA4C25B08
	for <linux-xfs@archiver.kernel.org>; Wed, 17 Aug 2022 15:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237405AbiHQPjY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbiHQPjW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Aug 2022 11:39:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB214DF3D
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 08:39:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F0D7614E5
        for <linux-xfs@vger.kernel.org>; Wed, 17 Aug 2022 15:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA52C433C1;
        Wed, 17 Aug 2022 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660750759;
        bh=3Dtq0GV3dmWxc3If9CxkG5EltZiudOiCTSzsmHAVb6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y0hq51sG5TduYO8v20X6JMffkSNimeaReLgdZpdMRIRnGn100ZKsRjP9FFK01nbpS
         wmn05DeQyhNP6SF7YCSh9RGvvbgawHqRW8xRP4EC1Qu2xQw0eHkUabuKMnMKtuTB68
         Pk6rmfJd3k1GS+fnY1CNzfCTmATatixvkWkzRq0QPzPjNhad61dyzSHl6RTqI0DhBz
         yYt2m2CD7zR7u7yLogMoew1QB6Mv6AqBN7wXgqZJQ0mu+FPh5TQoFUUHbg4SdREUkX
         CM/A8H2dBaPKmRdIerthVTnx5kLh7XMfzKjch6UqAyuTMmA1VjL0wYebs0Ls2IakqX
         qalVcIb4Lnr7A==
Date:   Wed, 17 Aug 2022 08:39:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdump: Initialize getbmap structure in quantity2offset
Message-ID: <Yv0Lp/mpV8s0lA4X@magnolia>
References: <166063952935.40771.5357077583333371260.stgit@orion>
 <cUd3hfyxm_FjsQ62RYGb76fd-cEtRSCtAMq3rh_nv6T8eAwScvjwPA03iMjbKZ9h4P7uDBQk7CS3upmPOsBiwg==@protonmail.internalid>
 <Yvu1h/dQi9CSft0X@magnolia>
 <20220817084214.sk6oar5jlhae6blv@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817084214.sk6oar5jlhae6blv@orion>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 17, 2022 at 10:42:14AM +0200, Carlos Maiolino wrote:
> On Tue, Aug 16, 2022 at 08:19:35AM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 16, 2022 at 10:45:50AM +0200, Carlos Maiolino wrote:
> > > Prevent uninitialized data in the stack by initializing getbmap structure
> > > to zero.
> > 
> > The kernel should fill out all the bmap[1..BMAP_LEN-1] entries, right?
> > 
> > The only part of the array that's critical to initialize to a known
> > value is bmap[0], since that's what the kernel will read to decide what
> > to do, right?
> > 
> > Or, zooming out a bit, why did you decide to initialize the struct?  Was
> > it valgrind complaining about uninitialized ioctl memory, or did someone
> > report a bug?
> > 
> 
> I thought about this from a userspace perspective at first, and by pure code
> inspection, not anything valgrind complained about.
> The previous mentioned patch replaced getbmapx by getbmap to remove the
> uninitialized bmv_iflags from the middle of bmap[0], which for sure is the most
> critical part here.

Agreed!

> At the array declaration though, the first element is zeroed,
> but it still leaves garbage on the remaining arrays, so, I thought it would be
> wise to just zero out the whole array there without leaving uninitialized data
> we might trip over in the future.

<shrug> In theory, if userspace range-checks itself to
bmap[0].bmv_entries then the uninitialized array elements shouldn't be
an issue, right?

(That said, getbmap* is not an intuitive interface given that it reuses
the same struct for the query information and the records, with the
result that there are header fields that are ignored, and record fields
that are meaningless.)

> I just did a quick look from the kernel side, and if I'm not wrong, if the file
> has fewer extents than the array has slots, the kernel won't touch the remaining
> array entries, leaving that space uninitialized.

Right.

> I don't think it's a big deal anyway, as xfsdump walk through the array based on
> the returned entries.

<nod>

> > (I'm actually fine with this change, I just want to know how you got
> > here. ;))
> 
> Just thought it as a 'better safe than sorry' kind of situation, nothing more :P

<nod>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> > 
> > --D
> > 
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >
> > > There is already a patch on the list to remove remaining DMAPI stuff from
> > > xfsdump:
> > > xfsdump: remove BMV_IF_NO_DMAPI_READ flag
> > >
> > > This patch though, does not initialize the getbmap structure, and although
> > > the
> > > first struct in the array is initialized, the remaining structures in the
> > > array are not, leaving garbage in the stack.
> > >
> > >
> > >  dump/inomap.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/dump/inomap.c b/dump/inomap.c
> > > index f3200be..c4ea21d 100644
> > > --- a/dump/inomap.c
> > > +++ b/dump/inomap.c
> > > @@ -1627,7 +1627,7 @@ static off64_t
> > >  quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
> > >  {
> > >  	int fd;
> > > -	struct getbmap bmap[BMAP_LEN];
> > > +	struct getbmap bmap[BMAP_LEN] = {0};
> > >  	off64_t offset;
> > >  	off64_t offset_next;
> > >  	off64_t qty_accum;
> > >
> > >
> 
> -- 
> Carlos Maiolino
