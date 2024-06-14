Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D82801
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 02:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718333979; cv=none; b=silSymuqEZ+sbTRWSSS4rsPB/YLIwfDcShkAUxW9EJGQEpiaxLzTBqedLjxuJmdfI6HaHCBXfCIIZsF+72yUmhpUxP1Z1xsWxVepvQR6U7zSh/YkMaRV3UeYhjVzPolhttogCdeeKR5nS9wDPznlP6XOY+OLIv5c1WUV/F/3Ze8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718333979; c=relaxed/simple;
	bh=RYRgAkeTli6p9GumHR7Pq6hgHZqz/iJKu9sEoNngKok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFtfr0/sHt5G2q2H4aLHP6EEKfVT44tNp18K1IuWFbqbersT3m3Vn2voyBY+ZScp1CMH5iY4sZQ3lD30QrmWzyPPSNvlDe6ryBUwwVm7LBA85ulskfFvbQa2TiL3rjWVxsk8trtizS3fgSDp+Suv3BMZiX167ab360V0GwQX1cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=driCXr3J; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="driCXr3J"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-6fd8506a0b2so1359391a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 19:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1718333976; x=1718938776; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tKcxURWg2RHQ6s8iToI4zjA7nvIFXhxOnYR9z5Z7AEg=;
        b=driCXr3JqyKw0LSJs3jUhC1vtJ8KacaQjGXAi5NqrCiI2eS+vpa6w3tb3FKGg5gvn+
         q6u3Y+tQ5RjmAjhT0tbl/AWqTC6B614H3EbH0Ce1WYzA0c7yVKwAXikfSt1UZQv6JSx7
         9xA0THldoY9gOVdP57csmr0mLn7+Jqp5UueWoYMHimKi2H/UQPZrO8YWp5UKHaq8qv5Z
         8n9gLM/lQfwc8J8JuJrO1mrlbmn3FvJlgaTalkMVv4akW7Sl620o0FBRYtEICe6jL57g
         XrqikfhP5o62tMlkAHvD48nKevx8OMVwnBFH4VbQ27hBlp9XRyBMGOinGrFTYBHlu5TL
         tBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718333976; x=1718938776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tKcxURWg2RHQ6s8iToI4zjA7nvIFXhxOnYR9z5Z7AEg=;
        b=BjBLTywJ9J2HcUmKtQS/xXSKjj0NN+Ja586DX5atU8fzAYqCE08G6U7Z5BcsM1S7jC
         47z31FFbzwvUEU+UIy7Llw2AqoRPnTS+rG7GBH8zxxzLtopuI/jkO6jLY2r7SGNexqY4
         8SFeygnBVMOhRzla46D6BWXxvtBC52bIhSQrOIds6DAn/pbBKE2fYrwtdfjCdLG+Z5B5
         6uoIq21Q9eUEIENCyr+cPP90QL/QXttwpGneJLFqotoTo79+St1hyvfh354A0wcNe57J
         X6POfe3gLuR/G5UgpN0h9cucKlnPSSxjAxTpZwJtXZkaJc+Z4/KDa7fhivdGlJGUnvH8
         g3tw==
X-Forwarded-Encrypted: i=1; AJvYcCUaj+oPIuZOeX27OOSQyAKkurpSLVBvSm3XkPleuHhwjTWbNLDBUeosef1iUYPb7q3HpwgaxuHSPoX2hgkNauCv/Tag6vBfr/iM
X-Gm-Message-State: AOJu0YwD1ZC2Qkz3DSb+Dow0HqxeaXwj1cvZzJJjW0EXwo2jpdHcjcKr
	2CEM0hl/3E3weufp9oUT3UA2kuqK/7s2tB0EignVIktE1QmobOTGOGAwel2gEOc=
X-Google-Smtp-Source: AGHT+IEpMF2XR2huhDSjDORFiRZHbu2UD7A+1UyxGRcREwUqoiLGC0762hxJTUrn/+SNHdLAs6s9Pw==
X-Received: by 2002:a17:90a:d685:b0:2c2:41cf:b0f0 with SMTP id 98e67ed59e1d1-2c4dbd38eaamr1565319a91.43.1718333976047;
        Thu, 13 Jun 2024 19:59:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a769bc48sm4861355a91.38.2024.06.13.19.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 19:59:35 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sHxA4-00FD1G-1K;
	Fri, 14 Jun 2024 12:59:32 +1000
Date: Fri, 14 Jun 2024 12:59:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Krister Johansen <kjlx@templeofstupid.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: resurrect the AGFL reservation
Message-ID: <ZmuyFCG/jQrrRb6N@dread.disaster.area>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dfbe8d00d2be53999b20e336641ba3d60306ffa.1718232004.git.kjlx@templeofstupid.com>

On Thu, Jun 13, 2024 at 01:27:26PM -0700, Krister Johansen wrote:
> Transactions that perform multiple allocations may inadvertently run out
> of space after the first allocation selects an AG that appears to have
> enough available space.  The problem occurs when the allocation in the
> transaction splits freespace b-trees but the second allocation does not
> have enough available space to refill the AGFL.  This results in an
> aborted transaction and a filesystem shutdown.  In this author's case,
> it's frequently encountered in the xfs_bmap_extents_to_btree path on a
> write to an AG that's almost reached its limits.
> 
> The AGFL reservation allows us to save some blocks to refill the AGFL to
> its minimum level in an Nth allocation, and to prevent allocations from
> proceeding when there's not enough reserved space to accommodate the
> refill.
> 
> This patch just brings back the reservation and does the plumbing.  The
> policy decisions about which allocations to allow will be in a
> subsequent patch.
> 
> This implementation includes space for the bnobt and cnobt in the
> reserve.  This was done largely because the AGFL reserve stubs appeared
> to already be doing it this way.
> 
> Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h          |  2 ++
>  fs/xfs/libxfs/xfs_ag_resv.c     | 54 ++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_ag_resv.h     |  4 +++
>  fs/xfs/libxfs/xfs_alloc.c       | 43 +++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_alloc.h       |  3 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c | 59 +++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.h |  5 +++
>  fs/xfs/libxfs/xfs_rmap_btree.c  |  5 +++
>  fs/xfs/scrub/fscounters.c       |  1 +
>  9 files changed, 161 insertions(+), 15 deletions(-)
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 35de09a2516c..40bff82f2b7e 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -62,6 +62,8 @@ struct xfs_perag {
>  	struct xfs_ag_resv	pag_meta_resv;
>  	/* Blocks reserved for the reverse mapping btree. */
>  	struct xfs_ag_resv	pag_rmapbt_resv;
> +	/* Blocks reserved for the AGFL. */
> +	struct xfs_ag_resv	pag_agfl_resv;

Ok, so you're creating a new pool for the AGFL refills.

....
> @@ -180,11 +188,13 @@ __xfs_ag_resv_init(
>  
>  	switch (type) {
>  	case XFS_AG_RESV_RMAPBT:
> +	case XFS_AG_RESV_AGFL:
>  		/*
> -		 * Space taken by the rmapbt is not subtracted from fdblocks
> -		 * because the rmapbt lives in the free space.  Here we must
> -		 * subtract the entire reservation from fdblocks so that we
> -		 * always have blocks available for rmapbt expansion.
> +		 * Space taken by the rmapbt and agfl are not subtracted from
> +		 * fdblocks because they both live in the free space.  Here we
> +		 * must subtract the entire reservation from fdblocks so that we
> +		 * always have blocks available for rmapbt expansion and agfl
> +		 * refilling.
>  		 */
>  		hidden_space = ask;
>  		break;

And the AGFL and RMAPBT pools have largely the same behaviour.

> @@ -299,6 +309,25 @@ xfs_ag_resv_init(
>  			has_resv = true;
>  	}
>  
> +	/* Create the AGFL reservation */
> +	if (pag->pag_agfl_resv.ar_asked == 0) {
> +		ask = used = 0;
> +
> +		error = xfs_allocbt_calc_reserves(mp, tp, pag, &ask, &used);
> +		if (error)
> +			goto out;

I think this is wrong, more below.

> +		error = xfs_alloc_agfl_calc_reserves(mp, tp, pag, &ask, &used);
> +		if (error)
> +			goto out;
> +
> +		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
> +		if (error)
> +			goto out;
> +		if (ask)
> +			has_resv = true;
> +	}
> +
>  out:
>  	/*
>  	 * Initialize the pagf if we have at least one active reservation on the
> @@ -324,7 +353,8 @@ xfs_ag_resv_init(
>  		 */
>  		if (!error &&
>  		    xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
> +		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved +
> +		    xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved >
>  		    pag->pagf_freeblks + pag->pagf_flcount)
>  			error = -ENOSPC;
>  	}

This is now quite hard to read. Perhaps a helper:

xfs_ag_reserved_space(pag)
{
	return pag->pag_meta_resv.ar_reserved +
		pag->pag_rmapbt_resv.ar_reserved +
		pag->pag_agfl_resv.ar_reserved;
}

And that can also be used in xfs_ag_resv_needed()....

> @@ -48,6 +50,8 @@ xfs_ag_resv_rmapbt_alloc(
>  
>  	args.len = 1;
>  	pag = xfs_perag_get(mp, agno);
> +	/* Transfer this reservation from the AGFL to RMAPBT */
> +	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL, NULL, 1);
>  	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
>  	xfs_perag_put(pag);
>  }

I have no idea what this is accounting for or why it needs to be
done. Comments need to explain why, not repeat what the code is
doing.

> +/*
> + * Work out how many blocks to reserve for the AGFL as well as how many are in
> + * use currently.
> + */
> +int
> +xfs_alloc_agfl_calc_reserves(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	xfs_extlen_t		*ask,
> +	xfs_extlen_t		*used)
> +{
> +	struct xfs_buf		*agbp;
> +	struct xfs_agf		*agf;
> +	xfs_extlen_t		agfl_blocks;
> +	xfs_extlen_t		list_len;
> +	int			error;
> +
> +	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
> +	if (error)
> +		return error;
> +
> +	agf = agbp->b_addr;
> +	agfl_blocks = xfs_alloc_min_freelist(mp, NULL);

Why are you passing a NULL for the perag in here? This minimum AGFL
blocks we will reserve is for single level btrees.

When we are actually doing an allocation, this calculation returns
a block count based on the current height of the btrees, and so the
actual AGFL refill size is always going to be larger than the
reserves calculated here.


> +	list_len = be32_to_cpu(agf->agf_flcount);

There is no relationship between the minimum AGFL block count and
the current number of blocks on the AGFL. The number of blocks on
the AGFL can be much larger than the minimum required to perform an
allocation (e.g. we just did a series of merges that moved lots of
blocks to the AGFL that was already at it's required size).

> +	xfs_trans_brelse(tp, agbp);
> +
> +	/*
> +	 * Reserve enough space to refill AGFL to minimum fullness if btrees are
> +	 * at maximum height.
> +	 */
> +	*ask += agfl_blocks;
> +	*used += list_len;

Hence the above calculations can result in a situation where used >
ask, and ask is not large enough for runtime AGFL reservations.

> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 6ef5ddd89600..9c20f85a459d 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -671,6 +671,65 @@ xfs_allocbt_calc_size(
>  	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
>  }
>  
> +/*
> + * Calculate the maximum alloc btree size.  This is for a single allocbt.
> + * Callers wishing to compute both the size of the bnobt and cnobt must double
> + * this result.
> + */
> +xfs_extlen_t
> +xfs_allocbt_max_size(
> +	struct xfs_mount	*mp,
> +	xfs_agblock_t		agblocks)
> +{
> +
> +	/* Don't proceed if uninitialized.  Can happen in mkfs. */
> +	if (mp->m_alloc_mxr[0] == 0)
> +		return 0;
> +
> +	return xfs_allocbt_calc_size(mp, agblocks);
> +}

So this is using a block count as the number of records in the
btree? And it's returning the number of btree blocks that would be
needed to index that number of records?

I'm not sure what you are attempting to calculate here, because...

> +/*
> + * Work out how many blocks to reserve for the bnobt and the cnobt as well as
> + * how many blocks are in use by these trees.
> + */
> +int
> +xfs_allocbt_calc_reserves(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	xfs_extlen_t		*ask,
> +	xfs_extlen_t		*used)
> +{
> +	struct xfs_buf		*agbp;
> +	struct xfs_agf		*agf;
> +	xfs_agblock_t		agblocks;
> +	xfs_extlen_t		tree_len;
> +	int			error;
> +
> +	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
> +	if (error)
> +		return error;
> +
> +	agf = agbp->b_addr;
> +	agblocks = be32_to_cpu(agf->agf_length);
> +	tree_len = be32_to_cpu(agf->agf_btreeblks);
> +	xfs_trans_brelse(tp, agbp);
> +
> +	/*
> +	 * The log is permanently allocated. The space it occupies will never be
> +	 * available for btree expansion.  Pretend the space is not there.
> +	 */
> +	if (xfs_ag_contains_log(mp, pag->pag_agno))
> +		agblocks -= mp->m_sb.sb_logblocks;
> +
> +	/* Reserve 1% of the AG or enough for one block per record per tree. */
> +	*ask += max(agblocks / 100, 2 * xfs_allocbt_max_size(mp, agblocks));
> +	*used += tree_len;
> +
> +	return error;
> +}

... this is passing the AG size into xfs_allocbt_max_size(), but the
free space btree cannot have that many records in it. If all the
blocks are free, then there will be a single contiguous free space
extent record spanning the entire space. That's definitely not what
this is calculation results in. :)

I can see why you might be trying to calculate the max number of
blocks in the btree - given worst case single block fragmentation,
half the space in the AG can be indexed by the free space btree.
That's a non-trivial number of records and a decent number of btree
blocks to index them, but even then I don't think it's a relevant
number to the AGFL reservation size.

The minimum AGFL size is tiny - it's just enough blocks to cover a
full height split of each btree that sources blocks from the AGFL.
If you point xfs_db at a filesystem and run the btheight command
with the length of the AG as the record count, you'll get an idea
of the worst case btree heights in the filesystem.

On the workstation I'm typing this one, /home is 1.8TB, has 32 AGs
and has reflink and rmap enabled. 

The worst case btree heights for both the bno and cnt btrees is 4
levels, and the rmapbt is 5 levels at worst.  Hence for any given
allocation the worst case AGFL length is going to be ~15 blocks.

Then we need to consider how many times we might have to refill the
AGFL in a series of dependent allocations that might be forced into
the same AG. i.e. the bmbt splitting during record insertion after a
data extent allocation (which I think is the only case this matters)

The bmapbt for the above filesystem has a maximum height of 4
levels. Hence the worst case "data extent + bmbt split" allocation
is going to require 1 + ((max bmbt level - 1) + 1) block allocations
from the AG. i.e. (max bmbt level + 1) AGFL refills.

Hence to guarantee that we'd never run out of blocks on an
allocation requiring worst case btree splits on all btrees
on all allocations is ~75 blocks.

So I wouldn't expect the AGFL reserve pool to be any larger than a
couple of hundred blocks in the worst case.

Which brings me to the next question: do we even need a reserve pool
for this? We know when we are doing such a dependent allocation
chain because args->minleft has to be set to ensure enough space
is left after the first allocation to allow all the remaining
allocations to succeed.

Perhaps we can to extend the minleft mechanism to indicate how many
dependent allocations are in this chain (we know the bmbt height,
too) and trigger the initial AGFL fill to handle multiple splits
when the AG reservations cause the AG to be "empty" when there's
actually still lots of free space in the AG?

Or maybe there's a simpler way? Just extend the RMAPBT reservation
slightly and use it for AGFL blocks whenever that reservation is
non-zero and causing ENOSPC for AGFL refills?

I'm not sure waht the best approach is here - even though I
suggested making use of reserve pools some time ago, looking at the
context and the maths again I'm not really sure that it is the only
(or best) approach to solving the issue...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
