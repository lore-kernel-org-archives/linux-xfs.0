Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DF4C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 15:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiCQPrb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 11:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbiCQPrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 11:47:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEFF1D4C13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 08:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 465EB61994
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 15:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46C9C340E9;
        Thu, 17 Mar 2022 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647531973;
        bh=Q0P4PPNaJ5fRxzeqhuu0X4OClixy8mNnJZxgnxSUwrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XnnWM1Q27gdi9fftuWq05Jv6A0SyEo/owAzjSmwwe+3zHy5RGZaDO6AlgHYyu9632
         EwIewbm7gLo6J6Ekt7B9nBNEbonV8DfI48d4tY25tRWsSA/NySM8z/fQ7mlWgw4UPL
         EOKRUUaayZhm3olH9QtUlIKJhXJGYYhNht3r30o5t7m9ZJh4hR3zO7Wx3BnSMIXDKJ
         4cUmlbJUIfRVF/an7D1cOA5w8yRpLfFtjUzM59t6rujQPGCzckkbslevI1aaanJwgr
         9as1qBpIajHqbqksQFzfCfo/UK9FcuWXUDm5JJEY9xCiKBAS1ySGLGNoEyYzNa1xn2
         D+cD24RyLBWLQ==
Date:   Thu, 17 Mar 2022 08:46:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220317154613.GA8224@magnolia>
References: <20220314180847.GM8224@magnolia>
 <YjHJ0qOUnmAUEgoV@bfoster>
 <20220316163216.GU8224@magnolia>
 <YjIeXX6XeX36bmXx@bfoster>
 <20220316181726.GV8224@magnolia>
 <20220317020526.GV3927073@dread.disaster.area>
 <YjMwF8Sh231vjjde@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjMwF8Sh231vjjde@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 08:56:55AM -0400, Brian Foster wrote:
> On Thu, Mar 17, 2022 at 01:05:26PM +1100, Dave Chinner wrote:
> > On Wed, Mar 16, 2022 at 11:17:26AM -0700, Darrick J. Wong wrote:
> > > On Wed, Mar 16, 2022 at 01:29:01PM -0400, Brian Foster wrote:
> > > > On Wed, Mar 16, 2022 at 09:32:16AM -0700, Darrick J. Wong wrote:
> > > > > On Wed, Mar 16, 2022 at 07:28:18AM -0400, Brian Foster wrote:
> > > > > > On Mon, Mar 14, 2022 at 11:08:47AM -0700, Darrick J. Wong wrote:
> > > > Similar deal as above.. I'm more interested in a potential cleanup of
> > > > the code that helps prevent this sort of buglet for the next user of
> > > > ->m_alloc_set_aside that will (expectedly) have no idea about this
> > > > subtle quirk than I am about what's presented in the free space
> > > > counters. ISTM that we ought to just ditch ->m_alloc_set_aside, replace
> > > > the existing xfs_alloc_set_aside() with an XFS_ALLOC_FS_RESERVED() macro
> > > > or something that just does the (agcount << 3) thing, and then define a
> > > 
> > > I'm not sure that the current xfs_alloc_set_aside code is correct.
> > > Right now it comes with this comment:
> > > 
> > > "We need to reserve 4 fsbs _per AG_ for the freelist and 4 more to
> > > handle a potential split of the file's bmap btree."
> > >
> > > I think the first part ("4 fsbs _per AG_ for the freelist") is wrong.
> > > AFAICT, that part refers to the number of blocks we need to keep free in
> > > case we have to replenish a completely empty AGFL.  The hardcoded value
> > > of 4 seems wrong, since xfs_alloc_min_freelist() is what _fix_freelist
> > > uses to decide how big the AGFL needs to be, and it returns 6 on a
> > > filesystem that has rmapbt enabled.  So I think XFS_ALLOC_AGFL_RESERVE
> > > is wrong here and should be replaced with the function call.
> > 
> > Back when I wrote that code (circa 2007, IIRC), that was actually
> > correct according to the reservations that were made when freeing
> > an extent at ENOSPC.
> > 
> > We needed 4 blocks for the AGFL fixup to always succeed  - 2 blocks
> > for each BNO and CNT btrees, and, IIRC, the extent free reservation
> > was just 4 blocks at that time. Hence the 4+4 value.
> > 
> > However, you are right that rmap also adds another per-ag btree that
> > is allocated from the agfl and that set_aside() should be taking
> > that into accout. That said, I think that xfs_alloc_min_freelist()
> > might even be wrong by just adding 2 blocks to the AGFL for the
> > rmapbt.
> > 
> > That is, at ENOSPC the rmapbt can be a *big* btree. It's not like
> > the BNO and CNT btrees which are completely empty at that point in
> > time; the RMAP tree could be one level below max height, and freeing
> > a single block could split a rmap rec and trigger a full height RMAP
> > split.
> > 
> > So the minimum free list length in that case is 2 + 2 + MAX_RMAP_HEIGHT.
> > 
> > > I also think the second part ("and 4 more to handle a split of the
> > > file's bmap btree") is wrong.  If we're really supposed to save enough
> > > blocks to handle a bmbt split, then I think this ought to be
> > > (mp->m_bm_maxlevels[0] - 1), not 4, right?  According to xfs_db, bmap
> > > btrees can be 9 levels tall:
> > 
> > Yes, we've changed the BMBT reservations in the years since that
> > code was written to handle max height reservations correctly, too.
> > So, like the RMAP btree reservation, we probably should be reserving
> > MAX_BMAP_HEIGHT in the set-aside calculation.
> > 
> > refcount btree space is handled by the ag_resv code and blocks
> > aren't allocated from the AGFL, so I don't think we need to take
> > taht into account for xfs_alloc_set_aside().
> > 
> > > So in the end, I think that calculation should become:
> > > 
> > > unsigned int
> > > xfs_alloc_set_aside(
> > > 	struct xfs_mount	*mp)
> > > {
> > > 	unsigned int		min-agfl = xfs_alloc_min_freelist(mp, NULL);
> > > 
> > > 	return mp->m_sb.sb_agcount * (min_agfl + mp->m_bm_maxlevels[0] - 1);
> > > }
> > 
> > *nod*, but with the proviso that xfs_alloc_min_freelist() doesn't
> > appear to be correct, either....
> > 
> > Also, that's a fixed value for the physical geometry of the
> > filesystem, so it should be calculated once at mount time and stored
> > in the xfs_mount (and only updated if needed at growfs time)...
> > 
> 
> To my earlier point... please just don't call this fixed mount value
> "set_aside" if that's not what it actually is. Rename the field and
> helper to something self-descriptive based on whatever fixed components
> it's made up of (you could even qualify it as a subcomponent of
> set_aside with something like ".._agfl_bmap_set_aside" or whatever) then
> reserve the _set_aside() name for the helper that calculates and
> documents what the actual/final/dynamic "set aside" value is.

Ahh, ok, that's what you were getting at.  Every time I look at
"alloc_set_aside" I have to figure out what that /really/ does, and I
think "agfl_bmap_setaside" (or even "bmbt_split_setaside") is a better
hint to what this actually does.

--D

> Brian
> 
> > > > new xfs_alloc_set_aside() that combines the macro calculation with
> > > > ->m_allocbt_blks. Then the whole "set aside" concept is calculated and
> > > > documented in one place. Hm?
> > > 
> > > I think I'd rather call the new function xfs_fdblocks_avail() over
> > > reusing an existing name, because I fear that zapping an old function
> > > and replacing it with a new function with the same name will cause
> > > confusion for anyone backporting patches or reading code after an
> > > absence.
> > > 
> > > Also the only reason we have a mount variable and a function (instead of
> > > a macro) is that Dave asked me to change the codebase away from the
> > > XFS_ALLOC_AG_MAX_USABLE/XFS_ALLOC_SET_ASIDE macros as part of merging
> > > reflink.
> > 
> > Yeah, macros wrapping a variable or repeated constant calculation
> > are bad, and it's something we've been cleaning up for a long
> > time...
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 
