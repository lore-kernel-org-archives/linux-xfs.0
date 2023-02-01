Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321A6C636D3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 22:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjBAWvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 17:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjBAWva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 17:51:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9C26BBC4
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 14:51:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6276195A
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 22:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B348C433EF;
        Wed,  1 Feb 2023 22:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675291884;
        bh=6Gzn5DYq5gMRODNBDjcepavO0yBMuyVH3tmI7zaQhCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TDyEujgDJVh08I1OTxm9Q5I3NFGqaeUEsbIZY+mHhiO1Cf1d4NHQr20kgdoZI3eZM
         1tlg54a9a9vRjZrxJUrtT6JPUVJew08y0yAqN/8D4YNGZcNdpEp7XdjCDguF98IsKz
         PBKG0nQ4Re26vnJGL6OEYLJLnuSwHNoMr8aP3GLaaWyfkko1ZF1MKEJnxLAFPU6v9s
         tAoHqzGZdqn+3AlIcgHsCp8gMMYV5xIXH1uApJY+WAIY2E4EXeHyTLK/F2tEg7dy2Z
         JMiRHX+FQcMT7l9AvjRKyV39uf4n2qzkepmNTaHl53u9GAzrDhtLBp0FwGXJ8A9WW/
         U8wVpJDgiVLog==
Date:   Wed, 1 Feb 2023 14:51:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/42] xfs: use xfs_alloc_vextent_start_bno() where
 appropriate
Message-ID: <Y9rs68OoaskIAXsd@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-22-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:44AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Change obvious callers of single AG allocation to use
> xfs_alloc_vextent_start_bno(). Callers no long need to specify
> XFS_ALLOCTYPE_START_BNO, and so the type can be driven inward and
> removed.
> 
> While doing this, also pass the allocation target fsb as a parameter
> rather than encoding it in args->fsbno.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c      | 24 ++++++++++---------
>  fs/xfs/libxfs/xfs_alloc.h      | 13 ++++++++--
>  fs/xfs/libxfs/xfs_bmap.c       | 43 ++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_bmap_btree.c |  9 ++-----
>  4 files changed, 51 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 186ce3aee9e0..294f80d596d9 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3189,7 +3189,6 @@ xfs_alloc_vextent_check_args(
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agblock_t		agsize;
>  
> -	args->otype = args->type;
>  	args->agbno = NULLAGBLOCK;
>  
>  	/*
> @@ -3345,7 +3344,7 @@ xfs_alloc_vextent_iterate_ags(
>  		trace_xfs_alloc_vextent_loopfailed(args);
>  
>  		if (args->agno == start_agno &&
> -		    args->otype == XFS_ALLOCTYPE_START_BNO)
> +		    args->otype == XFS_ALLOCTYPE_NEAR_BNO)
>  			args->type = XFS_ALLOCTYPE_THIS_AG;
>  
>  		/*
> @@ -3373,7 +3372,7 @@ xfs_alloc_vextent_iterate_ags(
>  			}
>  
>  			flags = 0;
> -			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
> +			if (args->otype == XFS_ALLOCTYPE_NEAR_BNO) {
>  				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
>  				args->type = XFS_ALLOCTYPE_NEAR_BNO;
>  			}
> @@ -3396,18 +3395,22 @@ xfs_alloc_vextent_iterate_ags(
>   * otherwise will wrap back to the start AG and run a second blocking pass to
>   * the end of the filesystem.
>   */
> -static int
> +int
>  xfs_alloc_vextent_start_ag(
>  	struct xfs_alloc_arg	*args,
> -	xfs_agnumber_t		minimum_agno)
> +	xfs_rfsblock_t		target)

Same xfs_fsblock_t vs. xfs_rfsblock_t comment as the last patch.  The
rest looks ok though.

--D

>  {
>  	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		minimum_agno = 0;
>  	xfs_agnumber_t		start_agno;
>  	xfs_agnumber_t		rotorstep = xfs_rotorstep;
>  	bool			bump_rotor = false;
>  	int			error;
>  
> -	error = xfs_alloc_vextent_check_args(args, args->fsbno);
> +	if (args->tp->t_highest_agno != NULLAGNUMBER)
> +		minimum_agno = args->tp->t_highest_agno;
> +
> +	error = xfs_alloc_vextent_check_args(args, target);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> @@ -3416,14 +3419,15 @@ xfs_alloc_vextent_start_ag(
>  
>  	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
>  	    xfs_is_inode32(mp)) {
> -		args->fsbno = XFS_AGB_TO_FSB(mp,
> +		target = XFS_AGB_TO_FSB(mp,
>  				((mp->m_agfrotor / rotorstep) %
>  				mp->m_sb.sb_agcount), 0);
>  		bump_rotor = 1;
>  	}
> -	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, args->fsbno));
> -	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
> +	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
> +	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
>  	args->type = XFS_ALLOCTYPE_NEAR_BNO;
> +	args->fsbno = target;
>  
>  	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
>  			XFS_ALLOC_FLAG_TRYLOCK);
> @@ -3498,8 +3502,6 @@ xfs_alloc_vextent(
>  		error = xfs_alloc_vextent_this_ag(args);
>  		xfs_perag_put(args->pag);
>  		break;
> -	case XFS_ALLOCTYPE_START_BNO:
> -		return xfs_alloc_vextent_start_ag(args, minimum_agno);
>  	default:
>  		error = -EFSCORRUPTED;
>  		ASSERT(0);
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index 73697dd3ca55..5487dff3d68a 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -20,7 +20,6 @@ unsigned int xfs_agfl_size(struct xfs_mount *mp);
>   * Freespace allocation types.  Argument to xfs_alloc_[v]extent.
>   */
>  #define XFS_ALLOCTYPE_THIS_AG	0x08	/* anywhere in this a.g. */
> -#define XFS_ALLOCTYPE_START_BNO	0x10	/* near this block else anywhere */
>  #define XFS_ALLOCTYPE_NEAR_BNO	0x20	/* in this a.g. and near this block */
>  #define XFS_ALLOCTYPE_THIS_BNO	0x40	/* at exactly this block */
>  
> @@ -29,7 +28,6 @@ typedef unsigned int xfs_alloctype_t;
>  
>  #define XFS_ALLOC_TYPES \
>  	{ XFS_ALLOCTYPE_THIS_AG,	"THIS_AG" }, \
> -	{ XFS_ALLOCTYPE_START_BNO,	"START_BNO" }, \
>  	{ XFS_ALLOCTYPE_NEAR_BNO,	"NEAR_BNO" }, \
>  	{ XFS_ALLOCTYPE_THIS_BNO,	"THIS_BNO" }
>  
> @@ -128,6 +126,17 @@ xfs_alloc_vextent(
>   */
>  int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
>  
> +/*
> + * Best effort full filesystem allocation scan.
> + *
> + * Locality aware allocation will be attempted in the initial AG, but on failure
> + * non-localised attempts will be made. The AGs are constrained by previous
> + * allocations in the current transaction. Two passes will be made - the first
> + * non-blocking, the second blocking.
> + */
> +int xfs_alloc_vextent_start_ag(struct xfs_alloc_arg *args,
> +		xfs_rfsblock_t target);
> +
>  /*
>   * Iterate from the AG indicated from args->fsbno through to the end of the
>   * filesystem attempting blocking allocation. This is for use in last
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index eb3dc8d5319b..aefcdf2bfd57 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -646,12 +646,11 @@ xfs_bmap_extents_to_btree(
>  	args.mp = mp;
>  	xfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino, whichfork);
>  
> -	args.type = XFS_ALLOCTYPE_START_BNO;
> -	args.fsbno = XFS_INO_TO_FSB(mp, ip->i_ino);
>  	args.minlen = args.maxlen = args.prod = 1;
>  	args.wasdel = wasdel;
>  	*logflagsp = 0;
> -	error = xfs_alloc_vextent(&args);
> +	error = xfs_alloc_vextent_start_ag(&args,
> +				XFS_INO_TO_FSB(mp, ip->i_ino));
>  	if (error)
>  		goto out_root_realloc;
>  
> @@ -792,15 +791,15 @@ xfs_bmap_local_to_extents(
>  	args.total = total;
>  	args.minlen = args.maxlen = args.prod = 1;
>  	xfs_rmap_ino_owner(&args.oinfo, ip->i_ino, whichfork, 0);
> +
>  	/*
>  	 * Allocate a block.  We know we need only one, since the
>  	 * file currently fits in an inode.
>  	 */
> -	args.fsbno = XFS_INO_TO_FSB(args.mp, ip->i_ino);
> -	args.type = XFS_ALLOCTYPE_START_BNO;
>  	args.total = total;
>  	args.minlen = args.maxlen = args.prod = 1;
> -	error = xfs_alloc_vextent(&args);
> +	error = xfs_alloc_vextent_start_ag(&args,
> +			XFS_INO_TO_FSB(args.mp, ip->i_ino));
>  	if (error)
>  		goto done;
>  
> @@ -3208,7 +3207,6 @@ xfs_bmap_btalloc_select_lengths(
>  	int			notinit = 0;
>  	int			error = 0;
>  
> -	args->type = XFS_ALLOCTYPE_START_BNO;
>  	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
>  		args->total = ap->minlen;
>  		args->minlen = ap->minlen;
> @@ -3500,7 +3498,8 @@ xfs_bmap_btalloc_at_eof(
>  	struct xfs_bmalloca	*ap,
>  	struct xfs_alloc_arg	*args,
>  	xfs_extlen_t		blen,
> -	int			stripe_align)
> +	int			stripe_align,
> +	bool			ag_only)
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_alloctype_t		atype;
> @@ -3565,7 +3564,10 @@ xfs_bmap_btalloc_at_eof(
>  		args->minalignslop = 0;
>  	}
>  
> -	error = xfs_alloc_vextent(args);
> +	if (ag_only)
> +		error = xfs_alloc_vextent(args);
> +	else
> +		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  	if (error)
>  		return error;
>  
> @@ -3591,13 +3593,17 @@ xfs_bmap_btalloc_best_length(
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_extlen_t		blen = 0;
> +	bool			is_filestream = false;
>  	int			error;
>  
> +	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> +	    xfs_inode_is_filestream(ap->ip))
> +		is_filestream = true;
> +
>  	/*
>  	 * Determine the initial block number we will target for allocation.
>  	 */
> -	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> -	    xfs_inode_is_filestream(ap->ip)) {
> +	if (is_filestream) {
>  		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
>  		if (agno == NULLAGNUMBER)
>  			agno = 0;
> @@ -3613,8 +3619,7 @@ xfs_bmap_btalloc_best_length(
>  	 * the request.  If one isn't found, then adjust the minimum allocation
>  	 * size to the largest space found.
>  	 */
> -	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
> -	    xfs_inode_is_filestream(ap->ip)) {
> +	if (is_filestream) {
>  		/*
>  		 * If there is very little free space before we start a
>  		 * filestreams allocation, we're almost guaranteed to fail to
> @@ -3639,14 +3644,18 @@ xfs_bmap_btalloc_best_length(
>  	 * trying.
>  	 */
>  	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
> -		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
> +		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align,
> +				is_filestream);
>  		if (error)
>  			return error;
>  		if (args->fsbno != NULLFSBLOCK)
>  			return 0;
>  	}
>  
> -	error = xfs_alloc_vextent(args);
> +	if (is_filestream)
> +		error = xfs_alloc_vextent(args);
> +	else
> +		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  	if (error)
>  		return error;
>  	if (args->fsbno != NULLFSBLOCK)
> @@ -3658,9 +3667,7 @@ xfs_bmap_btalloc_best_length(
>  	 */
>  	if (args->minlen > ap->minlen) {
>  		args->minlen = ap->minlen;
> -		args->type = XFS_ALLOCTYPE_START_BNO;
> -		args->fsbno = ap->blkno;
> -		error = xfs_alloc_vextent(args);
> +		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index d42c1a1da1fc..b8ad95050c9b 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -214,9 +214,6 @@ xfs_bmbt_alloc_block(
>  	if (!args.wasdel && args.tp->t_blk_res == 0)
>  		return -ENOSPC;
>  
> -	args.fsbno = be64_to_cpu(start->l);
> -	args.type = XFS_ALLOCTYPE_START_BNO;
> -
>  	/*
>  	 * If we are coming here from something like unwritten extent
>  	 * conversion, there has been no data extent allocation already done, so
> @@ -227,7 +224,7 @@ xfs_bmbt_alloc_block(
>  		args.minleft = xfs_bmapi_minleft(cur->bc_tp, cur->bc_ino.ip,
>  					cur->bc_ino.whichfork);
>  
> -	error = xfs_alloc_vextent(&args);
> +	error = xfs_alloc_vextent_start_ag(&args, be64_to_cpu(start->l));
>  	if (error)
>  		return error;
>  
> @@ -237,10 +234,8 @@ xfs_bmbt_alloc_block(
>  		 * a full btree split.  Try again and if
>  		 * successful activate the lowspace algorithm.
>  		 */
> -		args.fsbno = 0;
>  		args.minleft = 0;
> -		args.type = XFS_ALLOCTYPE_START_BNO;
> -		error = xfs_alloc_vextent(&args);
> +		error = xfs_alloc_vextent_start_ag(&args, 0);
>  		if (error)
>  			return error;
>  		cur->bc_tp->t_flags |= XFS_TRANS_LOWMODE;
> -- 
> 2.39.0
> 
