Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF7FDC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1FF8610A7
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhELWnP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 18:43:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1442040AbhELVuk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 17:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3387161028;
        Wed, 12 May 2021 21:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620856171;
        bh=YMtJtZtlfbApuGTLalc8imDZMmP6KMYXjxhz+CNXBc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZnN1qCLhsHvbAAtINv7eLX8oomQFdfR4qerPLtSb30ZsL8i6o1qpsId414IqlCtLK
         QI48xvU/b6PGnoeY6Y/NYYIQrPWO7/5FZcrYBd6/pB2UpekJzC26gZj8MiuQH2jK00
         CLoZ4dTjnVCsWcbTqb+ViUXW06yu5pdSueJgA7YdGHBIiEKD8D3wSMClTjyimn4Byt
         EdQCort2hKz/bmqtupPU4cviZW5MCw0FWN6EmliwgI/1PDAuZhdxJcKY4AR5IB8UIB
         Qe/rNXI7Yk+Ln7HOdjRjbrLhzbauXqzfVcwYzrHG96jlw79QfwSmFGP2SOwukia7yu
         eItcKGHSohyJA==
Date:   Wed, 12 May 2021 14:49:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/22] xfs: clean up and simplify xfs_dialloc()
Message-ID: <20210512214930.GZ8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-22-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because it's a mess.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 270 +++++++++++++++++++++----------------
>  1 file changed, 153 insertions(+), 117 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index d749bb7c7a69..340bb95d7bc1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -604,9 +604,10 @@ xfs_inobt_insert_sprec(
>  }
>  
>  /*
> - * Allocate new inodes in the allocation group specified by agbp.
> - * Returns 0 if inodes were allocated in this AG; 1 if there was no space
> - * in this AG; or the usual negative error code.
> + * Allocate new inodes in the allocation group specified by agbp.  Returns 0 if
> + * inodes were allocated in this AG; -EAGAIN if there was no space in this AG so
> + * the caller knows it can try another AG, a hard -ENOSPC when over the maximum
> + * inode count threshold, or the usual negative error code for other errors.
>   */
>  STATIC int
>  xfs_ialloc_ag_alloc(
> @@ -792,7 +793,7 @@ xfs_ialloc_ag_alloc(
>  	}
>  
>  	if (args.fsbno == NULLFSBLOCK)
> -		return 1;
> +		return -EAGAIN;
>  
>  	ASSERT(args.len == args.minlen);
>  
> @@ -1568,14 +1569,17 @@ xfs_dialloc_roll(
>  	/* Re-attach the quota info that we detached from prev trx. */
>  	tp->t_dqinfo = dqinfo;
>  
> -	*tpp = tp;
> -	if (error)
> -		return error;
> +	/*
> +	 * Join the buffer even on commit error so that the buffer is released
> +	 * when the caller cancels the transaction and doesn't have to handle
> +	 * this error case specially.
> +	 */
>  	xfs_trans_bjoin(tp, agibp);
> -	return 0;
> +	*tpp = tp;
> +	return error;
>  }
>  
> -STATIC xfs_agnumber_t
> +static xfs_agnumber_t
>  xfs_ialloc_next_ag(
>  	xfs_mount_t	*mp)
>  {
> @@ -1590,16 +1594,136 @@ xfs_ialloc_next_ag(
>  	return agno;
>  }
>  
> +static bool
> +xfs_dialloc_good_ag(
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	umode_t			mode,
> +	int			flags,
> +	bool			ok_alloc)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_extlen_t		ineed;
> +	xfs_extlen_t		longest = 0;
> +	int			needspace;
> +	int			error;
> +
> +	if (!pag->pagi_inodeok)
> +		return false;
> +
> +	if (!pag->pagi_init) {
> +		error = xfs_ialloc_pagi_init(mp, tp, pag->pag_agno);
> +		if (error)
> +			return false;
> +	}
> +
> +	if (pag->pagi_freecount)
> +		return true;
> +	if (!ok_alloc)
> +		return false;
> +
> +	if (!pag->pagf_init) {
> +		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, flags);
> +		if (error)
> +			return false;
> +	}
> +
> +	/*
> +	 * Check that there is enough free space for the file plus a chunk of
> +	 * inodes if we need to allocate some. If this is the first pass across
> +	 * the AGs, take into account the potential space needed for alignment
> +	 * of inode chunks when checking the longest contiguous free space in
> +	 * the AG - this prevents us from getting ENOSPC because we have free
> +	 * space larger than ialloc_blks but alignment constraints prevent us
> +	 * from using it.
> +	 *
> +	 * If we can't find an AG with space for full alignment slack to be
> +	 * taken into account, we must be near ENOSPC in all AGs.  Hence we
> +	 * don't include alignment for the second pass and so if we fail
> +	 * allocation due to alignment issues then it is most likely a real
> +	 * ENOSPC condition.
> +	 *
> +	 * XXX(dgc): this calculation is now bogus thanks to the per-ag
> +	 * reservations that xfs_alloc_fix_freelist() now does via
> +	 * xfs_alloc_space_available(). When the AG fills up, pagf_freeblks will
> +	 * be more than large enough for the check below to succeed, but
> +	 * xfs_alloc_space_available() will fail because of the non-zero
> +	 * metadata reservation and hence we won't actually be able to allocate
> +	 * more inodes in this AG. We do soooo much unnecessary work near ENOSPC
> +	 * because of this.

Yuck.  Can this be fixed by doing:

	really_free = pag->pagf_freeblks -
				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
	return really_free >= needspace + ineed && longest >= ineed)

to account for those reservations, perhaps?

> +	 */
> +	ineed = M_IGEO(mp)->ialloc_min_blks;
> +	if (flags && ineed > 1)
> +		ineed += M_IGEO(mp)->cluster_align;
> +	longest = pag->pagf_longest;
> +	if (!longest)
> +		longest = pag->pagf_flcount > 0;
> +	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> +
> +	if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
> +		return false;
> +	return true;
> +}
> +
> +static int
> +xfs_dialloc_try_ag(
> +	struct xfs_trans	**tpp,
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		parent,
> +	xfs_ino_t		*new_ino,
> +	bool			ok_alloc)
> +{
> +	struct xfs_buf		*agbp;
> +	xfs_ino_t		ino;
> +	int			error;
> +
> +	/*
> +	 * Then read in the AGI buffer and recheck with the AGI buffer
> +	 * lock held.
> +	 */
> +	error = xfs_ialloc_read_agi(pag->pag_mount, *tpp, pag->pag_agno, &agbp);
> +	if (error)
> +		return error;
> +
> +	if (!pag->pagi_freecount) {
> +		if (!ok_alloc) {
> +			error = -EAGAIN;
> +			goto out_release;
> +		}
> +
> +		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
> +		if (error < 0)
> +			goto out_release;
> +
> +		/*
> +		 * We successfully allocated space for an inode cluster in this
> +		 * AG.  Roll the transaction so that we can allocate one of the
> +		 * new inodes.
> +		 */
> +		ASSERT(pag->pagi_freecount > 0);
> +		error = xfs_dialloc_roll(tpp, agbp);
> +		if (error)
> +			goto out_release;
> +	}
> +
> +	/* Allocate an inode in the found AG */
> +	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
> +	if (!error)
> +		*new_ino = ino;
> +	return error;
> +
> +out_release:
> +	xfs_trans_brelse(*tpp, agbp);
> +	return error;
> +}
> +
>  /*
> - * Select and prepare an AG for inode allocation.
> + * Allocate an on-disk inode.
>   *
>   * Mode is used to tell whether the new inode is a directory and hence where to
> - * locate it.
> - *
> - * This function will ensure that the selected AG has free inodes available to
> - * allocate from. The selected AGI will be returned locked to the caller, and it
> - * will allocate more free inodes if required. If no free inodes are found or
> - * can be allocated, -ENOSPC be returned.
> + * locate it. The on-disk inode that is allocated will be returned in @new_ino
> + * on success, otherwise an error will be set to indicate the failure (e.g.
> + * -ENOSPC).
>   */
>  int
>  xfs_dialloc(
> @@ -1609,14 +1733,12 @@ xfs_dialloc(
>  	xfs_ino_t		*new_ino)
>  {
>  	struct xfs_mount	*mp = (*tpp)->t_mountp;
> -	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error = 0;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	bool			okalloc = true;
> -	int			needspace;
> +	bool			ok_alloc = true;
>  	int			flags;
>  	xfs_ino_t		ino;
>  
> @@ -1624,7 +1746,6 @@ xfs_dialloc(
>  	 * Files of these types need at least one block if length > 0
>  	 * (and they won't fit in the inode, but that's hard to figure out).
>  	 */
> -	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
>  	if (S_ISDIR(mode))
>  		start_agno = xfs_ialloc_next_ag(mp);
>  	else {
> @@ -1635,7 +1756,7 @@ xfs_dialloc(
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> -	 * okalloc so we scan all available agi structures for a free
> +	 * ok_alloc so we scan all available agi structures for a free
>  	 * inode.
>  	 *
>  	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
> @@ -1644,7 +1765,7 @@ xfs_dialloc(

Er... didn't this logic get split into xfs_dialloc_select_ag in 5.11?

Nice cleanup, at least...

--D

>  	if (igeo->maxicount &&
>  	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
>  							> igeo->maxicount) {
> -		okalloc = false;
> +		ok_alloc = false;
>  	}
>  
>  	/*
> @@ -1655,95 +1776,14 @@ xfs_dialloc(
>  	agno = start_agno;
>  	flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	for (;;) {
> -		xfs_extlen_t	ineed;
> -		xfs_extlen_t	longest = 0;
> -
>  		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok)
> -			goto nextag;
> -
> -		if (!pag->pagi_init) {
> -			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
> -			if (error)
> -				break;
> -		}
> -
> -		if (!pag->pagi_freecount)
> -			goto nextag;
> -		if (!okalloc)
> -			goto nextag;
> -
> -		if (!pag->pagf_init) {
> -			error = xfs_alloc_pagf_init(mp, *tpp, agno, flags);
> -			if (error)
> -				goto nextag;
> -		}
> -
> -		/*
> -		 * Check that there is enough free space for the file plus a
> -		 * chunk of inodes if we need to allocate some. If this is the
> -		 * first pass across the AGs, take into account the potential
> -		 * space needed for alignment of inode chunks when checking the
> -		 * longest contiguous free space in the AG - this prevents us
> -		 * from getting ENOSPC because we have free space larger than
> -		 * ialloc_blks but alignment constraints prevent us from using
> -		 * it.
> -		 *
> -		 * If we can't find an AG with space for full alignment slack to
> -		 * be taken into account, we must be near ENOSPC in all AGs.
> -		 * Hence we don't include alignment for the second pass and so
> -		 * if we fail allocation due to alignment issues then it is most
> -		 * likely a real ENOSPC condition.
> -		 */
> -		ineed = M_IGEO(mp)->ialloc_min_blks;
> -		if (flags && ineed > 1)
> -			ineed += M_IGEO(mp)->cluster_align;
> -		longest = pag->pagf_longest;
> -		if (!longest)
> -			longest = pag->pagf_flcount > 0;
> -
> -		if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
> -			goto nextag;
> -
> -		/*
> -		 * Then read in the AGI buffer and recheck with the AGI buffer
> -		 * lock held.
> -		 */
> -		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
> -		if (error)
> -			break;
> -
> -		if (pag->pagi_freecount)
> -			goto found_ag;
> -
> -		if (!okalloc)
> -			goto nextag_relse_buffer;
> -
> -		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
> -		if (error < 0) {
> -			xfs_trans_brelse(*tpp, agbp);
> -			break;
> -		}
> -
> -		if (error == 0) {
> -			/*
> -			 * We successfully allocated space for an inode cluster
> -			 * in this AG.  Roll the transaction so that we can
> -			 * allocate one of the new inodes.
> -			 */
> -			ASSERT(pag->pagi_freecount > 0);
> -
> -			error = xfs_dialloc_roll(tpp, agbp);
> -			if (error) {
> -				xfs_buf_relse(agbp);
> +		if (xfs_dialloc_good_ag(*tpp, pag, mode, flags, ok_alloc)) {
> +			error = xfs_dialloc_try_ag(tpp, pag, parent,
> +					&ino, ok_alloc);
> +			if (error != -EAGAIN)
>  				break;
> -			}
> -			goto found_ag;
>  		}
>  
> -nextag_relse_buffer:
> -		xfs_trans_brelse(*tpp, agbp);
> -nextag:
>  		if (XFS_FORCED_SHUTDOWN(mp)) {
>  			error = -EFSCORRUPTED;
>  			break;
> @@ -1751,23 +1791,19 @@ xfs_dialloc(
>  		if (++agno == mp->m_maxagi)
>  			agno = 0;
>  		if (agno == start_agno) {
> -			if (!flags)
> +			if (!flags) {
> +				error = -ENOSPC;
>  				break;
> +			}
>  			flags = 0;
>  		}
>  		xfs_perag_put(pag);
>  	}
>  
> +	if (!error)
> +		*new_ino = ino;
>  	xfs_perag_put(pag);
> -	return error ? error : -ENOSPC;
> -found_ag:
> -	/* Allocate an inode in the found AG */
> -	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
> -	xfs_perag_put(pag);
> -	if (error)
> -		return error;
> -	*new_ino = ino;
> -	return 0;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.31.1
> 
