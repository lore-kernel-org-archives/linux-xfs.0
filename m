Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCB0C38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 00:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiJZAki (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJZAkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 20:40:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BCF63F25
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 17:40:34 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id jo13so8912786plb.13
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 17:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k2A1U85sPVAtCml064YtwOEr/26e0okYylNH2hy5AHA=;
        b=yfG09dQB5CtN1K6OZBS8GWc5lGT7/pOHVV4/EpbO+f2IABzFlPYrZtAbmtq2cWUe20
         G7GDbpeiNLiVrttfr1+t7f3FS9EuFPQcW12pY3IhvsuYGEKpy1AT+fE7ZpRt9+lIUlY7
         /6AiEM5VV3q4vF05gRxN9W5CluGZ5D6ptqfinVxNNTRNuelOszN8uGbflomxR9j2N8wr
         JP5zzdU3PoZqBXCD0Ghw19pX4aTak0xc21OoooqLIIy8o1zmVvWBIct4GjXCXBMRzlQA
         Z7Fa6XApZK10LDI+6QcoAwSv6pm4SptJpURZuV1fpGAMvHdB7fp2mWK+gNMdz748sa+l
         w1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k2A1U85sPVAtCml064YtwOEr/26e0okYylNH2hy5AHA=;
        b=wQXv+cS7Ln3NLkyth5/Ivr1gYmwlTZyD+71F/rej4keWCi6dNW3K5cl4bl1lUttc0K
         SCUQHkXVmuml1Vtm3RNU+zKMPIBsovZbiwmGJM/Xxvooc8qWC7KusxzTfOFLwexz28L4
         opXTfnM0YK01pLlp9FM/I69iNkjcDq8TTqtG184NmiMQXZMTW9bQTDfw6W2NyPz6nD7n
         uZPdxHNbOALBgk2rfhsJnh75n62k2QLgah2uX1f+opllV6ILSWKn953J0fSUbhMXw30T
         eWt7jTkayuxlG0qs6+rNdGfNniXzdGOcbGpal0xSOGZ4DxKFZ3/IE8pZipxPgx8i/EkJ
         JDKw==
X-Gm-Message-State: ACrzQf0TrNz15C5hg2/gSzo+CS5Ohptuob5tutYmr7Dr++hR6MMHVO8F
        O1tnfqOxSdEf0iwABPdbxn2wcw==
X-Google-Smtp-Source: AMsMyM6zLml+Nwn1urEZ/4CHjXobp8B2usqw+2L4AFbfvVubO7K0OZfvRm7UQyEmBlfJKCPSnkSW4Q==
X-Received: by 2002:a17:90a:ee44:b0:213:604:53ad with SMTP id bu4-20020a17090aee4400b00213060453admr1108053pjb.155.1666744834160;
        Tue, 25 Oct 2022 17:40:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id o20-20020a170902779400b0017f59ebafe7sm1726085pll.212.2022.10.25.17.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 17:40:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onUT7-006QFr-QE; Wed, 26 Oct 2022 11:40:29 +1100
Date:   Wed, 26 Oct 2022 11:40:29 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: track cow/shared record domains explicitly in
 xfs_refcount_irec
Message-ID: <20221026004029.GK3600936@dread.disaster.area>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
 <166664720593.2690245.18182994137797499438.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664720593.2690245.18182994137797499438.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Just prior to committing the reflink code into upstream, the xfs
> maintainer at the time requested that I find a way to shard the refcount
> records into two domains -- one for records tracking shared extents, and
> a second for tracking CoW staging extents.  The idea here was to
> minimize mount time CoW reclamation by pushing all the CoW records to
> the right edge of the keyspace, and it was accomplished by setting the
> upper bit in rc_startblock.  We don't allow AGs to have more than 2^31
> blocks, so the bit was free.
> 
> Unfortunately, this was a very late addition to the codebase, so most of
> the refcount record processing code still treats rc_startblock as a u32
> and pays no attention to whether or not the upper bit (the cow flag) is
> set.  This is a weakness is theoretically exploitable, since we're not
> fully validating the incoming metadata records.
> 
> Fuzzing demonstrates practical exploits of this weakness.  If the cow
> flag of a node block key record is corrupted, a lookup operation can go
> to the wrong record block and start returning records from the wrong
> cow/shared domain.  This causes the math to go all wrong (since cow
> domain is still implicit in the upper bit of rc_startblock) and we can
> crash the kernel by tricking xfs into jumping into a nonexistent AG and
> tripping over xfs_perag_get(mp, <nonexistent AG>) returning NULL.
> 
> To fix this, start tracking the domain as an explicit part of struct
> xfs_refcount_irec, adjust all refcount functions to check the domain
> of a returned record, and alter the function definitions to accept them
> where necessary.
> 
> Found by fuzzing keys[2].cowflag = add in xfs/464.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c       |  221 ++++++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_refcount.h       |    9 +
>  fs/xfs/libxfs/xfs_refcount_btree.c |   26 ++++
>  fs/xfs/libxfs/xfs_types.h          |   10 ++
>  fs/xfs/scrub/refcount.c            |   22 ++--
>  fs/xfs/xfs_trace.h                 |   48 ++++++--
>  6 files changed, 235 insertions(+), 101 deletions(-)

My first thought was that this is complex enough that it needs to be
split up. Reading the very first hunk:

> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 64b910caafaa..fa75e785652b 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -46,13 +46,16 @@ STATIC int __xfs_refcount_cow_free(struct xfs_btree_cur *rcur,
>  int
>  xfs_refcount_lookup_le(
>  	struct xfs_btree_cur	*cur,
> +	enum xfs_rcext_domain	domain,
>  	xfs_agblock_t		bno,
>  	int			*stat)
>  {
> -	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
> +	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> +			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
>  			XFS_LOOKUP_LE);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
> +	cur->bc_rec.rc.rc_domain = domain;
>  	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);

I found that I had to go looking through the patch to find what the
definitions of xfs_rcext_domain, XFS_RCDOM_COW and rc_domain
actually were, because without knowing what the actual new
structures being introduced actually were this didn't make a whole
lot of sense.

Hence I think I'd like this to be broken up into a patch that
introduces the rc_domain and the helpers that build/split the
domain/startblock information in the irec, and a followup patch that
modifies the implementation to use the new domain interfaces to make
it a bit easier to see where the significant changes in the code
actually are.

I also suspect that trace_xfs_refcount_lookup() should be passed the
domain directly rather than encoding it at every call site of the
tracepoint, or it code encoded in a helper such as
xfs_refcount_domain_to_block()...

For consistency, calling the enums XFS_REFC_DOMAIN_{COW/SHARED}
would be more consistent with the naming used in other refcount
btree constants.

>  }
>  
> @@ -63,13 +66,16 @@ xfs_refcount_lookup_le(
>  int
>  xfs_refcount_lookup_ge(
>  	struct xfs_btree_cur	*cur,
> +	enum xfs_rcext_domain	domain,
>  	xfs_agblock_t		bno,
>  	int			*stat)
>  {
> -	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
> +	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> +			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
>  			XFS_LOOKUP_GE);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
> +	cur->bc_rec.rc.rc_domain = domain;
>  	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
>  }
>  
> @@ -80,13 +86,16 @@ xfs_refcount_lookup_ge(
>  int
>  xfs_refcount_lookup_eq(
>  	struct xfs_btree_cur	*cur,
> +	enum xfs_rcext_domain	domain,
>  	xfs_agblock_t		bno,
>  	int			*stat)
>  {
> -	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno, bno,
> +	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
> +			bno | (domain == XFS_RCDOM_COW ? XFS_REFC_COW_START : 0),
>  			XFS_LOOKUP_LE);
>  	cur->bc_rec.rc.rc_startblock = bno;
>  	cur->bc_rec.rc.rc_blockcount = 0;
> +	cur->bc_rec.rc.rc_domain = domain;
>  	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
>  }
>  
> @@ -96,7 +105,17 @@ xfs_refcount_btrec_to_irec(
>  	const union xfs_btree_rec	*rec,
>  	struct xfs_refcount_irec	*irec)
>  {
> -	irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
> +	__u32				start;
> +
> +	start = be32_to_cpu(rec->refc.rc_startblock);
> +	if (start & XFS_REFC_COW_START) {
> +		start &= ~XFS_REFC_COW_START;
> +		irec->rc_domain = XFS_RCDOM_COW;
> +	} else {
> +		irec->rc_domain = XFS_RCDOM_SHARED;
> +	}

xfs_refcount_block_to_domain()?



> +
> +	irec->rc_startblock = start;
>  	irec->rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
>  	irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
>  }
> @@ -114,7 +133,6 @@ xfs_refcount_get_rec(
>  	struct xfs_perag		*pag = cur->bc_ag.pag;
>  	union xfs_btree_rec		*rec;
>  	int				error;
> -	xfs_agblock_t			realstart;
>  
>  	error = xfs_btree_get_rec(cur, &rec, stat);
>  	if (error || !*stat)
> @@ -124,22 +142,18 @@ xfs_refcount_get_rec(
>  	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
>  		goto out_bad_rec;
>  
> -	/* handle special COW-staging state */
> -	realstart = irec->rc_startblock;
> -	if (realstart & XFS_REFC_COW_START) {
> -		if (irec->rc_refcount != 1)
> -			goto out_bad_rec;
> -		realstart &= ~XFS_REFC_COW_START;
> -	} else if (irec->rc_refcount < 2) {
> +	/* handle special COW-staging domain */
> +	if (irec->rc_domain == XFS_RCDOM_COW && irec->rc_refcount != 1)
> +		goto out_bad_rec;
> +	if (irec->rc_domain == XFS_RCDOM_SHARED && irec->rc_refcount < 2)
>  		goto out_bad_rec;
> -	}
>  
>  	/* check for valid extent range, including overflow */
> -	if (!xfs_verify_agbno(pag, realstart))
> +	if (!xfs_verify_agbno(pag, irec->rc_startblock))
>  		goto out_bad_rec;
> -	if (realstart > realstart + irec->rc_blockcount)
> +	if (irec->rc_startblock > irec->rc_startblock + irec->rc_blockcount)
>  		goto out_bad_rec;
> -	if (!xfs_verify_agbno(pag, realstart + irec->rc_blockcount - 1))
> +	if (!xfs_verify_agbno(pag, irec->rc_startblock + irec->rc_blockcount - 1))
>  		goto out_bad_rec;
>  
>  	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
> @@ -169,12 +183,19 @@ xfs_refcount_update(
>  	struct xfs_refcount_irec	*irec)
>  {
>  	union xfs_btree_rec	rec;
> +	__u32			start;
>  	int			error;
>  
>  	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
> -	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
> +
> +	start = irec->rc_startblock & ~XFS_REFC_COW_START;
> +	if (irec->rc_domain == XFS_RCDOM_COW)
> +		start |= XFS_REFC_COW_START;

Yeah, this definitely looks like we want a
xfs_refcount_domain_to_block() helper...

> +
> +	rec.refc.rc_startblock = cpu_to_be32(start);
>  	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
>  	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
> +
>  	error = xfs_btree_update(cur, &rec);
>  	if (error)
>  		trace_xfs_refcount_update_error(cur->bc_mp,
> @@ -196,9 +217,12 @@ xfs_refcount_insert(
>  	int				error;
>  
>  	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
> +
>  	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
>  	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
>  	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
> +	cur->bc_rec.rc.rc_domain = irec->rc_domain;

Does a struct copy make more sense here now?

[.....]

> @@ -600,8 +636,6 @@ xfs_refcount_merge_right_extent(
>  	return error;
>  }
>  
> -#define XFS_FIND_RCEXT_SHARED	1
> -#define XFS_FIND_RCEXT_COW	2
>  /*
>   * Find the left extent and the one after it (cleft).  This function assumes
>   * that we've already split any extent crossing agbno.
> @@ -611,16 +645,16 @@ xfs_refcount_find_left_extents(
>  	struct xfs_btree_cur		*cur,
>  	struct xfs_refcount_irec	*left,
>  	struct xfs_refcount_irec	*cleft,
> +	enum xfs_rcext_domain		domain,
>  	xfs_agblock_t			agbno,
> -	xfs_extlen_t			aglen,
> -	int				flags)
> +	xfs_extlen_t			aglen)
>  {
>  	struct xfs_refcount_irec	tmp;
>  	int				error;
>  	int				found_rec;
>  
>  	left->rc_startblock = cleft->rc_startblock = NULLAGBLOCK;
> -	error = xfs_refcount_lookup_le(cur, agbno - 1, &found_rec);
> +	error = xfs_refcount_lookup_le(cur, domain, agbno - 1, &found_rec);
>  	if (error)
>  		goto out_error;
>  	if (!found_rec)
> @@ -634,11 +668,13 @@ xfs_refcount_find_left_extents(
>  		goto out_error;
>  	}
>  
> +	if (tmp.rc_domain != domain)
> +		return 0;
>  	if (xfs_refc_next(&tmp) != agbno)
>  		return 0;
> -	if ((flags & XFS_FIND_RCEXT_SHARED) && tmp.rc_refcount < 2)
> +	if (domain == XFS_RCDOM_SHARED && tmp.rc_refcount < 2)
>  		return 0;
> -	if ((flags & XFS_FIND_RCEXT_COW) && tmp.rc_refcount > 1)
> +	if (domain == XFS_RCDOM_COW && tmp.rc_refcount > 1)
>  		return 0;

Hmmm - this pattern is repeated in a couple of places. Perhaps a
helper is in order?

[....]

> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 316c1ec0c3c2..b0818063aa20 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -155,12 +155,31 @@ xfs_refcountbt_init_high_key_from_rec(
>  	key->refc.rc_startblock = cpu_to_be32(x);
>  }
>  
> +static inline __u32
> +xfs_refcountbt_encode_startblock(
> +	struct xfs_btree_cur	*cur)
> +{
> +	__u32			start;
> +
> +	/*
> +	 * low level btree operations need to handle the generic btree range
> +	 * query functions (which set rc_domain == -1U), so we check that the
> +	 * domain is /not/ shared.
> +	 */
> +	start = cur->bc_rec.rc.rc_startblock & ~XFS_REFC_COW_START;
> +	if (cur->bc_rec.rc.rc_domain != XFS_RCDOM_SHARED)
> +		start |= XFS_REFC_COW_START;
> +	return start;
> +}

Oh, there is a xfs_refcount_domain_to_block() helper already - it
just needs to be passed the agbno + domain, not a btree cursor :)

[....]

> diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
> index 8ab55e791ea8..9cf4be9cbb89 100644
> --- a/fs/xfs/scrub/refcount.c
> +++ b/fs/xfs/scrub/refcount.c
> @@ -334,20 +334,19 @@ xchk_refcountbt_rec(
>  	struct xfs_refcount_irec irec;
>  	xfs_agblock_t		*cow_blocks = bs->private;
>  	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
> -	bool			has_cowflag;
>  
>  	xfs_refcount_btrec_to_irec(rec, &irec);
>  
>  	/* Only CoW records can have refcount == 1. */
> -	has_cowflag = (irec.rc_startblock & XFS_REFC_COW_START);
> -	if ((irec.rc_refcount == 1 && !has_cowflag) ||
> -	    (irec.rc_refcount != 1 && has_cowflag))
> +	if (irec.rc_domain == XFS_RCDOM_SHARED && irec.rc_refcount == 1)
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
> -	if (has_cowflag)
> +	if (irec.rc_domain == XFS_RCDOM_COW) {
> +		if (irec.rc_refcount != 1)
> +			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
>  		(*cow_blocks) += irec.rc_blockcount;
> +	}

Hmmm, that looks like another of those shared/cow domain + refcount
checks like I pointed out above...

>  
>  	/* Check the extent. */
> -	irec.rc_startblock &= ~XFS_REFC_COW_START;
>  	if (irec.rc_startblock + irec.rc_blockcount <= irec.rc_startblock ||
>  	    !xfs_verify_agbno(pag, irec.rc_startblock) ||
>  	    !xfs_verify_agbno(pag, irec.rc_startblock + irec.rc_blockcount - 1))
> @@ -420,7 +419,6 @@ xchk_xref_is_cow_staging(
>  	xfs_extlen_t			len)
>  {
>  	struct xfs_refcount_irec	rc;
> -	bool				has_cowflag;
>  	int				has_refcount;
>  	int				error;
>  
> @@ -428,8 +426,8 @@ xchk_xref_is_cow_staging(
>  		return;
>  
>  	/* Find the CoW staging extent. */
> -	error = xfs_refcount_lookup_le(sc->sa.refc_cur,
> -			agbno + XFS_REFC_COW_START, &has_refcount);
> +	error = xfs_refcount_lookup_le(sc->sa.refc_cur, XFS_RCDOM_COW, agbno,
> +			&has_refcount);
>  	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
>  		return;
>  	if (!has_refcount) {
> @@ -446,8 +444,7 @@ xchk_xref_is_cow_staging(
>  	}
>  
>  	/* CoW flag must be set, refcount must be 1. */
> -	has_cowflag = (rc.rc_startblock & XFS_REFC_COW_START);
> -	if (!has_cowflag || rc.rc_refcount != 1)
> +	if (rc.rc_domain != XFS_RCDOM_COW || rc.rc_refcount != 1)
>  		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);

That looks like the same validation logic check as the above hunk
in xchk_refcountbt_rec()...

That's just a first pass - I haven't really concentrated on
correctness that much yet, the patch is really doing too much for me
to get a good picture of everything...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
