Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 306FBEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jul 2023 23:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbjGEXRk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjGEXRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2023 19:17:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2460E57
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 16:17:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50DD46185F
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jul 2023 23:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5810C433C8;
        Wed,  5 Jul 2023 23:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688599057;
        bh=3HI7YS5fSSNqNnbwaIemjtpgOOsWiOiFyrj0UGf0Tsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KbcR71T5D+vyPbgM7eI7PWi4DvdHR9YyZWbA48WuIjkjBfQcCsZVzg+SRMrBYiWPj
         3x9vZlUJ9LdrEDwXYzQkizTq8ea4IHEYK3SQcv//M5CJSIwiQ5iPzzouNQMKMxVqax
         viYgAQy6qEskXIutnM1r6ykJWHkRene4X5GKbcGj8g9N2fIXw/zHHu8Mg048c/x76K
         co1XqyFNBiI7ckEnQ1yIeVf6E/qs99CHW9fWjzGyIDk4On69d2VqqA1zWig25haXlD
         shkSdjyv19flR0Lm78rQzV6m3jyWGVl3aUPe3Ul3Xnknm9V2mkPhZjM9aBWIy8vIBz
         T+mRzNkXnhR3g==
Date:   Wed, 5 Jul 2023 16:17:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <20230705231736.GT11441@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
 <ZJEb2nSpIWoiKm6a@dread.disaster.area>
 <20230620044443.GE11467@frogsfrogsfrogs>
 <ZJFAqTaV6AO37v04@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJFAqTaV6AO37v04@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 04:01:13PM +1000, Dave Chinner wrote:
> On Mon, Jun 19, 2023 at 09:44:43PM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 20, 2023 at 01:24:10PM +1000, Dave Chinner wrote:
> > > On Thu, May 25, 2023 at 05:44:48PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > After an online repair, we need to invalidate buffers representing the
> > > > blocks from the old metadata that we're replacing.  It's possible that
> > > > parts of a tree that were previously cached in memory are no longer
> > > > accessible due to media failure or other corruption on interior nodes,
> > > > so repair figures out the old blocks from the reverse mapping data and
> > > > scans the buffer cache directly.
> > > > 
> > > > Unfortunately, the current buffer cache code triggers asserts if the
> > > > rhashtable lookup finds a non-stale buffer of a different length than
> > > > the key we searched for.  For regular operation this is desirable, but
> > > > for this repair procedure, we don't care since we're going to forcibly
> > > > stale the buffer anyway.  Add an internal lookup flag to avoid the
> > > > assert.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/scrub/reap.c |    2 +-
> > > >  fs/xfs/xfs_buf.c    |    5 ++++-
> > > >  fs/xfs/xfs_buf.h    |   10 ++++++++++
> > > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> > > > index 30e61315feb0..ca75c22481d2 100644
> > > > --- a/fs/xfs/scrub/reap.c
> > > > +++ b/fs/xfs/scrub/reap.c
> > > > @@ -149,7 +149,7 @@ xrep_block_reap_binval(
> > > >  	 */
> > > >  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> > > >  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > > > -			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
> > > > +			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> > > 
> > > Can't say I'm a big fan of XBF_BCACHE_SCAN as a name - it tells me
> > > nothing about what the incore lookup is actually doing. The actual
> > > lookup action that is being performed is "find any match" rather
> > > than "find exact match". XBF_ANY_MATCH would be a better name, IMO.
> > > 
> > > >  	if (error)
> > > >  		return;
> > > >  
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index 15d1e5a7c2d3..b31e6d09a056 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
> > > >  		 * reallocating a busy extent. Skip this buffer and
> > > >  		 * continue searching for an exact match.
> > > >  		 */
> > > > -		ASSERT(bp->b_flags & XBF_STALE);
> > > > +		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
> > > > +			ASSERT(bp->b_flags & XBF_STALE);
> > > 
> > > And this becomes XBM_ANY_MATCH, too.
> > 
> > Hmmm.  I've never come up with a good name for this flag.  The caller
> > actually has a *specific* length in mind; it simply doesn't want to trip
> > the assertions on the cached buffers that have a different length but
> > won't be returned by *this* call.
> > 
> > If the buffer cache has bufs for daddr 24 len 8 and daddr len 120, the
> > scan calls xfs_buf_get as follows:
> > 
> > daddr 24 len 1 (nothing)
> > daddr 24 len 2 (nothing)
> > ...
> > daddr 24 len 8 (finds the first buffer)
> > ...
> > daddr 24 len 120 (finds the second buffer)
> > ...
> > daddr 24 len 132 (nothing)
> > 
> > I don't want the scan to ASSERT 130 times, because that muddles the
> > output so badly that it becomes impossible to find relevant debugging
> > messages among the crap.
> 
> As I mentioned in the my response to the next patch, this is an
> O(N^2) brute force search. But how do you get two buffers at the
> same address into the cache in the first place?

/me smacks forehead, realizes that I totally lead you astray here.
What we're scanning for is the case that the buffer cache has two
overlapping buffers with *different* daddrs.

(That teaches me to reply to emails while on vacation...)

xreap_agextent_binval is only called if the extent being freed is
completely owned by the data structure and is *not* crosslinked with a
different structure.  We've just rebuilt a data structure that was
corrupt in some manner, but the reaper doesn't know the details of that
corruption.  Therefore, the reaper should invalidate /all/ buffers that
might span the extent being freed, no matter how they ended up in the
cache.  If a deceased data structure thought it was the sole owner of a
single fsblock of space starting at fsblock 16, we ought to look for
buffers (daddr 128, length 1) (128, 2), ... (128, 8), (129, 1), (129, 2)
...  (129, 7) ... (135, 1) and invalidate all of them.

Concrete example:

So let's pretend that we have an xfs with fs blocksize 4k and dir
blocksize 8k.  Let's suppose the directory's data fork maps fsblock 16,
resulting in a buffer (daddr 128, length 16).  Let us further suppose
the inobt then allocates fsblock 17, resulting in a buffer (daddr 136,
length 8).  These are crosslinked.

First, we discover the inobt is crosslinked with a directory and decide
to rebuild it.  We write out the new inobt and go to reap the old
blocks.  Since fsblock 17 is crosslinked, we simply remove the OWN_INOBT
rmap record and leave the buffer.

Aside: Long ago, I tried to make the reaping code invalidate buffers
when the space is crosslinked, but I couldn't figure out how to deal
with the situation where (say) the bmap btrees of two separate forks
think they own the same block.  The b_ops will be the same; the buffer
cache doesn't know about the owner field in the block header, and
there's no way to distinguish the blocks for a data fork bmbt vs. an
attr fork bmbt.

Next we discover that the directory is corrupt and decide to rebuild
that.  The directory is now the only owner, so it can actually free the
two fsb of space at startblock 16fsb.  Both buffers (128, 16) and (136,
8) are still in the cache, so it needs to invalidate both.

Does all /that/ make sense?

--D

> > > >  		return 1;
> > > >  	}
> > > >  	return 0;
> > > > @@ -682,6 +683,8 @@ xfs_buf_get_map(
> > > >  	int			error;
> > > >  	int			i;
> > > >  
> > > > +	if (flags & XBF_BCACHE_SCAN)
> > > > +		cmap.bm_flags |= XBM_IGNORE_LENGTH_MISMATCH;
> > > >  	for (i = 0; i < nmaps; i++)
> > > >  		cmap.bm_len += map[i].bm_len;
> > > >  
> > > > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > > > index 549c60942208..d6e8c3bab9f6 100644
> > > > --- a/fs/xfs/xfs_buf.h
> > > > +++ b/fs/xfs/xfs_buf.h
> > > > @@ -44,6 +44,11 @@ struct xfs_buf;
> > > >  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
> > > >  
> > > >  /* flags used only as arguments to access routines */
> > > > +/*
> > > > + * We're scanning the buffer cache; do not warn about lookup mismatches.
> > > 
> > > The code using the flag isn't doing this - it's trying to invalidate
> > > any existing buffer at the location given. It simply wants any
> > > buffer at that address to be returned...
> > > 
> > > > + * Only online repair should use this.
> > > > + */
> > > > +#define XBF_BCACHE_SCAN	 (1u << 28)
> > > >  #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
> > > >  #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
> > > >  #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
> > > > @@ -67,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
> > > >  	{ _XBF_KMEM,		"KMEM" }, \
> > > >  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> > > >  	/* The following interface flags should never be set */ \
> > > > +	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
> > > >  	{ XBF_INCORE,		"INCORE" }, \
> > > >  	{ XBF_TRYLOCK,		"TRYLOCK" }, \
> > > >  	{ XBF_UNMAPPED,		"UNMAPPED" }
> > > > @@ -114,8 +120,12 @@ typedef struct xfs_buftarg {
> > > >  struct xfs_buf_map {
> > > >  	xfs_daddr_t		bm_bn;	/* block number for I/O */
> > > >  	int			bm_len;	/* size of I/O */
> > > > +	unsigned int		bm_flags;
> > > >  };
> > > >  
> > > > +/* Don't complain about live buffers with the wrong length during lookup. */
> > > > +#define XBM_IGNORE_LENGTH_MISMATCH	(1U << 0)
> > > 
> > > Which makes me wonder now: can we have two cached buffers at the
> > > same address with different lengths during a repair?
> > 
> > Let's say there's a filesystem with dirblksize 8k.  A directory block
> > gets crosslinked with an xattr block.  Running the dir and xattr
> > scrubbers each will create a new cached buffer -- an 8k buffer for the
> > dir, and a 4k buffer for the xattr. 
> 
> The second one will trip an assert fail because it found a non-stale
> block of a different length.
> 
> This is fundamental property of the buffer cache - there is only
> supposed to be a single active buffer for a given daddr in the cache
> at once. Just because the production code doesn't noisily complain
> about it, doesn't mean it is valid behaviour.
> 
> > Let's say that the dir block
> > overwrote the attr block.  Then, the xattr read verifier will fail in
> > xfs_trans_buf_read, but that doesn't remove the buffer from the cache.
> 
> It won't even get to the read verifier on a debug kernel - it should
> be assert failing in the compare function trying to look up the
> second buffer as it's asking for a different length.
> 
> i.e. I don't see how the above "crosslinked with different lengths
> instantiates two independent buffers" works at all on a debug
> kernel. It should fail, it is meant to fail, it is meant to tell us
> something is breaking the fundamental assumption that there is only
> one active cached buffer for a given daddr at a given time....
> 
> What am I missing?
> 
> > I want the xattr repair to be able to scan the buffer cache and examine
> > both buffers without throwing assertions all over the place, because
> > that makes it harder to debug repair.
> 
> Right, but I don't see anything in the buffer cache changes so far
> that allow that or make it in any way safe for it to occur.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
