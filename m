Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60DBEB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 04:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjFTEos (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 00:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjFTEor (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 00:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAB910C7
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 21:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87F2460F8F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 04:44:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EC2C433C8;
        Tue, 20 Jun 2023 04:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687236284;
        bh=8o7s1nbFqnKZfK3NkcoN2Lik3SpEceyuO4UJ42rMT/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCtD3nx8/HwJNagrRWnlRA69oN5c3jephMQ6gqiwUfhkIHd6PVJ5dYDPCyUtMjqwn
         g8bBVhM4YKiP07FVMShOmfOYoPuYjNOF1K2s8lkvc1uEMR/yaMfblOEWeYLd8lEsB1
         RQmIDXSYKWZcp2zFA+BS9f4WlmLNwqRnI8opOjXmzEcOwpRMad9aSoRtTNoGlcnQtA
         5kFtWINjn7NbX59B4deM6TNnUUYtFLoA9giYVzDBZ1rRFYGBkVs+ue9T2IDIuBTxC/
         tJ++E9QSVUnVWcGa7Hf6RyfJsHqf9LkuqOapYgIwR9M6w7Ooqb5kT94Q6ztsl0YsrZ
         PmLP0+pwnm/4A==
Date:   Mon, 19 Jun 2023 21:44:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <20230620044443.GE11467@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
 <ZJEb2nSpIWoiKm6a@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJEb2nSpIWoiKm6a@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 20, 2023 at 01:24:10PM +1000, Dave Chinner wrote:
> On Thu, May 25, 2023 at 05:44:48PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > After an online repair, we need to invalidate buffers representing the
> > blocks from the old metadata that we're replacing.  It's possible that
> > parts of a tree that were previously cached in memory are no longer
> > accessible due to media failure or other corruption on interior nodes,
> > so repair figures out the old blocks from the reverse mapping data and
> > scans the buffer cache directly.
> > 
> > Unfortunately, the current buffer cache code triggers asserts if the
> > rhashtable lookup finds a non-stale buffer of a different length than
> > the key we searched for.  For regular operation this is desirable, but
> > for this repair procedure, we don't care since we're going to forcibly
> > stale the buffer anyway.  Add an internal lookup flag to avoid the
> > assert.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/reap.c |    2 +-
> >  fs/xfs/xfs_buf.c    |    5 ++++-
> >  fs/xfs/xfs_buf.h    |   10 ++++++++++
> >  3 files changed, 15 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> > index 30e61315feb0..ca75c22481d2 100644
> > --- a/fs/xfs/scrub/reap.c
> > +++ b/fs/xfs/scrub/reap.c
> > @@ -149,7 +149,7 @@ xrep_block_reap_binval(
> >  	 */
> >  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> >  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > -			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
> > +			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> 
> Can't say I'm a big fan of XBF_BCACHE_SCAN as a name - it tells me
> nothing about what the incore lookup is actually doing. The actual
> lookup action that is being performed is "find any match" rather
> than "find exact match". XBF_ANY_MATCH would be a better name, IMO.
> 
> >  	if (error)
> >  		return;
> >  
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 15d1e5a7c2d3..b31e6d09a056 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
> >  		 * reallocating a busy extent. Skip this buffer and
> >  		 * continue searching for an exact match.
> >  		 */
> > -		ASSERT(bp->b_flags & XBF_STALE);
> > +		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
> > +			ASSERT(bp->b_flags & XBF_STALE);
> 
> And this becomes XBM_ANY_MATCH, too.

Hmmm.  I've never come up with a good name for this flag.  The caller
actually has a *specific* length in mind; it simply doesn't want to trip
the assertions on the cached buffers that have a different length but
won't be returned by *this* call.

If the buffer cache has bufs for daddr 24 len 8 and daddr len 120, the
scan calls xfs_buf_get as follows:

daddr 24 len 1 (nothing)
daddr 24 len 2 (nothing)
...
daddr 24 len 8 (finds the first buffer)
...
daddr 24 len 120 (finds the second buffer)
...
daddr 24 len 132 (nothing)

I don't want the scan to ASSERT 130 times, because that muddles the
output so badly that it becomes impossible to find relevant debugging
messages among the crap.

Can I change it to XB[FM]_IGNORE_MISMATCHES?

> >  		return 1;
> >  	}
> >  	return 0;
> > @@ -682,6 +683,8 @@ xfs_buf_get_map(
> >  	int			error;
> >  	int			i;
> >  
> > +	if (flags & XBF_BCACHE_SCAN)
> > +		cmap.bm_flags |= XBM_IGNORE_LENGTH_MISMATCH;
> >  	for (i = 0; i < nmaps; i++)
> >  		cmap.bm_len += map[i].bm_len;
> >  
> > diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> > index 549c60942208..d6e8c3bab9f6 100644
> > --- a/fs/xfs/xfs_buf.h
> > +++ b/fs/xfs/xfs_buf.h
> > @@ -44,6 +44,11 @@ struct xfs_buf;
> >  #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
> >  
> >  /* flags used only as arguments to access routines */
> > +/*
> > + * We're scanning the buffer cache; do not warn about lookup mismatches.
> 
> The code using the flag isn't doing this - it's trying to invalidate
> any existing buffer at the location given. It simply wants any
> buffer at that address to be returned...
> 
> > + * Only online repair should use this.
> > + */
> > +#define XBF_BCACHE_SCAN	 (1u << 28)
> >  #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
> >  #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
> >  #define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
> > @@ -67,6 +72,7 @@ typedef unsigned int xfs_buf_flags_t;
> >  	{ _XBF_KMEM,		"KMEM" }, \
> >  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> >  	/* The following interface flags should never be set */ \
> > +	{ XBF_BCACHE_SCAN,	"BCACHE_SCAN" }, \
> >  	{ XBF_INCORE,		"INCORE" }, \
> >  	{ XBF_TRYLOCK,		"TRYLOCK" }, \
> >  	{ XBF_UNMAPPED,		"UNMAPPED" }
> > @@ -114,8 +120,12 @@ typedef struct xfs_buftarg {
> >  struct xfs_buf_map {
> >  	xfs_daddr_t		bm_bn;	/* block number for I/O */
> >  	int			bm_len;	/* size of I/O */
> > +	unsigned int		bm_flags;
> >  };
> >  
> > +/* Don't complain about live buffers with the wrong length during lookup. */
> > +#define XBM_IGNORE_LENGTH_MISMATCH	(1U << 0)
> 
> Which makes me wonder now: can we have two cached buffers at the
> same address with different lengths during a repair?

Let's say there's a filesystem with dirblksize 8k.  A directory block
gets crosslinked with an xattr block.  Running the dir and xattr
scrubbers each will create a new cached buffer -- an 8k buffer for the
dir, and a 4k buffer for the xattr.  Let's say that the dir block
overwrote the attr block.  Then, the xattr read verifier will fail in
xfs_trans_buf_read, but that doesn't remove the buffer from the cache.

I want the xattr repair to be able to scan the buffer cache and examine
both buffers without throwing assertions all over the place, because
that makes it harder to debug repair.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
