Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F320C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30E7021D81
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 22:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DrB3VEZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfJDWr2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 18:47:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42606 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDWr2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 18:47:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94MiYFh041428;
        Fri, 4 Oct 2019 22:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=UigRVi3q3Lna7viqVtvgAJu9Htt1Cfw0h1Px1gUUjzk=;
 b=DrB3VEZ6/JdmLKkK/IJDiL3/szeyDJGxL9Qgqd3la8HcUozJd+PPj/aoPSRJOixm316b
 Lioc686cwgoQKUdQQXn+/mEWUwAk1WuSRWKcdKaB7jK5AgFAmb3HHwapHiiMJ/1ykbb9
 h3gz0AHAY54i6/iM/7flOrXt6Uk9/kpW8JqofKpVY2FyR6x+0C5ErY3xPnbnO9d/ezkR
 aPgN9O1OrOh/qOuIThqyJfWIcVokfVDMjby68a/3fgw6JywDWooolHzHqZWRPCC04eQO
 PQTbhsef75sAcEru5cd3JhYpYs4Hn1cTeLMsX2uDWlziLioRZ8PZIYID8NSOp0NhdE1F Kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05se6vy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:47:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94MhhiC078315;
        Fri, 4 Oct 2019 22:45:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vdxu9kqk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 22:45:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x94MjHGr032028;
        Fri, 4 Oct 2019 22:45:17 GMT
Received: from localhost (/10.159.134.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 15:45:17 -0700
Date:   Fri, 4 Oct 2019 15:45:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 06/11] xfs: reuse best extent tracking logic for bnobt
 scan
Message-ID: <20191004224516.GE1473994@magnolia>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927171802.45582-7-bfoster@redhat.com>
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

On Fri, Sep 27, 2019 at 01:17:57PM -0400, Brian Foster wrote:
> The near mode bnobt scan searches left and right in the bnobt
> looking for the closest free extent to the allocation hint that
> satisfies minlen. Once such an extent is found, the left/right
> search terminates, we search one more time in the opposite direction
> and finish the allocation with the best overall extent.
> 
> The left/right and find best searches are currently controlled via a
> combination of cursor state and local variables. Clean up this code
> and prepare for further improvements to the near mode fallback
> algorithm by reusing the allocation cursor best extent tracking
> mechanism. Update the tracking logic to deactivate bnobt cursors
> when out of allocation range and replace open-coded extent checks to
> calls to the common helper. In doing so, rename some misnamed local
> variables in the top-level near mode allocation function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks reasonable,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 276 +++++++++++---------------------------
>  fs/xfs/xfs_trace.h        |   4 +-
>  2 files changed, 79 insertions(+), 201 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 38183953636a..d412ae41676a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -810,6 +810,7 @@ xfs_alloc_cur_check(
>  	bool			busy;
>  	unsigned		busy_gen = 0;
>  	bool			deactivate = false;
> +	bool			isbnobt = cur->bc_btnum == XFS_BTNUM_BNO;
>  
>  	*new = 0;
>  
> @@ -823,7 +824,7 @@ xfs_alloc_cur_check(
>  	 * range (i.e., walking backwards looking for a minlen extent).
>  	 */
>  	if (len < args->minlen) {
> -		deactivate = true;
> +		deactivate = !isbnobt;
>  		goto out;
>  	}
>  
> @@ -833,8 +834,10 @@ xfs_alloc_cur_check(
>  	if (busy)
>  		acur->busy_gen = busy_gen;
>  	/* deactivate a bnobt cursor outside of locality range */
> -	if (bnoa < args->min_agbno || bnoa > args->max_agbno)
> +	if (bnoa < args->min_agbno || bnoa > args->max_agbno) {
> +		deactivate = isbnobt;
>  		goto out;
> +	}
>  	if (lena < args->minlen)
>  		goto out;
>  
> @@ -854,8 +857,14 @@ xfs_alloc_cur_check(
>  				      bnoa, lena, &bnew);
>  	if (bnew == NULLAGBLOCK)
>  		goto out;
> -	if (diff > acur->diff)
> +
> +	/*
> +	 * Deactivate a bnobt cursor with worse locality than the current best.
> +	 */
> +	if (diff > acur->diff) {
> +		deactivate = isbnobt;
>  		goto out;
> +	}
>  
>  	ASSERT(args->len > acur->len ||
>  	       (args->len == acur->len && diff <= acur->diff));
> @@ -1163,96 +1172,44 @@ xfs_alloc_ag_vextent_exact(
>  }
>  
>  /*
> - * Search the btree in a given direction via the search cursor and compare
> - * the records found against the good extent we've already found.
> + * Search the btree in a given direction and check the records against the good
> + * extent we've already found.
>   */
>  STATIC int
>  xfs_alloc_find_best_extent(
> -	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> -	struct xfs_btree_cur	*gcur,	/* good cursor */
> -	struct xfs_btree_cur	*scur,	/* searching cursor */
> -	xfs_agblock_t		gdiff,	/* difference for search comparison */
> -	xfs_agblock_t		*sbno,	/* extent found by search */
> -	xfs_extlen_t		*slen,	/* extent length */
> -	xfs_agblock_t		*sbnoa,	/* aligned extent found by search */
> -	xfs_extlen_t		*slena,	/* aligned extent length */
> -	int			dir)	/* 0 = search right, 1 = search left */
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_alloc_cur	*acur,
> +	struct xfs_btree_cur	*cur,
> +	bool			increment)
>  {
> -	xfs_agblock_t		new;
> -	xfs_agblock_t		sdiff;
>  	int			error;
>  	int			i;
> -	unsigned		busy_gen;
> -
> -	/* The good extent is perfect, no need to  search. */
> -	if (!gdiff)
> -		goto out_use_good;
>  
>  	/*
> -	 * Look until we find a better one, run out of space or run off the end.
> +	 * Search so long as the cursor is active or we find a better extent.
> +	 * The cursor is deactivated if it extends beyond the range of the
> +	 * current allocation candidate.
>  	 */
> -	do {
> -		error = xfs_alloc_get_rec(scur, sbno, slen, &i);
> +	while (xfs_alloc_cur_active(cur)) {
> +		error = xfs_alloc_cur_check(args, acur, cur, &i);
>  		if (error)
> -			goto error0;
> -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> -		xfs_alloc_compute_aligned(args, *sbno, *slen,
> -				sbnoa, slena, &busy_gen);
> -
> -		/*
> -		 * The good extent is closer than this one.
> -		 */
> -		if (!dir) {
> -			if (*sbnoa > args->max_agbno)
> -				goto out_use_good;
> -			if (*sbnoa >= args->agbno + gdiff)
> -				goto out_use_good;
> -		} else {
> -			if (*sbnoa < args->min_agbno)
> -				goto out_use_good;
> -			if (*sbnoa <= args->agbno - gdiff)
> -				goto out_use_good;
> -		}
> -
> -		/*
> -		 * Same distance, compare length and pick the best.
> -		 */
> -		if (*slena >= args->minlen) {
> -			args->len = XFS_EXTLEN_MIN(*slena, args->maxlen);
> -			xfs_alloc_fix_len(args);
> -
> -			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> -						       args->alignment,
> -						       args->datatype, *sbnoa,
> -						       *slena, &new);
> -
> -			/*
> -			 * Choose closer size and invalidate other cursor.
> -			 */
> -			if (sdiff < gdiff)
> -				goto out_use_search;
> -			goto out_use_good;
> -		}
> +			return error;
> +		if (i == 1)
> +			break;
> +		if (!xfs_alloc_cur_active(cur))
> +			break;
>  
> -		if (!dir)
> -			error = xfs_btree_increment(scur, 0, &i);
> +		if (increment)
> +			error = xfs_btree_increment(cur, 0, &i);
>  		else
> -			error = xfs_btree_decrement(scur, 0, &i);
> +			error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
> -			goto error0;
> -	} while (i);
> -
> -out_use_good:
> -	scur->bc_private.a.priv.abt.active = false;
> -	return 0;
> +			return error;
> +		if (i == 0)
> +			cur->bc_private.a.priv.abt.active = false;
> +	}
>  
> -out_use_search:
> -	gcur->bc_private.a.priv.abt.active = false;
>  	return 0;
> -
> -error0:
> -	/* caller invalidates cursors */
> -	return error;
>  }
>  
>  /*
> @@ -1266,23 +1223,13 @@ xfs_alloc_ag_vextent_near(
>  	struct xfs_alloc_arg	*args)
>  {
>  	struct xfs_alloc_cur	acur = {0,};
> -	struct xfs_btree_cur	*bno_cur;
> -	xfs_agblock_t	gtbno;		/* start bno of right side entry */
> -	xfs_agblock_t	gtbnoa;		/* aligned ... */
> -	xfs_extlen_t	gtdiff;		/* difference to right side entry */
> -	xfs_extlen_t	gtlen;		/* length of right side entry */
> -	xfs_extlen_t	gtlena;		/* aligned ... */
> -	xfs_agblock_t	gtnew;		/* useful start bno of right side */
> -	int		error;		/* error code */
> -	int		i;		/* result code, temporary */
> -	int		j;		/* result code, temporary */
> -	xfs_agblock_t	ltbno;		/* start bno of left side entry */
> -	xfs_agblock_t	ltbnoa;		/* aligned ... */
> -	xfs_extlen_t	ltdiff;		/* difference to left side entry */
> -	xfs_extlen_t	ltlen;		/* length of left side entry */
> -	xfs_extlen_t	ltlena;		/* aligned ... */
> -	xfs_agblock_t	ltnew;		/* useful start bno of left side */
> -	xfs_extlen_t	rlen;		/* length of returned extent */
> +	struct xfs_btree_cur	*fbcur = NULL;
> +	int			error;		/* error code */
> +	int			i;		/* result code, temporary */
> +	int			j;		/* result code, temporary */
> +	xfs_agblock_t		bno;
> +	xfs_extlen_t		len;
> +	bool			fbinc = false;
>  #ifdef DEBUG
>  	/*
>  	 * Randomly don't execute the first algorithm.
> @@ -1304,9 +1251,7 @@ xfs_alloc_ag_vextent_near(
>  		args->agbno = args->max_agbno;
>  
>  restart:
> -	ltlen = 0;
> -	gtlena = 0;
> -	ltlena = 0;
> +	len = 0;
>  
>  	/*
>  	 * Set up cursors and see if there are any free extents as big as
> @@ -1315,11 +1260,11 @@ xfs_alloc_ag_vextent_near(
>  	 */
>  	error = xfs_alloc_cur_setup(args, &acur);
>  	if (error == -ENOSPC) {
> -		error = xfs_alloc_ag_vextent_small(args, acur.cnt, &ltbno,
> -				&ltlen, &i);
> +		error = xfs_alloc_ag_vextent_small(args, acur.cnt, &bno,
> +				&len, &i);
>  		if (error)
>  			goto out;
> -		if (i == 0 || ltlen == 0) {
> +		if (i == 0 || len == 0) {
>  			trace_xfs_alloc_near_noentry(args);
>  			goto out;
>  		}
> @@ -1350,21 +1295,21 @@ xfs_alloc_ag_vextent_near(
>  		 * record smaller than maxlen, go to the start of this block,
>  		 * and skip all those smaller than minlen.
>  		 */
> -		if (ltlen || args->alignment > 1) {
> +		if (len || args->alignment > 1) {
>  			acur.cnt->bc_ptrs[0] = 1;
>  			do {
> -				error = xfs_alloc_get_rec(acur.cnt, &ltbno,
> -						&ltlen, &i);
> +				error = xfs_alloc_get_rec(acur.cnt, &bno, &len,
> +						&i);
>  				if (error)
>  					goto out;
>  				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -				if (ltlen >= args->minlen)
> +				if (len >= args->minlen)
>  					break;
>  				error = xfs_btree_increment(acur.cnt, 0, &i);
>  				if (error)
>  					goto out;
>  			} while (i);
> -			ASSERT(ltlen >= args->minlen);
> +			ASSERT(len >= args->minlen);
>  			if (!i)
>  				break;
>  		}
> @@ -1433,77 +1378,43 @@ xfs_alloc_ag_vextent_near(
>  	 */
>  	do {
>  		if (xfs_alloc_cur_active(acur.bnolt)) {
> -			error = xfs_alloc_get_rec(acur.bnolt, &ltbno, &ltlen, &i);
> +			error = xfs_alloc_cur_check(args, &acur, acur.bnolt, &i);
>  			if (error)
>  				goto out;
> -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -			acur.busy |= xfs_alloc_compute_aligned(args, ltbno,
> -					ltlen, &ltbnoa, &ltlena, &acur.busy_gen);
> -			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
> +			if (i == 1) {
> +				trace_xfs_alloc_cur_left(args);
> +				fbcur = acur.bnogt;
> +				fbinc = true;
>  				break;
> +			}
>  			error = xfs_btree_decrement(acur.bnolt, 0, &i);
>  			if (error)
>  				goto out;
> -			if (!i || ltbnoa < args->min_agbno)
> +			if (!i)
>  				acur.bnolt->bc_private.a.priv.abt.active = false;
>  		}
>  		if (xfs_alloc_cur_active(acur.bnogt)) {
> -			error = xfs_alloc_get_rec(acur.bnogt, &gtbno, &gtlen, &i);
> +			error = xfs_alloc_cur_check(args, &acur, acur.bnogt, &i);
>  			if (error)
>  				goto out;
> -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
> -			acur.busy |= xfs_alloc_compute_aligned(args, gtbno,
> -					gtlen, &gtbnoa, &gtlena, &acur.busy_gen);
> -			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
> +			if (i == 1) {
> +				trace_xfs_alloc_cur_right(args);
> +				fbcur = acur.bnolt;
> +				fbinc = false;
>  				break;
> +			}
>  			error = xfs_btree_increment(acur.bnogt, 0, &i);
>  			if (error)
>  				goto out;
> -			if (!i || gtbnoa > args->max_agbno)
> +			if (!i)
>  				acur.bnogt->bc_private.a.priv.abt.active = false;
>  		}
>  	} while (xfs_alloc_cur_active(acur.bnolt) ||
>  		 xfs_alloc_cur_active(acur.bnogt));
>  
> -	/*
> -	 * Got both cursors still active, need to find better entry.
> -	 */
> -	if (xfs_alloc_cur_active(acur.bnolt) &&
> -	    xfs_alloc_cur_active(acur.bnogt)) {
> -		if (ltlena >= args->minlen) {
> -			/*
> -			 * Left side is good, look for a right side entry.
> -			 */
> -			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> -			xfs_alloc_fix_len(args);
> -			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> -				args->alignment, args->datatype, ltbnoa,
> -				ltlena, &ltnew);
> -
> -			error = xfs_alloc_find_best_extent(args,
> -						acur.bnolt, acur.bnogt,
> -						ltdiff, &gtbno, &gtlen,
> -						&gtbnoa, &gtlena,
> -						0 /* search right */);
> -		} else {
> -			ASSERT(gtlena >= args->minlen);
> -
> -			/*
> -			 * Right side is good, look for a left side entry.
> -			 */
> -			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
> -			xfs_alloc_fix_len(args);
> -			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
> -				args->alignment, args->datatype, gtbnoa,
> -				gtlena, &gtnew);
> -
> -			error = xfs_alloc_find_best_extent(args,
> -						acur.bnogt, acur.bnolt,
> -						gtdiff, &ltbno, &ltlen,
> -						&ltbnoa, &ltlena,
> -						1 /* search left */);
> -		}
> -
> +	/* search the opposite direction for a better entry */
> +	if (fbcur) {
> +		error = xfs_alloc_find_best_extent(args, &acur, fbcur, fbinc);
>  		if (error)
>  			goto out;
>  	}
> @@ -1511,8 +1422,7 @@ xfs_alloc_ag_vextent_near(
>  	/*
>  	 * If we couldn't get anything, give up.
>  	 */
> -	if (!xfs_alloc_cur_active(acur.bnolt) &&
> -	    !xfs_alloc_cur_active(acur.bnogt)) {
> +	if (!acur.len) {
>  		if (acur.busy) {
>  			trace_xfs_alloc_near_busy(args);
>  			xfs_extent_busy_flush(args->mp, args->pag,
> @@ -1524,47 +1434,15 @@ xfs_alloc_ag_vextent_near(
>  		goto out;
>  	}
>  
> -	/*
> -	 * At this point we have selected a freespace entry, either to the
> -	 * left or to the right.  If it's on the right, copy all the
> -	 * useful variables to the "left" set so we only have one
> -	 * copy of this code.
> -	 */
> -	if (xfs_alloc_cur_active(acur.bnogt)) {
> -		bno_cur = acur.bnogt;
> -		ltbno = gtbno;
> -		ltbnoa = gtbnoa;
> -		ltlen = gtlen;
> -		ltlena = gtlena;
> -		j = 1;
> -	} else {
> -		bno_cur = acur.bnolt;
> -		j = 0;
> -	}
> -
> -	/*
> -	 * Fix up the length and compute the useful address.
> -	 */
> -	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
> -	xfs_alloc_fix_len(args);
> -	rlen = args->len;
> -	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
> -				     args->datatype, ltbnoa, ltlena, &ltnew);
> -	ASSERT(ltnew >= ltbno);
> -	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
> -	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
> -	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
> -	args->agbno = ltnew;
> -
> -	error = xfs_alloc_fixup_trees(acur.cnt, bno_cur, ltbno, ltlen, ltnew,
> -				      rlen, XFSA_FIXUP_BNO_OK);
> -	if (error)
> -		goto out;
> +	args->agbno = acur.bno;
> +	args->len = acur.len;
> +	ASSERT(acur.bno >= acur.rec_bno);
> +	ASSERT(acur.bno + acur.len <= acur.rec_bno + acur.rec_len);
> +	ASSERT(acur.rec_bno + acur.rec_len <=
> +	       be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
>  
> -	if (j)
> -		trace_xfs_alloc_near_greater(args);
> -	else
> -		trace_xfs_alloc_near_lesser(args);
> +	error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, acur.rec_bno,
> +				      acur.rec_len, acur.bno, acur.len, 0);
>  
>  out:
>  	xfs_alloc_cur_close(&acur, error);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index cf618919cacf..ebe85e9ed7c8 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1642,8 +1642,8 @@ DEFINE_ALLOC_EVENT(xfs_alloc_exact_notfound);
>  DEFINE_ALLOC_EVENT(xfs_alloc_exact_error);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_nominleft);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
> -DEFINE_ALLOC_EVENT(xfs_alloc_near_greater);
> -DEFINE_ALLOC_EVENT(xfs_alloc_near_lesser);
> +DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
> +DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
> -- 
> 2.20.1
> 
