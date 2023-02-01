Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBE5C05027
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 22:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBAWnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 17:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBAWnS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 17:43:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07E938674
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 14:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A17C9B821C8
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 22:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0E6C433D2;
        Wed,  1 Feb 2023 22:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675291394;
        bh=y/x59KElDk0wGy9QXVtZitDbS7sul2t0ptHHe1CLEZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b9UMJFXrDNTHWBRrBsfn8YbApY4Bw142KNuRkv6foz0dnHXwpMWafr9OCIExbjIEV
         EX8q+u3ddq4XrZ4V7FnMwaXpDwNZv0YRXPi+3mexrDai0ZQrJFYV5o/UFYoaX2o5r5
         6jfCJuppiDDcTOVUyHgMAlCmQ2Ip5IkpnEYZyOO54X/K9DKqQ5OPEy2wk1I/eJnCaq
         DLR/W3wgrTIshxMbemikuM3BD56J3RypTrvAGKv3IFSWl4fOTmWnLSaoDkvfvZoqHN
         EzTUpE53TNDGlruSC0ktYIZdygpVpztutMmALIHoE/pZsvsaBZ3shGkgfCzftW8c4Q
         5QiyUtZ+gmdqA==
Date:   Wed, 1 Feb 2023 14:43:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/42] xfs: use xfs_alloc_vextent_first_ag() where
 appropriate
Message-ID: <Y9rrAam9LzgERBYY@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-21-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-21-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:43AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Change obvious callers of single AG allocation to use
> xfs_alloc_vextent_first_ag(). This gets rid of
> XFS_ALLOCTYPE_FIRST_AG as the type used within
> xfs_alloc_vextent_first_ag() during iteration is _THIS_AG. Hence we
> can remove the setting of args->type from all the callers of
> _first_ag() and remove the alloctype.
> 
> While doing this, pass the allocation target fsb as a parameter
> rather than encoding it in args->fsbno. This starts the process
> of making args->fsbno an output only variable rather than
> input/output.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 35 +++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_alloc.h | 10 ++++++++--
>  fs/xfs/libxfs/xfs_bmap.c  | 31 ++++++++++++++++---------------
>  3 files changed, 43 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 28b79facf2e3..186ce3aee9e0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3183,7 +3183,8 @@ xfs_alloc_read_agf(
>   */
>  static int
>  xfs_alloc_vextent_check_args(
> -	struct xfs_alloc_arg	*args)
> +	struct xfs_alloc_arg	*args,
> +	xfs_rfsblock_t		target)

Isn't xfs_rfsblock_t supposed to be used to measure quantities of raw fs
blocks, and not the segmented agno/agbno numbers that we encode in most
places?

>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agblock_t		agsize;
> @@ -3201,13 +3202,13 @@ xfs_alloc_vextent_check_args(
>  		args->maxlen = agsize;
>  	if (args->alignment == 0)
>  		args->alignment = 1;
> -	ASSERT(XFS_FSB_TO_AGNO(mp, args->fsbno) < mp->m_sb.sb_agcount);
> -	ASSERT(XFS_FSB_TO_AGBNO(mp, args->fsbno) < agsize);
> +	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
> +	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);

Yes, I think @target should be xfs_fsblock_t since we pass it to
XFS_FSB_TO_AG{,B}NO here.

>  	ASSERT(args->minlen <= args->maxlen);
>  	ASSERT(args->minlen <= agsize);
>  	ASSERT(args->mod < args->prod);
> -	if (XFS_FSB_TO_AGNO(mp, args->fsbno) >= mp->m_sb.sb_agcount ||
> -	    XFS_FSB_TO_AGBNO(mp, args->fsbno) >= agsize ||
> +	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
> +	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
>  	    args->minlen > args->maxlen || args->minlen > agsize ||
>  	    args->mod >= args->prod) {
>  		args->fsbno = NULLFSBLOCK;
> @@ -3281,7 +3282,7 @@ xfs_alloc_vextent_this_ag(
>  	if (args->tp->t_highest_agno != NULLAGNUMBER)
>  		minimum_agno = args->tp->t_highest_agno;
>  
> -	error = xfs_alloc_vextent_check_args(args);
> +	error = xfs_alloc_vextent_check_args(args, args->fsbno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> @@ -3406,7 +3407,7 @@ xfs_alloc_vextent_start_ag(
>  	bool			bump_rotor = false;
>  	int			error;
>  
> -	error = xfs_alloc_vextent_check_args(args);
> +	error = xfs_alloc_vextent_check_args(args, args->fsbno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> @@ -3444,25 +3445,29 @@ xfs_alloc_vextent_start_ag(
>   * filesystem attempting blocking allocation. This does not wrap or try a second
>   * pass, so will not recurse into AGs lower than indicated by fsbno.
>   */
> -static int
> -xfs_alloc_vextent_first_ag(
> +int
> + xfs_alloc_vextent_first_ag(
>  	struct xfs_alloc_arg	*args,
> -	xfs_agnumber_t		minimum_agno)
> -{
> +	xfs_rfsblock_t		target)
> + {

Extra spaces here, and seemingly another variable that ought to be
xfs_fsblock_t?

--D

>  	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		minimum_agno = 0;
>  	xfs_agnumber_t		start_agno;
>  	int			error;
>  
> -	error = xfs_alloc_vextent_check_args(args);
> +	if (args->tp->t_highest_agno != NULLAGNUMBER)
> +		minimum_agno = args->tp->t_highest_agno;
> +
> +	error = xfs_alloc_vextent_check_args(args, target);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
>  		return error;
>  	}
>  
> -	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
> -
> +	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
>  	args->type = XFS_ALLOCTYPE_THIS_AG;
> +	args->fsbno = target;
>  	error =  xfs_alloc_vextent_iterate_ags(args, minimum_agno,
>  			start_agno, 0);
>  	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
> @@ -3495,8 +3500,6 @@ xfs_alloc_vextent(
>  		break;
>  	case XFS_ALLOCTYPE_START_BNO:
>  		return xfs_alloc_vextent_start_ag(args, minimum_agno);
> -	case XFS_ALLOCTYPE_FIRST_AG:
> -		return xfs_alloc_vextent_first_ag(args, minimum_agno);
>  	default:
>  		error = -EFSCORRUPTED;
>  		ASSERT(0);
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 0a9ad6cd18e2..73697dd3ca55 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -19,7 +19,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>  /*
>   * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
>   */
> -#define XFS_ALLOCTYPE_FIRST_AG	0x02	/* ... start at ag 0 */
>  #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
>  #define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
>  #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
> @@ -29,7 +28,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>  typedef unsigned int xfs_alloctype_t;
>  
>  #define XFS_ALLOC_TYPES \
> -	{ XFS_ALLOCTYPE_FIRST_AG,	"FIRST_AG" }, \
>  	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
>  	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
>  	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
> @@ -130,6 +128,14 @@ xfs_alloc_vextent(
>   */
>  int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
>  
> +/*
> + * Iterate from the AG indicated from args->fsbno through to the end of the
> + * filesystem attempting blocking allocation. This is for use in last
> + * resort allocation attempts when everything else has failed.
> + */
> +int xfs_alloc_vextent_first_ag(struct xfs_alloc_arg *args,
> +		xfs_rfsblock_t target);
> +
>  /*
>   * Free an extent.
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cdf3b551ef7b..eb3dc8d5319b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3248,13 +3248,6 @@ xfs_bmap_btalloc_filestreams(
>  	int			notinit = 0;
>  	int			error;
>  
> -	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> -		args->type = XFS_ALLOCTYPE_FIRST_AG;
> -		args->total = ap->minlen;
> -		args->minlen = ap->minlen;
> -		return 0;
> -	}
> -
>  	args->type = XFS_ALLOCTYPE_NEAR_BNO;
>  	args->total = ap->total;
>  
> @@ -3462,9 +3455,7 @@ xfs_bmap_exact_minlen_extent_alloc(
>  	 */
>  	ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
>  
> -	args.fsbno = ap->blkno;
>  	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
> -	args.type = XFS_ALLOCTYPE_FIRST_AG;
>  	args.minlen = args.maxlen = ap->minlen;
>  	args.total = ap->total;
>  
> @@ -3476,7 +3467,7 @@ xfs_bmap_exact_minlen_extent_alloc(
>  	args.resv = XFS_AG_RESV_NONE;
>  	args.datatype = ap->datatype;
>  
> -	error = xfs_alloc_vextent(&args);
> +	error = xfs_alloc_vextent_first_ag(&args, ap->blkno);
>  	if (error)
>  		return error;
>  
> @@ -3623,10 +3614,21 @@ xfs_bmap_btalloc_best_length(
>  	 * size to the largest space found.
>  	 */
>  	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> -	    xfs_inode_is_filestream(ap->ip))
> +	    xfs_inode_is_filestream(ap->ip)) {
> +		/*
> +		 * If there is very little free space before we start a
> +		 * filestreams allocation, we're almost guaranteed to fail to
> +		 * find an AG with enough contiguous free space to succeed, so
> +		 * just go straight to the low space algorithm.
> +		 */
> +		if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> +			args->minlen = ap->minlen;
> +			goto critically_low_space;
> +		}
>  		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
> -	else
> +	} else {
>  		error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
> +	}
>  	if (error)
>  		return error;
>  
> @@ -3673,10 +3675,9 @@ xfs_bmap_btalloc_best_length(
>  	 * so they don't waste time on allocation modes that are unlikely to
>  	 * succeed.
>  	 */
> -	args->fsbno = 0;
> -	args->type = XFS_ALLOCTYPE_FIRST_AG;
> +critically_low_space:
>  	args->total = ap->minlen;
> -	error = xfs_alloc_vextent(args);
> +	error = xfs_alloc_vextent_first_ag(args, 0);
>  	if (error)
>  		return error;
>  	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
> -- 
> 2.39.0
> 
