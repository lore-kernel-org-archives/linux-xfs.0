Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF8DC636D3
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Feb 2023 00:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBBAIy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Feb 2023 19:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBBAIx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2023 19:08:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E25869B34
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 16:08:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8243AB8221F
        for <linux-xfs@vger.kernel.org>; Thu,  2 Feb 2023 00:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22508C433D2;
        Thu,  2 Feb 2023 00:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675296529;
        bh=CNkMi63vgIRGhtSWHOcdA4JPVrwYEoz/y9/UyyupAeA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+Zwqcat2mqhjeby4Po0fbQBQWatdxn3CaLi3VgOuTfFpy+EHRKnA/BjPxbLFAyi1
         i13GZO3VpQZTmDQm32HVIgUq06DWOB0ouDGh1Ff6hr4dLayr3VofOUvkR/vOClLaRj
         DSkNBmhKFnqWF2WWqKcdhnLSRXSo53ouVZGsYaiprRU5x0AyEuoWGU7aNZ0exaXrv/
         iOL969UcN8At2hM9lNOIQEZtQjX8oLyV7GZgN3HbbMp5HRTpd6Pp4puaxn1Yxg2zzO
         s/skXQNETo8w0rgn1nI3C+lge1FlmBIeA9GZjr5vt9tJ/8EQhkifqrbx5FKelcT7CP
         f4LW5wSdeMz0g==
Date:   Wed, 1 Feb 2023 16:08:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/42] xfs: refactor the filestreams allocator pick
 functions
Message-ID: <Y9r/ELba/fu2dFuG@magnolia>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-43-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118224505.1964941-43-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 19, 2023 at 09:45:05AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the filestreams allocator is largely rewritten,
> restructure the main entry point and pick function to seperate out
> the different operations cleanly. The MRU lookup function should not
> handle the start AG selection on MRU lookup failure, and nor should
> the pick function handle building the association that is inserted
> into the MRU.
> 
> This leaves the filestreams allocator fairly clean and easy to
> understand, returning to the caller with an active perag reference
> and a target block to allocate at.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_filestream.c | 247 +++++++++++++++++++++-------------------
>  fs/xfs/xfs_trace.h      |   9 +-
>  2 files changed, 132 insertions(+), 124 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 523a3b8b5754..0a1d316ebdba 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -48,19 +48,19 @@ xfs_fstrm_free_func(
>  }
>  
>  /*
> - * Scan the AGs starting at startag looking for an AG that isn't in use and has
> - * at least minlen blocks free.
> + * Scan the AGs starting at start_agno looking for an AG that isn't in use and
> + * has at least minlen blocks free. If no AG is found to match the allocation
> + * requirements, pick the AG with the most free space in it.
>   */
>  static int
>  xfs_filestream_pick_ag(
>  	struct xfs_alloc_arg	*args,
> -	struct xfs_inode	*ip,
> +	xfs_ino_t		pino,
>  	xfs_agnumber_t		start_agno,
>  	int			flags,
>  	xfs_extlen_t		*longest)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_fstrm_item	*item;
> +	struct xfs_mount	*mp = args->mp;
>  	struct xfs_perag	*pag;
>  	struct xfs_perag	*max_pag = NULL;
>  	xfs_extlen_t		minlen = *longest;
> @@ -68,8 +68,6 @@ xfs_filestream_pick_ag(
>  	xfs_agnumber_t		agno;
>  	int			err, trylock;

Who consumes trylock?  Is this supposed to get passed through to
xfs_bmap_longest_free_extent, or is the goal here merely to run the
for_each_perag_wrap loop twice before going for the most free or any old
perag?

--D

> -	ASSERT(S_ISDIR(VFS_I(ip)->i_mode));
> -
>  	/* 2% of an AG's blocks must be free for it to be chosen. */
>  	minfree = mp->m_sb.sb_agblocks / 50;
>  
> @@ -78,7 +76,7 @@ xfs_filestream_pick_ag(
>  
>  restart:
>  	for_each_perag_wrap(mp, start_agno, agno, pag) {
> -		trace_xfs_filestream_scan(pag, ip->i_ino);
> +		trace_xfs_filestream_scan(pag, pino);
>  		*longest = 0;
>  		err = xfs_bmap_longest_free_extent(pag, NULL, longest);
>  		if (err) {
> @@ -148,9 +146,9 @@ xfs_filestream_pick_ag(
>  		 * grab.
>  		 */
>  		if (!max_pag) {
> -			for_each_perag_wrap(mp, start_agno, agno, pag)
> +			for_each_perag_wrap(args->mp, 0, start_agno, args->pag)
>  				break;
> -			atomic_inc(&pag->pagf_fstrms);
> +			atomic_inc(&args->pag->pagf_fstrms);
>  			*longest = 0;
>  		} else {
>  			pag = max_pag;
> @@ -161,44 +159,10 @@ xfs_filestream_pick_ag(
>  		xfs_perag_rele(max_pag);
>  	}
>  
> -	trace_xfs_filestream_pick(ip, pag, free);
> -
> -	err = -ENOMEM;
> -	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
> -	if (!item)
> -		goto out_put_ag;
> -
> -
> -	/*
> -	 * We are going to use this perag now, so take another ref to it for the
> -	 * allocation context returned to the caller. If we raced to create and
> -	 * insert the filestreams item into the MRU (-EEXIST), then we still
> -	 * keep this reference but free the item reference we gained above. On
> -	 * any other failure, we have to drop both.
> -	 */
> -	atomic_inc(&pag->pag_active_ref);
> -	item->pag = pag;
> +	trace_xfs_filestream_pick(pag, pino, free);
>  	args->pag = pag;
> -
> -	err = xfs_mru_cache_insert(mp->m_filestream, ip->i_ino, &item->mru);
> -	if (err) {
> -		if (err == -EEXIST) {
> -			err = 0;
> -		} else {
> -			xfs_perag_rele(args->pag);
> -			args->pag = NULL;
> -		}
> -		goto out_free_item;
> -	}
> -
>  	return 0;
>  
> -out_free_item:
> -	kmem_free(item);
> -out_put_ag:
> -	atomic_dec(&pag->pagf_fstrms);
> -	xfs_perag_rele(pag);
> -	return err;
>  }
>  
>  static struct xfs_inode *
> @@ -227,29 +191,29 @@ xfs_filestream_get_parent(
>  
>  /*
>   * Lookup the mru cache for an existing association. If one exists and we can
> - * use it, return with the agno and blen indicating that the allocation will
> - * proceed with that association.
> + * use it, return with an active perag reference indicating that the allocation
> + * will proceed with that association.
>   *
>   * If we have no association, or we cannot use the current one and have to
> - * destroy it, return with blen = 0 and agno pointing at the next agno to try.
> + * destroy it, return with longest = 0 to tell the caller to create a new
> + * association.
>   */
> -int
> -xfs_filestream_select_ag_mru(
> +static int
> +xfs_filestream_lookup_association(
>  	struct xfs_bmalloca	*ap,
>  	struct xfs_alloc_arg	*args,
> -	struct xfs_inode	*pip,
> -	xfs_agnumber_t		*agno,
> -	xfs_extlen_t		*blen)
> +	xfs_ino_t		pino,
> +	xfs_extlen_t		*longest)
>  {
> -	struct xfs_mount	*mp = ap->ip->i_mount;
> +	struct xfs_mount	*mp = args->mp;
>  	struct xfs_perag	*pag;
>  	struct xfs_mru_cache_elem *mru;
> -	int			error;
> +	int			error = 0;
>  
> -	mru = xfs_mru_cache_lookup(mp->m_filestream, pip->i_ino);
> +	*longest = 0;
> +	mru = xfs_mru_cache_lookup(mp->m_filestream, pino);
>  	if (!mru)
> -		goto out_default_agno;
> -
> +		return 0;
>  	/*
>  	 * Grab the pag and take an extra active reference for the caller whilst
>  	 * the mru item cannot go away. This means we'll pin the perag with
> @@ -265,103 +229,148 @@ xfs_filestream_select_ag_mru(
>  	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
>  	xfs_bmap_adjacent(ap);
>  
> -	error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
> -	if (error) {
> -		/* We aren't going to use this perag */
> -		xfs_perag_rele(pag);
> -		if (error != -EAGAIN)
> -			return error;
> -		*blen = 0;
> -	}
> -
>  	/*
> -	 * We are done if there's still enough contiguous free space to succeed.
>  	 * If there is very little free space before we start a filestreams
> -	 * allocation, we're almost guaranteed to fail to find a better AG with
> -	 * larger free space available so we don't even try.
> +	 * allocation, we're almost guaranteed to fail to find a large enough
> +	 * free space available so just use the cached AG.
>  	 */
> -	*agno = pag->pag_agno;
> -	if (*blen >= args->maxlen || (ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
> -		args->pag = pag;
> -		return 0;
> +	if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> +		*longest = 1;
> +		goto out_done;
>  	}
>  
> +	error = xfs_bmap_longest_free_extent(pag, args->tp, longest);
> +	if (error == -EAGAIN)
> +		error = 0;
> +	if (error || *longest < args->maxlen) {
> +		/* We aren't going to use this perag */
> +		*longest = 0;
> +		xfs_perag_rele(pag);
> +		return error;
> +	}
> +
> +out_done:
> +	args->pag = pag;
> +	return 0;
> +}
> +
> +static int
> +xfs_filestream_create_association(
> +	struct xfs_bmalloca	*ap,
> +	struct xfs_alloc_arg	*args,
> +	xfs_ino_t		pino,
> +	xfs_extlen_t		*longest)
> +{
> +	struct xfs_mount	*mp = args->mp;
> +	struct xfs_mru_cache_elem *mru;
> +	struct xfs_fstrm_item	*item;
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, pino);
> +	int			flags = 0;
> +	int			error;
> +
>  	/* Changing parent AG association now, so remove the existing one. */
> -	xfs_perag_rele(pag);
> -	mru = xfs_mru_cache_remove(mp->m_filestream, pip->i_ino);
> +	mru = xfs_mru_cache_remove(mp->m_filestream, pino);
>  	if (mru) {
>  		struct xfs_fstrm_item *item =
>  			container_of(mru, struct xfs_fstrm_item, mru);
> -		*agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
> -		xfs_fstrm_free_func(mp, mru);
> -		return 0;
> -	}
>  
> -out_default_agno:
> -	if (xfs_is_inode32(mp)) {
> +		agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
> +		xfs_fstrm_free_func(mp, mru);
> +	} else if (xfs_is_inode32(mp)) {
>  		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
> -		*agno = (mp->m_agfrotor / rotorstep) %
> -				mp->m_sb.sb_agcount;
> +
> +		agno = (mp->m_agfrotor / rotorstep) % mp->m_sb.sb_agcount;
>  		mp->m_agfrotor = (mp->m_agfrotor + 1) %
>  				 (mp->m_sb.sb_agcount * rotorstep);
> -		return 0;
>  	}
> -	*agno = XFS_INO_TO_AGNO(mp, pip->i_ino);
> +
> +	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
> +	xfs_bmap_adjacent(ap);
> +
> +	if (ap->datatype & XFS_ALLOC_USERDATA)
> +		flags |= XFS_PICK_USERDATA;
> +	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
> +		flags |= XFS_PICK_LOWSPACE;
> +
> +	*longest = ap->length;
> +	error = xfs_filestream_pick_ag(args, pino, agno, flags, longest);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * We are going to use this perag now, so create an assoication for it.
> +	 * xfs_filestream_pick_ag() has already bumped the perag fstrms counter
> +	 * for us, so all we need to do here is take another active reference to
> +	 * the perag for the cached association.
> +	 *
> +	 * If we fail to store the association, we need to drop the fstrms
> +	 * counter as well as drop the perag reference we take here for the
> +	 * item. We do not need to return an error for this failure - as long as
> +	 * we return a referenced AG, the allocation can still go ahead just
> +	 * fine.
> +	 */
> +	item = kmem_alloc(sizeof(*item), KM_MAYFAIL);
> +	if (!item)
> +		goto out_put_fstrms;
> +
> +	atomic_inc(&args->pag->pag_active_ref);
> +	item->pag = args->pag;
> +	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
> +	if (error)
> +		goto out_free_item;
>  	return 0;
>  
> +out_free_item:
> +	xfs_perag_rele(item->pag);
> +	kmem_free(item);
> +out_put_fstrms:
> +	atomic_dec(&args->pag->pagf_fstrms);
> +	return 0;
>  }
>  
>  /*
>   * Search for an allocation group with a single extent large enough for
> - * the request.  If one isn't found, then adjust the minimum allocation
> - * size to the largest space found.
> + * the request. First we look for an existing association and use that if it
> + * is found. Otherwise, we create a new association by selecting an AG that fits
> + * the allocation criteria.
> + *
> + * We return with a referenced perag in args->pag to indicate which AG we are
> + * allocating into or an error with no references held.
>   */
>  int
>  xfs_filestream_select_ag(
>  	struct xfs_bmalloca	*ap,
>  	struct xfs_alloc_arg	*args,
> -	xfs_extlen_t		*blen)
> +	xfs_extlen_t		*longest)
>  {
> -	struct xfs_mount	*mp = ap->ip->i_mount;
> -	struct xfs_inode	*pip = NULL;
> -	xfs_agnumber_t		agno;
> -	int			flags = 0;
> +	struct xfs_mount	*mp = args->mp;
> +	struct xfs_inode	*pip;
> +	xfs_ino_t		ino = 0;
>  	int			error = 0;
>  
> +	*longest = 0;
>  	args->total = ap->total;
> -	*blen = 0;
> -
>  	pip = xfs_filestream_get_parent(ap->ip);
> -	if (!pip) {
> -		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
> -		return 0;
> +	if (pip) {
> +		ino = pip->i_ino;
> +		error = xfs_filestream_lookup_association(ap, args, ino,
> +				longest);
> +		xfs_irele(pip);
> +		if (error)
> +			return error;
> +		if (*longest >= args->maxlen)
> +			goto out_select;
> +		if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
> +			goto out_select;
>  	}
>  
> -	error = xfs_filestream_select_ag_mru(ap, args, pip, &agno, blen);
> +	error = xfs_filestream_create_association(ap, args, ino, longest);
>  	if (error)
> -		goto out_rele;
> -	if (*blen >= args->maxlen)
> -		goto out_select;
> -	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
> -		goto out_select;
> -
> -	ap->blkno = XFS_AGB_TO_FSB(args->mp, agno, 0);
> -	xfs_bmap_adjacent(ap);
> -	*blen = ap->length;
> -	if (ap->datatype & XFS_ALLOC_USERDATA)
> -		flags |= XFS_PICK_USERDATA;
> -	if (ap->tp->t_flags & XFS_TRANS_LOWMODE)
> -		flags |= XFS_PICK_LOWSPACE;
> +		return error;
>  
> -	error = xfs_filestream_pick_ag(args, pip, agno, flags, blen);
> -	if (error)
> -		goto out_rele;
>  out_select:
>  	ap->blkno = XFS_AGB_TO_FSB(mp, args->pag->pag_agno, 0);
> -out_rele:
> -	xfs_irele(pip);
> -	return error;
> -
> +	return 0;
>  }
>  
>  void
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b5f7d225d5b4..1d3569c0d2fe 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -668,9 +668,8 @@ DEFINE_FILESTREAM_EVENT(xfs_filestream_lookup);
>  DEFINE_FILESTREAM_EVENT(xfs_filestream_scan);
>  
>  TRACE_EVENT(xfs_filestream_pick,
> -	TP_PROTO(struct xfs_inode *ip, struct xfs_perag *pag,
> -		 xfs_extlen_t free),
> -	TP_ARGS(ip, pag, free),
> +	TP_PROTO(struct xfs_perag *pag, xfs_ino_t ino, xfs_extlen_t free),
> +	TP_ARGS(pag, ino, free),
>  	TP_STRUCT__entry(
>  		__field(dev_t, dev)
>  		__field(xfs_ino_t, ino)
> @@ -679,8 +678,8 @@ TRACE_EVENT(xfs_filestream_pick,
>  		__field(xfs_extlen_t, free)
>  	),
>  	TP_fast_assign(
> -		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> -		__entry->ino = ip->i_ino;
> +		__entry->dev = pag->pag_mount->m_super->s_dev;
> +		__entry->ino = ino;
>  		if (pag) {
>  			__entry->agno = pag->pag_agno;
>  			__entry->streams = atomic_read(&pag->pagf_fstrms);
> -- 
> 2.39.0
> 
