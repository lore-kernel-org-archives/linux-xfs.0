Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA6CEB64DC
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Jul 2023 23:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjGIXcU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Jul 2023 19:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGIXcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jul 2023 19:32:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E86FA
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 16:32:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F12660BEB
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 23:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F54C433C8;
        Sun,  9 Jul 2023 23:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688945537;
        bh=AWQL0/xi+r/VPn1sQkhMIytytV5/7Swp97f315gYduo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rshlfbyl/mnjy6oMyzdfUa/Td+ytb3r22STLKmJ3COcLGTqdAAx9OXsVa8PDXBhZP
         LrCyVNF0DgIlj82g4gqewZgiyf8GXZJZWNrtS1djQ8esRU9uBDMUGKRo0FnE6i7p1h
         M8hxRt4RaxNjvvpAl7nwTZi7HJ2DAQxUbi+w5KJpi+N5LbV0NV7AbRmeBRj90pocp+
         kG9sW0iUFYyOfDHY00a9fjVEaqNIF4oGqaIxN2L+Wmf4XGsKm7UjMw+pP71OLz4TmB
         ArJDnVfhGeXV5Al2hqk0nwT4bW3eh+NL/FFmVAFEX6Ciy56GWDZe8M1WUBjeynW0s5
         OV09FC2+ZBDmA==
Date:   Sun, 9 Jul 2023 16:32:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <20230709233216.GE11456@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
 <ZJEb2nSpIWoiKm6a@dread.disaster.area>
 <20230620044443.GE11467@frogsfrogsfrogs>
 <ZJFAqTaV6AO37v04@dread.disaster.area>
 <20230705231736.GT11441@frogsfrogsfrogs>
 <ZKs/eo/13sCfEqvQ@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKs/eo/13sCfEqvQ@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 10, 2023 at 09:15:06AM +1000, Dave Chinner wrote:
> On Wed, Jul 05, 2023 at 04:17:36PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 20, 2023 at 04:01:13PM +1000, Dave Chinner wrote:
> > > On Mon, Jun 19, 2023 at 09:44:43PM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jun 20, 2023 at 01:24:10PM +1000, Dave Chinner wrote:
> > > > > On Thu, May 25, 2023 at 05:44:48PM -0700, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > > 
> > > > > > After an online repair, we need to invalidate buffers representing the
> > > > > > blocks from the old metadata that we're replacing.  It's possible that
> > > > > > parts of a tree that were previously cached in memory are no longer
> > > > > > accessible due to media failure or other corruption on interior nodes,
> > > > > > so repair figures out the old blocks from the reverse mapping data and
> > > > > > scans the buffer cache directly.
> > > > > > 
> > > > > > Unfortunately, the current buffer cache code triggers asserts if the
> > > > > > rhashtable lookup finds a non-stale buffer of a different length than
> > > > > > the key we searched for.  For regular operation this is desirable, but
> > > > > > for this repair procedure, we don't care since we're going to forcibly
> > > > > > stale the buffer anyway.  Add an internal lookup flag to avoid the
> > > > > > assert.
> > > > > > 
> > > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > > ---
> > > > > >  fs/xfs/scrub/reap.c |    2 +-
> > > > > >  fs/xfs/xfs_buf.c    |    5 ++++-
> > > > > >  fs/xfs/xfs_buf.h    |   10 ++++++++++
> > > > > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > 
> > > > > > diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> > > > > > index 30e61315feb0..ca75c22481d2 100644
> > > > > > --- a/fs/xfs/scrub/reap.c
> > > > > > +++ b/fs/xfs/scrub/reap.c
> > > > > > @@ -149,7 +149,7 @@ xrep_block_reap_binval(
> > > > > >  	 */
> > > > > >  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> > > > > >  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > > > > > -			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
> > > > > > +			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> > > > > 
> > > > > Can't say I'm a big fan of XBF_BCACHE_SCAN as a name - it tells me
> > > > > nothing about what the incore lookup is actually doing. The actual
> > > > > lookup action that is being performed is "find any match" rather
> > > > > than "find exact match". XBF_ANY_MATCH would be a better name, IMO.
> > > > > 
> > > > > >  	if (error)
> > > > > >  		return;
> > > > > >  
> > > > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > > > index 15d1e5a7c2d3..b31e6d09a056 100644
> > > > > > --- a/fs/xfs/xfs_buf.c
> > > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > > @@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
> > > > > >  		 * reallocating a busy extent. Skip this buffer and
> > > > > >  		 * continue searching for an exact match.
> > > > > >  		 */
> > > > > > -		ASSERT(bp->b_flags & XBF_STALE);
> > > > > > +		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
> > > > > > +			ASSERT(bp->b_flags & XBF_STALE);
> > > > > 
> > > > > And this becomes XBM_ANY_MATCH, too.
> > > > 
> > > > Hmmm.  I've never come up with a good name for this flag.  The caller
> > > > actually has a *specific* length in mind; it simply doesn't want to trip
> > > > the assertions on the cached buffers that have a different length but
> > > > won't be returned by *this* call.
> > > > 
> > > > If the buffer cache has bufs for daddr 24 len 8 and daddr len 120, the
> > > > scan calls xfs_buf_get as follows:
> > > > 
> > > > daddr 24 len 1 (nothing)
> > > > daddr 24 len 2 (nothing)
> > > > ...
> > > > daddr 24 len 8 (finds the first buffer)
> > > > ...
> > > > daddr 24 len 120 (finds the second buffer)
> > > > ...
> > > > daddr 24 len 132 (nothing)
> > > > 
> > > > I don't want the scan to ASSERT 130 times, because that muddles the
> > > > output so badly that it becomes impossible to find relevant debugging
> > > > messages among the crap.
> > > 
> > > As I mentioned in the my response to the next patch, this is an
> > > O(N^2) brute force search. But how do you get two buffers at the
> > > same address into the cache in the first place?
> > 
> > /me smacks forehead, realizes that I totally lead you astray here.
> > What we're scanning for is the case that the buffer cache has two
> > overlapping buffers with *different* daddrs.
> > 
> > (That teaches me to reply to emails while on vacation...)
> > 
> > xreap_agextent_binval is only called if the extent being freed is
> > completely owned by the data structure and is *not* crosslinked with a
> > different structure.  We've just rebuilt a data structure that was
> > corrupt in some manner, but the reaper doesn't know the details of that
> > corruption.  Therefore, the reaper should invalidate /all/ buffers that
> > might span the extent being freed, no matter how they ended up in the
> > cache.  If a deceased data structure thought it was the sole owner of a
> > single fsblock of space starting at fsblock 16, we ought to look for
> > buffers (daddr 128, length 1) (128, 2), ... (128, 8), (129, 1), (129, 2)
> > ...  (129, 7) ... (135, 1) and invalidate all of them.
> 
> Ok, but we can't have random metadata buffers at individual daddr
> offsets - except for the AG headers, every metadata buffer is
> filesystem block aligned. Hence in the above example, there is no
> possibility of having a metadata buffer at sectors 129-135 on a 4kB
> block size filesystem.
> 
> > Concrete example:
> > 
> > So let's pretend that we have an xfs with fs blocksize 4k and dir
> > blocksize 8k.  Let's suppose the directory's data fork maps fsblock 16,
> > resulting in a buffer (daddr 128, length 16).  Let us further suppose
> > the inobt then allocates fsblock 17, resulting in a buffer (daddr 136,
> > length 8).  These are crosslinked.
> 
> RIght, that's an intersection of {128,16} and {136,8}. The search
> region for buffer invalidation is {128, 8} {128, 16} and {136, 8}.
> They are the only possible buffers that can be cached in that region
> for a 4kB block size filesystem, as there can be no metadata buffers
> starting at daddrs 129-135 or 137-143...

<nod> There's nothing in this flag that *prevents* someone from spending
a lot of time pounding on the buffer cache with a per-daddr scan.  But
note that the next patch only ever calls it with fsblock-aligned daddr
and length values.  So in the end, the only xfs_buf queries will indded
be for {128, 8} {128, 16} and {136, 8} like you said.

See the next patch for the actual usage.  Sorry that I've been unclear
about all this and compounding it with not very good examples.  It's
been a /very/ long time since I actually touched this code (this rewrite
has been waiting for merge since ... 2019?) and I'm basically coming in
cold. :(

Ultimately I make invalidation scan code look like this:

/* Buffer cache scan context. */
struct xrep_bufscan {
	/* Disk address for the buffers we want to scan. */
	xfs_daddr_t		daddr;

	/* Maximum number of sectors to scan. */
	xfs_daddr_t		max_sectors;

	/* Each round, increment the search length by this number of sectors. */
	xfs_daddr_t		daddr_step;

	/* Internal scan state; initialize to zero. */
	xfs_daddr_t		__sector_count;
};

/*
 * Return an incore buffer from a sector scan, or NULL if there are no buffers
 * left to return.
 */
struct xfs_buf *
xrep_bufscan_advance(
	struct xfs_mount	*mp,
	struct xrep_bufscan	*scan)
{
	scan->__sector_count += scan->daddr_step;
	while (scan->__sector_count <= scan->max_sectors) {
		struct xfs_buf	*bp = NULL;
		int		error;

		error = xfs_buf_incore(mp->m_ddev_targp, scan->daddr,
				scan->__sector_count, XBF_LIVESCAN, &bp);
		if (!error)
			return bp;

		scan->__sector_count += scan->daddr_step;
	}

	return NULL;
}

/* Try to invalidate the incore buffers for an extent that we're freeing. */
STATIC void
xreap_agextent_binval(
	struct xreap_state	*rs,
	xfs_agblock_t		agbno,
	xfs_extlen_t		*aglenp)
{
	struct xfs_scrub	*sc = rs->sc;
	struct xfs_perag	*pag = sc->sa.pag;
	struct xfs_mount	*mp = sc->mp;
	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
	xfs_agblock_t		agbno_next = agbno + *aglenp;
	xfs_agblock_t		bno = agbno;

	/*
	 * Avoid invalidating AG headers and post-EOFS blocks because we never
	 * own those.
	 */
	if (!xfs_verify_agbno(pag, agbno) ||
	    !xfs_verify_agbno(pag, agbno_next - 1))
		return;

	/*
	 * If there are incore buffers for these blocks, invalidate them.  We
	 * assume that the lack of any other known owners means that the buffer
	 * can be locked without risk of deadlocking.  The buffer cache cannot
	 * detect aliasing, so employ nested loops to scan for incore buffers
	 * of any plausible size.
	 */
	while (bno < agbno_next) {
		struct xrep_bufscan	scan = {
			.daddr		= XFS_AGB_TO_DADDR(mp, agno, bno),
			.max_sectors	= xrep_bufscan_max_sectors(mp,
							agbno_next - bno),
			.daddr_step	= XFS_FSB_TO_BB(mp, 1),
		};
		struct xfs_buf	*bp;

		while ((bp = xrep_bufscan_advance(mp, &scan)) != NULL) {
			xfs_trans_bjoin(sc->tp, bp);
			xfs_trans_binval(sc->tp, bp);
			rs->invalidated++;

			/*
			 * Stop invalidating if we've hit the limit; we should
			 * still have enough reservation left to free however
			 * far we've gotten.
			 */
			if (rs->invalidated > XREAP_MAX_BINVAL) {
				*aglenp -= agbno_next - bno;
				goto out;
			}
		}

		bno++;
	}

out:
	trace_xreap_agextent_binval(sc->sa.pag, agbno, *aglenp);
}

I hope that makes it clearer?

--D

> > First, we discover the inobt is crosslinked with a directory and decide
> > to rebuild it.  We write out the new inobt and go to reap the old
> > blocks.  Since fsblock 17 is crosslinked, we simply remove the OWN_INOBT
> > rmap record and leave the buffer.
> > 
> > Aside: Long ago, I tried to make the reaping code invalidate buffers
> > when the space is crosslinked, but I couldn't figure out how to deal
> > with the situation where (say) the bmap btrees of two separate forks
> > think they own the same block.  The b_ops will be the same; the buffer
> > cache doesn't know about the owner field in the block header, and
> > there's no way to distinguish the blocks for a data fork bmbt vs. an
> > attr fork bmbt.
> > 
> > Next we discover that the directory is corrupt and decide to rebuild
> > that.  The directory is now the only owner, so it can actually free the
> > two fsb of space at startblock 16fsb.  Both buffers (128, 16) and (136,
> > 8) are still in the cache, so it needs to invalidate both.
> > 
> > Does all /that/ make sense?
> 
> Yes, it does, and I figured that is waht you were trying to detect,
> it's just the search pattern you described made no sense.
> 
> I still think needs cleaning up - it's doing a massive amount of
> unnecessary work checking for things that cannot exist...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
