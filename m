Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2002EB64DD
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Jul 2023 23:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjGIXPO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Jul 2023 19:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjGIXPN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Jul 2023 19:15:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0E5106
        for <linux-xfs@vger.kernel.org>; Sun,  9 Jul 2023 16:15:11 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id 98e67ed59e1d1-262e66481c4so1854541a91.1
        for <linux-xfs@vger.kernel.org>; Sun, 09 Jul 2023 16:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688944511; x=1691536511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8UCsg41bNgITNGSJ1G7v2ODBC+OXZnenP7SgeidhUw=;
        b=1fkCQqWcjSJ/GQvhmUOORuWHyjFxozrjB7PsG52+AXwEQUNUtZEHHR1bRCKmxN/ypV
         h4ZC3Omji6Ypmj80niDR2mc6MOr853P1reH9j66KWFCyxAFElHecqZa2T/jJOghsPP9V
         UcNYxqo8XT87RfjHnK+hAlWRBFkXLiPF1k908gcjKkqGr3GjvZUL2H1R586GU05ugKaK
         7FaKjo5tIeSpPquAoUBqxXzyfwunjLfnRJYYqjXfaXhmbvqAVsXzN9CgocZuj2Bg1QJK
         IqvhGutdogQ15NyNWHOXTqieuOQfFMditMpknk9M2wwNfp8F/xEJMupf9VTrH4JjiIFi
         GX5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688944511; x=1691536511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8UCsg41bNgITNGSJ1G7v2ODBC+OXZnenP7SgeidhUw=;
        b=fQINdfWpSaJSwCHUgIZAHqQO7NwjFNpZVeZrChKp//XBf96kBwY66ydgUCD+nG4YLY
         Xdrs6r4yDjVD35oRHXoVCxpIWR36AGLpjIzhU83ibg7sFvrcgGSSc2KmGjjmhC/NVxDK
         9UAPQ2jvmkxsIuz9gUm75iiODFuMvIxUo1+9lGj9svg581Y1eRmxaKlFhu1sOmTaFdLc
         eUFYNQeXagMnwP3vspk1lKZJEsh5buHXyZrzF6ea2RpEQgSsKTQXtt5MjFgVLMpMZZ21
         c6IVp+qI5aLfvDQqgyFX6kAqcV11U1RgTDiSTONc8caPN9p1oHRWUTcQgOzH1OwTw3MX
         V5VA==
X-Gm-Message-State: ABy/qLa7XI0c1HPWxE1uZI9I40f9PUIm36i9yYhDJkYWB2UyiLHDwmtL
        ZeMDWi5FlssKZwJ0FUKQ6VQ1gXrxsXmowFG+vKE=
X-Google-Smtp-Source: APBJJlGHiEgT46ypaQIn77NiIPCBoDPfXWI0TYBIIhqjSq3PmyzbO6zwYk8DV69EKX47yK0Dck+vFg==
X-Received: by 2002:a17:90b:24c:b0:264:929:ed96 with SMTP id fz12-20020a17090b024c00b002640929ed96mr5980733pjb.9.1688944511304;
        Sun, 09 Jul 2023 16:15:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id r8-20020a635d08000000b00553dcfc2179sm6125934pgb.52.2023.07.09.16.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jul 2023 16:15:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qIdcQ-004Any-1x;
        Mon, 10 Jul 2023 09:15:06 +1000
Date:   Mon, 10 Jul 2023 09:15:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: ignore stale buffers when scanning the buffer
 cache
Message-ID: <ZKs/eo/13sCfEqvQ@dread.disaster.area>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
 <168506055718.3728180.15781485173918712234.stgit@frogsfrogsfrogs>
 <ZJEb2nSpIWoiKm6a@dread.disaster.area>
 <20230620044443.GE11467@frogsfrogsfrogs>
 <ZJFAqTaV6AO37v04@dread.disaster.area>
 <20230705231736.GT11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705231736.GT11441@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 05, 2023 at 04:17:36PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 20, 2023 at 04:01:13PM +1000, Dave Chinner wrote:
> > On Mon, Jun 19, 2023 at 09:44:43PM -0700, Darrick J. Wong wrote:
> > > On Tue, Jun 20, 2023 at 01:24:10PM +1000, Dave Chinner wrote:
> > > > On Thu, May 25, 2023 at 05:44:48PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > After an online repair, we need to invalidate buffers representing the
> > > > > blocks from the old metadata that we're replacing.  It's possible that
> > > > > parts of a tree that were previously cached in memory are no longer
> > > > > accessible due to media failure or other corruption on interior nodes,
> > > > > so repair figures out the old blocks from the reverse mapping data and
> > > > > scans the buffer cache directly.
> > > > > 
> > > > > Unfortunately, the current buffer cache code triggers asserts if the
> > > > > rhashtable lookup finds a non-stale buffer of a different length than
> > > > > the key we searched for.  For regular operation this is desirable, but
> > > > > for this repair procedure, we don't care since we're going to forcibly
> > > > > stale the buffer anyway.  Add an internal lookup flag to avoid the
> > > > > assert.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/scrub/reap.c |    2 +-
> > > > >  fs/xfs/xfs_buf.c    |    5 ++++-
> > > > >  fs/xfs/xfs_buf.h    |   10 ++++++++++
> > > > >  3 files changed, 15 insertions(+), 2 deletions(-)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> > > > > index 30e61315feb0..ca75c22481d2 100644
> > > > > --- a/fs/xfs/scrub/reap.c
> > > > > +++ b/fs/xfs/scrub/reap.c
> > > > > @@ -149,7 +149,7 @@ xrep_block_reap_binval(
> > > > >  	 */
> > > > >  	error = xfs_buf_incore(sc->mp->m_ddev_targp,
> > > > >  			XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > > > > -			XFS_FSB_TO_BB(sc->mp, 1), 0, &bp);
> > > > > +			XFS_FSB_TO_BB(sc->mp, 1), XBF_BCACHE_SCAN, &bp);
> > > > 
> > > > Can't say I'm a big fan of XBF_BCACHE_SCAN as a name - it tells me
> > > > nothing about what the incore lookup is actually doing. The actual
> > > > lookup action that is being performed is "find any match" rather
> > > > than "find exact match". XBF_ANY_MATCH would be a better name, IMO.
> > > > 
> > > > >  	if (error)
> > > > >  		return;
> > > > >  
> > > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > > index 15d1e5a7c2d3..b31e6d09a056 100644
> > > > > --- a/fs/xfs/xfs_buf.c
> > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > @@ -481,7 +481,8 @@ _xfs_buf_obj_cmp(
> > > > >  		 * reallocating a busy extent. Skip this buffer and
> > > > >  		 * continue searching for an exact match.
> > > > >  		 */
> > > > > -		ASSERT(bp->b_flags & XBF_STALE);
> > > > > +		if (!(map->bm_flags & XBM_IGNORE_LENGTH_MISMATCH))
> > > > > +			ASSERT(bp->b_flags & XBF_STALE);
> > > > 
> > > > And this becomes XBM_ANY_MATCH, too.
> > > 
> > > Hmmm.  I've never come up with a good name for this flag.  The caller
> > > actually has a *specific* length in mind; it simply doesn't want to trip
> > > the assertions on the cached buffers that have a different length but
> > > won't be returned by *this* call.
> > > 
> > > If the buffer cache has bufs for daddr 24 len 8 and daddr len 120, the
> > > scan calls xfs_buf_get as follows:
> > > 
> > > daddr 24 len 1 (nothing)
> > > daddr 24 len 2 (nothing)
> > > ...
> > > daddr 24 len 8 (finds the first buffer)
> > > ...
> > > daddr 24 len 120 (finds the second buffer)
> > > ...
> > > daddr 24 len 132 (nothing)
> > > 
> > > I don't want the scan to ASSERT 130 times, because that muddles the
> > > output so badly that it becomes impossible to find relevant debugging
> > > messages among the crap.
> > 
> > As I mentioned in the my response to the next patch, this is an
> > O(N^2) brute force search. But how do you get two buffers at the
> > same address into the cache in the first place?
> 
> /me smacks forehead, realizes that I totally lead you astray here.
> What we're scanning for is the case that the buffer cache has two
> overlapping buffers with *different* daddrs.
> 
> (That teaches me to reply to emails while on vacation...)
> 
> xreap_agextent_binval is only called if the extent being freed is
> completely owned by the data structure and is *not* crosslinked with a
> different structure.  We've just rebuilt a data structure that was
> corrupt in some manner, but the reaper doesn't know the details of that
> corruption.  Therefore, the reaper should invalidate /all/ buffers that
> might span the extent being freed, no matter how they ended up in the
> cache.  If a deceased data structure thought it was the sole owner of a
> single fsblock of space starting at fsblock 16, we ought to look for
> buffers (daddr 128, length 1) (128, 2), ... (128, 8), (129, 1), (129, 2)
> ...  (129, 7) ... (135, 1) and invalidate all of them.

Ok, but we can't have random metadata buffers at individual daddr
offsets - except for the AG headers, every metadata buffer is
filesystem block aligned. Hence in the above example, there is no
possibility of having a metadata buffer at sectors 129-135 on a 4kB
block size filesystem.

> Concrete example:
> 
> So let's pretend that we have an xfs with fs blocksize 4k and dir
> blocksize 8k.  Let's suppose the directory's data fork maps fsblock 16,
> resulting in a buffer (daddr 128, length 16).  Let us further suppose
> the inobt then allocates fsblock 17, resulting in a buffer (daddr 136,
> length 8).  These are crosslinked.

RIght, that's an intersection of {128,16} and {136,8}. The search
region for buffer invalidation is {128, 8} {128, 16} and {136, 8}.
They are the only possible buffers that can be cached in that region
for a 4kB block size filesystem, as there can be no metadata buffers
starting at daddrs 129-135 or 137-143...

> First, we discover the inobt is crosslinked with a directory and decide
> to rebuild it.  We write out the new inobt and go to reap the old
> blocks.  Since fsblock 17 is crosslinked, we simply remove the OWN_INOBT
> rmap record and leave the buffer.
> 
> Aside: Long ago, I tried to make the reaping code invalidate buffers
> when the space is crosslinked, but I couldn't figure out how to deal
> with the situation where (say) the bmap btrees of two separate forks
> think they own the same block.  The b_ops will be the same; the buffer
> cache doesn't know about the owner field in the block header, and
> there's no way to distinguish the blocks for a data fork bmbt vs. an
> attr fork bmbt.
> 
> Next we discover that the directory is corrupt and decide to rebuild
> that.  The directory is now the only owner, so it can actually free the
> two fsb of space at startblock 16fsb.  Both buffers (128, 16) and (136,
> 8) are still in the cache, so it needs to invalidate both.
> 
> Does all /that/ make sense?

Yes, it does, and I figured that is waht you were trying to detect,
it's just the search pattern you described made no sense.

I still think needs cleaning up - it's doing a massive amount of
unnecessary work checking for things that cannot exist...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
