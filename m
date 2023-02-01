Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EACDC05027
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 19:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbjBAT26 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 14:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBAT26 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 14:28:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BA4820D5
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 11:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FBC46192C
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 19:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85ADC433EF;
        Wed,  1 Feb 2023 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675279735;
        bh=lUf+BNuXiQr9WynIJuaMVm0Aq5FSCpBETM0UpS27uAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gNtUPozgyNC1Vrje4iaNRQSP+BRLxMmECOp0akjA6GY4VZYYsA9ClVlD7mnuBc5aM
         dPr5MGkpNg4SZSrJleVQ8wz3x9jHOzDwsims9/4Mzblz0p8X2FGUamT9X2Lglmx9ja
         uwX58hG9kQi6H143sVji6eGvQBVlN7ECqGvUIuHjTBnAtRzhpyoPTSj6WvuB7VFRZk
         ldKX9opaKM70GZOs7zfrf+2LPtZN8C+BuUqQmAvy2poOvwaaAq6cOCYNLY9D07pYSn
         FjugJ3ouuca/WnxznVyPsPc8zywUR5OizCkYMHmGZo8OGRrlxwUHkCKyM2i+ZlML3B
         Q/m5dCuP5l5Jw==
Date:   Wed, 1 Feb 2023 11:28:55 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/42] xfs: introduce xfs_for_each_perag_wrap()
Message-ID: <Y9q9dynRpYDmN4sK@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-15-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:44:37AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In several places we iterate every AG from a specific start agno and
> wrap back to the first AG when we reach the end of the filesystem to
> continue searching. We don't have a primitive for this iteration
> yet, so add one for conversion of these algorithms to per-ag based
> iteration.
> 
> The filestream AG select code is a mess, and this initially makes it
> worse. The per-ag selection needs to be driven completely into the
> filestream code to clean this up and it will be done in a future
> patch that makes the filestream allocator use active per-ag
> references correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h     | 45 +++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_bmap.c   | 76 ++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++--------
>  3 files changed, 104 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 187d30d9bb13..8f43b91d4cf3 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -237,7 +237,6 @@ xfs_perag_next(
>  #define for_each_perag_from(mp, agno, pag) \
>  	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
>  
> -
>  #define for_each_perag(mp, agno, pag) \
>  	(agno) = 0; \
>  	for_each_perag_from((mp), (agno), (pag))
> @@ -249,6 +248,50 @@ xfs_perag_next(
>  		xfs_perag_rele(pag), \
>  		(pag) = xfs_perag_grab_tag((mp), (agno), (tag)))
>  
> +static inline struct xfs_perag *
> +xfs_perag_next_wrap(
> +	struct xfs_perag	*pag,
> +	xfs_agnumber_t		*agno,
> +	xfs_agnumber_t		stop_agno,
> +	xfs_agnumber_t		wrap_agno)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	*agno = pag->pag_agno + 1;
> +	xfs_perag_rele(pag);
> +	while (*agno != stop_agno) {
> +		if (*agno >= wrap_agno)
> +			*agno = 0;
> +		if (*agno == stop_agno)
> +			break;
> +
> +		pag = xfs_perag_grab(mp, *agno);
> +		if (pag)
> +			return pag;
> +		(*agno)++;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Iterate all AGs from start_agno through wrap_agno, then 0 through
> + * (start_agno - 1).
> + */
> +#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
> +	for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
> +		(pag) != NULL; \
> +		(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
> +				(wrap_agno)))
> +
> +/*
> + * Iterate all AGs from start_agno through to the end of the filesystem, then 0
> + * through (start_agno - 1).
> + */
> +#define for_each_perag_wrap(mp, start_agno, agno, pag) \
> +	for_each_perag_wrap_at((mp), (start_agno), (mp)->m_sb.sb_agcount, \
> +				(agno), (pag))

This seems like a useful new iterator.  I like that the opencoded loops
finally got cleaned up.

> +
> +
>  struct aghdr_init_data {
>  	/* per ag data */
>  	xfs_agblock_t		agno;		/* ag to init */
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6aad0ea5e606..e5519abbfa0d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c

<snip>

> @@ -3218,21 +3214,21 @@ xfs_bmap_btalloc_select_lengths(
>  	}
>  
>  	args->total = ap->total;
> -	startag = ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
> +	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
>  	if (startag == NULLAGNUMBER)
> -		startag = ag = 0;
> +		startag = 0;
>  
> -	while (*blen < args->maxlen) {
> -		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
> +	*blen = 0;
> +	for_each_perag_wrap(mp, startag, agno, pag) {
> +		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
>  						     &notinit);
>  		if (error)
> -			return error;
> -
> -		if (++ag == mp->m_sb.sb_agcount)
> -			ag = 0;
> -		if (ag == startag)
> +			break;
> +		if (*blen >= args->maxlen)
>  			break;
>  	}
> +	if (pag)
> +		xfs_perag_rele(pag);
>  
>  	xfs_bmap_select_minlen(ap, args, blen, notinit);
>  	return 0;

Same question as Allison -- if xfs_bmap_longest_free_extent returned a
non-EAGAIN error code, don't we want to return that to the caller?

--D

> @@ -3245,7 +3241,8 @@ xfs_bmap_btalloc_filestreams(
>  	xfs_extlen_t		*blen)
>  {
>  	struct xfs_mount	*mp = ap->ip->i_mount;
> -	xfs_agnumber_t		ag;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		start_agno;
>  	int			notinit = 0;
>  	int			error;
>  
> @@ -3259,33 +3256,50 @@ xfs_bmap_btalloc_filestreams(
>  	args->type = XFS_ALLOCTYPE_NEAR_BNO;
>  	args->total = ap->total;
>  
> -	ag = XFS_FSB_TO_AGNO(mp, args->fsbno);
> -	if (ag == NULLAGNUMBER)
> -		ag = 0;
> +	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
> +	if (start_agno == NULLAGNUMBER)
> +		start_agno = 0;
>  
> -	error = xfs_bmap_longest_free_extent(args->tp, ag, blen, &notinit);
> -	if (error)
> -		return error;
> +	pag = xfs_perag_grab(mp, start_agno);
> +	if (pag) {
> +		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
> +				&notinit);
> +		xfs_perag_rele(pag);
> +		if (error)
> +			return error;
> +	}
>  
>  	if (*blen < args->maxlen) {
> -		error = xfs_filestream_new_ag(ap, &ag);
> +		xfs_agnumber_t	agno = start_agno;
> +
> +		error = xfs_filestream_new_ag(ap, &agno);
>  		if (error)
>  			return error;
> +		if (agno == NULLAGNUMBER)
> +			goto out_select;
>  
> -		error = xfs_bmap_longest_free_extent(args->tp, ag, blen,
> -						     &notinit);
> +		pag = xfs_perag_grab(mp, agno);
> +		if (!pag)
> +			goto out_select;
> +
> +		error = xfs_bmap_longest_free_extent(pag, args->tp,
> +				blen, &notinit);
> +		xfs_perag_rele(pag);
>  		if (error)
>  			return error;
>  
> +		start_agno = agno;
> +
>  	}
>  
> +out_select:
>  	xfs_bmap_select_minlen(ap, args, blen, notinit);
>  
>  	/*
>  	 * Set the failure fallback case to look in the selected AG as stream
>  	 * may have moved.
>  	 */
> -	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
> +	ap->blkno = args->fsbno = XFS_AGB_TO_FSB(mp, start_agno, 0);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2a323ffa5ba9..50fef3f5af51 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1725,7 +1725,7 @@ xfs_dialloc(
>  	bool			ok_alloc = true;
>  	bool			low_space = false;
>  	int			flags;
> -	xfs_ino_t		ino;
> +	xfs_ino_t		ino = NULLFSINO;
>  
>  	/*
>  	 * Directories, symlinks, and regular files frequently allocate at least
> @@ -1773,39 +1773,37 @@ xfs_dialloc(
>  	 * or in which we can allocate some inodes.  Iterate through the
>  	 * allocation groups upward, wrapping at the end.
>  	 */
> -	agno = start_agno;
>  	flags = XFS_ALLOC_FLAG_TRYLOCK;
> -	for (;;) {
> -		pag = xfs_perag_grab(mp, agno);
> +retry:
> +	for_each_perag_wrap_at(mp, start_agno, mp->m_maxagi, agno, pag) {
>  		if (xfs_dialloc_good_ag(pag, *tpp, mode, flags, ok_alloc)) {
>  			error = xfs_dialloc_try_ag(pag, tpp, parent,
>  					&ino, ok_alloc);
>  			if (error != -EAGAIN)
>  				break;
> +			error = 0;
>  		}
>  
>  		if (xfs_is_shutdown(mp)) {
>  			error = -EFSCORRUPTED;
>  			break;
>  		}
> -		if (++agno == mp->m_maxagi)
> -			agno = 0;
> -		if (agno == start_agno) {
> -			if (!flags) {
> -				error = -ENOSPC;
> -				break;
> -			}
> +	}
> +	if (pag)
> +		xfs_perag_rele(pag);
> +	if (error)
> +		return error;
> +	if (ino == NULLFSINO) {
> +		if (flags) {
>  			flags = 0;
>  			if (low_space)
>  				ok_alloc = true;
> +			goto retry;
>  		}
> -		xfs_perag_rele(pag);
> +		return -ENOSPC;
>  	}
> -
> -	if (!error)
> -		*new_ino = ino;
> -	xfs_perag_rele(pag);
> -	return error;
> +	*new_ino = ino;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.39.0
> 
