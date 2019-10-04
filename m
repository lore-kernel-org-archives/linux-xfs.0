Return-Path: <SRS0=FqvN=X5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07344C4360C
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 23:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8F72215EA
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Oct 2019 23:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i78t+CNk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfJDXWf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Oct 2019 19:22:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbfJDXWf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Oct 2019 19:22:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94NJFLa026798;
        Fri, 4 Oct 2019 23:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=4/wcJ7HkSeo1NNigdtLieTGrlWCwKh2ALjQGj08a2DA=;
 b=i78t+CNky/T2ww92vXZWGAVxFME6lZIxOGQe+kktMTN+2sfruzeqpJbtVzDUUZq+FPm/
 FCeEumL59LFSF5pFn5aUd1bHLBasfiFF92Zu5gmT2uo8Kjz1iQ3q1YqJ8oTdA8IECk2O
 L96OfolP1oODCIPod/P20bU5QC6xmAh5NtsX7Yu0MCg76kda5v2C7266hykwys5h547Q
 Tpa0YN2TIJ8Xn2gASfaGzmyeQasucX5fPuauXSHHJUmSkTQRSHEklj7EUZLb7jm6KYg/
 d2te4Vv1ATNgqsmU9CqU1xn27iJNZndzM7dq+FeZlTfLUTqUAvuoGMrg3Z93X7xmDXln Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2v9yfqxbj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 23:22:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x94NIVID002996;
        Fri, 4 Oct 2019 23:20:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vebbx550h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Oct 2019 23:20:29 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x94NKRD9005630;
        Fri, 4 Oct 2019 23:20:28 GMT
Received: from localhost (/10.159.134.51)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Oct 2019 16:20:24 -0700
Date:   Fri, 4 Oct 2019 16:20:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 11/11] xfs: optimize near mode bnobt scans with
 concurrent cntbt lookups
Message-ID: <20191004232022.GN13108@magnolia>
References: <20190927171802.45582-1-bfoster@redhat.com>
 <20190927171802.45582-12-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190927171802.45582-12-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910040196
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9400 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910040196
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 27, 2019 at 01:18:02PM -0400, Brian Foster wrote:
> The near mode fallback algorithm consists of a left/right scan of
> the bnobt. This algorithm has very poor breakdown characteristics
> under worst case free space fragmentation conditions. If a suitable
> extent is far enough from the locality hint, each allocation may
> scan most or all of the bnobt before it completes. This causes
> pathological behavior and extremely high allocation latencies.
> 
> While locality is important to near mode allocations, it is not so
> important as to incur pathological allocation latency to provide the
> asolute best available locality for every allocation. If the
> allocation is large enough or far enough away, there is a point of
> diminishing returns. As such, we can bound the overall operation by
> including an iterative cntbt lookup in the broader search. The cntbt
> lookup is optimized to immediately find the extent with best
> locality for the given size on each iteration. Since the cntbt is
> indexed by extent size, the lookup repeats with a variably
> aggressive increasing search key size until it runs off the edge of
> the tree.
> 
> This approach provides a natural balance between the two algorithms
> for various situations. For example, the bnobt scan is able to
> satisfy smaller allocations such as for inode chunks or btree blocks
> more quickly where the cntbt search may have to search through a
> large set of extent sizes when the search key starts off small
> relative to the largest extent in the tree. On the other hand, the
> cntbt search more deterministically covers the set of suitable
> extents for larger data extent allocation requests that the bnobt
> scan may have to search the entire tree to locate.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok, I'll give it a spin along with all the other 5.5 stuff...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 154 +++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_trace.h        |   2 +
>  2 files changed, 144 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b16aa41507e8..e9f74eb92073 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -716,6 +716,7 @@ struct xfs_alloc_cur {
>  	struct xfs_btree_cur		*cnt;	/* btree cursors */
>  	struct xfs_btree_cur		*bnolt;
>  	struct xfs_btree_cur		*bnogt;
> +	xfs_extlen_t			cur_len;/* current search length */
>  	xfs_agblock_t			rec_bno;/* extent startblock */
>  	xfs_extlen_t			rec_len;/* extent length */
>  	xfs_agblock_t			bno;	/* alloc bno */
> @@ -740,6 +741,7 @@ xfs_alloc_cur_setup(
>  
>  	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
>  
> +	acur->cur_len = args->maxlen;
>  	acur->rec_bno = 0;
>  	acur->rec_len = 0;
>  	acur->bno = 0;
> @@ -920,6 +922,76 @@ xfs_alloc_cur_finish(
>  	return 0;
>  }
>  
> +/*
> + * Locality allocation lookup algorithm. This expects a cntbt cursor and uses
> + * bno optimized lookup to search for extents with ideal size and locality.
> + */
> +STATIC int
> +xfs_alloc_cntbt_iter(
> +	struct xfs_alloc_arg		*args,
> +	struct xfs_alloc_cur		*acur)
> +{
> +	struct xfs_btree_cur	*cur = acur->cnt;
> +	xfs_agblock_t		bno;
> +	xfs_extlen_t		len, cur_len;
> +	int			error;
> +	int			i;
> +
> +	if (!xfs_alloc_cur_active(cur))
> +		return 0;
> +
> +	/* locality optimized lookup */
> +	cur_len = acur->cur_len;
> +	error = xfs_alloc_lookup_ge(cur, args->agbno, cur_len, &i);
> +	if (error)
> +		return error;
> +	if (i == 0)
> +		return 0;
> +	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
> +	if (error)
> +		return error;
> +
> +	/* check the current record and update search length from it */
> +	error = xfs_alloc_cur_check(args, acur, cur, &i);
> +	if (error)
> +		return error;
> +	ASSERT(len >= acur->cur_len);
> +	acur->cur_len = len;
> +
> +	/*
> +	 * We looked up the first record >= [agbno, len] above. The agbno is a
> +	 * secondary key and so the current record may lie just before or after
> +	 * agbno. If it is past agbno, check the previous record too so long as
> +	 * the length matches as it may be closer. Don't check a smaller record
> +	 * because that could deactivate our cursor.
> +	 */
> +	if (bno > args->agbno) {
> +		error = xfs_btree_decrement(cur, 0, &i);
> +		if (!error && i) {
> +			error = xfs_alloc_get_rec(cur, &bno, &len, &i);
> +			if (!error && i && len == acur->cur_len)
> +				error = xfs_alloc_cur_check(args, acur, cur,
> +							    &i);
> +		}
> +		if (error)
> +			return error;
> +	}
> +
> +	/*
> +	 * Increment the search key until we find at least one allocation
> +	 * candidate or if the extent we found was larger. Otherwise, double the
> +	 * search key to optimize the search. Efficiency is more important here
> +	 * than absolute best locality.
> +	 */
> +	cur_len <<= 1;
> +	if (!acur->len || acur->cur_len >= cur_len)
> +		acur->cur_len++;
> +	else
> +		acur->cur_len = cur_len;
> +
> +	return error;
> +}
> +
>  /*
>   * Deal with the case where only small freespaces remain. Either return the
>   * contents of the last freespace record, or allocate space from the freelist if
> @@ -1261,12 +1333,11 @@ xfs_alloc_walk_iter(
>  }
>  
>  /*
> - * Search in the by-bno btree to the left and to the right simultaneously until
> - * in each case we find a large enough free extent or run into the edge of the
> - * tree. When we run into the edge of the tree, we deactivate that cursor.
> + * Search the by-bno and by-size btrees in parallel in search of an extent with
> + * ideal locality based on the NEAR mode ->agbno locality hint.
>   */
>  STATIC int
> -xfs_alloc_ag_vextent_bnobt(
> +xfs_alloc_ag_vextent_locality(
>  	struct xfs_alloc_arg	*args,
>  	struct xfs_alloc_cur	*acur,
>  	int			*stat)
> @@ -1281,6 +1352,9 @@ xfs_alloc_ag_vextent_bnobt(
>  
>  	*stat = 0;
>  
> +	error = xfs_alloc_lookup_ge(acur->cnt, args->agbno, acur->cur_len, &i);
> +	if (error)
> +		return error;
>  	error = xfs_alloc_lookup_le(acur->bnolt, args->agbno, 0, &i);
>  	if (error)
>  		return error;
> @@ -1289,12 +1363,37 @@ xfs_alloc_ag_vextent_bnobt(
>  		return error;
>  
>  	/*
> -	 * Loop going left with the leftward cursor, right with the rightward
> -	 * cursor, until either both directions give up or we find an entry at
> -	 * least as big as minlen.
> +	 * Search the bnobt and cntbt in parallel. Search the bnobt left and
> +	 * right and lookup the closest extent to the locality hint for each
> +	 * extent size key in the cntbt. The entire search terminates
> +	 * immediately on a bnobt hit because that means we've found best case
> +	 * locality. Otherwise the search continues until the cntbt cursor runs
> +	 * off the end of the tree. If no allocation candidate is found at this
> +	 * point, give up on locality, walk backwards from the end of the cntbt
> +	 * and take the first available extent.
> +	 *
> +	 * The parallel tree searches balance each other out to provide fairly
> +	 * consistent performance for various situations. The bnobt search can
> +	 * have pathological behavior in the worst case scenario of larger
> +	 * allocation requests and fragmented free space. On the other hand, the
> +	 * bnobt is able to satisfy most smaller allocation requests much more
> +	 * quickly than the cntbt. The cntbt search can sift through fragmented
> +	 * free space and sets of free extents for larger allocation requests
> +	 * more quickly than the bnobt. Since the locality hint is just a hint
> +	 * and we don't want to scan the entire bnobt for perfect locality, the
> +	 * cntbt search essentially bounds the bnobt search such that we can
> +	 * find good enough locality at reasonable performance in most cases.
>  	 */
>  	while (xfs_alloc_cur_active(acur->bnolt) ||
> -	       xfs_alloc_cur_active(acur->bnogt)) {
> +	       xfs_alloc_cur_active(acur->bnogt) ||
> +	       xfs_alloc_cur_active(acur->cnt)) {
> +
> +		trace_xfs_alloc_cur_lookup(args);
> +
> +		/*
> +		 * Search the bnobt left and right. In the case of a hit, finish
> +		 * the search in the opposite direction and we're done.
> +		 */
>  		error = xfs_alloc_walk_iter(args, acur, acur->bnolt, false,
>  					    true, 1, &i);
>  		if (error)
> @@ -1305,7 +1404,6 @@ xfs_alloc_ag_vextent_bnobt(
>  			fbinc = true;
>  			break;
>  		}
> -
>  		error = xfs_alloc_walk_iter(args, acur, acur->bnogt, true, true,
>  					    1, &i);
>  		if (error)
> @@ -1316,9 +1414,40 @@ xfs_alloc_ag_vextent_bnobt(
>  			fbinc = false;
>  			break;
>  		}
> +
> +		/*
> +		 * Check the extent with best locality based on the current
> +		 * extent size search key and keep track of the best candidate.
> +		 */
> +		error = xfs_alloc_cntbt_iter(args, acur);
> +		if (error)
> +			return error;
> +		if (!xfs_alloc_cur_active(acur->cnt)) {
> +			trace_xfs_alloc_cur_lookup_done(args);
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * If we failed to find anything due to busy extents, return empty
> +	 * handed so the caller can flush and retry. If no busy extents were
> +	 * found, walk backwards from the end of the cntbt as a last resort.
> +	 */
> +	if (!xfs_alloc_cur_active(acur->cnt) && !acur->len && !acur->busy) {
> +		error = xfs_btree_decrement(acur->cnt, 0, &i);
> +		if (error)
> +			return error;
> +		if (i) {
> +			acur->cnt->bc_private.a.priv.abt.active = true;
> +			fbcur = acur->cnt;
> +			fbinc = false;
> +		}
>  	}
>  
> -	/* search the opposite direction for a better entry */
> +	/*
> +	 * Search in the opposite direction for a better entry in the case of
> +	 * a bnobt hit or walk backwards from the end of the cntbt.
> +	 */
>  	if (fbcur) {
>  		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true, -1,
>  					    &i);
> @@ -1447,9 +1576,10 @@ xfs_alloc_ag_vextent_near(
>  	}
>  
>  	/*
> -	 * Second algorithm. Search the bnobt left and right.
> +	 * Second algorithm. Combined cntbt and bnobt search to find ideal
> +	 * locality.
>  	 */
> -	error = xfs_alloc_ag_vextent_bnobt(args, &acur, &i);
> +	error = xfs_alloc_ag_vextent_locality(args, &acur, &i);
>  	if (error)
>  		goto out;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 21fa0e8822e3..a07a5fe22218 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1645,6 +1645,8 @@ DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
>  DEFINE_ALLOC_EVENT(xfs_alloc_cur);
>  DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
>  DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
> +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup);
> +DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup_done);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
>  DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
> -- 
> 2.20.1
> 
