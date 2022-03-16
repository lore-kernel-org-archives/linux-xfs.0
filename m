Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F28FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 18:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245743AbiCPSSq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 14:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244947AbiCPSSp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 14:18:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C2F4D9E4
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 11:17:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9754B81A71
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 18:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E338C340E9;
        Wed, 16 Mar 2022 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647454647;
        bh=tDTofA4YAKrKU+UvB083aoTyIwislZM94NuPlZ+Tejs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SX2iD7P6DSgbJLVCv6LyQEF7U+RIPr+SnhCxGAXPcodlG+CDxPJLOKshM+/t6bb1r
         yg5VJ1FemNa40lmIImj0eQhrwAV6ojfApCA9DAndrH5ZmoIPxqSdJCRJ4fINBSWtAD
         Ef/k3pjie+UApC6WwGliE9C+CDruddvOLhtibfHv6DcEwV+RRFJ/foiNcy+tjAWm81
         dSJ6wo1XpdLyfBtQTRmP+3Nli/ZVHM6CMJk+RwwiPAf24M5ZH0X8Sr90FhPp7kZ7qQ
         XCcypgqxVwFOCrv6HnuG3845fr/Yig5HE3F14YO6EcGQWCqOI81sWgYb+lV8XEeegu
         20F5gqQ/kcuPg==
Date:   Wed, 16 Mar 2022 11:17:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220316181726.GV8224@magnolia>
References: <20220314180847.GM8224@magnolia>
 <YjHJ0qOUnmAUEgoV@bfoster>
 <20220316163216.GU8224@magnolia>
 <YjIeXX6XeX36bmXx@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjIeXX6XeX36bmXx@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 01:29:01PM -0400, Brian Foster wrote:
> On Wed, Mar 16, 2022 at 09:32:16AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 16, 2022 at 07:28:18AM -0400, Brian Foster wrote:
> > > On Mon, Mar 14, 2022 at 11:08:47AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > xfs_reserve_blocks controls the size of the user-visible free space
> > > > reserve pool.  Given the difference between the current and requested
> > > > pool sizes, it will try to reserve free space from fdblocks.  However,
> > > > the amount requested from fdblocks is also constrained by the amount of
> > > > space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> > > > reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> > > > 
> > > > In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> > > > out the "free space" used by the free space btrees, because some portion
> > > > of the free space btrees hold in reserve space for future btree
> > > > expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> > > > of blocks that it could request from xfs_mod_fdblocks was not updated to
> > > > include m_allocbt_blks, so if space is extremely low, the caller hangs.
> > > > 
> > > > Fix this by including m_allocbt_blks in the estimation, and modify the
> > > > loop so that it will not retry infinitely.
> > > > 
> > > > Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> > > > with an fstests configuration that specifies a 1k blocksize and a
> > > > specially crafted log size that will consume 7/8 of the space (17920
> > > > blocks, specifically) in that AG.
> > > > 
> > > > Cc: Brian Foster <bfoster@redhat.com>
> > > > Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_fsops.c |   16 ++++++++++++----
> > > >  1 file changed, 12 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > index 33e26690a8c4..78b6982ea5b0 100644
> > > > --- a/fs/xfs/xfs_fsops.c
> > > > +++ b/fs/xfs/xfs_fsops.c
> > > > @@ -379,6 +379,7 @@ xfs_reserve_blocks(
> > > >  	int64_t			fdblks_delta = 0;
> > > >  	uint64_t		request;
> > > >  	int64_t			free;
> > > > +	unsigned int		tries;
> > > >  	int			error = 0;
> > > >  
> > > >  	/* If inval is null, report current values and return */
> > > > @@ -432,9 +433,16 @@ xfs_reserve_blocks(
> > > >  	 * perform a partial reservation if the request exceeds free space.
> > > >  	 */
> > > >  	error = -ENOSPC;
> > > > -	do {
> > > > -		free = percpu_counter_sum(&mp->m_fdblocks) -
> > > > -						mp->m_alloc_set_aside;
> > > > +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
> > > 
> > > Any reason for the magic number of retries as opposed to perhaps just
> > > not retrying at all?
> > 
> > I /think/ the origins of the loop was commit dbcabad19aa9 ("[XFS] Fix
> > block reservation mechanism."), where I guess Dave decided that we
> > should loop forever trying to satisfy a request from userspace to
> > increase the reserve pool.  OFC you and I have been patching this
> > function to fix all its horrible warts over the years, so maybe you're
> > right that this should only try once...
> > 
> > (For the mount time default reservation, we should only iterate the loop
> > once (provided the accounting is correct ;) since nobody else is
> > touching the free space counters.)
> > 
> > > This seems a little odd when you think about it
> > > given that the request is already intended to take available space into
> > > account and modify the request from userspace. OTOH, another
> > > consideration could be to retry some (really large?) number of times and
> > > then bail out if we happen to iterate without an observable change in
> > > free space (i.e., something is wrong), however I suppose that could be
> > > racy as well. *shrug*
> > 
> > ...but if you're the sysadmin desperately trying to increase the size of
> > the reserve pool when the fs is running near ENOSPC, you're going to be
> > racing with fdblocks bouncing up and down.  The @free samples that we
> > take here in the loop body are indeed racy since we can't tell the
> > difference between @free being unchanged from the last iteration because
> > someone freed a block and someone else immediately consumed it, or a
> > totally idle system.
> > 
> > Either way, it's better than hanging the whole system. :)
> > 
> 
> Yeah.. I'm not bothered much by whether we retry once, 42 times or
> forever. I think what this boils down to for me is whether it's worth
> the risk of a behavior change of an -ENOSPC return causing something
> unexpected for some random user or use case. Could we just do this in
> two separate patches? Patch 1 fixes the calculation and targets stable,
> patch 2 does whatever to the retry loop that potentially changes retry
> semantics (and doesn't really need backporting)..?

Splitting the two patches sounds good to me.

> > What if I augment the loop control with a comment capturing some of this:
> > 
> > 	/*
> > 	 * The loop body estimates how many blocks it can request from
> > 	 * fdblocks to stash in the reserve pool.  This is a classic
> > 	 * TOCTOU race since fdblocks updates are not always coordinated
> > 	 * via m_sb_lock.  We also cannot tell if @free remaining
> > 	 * unchanged between iterations is due to an idle system or
> > 	 * freed blocks being consumed immediately, so we'll try a
> > 	 * finite number of times to satisfy the request.
> > 	 */
> > 	for (tries = 0; tries < 30...) {
> > 
> > > 
> > > > +		/*
> > > > +		 * The reservation pool cannot take space that xfs_mod_fdblocks
> > > > +		 * will not give us.  This includes the per-AG set-aside space
> > > > +		 * and free space btree blocks that are not available for
> > > > +		 * allocation due to per-AG metadata reservations.
> > > > +		 */
> > > > +		free = percpu_counter_sum(&mp->m_fdblocks);
> > > > +		free -= mp->m_alloc_set_aside;
> > > > +		free -= atomic64_read(&mp->m_allocbt_blks);
> > > 
> > > Seems reasonable. Do we want to consider ->m_allocbt_blks in other
> > > places where ->m_alloc_set_aside is used (i.e. xfs_fs_statfs(), etc.)?
> > > Not sure how much it matters for space reporting purposes, but if so, it
> > > might also be worth reconsidering the usefulness of a static field and
> > > initialization helper (i.e. xfs_alloc_set_aside()) if the majority of
> > > uses involve a dynamic calculation (due to ->m_allocbt_blks).
> > 
> > When I was writing this patch, I very nearly decided to make those three
> > lines above their own helper.  I didn't see any other spots that looked
> > like obvious candidates for such a calculation outside of statfs.
> > 
> 
> Indeed..
> 
> > Subtracting m_allocbt_blks from statfs' avail field is a behavior
> > change, since we always used to consider bnobt blocks as available.  We
> > don't have an exact count of how many blocks are needed to hide the
> > per-ag reserved extents, so in the end we have to decide whether we want
> > to hear complaints about over- or under-estimation of available blocks.
> > 
> > So I think the statfs stuff is a separate patch. :)
> > 
> 
> Similar deal as above.. I'm more interested in a potential cleanup of
> the code that helps prevent this sort of buglet for the next user of
> ->m_alloc_set_aside that will (expectedly) have no idea about this
> subtle quirk than I am about what's presented in the free space
> counters. ISTM that we ought to just ditch ->m_alloc_set_aside, replace
> the existing xfs_alloc_set_aside() with an XFS_ALLOC_FS_RESERVED() macro
> or something that just does the (agcount << 3) thing, and then define a

I'm not sure that the current xfs_alloc_set_aside code is correct.
Right now it comes with this comment:

"We need to reserve 4 fsbs _per AG_ for the freelist and 4 more to
handle a potential split of the file's bmap btree."

I think the first part ("4 fsbs _per AG_ for the freelist") is wrong.
AFAICT, that part refers to the number of blocks we need to keep free in
case we have to replenish a completely empty AGFL.  The hardcoded value
of 4 seems wrong, since xfs_alloc_min_freelist() is what _fix_freelist
uses to decide how big the AGFL needs to be, and it returns 6 on a
filesystem that has rmapbt enabled.  So I think XFS_ALLOC_AGFL_RESERVE
is wrong here and should be replaced with the function call.

I also think the second part ("and 4 more to handle a split of the
file's bmap btree") is wrong.  If we're really supposed to save enough
blocks to handle a bmbt split, then I think this ought to be
(mp->m_bm_maxlevels[0] - 1), not 4, right?  According to xfs_db, bmap
btrees can be 9 levels tall:

xfs_db> btheight bmapbt -n 4294967296 -b 512
bmapbt: worst case per 512-byte block: 13 records (leaf) / 13 keyptrs (node)
level 0: 4294967296 records, 330382100 blocks
level 1: 330382100 records, 25414008 blocks
level 2: 25414008 records, 1954924 blocks
level 3: 1954924 records, 150379 blocks
level 4: 150379 records, 11568 blocks
level 5: 11568 records, 890 blocks
level 6: 890 records, 69 blocks
level 7: 69 records, 6 blocks
level 8: 6 records, 1 block
9 levels, 357913945 blocks total

The root level is in the inode, so we need 8 blocks to handle a full
split on a 512b block filesystem.

Granted, it's at least correct for 4k+ block filesystems:

xfs_db> btheight bmapbt -n 4294967296
bmapbt: worst case per 4096-byte block: 125 records (leaf) / 125 keyptrs (node)
level 0: 4294967296 records, 34359739 blocks
level 1: 34359739 records, 274878 blocks
level 2: 274878 records, 2200 blocks
level 3: 2200 records, 18 blocks
level 4: 18 records, 1 block
5 levels, 34636836 blocks total

So in the end, I think that calculation should become:

unsigned int
xfs_alloc_set_aside(
	struct xfs_mount	*mp)
{
	unsigned int		min-agfl = xfs_alloc_min_freelist(mp, NULL);

	return mp->m_sb.sb_agcount * (min_agfl + mp->m_bm_maxlevels[0] - 1);
}

> new xfs_alloc_set_aside() that combines the macro calculation with
> ->m_allocbt_blks. Then the whole "set aside" concept is calculated and
> documented in one place. Hm?

I think I'd rather call the new function xfs_fdblocks_avail() over
reusing an existing name, because I fear that zapping an old function
and replacing it with a new function with the same name will cause
confusion for anyone backporting patches or reading code after an
absence.

Also the only reason we have a mount variable and a function (instead of
a macro) is that Dave asked me to change the codebase away from the
XFS_ALLOC_AG_MAX_USABLE/XFS_ALLOC_SET_ASIDE macros as part of merging
reflink.

--D

> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > >  		if (free <= 0)
> > > >  			break;
> > > >  
> > > > @@ -459,7 +467,7 @@ xfs_reserve_blocks(
> > > >  		spin_unlock(&mp->m_sb_lock);
> > > >  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> > > >  		spin_lock(&mp->m_sb_lock);
> > > > -	} while (error == -ENOSPC);
> > > > +	}
> > > >  
> > > >  	/*
> > > >  	 * Update the reserve counters if blocks have been successfully
> > > > 
> > > 
> > 
> 
