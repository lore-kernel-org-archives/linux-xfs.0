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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF566C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 07:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A6761179
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 07:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243560AbhHFHTg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbhHFHTc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 03:19:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB4FC061798
        for <linux-xfs@vger.kernel.org>; Fri,  6 Aug 2021 00:19:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so12316813pjn.4
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 00:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=t3gNdApztQvCzG+VvMnESrxN/zdV8JfUWIMQoPol2qw=;
        b=W+dzxXH5hUBGrBy4T8zQ/NHqqRhUtKbvIgSFCrSy0+MTwH5OCzJakPza6xndzTZHL5
         AOkqTlgLmOuGknWyay1Nl6oevOp4rgNolD3bazzwDaY6gpS01haNXIwObMw64mO84JHG
         ipNOv6rfXCkY5BGDMj9kBdOthbnun25t2RpfMi9d94i0YNHcGjdCJqcLQTjF3KLIzVwl
         dTh1DKwwrxT88XCmFud2uIk3CspIJA+MowMg4H+rG5ENb03lOk/HxTj9sbX96fJTKrai
         iaea8wwonS3GsEUvbJnuU1Wj7gUU5JT7dex/XBzPXbdFPG8v1+sOo4b1kVHVKbZJz3LE
         sPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=t3gNdApztQvCzG+VvMnESrxN/zdV8JfUWIMQoPol2qw=;
        b=moncWUfyH9vjdBPvjfVfINjbGFT03DVVMUqmFGWLo8hsKjM+omuDpqpEX4FRLS265V
         3ow2pcMdpIASQt+YTDFFxvfRFRLCJfnlL0zsQjcNKSvOCu0W75T49u6klmZatSJMduB/
         k/7riAc8/ItyDjHDOG6F6gAwvJNqe4uCREDKDqNw/fcDnd5YdAuUmRcC4dUDts9FnLMX
         hIMmg24Y7l9xKAlRp12naCDk4RaAOq9bwmtaDzuEtdwIQYzvVZRHdpBX8u2AP2T1IX0/
         e6ST9FZBgDM5UD+RKwrMqd9FvOYAhqpoLIcnwIWhlk5rX8ddxQFc5SwUq1Nq4WRfeZ+Z
         13Jg==
X-Gm-Message-State: AOAM531a3nJrGCYvgE1Qv7I0WzxtwBfsoCnO+2VPzgZcb6jGKXQl67vU
        +zydRPOwp8R/SWSnDOQ5Nx9/K9LI9CU=
X-Google-Smtp-Source: ABdhPJxZNKC7IyPIOoq0I4jXw7i/pDduDxNCPGrnJQnkV4oYJ8Uljb/0zHxeC8dLIasGCOar5SxCBA==
X-Received: by 2002:a17:90b:34a:: with SMTP id fh10mr8827054pjb.134.1628234355817;
        Fri, 06 Aug 2021 00:19:15 -0700 (PDT)
Received: from garuda ([122.179.62.73])
        by smtp.gmail.com with ESMTPSA id s14sm9126467pfg.220.2021.08.06.00.19.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 06 Aug 2021 00:19:15 -0700 (PDT)
References: <162814684332.2777088.14593133806068529811.stgit@magnolia> <162814685996.2777088.11268635137040103857.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: automatic resource cleanup of for_each_perag*
Date:   Fri, 06 Aug 2021 12:45:19 +0530
Message-ID: <874kc3jb5i.fsf@garuda>
In-reply-to: <162814685996.2777088.11268635137040103857.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 05 Aug 2021 at 00:01, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Jan Kara pointed me to a magic gcc attribute that schedules a finalizer
> function to run against any automatic variable that's going out of
> scope.  Provided nobody minds compiling XFS with gnu99 instead of c89,
> we can use this capability to define a loop-scope iterator variable that
> will trigger the automatic finalizer, which means that we don't have to
> burden for_each_perag* callers with the necessity of manually putting
> the perag structures when exiting the loop body.
>

The behaviour of the code before and after the changes are applied looks to be
the same. Hence,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/Makefile           |    3 ++
>  fs/xfs/libxfs/xfs_ag.h    |   66 +++++++++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_sb.c    |   17 ++++++------
>  fs/xfs/libxfs/xfs_types.c |    6 +---
>  fs/xfs/scrub/bmap.c       |    8 +----
>  fs/xfs/scrub/fscounters.c |   41 ++++++++++++----------------
>  fs/xfs/xfs_extent_busy.c  |   11 +++-----
>  fs/xfs/xfs_fsmap.c        |   25 ++++++-----------
>  fs/xfs/xfs_fsops.c        |   12 +++-----
>  fs/xfs/xfs_health.c       |    9 +++---
>  fs/xfs/xfs_icache.c       |   27 ++++++------------
>  fs/xfs/xfs_iwalk.c        |   41 +++++++++++-----------------
>  fs/xfs/xfs_log_recover.c  |   21 ++++++--------
>  fs/xfs/xfs_reflink.c      |   10 ++-----
>  14 files changed, 135 insertions(+), 162 deletions(-)
>
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 04611a1068b4..e482cb43743d 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -7,6 +7,9 @@
>  ccflags-y += -I $(srctree)/$(src)		# needed for trace events
>  ccflags-y += -I $(srctree)/$(src)/libxfs
>  
> +# Required for for_each_perag*
> +ccflags-y += -std=gnu99
> +
>  obj-$(CONFIG_XFS_FS)		+= xfs.o
>  
>  # this one should be compiled first, as the tracing macros can easily blow up
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 4c6f9045baca..5141e8936912 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -116,35 +116,53 @@ void xfs_perag_put(struct xfs_perag *pag);
>  
>  /*
>   * Perag iteration APIs
> - *
> - * XXX: for_each_perag_range() usage really needs an iterator to clean up when
> - * we terminate at end_agno because we may have taken a reference to the perag
> - * beyond end_agno. Right now callers have to be careful to catch and clean that
> - * up themselves. This is not necessary for the callers of for_each_perag() and
> - * for_each_perag_from() because they terminate at sb_agcount where there are
> - * no perag structures in tree beyond end_agno.
>   */
> -#define for_each_perag_range(mp, next_agno, end_agno, pag) \
> -	for ((pag) = xfs_perag_get((mp), (next_agno)); \
> -		(pag) != NULL && (next_agno) <= (end_agno); \
> -		(next_agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_put(pag), \
> -		(pag) = xfs_perag_get((mp), (next_agno)))
> +struct xfs_perag_iter {
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		__agno;
> +};
>  
> -#define for_each_perag_from(mp, next_agno, pag) \
> -	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
> +static inline void
> +xfs_perag_iter_cleanup(struct xfs_perag_iter *pagit)
> +{
> +	if (pagit->pag)
> +		xfs_perag_put(pagit->pag);
> +	pagit->pag = NULL;
> +	pagit->__agno = NULLAGNUMBER;
> +}
>  
> +#define XFS_PERAG_ITER_INIT(mp, name, first_agno)	\
> +	struct xfs_perag_iter name \
> +			__attribute__((__cleanup__(xfs_perag_iter_cleanup))) = \
> +			{ .__agno = (first_agno), \
> +			  .pag = xfs_perag_get((mp), (first_agno)), }
>  
> -#define for_each_perag(mp, agno, pag) \
> -	(agno) = 0; \
> -	for_each_perag_from((mp), (agno), (pag))
> +#define XFS_PERAG_TAG_ITER_INIT(mp, name, first_agno, tag)	\
> +	struct xfs_perag_iter name \
> +			__attribute__((__cleanup__(xfs_perag_iter_cleanup))) = \
> +			{ .__agno = (first_agno), \
> +			  .pag = xfs_perag_get_tag((mp), (first_agno), (tag)), }
>  
> -#define for_each_perag_tag(mp, agno, pag, tag) \
> -	for ((agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
> -		(pag) != NULL; \
> -		(agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_put(pag), \
> -		(pag) = xfs_perag_get_tag((mp), (agno), (tag)))
> +/* Perag iteration APIs */
> +#define for_each_perag_range(mp, name, start_agno, end_agno) \
> +	for (XFS_PERAG_ITER_INIT((mp), (name), (start_agno)); \
> +		(name).pag != NULL && (name).__agno <= (end_agno); \
> +		(name).__agno = (name).pag->pag_agno + 1, \
> +		xfs_perag_put((name).pag), \
> +		(name).pag = xfs_perag_get((mp), (name).__agno))
> +
> +#define for_each_perag_from(mp, name, start_agno) \
> +	for_each_perag_range((mp), (name), (start_agno), (mp)->m_sb.sb_agcount)
> +
> +#define for_each_perag(mp, name) \
> +	for_each_perag_from((mp), (name), 0)
> +
> +#define for_each_perag_tag(mp, name, tag) \
> +	for (XFS_PERAG_TAG_ITER_INIT((mp), (name), 0, (tag)); \
> +		(name).pag != NULL; \
> +		(name).__agno = (name).pag->pag_agno + 1, \
> +		xfs_perag_put((name).pag), \
> +		(name).pag = xfs_perag_get_tag((mp), (name).__agno, (tag)))
>  
>  struct aghdr_init_data {
>  	/* per ag data */
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 04f5386446db..a0a07ebaf41b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -856,18 +856,19 @@ int
>  xfs_update_secondary_sbs(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno = 1;
> +	xfs_agnumber_t		last_agno = 0;
>  	int			saved_error = 0;
>  	int			error = 0;
>  	LIST_HEAD		(buffer_list);
>  
>  	/* update secondary superblocks. */
> -	for_each_perag_from(mp, agno, pag) {
> +	for_each_perag_from(mp, iter, 1) {
>  		struct xfs_buf		*bp;
>  
> +		last_agno = iter.pag->pag_agno;
> +
>  		error = xfs_buf_get(mp->m_ddev_targp,
> -				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
> +				 XFS_AG_DADDR(mp, last_agno, XFS_SB_DADDR),
>  				 XFS_FSS_TO_BB(mp, 1), &bp);
>  		/*
>  		 * If we get an error reading or writing alternate superblocks,
> @@ -879,7 +880,7 @@ xfs_update_secondary_sbs(
>  		if (error) {
>  			xfs_warn(mp,
>  		"error allocating secondary superblock for ag %d",
> -				pag->pag_agno);
> +				last_agno);
>  			if (!saved_error)
>  				saved_error = error;
>  			continue;
> @@ -893,14 +894,14 @@ xfs_update_secondary_sbs(
>  		xfs_buf_relse(bp);
>  
>  		/* don't hold too many buffers at once */
> -		if (agno % 16)
> +		if (last_agno % 16)
>  			continue;
>  
>  		error = xfs_buf_delwri_submit(&buffer_list);
>  		if (error) {
>  			xfs_warn(mp,
>  		"write error %d updating a secondary superblock near ag %d",
> -				error, pag->pag_agno);
> +				error, last_agno);
>  			if (!saved_error)
>  				saved_error = error;
>  			continue;
> @@ -910,7 +911,7 @@ xfs_update_secondary_sbs(
>  	if (error) {
>  		xfs_warn(mp,
>  		"write error %d updating a secondary superblock near ag %d",
> -			error, agno);
> +			error, last_agno);
>  	}
>  
>  	return saved_error ? saved_error : error;
> diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
> index e8f4abee7892..8654b46b7c60 100644
> --- a/fs/xfs/libxfs/xfs_types.c
> +++ b/fs/xfs/libxfs/xfs_types.c
> @@ -223,16 +223,14 @@ xfs_icount_range(
>  	unsigned long long	*max)
>  {
>  	unsigned long long	nr_inos = 0;
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
>  
>  	/* root, rtbitmap, rtsum all live in the first chunk */
>  	*min = XFS_INODES_PER_CHUNK;
>  
> -	for_each_perag(mp, agno, pag) {
> +	for_each_perag(mp, iter) {
>  		xfs_agino_t	first, last;
>  
> -		xfs_agino_range(mp, agno, &first, &last);
> +		xfs_agino_range(mp, iter.pag->pag_agno, &first, &last);
>  		nr_inos += last - first + 1;
>  	}
>  	*max = nr_inos;
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index 1d146c9d9de1..14e952d116f4 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -576,8 +576,6 @@ xchk_bmap_check_rmaps(
>  	int			whichfork)
>  {
>  	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, whichfork);
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
>  	bool			zero_size;
>  	int			error;
>  
> @@ -609,15 +607,13 @@ xchk_bmap_check_rmaps(
>  	    (zero_size || ifp->if_nextents > 0))
>  		return 0;
>  
> -	for_each_perag(sc->mp, agno, pag) {
> -		error = xchk_bmap_check_ag_rmaps(sc, whichfork, pag);
> +	for_each_perag(sc->mp, iter) {
> +		error = xchk_bmap_check_ag_rmaps(sc, whichfork, iter.pag);
>  		if (error)
>  			break;
>  		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  			break;
>  	}
> -	if (pag)
> -		xfs_perag_put(pag);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index fd7941e04ae1..e03577af63d9 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -67,21 +67,21 @@ xchk_fscount_warmup(
>  	struct xfs_mount	*mp = sc->mp;
>  	struct xfs_buf		*agi_bp = NULL;
>  	struct xfs_buf		*agf_bp = NULL;
> -	struct xfs_perag	*pag = NULL;
> -	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
> -	for_each_perag(mp, agno, pag) {
> +	for_each_perag(mp, iter) {
>  		if (xchk_should_terminate(sc, &error))
>  			break;
> -		if (pag->pagi_init && pag->pagf_init)
> +		if (iter.pag->pagi_init && iter.pag->pagf_init)
>  			continue;
>  
>  		/* Lock both AG headers. */
> -		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
> +		error = xfs_ialloc_read_agi(mp, sc->tp, iter.pag->pag_agno,
> +				&agi_bp);
>  		if (error)
>  			break;
> -		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
> +		error = xfs_alloc_read_agf(mp, sc->tp, iter.pag->pag_agno, 0,
> +				&agf_bp);
>  		if (error)
>  			break;
>  
> @@ -89,7 +89,7 @@ xchk_fscount_warmup(
>  		 * These are supposed to be initialized by the header read
>  		 * function.
>  		 */
> -		if (!pag->pagi_init || !pag->pagf_init) {
> +		if (!iter.pag->pagi_init || !iter.pag->pagf_init) {
>  			error = -EFSCORRUPTED;
>  			break;
>  		}
> @@ -104,8 +104,6 @@ xchk_fscount_warmup(
>  		xfs_buf_relse(agf_bp);
>  	if (agi_bp)
>  		xfs_buf_relse(agi_bp);
> -	if (pag)
> -		xfs_perag_put(pag);
>  	return error;
>  }
>  
> @@ -179,9 +177,7 @@ xchk_fscount_aggregate_agcounts(
>  	struct xchk_fscounters	*fsc)
>  {
>  	struct xfs_mount	*mp = sc->mp;
> -	struct xfs_perag	*pag;
>  	uint64_t		delayed;
> -	xfs_agnumber_t		agno;
>  	int			tries = 8;
>  	int			error = 0;
>  
> @@ -190,27 +186,28 @@ xchk_fscount_aggregate_agcounts(
>  	fsc->ifree = 0;
>  	fsc->fdblocks = 0;
>  
> -	for_each_perag(mp, agno, pag) {
> +	for_each_perag(mp, iter) {
>  		if (xchk_should_terminate(sc, &error))
>  			break;
>  
>  		/* This somehow got unset since the warmup? */
> -		if (!pag->pagi_init || !pag->pagf_init) {
> +		if (!iter.pag->pagi_init || !iter.pag->pagf_init) {
>  			error = -EFSCORRUPTED;
>  			break;
>  		}
>  
>  		/* Count all the inodes */
> -		fsc->icount += pag->pagi_count;
> -		fsc->ifree += pag->pagi_freecount;
> +		fsc->icount += iter.pag->pagi_count;
> +		fsc->ifree += iter.pag->pagi_freecount;
>  
>  		/* Add up the free/freelist/bnobt/cntbt blocks */
> -		fsc->fdblocks += pag->pagf_freeblks;
> -		fsc->fdblocks += pag->pagf_flcount;
> +		fsc->fdblocks += iter.pag->pagf_freeblks;
> +		fsc->fdblocks += iter.pag->pagf_flcount;
>  		if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb)) {
> -			fsc->fdblocks += pag->pagf_btreeblks;
> +			fsc->fdblocks += iter.pag->pagf_btreeblks;
>  		} else {
> -			error = xchk_fscount_btreeblks(sc, fsc, agno);
> +			error = xchk_fscount_btreeblks(sc, fsc,
> +					iter.pag->pag_agno);
>  			if (error)
>  				break;
>  		}
> @@ -219,12 +216,10 @@ xchk_fscount_aggregate_agcounts(
>  		 * Per-AG reservations are taken out of the incore counters,
>  		 * so they must be left out of the free blocks computation.
>  		 */
> -		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
> -		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
> +		fsc->fdblocks -= iter.pag->pag_meta_resv.ar_reserved;
> +		fsc->fdblocks -= iter.pag->pag_rmapbt_resv.ar_orig_reserved;
>  
>  	}
> -	if (pag)
> -		xfs_perag_put(pag);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ad22a003f959..fe85df915707 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -593,18 +593,17 @@ void
>  xfs_extent_busy_wait_all(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
>  	DEFINE_WAIT		(wait);
> -	xfs_agnumber_t		agno;
>  
> -	for_each_perag(mp, agno, pag) {
> +	for_each_perag(mp, iter) {
>  		do {
> -			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
> -			if  (RB_EMPTY_ROOT(&pag->pagb_tree))
> +			prepare_to_wait(&iter.pag->pagb_wait, &wait,
> +					TASK_KILLABLE);
> +			if  (RB_EMPTY_ROOT(&iter.pag->pagb_tree))
>  				break;
>  			schedule();
>  		} while (1);
> -		finish_wait(&pag->pagb_wait, &wait);
> +		finish_wait(&iter.pag->pagb_wait, &wait);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 7d0b09c1366e..cdf44db29973 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -573,7 +573,6 @@ __xfs_getfsmap_datadev(
>  	void				*priv)
>  {
>  	struct xfs_mount		*mp = tp->t_mountp;
> -	struct xfs_perag		*pag;
>  	struct xfs_btree_cur		*bt_cur = NULL;
>  	xfs_fsblock_t			start_fsb;
>  	xfs_fsblock_t			end_fsb;
> @@ -612,13 +611,13 @@ __xfs_getfsmap_datadev(
>  	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
>  	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
>  
> -	for_each_perag_range(mp, start_ag, end_ag, pag) {
> +	for_each_perag_range(mp, iter, start_ag, end_ag) {
>  		/*
>  		 * Set the AG high key from the fsmap high key if this
>  		 * is the last AG that we're querying.
>  		 */
> -		info->pag = pag;
> -		if (pag->pag_agno == end_ag) {
> +		info->pag = iter.pag;
> +		if (iter.pag->pag_agno == end_ag) {
>  			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
>  					end_fsb);
>  			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
> @@ -636,14 +635,14 @@ __xfs_getfsmap_datadev(
>  			info->agf_bp = NULL;
>  		}
>  
> -		error = xfs_alloc_read_agf(mp, tp, pag->pag_agno, 0,
> +		error = xfs_alloc_read_agf(mp, tp, iter.pag->pag_agno, 0,
>  				&info->agf_bp);
>  		if (error)
>  			break;
>  
> -		trace_xfs_fsmap_low_key(mp, info->dev, pag->pag_agno,
> +		trace_xfs_fsmap_low_key(mp, info->dev, iter.pag->pag_agno,
>  				&info->low);
> -		trace_xfs_fsmap_high_key(mp, info->dev, pag->pag_agno,
> +		trace_xfs_fsmap_high_key(mp, info->dev, iter.pag->pag_agno,
>  				&info->high);
>  
>  		error = query_fn(tp, info, &bt_cur, priv);
> @@ -654,7 +653,7 @@ __xfs_getfsmap_datadev(
>  		 * Set the AG low key to the start of the AG prior to
>  		 * moving on to the next AG.
>  		 */
> -		if (pag->pag_agno == start_ag) {
> +		if (iter.pag->pag_agno == start_ag) {
>  			info->low.rm_startblock = 0;
>  			info->low.rm_owner = 0;
>  			info->low.rm_offset = 0;
> @@ -666,7 +665,7 @@ __xfs_getfsmap_datadev(
>  		 * before we drop the reference to the perag when the loop
>  		 * terminates.
>  		 */
> -		if (pag->pag_agno == end_ag) {
> +		if (iter.pag->pag_agno == end_ag) {
>  			info->last = true;
>  			error = query_fn(tp, info, &bt_cur, priv);
>  			if (error)
> @@ -682,13 +681,7 @@ __xfs_getfsmap_datadev(
>  		xfs_trans_brelse(tp, info->agf_bp);
>  		info->agf_bp = NULL;
>  	}
> -	if (info->pag) {
> -		xfs_perag_put(info->pag);
> -		info->pag = NULL;
> -	} else if (pag) {
> -		/* loop termination case */
> -		xfs_perag_put(pag);
> -	}
> +	info->pag = NULL;
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 6ed29b158312..31f585a525e8 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -570,14 +570,12 @@ int
>  xfs_fs_reserve_ag_blocks(
>  	struct xfs_mount	*mp)
>  {
> -	xfs_agnumber_t		agno;
> -	struct xfs_perag	*pag;
>  	int			error = 0;
>  	int			err2;
>  
>  	mp->m_finobt_nores = false;
> -	for_each_perag(mp, agno, pag) {
> -		err2 = xfs_ag_resv_init(pag, NULL);
> +	for_each_perag(mp, iter) {
> +		err2 = xfs_ag_resv_init(iter.pag, NULL);
>  		if (err2 && !error)
>  			error = err2;
>  	}
> @@ -598,13 +596,11 @@ int
>  xfs_fs_unreserve_ag_blocks(
>  	struct xfs_mount	*mp)
>  {
> -	xfs_agnumber_t		agno;
> -	struct xfs_perag	*pag;
>  	int			error = 0;
>  	int			err2;
>  
> -	for_each_perag(mp, agno, pag) {
> -		err2 = xfs_ag_resv_free(pag);
> +	for_each_perag(mp, iter) {
> +		err2 = xfs_ag_resv_free(iter.pag);
>  		if (err2 && !error)
>  			error = err2;
>  	}
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index eb10eacabc8f..715a987b8204 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -24,8 +24,6 @@ void
>  xfs_health_unmount(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
>  	unsigned int		sick = 0;
>  	unsigned int		checked = 0;
>  	bool			warn = false;
> @@ -34,10 +32,11 @@ xfs_health_unmount(
>  		return;
>  
>  	/* Measure AG corruption levels. */
> -	for_each_perag(mp, agno, pag) {
> -		xfs_ag_measure_sickness(pag, &sick, &checked);
> +	for_each_perag(mp, iter) {
> +		xfs_ag_measure_sickness(iter.pag, &sick, &checked);
>  		if (sick) {
> -			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
> +			trace_xfs_ag_unfixed_corruption(mp, iter.pag->pag_agno,
> +					sick);
>  			warn = true;
>  		}
>  	}
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6741e27603ad..1d4006df4066 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1368,14 +1368,11 @@ void
>  xfs_blockgc_stop(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
> -
>  	if (!xfs_clear_blockgc_enabled(mp))
>  		return;
>  
> -	for_each_perag(mp, agno, pag)
> -		cancel_delayed_work_sync(&pag->pag_blockgc_work);
> +	for_each_perag(mp, iter)
> +		cancel_delayed_work_sync(&iter.pag->pag_blockgc_work);
>  	trace_xfs_blockgc_stop(mp, __return_address);
>  }
>  
> @@ -1384,15 +1381,12 @@ void
>  xfs_blockgc_start(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
> -
>  	if (xfs_set_blockgc_enabled(mp))
>  		return;
>  
>  	trace_xfs_blockgc_start(mp, __return_address);
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> -		xfs_blockgc_queue(pag);
> +	for_each_perag_tag(mp, iter, XFS_ICI_BLOCKGC_TAG)
> +		xfs_blockgc_queue(iter.pag);
>  }
>  
>  /* Don't try to run block gc on an inode that's in any of these states. */
> @@ -1515,9 +1509,6 @@ void
>  xfs_blockgc_flush_all(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
> -
>  	trace_xfs_blockgc_flush_all(mp, __return_address);
>  
>  	/*
> @@ -1525,12 +1516,12 @@ xfs_blockgc_flush_all(
>  	 * wasn't queued, it will not be requeued.  Then flush whatever's
>  	 * left.
>  	 */
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> -		mod_delayed_work(pag->pag_mount->m_blockgc_wq,
> -				&pag->pag_blockgc_work, 0);
> +	for_each_perag_tag(mp, iter, XFS_ICI_BLOCKGC_TAG)
> +		mod_delayed_work(mp->m_blockgc_wq, &iter.pag->pag_blockgc_work,
> +				0);
>  
> -	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
> -		flush_delayed_work(&pag->pag_blockgc_work);
> +	for_each_perag_tag(mp, iter, XFS_ICI_BLOCKGC_TAG)
> +		flush_delayed_work(&iter.pag->pag_blockgc_work);
>  
>  	xfs_inodegc_flush(mp);
>  }
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 7558486f4937..0c06a59aec79 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -568,30 +568,27 @@ xfs_iwalk(
>  		.pwork		= XFS_PWORK_SINGLE_THREADED,
>  		.lastino	= NULLFSINO,
>  	};
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> +	xfs_agnumber_t		start_agno = XFS_INO_TO_AGNO(mp, startino);
>  	int			error;
>  
> -	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(start_agno < mp->m_sb.sb_agcount);
>  	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
>  
>  	error = xfs_iwalk_alloc(&iwag);
>  	if (error)
>  		return error;
>  
> -	for_each_perag_from(mp, agno, pag) {
> -		iwag.pag = pag;
> +	for_each_perag_from(mp, iter, start_agno) {
> +		iwag.pag = iter.pag;
>  		error = xfs_iwalk_ag(&iwag);
>  		if (error)
>  			break;
> -		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +		iwag.startino = XFS_AGINO_TO_INO(mp, iter.pag->pag_agno + 1, 0);
>  		if (flags & XFS_INOBT_WALK_SAME_AG)
>  			break;
>  		iwag.pag = NULL;
>  	}
>  
> -	if (iwag.pag)
> -		xfs_perag_put(pag);
>  	xfs_iwalk_free(&iwag);
>  	return error;
>  }
> @@ -646,18 +643,17 @@ xfs_iwalk_threaded(
>  	void			*data)
>  {
>  	struct xfs_pwork_ctl	pctl;
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> +	xfs_agnumber_t		start_agno = XFS_INO_TO_AGNO(mp, startino);
>  	int			error;
>  
> -	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(start_agno < mp->m_sb.sb_agcount);
>  	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
>  
>  	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk");
>  	if (error)
>  		return error;
>  
> -	for_each_perag_from(mp, agno, pag) {
> +	for_each_perag_from(mp, iter, start_agno) {
>  		struct xfs_iwalk_ag	*iwag;
>  
>  		if (xfs_pwork_ctl_want_abort(&pctl))
> @@ -670,20 +666,18 @@ xfs_iwalk_threaded(
>  		 * perag is being handed off to async work, so take another
>  		 * reference for the async work to release.
>  		 */
> -		atomic_inc(&pag->pag_ref);
> -		iwag->pag = pag;
> +		atomic_inc(&iter.pag->pag_ref);
> +		iwag->pag = iter.pag;
>  		iwag->iwalk_fn = iwalk_fn;
>  		iwag->data = data;
>  		iwag->startino = startino;
>  		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
>  		iwag->lastino = NULLFSINO;
>  		xfs_pwork_queue(&pctl, &iwag->pwork);
> -		startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
> +		startino = XFS_AGINO_TO_INO(mp, iter.pag->pag_agno + 1, 0);
>  		if (flags & XFS_INOBT_WALK_SAME_AG)
>  			break;
>  	}
> -	if (pag)
> -		xfs_perag_put(pag);
>  	if (polled)
>  		xfs_pwork_poll(&pctl);
>  	return xfs_pwork_destroy(&pctl);
> @@ -753,30 +747,27 @@ xfs_inobt_walk(
>  		.pwork		= XFS_PWORK_SINGLE_THREADED,
>  		.lastino	= NULLFSINO,
>  	};
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> +	xfs_agnumber_t		start_agno = XFS_INO_TO_AGNO(mp, startino);
>  	int			error;
>  
> -	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(start_agno < mp->m_sb.sb_agcount);
>  	ASSERT(!(flags & ~XFS_INOBT_WALK_FLAGS_ALL));
>  
>  	error = xfs_iwalk_alloc(&iwag);
>  	if (error)
>  		return error;
>  
> -	for_each_perag_from(mp, agno, pag) {
> -		iwag.pag = pag;
> +	for_each_perag_from(mp, iter, start_agno) {
> +		iwag.pag = iter.pag;
>  		error = xfs_iwalk_ag(&iwag);
>  		if (error)
>  			break;
> -		iwag.startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
> +		iwag.startino = XFS_AGINO_TO_INO(mp, iter.pag->pag_agno + 1, 0);
>  		if (flags & XFS_INOBT_WALK_SAME_AG)
>  			break;
>  		iwag.pag = NULL;
>  	}
>  
> -	if (iwag.pag)
> -		xfs_perag_put(pag);
>  	xfs_iwalk_free(&iwag);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index a98d2429d795..d51c03dbb01b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2745,16 +2745,14 @@ xlog_recover_process_iunlinks(
>  	struct xlog	*log)
>  {
>  	struct xfs_mount	*mp = log->l_mp;
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
>  	struct xfs_agi		*agi;
>  	struct xfs_buf		*agibp;
>  	xfs_agino_t		agino;
>  	int			bucket;
>  	int			error;
>  
> -	for_each_perag(mp, agno, pag) {
> -		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
> +	for_each_perag(mp, iter) {
> +		error = xfs_read_agi(mp, NULL, iter.pag->pag_agno, &agibp);
>  		if (error) {
>  			/*
>  			 * AGI is b0rked. Don't process it.
> @@ -2780,7 +2778,8 @@ xlog_recover_process_iunlinks(
>  			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
>  			while (agino != NULLAGINO) {
>  				agino = xlog_recover_process_one_iunlink(mp,
> -						pag->pag_agno, agino, bucket);
> +						iter.pag->pag_agno, agino,
> +						bucket);
>  				cond_resched();
>  			}
>  		}
> @@ -3503,10 +3502,8 @@ xlog_recover_check_summary(
>  	struct xlog		*log)
>  {
>  	struct xfs_mount	*mp = log->l_mp;
> -	struct xfs_perag	*pag;
>  	struct xfs_buf		*agfbp;
>  	struct xfs_buf		*agibp;
> -	xfs_agnumber_t		agno;
>  	uint64_t		freeblks;
>  	uint64_t		itotal;
>  	uint64_t		ifree;
> @@ -3517,11 +3514,11 @@ xlog_recover_check_summary(
>  	freeblks = 0LL;
>  	itotal = 0LL;
>  	ifree = 0LL;
> -	for_each_perag(mp, agno, pag) {
> -		error = xfs_read_agf(mp, NULL, pag->pag_agno, 0, &agfbp);
> +	for_each_perag(mp, iter) {
> +		error = xfs_read_agf(mp, NULL, iter.pag->pag_agno, 0, &agfbp);
>  		if (error) {
>  			xfs_alert(mp, "%s agf read failed agno %d error %d",
> -						__func__, pag->pag_agno, error);
> +					__func__, iter.pag->pag_agno, error);
>  		} else {
>  			struct xfs_agf	*agfp = agfbp->b_addr;
>  
> @@ -3530,10 +3527,10 @@ xlog_recover_check_summary(
>  			xfs_buf_relse(agfbp);
>  		}
>  
> -		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
> +		error = xfs_read_agi(mp, NULL, iter.pag->pag_agno, &agibp);
>  		if (error) {
>  			xfs_alert(mp, "%s agi read failed agno %d error %d",
> -						__func__, pag->pag_agno, error);
> +					__func__, iter.pag->pag_agno, error);
>  		} else {
>  			struct xfs_agi	*agi = agibp->b_addr;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index c256104772cb..bc19291c577d 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -755,19 +755,15 @@ int
>  xfs_reflink_recover_cow(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_perag	*pag;
> -	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
>  	if (!xfs_sb_version_hasreflink(&mp->m_sb))
>  		return 0;
>  
> -	for_each_perag(mp, agno, pag) {
> -		error = xfs_refcount_recover_cow_leftovers(mp, pag);
> -		if (error) {
> -			xfs_perag_put(pag);
> +	for_each_perag(mp, iter) {
> +		error = xfs_refcount_recover_cow_leftovers(mp, iter.pag);
> +		if (error)
>  			break;
> -		}
>  	}
>  
>  	return error;


-- 
chandan
