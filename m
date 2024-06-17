Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0FA4689
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 00:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718669079; cv=pass; b=tKVe0ysHRMzSU6lproa8MyFPgrcFBTr8dbkjFJFuVTjRXtWPlDv8Y+rJgivolOY200g3u/P0LK4ikuzcM08AmXc9lPN64IBsg2OP6AdTPst82nnhJKV3WQQNH+DmjNIzBV5H3Nmve1JaavV2DBcHglwYZ01sUwczwSwyhsnOAo8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718669079; c=relaxed/simple;
	bh=yA71khwgiYuzF8e9MgANffFSnU9WkolvxW+qFP5+1Kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=higWPNf4Br5OvLaitFViOJkqUqSbfVaaM31Osbz6hHD+eXm8LnWf7IudgS6l5xV+oCKaX9+rjshTEyO67i6cB96yVSdrwnHp80sFcaa8WuiDOTTdJzxUrkyb7JcZzDg33ycuDrD+PdOGSC3FdHWnGvErqhxYr4PFlv8mz9V0MJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=g5lyv4n+; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="g5lyv4n+"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 777011042BD
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:47:09 +0000 (UTC)
Received: from pdx1-sub0-mail-a203.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9CC5F1042F9
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:47:08 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718668028; a=rsa-sha256;
	cv=none;
	b=P0TlEfApG+/bkQfUFBOtckCcEkwezEjIq0CvmMyHuWReHjunxN6BRXMTbeL7LQ9buaAu0R
	bkIKf+rgcl9L9ciE+7crzeWsB6k38K9kgegGPpfaEBEYVYYvnNuVIJ3mrK98Cav2mfl1B/
	cG+lu3V4X2+jZRl5L5gTk0up0V4G84YcfvAT1w1X4bWvt3Hqua+OWaubb9a8+5vfGbw2iw
	T31TTxpzBx7uka/0PGtsumBDQoy/8SIiu22feY7TJRfH7b8jVdhhP1MkjQ31GJjGqgPaDk
	PpQsUi2EJzb+qMbpHewE89fhluVPeLcn/8/AXBJ8gUYuspmJ5Y9jV4K6+qhKXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718668028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5b046GfL9niVZBnnjeZgBfTSO0WGlme6LE3IzLOPYLc=;
	b=Y5PACWGjEjQbm0rRhtg3E/HKod7+6uIsdPuO049G1BbrMlVB5GpPf8U2JIGMWxto///Jiy
	6uSTopT5ajyDpZLLtjT5znXNA22JtiYJaAobncMGn86Vxs58qej0RWpc96AIbKUbPMDg9y
	0g9x6iuUFtYoPTvDEbhlXZ9+dC8V49+O1hQPwnXW0twCRM0XI0wvwvKLo2Z80RTLDbL7FN
	M1hhxFgEGen3VtiVRisKcRTRQgo4uLFSA41DHqvqKEsgsk2t0Z4AhIbZrnQ0Ncch9M9DhS
	tukCPWGG+JK8BRr/I8zvN9pQMpXAmCDZgGUOCz/roF9cmbpvwoaXLZ1C2lXpDg==
ARC-Authentication-Results: i=1;
	rspamd-7f76976655-gbm28;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Decisive-Spicy: 0924fd8c3896bb02_1718668029415_2370764417
X-MC-Loop-Signature: 1718668029415:392774790
X-MC-Ingress-Time: 1718668029414
Received: from pdx1-sub0-mail-a203.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.110.1.198 (trex/6.9.2);
	Mon, 17 Jun 2024 23:47:09 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a203.dreamhost.com (Postfix) with ESMTPSA id 4W364D2mJ5zTR
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 16:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718668028;
	bh=5b046GfL9niVZBnnjeZgBfTSO0WGlme6LE3IzLOPYLc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=g5lyv4n+Qfr9C6U4FljcaA3vo1CZvcclWiDRDtz50GD7Lt0Nmdl117JyATRAeZ9Zh
	 u9I9xnJI7ouibNIsbJqUueiLNRhhCux13oV81vSQ63aq1kWakfPCjf310ylXQ03CGx
	 rT6NeZ7tCVyk7pMRLoH+GX6OZA+u4xepS8ei/zeRsH2nqpNWT10oFx/ox9bkcWBfj7
	 cHyXWin6N4yRcpaD6GJN6DTGkj50EIqJrkzdKET0pw8uEkAthKEq7jW0x6rYD2vS0X
	 xm5XLc8KZTuny5nFNI3yEc6f6Deeunhdb97y46UcOaOHCceKwM9fVqjKe9PhKxOKHI
	 rdIdRV13CrV5w==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e002c
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Mon, 17 Jun 2024 16:46:31 -0700
Date: Mon, 17 Jun 2024 16:46:31 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <20240617234631.GC2044@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
 <ZmuyFCG/jQrrRb6N@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmuyFCG/jQrrRb6N@dread.disaster.area>

On Fri, Jun 14, 2024 at 12:59:32PM +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2024 at 01:27:26PM -0700, Krister Johansen wrote:
> > Transactions that perform multiple allocations may inadvertently run out
> > of space after the first allocation selects an AG that appears to have
> > enough available space.  The problem occurs when the allocation in the
> > transaction splits freespace b-trees but the second allocation does not
> > have enough available space to refill the AGFL.  This results in an
> > aborted transaction and a filesystem shutdown.  In this author's case,
> > it's frequently encountered in the xfs_bmap_extents_to_btree path on a
> > write to an AG that's almost reached its limits.
> > 
> > The AGFL reservation allows us to save some blocks to refill the AGFL to
> > its minimum level in an Nth allocation, and to prevent allocations from
> > proceeding when there's not enough reserved space to accommodate the
> > refill.
> > 
> > This patch just brings back the reservation and does the plumbing.  The
> > policy decisions about which allocations to allow will be in a
> > subsequent patch.
> > 
> > This implementation includes space for the bnobt and cnobt in the
> > reserve.  This was done largely because the AGFL reserve stubs appeared
> > to already be doing it this way.
> > 
> > Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.h          |  2 ++
> >  fs/xfs/libxfs/xfs_ag_resv.c     | 54 ++++++++++++++++++++++--------
> >  fs/xfs/libxfs/xfs_ag_resv.h     |  4 +++
> >  fs/xfs/libxfs/xfs_alloc.c       | 43 +++++++++++++++++++++++-
> >  fs/xfs/libxfs/xfs_alloc.h       |  3 +-
> >  fs/xfs/libxfs/xfs_alloc_btree.c | 59 +++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_alloc_btree.h |  5 +++
> >  fs/xfs/libxfs/xfs_rmap_btree.c  |  5 +++
> >  fs/xfs/scrub/fscounters.c       |  1 +
> >  9 files changed, 161 insertions(+), 15 deletions(-)
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 35de09a2516c..40bff82f2b7e 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -62,6 +62,8 @@ struct xfs_perag {
> >  	struct xfs_ag_resv	pag_meta_resv;
> >  	/* Blocks reserved for the reverse mapping btree. */
> >  	struct xfs_ag_resv	pag_rmapbt_resv;
> > +	/* Blocks reserved for the AGFL. */
> > +	struct xfs_ag_resv	pag_agfl_resv;
> 
> Ok, so you're creating a new pool for the AGFL refills.

Sorry, I should have been clearer about what I was trying to do.  When I
reviewed the patches[1] that created the rmapbt reservation, it looked
like part of the justification for that work was that blocks from the
agfl moving to other data structures, like the rmapbt, caused accounting
inconsistencies.  I worried that if I just accounted for the AGFL blocks
without also trying to track the agfl blocks in use by the bnobt and the
cnobt then I'd be re-creating a problem similar to what the previous
patch had tried to fix.

After reading the rest of your comments, it sounds like I didn't get
this right and we should probably discuss which approach is best to
take.

> > @@ -48,6 +50,8 @@ xfs_ag_resv_rmapbt_alloc(
> >  
> >  	args.len = 1;
> >  	pag = xfs_perag_get(mp, agno);
> > +	/* Transfer this reservation from the AGFL to RMAPBT */
> > +	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL, NULL, 1);
> >  	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
> >  	xfs_perag_put(pag);
> >  }
> 
> I have no idea what this is accounting for or why it needs to be
> done. Comments need to explain why, not repeat what the code is
> doing.

Thanks, would something along the lines of the following been better?

/*
 *
 * The rmapbt has its own reservation separate from the AGFL.  In cases
 * where an agfl block is destined for use in the rmapbt, ensure that it
 * is counted against the rmapbt reservation instead of the agfl's.
 */

> > +/*
> > + * Work out how many blocks to reserve for the AGFL as well as how many are in
> > + * use currently.
> > + */
> > +int
> > +xfs_alloc_agfl_calc_reserves(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	struct xfs_perag	*pag,
> > +	xfs_extlen_t		*ask,
> > +	xfs_extlen_t		*used)
> > +{
> > +	struct xfs_buf		*agbp;
> > +	struct xfs_agf		*agf;
> > +	xfs_extlen_t		agfl_blocks;
> > +	xfs_extlen_t		list_len;
> > +	int			error;
> > +
> > +	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
> > +	if (error)
> > +		return error;
> > +
> > +	agf = agbp->b_addr;
> > +	agfl_blocks = xfs_alloc_min_freelist(mp, NULL);
> 
> Why are you passing a NULL for the perag in here? This minimum AGFL
> blocks we will reserve is for single level btrees.

Thanks for catching this.  I let myself get fooled by the comment at the
top that said, "If @pag is NULL, return the largest possible minimum
length" which was what I thought I wanted.

> When we are actually doing an allocation, this calculation returns
> a block count based on the current height of the btrees, and so the
> actual AGFL refill size is always going to be larger than the
> reserves calculated here.
> 
> 
> > +	list_len = be32_to_cpu(agf->agf_flcount);
> 
> There is no relationship between the minimum AGFL block count and
> the current number of blocks on the AGFL. The number of blocks on
> the AGFL can be much larger than the minimum required to perform an
> allocation (e.g. we just did a series of merges that moved lots of
> blocks to the AGFL that was already at it's required size).
> 
> > +	xfs_trans_brelse(tp, agbp);
> > +
> > +	/*
> > +	 * Reserve enough space to refill AGFL to minimum fullness if btrees are
> > +	 * at maximum height.
> > +	 */
> > +	*ask += agfl_blocks;
> > +	*used += list_len;
> 
> Hence the above calculations can result in a situation where used >
> ask, and ask is not large enough for runtime AGFL reservations.

It sounds like I need to work out some tests that involve generating a
really full agfl and/or free-space trees without the change and then
trying to use those with the change.

> > diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> > index 6ef5ddd89600..9c20f85a459d 100644
> > --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> > @@ -671,6 +671,65 @@ xfs_allocbt_calc_size(
> >  	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
> >  }
> >  
> > +/*
> > + * Calculate the maximum alloc btree size.  This is for a single allocbt.
> > + * Callers wishing to compute both the size of the bnobt and cnobt must double
> > + * this result.
> > + */
> > +xfs_extlen_t
> > +xfs_allocbt_max_size(
> > +	struct xfs_mount	*mp,
> > +	xfs_agblock_t		agblocks)
> > +{
> > +
> > +	/* Don't proceed if uninitialized.  Can happen in mkfs. */
> > +	if (mp->m_alloc_mxr[0] == 0)
> > +		return 0;
> > +
> > +	return xfs_allocbt_calc_size(mp, agblocks);
> > +}
> 
> So this is using a block count as the number of records in the
> btree? And it's returning the number of btree blocks that would be
> needed to index that number of records?
> 
> I'm not sure what you are attempting to calculate here, because...
> 
> > +/*
> > + * Work out how many blocks to reserve for the bnobt and the cnobt as well as
> > + * how many blocks are in use by these trees.
> > + */
> > +int
> > +xfs_allocbt_calc_reserves(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,
> > +	struct xfs_perag	*pag,
> > +	xfs_extlen_t		*ask,
> > +	xfs_extlen_t		*used)
> > +{
> > +	struct xfs_buf		*agbp;
> > +	struct xfs_agf		*agf;
> > +	xfs_agblock_t		agblocks;
> > +	xfs_extlen_t		tree_len;
> > +	int			error;
> > +
> > +	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
> > +	if (error)
> > +		return error;
> > +
> > +	agf = agbp->b_addr;
> > +	agblocks = be32_to_cpu(agf->agf_length);
> > +	tree_len = be32_to_cpu(agf->agf_btreeblks);
> > +	xfs_trans_brelse(tp, agbp);
> > +
> > +	/*
> > +	 * The log is permanently allocated. The space it occupies will never be
> > +	 * available for btree expansion.  Pretend the space is not there.
> > +	 */
> > +	if (xfs_ag_contains_log(mp, pag->pag_agno))
> > +		agblocks -= mp->m_sb.sb_logblocks;
> > +
> > +	/* Reserve 1% of the AG or enough for one block per record per tree. */
> > +	*ask += max(agblocks / 100, 2 * xfs_allocbt_max_size(mp, agblocks));
> > +	*used += tree_len;
> > +
> > +	return error;
> > +}
> 
> ... this is passing the AG size into xfs_allocbt_max_size(), but the
> free space btree cannot have that many records in it. If all the
> blocks are free, then there will be a single contiguous free space
> extent record spanning the entire space. That's definitely not what
> this is calculation results in. :)
>
> I can see why you might be trying to calculate the max number of
> blocks in the btree - given worst case single block fragmentation,
> half the space in the AG can be indexed by the free space btree.
> That's a non-trivial number of records and a decent number of btree
> blocks to index them, but even then I don't think it's a relevant
> number to the AGFL reservation size.
>
> The minimum AGFL size is tiny - it's just enough blocks to cover a
> full height split of each btree that sources blocks from the AGFL.
> If you point xfs_db at a filesystem and run the btheight command
> with the length of the AG as the record count, you'll get an idea
> of the worst case btree heights in the filesystem.
> 
> On the workstation I'm typing this one, /home is 1.8TB, has 32 AGs
> and has reflink and rmap enabled. 
> 
> The worst case btree heights for both the bno and cnt btrees is 4
> levels, and the rmapbt is 5 levels at worst.  Hence for any given
> allocation the worst case AGFL length is going to be ~15 blocks.
> 
> Then we need to consider how many times we might have to refill the
> AGFL in a series of dependent allocations that might be forced into
> the same AG. i.e. the bmbt splitting during record insertion after a
> data extent allocation (which I think is the only case this matters)
> 
> The bmapbt for the above filesystem has a maximum height of 4
> levels. Hence the worst case "data extent + bmbt split" allocation
> is going to require 1 + ((max bmbt level - 1) + 1) block allocations
> from the AG. i.e. (max bmbt level + 1) AGFL refills.
> 
> Hence to guarantee that we'd never run out of blocks on an
> allocation requiring worst case btree splits on all btrees
> on all allocations is ~75 blocks.

Just to make certain I understand, for each allocation the correct way
to calculate the AGFL refill size would be to use the formula in
xfs_alloc_min_freelist(), and assume that in the worst-case the level
increments each time?

> So I wouldn't expect the AGFL reserve pool to be any larger than a
> couple of hundred blocks in the worst case.
> 
> Which brings me to the next question: do we even need a reserve pool
> for this? We know when we are doing such a dependent allocation
> chain because args->minleft has to be set to ensure enough space
> is left after the first allocation to allow all the remaining
> allocations to succeed.
> 
> Perhaps we can to extend the minleft mechanism to indicate how many
> dependent allocations are in this chain (we know the bmbt height,
> too) and trigger the initial AGFL fill to handle multiple splits
> when the AG reservations cause the AG to be "empty" when there's
> actually still lots of free space in the AG?
> 
> Or maybe there's a simpler way? Just extend the RMAPBT reservation
> slightly and use it for AGFL blocks whenever that reservation is
> non-zero and causing ENOSPC for AGFL refills?
> 
> I'm not sure waht the best approach is here - even though I
> suggested making use of reserve pools some time ago, looking at the
> context and the maths again I'm not really sure that it is the only
> (or best) approach to solving the issue...

I'd be happy to explore some of these alternate approaches.

One approach that I tried before the agfl reserved pool was to work out
how much space would be needed for the next agfl refill by allowing
xfs_alloc_min_freelist to tell me the need at level n+1.  From there, I
required minleft > 0 allocations to have that additional space
available.  It seemed like it was working, but broke the stripe
alignment tests in generic/336.  The case where that test selects a
really large extent size was failing because it was falling back to a
minleft allocation and not getting proper stripe alignment.

This was because I was effectively reserving additional space, but not
subtracting that space from m_ag_max_usable.  The ag_resv code already
does this, so I wondered if I might be acting like I was smarter than
the experts and should try following the advice that was given.

Let me try to summarize and make a few of these proposals more concrete
and then we can discuss the tradeoffs.

Based upon previous discussions, I was under the impression that a
correct solution should maintain the following invariant:

   xfs_alloc_fix_freelist() should not select an AG for which there
   is not enough space to satisfy all of the allocations in the
   transaction.

I had pedantically turned that into a pair of checks:

a. Validate that enough space exists to satisfy the transaction at the
time the AG for the first allocation is selected.

b. Take additional steps in subsequent allocations in the same
transaction to ensure available space could be used.

The absolutely _most_ simplistic approach I can think of is the
following.

1. Allow AGFL refills to ignore the reservation if we're close to ENOSPC
and are performing a subsequent allocation in a transaction.

I think you originally suggested this idea[2] in the previous discussion.
It's a simplistic solution, and doesn't check ahead of time that enough
blocks are available to meet the demand.  However, in all of the cases
where I've run into this problem, the filesystems that hit this case had
substantially more than 75 blocks (approx 20x more) in the reserve, and
were only doing a single bmbt, bnobt, and cnobt split.  (Only short 8
blocks).

If the reserved block counter doesn't change as a result of
the "borrowing" of these blocks, then subsequent allocation attempts
will correctly get ENOSPC on that AG.  Essentially,
xfs_alloc_space_available might let one of these through, but it's
unlikely to let any more through since the available count will now
always be less than the reserved count after one of these borrow edge
cases occurs.

2. Modify minleft to account for dependent allocations

Turn minleft into something like:

   union xfs_minleft {
   	xfs_extlen_t blocksleft;
	unsigned int ndepallocs;
   };

AFAICS, xfs_bmapi_minleft() handles this calculation for bmap
allocations which just leaves the ialloc code using blocksleft as the
original minfree.  The code in xfs_alloc_space_available would need to
know how to turn ndepallocs into a number of blocks, and then there's
some tracepoint code to touch up.

The ialloc code sets owner info that we might be able to use later to
determine whether to use blocksleft or ndepallocs, provided it's
acceptable to rely on the field for that.

This is appealing because it would let the allocation path perform one
allocation to fill the AGFL instead of multiple, and we'd know up front
whether we could get all the space needed for the transaction or not.

The downside might be having to adjust the freelist length more
frequently if we need to subsequently shrink it, or partially fill, hit
an error, and then have to cleanup.  The AGF modifications needed to be
journaled so there might be additional overhead from that path.

3. Extend the RMAPBT reservation

Older filesystems don't default to having rmapbt enabled so they may not
benefit from this adjustment.  If we could extend both reservations that
might be a compromise solution.

It seems like this solution would still want to look at the filesystem
gemoetry and use that to make an estimate of how many additional blocks
to reserve.  That starts to look like the first step in creating a
separate AGFL reservation which leaves...

4. Implement a less ambitious AGFL reserve

The draft in this thread tried to track all AGFL blocks from their
allocation and continued to account for them during their lifetime in
the bnobt and cnobt.  Instead of trying to build a reserve for all free
space management blocks that aren't rmapbt, reduce the scope of the AGFL
reserve to be just the number of blocks needed to satsify a single
transaction with multiple allocations that occurs close to an AG's
ENOSPC.

Blocks would be subtracted from used on agfl block free, if used were
non zero.  Blocks would be added to used on agfl block allocation if a
non-reserve alloction failed to obtain the requested number of blocks.
The wanted size could be determined using the same calculation described
earlier: calculate the maximum number of bmbt splits in a transaction
and add up the worst-case number of blocks for each split.

The one part I'm not quite sure how to work out is how to re-derive the
amount of the AGFL reserve that's been taken and is currently in use on a
subsequent mount of the filesystem.  I think option #3 suffers from this
problem as well.  IOW, is there a sneaky way to re-compute this without
having to add another field to the on-disk AGF?

Do any of these approaches stand out as clearly better (or worse) to
you?

Thanks again for taking the time to read through these patches and
provide feedback.  I appreciate all the comments, ideas, and
explanations.

-K

[1] https://lore.kernel.org/linux-xfs/20180205174601.51574-5-bfoster@redhat.com/
[2] https://lore.kernel.org/linux-xfs/20221116025106.GB3600936@dread.disaster.area/
