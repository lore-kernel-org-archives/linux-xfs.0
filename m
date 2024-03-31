Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E69757EF
	for <linux-xfs@vger.kernel.org>; Sun, 31 Mar 2024 22:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711925086; cv=none; b=OJn/m/r0aCw9wrgk0YdGSkUza6eegVLT6YGPxsk39+dD4m6pzxw99otZPo4MszJFkjbnDDuKNlYdV5T2L9U5WFe92U5KOd2iJUdiY3Fm4+yJ9aqseu5Dio6Evxfq4HzbCsOw5E1LLq+atdL9/yRCiKd/T372YdP/tk+P4E2fcAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711925086; c=relaxed/simple;
	bh=lmBPPsSOBHQa5Gb3gYxXjGQR2181bzIHkfdrl7JXH6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TIS5O7zWcUt6rqeYKdMOOM52mOd8TuI5BtV+dm86ilTWkooSzU94E+cKLeuBo5P4/Gbwj6p5bfWEJYIMjFrpwaxw/Ze5D/Z2KQ3U6dr3Rz0DweYfmQCs31RteNCzHKy+ZCHE1dC8yr6e20wU617b4vla14V6dq3cXW2ZEaOqs4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GH1mLDP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GH1mLDP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8D8C433F1;
	Sun, 31 Mar 2024 22:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711925086;
	bh=lmBPPsSOBHQa5Gb3gYxXjGQR2181bzIHkfdrl7JXH6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GH1mLDP9E8ypLn8hvUBiDpju3x9ZL19y0bh1X5n8Yd97bpQuj4hawJ3pB5seo2NJY
	 sK38gRsxL5aiwyug6QUH1TCS02i85igloowxyeBzvO3yx/WDfmrQF/qRt8PzGxGAen
	 FAAK9hSAQiX3Hth6ZwSQIP+mw0R3+1EVd1Ew69wjTASoIq6KS6mRc0+p3WFA/patJM
	 W7P07awKlIW+kOy/rAtosjabcFzIjIs8Bb6svVDBV69aJsyURy5dNgBdKYCkyXp2p5
	 iPoQtGXAiUsDvUFjPPi9DeDj3dnlKGo+ODXj4xlfdjcYdwLDx77StQYPwWcISdC+jd
	 jI4gQajwqaddg==
Date: Sun, 31 Mar 2024 15:44:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <20240331224445.GX6390@frogsfrogsfrogs>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
 <ZgSaffJmGXBiXwKZ@dread.disaster.area>
 <20240329225149.GR6390@frogsfrogsfrogs>
 <ZgiJWxVcVwag0fIP@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgiJWxVcVwag0fIP@dread.disaster.area>

On Sun, Mar 31, 2024 at 08:51:23AM +1100, Dave Chinner wrote:
> On Fri, Mar 29, 2024 at 03:51:49PM -0700, Darrick J. Wong wrote:
> > On Thu, Mar 28, 2024 at 09:15:25AM +1100, Dave Chinner wrote:
> > > On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> ....
> > > I think a commit message update is necessary. :)
> > 
> > xfs: fix performance problems when fstrimming a subset of a fragmented AG
> > 
> > On a 10TB filesystem where the free space in each AG is heavily
> > fragmented, I noticed some very high runtimes on a FITRIM call for the
> > entire filesystem.  xfs_scrub likes to report progress information on
> > each phase of the scrub, which means that a strace for the entire
> > filesystem:
> > 
> > ioctl(3, FITRIM, {start=0x0, len=10995116277760, minlen=0}) = 0 <686.209839>
> > 
> > shows that scrub is uncommunicative for the entire duration.  Reducing
> > the size of the FITRIM requests to a single AG at a time produces lower
> > times for each individual call, but even this isn't quite acceptable,
> > because the time between progress reports are still very high:
> > 
> > Strace for the first 4x 1TB AGs looks like (2):
> > ioctl(3, FITRIM, {start=0x0, len=1099511627776, minlen=0}) = 0 <68.352033>
> > ioctl(3, FITRIM, {start=0x10000000000, len=1099511627776, minlen=0}) = 0 <68.760323>
> > ioctl(3, FITRIM, {start=0x20000000000, len=1099511627776, minlen=0}) = 0 <67.235226>
> > ioctl(3, FITRIM, {start=0x30000000000, len=1099511627776, minlen=0}) = 0 <69.465744>
> > 
> > I then had the idea to limit the length parameter of each call to a
> > smallish amount (~11GB) so that we could report progress relatively
> > quickly, but much to my surprise, each FITRIM call still took ~68
> > seconds!
> > 
> > Unfortunately, the by-length fstrim implementation handles this poorly
> > because it walks the entire free space by length index (cntbt), which is
> > a very inefficient way to walk a subset of the blocks of an AG.
> > 
> > Therefore, create a second implementation that will walk the bnobt and
> > perform the trims in block number order.  This implementation avoids the
> > worst problems of the original code, though it lacks the desirable
> > attribute of freeing the biggest chunks first.
> > 
> > On the other hand, this second implementation will be much easier to
> > constrain the system call latency, and makes it much easier to report
> > fstrim progress to anyone who's running xfs_scrub.
> 
> Much better :)
> 
> > > Here's a completely untested, uncompiled version of this by-bno
> > > search I just wrote up to demonstrate that if we pass ag-confined
> > > agbnos from the top level, we don't need to duplicate this gather
> > > code at all or do trim range constraining inside the gather
> > > functions...
> > 
> > Mostly looks ok, but let's dig in--
> > 
> > > -Dave.
> > > 
> > > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > > index 268bb734dc0a..0c949dfc097a 100644
> > > --- a/fs/xfs/xfs_discard.c
> > > +++ b/fs/xfs/xfs_discard.c
> > > @@ -145,14 +145,18 @@ xfs_discard_extents(
> > >  	return error;
> > >  }
> > >  
> > > +struct xfs_trim_cur {
> > > +	xfs_agblock_t	start;
> > > +	xfs_extlen_t	count;
> > > +	xfs_agblock_t	end;
> > > +	xfs_extlen_t	minlen;
> > > +	bool		by_len;
> > > +};
> > >  
> > >  static int
> > >  xfs_trim_gather_extents(
> > >  	struct xfs_perag	*pag,
> > > -	xfs_daddr_t		start,
> > > -	xfs_daddr_t		end,
> > > -	xfs_daddr_t		minlen,
> > > -	struct xfs_alloc_rec_incore *tcur,
> > > +	struct xfs_trim_cur	*tcur,
> > >  	struct xfs_busy_extents	*extents,
> > >  	uint64_t		*blocks_trimmed)
> > >  {
> > > @@ -179,21 +183,21 @@ xfs_trim_gather_extents(
> > >  	if (error)
> > >  		goto out_trans_cancel;
> > >  
> > > -	cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> > >  
> > > -	/*
> > > -	 * Look up the extent length requested in the AGF and start with it.
> > > -	 */
> > > -	if (tcur->ar_startblock == NULLAGBLOCK)
> > > -		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
> > > -	else
> > > +	if (tcur->by_len) {
> > > +		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
> > 
> > I'm confused, why are we searching the by-bno btree if "by_len" is set?
> 
> Because I changed the logic half way through writing it and forgot
> to change the variable name....
> 
> > Granted the logic for setting by_len triggers only for FITRIMs of
> > subsets of an AG so this functions conrrectly...
> > 
> > > +		error = xfs_alloc_lookup_ge(cur, tcur->ar_startblock,
> > > +				0, &i);
> > 
> > ...insofar as this skips a free extent that starts before and ends after
> > tcur->start.
> 
> Right - did I mention this wasn't even compiled? :)
> 
> > 
> > > +	} else {
> > > +		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> > >  		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
> > >  				tcur->ar_blockcount, &i);
> > > +	}
> > 
> > How about this initialization logic:
> > 
> > 	if (tcur->by_bno) {
> > 		/* sub-AG discard request always starts at tcur->start */
> > 		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
> > 		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
> 
> OK.
> 
> > 	} else if (tcur->start == NULLAGBLOCK) {
> > 		/* first time through a by-len starts with max length */
> > 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> > 		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
> > 	} else {
> > 		/* nth time through a by-len starts where we left off */
> > 		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
> > 		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
> > 	}
> 
> ... but that is what I was explicilty trying to avoid because the
> initial search on a by-count config is for tcur->count =
> pag->pagf_longest.
> 
> IOWs, there is no "greater" sized free extent than tcur->count,
> every free extent *must* be less than or equal to pag->pagf_longest.
> The _ge() search is done because the start block of zero is less
> than every agbno in the tree. Hence we have to do a _ge() search to
> "find" the pag->pagf_longest extent based on start block criteria.
> 
> If we pass in a tcur->start = NULLAGBLOCK (0xffffffff) or
> pag->pag_blocks then every agbno is "less than" the start block, and
> so it should return the extent at the right most edge of the tree
> with a _le() search regardless of where in the AG it is located.
> 
> Hence the initial search can also be a _le() search and we don't
> have to special case it - the by-count tree has two components in
> it's search key and if we set the initial values of both components
> correctly one search works for all cases...
> 
> > > @@ -248,10 +235,35 @@ xfs_trim_gather_extents(
> > >  		 * supposed to discard skip it.  Do not bother to trim
> > >  		 * down partially overlapping ranges for now.
> > >  		 */
> > > -		if (dbno + dlen < start || dbno > end) {
> > > +		if (fbno + flen < tcur->start) {
> > >  			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
> > >  			goto next_extent;
> > >  		}
> > > +		if (fbno > tcur->end) {
> > > +			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
> > > +			if (tcur->by_len) {
> > > +				tcur->count = 0;
> > > +				break;
> > > +			}
> > > +			goto next_extent;
> > > +		}
> > > +
> > > +		/* Trim the extent returned to the range we want. */
> > > +		if (fbno < tcur->start) {
> > > +			flen -= tcur->start - fbno;
> > > +			fbno = tcur->start;
> > > +		}
> > > +		if (fbno + flen > tcur->end + 1)
> > > +			flen = tcur->end - fbno + 1;
> > > +
> > > +		/*
> > > +		 * Too small?  Give up.
> > > +		 */
> > > +		if (flen < minlen) {
> > > +			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
> > > +			tcur->count = 0;
> > > +			break;
> > > +		}
> > 
> > For a by-bno search, this logic skips the entire rest of the AG after
> > the first free extent that's smaller than tcur->minlen.  Instead, it
> > should goto next_extent, yes?
> 
> Yes.
> 
> > > @@ -415,12 +438,23 @@ xfs_ioc_trim(
> > >  	start = BTOBB(range.start);
> > >  	end = start + BTOBBT(range.len) - 1;
> > >  
> > > -	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> > > -		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
> > 
> > Couldn't this simply be:
> > 
> > 	end = min_t(xfs_daddr_t, start + BTOBBT(range.len) - 1,
> > 		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1);
> 
> Yes.

How's this for a replacement patch, then?

--D

Subject: xfs: fix performance problems when fstrimming a subset of a fragmented AG

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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_discard.c |  153 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 93 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 268bb734dc0a8..25fe3b932b5a6 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -145,14 +145,18 @@ xfs_discard_extents(
 	return error;
 }
 
+struct xfs_trim_cur {
+	xfs_agblock_t	start;
+	xfs_extlen_t	count;
+	xfs_agblock_t	end;
+	xfs_extlen_t	minlen;
+	bool		by_bno;
+};
 
 static int
 xfs_trim_gather_extents(
 	struct xfs_perag	*pag,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
-	struct xfs_alloc_rec_incore *tcur,
+	struct xfs_trim_cur	*tcur,
 	struct xfs_busy_extents	*extents,
 	uint64_t		*blocks_trimmed)
 {
@@ -179,21 +183,26 @@ xfs_trim_gather_extents(
 	if (error)
 		goto out_trans_cancel;
 
-	cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
-
-	/*
-	 * Look up the extent length requested in the AGF and start with it.
-	 */
-	if (tcur->ar_startblock == NULLAGBLOCK)
-		error = xfs_alloc_lookup_ge(cur, 0, tcur->ar_blockcount, &i);
-	else
-		error = xfs_alloc_lookup_le(cur, tcur->ar_startblock,
-				tcur->ar_blockcount, &i);
+	if (tcur->by_bno) {
+		/* sub-AG discard request always starts at tcur->start */
+		cur = xfs_bnobt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_le(cur, tcur->start, 0, &i);
+		if (!error && !i)
+			error = xfs_alloc_lookup_ge(cur, tcur->start, 0, &i);
+	} else if (tcur->start == 0) {
+		/* first time through a by-len starts with max length */
+		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_ge(cur, 0, tcur->count, &i);
+	} else {
+		/* nth time through a by-len starts where we left off */
+		cur = xfs_cntbt_init_cursor(mp, tp, agbp, pag);
+		error = xfs_alloc_lookup_le(cur, tcur->start, tcur->count, &i);
+	}
 	if (error)
 		goto out_del_cursor;
 	if (i == 0) {
 		/* nothing of that length left in the AG, we are done */
-		tcur->ar_blockcount = 0;
+		tcur->count = 0;
 		goto out_del_cursor;
 	}
 
@@ -204,8 +213,6 @@ xfs_trim_gather_extents(
 	while (i) {
 		xfs_agblock_t	fbno;
 		xfs_extlen_t	flen;
-		xfs_daddr_t	dbno;
-		xfs_extlen_t	dlen;
 
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
@@ -221,37 +228,45 @@ xfs_trim_gather_extents(
 			 * Update the cursor to point at this extent so we
 			 * restart the next batch from this extent.
 			 */
-			tcur->ar_startblock = fbno;
-			tcur->ar_blockcount = flen;
-			break;
-		}
-
-		/*
-		 * use daddr format for all range/len calculations as that is
-		 * the format the range/len variables are supplied in by
-		 * userspace.
-		 */
-		dbno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, fbno);
-		dlen = XFS_FSB_TO_BB(mp, flen);
-
-		/*
-		 * Too small?  Give up.
-		 */
-		if (dlen < minlen) {
-			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
-			tcur->ar_blockcount = 0;
+			tcur->start = fbno;
+			tcur->count = flen;
 			break;
 		}
 
 		/*
 		 * If the extent is entirely outside of the range we are
-		 * supposed to discard skip it.  Do not bother to trim
-		 * down partially overlapping ranges for now.
+		 * supposed to skip it.  Do not bother to trim down partially
+		 * overlapping ranges for now.
 		 */
-		if (dbno + dlen < start || dbno > end) {
+		if (fbno + flen < tcur->start) {
 			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
 			goto next_extent;
 		}
+		if (fbno > tcur->end) {
+			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
+			if (tcur->by_bno) {
+				tcur->count = 0;
+				break;
+			}
+			goto next_extent;
+		}
+
+		/* Trim the extent returned to the range we want. */
+		if (fbno < tcur->start) {
+			flen -= tcur->start - fbno;
+			fbno = tcur->start;
+		}
+		if (fbno + flen > tcur->end + 1)
+			flen = tcur->end - fbno + 1;
+
+		/* Too small?  Give up. */
+		if (flen < tcur->minlen) {
+			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			if (tcur->by_bno)
+				goto next_extent;
+			tcur->count = 0;
+			break;
+		}
 
 		/*
 		 * If any blocks in the range are still busy, skip the
@@ -266,7 +281,10 @@ xfs_trim_gather_extents(
 				&extents->extent_list);
 		*blocks_trimmed += flen;
 next_extent:
-		error = xfs_btree_decrement(cur, 0, &i);
+		if (tcur->by_bno)
+			error = xfs_btree_increment(cur, 0, &i);
+		else
+			error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			break;
 
@@ -276,7 +294,7 @@ xfs_trim_gather_extents(
 		 * is no more extents to search.
 		 */
 		if (i == 0)
-			tcur->ar_blockcount = 0;
+			tcur->count = 0;
 	}
 
 	/*
@@ -306,17 +324,22 @@ xfs_trim_should_stop(void)
 static int
 xfs_trim_extents(
 	struct xfs_perag	*pag,
-	xfs_daddr_t		start,
-	xfs_daddr_t		end,
-	xfs_daddr_t		minlen,
+	xfs_agblock_t		start,
+	xfs_agblock_t		end,
+	xfs_extlen_t		minlen,
 	uint64_t		*blocks_trimmed)
 {
-	struct xfs_alloc_rec_incore tcur = {
-		.ar_blockcount = pag->pagf_longest,
-		.ar_startblock = NULLAGBLOCK,
+	struct xfs_trim_cur	tcur = {
+		.start		= start,
+		.count		= pag->pagf_longest,
+		.end		= end,
+		.minlen		= minlen,
 	};
 	int			error = 0;
 
+	if (start != 0 || end != pag->block_count)
+		tcur.by_bno = true;
+
 	do {
 		struct xfs_busy_extents	*extents;
 
@@ -330,8 +353,8 @@ xfs_trim_extents(
 		extents->owner = extents;
 		INIT_LIST_HEAD(&extents->extent_list);
 
-		error = xfs_trim_gather_extents(pag, start, end, minlen,
-				&tcur, extents, blocks_trimmed);
+		error = xfs_trim_gather_extents(pag, &tcur, extents,
+				blocks_trimmed);
 		if (error) {
 			kfree(extents);
 			break;
@@ -354,7 +377,7 @@ xfs_trim_extents(
 		if (xfs_trim_should_stop())
 			break;
 
-	} while (tcur.ar_blockcount != 0);
+	} while (tcur.count != 0);
 
 	return error;
 
@@ -378,8 +401,10 @@ xfs_ioc_trim(
 	unsigned int		granularity =
 		bdev_discard_granularity(mp->m_ddev_targp->bt_bdev);
 	struct fstrim_range	range;
-	xfs_daddr_t		start, end, minlen;
-	xfs_agnumber_t		agno;
+	xfs_daddr_t		start, end;
+	xfs_extlen_t		minlen;
+	xfs_agnumber_t		start_agno, end_agno;
+	xfs_agblock_t		start_agbno, end_agbno;
 	uint64_t		blocks_trimmed = 0;
 	int			error, last_error = 0;
 
@@ -399,7 +424,8 @@ xfs_ioc_trim(
 		return -EFAULT;
 
 	range.minlen = max_t(u64, granularity, range.minlen);
-	minlen = BTOBB(range.minlen);
+	minlen = XFS_B_TO_FSB(mp, range.minlen);
+
 	/*
 	 * Truncating down the len isn't actually quite correct, but using
 	 * BBTOB would mean we trivially get overflows for values
@@ -413,15 +439,21 @@ xfs_ioc_trim(
 		return -EINVAL;
 
 	start = BTOBB(range.start);
-	end = start + BTOBBT(range.len) - 1;
+	end = min_t(xfs_daddr_t, start + BTOBBT(range.len),
+		    XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)) - 1;
 
-	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
-		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1;
+	start_agno = xfs_daddr_to_agno(mp, start);
+	start_agbno = xfs_daddr_to_agbno(mp, start);
+	end_agno = xfs_daddr_to_agno(mp, end);
+	end_agbno = xfs_daddr_to_agbno(mp, end);
 
-	agno = xfs_daddr_to_agno(mp, start);
-	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
-		error = xfs_trim_extents(pag, start, end, minlen,
-					  &blocks_trimmed);
+	for_each_perag_range(mp, start_agno, end_agno, pag) {
+		xfs_agblock_t	agend = pag->block_count;
+
+		if (start_agno == end_agno)
+			agend = end_agbno;
+		error = xfs_trim_extents(pag, start_agbno, agend, minlen,
+				&blocks_trimmed);
 		if (error)
 			last_error = error;
 
@@ -429,6 +461,7 @@ xfs_ioc_trim(
 			xfs_perag_rele(pag);
 			break;
 		}
+		start_agbno = 0;
 	}
 
 	if (last_error)
