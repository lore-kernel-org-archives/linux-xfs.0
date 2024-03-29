Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4B464B
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 22:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711752710; cv=none; b=jcCFeD9oJCVQoAP19OWS5GmKXUqTY2Xm4xxgFLbDAshv8OCR/r35+sxU62fcdZ5tVta6k97oQ3UAHKrkRU7GaXS+8NA6lgdNcCIhrinSt2unCu556BkOmC3dv1Tvt+z1801zXhLRAFQzUuzm9+EqTEMeHNsUvH+gvFjGaQNw8Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711752710; c=relaxed/simple;
	bh=nTSzd5Fc2Tr1A80KCvasKR2efkw6UOLmoH9hUt+Z5ZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrWmYbxBvdLkx+T1m9GJ8/z3/mvtzb6kUJRDWHLRbxbz8qm+5aAkhni+Dk8EGj2689dkkTufB4+KVrTwya7SUnS9ihN65YfN3KNKbpU19nI6ZTWeQw4Hbn6V0eTosv2ql6+AEGZIyBNNAxYS+OZutrURhi93GmhRuWsfsfwS1vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QNRZpXi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QNRZpXi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7906C433C7;
	Fri, 29 Mar 2024 22:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711752710;
	bh=nTSzd5Fc2Tr1A80KCvasKR2efkw6UOLmoH9hUt+Z5ZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNRZpXi6qm7bMIG/7oalT1VtFzAOyWWNx1ZEWZVOxio9gmgYYTGKwDkW1X5BJB+8u
	 XFlTQXSNmFPcxV21hiufUuGdSG3EwdHFbFWHi579EMO+T+S7tov/n/au2fXGeTT+XK
	 z6XLzMdkgaRhFJ1WPX3SAASFOgBZL7ySLf6QBw73uRXtclwe1aYXbE0MOCMVDvqvzz
	 U4hCFswGMdcWivOAcB68TgPPwPDnxw9IY/EFHtUnv7KPI9JTHKAzH20c3LYGrYG9bd
	 ZvzGwE5IUgiPVKFADe/iDdEsr3i5W2yd0lj5awIFBCcNVGa7zgaEhemGFy2sqixC2A
	 arf4EVXXuE52g==
Date: Fri, 29 Mar 2024 15:51:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <20240329225149.GR6390@frogsfrogsfrogs>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgSaffJmGXBiXwKZ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgSaffJmGXBiXwKZ@dread.disaster.area>

On Thu, Mar 28, 2024 at 09:15:25AM +1100, Dave Chinner wrote:
> On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS issues discard IOs while holding the free space btree and the AGF
> > buffers locked.  If the discard IOs are slow, this can lead to long
> > stalls for every other thread trying to access that AG.  On a 10TB high
> > performance flash storage device with a severely fragmented free space
> > btree in every AG, this results in many threads tripping the hangcheck
> > warnings while waiting for the AGF.  This happens even after we've run
> > fstrim a few times and waited for the nvme namespace utilization
> > counters to stabilize.
> > 
> > Strace for the entire 100TB looks like:
> > ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>
> > 
> > Reducing the size of the FITRIM requests to a single AG at a time
> > produces lower times for each individual call, but even this isn't quite
> > acceptable, because the lock hold times are still high enough to cause
> > stall warnings:
> > 
> > Strace for the first 4x 1TB AGs looks like (2):
> > ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
> > ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
> > ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
> > ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>
> 
> Large FITRIM runtime is not actually an AGF locking latency problem
> anymore....
> 
> > The fstrim code has to synchronize discards with block allocations, so
> > we must hold the AGF lock while issuing discard IOs.
> 
> ... because I fixed this problem in commit 89cfa899608f ("xfs:
> reduce AGF hold times during fstrim operations").
> 
> > Breaking up the
> > calls into smaller start/len segments ought to reduce the lock hold time
> > and allow other threads a chance to make progress.  Unfortunately, the
> > current fstrim implementation handles this poorly because it walks the
> > entire free space by length index (cntbt) and it's not clear if we can
> > cycle the AGF periodically to reduce latency because there's no
> > less-than btree lookup.
> 
> That commit also fixed this problem.
> > The first solution I thought of was to limit latency by scanning parts
> > of an AG at a time,
> 
> It already does this.

Yeah.  I sent this patch to the list 10 months ago, but nobody ever
responded.  I sent it again at the end of last year, and still nothing.

I guess I forgot to update the commit message on this patch after you
fixed the AGF hold times, but there's still the problem that asking to
trim a subset of an AG causes XFS to walk the entire by-length btree
just to select out the records that actually fit within the criteria.

> > but this doesn't solve the stalling problem when the
> > free space is heavily fragmented because each sub-AG scan has to walk
> > the entire cntbt to find free space that fits within the given range.
> > In fact, this dramatically increases the runtime!  This itself is a
> > problem, because sub-AG fstrim runtime is unnecessarily high.
> 
> Ah, so this is a completely different problem to what you describe
> above.  i.e. The problem with "sub-ag" fstrim is simply that finding
> block range limited free extents is costly in terms of overall time
> and CPU usage when you do it via the by-count btree instead of the
> by-bno btree...

Yes.

> > For sub-AG scans, create a second implementation that will walk the
> > bnobt and perform the trims in block number order.  Since the cursor has
> > an obviously monotonically increasing value, it is easy to cycle the AGF
> > periodically to allow other threads to do work.  This implementation
> > avoids the worst problems of the original code, though it lacks the
> > desirable attribute of freeing the biggest chunks first.
> 
> Ok, it's fine to do a by-bno search in this case...
> 
> > On the other hand, this second implementation will be much easier to
> > constrain the locking latency, and makes it much easier to report fstrim
> > progress to anyone who's running xfs_scrub.
> 
> ... but It doesn't change the locking latency of fstrim at all.
> Locks are still only held for batches of 100 free extent lookups...
> 
> I think a commit message update is necessary. :)

xfs: fix performance problems when fstrimming a subset of a fragmented AG

On a 10TB filesystem where the free space in each AG is heavily
fragmented, I noticed some very high runtimes on a FITRIM call for the
entire filesystem.  xfs_scrub likes to report progress information on
each phase of the scrub, which means that a strace for the entire
filesystem:

ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>

shows that scrub is uncommunicative for the entire duration.  Reducing
the size of the FITRIM requests to a single AG at a time produces lower
times for each individual call, but even this isn't quite acceptable,
because the time between progress reports are still very high:

Strace for the first 4x 1TB AGs looks like (2):
ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>

I then had the idea to limit the length parameter of each call to a
smallish amount (~11GB) so that we could report progress relatively
quickly, but much to my surprise, each FITRIM call still took ~68
seconds!

Unfortunately, the by-length fstrim implementation handles this poorly
because it walks the entire free space by length index (cntbt), which is
a very inefficient way to walk a subset of the blocks of an AG.

Therefore, create a second implementation that will walk the bnobt and
perform the trims in block number order.  This implementation avoids the
worst problems of the original code, though it lacks the desirable
attribute of freeing the biggest chunks first.

On the other hand, this second implementation will be much easier to
constrain the system call latency, and makes it much easier to report
fstrim progress to anyone who's running xfs_scrub.

> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_discard.c |  172 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 169 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index 268bb734dc0a8..ee7a8759091eb 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -157,9 +157,9 @@ xfs_trim_gather_extents(
> >  	uint64_t		*blocks_trimmed)
> >  {
> >  	struct xfs_mount	*mp = pag->pag_mount;
> > -	struct xfs_trans	*tp;
> >  	struct xfs_btree_cur	*cur;
> >  	struct xfs_buf		*agbp;
> > +	struct xfs_trans	*tp;
> >  	int			error;
> >  	int			i;
> >  	int			batch = 100;
> > @@ -292,6 +292,160 @@ xfs_trim_gather_extents(
> >  	return error;
> >  }
> >  
> > +/* Trim the free space in this AG by block number. */
> > +static inline int
> > +xfs_trim_gather_bybno(
> > +	struct xfs_perag	*pag,
> > +	xfs_daddr_t		start,
> > +	xfs_daddr_t		end,
> > +	xfs_daddr_t		minlen,
> > +	struct xfs_alloc_rec_incore *tcur,
> > +	struct xfs_busy_extents	*extents,
> > +	uint64_t		*blocks_trimmed)
> > +{
> 
> I'd prefer that we don't copy-n-paste-n-subtly-modify code like
> this.  There's very little different between the two gather cases -
> the initial cursor setup and the loop exit criteria - so they should
> be easy to use a common core loop.

<nod>

> > +	struct xfs_mount	*mp = pag->pag_mount;
> > +	struct xfs_trans	*tp;
> > +	struct xfs_btree_cur	*cur;
> > +	struct xfs_buf		*agbp;
> > +	xfs_daddr_t		end_daddr;
> > +	xfs_agnumber_t		agno = pag->pag_agno;
> > +	xfs_agblock_t		start_agbno;
> > +	xfs_agblock_t		end_agbno;
> > +	xfs_extlen_t		minlen_fsb = XFS_BB_TO_FSB(mp, minlen);
> > +	int			i;
> > +	int			batch = 100;
> > +	int			error;
> > +
> > +	start = max(start, XFS_AGB_TO_DADDR(mp, agno, 0));
> > +	start_agbno = xfs_daddr_to_agbno(mp, start);
> > +
> > +	end_daddr = XFS_AGB_TO_DADDR(mp, agno, pag->block_count);
> > +	end = min(end, end_daddr - 1);
> > +	end_agbno = xfs_daddr_to_agbno(mp, end);
> 
> I think this is the wrong place to do this.  I agree that it is
> sensible to use ag-constrained agbnos here, but we should do it
> properly and not make the code unnecessarily difficult to maintain
> by using unconstrained daddrs in one gather function and constrained
> agbnos in another. 
> 
> Here's a completely untested, uncompiled version of this by-bno
> search I just wrote up to demonstrate that if we pass ag-confined
> agbnos from the top level, we don't need to duplicate this gather
> code at all or do trim range constraining inside the gather
> functions...

Mostly looks ok, but let's dig in--

> -Dave.
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 268bb734dc0a..0c949dfc097a 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -145,14 +145,18 @@ xfs_discard_extents(
>  	return error;
>  }
>  
> +struct xfs_trim_cur {
> +	xfs_agblock_t	start;
> +	xfs_extlen_t	count;
> +	xfs_agblock_t	end;
> +	xfs_extlen_t	minlen;
> +	bool		by_len;
> +};
>  
>  static int
>  xfs_trim_gather_extents(
>  	struct xfs_perag	*pag,
> -	xfs_daddr_t		start,
> -	xfs_daddr_t		end,
> -	xfs_daddr_t		minlen,
> -	struct xfs_alloc_rec_incore *tcur,
> +	struct xfs_trim_cur	*tcur,
>  	struct xfs_busy_extents	*extents,
>  	uint64_t		*blocks_trimmed)
>  {
> @@ -179,21 +183,21 @@ xfs_trim_gather_extents(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
>  
> -	/*
> -	 * Look up the extent length requested in the AGF and start with it.
> -	 */
> -	if (tcur->ar_startblock == NULLAGBLOCK)
> -		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
> -	else
> +	if (tcur->by_len) {
> +		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);

I'm confused, why are we searching the by-bno btree if "by_len" is set?
Granted the logic for setting by_len triggers only for FITRIMs of
subsets of an AG so this functions conrrectly...

> +		error = xfs_alloc_lookup_ge(cur, tcur->ar_startblock,
> +				0, &i);

...insofar as this skips a free extent that starts before and ends after
tcur->start.

> +	} else {
> +		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
>  		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
>  				tcur->ar_blockcount, &i);
> +	}

How about this initialization logic:

	if (tcur->by_bno) {
		/* sub-AG discard request always starts at tcur->start */
		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
	} else if (tcur->start == NULLAGBLOCK) {
		/* first time through a by-len starts with max length */
		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
	} else {
		/* nth time through a by-len starts where we left off */
		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
	}

>  	if (error)
>  		goto out_del_cursor;
>  	if (i == 0) {
>  		/* nothing of that length left in the AG, we are done */
> -		tcur->ar_blockcount = 0;
> +		tcur->count = 0;
>  		goto out_del_cursor;
>  	}
>  
> @@ -221,25 +225,8 @@ xfs_trim_gather_extents(
>  			 * Update the cursor to point at this extent so we
>  			 * restart the next batch from this extent.
>  			 */
> -			tcur->ar_startblock = fbno;
> -			tcur->ar_blockcount = flen;
> -			break;
> -		}
> -
> -		/*
> -		 * use daddr format for all range/len calculations as that is
> -		 * the format the range/len variables are supplied in by
> -		 * userspace.
> -		 */
> -		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
> -		dlen = XFS_FSB_TO_BB(mp, flen);
> -
> -		/*
> -		 * Too small?  Give up.
> -		 */
> -		if (dlen < minlen) {
> -			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
> -			tcur->ar_blockcount = 0;
> +			tcur->start = fbno;
> +			tcur->count = flen;
>  			break;
>  		}
>  
> @@ -248,10 +235,35 @@ xfs_trim_gather_extents(
>  		 * supposed to discard skip it.  Do not bother to trim
>  		 * down partially overlapping ranges for now.
>  		 */
> -		if (dbno + dlen < start || dbno > end) {
> +		if (fbno + flen < tcur->start) {
>  			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
>  			goto next_extent;
>  		}
> +		if (fbno > tcur->end) {
> +			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
> +			if (tcur->by_len) {
> +				tcur->count = 0;
> +				break;
> +			}
> +			goto next_extent;
> +		}
> +
> +		/* Trim the extent returned to the range we want. */
> +		if (fbno < tcur->start) {
> +			flen -= tcur->start - fbno;
> +			fbno = tcur->start;
> +		}
> +		if (fbno + flen > tcur->end + 1)
> +			flen = tcur->end - fbno + 1;
> +
> +		/*
> +		 * Too small?  Give up.
> +		 */
> +		if (flen < minlen) {
> +			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
> +			tcur->count = 0;
> +			break;
> +		}

For a by-bno search, this logic skips the entire rest of the AG after
the first free extent that's smaller than tcur->minlen.  Instead, it
should goto next_extent, yes?

>  
>  		/*
>  		 * If any blocks in the range are still busy, skip the
> @@ -266,7 +278,10 @@ xfs_trim_gather_extents(
>  				&extents->extent_list);
>  		*blocks_trimmed += flen;
>  next_extent:
> -		error = xfs_btree_decrement(cur, 0, &i);
> +		if (tcur->by_len)
> +			error = xfs_btree_increment(cur, 0, &i);
> +		else
> +			error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			break;
>  
> @@ -276,7 +291,7 @@ xfs_trim_gather_extents(
>  		 * is no more extents to search.
>  		 */
>  		if (i == 0)
> -			tcur->ar_blockcount = 0;
> +			tcur->count = 0;
>  	}
>  
>  	/*
> @@ -306,17 +321,22 @@ xfs_trim_should_stop(void)
>  static int
>  xfs_trim_extents(
>  	struct xfs_perag	*pag,
> -	xfs_daddr_t		start,
> -	xfs_daddr_t		end,
> -	xfs_daddr_t		minlen,
> +	xfs_agblock_t		start,
> +	xfs_agblock_t		end,
> +	xfs_extlen_t		minlen,
>  	uint64_t		*blocks_trimmed)
>  {
> -	struct xfs_alloc_rec_incore tcur = {
> -		.ar_blockcount = pag->pagf_longest,
> -		.ar_startblock = NULLAGBLOCK,
> +	struct xfs_trim_cur	tcur = {
> +		.start		= start,
> +		.count		= pag->pagf_longest,
> +		.end		= end,
> +		.minlen		= minlen,
>  	};
>  	int			error = 0;
>  
> +	if (start != 0 || end != pag->block_count)
> +		tcur.by_len = true;
> +
>  	do {
>  		struct xfs_busy_extents	*extents;
>  
> @@ -330,8 +350,8 @@ xfs_trim_extents(
>  		extents->owner = extents;
>  		INIT_LIST_HEAD(&extents->extent_list);
>  
> -		error = xfs_trim_gather_extents(pag, start, end, minlen,
> -				&tcur, extents, blocks_trimmed);
> +		error = xfs_trim_gather_extents(pag, &tcur, extents,
> +					blocks_trimmed);
>  		if (error) {
>  			kfree(extents);
>  			break;
> @@ -354,7 +374,7 @@ xfs_trim_extents(
>  		if (xfs_trim_should_stop())
>  			break;
>  
> -	} while (tcur.ar_blockcount != 0);
> +	} while (tcur.count != 0);
>  
>  	return error;
>  
> @@ -378,8 +398,10 @@ xfs_ioc_trim(
>  	unsigned int		granularity =
>  		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
>  	struct fstrim_range	range;
> -	xfs_daddr_t		start, end, minlen;
> +	xfs_daddr_t		start, end;
> +	xfs_extlen_t		minlen;
>  	xfs_agnumber_t		agno;
> +	xfs_agblock_t		start_agbno, end_agbno;
>  	uint64_t		blocks_trimmed = 0;
>  	int			error, last_error = 0;
>  
> @@ -399,7 +421,8 @@ xfs_ioc_trim(
>  		return -EFAULT;
>  
>  	range.minlen = max_t(u64, granularity, range.minlen);
> -	minlen = BTOBB(range.minlen);
> +	minlen = XFS_B_TO_FSB(mp, range.minlen);
> +
>  	/*
>  	 * Truncating down the len isn't actually quite correct, but using
>  	 * BBTOB would mean we trivially get overflows for values
> @@ -415,12 +438,23 @@ xfs_ioc_trim(
>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  
> -	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> -		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;

Couldn't this simply be:

	end = min_t(xfs_daddr_t, start + BTOBBT(range.len) - 1,
		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);


--D

> +	start_agno = xfs_daddr_to_agno(mp, start);
> +	start_agbno = xfs_daddr_to_agbno(mp, start);
> +	end_agno = xfs_daddr_to_agno(mp, end);
> +	end_agbno = xfs_daddr_to_agbno(mp, end);
>  
> -	agno = xfs_daddr_to_agno(mp, start);
> -	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
> -		error = xfs_trim_extents(pag, start, end, minlen,
> +	if (end_agno >= mp->m_sb.sb_agcount ||
> +	    !xfs_verify_agno_agbno(mp, end_agno, end_agbno)) {
> +		end_agno = mp->m_sb.sb_agcount - 1;
> +		end_agbno = xfs_ag_block_count(mp, end_agno);
> +	}
> +
> +	for_each_perag_range(mp, start_agno, end_agno, pag) {
> +		xfs_agblock_t end = mp->m_sb.sb_agblocks;
> +
> +		if (start_agno == end_agno)
> +			end = end_agbno;
> +		error = xfs_trim_extents(pag, start_agbno, end, minlen,
>  					  &blocks_trimmed);
>  		if (error)
>  			last_error = error;
> @@ -429,6 +463,7 @@ xfs_ioc_trim(
>  			xfs_perag_rele(pag);
>  			break;
>  		}
> +		start_agbno = 0;
>  	}
>  
>  	if (last_error)
> -- 
> Dave Chinner
> david@fromorbit.com
> 
