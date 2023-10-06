Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D55FE92FE4
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Oct 2023 05:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjJFF40 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Oct 2023 01:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjJFF4Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2023 01:56:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99FCCA
        for <linux-xfs@vger.kernel.org>; Thu,  5 Oct 2023 22:56:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46381C433C8;
        Fri,  6 Oct 2023 05:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696571783;
        bh=ulpmygSRYQXcOWxJ+tyWYWI8vIDPm7YgojjzRrMvzc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TIo152xbVmX5+7+ULdZgxQHRQNQ/oLs8rwdkceY6Xm5LpACoOmDxQWH8oyJ+rAhWz
         zzLxI831s7kcZkLxGAlSNxhgLpzO5OHUK+A3J9LA2uXRcj6LzGtbjGHEvZ3kd6KyXo
         igKkWHqmYh9rJUORbOMxCIARHI8N831c+RelPyBQs/JRlb1wl8+m84vybhGhIWOC7y
         GGs9FUgv5rV+eJhoHxcoFg6wR2aLOgoD4k2UhZylO0cQQ9L8E1D5CBRmoQhKvMgLct
         x44/xVbLhOd/hVpO6DfeAvHEsOMWpM3dAgd1vBh0IZ0j33uQK6olQCUkKN3MC8YDMd
         GWgPjH115Ihdw==
Date:   Thu, 5 Oct 2023 22:56:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 6/9] xfs: use agno/agbno in xfs_alloc_vextent functions
Message-ID: <20231006055622.GV21298@frogsfrogsfrogs>
References: <20231004001943.349265-1-david@fromorbit.com>
 <20231004001943.349265-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231004001943.349265-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2023 at 11:19:40AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We're moving away from using xfs_fsblock_t to define allocation
> targets, and instead we are using {agno,agbno} tuples instead. This
> will allow us to eventually move everything to {perag,agbno}. But
> before we get there, we need to split the fsblock into {agno,agbno}
> and convert the code to use those first.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks promising,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 57 +++++++++++++++++++++------------------
>  1 file changed, 31 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 3069194527dd..289b54911b05 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3249,7 +3249,8 @@ xfs_alloc_read_agf(
>  static int
>  xfs_alloc_vextent_check_args(
>  	struct xfs_alloc_arg	*args,
> -	xfs_fsblock_t		target,
> +	xfs_agnumber_t		target_agno,
> +	xfs_agblock_t		target_agbno,
>  	xfs_agnumber_t		*minimum_agno)
>  {
>  	struct xfs_mount	*mp = args->mp;
> @@ -3277,14 +3278,14 @@ xfs_alloc_vextent_check_args(
>  	ASSERT(args->alignment > 0);
>  	ASSERT(args->resv != XFS_AG_RESV_AGFL);
>  
> -	ASSERT(XFS_FSB_TO_AGNO(mp, target) < mp->m_sb.sb_agcount);
> -	ASSERT(XFS_FSB_TO_AGBNO(mp, target) < agsize);
> +	ASSERT(target_agno < mp->m_sb.sb_agcount);
> +	ASSERT(target_agbno < agsize);
>  	ASSERT(args->minlen <= args->maxlen);
>  	ASSERT(args->minlen <= agsize);
>  	ASSERT(args->mod < args->prod);
>  
> -	if (XFS_FSB_TO_AGNO(mp, target) >= mp->m_sb.sb_agcount ||
> -	    XFS_FSB_TO_AGBNO(mp, target) >= agsize ||
> +	if (target_agno >= mp->m_sb.sb_agcount ||
> +	    target_agbno >= agsize ||
>  	    args->minlen > args->maxlen || args->minlen > agsize ||
>  	    args->mod >= args->prod) {
>  		trace_xfs_alloc_vextent_badargs(args);
> @@ -3438,7 +3439,6 @@ xfs_alloc_vextent_this_ag(
>  	struct xfs_alloc_arg	*args,
>  	xfs_agnumber_t		agno)
>  {
> -	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
>  	uint32_t		alloc_flags = 0;
>  	int			error;
> @@ -3451,8 +3451,7 @@ xfs_alloc_vextent_this_ag(
>  
>  	trace_xfs_alloc_vextent_this_ag(args);
>  
> -	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
> -			&minimum_agno);
> +	error = xfs_alloc_vextent_check_args(args, agno, 0, &minimum_agno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> @@ -3563,7 +3562,8 @@ xfs_alloc_vextent_start_ag(
>  {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
> -	xfs_agnumber_t		start_agno;
> +	xfs_agnumber_t		target_agno;
> +	xfs_agblock_t		target_agbno;
>  	xfs_agnumber_t		rotorstep = xfs_rotorstep;
>  	bool			bump_rotor = false;
>  	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
> @@ -3576,7 +3576,10 @@ xfs_alloc_vextent_start_ag(
>  
>  	trace_xfs_alloc_vextent_start_ag(args);
>  
> -	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
> +	target_agno = XFS_FSB_TO_AGNO(mp, target);
> +	target_agbno = XFS_FSB_TO_AGBNO(mp, target);
> +	error = xfs_alloc_vextent_check_args(args, target_agno, target_agbno,
> +			&minimum_agno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> @@ -3591,12 +3594,11 @@ xfs_alloc_vextent_start_ag(
>  		bump_rotor = 1;
>  	}
>  
> -	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
> -	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
> -			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
> -
> +	target_agno = max(minimum_agno, target_agno);
> +	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, target_agno,
> +			target_agbno, alloc_flags);
>  	if (bump_rotor) {
> -		if (args->agno == start_agno)
> +		if (args->agno == target_agno)
>  			mp->m_agfrotor = (mp->m_agfrotor + 1) %
>  				(mp->m_sb.sb_agcount * rotorstep);
>  		else
> @@ -3619,7 +3621,8 @@ xfs_alloc_vextent_first_ag(
>   {
>  	struct xfs_mount	*mp = args->mp;
>  	xfs_agnumber_t		minimum_agno;
> -	xfs_agnumber_t		start_agno;
> +	xfs_agnumber_t		target_agno;
> +	xfs_agblock_t		target_agbno;
>  	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	int			error;
>  
> @@ -3630,16 +3633,19 @@ xfs_alloc_vextent_first_ag(
>  
>  	trace_xfs_alloc_vextent_first_ag(args);
>  
> -	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
> +	target_agno = XFS_FSB_TO_AGNO(mp, target);
> +	target_agbno = XFS_FSB_TO_AGBNO(mp, target);
> +	error = xfs_alloc_vextent_check_args(args, target_agno, target_agbno,
> +			&minimum_agno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
>  		return error;
>  	}
>  
> -	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
> -	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
> -			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
> +	target_agno = max(minimum_agno, target_agno);
> +	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, target_agno,
> +			target_agbno, alloc_flags);
>  	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
>  }
>  
> @@ -3656,15 +3662,13 @@ xfs_alloc_vextent_exact_bno(
>  	xfs_agnumber_t		minimum_agno;
>  	int			error;
>  
> -	ASSERT(args->pag != NULL);
> -	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
> -
> -	args->agno = XFS_FSB_TO_AGNO(mp, target);
> +	args->agno = args->pag->pag_agno;
>  	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
>  
>  	trace_xfs_alloc_vextent_exact_bno(args);
>  
> -	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
> +	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
> +			&minimum_agno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> @@ -3703,7 +3707,8 @@ xfs_alloc_vextent_near_bno(
>  
>  	trace_xfs_alloc_vextent_near_bno(args);
>  
> -	error = xfs_alloc_vextent_check_args(args, target, &minimum_agno);
> +	error = xfs_alloc_vextent_check_args(args, args->agno, args->agbno,
> +			&minimum_agno);
>  	if (error) {
>  		if (error == -ENOSPC)
>  			return 0;
> -- 
> 2.40.1
> 
