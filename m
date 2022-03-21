Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DBFC433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Mar 2022 20:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347651AbiCUUnt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbiCUUns (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Mar 2022 16:43:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9636F17B0F4
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 13:42:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01BD960EA2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Mar 2022 20:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDBBC340ED;
        Mon, 21 Mar 2022 20:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647895341;
        bh=+fLCPsJXGjeABHRMWi4KJpmImK8BeuGTMy2JieLSG8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ED4O9Dqp8zGW8RHIXmhbEUC7o/R7u9IaqPsaP7Uq+JiMz+PhZlx1elDi5ARud5ldI
         C/HoY2lVxMAYbdsqUv0vwCdbbq3DCJ7RTTVHC7YFGrOBGUxevabSGNQrmtL5c3AMVP
         pVCyio6NhbMQTSaX65Zb1e0yIBkdTgqNcgLEzHEAXS4/beajhiLEaimonx70cY5j2U
         dQsCm3CR4MYz7V1aDnfscBeHneok093rwc1sUgNKFLfK3xl1o14aAmDj2mD+4Qv3Qr
         Ghp9JpI7yJ4+/0O2Dvc+TxYYhFIHQM4XE3Y7tgZdou1kSUa4GmCowflT0Wy/3RvCKk
         wCBdfcqWUg5JQ==
Date:   Mon, 21 Mar 2022 13:42:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/6] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <20220321204220.GI8224@magnolia>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779462392.550479.11627083041484347485.stgit@magnolia>
 <YjiYM2uxEHAfWFmz@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjiYM2uxEHAfWFmz@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 11:22:27AM -0400, Brian Foster wrote:
> On Sun, Mar 20, 2022 at 09:43:43AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_reserve_blocks controls the size of the user-visible free space
> > reserve pool.  Given the difference between the current and requested
> > pool sizes, it will try to reserve free space from fdblocks.  However,
> > the amount requested from fdblocks is also constrained by the amount of
> > space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> > reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> > 
> > In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> > out the "free space" used by the free space btrees, because some portion
> > of the free space btrees hold in reserve space for future btree
> > expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> > of blocks that it could request from xfs_mod_fdblocks was not updated to
> > include m_allocbt_blks, so if space is extremely low, the caller hangs.
> > 
> > Fix this by creating a function to estimate the number of blocks that
> > can be reserved from fdblocks, which needs to exclude the set-aside and
> > m_allocbt_blks.
> > 
> > Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> > with an fstests configuration that specifies a 1k blocksize and a
> > specially crafted log size that will consume 7/8 of the space (17920
> > blocks, specifically) in that AG.
> > 
> > Cc: Brian Foster <bfoster@redhat.com>
> > Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_fsops.c |    2 +-
> >  fs/xfs/xfs_mount.c |    2 +-
> >  fs/xfs/xfs_mount.h |   15 +++++++++++++++
> >  3 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > 
> ...
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 00720a02e761..da1b7056e743 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -479,6 +479,21 @@ extern void	xfs_unmountfs(xfs_mount_t *);
> >   */
> >  #define XFS_FDBLOCKS_BATCH	1024
> >  
> > +/*
> > + * Estimate the amount of free space that is not available to userspace and is
> > + * not explicitly reserved from the incore fdblocks:
> > + *
> > + * - Space reserved to ensure that we can always split a bmap btree
> > + * - Free space btree blocks that are not available for allocation due to
> > + *   per-AG metadata reservations
> > + */
> 
> What does this mean by "due to" perag res? That sounds like a separate
> thing to me. Perhaps this could just say something like:
> 
> "Estimate the amount of accounted free space that is not available to
> userspace. This includes the minimum number of blocks to support a bmbt
> split (calculated at mount time) and the blocks currently in-use by the
> allocation btrees."

IMO, the last sentence should capture /why/ we subtract the blocks that
are in use by the free space btrees because we used to advertise freesp
btree blocks in f_bfree/f_bavail, and someone who is accustomed to that
behavior might read the sentence and think "Oh, that's incorrect".

But clearly "due to per-AG metadata reservations" isn't clear enough, so
I'll change it to:

"The blocks currently in use by the freespace btrees because they record
the actual blocks that will fill per-AG metadata space reservations."

Thanks for the review :)

--D

> Comment nit aside, this LGTM. Thanks for the rework..
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +static inline uint64_t
> > +xfs_fdblocks_unavailable(
> > +	struct xfs_mount	*mp)
> > +{
> > +	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> > +}
> > +
> >  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
> >  				 bool reserved);
> >  extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> > 
> 
