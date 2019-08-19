Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0F7C3A5A0
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 18:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E52B222CEB
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 18:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfHSSGd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 14:06:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbfHSSGd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Aug 2019 14:06:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8337C307D962;
        Mon, 19 Aug 2019 18:06:32 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E5EDB1E2;
        Mon, 19 Aug 2019 18:06:31 +0000 (UTC)
Date:   Mon, 19 Aug 2019 14:06:30 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 2/4] xfs: use locality optimized cntbt lookups for
 near mode allocations
Message-ID: <20190819180630.GD2875@bfoster>
References: <20190815125538.49570-1-bfoster@redhat.com>
 <20190815125538.49570-3-bfoster@redhat.com>
 <20190817013459.GF15198@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817013459.GF15198@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 19 Aug 2019 18:06:32 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 06:34:59PM -0700, Darrick J. Wong wrote:
> Whee, a huge patch! :)
> 

Heh.

> On Thu, Aug 15, 2019 at 08:55:36AM -0400, Brian Foster wrote:
> > The extent allocation code in XFS has several allocation modes with
> > unique implementations. These modes are not all that different from
> > a high level perspective. The most involved mode is near allocation
> > mode which attempts to allocate an optimally sized extent with ideal
> > locality with respect to a provided agbno hint.
> > 
> > In the common case, a near mode allocation consists of a conditional
> > scan of the last cntbt block followed by a concurrent left and right
> > spanning search of the bnobt starting from the ideal point of
> > locality in the bnobt. This works reasonably well as filesystems age
> > via most common allocation patterns. If free space fragments as the
> > filesystem ages, however, the near algorithm has very poor breakdown
> > characteristics. If the extent size lookup happens to land outside
> > (i.e., before) the last cntbt block, the alloc bypasses the cntbt
> > entirely. If a suitably sized extent is far enough away from the
> > starting points of the bnobt search, the left/right scans can take a
> > significant amount of time to locate the target extent. This leads
> > to pathological allocation latencies in certain workloads.
> > 
> > While locality is important to near mode allocations, it is not so
> > important as to incur pathological allocation latency to provide the
> > asolute best locality for every allocation. The left/right bnobt
> > scan is inefficient in many large allocation scenarios. As an
> > alternative, we can use locality optimized lookups of the cntbt to
> > find the closest extent to the target agbno of a particular size. We
> > can repeat this lookup to cover a larger span of extents much more
> > efficiently. Finally, we can combine this cntbt lookup algorithm
> > with the existing bnobt scan to provide a natural balance between
> > the two for large and small allocations. For example, the bnobt scan
> > may be able to satisfy inode chunk or btree block allocations fairly
> > quickly where the cntbt search may have to search through a large
> > set of extent sizes. On the other hand, the cntbt search can more
> > deterministically scan the set of free extents available for much
> > larger delayed allocation requests where the bnobt scan may have to
> > search the entire AG.
> 
> I sure wish this lengthy description was being put into xfs_alloc.c
> itself.  It would be nice to have some pictures of how this is supposed
> to work too.
> 

I can try to filter some of this down into the functions that implement
the appropriate bits of the algorithm. I'm not sure what a picture might
look like though... can you elaborate on what you're looking for here?

> > Rework the near mode allocation algorithm as described above to
> > provide predictable allocation latency under breakdown conditions
> > with good enough locality in the common case. In doing so, refactor
> > the affected code into a more generic interface and mechanisms to
> > facilitate future reuse by the by-size and exact mode algorithms.
> > Both allocation modes currently have unique, ground-up
> > implementations that can be replaced with minimal logic additions to
> > the generic code in this patch.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 1045 +++++++++++++++++++------------------
> >  fs/xfs/xfs_trace.h        |   43 +-
> >  2 files changed, 581 insertions(+), 507 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 6340f59ac3f4..7753b61ba532 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
...
> > @@ -710,8 +709,446 @@ xfs_alloc_update_counters(
...
> > +
> > +/*
> > + * Locality allocation lookup algorithm. This expects a cntbt cursor and uses
> > + * bno optimized lookup to search for extents with ideal size and locality.
> 
> Is it supposed to be the case that acur->cnt == cur?  Why not omit the
> third parameter?
> 

Yeah, it was originally written to facilitate reuse but didn't end up
that way. I should be able to just drop the cursor parameter. I might
rename it to something like cntbt_lookup_iter() too just so it's clear,
FWIW.

> > + */
> > +STATIC int
> > +xfs_alloc_lookup_iter(
> > +	struct xfs_alloc_arg		*args,
> > +	struct xfs_alloc_cur		*acur,
> > +	struct xfs_btree_cur		*cur)
> > +{
> > +	xfs_agblock_t		bno;
> > +	xfs_extlen_t		len, cur_len;
> > +	int			error;
> > +	int			i;
> > +
> > +	if (!xfs_alloc_cur_active(cur))
> > +		return 0;
> > +
> > +	/* locality optimized lookup */
> > +	cur_len = acur->cur_len;
> > +	error = xfs_alloc_lookup_ge(cur, args->agbno, cur_len, &i);
> > +	if (error)
> > +		return error;
> > +	if (i == 0)
> > +		return 0;
> > +	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
> > +	if (error)
> > +		return error;
> > +
> > +	/* check the current record and update search length from it */
> > +	error = xfs_alloc_cur_check(args, acur, cur, &i);
> > +	if (error)
> > +		return error;
> > +	ASSERT(len >= acur->cur_len);
> > +	acur->cur_len = len;
> > +
> > +	/*
> > +	 * We looked up the first record >= [agbno, len] above. The agbno is a
> > +	 * secondary key and so the current record may lie just before or after
> > +	 * agbno. If it is past agbno, check the previous record too so long as
> > +	 * the length matches as it may be closer. Don't check a smaller record
> > +	 * because that could deactivate our cursor.
> > +	 */
> > +	if (bno > args->agbno) {
> > +		error = xfs_btree_decrement(cur, 0, &i);
> > +		if (!error && i) {
> > +			error = xfs_alloc_get_rec(cur, &bno, &len, &i);
> > +			if (!error && i && len == acur->cur_len)
> > +				error = xfs_alloc_cur_check(args, acur, cur,
> > +							    &i);
> > +		}
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	/*
> > +	 * Increment the search key until we find at least one allocation
> > +	 * candidate or if the extent we found was larger. Otherwise, double the
> > +	 * search key to optimize the search. Efficiency is more important here
> > +	 * than absolute best locality.
> > +	 */
> > +	cur_len <<= 1;
> > +	if (!acur->len || acur->cur_len >= cur_len)
> > +		acur->cur_len++;
> > +	else
> > +		acur->cur_len = cur_len;
> > +
> > +	return error;
> > +}
> > +
> > +/*
> > + * Incremental lookup algorithm. Walk a btree in either direction looking for
> > + * candidate extents. This works for either bnobt (locality allocation) or cntbt
> > + * (by-size allocation) cursors.
> > + */
> > +STATIC int
> > +xfs_alloc_walk_iter(
> > +	struct xfs_alloc_arg		*args,
> > +	struct xfs_alloc_cur		*acur,
> > +	struct xfs_btree_cur		*cur,
> > +	bool				increment,
> > +	bool				findone,
> > +	int				iters,
> 
> Err... what do fin-done and iters do?
> 
> "If @findone, return the first thing we find" and "Only search @iters
> steps away"?  Maybe the two bools should be flags?
> 

Yeah.. basically visit iters records and whether or not to end the
search if we find an allocation candidate. It doesn't matter to me
whether we use bools or flags, but how do you prefer to define flags for
the increment/decrement control? Increment by default unless
XFS_ALLOC_DECREMENT or some such flag is passed..? Vice versa?

> > +	int				*stat)
> > +{
> > +	int			error;
> > +	int			i;
> > +
> > +	*stat = 0;
> > +
> > +	if (!xfs_alloc_cur_active(cur))
> > +		return 0;
> > +
> > +	for (; iters > 0; iters--) {
> > +		error = xfs_alloc_cur_check(args, acur, cur, &i);
> > +		if (error)
> > +			return error;
> > +		if (i) {
> > +			*stat = 1;
> > +			if (findone)
> > +				break;
> > +		}
> > +		if (!xfs_alloc_cur_active(cur))
> > +			break;
> > +
> > +		if (increment)
> > +			error = xfs_btree_increment(cur, 0, &i);
> > +		else
> > +			error = xfs_btree_decrement(cur, 0, &i);
> > +		if (error)
> > +			return error;
> > +		if (i == 0) {
> > +			cur->bc_private.a.priv.abt.active = false;
> > +			break;
> > +		}
> > +	}
> > +
> > +	return error;
> > +}
> > +
> > +/*
> > + * High level locality allocation algorithm. Search the bnobt (left and right)
> > + * in parallel with locality-optimized cntbt lookups to find an extent with
> > + * ideal locality.
> > + */
> > +STATIC int
> > +xfs_alloc_ag_vextent_lookup(
> > +	struct xfs_alloc_arg	*args,
> > +	struct xfs_alloc_cur	*acur,
> > +	int			*stat)
> > +{
> > +	int				error;
> > +	int				i;
> > +	struct xfs_btree_cur		*fbcur = NULL;
> > +	bool				fbinc = false;
> > +
> > +	ASSERT(acur->cnt);
> > +	ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
> > +	*stat = 0;
> > +
> > +	/*
> > +	 * Set up available cursors for a locality allocation search based on
> > +	 * the ->agbno hint. An exact allocation only needs the bnolt so disable
> > +	 * the cntbt cursor explicitly.
> > +	 */
> > +	error = xfs_alloc_lookup_ge(acur->cnt, args->agbno, acur->cur_len, &i);
> > +	if (error)
> > +		return error;
> > +	error = xfs_alloc_lookup_le(acur->bnolt, args->agbno, 0, &i);
> > +	if (error)
> > +		return error;
> > +	error = xfs_alloc_lookup_ge(acur->bnogt, args->agbno, 0, &i);
> > +	if (error)
> > +		return error;
> > +
> > +	/* search as long as we have at least one active cursor */
> > +	while (xfs_alloc_cur_active(acur->cnt) ||
> > +	       xfs_alloc_cur_active(acur->bnolt) ||
> > +	       xfs_alloc_cur_active(acur->bnogt)) {
> > +		trace_xfs_alloc_cur_lookup(args);
> > +
> > +		/*
> > +		 * Search the bnobt left and right. If either of these find a
> > +		 * maxlen extent, we know we've found ideal locality. Do a
> > +		 * capped search in the opposite direction and we're done.
> 
> So ... we cap the distance we'll walk the two bno cursors to 1 record,
> which I think is key to preventing the "pathological allocation"
> mentioned above?
> 

The key to avoiding the pathological behavior is more to have the cntbt
lookup search in parallel. That prevents us from ultimately having to
scan through bunches of bnobt blocks without any records that meet the
minimum requirements, particularly for larger allocation requests. The
cntbt lookup guarantees we'll find some extents that at least meet the
size requirement of the allocation in a timely fashion.

In that sense, the bnobt scan becomes more of an optimization/balance
for smaller allocations. If the bnobt scan finds a maxlen extent before
the cntbt lookup completes, we know we've found best case locality.
E.g., this is pretty much what happens every time for single block
allocations where otherwise the cntbt search would have to jump from
single block extents all the way to the largest free extent before it
would terminate.

With regard to the per-iteration tuning, I was originally thinking about
having this scan a full block at a time, since we've already had to read
it off disk. That turned out to be more overhead than I initially
thought so I just set it back to 1 to keep it simple. I'm guessing we
could bump it to something slightly larger (more on the order of a
handful), but I just haven't come across a case where that level of fine
tuning matters to this point.

> > +		 */
> > +		error = xfs_alloc_walk_iter(args, acur, acur->bnolt, false,
> > +					    true, 1, &i);
> > +		if (error)
> > +			return error;
> > +		if (i && acur->len == args->maxlen) {
> > +			trace_xfs_alloc_cur_left(args);
> > +			fbcur = acur->bnogt;
> > +			fbinc = true;
> > +			break;
> > +		}
> > +
> > +		error = xfs_alloc_walk_iter(args, acur, acur->bnogt, true,
> > +					    true, 1, &i);
> > +		if (error)
> > +			return error;
> > +		if (i && acur->len == args->maxlen) {
> > +			trace_xfs_alloc_cur_right(args);
> > +			fbcur = acur->bnolt;
> > +			break;
> > +		}
> > +
> > +		/*
> > +		 * Search the cntbt for a maximum sized extent with ideal
> > +		 * locality. The lookup search terminates on reaching the end of
> > +		 * the cntbt. Break out of the loop if this occurs to throttle
> > +		 * the bnobt scans.
> > +		 */
> > +		error = xfs_alloc_lookup_iter(args, acur, acur->cnt);
> > +		if (error)
> > +			return error;
> > +		if (!xfs_alloc_cur_active(acur->cnt)) {
> > +			trace_xfs_alloc_cur_lookup_done(args);
> 
> ...and I guess this means that now we're racing incremental steps of
> three different free space btree cursors to see if any of the three will
> find a match with the length we want?
> 
> And if all of this fails, then we fall back to scanning backwards with
> the cntbt until we find something?
> 

Pretty much. The bnobt search is by-definition a locality search so we
can terminate immediately on a maxlen hit. The cntbt search could
essentially provide random locality because of how the tree is
organized, hence the need for multiple lookups of >=maxlen sized extents
to improve the quality of the locality.

If the search fails, the fallbacks are less performance sensitive and
oriented towards just finding something that satisfies minlen.

> Ok, I think I get how this is a behavior improvement on the old code.
> 
> The splitting of the old _near function into smaller pieces makes it a
> little easier to read the code, though I sorta wish this was more like
> the March(?) version where the splitting happened and /then/ the
> behavior change came after, instead of a 33K patch...
> 

I'm not sure what you're referring to here. I never split up the current
implementation because I didn't have a clear path to do that at the
time. This was partly because the final algorithm wasn't really
established, so I needed to work that out, but also because there are
some weird quirks with the current code where helper functions are tied
into behavior of the higher level algorithm and it seemed like kind of a
mess to untangle just to potentially replace that code.

The previous version of this series converted more allocation modes
(exact and by-size) than this version. Those have been temporarily
dropped for now so I can make progress on the core mechanism/interfaces
without continuously refactoring the rest. Is that what you're referring
to?

I can take another look at moving to the updated algorithm more
incrementally now that the end result is more of a known quantity, but
I'll have to go back and stare at it some more to figure if/how much it
can be broken up...

Brian

> --D
> 
> > +			if (!acur->len) {
> > +				/*
> > +				 * Reset the cursor for a minlen search in the
> > +				 * caller.
> > +				 */
> > +				error = xfs_btree_decrement(acur->cnt, 0, &i);
> > +				if (error)
> > +					return error;
> > +				if (i)
> > +					acur->cnt->bc_private.a.priv.abt.active = true;
> > +			}
> > +			break;
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * Perform a best-effort search in the opposite direction from a bnobt
> > +	 * allocation.
> > +	 */
> > +	if (fbcur) {
> > +		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true,
> > +					    args->mp->m_alloc_mxr[0], &i);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	if (acur->len)
> > +		*stat = 1;
> > +
> > +	return error;
> > +}
> >  
> >  /*
> >   * Deal with the case where only small freespaces remain. Either return the
> > @@ -814,6 +1251,113 @@ xfs_alloc_ag_vextent_small(
> >  	return error;
> >  }
> >  
> > +/*
> > + * Allocate a variable extent near bno in the allocation group agno.
> > + * Extent's length (returned in len) will be between minlen and maxlen,
> > + * and of the form k * prod + mod unless there's nothing that large.
> > + * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
> > + */
> > +STATIC int
> > +xfs_alloc_ag_vextent_near(
> > +	struct xfs_alloc_arg	*args)
> > +{
> > +	struct xfs_alloc_cur	acur = {0,};
> > +	int			error;
> > +	int			i;
> > +	xfs_agblock_t		bno;
> > +	xfs_extlen_t		len;
> > +
> > +	/* handle unitialized agbno range so caller doesn't have to */
> > +	if (!args->min_agbno && !args->max_agbno)
> > +		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
> > +	ASSERT(args->min_agbno <= args->max_agbno);
> > +
> > +	/* clamp agbno to the range if it's outside */
> > +	if (args->agbno < args->min_agbno)
> > +		args->agbno = args->min_agbno;
> > +	if (args->agbno > args->max_agbno)
> > +		args->agbno = args->max_agbno;
> > +
> > +restart:
> > +	error = xfs_alloc_cur_setup(args, &acur);
> > +	if (error) {
> > +		error = (error == -ENOSPC) ? 0 : error;
> > +		goto out;
> > +	}
> > +
> > +	/*
> > +	 * The cntbt cursor points at the first maxlen or minlen extent. If it
> > +	 * resides in the last block of the tree, scan the rest of the block.
> > +	 * Otherwise run the optimized lookup search algorithm from the current
> > +	 * location to the end of the tree.
> > +	 */
> > +	if (xfs_btree_islastblock(acur.cnt, 0)) {
> > +		int	j;
> > +
> > +		trace_xfs_alloc_cur_lastblock(args);
> > +		error = xfs_alloc_walk_iter(args, &acur, acur.cnt, true, false,
> > +				    INT_MAX, &i);
> > +		if (error)
> > +			goto out;
> > +
> > +		/*
> > +		 * If allocation fails, reset the cursor for a reverse minlen
> > +		 * scan. cur_len doesn't change so look up the extent just
> > +		 * before the starting point.
> > +		 */
> > +		if (!i && acur.cur_len > args->minlen)
> > +			error = xfs_alloc_lookup_le(acur.cnt, 0, acur.cur_len, &j);
> > +	} else {
> > +		error = xfs_alloc_ag_vextent_lookup(args, &acur, &i);
> > +	}
> > +	if (error)
> > +		goto out;
> > +
> > +	/*
> > +	 * Ignore locality and search backwards for the first suitable minlen
> > +	 * extent. This fails if we run out of minlen extents.
> > +	 */
> > +	if (!i && xfs_alloc_cur_active(acur.cnt)) {
> > +		trace_xfs_alloc_cur_reverse(args);
> > +		error = xfs_alloc_walk_iter(args, &acur, acur.cnt, false, true,
> > +					    INT_MAX, &i);
> > +		if (error)
> > +			goto out;
> > +	}
> > +
> > +	if (!i) {
> > +		/* flush and retry if we found busy extents */
> > +		if (acur.busy) {
> > +			trace_xfs_alloc_ag_busy(args);
> > +			xfs_extent_busy_flush(args->mp, args->pag,
> > +					      acur.busy_gen);
> > +			goto restart;
> > +		}
> > +
> > +		/*
> > +		 * Try the AGFL as a last resort. Don't pass a cursor so this
> > +		 * returns an AGFL block (i == 0) or nothing.
> > +		 */
> > +		error = xfs_alloc_ag_vextent_small(args, NULL, &bno, &len, &i);
> > +		if (error)
> > +			goto out;
> > +		ASSERT(i == 0 || (i && len == 0));
> > +		trace_xfs_alloc_ag_noentry(args);
> > +
> > +		args->agbno = bno;
> > +		args->len = len;
> > +		goto out;
> > +	}
> > +
> > +	/* fix up btrees on a successful allocation */
> > +	error = xfs_alloc_cur_finish(args, &acur);
> > +out:
> > +	xfs_alloc_cur_close(&acur, error);
> > +	if (error)
> > +		trace_xfs_alloc_ag_error(args);
> > +	return error;
> > +}
> > +
> >  /*
> >   * Allocate a variable extent in the allocation group agno.
> >   * Type and bno are used to determine where in the allocation group the
> > @@ -1001,503 +1545,6 @@ xfs_alloc_ag_vextent_exact(
> >  	return error;
> >  }
> >  
> > -/*
> > - * Search the btree in a given direction via the search cursor and compare
> > - * the records found against the good extent we've already found.
> > - */
> > -STATIC int
> > -xfs_alloc_find_best_extent(
> > -	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> > -	struct xfs_btree_cur	**gcur,	/* good cursor */
> > -	struct xfs_btree_cur	**scur,	/* searching cursor */
> > -	xfs_agblock_t		gdiff,	/* difference for search comparison */
> > -	xfs_agblock_t		*sbno,	/* extent found by search */
> > -	xfs_extlen_t		*slen,	/* extent length */
> > -	xfs_agblock_t		*sbnoa,	/* aligned extent found by search */
> > -	xfs_extlen_t		*slena,	/* aligned extent length */
> > -	int			dir)	/* 0 = search right, 1 = search left */
> > -{
> > -	xfs_agblock_t		new;
> > -	xfs_agblock_t		sdiff;
> > -	int			error;
> > -	int			i;
> > -	unsigned		busy_gen;
> > -
> > -	/* The good extent is perfect, no need to  search. */
> > -	if (!gdiff)
> > -		goto out_use_good;
> > -
> > -	/*
> > -	 * Look until we find a better one, run out of space or run off the end.
> > -	 */
> > -	do {
> > -		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
> > -		if (error)
> > -			goto error0;
> > -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > -		xfs_alloc_compute_aligned(args, *sbno, *slen,
> > -				sbnoa, slena, &busy_gen);
> > -
> > -		/*
> > -		 * The good extent is closer than this one.
> > -		 */
> > -		if (!dir) {
> > -			if (*sbnoa > args->max_agbno)
> > -				goto out_use_good;
> > -			if (*sbnoa >= args->agbno + gdiff)
> > -				goto out_use_good;
> > -		} else {
> > -			if (*sbnoa < args->min_agbno)
> > -				goto out_use_good;
> > -			if (*sbnoa <= args->agbno - gdiff)
> > -				goto out_use_good;
> > -		}
> > -
> > -		/*
> > -		 * Same distance, compare length and pick the best.
> > -		 */
> > -		if (*slena >= args->minlen) {
> > -			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
> > -			xfs_alloc_fix_len(args);
> > -
> > -			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> > -						       args->alignment,
> > -						       args->datatype, *sbnoa,
> > -						       *slena, &new);
> > -
> > -			/*
> > -			 * Choose closer size and invalidate other cursor.
> > -			 */
> > -			if (sdiff < gdiff)
> > -				goto out_use_search;
> > -			goto out_use_good;
> > -		}
> > -
> > -		if (!dir)
> > -			error = xfs_btree_increment(*scur, 0, &i);
> > -		else
> > -			error = xfs_btree_decrement(*scur, 0, &i);
> > -		if (error)
> > -			goto error0;
> > -	} while (i);
> > -
> > -out_use_good:
> > -	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
> > -	*scur = NULL;
> > -	return 0;
> > -
> > -out_use_search:
> > -	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
> > -	*gcur = NULL;
> > -	return 0;
> > -
> > -error0:
> > -	/* caller invalidates cursors */
> > -	return error;
> > -}
> > -
> > -/*
> > - * Allocate a variable extent near bno in the allocation group agno.
> > - * Extent's length (returned in len) will be between minlen and maxlen,
> > - * and of the form k * prod + mod unless there's nothing that large.
> > - * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
> > - */
> > -STATIC int				/* error */
> > -xfs_alloc_ag_vextent_near(
> > -	xfs_alloc_arg_t	*args)		/* allocation argument structure */
> > -{
> > -	xfs_btree_cur_t	*bno_cur_gt;	/* cursor for bno btree, right side */
> > -	xfs_btree_cur_t	*bno_cur_lt;	/* cursor for bno btree, left side */
> > -	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
> > -	xfs_agblock_t	gtbno;		/* start bno of right side entry */
> > -	xfs_agblock_t	gtbnoa;		/* aligned ... */
> > -	xfs_extlen_t	gtdiff;		/* difference to right side entry */
> > -	xfs_extlen_t	gtlen;		/* length of right side entry */
> > -	xfs_extlen_t	gtlena;		/* aligned ... */
> > -	xfs_agblock_t	gtnew;		/* useful start bno of right side */
> > -	int		error;		/* error code */
> > -	int		i;		/* result code, temporary */
> > -	int		j;		/* result code, temporary */
> > -	xfs_agblock_t	ltbno;		/* start bno of left side entry */
> > -	xfs_agblock_t	ltbnoa;		/* aligned ... */
> > -	xfs_extlen_t	ltdiff;		/* difference to left side entry */
> > -	xfs_extlen_t	ltlen;		/* length of left side entry */
> > -	xfs_extlen_t	ltlena;		/* aligned ... */
> > -	xfs_agblock_t	ltnew;		/* useful start bno of left side */
> > -	xfs_extlen_t	rlen;		/* length of returned extent */
> > -	bool		busy;
> > -	unsigned	busy_gen;
> > -#ifdef DEBUG
> > -	/*
> > -	 * Randomly don't execute the first algorithm.
> > -	 */
> > -	int		dofirst;	/* set to do first algorithm */
> > -
> > -	dofirst = prandom_u32() & 1;
> > -#endif
> > -
> > -	/* handle unitialized agbno range so caller doesn't have to */
> > -	if (!args->min_agbno && !args->max_agbno)
> > -		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
> > -	ASSERT(args->min_agbno <= args->max_agbno);
> > -
> > -	/* clamp agbno to the range if it's outside */
> > -	if (args->agbno < args->min_agbno)
> > -		args->agbno = args->min_agbno;
> > -	if (args->agbno > args->max_agbno)
> > -		args->agbno = args->max_agbno;
> > -
> > -restart:
> > -	bno_cur_lt = NULL;
> > -	bno_cur_gt = NULL;
> > -	ltlen = 0;
> > -	gtlena = 0;
> > -	ltlena = 0;
> > -	busy = false;
> > -
> > -	/*
> > -	 * Get a cursor for the by-size btree.
> > -	 */
> > -	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> > -		args->agno, XFS_BTNUM_CNT);
> > -
> > -	/*
> > -	 * See if there are any free extents as big as maxlen.
> > -	 */
> > -	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
> > -		goto error0;
> > -	/*
> > -	 * If none, then pick up the last entry in the tree unless the
> > -	 * tree is empty.
> > -	 */
> > -	if (!i) {
> > -		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
> > -				&ltlen, &i)))
> > -			goto error0;
> > -		if (i == 0 || ltlen == 0) {
> > -			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > -			trace_xfs_alloc_near_noentry(args);
> > -			return 0;
> > -		}
> > -		ASSERT(i == 1);
> > -	}
> > -	args->wasfromfl = 0;
> > -
> > -	/*
> > -	 * First algorithm.
> > -	 * If the requested extent is large wrt the freespaces available
> > -	 * in this a.g., then the cursor will be pointing to a btree entry
> > -	 * near the right edge of the tree.  If it's in the last btree leaf
> > -	 * block, then we just examine all the entries in that block
> > -	 * that are big enough, and pick the best one.
> > -	 * This is written as a while loop so we can break out of it,
> > -	 * but we never loop back to the top.
> > -	 */
> > -	while (xfs_btree_islastblock(cnt_cur, 0)) {
> > -		xfs_extlen_t	bdiff;
> > -		int		besti=0;
> > -		xfs_extlen_t	blen=0;
> > -		xfs_agblock_t	bnew=0;
> > -
> > -#ifdef DEBUG
> > -		if (dofirst)
> > -			break;
> > -#endif
> > -		/*
> > -		 * Start from the entry that lookup found, sequence through
> > -		 * all larger free blocks.  If we're actually pointing at a
> > -		 * record smaller than maxlen, go to the start of this block,
> > -		 * and skip all those smaller than minlen.
> > -		 */
> > -		if (ltlen || args->alignment > 1) {
> > -			cnt_cur->bc_ptrs[0] = 1;
> > -			do {
> > -				if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno,
> > -						&ltlen, &i)))
> > -					goto error0;
> > -				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > -				if (ltlen >= args->minlen)
> > -					break;
> > -				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
> > -					goto error0;
> > -			} while (i);
> > -			ASSERT(ltlen >= args->minlen);
> > -			if (!i)
> > -				break;
> > -		}
> > -		i = cnt_cur->bc_ptrs[0];
> > -		for (j = 1, blen = 0, bdiff = 0;
> > -		     !error && j && (blen < args->maxlen || bdiff > 0);
> > -		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
> > -			/*
> > -			 * For each entry, decide if it's better than
> > -			 * the previous best entry.
> > -			 */
> > -			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
> > -				goto error0;
> > -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > -			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
> > -					&ltbnoa, &ltlena, &busy_gen);
> > -			if (ltlena < args->minlen)
> > -				continue;
> > -			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
> > -				continue;
> > -			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> > -			xfs_alloc_fix_len(args);
> > -			ASSERT(args->len >= args->minlen);
> > -			if (args->len < blen)
> > -				continue;
> > -			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> > -				args->alignment, args->datatype, ltbnoa,
> > -				ltlena, &ltnew);
> > -			if (ltnew != NULLAGBLOCK &&
> > -			    (args->len > blen || ltdiff < bdiff)) {
> > -				bdiff = ltdiff;
> > -				bnew = ltnew;
> > -				blen = args->len;
> > -				besti = cnt_cur->bc_ptrs[0];
> > -			}
> > -		}
> > -		/*
> > -		 * It didn't work.  We COULD be in a case where
> > -		 * there's a good record somewhere, so try again.
> > -		 */
> > -		if (blen == 0)
> > -			break;
> > -		/*
> > -		 * Point at the best entry, and retrieve it again.
> > -		 */
> > -		cnt_cur->bc_ptrs[0] = besti;
> > -		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
> > -			goto error0;
> > -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > -		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> > -		args->len = blen;
> > -
> > -		/*
> > -		 * We are allocating starting at bnew for blen blocks.
> > -		 */
> > -		args->agbno = bnew;
> > -		ASSERT(bnew >= ltbno);
> > -		ASSERT(bnew + blen <= ltbno + ltlen);
> > -		/*
> > -		 * Set up a cursor for the by-bno tree.
> > -		 */
> > -		bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp,
> > -			args->agbp, args->agno, XFS_BTNUM_BNO);
> > -		/*
> > -		 * Fix up the btree entries.
> > -		 */
> > -		if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno,
> > -				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK)))
> > -			goto error0;
> > -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > -		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
> > -
> > -		trace_xfs_alloc_near_first(args);
> > -		return 0;
> > -	}
> > -	/*
> > -	 * Second algorithm.
> > -	 * Search in the by-bno tree to the left and to the right
> > -	 * simultaneously, until in each case we find a space big enough,
> > -	 * or run into the edge of the tree.  When we run into the edge,
> > -	 * we deallocate that cursor.
> > -	 * If both searches succeed, we compare the two spaces and pick
> > -	 * the better one.
> > -	 * With alignment, it's possible for both to fail; the upper
> > -	 * level algorithm that picks allocation groups for allocations
> > -	 * is not supposed to do this.
> > -	 */
> > -	/*
> > -	 * Allocate and initialize the cursor for the leftward search.
> > -	 */
> > -	bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> > -		args->agno, XFS_BTNUM_BNO);
> > -	/*
> > -	 * Lookup <= bno to find the leftward search's starting point.
> > -	 */
> > -	if ((error = xfs_alloc_lookup_le(bno_cur_lt, args->agbno, args->maxlen, &i)))
> > -		goto error0;
> > -	if (!i) {
> > -		/*
> > -		 * Didn't find anything; use this cursor for the rightward
> > -		 * search.
> > -		 */
> > -		bno_cur_gt = bno_cur_lt;
> > -		bno_cur_lt = NULL;
> > -	}
> > -	/*
> > -	 * Found something.  Duplicate the cursor for the rightward search.
> > -	 */
> > -	else if ((error = xfs_btree_dup_cursor(bno_cur_lt, &bno_cur_gt)))
> > -		goto error0;
> > -	/*
> > -	 * Increment the cursor, so we will point at the entry just right
> > -	 * of the leftward entry if any, or to the leftmost entry.
> > -	 */
> > -	if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
> > -		goto error0;
> > -	if (!i) {
> > -		/*
> > -		 * It failed, there are no rightward entries.
> > -		 */
> > -		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_NOERROR);
> > -		bno_cur_gt = NULL;
> > -	}
> > -	/*
> > -	 * Loop going left with the leftward cursor, right with the
> > -	 * rightward cursor, until either both directions give up or
> > -	 * we find an entry at least as big as minlen.
> > -	 */
> > -	do {
> > -		if (bno_cur_lt) {
> > -			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
> > -				goto error0;
> > -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > -			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
> > -					&ltbnoa, &ltlena, &busy_gen);
> > -			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
> > -				break;
> > -			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
> > -				goto error0;
> > -			if (!i || ltbnoa < args->min_agbno) {
> > -				xfs_btree_del_cursor(bno_cur_lt,
> > -						     XFS_BTREE_NOERROR);
> > -				bno_cur_lt = NULL;
> > -			}
> > -		}
> > -		if (bno_cur_gt) {
> > -			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
> > -				goto error0;
> > -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > -			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
> > -					&gtbnoa, &gtlena, &busy_gen);
> > -			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
> > -				break;
> > -			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
> > -				goto error0;
> > -			if (!i || gtbnoa > args->max_agbno) {
> > -				xfs_btree_del_cursor(bno_cur_gt,
> > -						     XFS_BTREE_NOERROR);
> > -				bno_cur_gt = NULL;
> > -			}
> > -		}
> > -	} while (bno_cur_lt || bno_cur_gt);
> > -
> > -	/*
> > -	 * Got both cursors still active, need to find better entry.
> > -	 */
> > -	if (bno_cur_lt && bno_cur_gt) {
> > -		if (ltlena >= args->minlen) {
> > -			/*
> > -			 * Left side is good, look for a right side entry.
> > -			 */
> > -			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> > -			xfs_alloc_fix_len(args);
> > -			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> > -				args->alignment, args->datatype, ltbnoa,
> > -				ltlena, &ltnew);
> > -
> > -			error = xfs_alloc_find_best_extent(args,
> > -						&bno_cur_lt, &bno_cur_gt,
> > -						ltdiff, &gtbno, &gtlen,
> > -						&gtbnoa, &gtlena,
> > -						0 /* search right */);
> > -		} else {
> > -			ASSERT(gtlena >= args->minlen);
> > -
> > -			/*
> > -			 * Right side is good, look for a left side entry.
> > -			 */
> > -			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
> > -			xfs_alloc_fix_len(args);
> > -			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> > -				args->alignment, args->datatype, gtbnoa,
> > -				gtlena, &gtnew);
> > -
> > -			error = xfs_alloc_find_best_extent(args,
> > -						&bno_cur_gt, &bno_cur_lt,
> > -						gtdiff, &ltbno, &ltlen,
> > -						&ltbnoa, &ltlena,
> > -						1 /* search left */);
> > -		}
> > -
> > -		if (error)
> > -			goto error0;
> > -	}
> > -
> > -	/*
> > -	 * If we couldn't get anything, give up.
> > -	 */
> > -	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
> > -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > -
> > -		if (busy) {
> > -			trace_xfs_alloc_near_busy(args);
> > -			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> > -			goto restart;
> > -		}
> > -		trace_xfs_alloc_size_neither(args);
> > -		args->agbno = NULLAGBLOCK;
> > -		return 0;
> > -	}
> > -
> > -	/*
> > -	 * At this point we have selected a freespace entry, either to the
> > -	 * left or to the right.  If it's on the right, copy all the
> > -	 * useful variables to the "left" set so we only have one
> > -	 * copy of this code.
> > -	 */
> > -	if (bno_cur_gt) {
> > -		bno_cur_lt = bno_cur_gt;
> > -		bno_cur_gt = NULL;
> > -		ltbno = gtbno;
> > -		ltbnoa = gtbnoa;
> > -		ltlen = gtlen;
> > -		ltlena = gtlena;
> > -		j = 1;
> > -	} else
> > -		j = 0;
> > -
> > -	/*
> > -	 * Fix up the length and compute the useful address.
> > -	 */
> > -	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> > -	xfs_alloc_fix_len(args);
> > -	rlen = args->len;
> > -	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
> > -				     args->datatype, ltbnoa, ltlena, &ltnew);
> > -	ASSERT(ltnew >= ltbno);
> > -	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
> > -	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> > -	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
> > -	args->agbno = ltnew;
> > -
> > -	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
> > -			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
> > -		goto error0;
> > -
> > -	if (j)
> > -		trace_xfs_alloc_near_greater(args);
> > -	else
> > -		trace_xfs_alloc_near_lesser(args);
> > -
> > -	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > -	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
> > -	return 0;
> > -
> > - error0:
> > -	trace_xfs_alloc_near_error(args);
> > -	if (cnt_cur != NULL)
> > -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
> > -	if (bno_cur_lt != NULL)
> > -		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_ERROR);
> > -	if (bno_cur_gt != NULL)
> > -		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_ERROR);
> > -	return error;
> > -}
> > -
> >  /*
> >   * Allocate a variable extent anywhere in the allocation group agno.
> >   * Extent's length (returned in len) will be between minlen and maxlen,
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index 8094b1920eef..a441a472da79 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -1635,14 +1635,16 @@ DEFINE_EVENT(xfs_alloc_class, name, \
> >  DEFINE_ALLOC_EVENT(xfs_alloc_exact_done);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
> > -DEFINE_ALLOC_EVENT(xfs_alloc_size_neither);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_ag_error);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_ag_noentry);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_ag_busy);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lastblock);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup_done);
> > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_reverse);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
> > @@ -1658,6 +1660,31 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
> >  DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
> >  
> > +TRACE_EVENT(xfs_alloc_cur_check,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agblock_t bno,
> > +		 xfs_extlen_t len, xfs_extlen_t diff, bool new),
> > +	TP_ARGS(mp, btnum, bno, len, diff, new),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_btnum_t, btnum)
> > +		__field(xfs_agblock_t, bno)
> > +		__field(xfs_extlen_t, len)
> > +		__field(xfs_extlen_t, diff)
> > +		__field(bool, new)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->btnum = btnum;
> > +		__entry->bno = bno;
> > +		__entry->len = len;
> > +		__entry->diff = diff;
> > +		__entry->new = new;
> > +	),
> > +	TP_printk("dev %d:%d btnum %d bno 0x%x len 0x%x diff 0x%x new %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->btnum,
> > +		  __entry->bno, __entry->len, __entry->diff, __entry->new)
> > +)
> > +
> >  DECLARE_EVENT_CLASS(xfs_da_class,
> >  	TP_PROTO(struct xfs_da_args *args),
> >  	TP_ARGS(args),
> > -- 
> > 2.20.1
> > 
