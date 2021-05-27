Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793BFC47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 11:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A7E7610A6
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 11:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhE0LVd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 07:21:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233044AbhE0LVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 07:21:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622114400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cobx6uufB46eNoutdDN1zQDNDkxrvVvuTfmBrvaYzZE=;
        b=YeeL0EcLlwjRQyqooNwF3H20ZieiGYRyQmyJohbrAvlKRb1NBEN883r28siQfUlPI5yUNt
        qu9sNpNUfrwQYtK6ADe2TeeGulYYO56Bsz+wCMsnaW87EHKoOB/3cP1K92zyrS2Rah7rS8
        JW1pUMAnFJu5obqEtfeGBlVC6jIZw8c=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-kH1W-c_OPtmTcVNINbV1iQ-1; Thu, 27 May 2021 07:19:58 -0400
X-MC-Unique: kH1W-c_OPtmTcVNINbV1iQ-1
Received: by mail-qv1-f69.google.com with SMTP id b24-20020a0cb3d80000b02901e78b82d74aso3651934qvf.20
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 04:19:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cobx6uufB46eNoutdDN1zQDNDkxrvVvuTfmBrvaYzZE=;
        b=E5j+VkwcjFD/o5FZOTSe3fl8cXgyYQRGcNruiBHlBSzfTxo9Knx6AiaOF4xjivfUWX
         ZgwUZQHOdiOn3y7WSULlHBNWZ1chNkBnKcKH/lHdZdcShFDSb8fAW0jLh0gWquGyHiLv
         wbRmIXSp58QW6yZYsLIQ667/f5KWOzRNRdM3ZA22jLAcKLP/37/7m2mYB5Qem7wbLPNY
         JlKrelaRdk0qfZr7E/A/qRv9BwCcX7yg+6iNAqeFhZDKuJ+BE9+rVqZGqfiW4QJx1n2M
         yf8wUj6PUPj/B9K9J4g/jsRLJLNP9yoY+UBwgNWkDCUk07ydNKLz7nFXB41kZMmlYX/5
         zi7A==
X-Gm-Message-State: AOAM530lLAYZ0K9/cOY5yQlnDsZrZGA6/FOnNTh0NoiHvHatejV41nSE
        jTWHta6jBrrYj8Wkz4E+5/UIugdmA9JQpABaeKozLO6sQOEOw/ASKn9AlJD+K1Xu9Z5ax4bPm1q
        mvEl2sW+byydDNV6/jRNb
X-Received: by 2002:ac8:7496:: with SMTP id v22mr2534398qtq.159.1622114397392;
        Thu, 27 May 2021 04:19:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9m4HQ8iRESVDAamKmruC0BeWjXH3KwdLSxSahWmt+3nJKkXGXUHRu4NSyfAXSsTabm+vv5w==
X-Received: by 2002:ac8:7496:: with SMTP id v22mr2534366qtq.159.1622114396896;
        Thu, 27 May 2021 04:19:56 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id b17sm1122553qka.94.2021.05.27.04.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 04:19:56 -0700 (PDT)
Date:   Thu, 27 May 2021 07:19:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/23] xfs: collapse AG selection for inode allocation
Message-ID: <YK+AWjhCxn6kjwLg@bfoster>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-19-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:20:57AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_dialloc_select_ag() does a lot of repetitive work. It first
> calls xfs_ialloc_ag_select() to select the AG to start allocation
> attempts in, which can do up to two entire loops across the perags
> that inodes can be allocated in. This is simply checking if there is
> spce available to allocate inodes in an AG, and it returns when it
> finds the first candidate AG.
> 
> xfs_dialloc_select_ag() then does it's own iterative walk across
> all the perags locking the AGIs and trying to allocate inodes from
> the locked AG. It also doesn't limit the search to mp->m_maxagi,
> so it will walk all AGs whether they can allocate inodes or not.
> 
> Hence if we are really low on inodes, we could do almost 3 entire
> walks across the whole perag range before we find an allocation
> group we can allocate inodes in or report ENOSPC.
> 
> Because xfs_ialloc_ag_select() returns on the first candidate AG it
> finds, we can simply do these checks directly in
> xfs_dialloc_select_ag() before we lock and try to allocate inodes.
> This reduces the inode allocation pass down to 2 perag sweeps at
> most - one for aligned inode cluster allocation and if we can't
> allocate full, aligned inode clusters anywhere we'll do another pass
> trying to do sparse inode cluster allocation.
> 
> This also removes a big chunk of duplicate code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 220 +++++++++++++------------------------
>  1 file changed, 74 insertions(+), 146 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 872591e8f5cb..3acecdbe51e4 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -899,139 +899,6 @@ xfs_ialloc_ag_alloc(
>  	return 0;
>  }
>  
> -STATIC xfs_agnumber_t
> -xfs_ialloc_next_ag(
> -	xfs_mount_t	*mp)
> -{
> -	xfs_agnumber_t	agno;
> -
> -	spin_lock(&mp->m_agirotor_lock);
> -	agno = mp->m_agirotor;
> -	if (++mp->m_agirotor >= mp->m_maxagi)
> -		mp->m_agirotor = 0;
> -	spin_unlock(&mp->m_agirotor_lock);
> -
> -	return agno;
> -}
> -
> -/*
> - * Select an allocation group to look for a free inode in, based on the parent
> - * inode and the mode.  Return the allocation group buffer.
> - */
> -STATIC xfs_agnumber_t
> -xfs_ialloc_ag_select(
> -	xfs_trans_t	*tp,		/* transaction pointer */
> -	xfs_ino_t	parent,		/* parent directory inode number */
> -	umode_t		mode)		/* bits set to indicate file type */
> -{
> -	xfs_agnumber_t	agcount;	/* number of ag's in the filesystem */
> -	xfs_agnumber_t	agno;		/* current ag number */
> -	int		flags;		/* alloc buffer locking flags */
> -	xfs_extlen_t	ineed;		/* blocks needed for inode allocation */
> -	xfs_extlen_t	longest = 0;	/* longest extent available */
> -	xfs_mount_t	*mp;		/* mount point structure */
> -	int		needspace;	/* file mode implies space allocated */
> -	xfs_perag_t	*pag;		/* per allocation group data */
> -	xfs_agnumber_t	pagno;		/* parent (starting) ag number */
> -	int		error;
> -
> -	/*
> -	 * Files of these types need at least one block if length > 0
> -	 * (and they won't fit in the inode, but that's hard to figure out).
> -	 */
> -	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> -	mp = tp->t_mountp;
> -	agcount = mp->m_maxagi;
> -	if (S_ISDIR(mode))
> -		pagno = xfs_ialloc_next_ag(mp);
> -	else {
> -		pagno = XFS_INO_TO_AGNO(mp, parent);
> -		if (pagno >= agcount)
> -			pagno = 0;
> -	}
> -
> -	ASSERT(pagno < agcount);
> -
> -	/*
> -	 * Loop through allocation groups, looking for one with a little
> -	 * free space in it.  Note we don't look for free inodes, exactly.
> -	 * Instead, we include whether there is a need to allocate inodes
> -	 * to mean that blocks must be allocated for them,
> -	 * if none are currently free.
> -	 */
> -	agno = pagno;
> -	flags = XFS_ALLOC_FLAG_TRYLOCK;
> -	for (;;) {
> -		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok) {
> -			xfs_ialloc_next_ag(mp);
> -			goto nextag;
> -		}
> -
> -		if (!pag->pagi_init) {
> -			error = xfs_ialloc_pagi_init(mp, tp, agno);
> -			if (error)
> -				goto nextag;
> -		}
> -
> -		if (pag->pagi_freecount) {
> -			xfs_perag_put(pag);
> -			return agno;
> -		}
> -
> -		if (!pag->pagf_init) {
> -			error = xfs_alloc_pagf_init(mp, tp, agno, flags);
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
> -		if (pag->pagf_freeblks >= needspace + ineed &&
> -		    longest >= ineed) {
> -			xfs_perag_put(pag);
> -			return agno;
> -		}
> -nextag:
> -		xfs_perag_put(pag);
> -		/*
> -		 * No point in iterating over the rest, if we're shutting
> -		 * down.
> -		 */
> -		if (XFS_FORCED_SHUTDOWN(mp))
> -			return NULLAGNUMBER;
> -		agno++;
> -		if (agno >= agcount)
> -			agno = 0;
> -		if (agno == pagno) {
> -			if (flags == 0)
> -				return NULLAGNUMBER;
> -			flags = 0;
> -		}
> -	}
> -}
> -
>  /*
>   * Try to retrieve the next record to the left/right from the current one.
>   */
> @@ -1708,6 +1575,21 @@ xfs_dialloc_roll(
>  	return 0;
>  }
>  
> +STATIC xfs_agnumber_t
> +xfs_ialloc_next_ag(
> +	xfs_mount_t	*mp)
> +{
> +	xfs_agnumber_t	agno;
> +
> +	spin_lock(&mp->m_agirotor_lock);
> +	agno = mp->m_agirotor;
> +	if (++mp->m_agirotor >= mp->m_maxagi)
> +		mp->m_agirotor = 0;
> +	spin_unlock(&mp->m_agirotor_lock);
> +
> +	return agno;
> +}
> +
>  /*
>   * Select and prepare an AG for inode allocation.
>   *
> @@ -1734,16 +1616,24 @@ xfs_dialloc_select_ag(
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
>  	bool			okalloc = true;
> +	int			needspace;
> +	int			flags;
>  
>  	*IO_agbp = NULL;
>  
>  	/*
> -	 * We do not have an agbp, so select an initial allocation
> -	 * group for inode allocation.
> +	 * Directories, symlinks, and regular files frequently allocate at least
> +	 * one block, so factor that potential expansion when we examine whether
> +	 * an AG has enough space for file creation.
>  	 */
> -	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
> -	if (start_agno == NULLAGNUMBER)
> -		return -ENOSPC;
> +	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> +	if (S_ISDIR(mode))
> +		start_agno = xfs_ialloc_next_ag(mp);
> +	else {
> +		start_agno = XFS_INO_TO_AGNO(mp, parent);
> +		if (start_agno >= mp->m_maxagi)
> +			start_agno = 0;
> +	}
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> @@ -1765,12 +1655,14 @@ xfs_dialloc_select_ag(
>  	 * allocation groups upward, wrapping at the end.
>  	 */
>  	agno = start_agno;
> +	flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	for (;;) {
> +		xfs_extlen_t	ineed;
> +		xfs_extlen_t	longest = 0;
> +
>  		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok) {
> -			xfs_ialloc_next_ag(mp);
> +		if (!pag->pagi_inodeok)
>  			goto nextag;
> -		}
>  
>  		if (!pag->pagi_init) {
>  			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
> @@ -1778,10 +1670,39 @@ xfs_dialloc_select_ag(
>  				break;
>  		}
>  
> +		if (!pag->pagi_freecount && !okalloc)
> +			goto nextag;
> +
> +		if (!pag->pagf_init) {
> +			error = xfs_alloc_pagf_init(mp, *tpp, agno, flags);
> +			if (error)
> +				goto nextag;
> +		}
> +
>  		/*
> -		 * Do a first racy fast path check if this AG is usable.
> +		 * Check that there is enough free space for the file plus a
> +		 * chunk of inodes if we need to allocate some. If this is the
> +		 * first pass across the AGs, take into account the potential
> +		 * space needed for alignment of inode chunks when checking the
> +		 * longest contiguous free space in the AG - this prevents us
> +		 * from getting ENOSPC because we have free space larger than
> +		 * ialloc_blks but alignment constraints prevent us from using
> +		 * it.
> +		 *
> +		 * If we can't find an AG with space for full alignment slack to
> +		 * be taken into account, we must be near ENOSPC in all AGs.
> +		 * Hence we don't include alignment for the second pass and so
> +		 * if we fail allocation due to alignment issues then it is most
> +		 * likely a real ENOSPC condition.
>  		 */
> -		if (!pag->pagi_freecount && !okalloc)
> +		ineed = M_IGEO(mp)->ialloc_min_blks;
> +		if (flags && ineed > 1)
> +			ineed += M_IGEO(mp)->cluster_align;
> +		longest = pag->pagf_longest;
> +		if (!longest)
> +			longest = pag->pagf_flcount > 0;
> +
> +		if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
>  			goto nextag;

Similar to last time.. it looks like this skips an AG based on free
space even if there are allocated inode chunks with free inodes.

Brian

>  
>  		/*
> @@ -1823,10 +1744,17 @@ xfs_dialloc_select_ag(
>  nextag_relse_buffer:
>  		xfs_trans_brelse(*tpp, agbp);
>  nextag:
> -		if (++agno == mp->m_sb.sb_agcount)
> -			agno = 0;
> -		if (agno == start_agno)
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			error = -EFSCORRUPTED;
>  			break;
> +		}
> +		if (++agno == mp->m_maxagi)
> +			agno = 0;
> +		if (agno == start_agno) {
> +			if (!flags)
> +				break;
> +			flags = 0;
> +		}
>  		xfs_perag_put(pag);
>  	}
>  
> -- 
> 2.31.1
> 

