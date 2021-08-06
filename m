Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59D3C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 11:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C046108D
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 11:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbhHFLhR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232704AbhHFLhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 07:37:15 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B03C061798
        for <linux-xfs@vger.kernel.org>; Fri,  6 Aug 2021 04:36:58 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cl16-20020a17090af690b02901782c35c4ccso13481735pjb.5
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 04:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=n8CZfuK4JK0ZT+1aZV+C2G93DplG3YA8eY0dl4Q7+Gw=;
        b=XeZaKrfDXfB0pLrE6uGduqr1Oduop24pnFVYDQhg2vVjT+gPT+7BGTLZu4Rd7Wciqs
         HwWV1dR2QLfHh8IzHs752ARDbDrIfQja4X+co8h2O5LRoWkddVBe7DOZRCKDMsME63DG
         hgbX0xypNUQPxxkQ1UCpbRNmuMnRvI/AC8yePsrHxLTno2cSvccc5RRQx6+vnVKd2gRL
         tEds4Ff3edD1Fq0IlQi5NkroUGxorlLVLpmbqo94gCSIM8ukgsNingjwWhj1ZPqE8f6l
         Vj2eHvrrMDkDuMVyXFnnS1YRiE4lv5u82lKW8rpIxpwBMlp4hbAZSWI+jpzkHFkByxS1
         4bgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=n8CZfuK4JK0ZT+1aZV+C2G93DplG3YA8eY0dl4Q7+Gw=;
        b=jLALMTaT3zLMjZ/PhfjaZg05CXng92hcI2/dmbcfV5t5mn9cDGnF/E0zzVkVxfm+ZV
         WChBkAvv+vsP7oKAvh9zGkCpRICpy3NBX9LxLxsv26quemHgSS6EGIhaTeVEWowbNOrY
         9Baxu9siMxqtDj6Cmd7n+y9s5ZD9kOyArzFoY2VR4RcHct5eIDaZpt6BtXHHFSeUZAfa
         BUoPOB2RXkH9vhnkBFC+lywefGzzfgLlv7DbqCEUjsu/GjqpXA65R8qbX3DnYkYjA3BB
         q5wd4XmUMSZYJXZpZuWN2eJid+8+tZWVdCX48Ij354JpTvjBAdp1M+XHN8WRfVomlBev
         CGhg==
X-Gm-Message-State: AOAM531wGpCMqk7GeTVdxgn/DRTGBNZ6X3vYDGv+3DlfLxCi5y7PZnrt
        tuqfA0jibWjb8AwpmBsKwxYiGcU4TnM=
X-Google-Smtp-Source: ABdhPJyuwJ0sAs2y4ee9OR7OOezo5UYJ0BJ6pasmuBI9JDn4RUNxY0+/JWaWEeEc+vIwGYOPsT0GPw==
X-Received: by 2002:a63:1352:: with SMTP id 18mr231292pgt.348.1628249818275;
        Fri, 06 Aug 2021 04:36:58 -0700 (PDT)
Received: from garuda ([122.179.62.73])
        by smtp.gmail.com with ESMTPSA id f15sm11191160pgv.92.2021.08.06.04.36.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 04:36:57 -0700 (PDT)
References: <162814684332.2777088.14593133806068529811.stgit@magnolia> <162814686549.2777088.4887361021850034662.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: grab active perag ref when reading AG headers
Date:   Fri, 06 Aug 2021 16:55:27 +0530
Message-ID: <87y29eiz9i.fsf@garuda>
In-reply-to: <162814686549.2777088.4887361021850034662.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Aug 2021 at 00:01, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> This patch prepares scrub to deal with the possibility of tearing down
> entire AGs by changing the order of resource acquisition to match the
> rest of the XFS codebase.  In other words, scrub now grabs AG resources
> in order of: perag structure, then AGI/AGF/AGFL buffers, then btree
> cursors; and releases them in reverse order.
>
> This requires us to distinguish xchk_ag_init callers -- some are
> responding to a user request to check AG metadata, in which case we can
> return ENOENT to userspace; but other callers have an ondisk reference
> to an AG that they're trying to cross-reference.  In this second case,
> the lack of an AG means there's ondisk corruption, since ondisk metadata
> cannot point into nonexistent space.
>

As mentioned above, with this patch applied, scrub code either obtains a
reference to a metadata belonging to an AG or obtain a reference to the pag
structure during setup phase. Also, a reference to the pag structure is
obtained before getting a reference to AGI, AGF and AGFL. Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader.c        |   23 +++++++++++++------
>  fs/xfs/scrub/agheader_repair.c |    3 ---
>  fs/xfs/scrub/bmap.c            |    2 +-
>  fs/xfs/scrub/btree.c           |    2 +-
>  fs/xfs/scrub/common.c          |   48 ++++++++++++++++------------------------
>  fs/xfs/scrub/common.h          |   18 ++++++++++++++-
>  fs/xfs/scrub/fscounters.c      |    2 +-
>  fs/xfs/scrub/inode.c           |    2 +-
>  8 files changed, 56 insertions(+), 44 deletions(-)
>
>
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index be1a7e1e65f7..6152ce01c057 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -36,7 +36,7 @@ xchk_superblock_xref(
>  
>  	agbno = XFS_SB_BLOCK(mp);
>  
> -	error = xchk_ag_init(sc, agno, &sc->sa);
> +	error = xchk_ag_init_existing(sc, agno, &sc->sa);
>  	if (!xchk_xref_process_error(sc, agno, agbno, &error))
>  		return;
>  
> @@ -63,6 +63,7 @@ xchk_superblock(
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_buf		*bp;
>  	struct xfs_dsb		*sb;
> +	struct xfs_perag	*pag;
>  	xfs_agnumber_t		agno;
>  	uint32_t		v2_ok;
>  	__be32			features_mask;
> @@ -73,6 +74,15 @@ xchk_superblock(
>  	if (agno == 0)
>  		return 0;
>  
> +	/*
> +	 * Grab an active reference to the perag structure.  If we can't get
> +	 * it, we're racing with something that's tearing down the AG, so
> +	 * signal that the AG no longer exists.
> +	 */
> +	pag = xfs_perag_get(mp, agno);
> +	if (!pag)
> +		return -ENOENT;
> +
>  	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
>  	/*
>  	 * The superblock verifier can return several different error codes
> @@ -92,7 +102,7 @@ xchk_superblock(
>  		break;
>  	}
>  	if (!xchk_process_error(sc, agno, XFS_SB_BLOCK(mp), &error))
> -		return error;
> +		goto out_pag;
>  
>  	sb = bp->b_addr;
>  
> @@ -336,7 +346,8 @@ xchk_superblock(
>  		xchk_block_set_corrupt(sc, bp);
>  
>  	xchk_superblock_xref(sc, bp);
> -
> +out_pag:
> +	xfs_perag_put(pag);
>  	return error;
>  }
>  
> @@ -527,6 +538,7 @@ xchk_agf(
>  	xchk_buffer_recheck(sc, sc->sa.agf_bp);
>  
>  	agf = sc->sa.agf_bp->b_addr;
> +	pag = sc->sa.pag;
>  
>  	/* Check the AG length */
>  	eoag = be32_to_cpu(agf->agf_length);
> @@ -582,7 +594,6 @@ xchk_agf(
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  
>  	/* Do the incore counters match? */
> -	pag = xfs_perag_get(mp, agno);
>  	if (pag->pagf_freeblks != be32_to_cpu(agf->agf_freeblks))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  	if (pag->pagf_flcount != be32_to_cpu(agf->agf_flcount))
> @@ -590,7 +601,6 @@ xchk_agf(
>  	if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb) &&
>  	    pag->pagf_btreeblks != be32_to_cpu(agf->agf_btreeblks))
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
> -	xfs_perag_put(pag);
>  
>  	xchk_agf_xref(sc);
>  out:
> @@ -857,6 +867,7 @@ xchk_agi(
>  	xchk_buffer_recheck(sc, sc->sa.agi_bp);
>  
>  	agi = sc->sa.agi_bp->b_addr;
> +	pag = sc->sa.pag;
>  
>  	/* Check the AG length */
>  	eoag = be32_to_cpu(agi->agi_length);
> @@ -909,12 +920,10 @@ xchk_agi(
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  
>  	/* Do the incore counters match? */
> -	pag = xfs_perag_get(mp, agno);
>  	if (pag->pagi_count != be32_to_cpu(agi->agi_count))
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
>  	if (pag->pagi_freecount != be32_to_cpu(agi->agi_freecount))
>  		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
> -	xfs_perag_put(pag);
>  
>  	xchk_agi_xref(sc);
>  out:
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index e95f8c98f0f7..f122f2e20e79 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -366,7 +366,6 @@ xrep_agf(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return -EOPNOTSUPP;
>  
> -	xchk_perag_get(sc->mp, &sc->sa);
>  	/*
>  	 * Make sure we have the AGF buffer, as scrub might have decided it
>  	 * was corrupt after xfs_alloc_read_agf failed with -EFSCORRUPTED.
> @@ -641,7 +640,6 @@ xrep_agfl(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return -EOPNOTSUPP;
>  
> -	xchk_perag_get(sc->mp, &sc->sa);
>  	xbitmap_init(&agfl_extents);
>  
>  	/*
> @@ -896,7 +894,6 @@ xrep_agi(
>  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		return -EOPNOTSUPP;
>  
> -	xchk_perag_get(sc->mp, &sc->sa);
>  	/*
>  	 * Make sure we have the AGI buffer, as scrub might have decided it
>  	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 14e952d116f4..a5ca2856df8b 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -260,7 +260,7 @@ xchk_bmap_iextent_xref(
>  	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
>  	len = irec->br_blockcount;
>  
> -	error = xchk_ag_init(info->sc, agno, &info->sc->sa);
> +	error = xchk_ag_init_existing(info->sc, agno, &info->sc->sa);
>  	if (!xchk_fblock_process_error(info->sc, info->whichfork,
>  			irec->br_startoff, &error))
>  		return;
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index bd1172358964..c044e0a8da7f 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -374,7 +374,7 @@ xchk_btree_check_block_owner(
>  
>  	init_sa = bs->cur->bc_flags & XFS_BTREE_LONG_PTRS;
>  	if (init_sa) {
> -		error = xchk_ag_init(bs->sc, agno, &bs->sc->sa);
> +		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
>  		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
>  				level, &error))
>  			return error;
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index e86854171b0c..0ef96ed71017 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -394,11 +394,11 @@ want_ag_read_header_failure(
>  }
>  
>  /*
> - * Grab all the headers for an AG.
> + * Grab the perag structure and all the headers for an AG.
>   *
> - * The headers should be released by xchk_ag_free, but as a fail
> - * safe we attach all the buffers we grab to the scrub transaction so
> - * they'll all be freed when we cancel it.
> + * The headers should be released by xchk_ag_free, but as a fail safe we attach
> + * all the buffers we grab to the scrub transaction so they'll all be freed
> + * when we cancel it.  Returns ENOENT if we can't grab the perag structure.
>   */
>  int
>  xchk_ag_read_headers(
> @@ -409,22 +409,26 @@ xchk_ag_read_headers(
>  	struct xfs_mount	*mp = sc->mp;
>  	int			error;
>  
> +	ASSERT(!sa->pag);
> +	sa->pag = xfs_perag_get(mp, agno);
> +	if (!sa->pag)
> +		return -ENOENT;
> +
>  	sa->agno = agno;
>  
>  	error = xfs_ialloc_read_agi(mp, sc->tp, agno, &sa->agi_bp);
>  	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
> -		goto out;
> +		return error;
>  
>  	error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &sa->agf_bp);
>  	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
> -		goto out;
> +		return error;
>  
>  	error = xfs_alloc_read_agfl(mp, sc->tp, agno, &sa->agfl_bp);
>  	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGFL))
> -		goto out;
> -	error = 0;
> -out:
> -	return error;
> +		return error;
> +
> +	return 0;
>  }
>  
>  /* Release all the AG btree cursors. */
> @@ -461,7 +465,6 @@ xchk_ag_btcur_init(
>  {
>  	struct xfs_mount	*mp = sc->mp;
>  
> -	xchk_perag_get(sc->mp, sa);
>  	if (sa->agf_bp &&
>  	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_BNO)) {
>  		/* Set up a bnobt cursor for cross-referencing. */
> @@ -532,11 +535,11 @@ xchk_ag_free(
>  }
>  
>  /*
> - * For scrub, grab the AGI and the AGF headers, in that order.  Locking
> - * order requires us to get the AGI before the AGF.  We use the
> - * transaction to avoid deadlocking on crosslinked metadata buffers;
> - * either the caller passes one in (bmap scrub) or we have to create a
> - * transaction ourselves.
> + * For scrub, grab the perag structure, the AGI, and the AGF headers, in that
> + * order.  Locking order requires us to get the AGI before the AGF.  We use the
> + * transaction to avoid deadlocking on crosslinked metadata buffers; either the
> + * caller passes one in (bmap scrub) or we have to create a transaction
> + * ourselves.  Returns ENOENT if the perag struct cannot be grabbed.
>   */
>  int
>  xchk_ag_init(
> @@ -554,19 +557,6 @@ xchk_ag_init(
>  	return 0;
>  }
>  
> -/*
> - * Grab the per-ag structure if we haven't already gotten it.  Teardown of the
> - * xchk_ag will release it for us.
> - */
> -void
> -xchk_perag_get(
> -	struct xfs_mount	*mp,
> -	struct xchk_ag		*sa)
> -{
> -	if (!sa->pag)
> -		sa->pag = xfs_perag_get(mp, sa->agno);
> -}
> -
>  /* Per-scrubber setup functions */
>  
>  /*
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 0410faf7d735..454145db10e7 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -107,7 +107,23 @@ int xchk_setup_fscounters(struct xfs_scrub *sc);
>  void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
>  int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
>  		struct xchk_ag *sa);
> -void xchk_perag_get(struct xfs_mount *mp, struct xchk_ag *sa);
> +
> +/*
> + * Grab all AG resources, treating the inability to grab the perag structure as
> + * a fs corruption.  This is intended for callers checking an ondisk reference
> + * to a given AG, which means that the AG must still exist.
> + */
> +static inline int
> +xchk_ag_init_existing(
> +	struct xfs_scrub	*sc,
> +	xfs_agnumber_t		agno,
> +	struct xchk_ag		*sa)
> +{
> +	int			error = xchk_ag_init(sc, agno, sa);
> +
> +	return error == -ENOENT ? -EFSCORRUPTED : error;
> +}
> +
>  int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
>  		struct xchk_ag *sa);
>  void xchk_ag_btcur_free(struct xchk_ag *sa);
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index e03577af63d9..74e331afe49d 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -146,7 +146,7 @@ xchk_fscount_btreeblks(
>  	xfs_extlen_t		blocks;
>  	int			error;
>  
> -	error = xchk_ag_init(sc, agno, &sc->sa);
> +	error = xchk_ag_init_existing(sc, agno, &sc->sa);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 76fbc7ca4cec..a6a68ba19f0a 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -532,7 +532,7 @@ xchk_inode_xref(
>  	agno = XFS_INO_TO_AGNO(sc->mp, ino);
>  	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
>  
> -	error = xchk_ag_init(sc, agno, &sc->sa);
> +	error = xchk_ag_init_existing(sc, agno, &sc->sa);
>  	if (!xchk_xref_process_error(sc, agno, agbno, &error))
>  		return;
>  


-- 
chandan
