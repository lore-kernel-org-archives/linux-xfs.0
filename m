Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D518EB64D9
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jul 2023 21:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjGGVuv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Jul 2023 17:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjGGVuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jul 2023 17:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B21F210B
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jul 2023 14:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1074361A8A
        for <linux-xfs@vger.kernel.org>; Fri,  7 Jul 2023 21:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E38AC433C8;
        Fri,  7 Jul 2023 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688766646;
        bh=NsG+6g7uKFnC6HfkQiec63yGBvnlkxtoMmnM5Nr2RlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Crizv/rkiAu6DmmHsE63m4h+gVTgwJB/YJzEVszckQpJkS3xlBmmZ3m9lWHkmhYIP
         FL0M4h2uo/MQiWfp03ya+PzM7tD6ac30HAMynPvXNby8ePyUEC3XriEr4ClSTrXD3T
         xnltHYSKp/K6WoNcqIIJBZydpU0f1Yu0qXr/htidStccTe1BRsHGfC/2nkRv+eeRhc
         MmUmnDbFwp3Ux+hyuENWGH9yDkz5BolLI4NxHpS2Q++D9DDia9R00Lj0RGJ+OAKc+6
         tCIGdTwzXbXt94K3YY5A89Cg1bCgtTE+iIoYOxPSWfi1ZumB9AZVCU+vOnZ9bj5ht5
         IVU3wsXsbihUQ==
Date:   Fri, 7 Jul 2023 14:50:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: reap large AG metadata extents when possible
Message-ID: <20230707215045.GB11456@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055733.3728180.3134566782464969180.stgit@frogsfrogsfrogs>
 <ZJE9XO9cFBDGbr/8@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJE9XO9cFBDGbr/8@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 03:47:08PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:45:03PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we're freeing extents that have been set in a bitmap, break the
> > bitmap extent into multiple sub-extents organized by fate, and reap the
> > extents.  This enables us to dispose of old resources more efficiently
> > than doing them block by block.
> > 
> > While we're at it, rename the reaping functions to make it clear that
> > they're reaping per-AG extents.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> .....
> > +xreap_agextent_binval(
> > +	struct xreap_state	*rs,
> > +	xfs_agblock_t		agbno,
> > +	xfs_extlen_t		*aglenp)
> >  {
> > -	struct xfs_buf		*bp = NULL;
> > -	int			error;
> > +	struct xfs_scrub	*sc = rs->sc;
> > +	struct xfs_perag	*pag = sc->sa.pag;
> > +	struct xfs_mount	*mp = sc->mp;
> > +	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
> > +	xfs_agblock_t		agbno_next = agbno + *aglenp;
> > +	xfs_agblock_t		bno = agbno;
> >  
> >  	/*
> > -	 * If there's an incore buffer for exactly this block, invalidate it.
> >  	 * Avoid invalidating AG headers and post-EOFS blocks because we never
> >  	 * own those.
> >  	 */
> > -	if (!xfs_verify_fsbno(sc->mp, fsbno))
> > +	if (!xfs_verify_agbno(pag, agbno) ||
> > +	    !xfs_verify_agbno(pag, agbno_next - 1))
> >  		return;
> >  
> >  	/*
> > -	 * We assume that the lack of any other known owners means that the
> > -	 * buffer can be locked without risk of deadlocking.
> > +	 * If there are incore buffers for these blocks, invalidate them.  We
> > +	 * assume that the lack of any other known owners means that the buffer
> > +	 * can be locked without risk of deadlocking.  The buffer cache cannot
> > +	 * detect aliasing, so employ nested loops to scan for incore buffers
> > +	 * of any plausible size.
> >  	 */
> > -	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> > -			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > -			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> > -	if (error)
> > -		return;
> > -
> > -	xfs_trans_bjoin(sc->tp, bp);
> > -	xfs_trans_binval(sc->tp, bp);
> > +	while (bno < agbno_next) {
> > +		xfs_agblock_t	fsbcount;
> > +		xfs_agblock_t	max_fsbs;
> > +
> > +		/*
> > +		 * Max buffer size is the max remote xattr buffer size, which
> > +		 * is one fs block larger than 64k.
> > +		 */
> > +		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
> > +				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
> > +
> > +		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
> > +			struct xfs_buf	*bp = NULL;
> > +			xfs_daddr_t	daddr;
> > +			int		error;
> > +
> > +			daddr = XFS_AGB_TO_DADDR(mp, agno, bno);
> > +			error = xfs_buf_incore(mp->m_ddev_targp, daddr,
> > +					XFS_FSB_TO_BB(mp, fsbcount),
> > +					XBF_BCACHE_SCAN, &bp);
> > +			if (error)
> > +				continue;
> > +
> > +			xfs_trans_bjoin(sc->tp, bp);
> > +			xfs_trans_binval(sc->tp, bp);
> > +			rs->invalidated++;
> 
> Hmmm. O(N^2) brute force lookup walk to find any buffer at that
> specific daddr?  That's going to have an impact on running systems
> by hammering the perag hash lock.
> 
> I didn't know this was being done before I suggested XBF_ANY_MATCH,
> but now I'm wondering how can we even have multiple buffers in the
> cache at a given address? The whole point of the ASSERT() in the
> match function is to indicate this should not ever happen.
> 
> i.e. xfs_buf_find_insert() uses rhashtable_lookup_get_insert_fast(),
> which will return an existing buffer only if it has a match length.
> The compare function used at insert time will throw an assert fail
> if any other buffer exists at that address that has a mismatched
> length that is not stale. There is no way to avoid that ASSERT check
> on insert.
> 
> Hence, AFAICT, the only way we can get multiple buffers into the
> cache at the same daddr with different lengths is for all the
> existing buffers at that daddr to all be stale at insert time.  In
> which case, why do we need to invalidate buffers that are already
> stale (i.e. been invalidated)?
> 
> What am I missing here? i.e. this appears to cater for behaviour

The same braino that I mentioned in my previous replies -- I failed to
state that we're looking for buffers within a specific range of fsblocks
that do /not/ start at the same addr.

> that doesn't currently exist in the buffer cache, and I'm not sure
> we even want to allow to occur in the buffer cache given that it
> generally indicates in-memory metadata corruption.....
> 
> Hmmmm. What if the buffer was already stale? The lookup will then

Urk.  Yes, that results in the buffer's stale state being cleared and
then the buffer gets cancelled *again*.  It's unnecessary and we can
skip the second invalidation.

I think I'll change the name back to its former name XBF_LIVESCAN, which
means "only return non-stale buffers, and don't complain about finding
something with the same daddr but a different length from what the
caller asked for".

--D

> clear all the stale state from it, leave it with no valid contents
> which we then invalidate again and log a new buffer cancel item for
> it. What are the implications of that? (My brain is too full of
> stuff trying to understand what this code is doing to be able to
> think this through right now.)
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
