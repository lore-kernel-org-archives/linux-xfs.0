Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA5DC47404
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA8520873
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Pa4+aOcF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfJDWpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 18:45:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39854 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728023AbfJDWpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 18:45:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94MiYFY041428;
        Fri, 4 Oct 2019 22:44:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FRTeBuRr9WxqgiWwxe8xnsLqa/eisi7OuDG9wKgmQBk=;
 b=Pa4+aOcFxj59jbHDuKbbMt96ii26bsb3LBU5GLUezuDlifdsvFiQ11RxyguD0R/Or8G2
 1ctlZ2IEinqeMRnUWXCpSvCu+NZ6XFGcICcT3/bopLBv4v3mK8u01klMgkQQGMttB0DF
 fIY74D1KFB2ZmRI3UfnAwbaND/Q+Wcry/bEdythjBlIma1B2dJsnF/UUKdyvuf1tgUlA
 qzThWYCEyaoPcPvPCRKuj2rDpIwIRxndhBS0bk2aMIp/DGJa9sh48pr/SGJGWPd4z4Sf
 4lB2dbI4Aa6TmnATbfY2VPJN7SCc8RWIbKsM+0yyNSt9ig3M5nrMenAGHBKDQDWy3dxW Ew== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05se6k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:44:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94Mhgn8078269;
        Fri, 4 Oct 2019 22:44:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vdxu9kpu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:44:45 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x94MiiOk024263;
        Fri, 4 Oct 2019 22:44:44 GMT
Received: from localhost (/10.159.134.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 15:44:43 -0700
Date:   Fri, 4 Oct 2019 15:44:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 06/11] xfs: reuse best extent tracking logic for bnobt
 scan
Message-ID: <20191004224443.GM13108@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-7-bfoster@redhat.com>
 <20190918204311.GV2229799@magnolia>
 <20190919150424.GE35460@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919150424.GE35460@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040192
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 11:04:24AM -0400, Brian Foster wrote:
> On Wed, Sep 18, 2019 at 01:43:11PM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 16, 2019 at 08:16:30AM -0400, Brian Foster wrote:
> > > The near mode bnobt scan searches left and right in the bnobt
> > > looking for the closest free extent to the allocation hint that
> > > satisfies minlen. Once such an extent is found, the left/right
> > > search terminates, we search one more time in the opposite direction
> > > and finish the allocation with the best overall extent.
> > > 
> > > The left/right and find best searches are currently controlled via a
> > > combination of cursor state and local variables. Clean up this code
> > > and prepare for further improvements to the near mode fallback
> > > algorithm by reusing the allocation cursor best extent tracking
> > > mechanism. Update the tracking logic to deactivate bnobt cursors
> > > when out of allocation range and replace open-coded extent checks to
> > > calls to the common helper. In doing so, rename some misnamed local
> > > variables in the top-level near mode allocation function.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_alloc.c | 270 +++++++++++---------------------------
> > >  fs/xfs/xfs_trace.h        |   4 +-
> > >  2 files changed, 76 insertions(+), 198 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > index 2fa7bb6a00a8..edcec975c306 100644
> > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> ...
> > > @@ -1163,96 +1172,44 @@ xfs_alloc_ag_vextent_exact(
> > >  }
> > >  
> > >  /*
> > > - * Search the btree in a given direction via the search cursor and compare
> > > - * the records found against the good extent we've already found.
> > > + * Search the btree in a given direction and check the records against the good
> > > + * extent we've already found.
> > >   */
> > >  STATIC int
> > >  xfs_alloc_find_best_extent(
> > > -	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> > > -	struct xfs_btree_cur	*gcur,	/* good cursor */
> > > -	struct xfs_btree_cur	*scur,	/* searching cursor */
> > > -	xfs_agblock_t		gdiff,	/* difference for search comparison */
> > > -	xfs_agblock_t		*sbno,	/* extent found by search */
> > > -	xfs_extlen_t		*slen,	/* extent length */
> > > -	xfs_agblock_t		*sbnoa,	/* aligned extent found by search */
> > > -	xfs_extlen_t		*slena,	/* aligned extent length */
> > > -	int			dir)	/* 0 = search right, 1 = search left */
> > > +	struct xfs_alloc_arg	*args,
> > > +	struct xfs_alloc_cur	*acur,
> > > +	struct xfs_btree_cur	*cur,
> > > +	bool			increment)
> > >  {
> > > -	xfs_agblock_t		new;
> > > -	xfs_agblock_t		sdiff;
> > >  	int			error;
> > >  	int			i;
> > > -	unsigned		busy_gen;
> > > -
> > > -	/* The good extent is perfect, no need to  search. */
> > > -	if (!gdiff)
> > > -		goto out_use_good;
> > >  
> > >  	/*
> > > -	 * Look until we find a better one, run out of space or run off the end.
> > > +	 * Search so long as the cursor is active or we find a better extent.
> > > +	 * The cursor is deactivated if it extends beyond the range of the
> > > +	 * current allocation candidate.
> > >  	 */
> > > -	do {
> > > -		error = xfs_alloc_get_rec(scur, sbno, slen, &i);
> > > +	while (xfs_alloc_cur_active(cur)) {
> > > +		error = xfs_alloc_cur_check(args, acur, cur, &i);
> > 
> > Does @i > 0 now mean "we found a better candidate for allocation so
> > we're done" ?
> > 
> 
> In the context of xfs_alloc_cur_check(), i == 1 just means the checked
> extent became the new allocation candidate. Whether "we're done" or not
> is a higher level policy decision. In the xfs_alloc_find_best_extent()
> case, we're doing a last effort search in the opposite direction after
> finding an extent to allocate in the higher level left/right bnobt
> search. So yes, we are done in that scenario, but that's not necessarily
> the case for all calls to xfs_alloc_cur_check() that return i == 1.
> 
> Ideally this could be documented better, but this function is reworked
> into xfs_alloc_walk_iter() in the next couple patches and the behavior
> changes slightly.
> 
> > >  		if (error)
> > > -			goto error0;
> > > -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> > > -		xfs_alloc_compute_aligned(args, *sbno, *slen,
> > > -				sbnoa, slena, &busy_gen);
> > > -
> > > -		/*
> > > -		 * The good extent is closer than this one.
> > > -		 */
> > > -		if (!dir) {
> > > -			if (*sbnoa > args->max_agbno)
> > > -				goto out_use_good;
> > > -			if (*sbnoa >= args->agbno + gdiff)
> > > -				goto out_use_good;
> > > -		} else {
> > > -			if (*sbnoa < args->min_agbno)
> > > -				goto out_use_good;
> > > -			if (*sbnoa <= args->agbno - gdiff)
> > > -				goto out_use_good;
> > > -		}
> > > -
> > > -		/*
> > > -		 * Same distance, compare length and pick the best.
> > > -		 */
> > > -		if (*slena >= args->minlen) {
> > > -			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
> > > -			xfs_alloc_fix_len(args);
> > > -
> > > -			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> > > -						       args->alignment,
> > > -						       args->datatype, *sbnoa,
> > > -						       *slena, &new);
> > > -
> > > -			/*
> > > -			 * Choose closer size and invalidate other cursor.
> > > -			 */
> > > -			if (sdiff < gdiff)
> > > -				goto out_use_search;
> > > -			goto out_use_good;
> > > -		}
> > > +			return error;
> > > +		if (i == 1)
> > > +			break;
> > > +		if (!xfs_alloc_cur_active(cur))
> > > +			break;
> > >  
> > > -		if (!dir)
> > > -			error = xfs_btree_increment(scur, 0, &i);
> > > +		if (increment)
> > > +			error = xfs_btree_increment(cur, 0, &i);
> > >  		else
> > > -			error = xfs_btree_decrement(scur, 0, &i);
> > > +			error = xfs_btree_decrement(cur, 0, &i);
> > >  		if (error)
> > > -			goto error0;
> > > -	} while (i);
> > > -
> > > -out_use_good:
> > > -	scur->bc_private.a.priv.abt.active = false;
> > > -	return 0;
> > > +			return error;
> > > +		if (i == 0)
> > > +			cur->bc_private.a.priv.abt.active = false;
> > 
> > ...and I guess @i == 0 here means "@cur hit the end of the records so
> > deactivate it"?
> > 
> 
> Yeah, this is a bit of a quirk in that xfs_btree_[inc|dec]rement() are
> generic btree functions and so there was no place to bury the 'active'
> updates in the first patch of the series. I suppose you could argue that
> updating active is a reason to create a couple
> xfs_alloc_[inc|dec]rement() wrappers, but I don't have a strong
> preference. Thoughts?

Heh, oops, forgot to reply to this.  I would say that if we're
open-coding a lot of:

	error = xfs_btree_increment(some_alloc_cur, &i);
	if (error)
		return error;
	if (i == 0)
		some_alloc_cur->bc_private.a.priv.abt.active = false;

then yes, let's have a helper.  However, I'd only do that if there are
places other than this function that do this, and only as a cleanup to
add to the end of the series.

--D

> 
> > > +	}
> > >  
> > > -out_use_search:
> > > -	gcur->bc_private.a.priv.abt.active = false;
> > >  	return 0;
> > > -
> > > -error0:
> > > -	/* caller invalidates cursors */
> > > -	return error;
> > >  }
> > >  
> > >  /*
> > > @@ -1266,23 +1223,13 @@ xfs_alloc_ag_vextent_near(
> > >  	struct xfs_alloc_arg	*args)
> > >  {
> > >  	struct xfs_alloc_cur	acur = {0,};
> > > -	struct xfs_btree_cur	*bno_cur;
> > > -	xfs_agblock_t	gtbno;		/* start bno of right side entry */
> > > -	xfs_agblock_t	gtbnoa;		/* aligned ... */
> > > -	xfs_extlen_t	gtdiff;		/* difference to right side entry */
> > > -	xfs_extlen_t	gtlen;		/* length of right side entry */
> > > -	xfs_extlen_t	gtlena;		/* aligned ... */
> > > -	xfs_agblock_t	gtnew;		/* useful start bno of right side */
> > > +	struct xfs_btree_cur	*fbcur = NULL;
> > >  	int		error;		/* error code */
> > >  	int		i;		/* result code, temporary */
> > >  	int		j;		/* result code, temporary */
> > > -	xfs_agblock_t	ltbno;		/* start bno of left side entry */
> > > -	xfs_agblock_t	ltbnoa;		/* aligned ... */
> > > -	xfs_extlen_t	ltdiff;		/* difference to left side entry */
> > > -	xfs_extlen_t	ltlen;		/* length of left side entry */
> > > -	xfs_extlen_t	ltlena;		/* aligned ... */
> > > -	xfs_agblock_t	ltnew;		/* useful start bno of left side */
> > > -	xfs_extlen_t	rlen;		/* length of returned extent */
> > > +	xfs_agblock_t	bno;
> > 
> > Is the indenting here inconsistent with the *fbcur declaration above?
> > 
> 
> No, will fix.
> 
> > > +	xfs_extlen_t	len;
> > > +	bool		fbinc = false;
> > >  #ifdef DEBUG
> > >  	/*
> > >  	 * Randomly don't execute the first algorithm.
> ...
> > > @@ -1524,47 +1434,15 @@ xfs_alloc_ag_vextent_near(
> > >  		goto out;
> > >  	}
> > >  
> > > -	/*
> > > -	 * At this point we have selected a freespace entry, either to the
> > > -	 * left or to the right.  If it's on the right, copy all the
> > > -	 * useful variables to the "left" set so we only have one
> > > -	 * copy of this code.
> > > -	 */
> > > -	if (xfs_alloc_cur_active(acur.bnogt)) {
> > > -		bno_cur = acur.bnogt;
> > > -		ltbno = gtbno;
> > > -		ltbnoa = gtbnoa;
> > > -		ltlen = gtlen;
> > > -		ltlena = gtlena;
> > > -		j = 1;
> > > -	} else {
> > > -		bno_cur = acur.bnolt;
> > > -		j = 0;
> > > -	}
> > > -
> > > -	/*
> > > -	 * Fix up the length and compute the useful address.
> > > -	 */
> > > -	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> > > -	xfs_alloc_fix_len(args);
> > > -	rlen = args->len;
> > > -	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
> > > -				     args->datatype, ltbnoa, ltlena, &ltnew);
> > 
> > Hmm.  So I /think/ the reason this can go away is that
> > xfs_alloc_cur_check already did all this trimming and whatnot and
> > stuffed the values into the xfs_alloc_cur structure, so we can just copy
> > the allocated extent to the caller's @args, update the bnobt/cntbt to
> > reflect the allocation, and exit?
> > 
> 
> Right, the code just above should be a subset of what
> xfs_alloc_cur_check() is already doing before it selects a new
> candidate. This was necessary in the current code because this was all
> tracked by cursor state (i.e. xfs_alloc_find_best_extent() decides
> whether to use the left or right cursor). This is all replaced with
> explicit "best extent" tracking, independent from logic around things
> like which direction to do the "find best" search in, etc.
> 
> > I think this looks ok, but woof a lot to digest. :/
> > 
> 
> This was the hairiest patch of the set IMO. :P
> 
> Brian
> 
> > --D
> > 
> > > -	ASSERT(ltnew >= ltbno);
> > > -	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
> > > -	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> > > -	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
> > > -	args->agbno = ltnew;
> > > -
> > > -	error = xfs_alloc_fixup_trees(acur.cnt, bno_cur, ltbno, ltlen, ltnew,
> > > -				      rlen, XFSA_FIXUP_BNO_OK);
> > > -	if (error)
> > > -		goto out;
> > > +	args->agbno = acur.bno;
> > > +	args->len = acur.len;
> > > +	ASSERT(acur.bno >= acur.rec_bno);
> > > +	ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
> > > +	ASSERT(acur.rec_bno + acur.rec_len <=
> > > +	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> > >  
> > > -	if (j)
> > > -		trace_xfs_alloc_near_greater(args);
> > > -	else
> > > -		trace_xfs_alloc_near_lesser(args);
> > > +	error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, acur.rec_bno,
> > > +				      acur.rec_len, acur.bno, acur.len, 0);
> > >  
> > >  out:
> > >  	xfs_alloc_cur_close(&acur, error);
> > > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > > index b12fad3e45cb..2e57dc3d4230 100644
> > > --- a/fs/xfs/xfs_trace.h
> > > +++ b/fs/xfs/xfs_trace.h
> > > @@ -1642,8 +1642,8 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
> > >  DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
> > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
> > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
> > > -DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
> > > -DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
> > > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
> > > +DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
> > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
> > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
> > >  DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
> > > -- 
> > > 2.20.1
> > > 
