Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 253B9C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 11:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D5B610A6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 11:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhE0LV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 07:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhE0LV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 07:21:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622114425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YQagCj8TMs81E1e6kS5uzSv8n2l130IsQX+il0CnsBM=;
        b=C90eyhuy26GYvMFHb031fM0+/D/KxMYTUXbTnlbxU/K5wXSJVPMVvRUqAqPHTjCKVNfCDj
        ax+yd5E4ciDiZCPXglzrAR80tHmvtnWG08Lqhv3EYW6pP64237gf1w7SXINJIoic7Q5Kov
        kqt75yJZDtVZQKLRTlBR9dSa9V/X62k=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-iDS3ilf0P2qhqEG5gF22Vw-1; Thu, 27 May 2021 07:20:24 -0400
X-MC-Unique: iDS3ilf0P2qhqEG5gF22Vw-1
Received: by mail-qt1-f198.google.com with SMTP id z9-20020a05622a0609b02901f30a4fcf9bso2503358qta.4
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 04:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YQagCj8TMs81E1e6kS5uzSv8n2l130IsQX+il0CnsBM=;
        b=t6CdztzoUhsF9Zn+erTKt+9X2wZum7q3fEkEhEJE8NQ3wOVdHii6sDJMm1I4jXwb9y
         mecsssXfZXZ/AorcJKlv02+CaucEBTJooeZYFNFQaQYB7XKgO+DQ8bgC9xNGJo5siKhZ
         75BNhf3YEcAZJnCH66R5z/nDjXfeISgN6Wf1Xn4rMTe11V3Nqi+pJPNchQHSY1ruSRL7
         DDt3EeenaT9KE9fYUcRQLJiAK1aln7V649saZ3JJvzlwED5/5MRGsfNodDMBKS6wP/XA
         hzBFLTev1ryvqUHsibp1nLwG8HdgJG/OwT6+GvSkwvXCVPSFv3ffHlJtFFc3sOk1D2Rg
         Jxdg==
X-Gm-Message-State: AOAM5335zvxo5QdnJQrXim4cbCNawHYrij0RDktJbWG3+DMI6Kvi6Bj7
        LlIBFgcZYbpCY4xdmzPh+ERjwRKBGW2IY5zD+sC9L1HZtQctN3LNnYTmk0nZBDjuTpG1d9oHnSk
        zjO05I0a0y5S4M6PZYXp4
X-Received: by 2002:ac8:474d:: with SMTP id k13mr2523807qtp.229.1622114423140;
        Thu, 27 May 2021 04:20:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4RF4EzvAizbQ1Jyyuob7bJvHZNBPiCD4u6Ni7gSyfKEP/qQxVQJO8VuuitT+Ac458pGE4BQ==
X-Received: by 2002:ac8:474d:: with SMTP id k13mr2523783qtp.229.1622114422805;
        Thu, 27 May 2021 04:20:22 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id k124sm1114552qkc.132.2021.05.27.04.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 04:20:22 -0700 (PDT)
Date:   Thu, 27 May 2021 07:20:20 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/23] xfs: clean up and simplify xfs_dialloc()
Message-ID: <YK+AdHtinZckZP3I@bfoster>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-22-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:21:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because it's a mess.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 268 +++++++++++++++++++++----------------
>  1 file changed, 153 insertions(+), 115 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 88c15d8bd6e4..63a1b6d422cc 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
...
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

It looks like this fixes the problem in the earlier patch (though the
earlier patch should still be fixed up):

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> @@ -1625,7 +1747,6 @@ xfs_dialloc(
>  	 * one block, so factor that potential expansion when we examine whether
>  	 * an AG has enough space for file creation.
>  	 */
> -	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
>  	if (S_ISDIR(mode))
>  		start_agno = xfs_ialloc_next_ag(mp);
>  	else {
> @@ -1636,7 +1757,7 @@ xfs_dialloc(
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> -	 * okalloc so we scan all available agi structures for a free
> +	 * ok_alloc so we scan all available agi structures for a free
>  	 * inode.
>  	 *
>  	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
> @@ -1645,7 +1766,7 @@ xfs_dialloc(
>  	if (igeo->maxicount &&
>  	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
>  							> igeo->maxicount) {
> -		okalloc = false;
> +		ok_alloc = false;
>  	}
>  
>  	/*
> @@ -1656,93 +1777,14 @@ xfs_dialloc(
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
> -		if (!pag->pagi_freecount && !okalloc)
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
> @@ -1750,23 +1792,19 @@ xfs_dialloc(
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

