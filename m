Return-Path: <SRS0=GEoz=YA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D0DC47404
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D9682064A
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Oct 2019 11:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfJGLJC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Oct 2019 07:09:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727317AbfJGLJC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Oct 2019 07:09:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C224F3082E42;
        Mon,  7 Oct 2019 11:09:01 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 583811001B05;
        Mon,  7 Oct 2019 11:09:01 +0000 (UTC)
Date:   Mon, 7 Oct 2019 07:08:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 06/11] xfs: reuse best extent tracking logic for bnobt
 scan
Message-ID: <20191007110859.GA17033@bfoster>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-7-bfoster@redhat.com>
 <20190918204311.GV2229799@magnolia>
 <20190919150424.GE35460@bfoster>
 <20191004224443.GM13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004224443.GM13108@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 07 Oct 2019 11:09:01 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 04, 2019 at 03:44:43PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 19, 2019 at 11:04:24AM -0400, Brian Foster wrote:
> > On Wed, Sep 18, 2019 at 01:43:11PM -0700, Darrick J. Wong wrote:
> > > On Mon, Sep 16, 2019 at 08:16:30AM -0400, Brian Foster wrote:
> > > > The near mode bnobt scan searches left and right in the bnobt
> > > > looking for the closest free extent to the allocation hint that
> > > > satisfies minlen. Once such an extent is found, the left/right
> > > > search terminates, we search one more time in the opposite direction
> > > > and finish the allocation with the best overall extent.
> > > > 
> > > > The left/right and find best searches are currently controlled via a
> > > > combination of cursor state and local variables. Clean up this code
> > > > and prepare for further improvements to the near mode fallback
> > > > algorithm by reusing the allocation cursor best extent tracking
> > > > mechanism. Update the tracking logic to deactivate bnobt cursors
> > > > when out of allocation range and replace open-coded extent checks to
> > > > calls to the common helper. In doing so, rename some misnamed local
> > > > variables in the top-level near mode allocation function.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_alloc.c | 270 +++++++++++---------------------------
> > > >  fs/xfs/xfs_trace.h        |   4 +-
> > > >  2 files changed, 76 insertions(+), 198 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > index 2fa7bb6a00a8..edcec975c306 100644
> > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > ...
> > > > @@ -1163,96 +1172,44 @@ xfs_alloc_ag_vextent_exact(
> > > >  }
> > > >  
> > > >  /*
> > > > - * Search the btree in a given direction via the search cursor and compare
> > > > - * the records found against the good extent we've already found.
> > > > + * Search the btree in a given direction and check the records against the good
> > > > + * extent we've already found.
> > > >   */
> > > >  STATIC int
> > > >  xfs_alloc_find_best_extent(
> > > > -	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> > > > -	struct xfs_btree_cur	*gcur,	/* good cursor */
> > > > -	struct xfs_btree_cur	*scur,	/* searching cursor */
> > > > -	xfs_agblock_t		gdiff,	/* difference for search comparison */
> > > > -	xfs_agblock_t		*sbno,	/* extent found by search */
> > > > -	xfs_extlen_t		*slen,	/* extent length */
> > > > -	xfs_agblock_t		*sbnoa,	/* aligned extent found by search */
> > > > -	xfs_extlen_t		*slena,	/* aligned extent length */
> > > > -	int			dir)	/* 0 = search right, 1 = search left */
> > > > +	struct xfs_alloc_arg	*args,
> > > > +	struct xfs_alloc_cur	*acur,
> > > > +	struct xfs_btree_cur	*cur,
> > > > +	bool			increment)
> > > >  {
> > > > -	xfs_agblock_t		new;
> > > > -	xfs_agblock_t		sdiff;
> > > >  	int			error;
> > > >  	int			i;
> > > > -	unsigned		busy_gen;
> > > > -
> > > > -	/* The good extent is perfect, no need to  search. */
> > > > -	if (!gdiff)
> > > > -		goto out_use_good;
> > > >  
> > > >  	/*
> > > > -	 * Look until we find a better one, run out of space or run off the end.
> > > > +	 * Search so long as the cursor is active or we find a better extent.
> > > > +	 * The cursor is deactivated if it extends beyond the range of the
> > > > +	 * current allocation candidate.
> > > >  	 */
> > > > -	do {
> > > > -		error = xfs_alloc_get_rec(scur, sbno, slen, &i);
> > > > +	while (xfs_alloc_cur_active(cur)) {
> > > > +		error = xfs_alloc_cur_check(args, acur, cur, &i);
> > > 
> > > Does @i > 0 now mean "we found a better candidate for allocation so
> > > we're done" ?
> > > 
> > 
> > In the context of xfs_alloc_cur_check(), i == 1 just means the checked
> > extent became the new allocation candidate. Whether "we're done" or not
> > is a higher level policy decision. In the xfs_alloc_find_best_extent()
> > case, we're doing a last effort search in the opposite direction after
> > finding an extent to allocate in the higher level left/right bnobt
> > search. So yes, we are done in that scenario, but that's not necessarily
> > the case for all calls to xfs_alloc_cur_check() that return i == 1.
> > 
> > Ideally this could be documented better, but this function is reworked
> > into xfs_alloc_walk_iter() in the next couple patches and the behavior
> > changes slightly.
> > 
> > > >  		if (error)
> > > > -			goto error0;
> > > > -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > > > -		xfs_alloc_compute_aligned(args, *sbno, *slen,
> > > > -				sbnoa, slena, &busy_gen);
> > > > -
> > > > -		/*
> > > > -		 * The good extent is closer than this one.
> > > > -		 */
> > > > -		if (!dir) {
> > > > -			if (*sbnoa > args->max_agbno)
> > > > -				goto out_use_good;
> > > > -			if (*sbnoa >= args->agbno + gdiff)
> > > > -				goto out_use_good;
> > > > -		} else {
> > > > -			if (*sbnoa < args->min_agbno)
> > > > -				goto out_use_good;
> > > > -			if (*sbnoa <= args->agbno - gdiff)
> > > > -				goto out_use_good;
> > > > -		}
> > > > -
> > > > -		/*
> > > > -		 * Same distance, compare length and pick the best.
> > > > -		 */
> > > > -		if (*slena >= args->minlen) {
> > > > -			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
> > > > -			xfs_alloc_fix_len(args);
> > > > -
> > > > -			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> > > > -						       args->alignment,
> > > > -						       args->datatype, *sbnoa,
> > > > -						       *slena, &new);
> > > > -
> > > > -			/*
> > > > -			 * Choose closer size and invalidate other cursor.
> > > > -			 */
> > > > -			if (sdiff < gdiff)
> > > > -				goto out_use_search;
> > > > -			goto out_use_good;
> > > > -		}
> > > > +			return error;
> > > > +		if (i == 1)
> > > > +			break;
> > > > +		if (!xfs_alloc_cur_active(cur))
> > > > +			break;
> > > >  
> > > > -		if (!dir)
> > > > -			error = xfs_btree_increment(scur, 0, &i);
> > > > +		if (increment)
> > > > +			error = xfs_btree_increment(cur, 0, &i);
> > > >  		else
> > > > -			error = xfs_btree_decrement(scur, 0, &i);
> > > > +			error = xfs_btree_decrement(cur, 0, &i);
> > > >  		if (error)
> > > > -			goto error0;
> > > > -	} while (i);
> > > > -
> > > > -out_use_good:
> > > > -	scur->bc_private.a.priv.abt.active = false;
> > > > -	return 0;
> > > > +			return error;
> > > > +		if (i == 0)
> > > > +			cur->bc_private.a.priv.abt.active = false;
> > > 
> > > ...and I guess @i == 0 here means "@cur hit the end of the records so
> > > deactivate it"?
> > > 
> > 
> > Yeah, this is a bit of a quirk in that xfs_btree_[inc|dec]rement() are
> > generic btree functions and so there was no place to bury the 'active'
> > updates in the first patch of the series. I suppose you could argue that
> > updating active is a reason to create a couple
> > xfs_alloc_[inc|dec]rement() wrappers, but I don't have a strong
> > preference. Thoughts?
> 
> Heh, oops, forgot to reply to this.  I would say that if we're
> open-coding a lot of:
> 
> 	error = xfs_btree_increment(some_alloc_cur, &i);
> 	if (error)
> 		return error;
> 	if (i == 0)
> 		some_alloc_cur->bc_private.a.priv.abt.active = false;
> 
> then yes, let's have a helper.  However, I'd only do that if there are
> places other than this function that do this, and only as a cleanup to
> add to the end of the series.
> 

That pattern is used in at least a couple places as of this series. Once
in xfs_alloc_walk_iter() (to increment or decrement) and again in
xfs_alloc_ag_vextent_locality() to restore a cntbt cursor for a fallback
reverse search. I'll start the next round of reworks off with a patch to
refactor those into a helper.. thanks for the reviews.

Brian

> --D
> 
> > 
> > > > +	}
> > > >  
> > > > -out_use_search:
> > > > -	gcur->bc_private.a.priv.abt.active = false;
> > > >  	return 0;
> > > > -
> > > > -error0:
> > > > -	/* caller invalidates cursors */
> > > > -	return error;
> > > >  }
> > > >  
> > > >  /*
> > > > @@ -1266,23 +1223,13 @@ xfs_alloc_ag_vextent_near(
> > > >  	struct xfs_alloc_arg	*args)
> > > >  {
> > > >  	struct xfs_alloc_cur	acur = {0,};
> > > > -	struct xfs_btree_cur	*bno_cur;
> > > > -	xfs_agblock_t	gtbno;		/* start bno of right side entry */
> > > > -	xfs_agblock_t	gtbnoa;		/* aligned ... */
> > > > -	xfs_extlen_t	gtdiff;		/* difference to right side entry */
> > > > -	xfs_extlen_t	gtlen;		/* length of right side entry */
> > > > -	xfs_extlen_t	gtlena;		/* aligned ... */
> > > > -	xfs_agblock_t	gtnew;		/* useful start bno of right side */
> > > > +	struct xfs_btree_cur	*fbcur = NULL;
> > > >  	int		error;		/* error code */
> > > >  	int		i;		/* result code, temporary */
> > > >  	int		j;		/* result code, temporary */
> > > > -	xfs_agblock_t	ltbno;		/* start bno of left side entry */
> > > > -	xfs_agblock_t	ltbnoa;		/* aligned ... */
> > > > -	xfs_extlen_t	ltdiff;		/* difference to left side entry */
> > > > -	xfs_extlen_t	ltlen;		/* length of left side entry */
> > > > -	xfs_extlen_t	ltlena;		/* aligned ... */
> > > > -	xfs_agblock_t	ltnew;		/* useful start bno of left side */
> > > > -	xfs_extlen_t	rlen;		/* length of returned extent */
> > > > +	xfs_agblock_t	bno;
> > > 
> > > Is the indenting here inconsistent with the *fbcur declaration above?
> > > 
> > 
> > No, will fix.
> > 
> > > > +	xfs_extlen_t	len;
> > > > +	bool		fbinc = false;
> > > >  #ifdef DEBUG
> > > >  	/*
> > > >  	 * Randomly don't execute the first algorithm.
> > ...
> > > > @@ -1524,47 +1434,15 @@ xfs_alloc_ag_vextent_near(
> > > >  		goto out;
> > > >  	}
> > > >  
> > > > -	/*
> > > > -	 * At this point we have selected a freespace entry, either to the
> > > > -	 * left or to the right.  If it's on the right, copy all the
> > > > -	 * useful variables to the "left" set so we only have one
> > > > -	 * copy of this code.
> > > > -	 */
> > > > -	if (xfs_alloc_cur_active(acur.bnogt)) {
> > > > -		bno_cur = acur.bnogt;
> > > > -		ltbno = gtbno;
> > > > -		ltbnoa = gtbnoa;
> > > > -		ltlen = gtlen;
> > > > -		ltlena = gtlena;
> > > > -		j = 1;
> > > > -	} else {
> > > > -		bno_cur = acur.bnolt;
> > > > -		j = 0;
> > > > -	}
> > > > -
> > > > -	/*
> > > > -	 * Fix up the length and compute the useful address.
> > > > -	 */
> > > > -	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> > > > -	xfs_alloc_fix_len(args);
> > > > -	rlen = args->len;
> > > > -	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
> > > > -				     args->datatype, ltbnoa, ltlena, &ltnew);
> > > 
> > > Hmm.  So I /think/ the reason this can go away is that
> > > xfs_alloc_cur_check already did all this trimming and whatnot and
> > > stuffed the values into the xfs_alloc_cur structure, so we can just copy
> > > the allocated extent to the caller's @args, update the bnobt/cntbt to
> > > reflect the allocation, and exit?
> > > 
> > 
> > Right, the code just above should be a subset of what
> > xfs_alloc_cur_check() is already doing before it selects a new
> > candidate. This was necessary in the current code because this was all
> > tracked by cursor state (i.e. xfs_alloc_find_best_extent() decides
> > whether to use the left or right cursor). This is all replaced with
> > explicit "best extent" tracking, independent from logic around things
> > like which direction to do the "find best" search in, etc.
> > 
> > > I think this looks ok, but woof a lot to digest. :/
> > > 
> > 
> > This was the hairiest patch of the set IMO. :P
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > -	ASSERT(ltnew >= ltbno);
> > > > -	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
> > > > -	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> > > > -	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
> > > > -	args->agbno = ltnew;
> > > > -
> > > > -	error = xfs_alloc_fixup_trees(acur.cnt, bno_cur, ltbno, ltlen, ltnew,
> > > > -				      rlen, XFSA_FIXUP_BNO_OK);
> > > > -	if (error)
> > > > -		goto out;
> > > > +	args->agbno = acur.bno;
> > > > +	args->len = acur.len;
> > > > +	ASSERT(acur.bno >= acur.rec_bno);
> > > > +	ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
> > > > +	ASSERT(acur.rec_bno + acur.rec_len <=
> > > > +	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> > > >  
> > > > -	if (j)
> > > > -		trace_xfs_alloc_near_greater(args);
> > > > -	else
> > > > -		trace_xfs_alloc_near_lesser(args);
> > > > +	error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, acur.rec_bno,
> > > > +				      acur.rec_len, acur.bno, acur.len, 0);
> > > >  
> > > >  out:
> > > >  	xfs_alloc_cur_close(&acur, error);
> > > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > > index b12fad3e45cb..2e57dc3d4230 100644
> > > > --- a/fs/xfs/xfs_trace.h
> > > > +++ b/fs/xfs/xfs_trace.h
> > > > @@ -1642,8 +1642,8 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
> > > >  DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
> > > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
> > > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
> > > > -DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
> > > > -DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
> > > > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
> > > > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
> > > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
> > > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
> > > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
> > > > -- 
> > > > 2.20.1
> > > > 
