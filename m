Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E63C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 11:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B160660F46
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 11:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbhHMLEf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 07:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHMLEe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 07:04:34 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351D9C061756
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 04:04:08 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so1777247pjb.3
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 04:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=Th0pfNyEYEvjkh3TaqLuwENf6J7va2icvjkEZ3fAa98=;
        b=f5h3HMPInTrYbISHrIdlw2vZGPB5bR0yaIcmt3Bf42KlZ1l1iKHQwzYKnM26spsjUJ
         Ik5jxXvtaA8ALXHczIqJN/Y6F7kdNMZ9VEpKsiQk5scny+NkXOv0C9e1ShAkEwaBZ7n9
         cEC5vvE6zCX8Ou/unltf4JDWsSq1yiRRFGMsvls0Nck/fE1D1MzFQNF/iF3vbajH+7+A
         Vlh91VS8mWepNnvGXP4AYb9vQ8BVfpx02JQ8LFANfj628a0+RPqoUdk+gt/sGLC+OMT9
         J2m0TSgN7Lbneb6vF04C/LSb3PBq+uGI65GBBtlKEge1gHLX+yGto2R/kZf/mZ+ALWTO
         5H8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=Th0pfNyEYEvjkh3TaqLuwENf6J7va2icvjkEZ3fAa98=;
        b=Zw42q1i6cWYUYRVqyWq7xqQbIAaAossosKszMGRIdjtYwk/RqesiMUhjKh6+eXuf2x
         UDtTGpfa03jp0M4dDRbah19ftet22J8Fvo0LPnK9p56Y3Hj6XpJBqk84I6vzItCQFTI/
         Vrcf6Diy9Y5LnkAv0rm2qpAxadDEwV9d35M58tQ09gCXKPyAyjjxsBO0aNXc5dUdeEQK
         /JwCeYP8z42lqTr54AP6G8ClZQEbvogPYFlVGhDsPSP5WV4dzkVmWYlosNbDlTcJvEht
         zFRuhEKNyrTaYg7y8pqiIwOXVMEQXVb6NDrWuBVclPcNClc17YhJl9QvmDJ/i0ILpPFA
         /S9A==
X-Gm-Message-State: AOAM533iW49669fUL4C9EjKHBfG1LaU3LhdajVQ0E6iwPACpkYgiSvpX
        h8km1SbeblkFQBXgDjeASltZtgnMiZivrQ==
X-Google-Smtp-Source: ABdhPJwTXB09Hr1brjv2g0kh8idBeXu9kWWrGmSXCC5O7CrRgYW5b9p9Z+quFaZBlfghllrripV1WQ==
X-Received: by 2002:a17:90a:cb86:: with SMTP id a6mr2099957pju.137.1628852647542;
        Fri, 13 Aug 2021 04:04:07 -0700 (PDT)
Received: from garuda ([122.167.186.107])
        by smtp.gmail.com with ESMTPSA id q68sm2242429pgq.5.2021.08.13.04.04.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Aug 2021 04:04:06 -0700 (PDT)
References: <162872991654.1220643.136984377220187940.stgit@magnolia> <162872992222.1220643.2988115020171417694.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: make xfs_rtalloc_query_range input parameters const
Date:   Fri, 13 Aug 2021 15:26:23 +0530
Message-ID: <87h7ftllbb.fsf@garuda>
In-reply-to: <162872992222.1220643.2988115020171417694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Aug 2021 at 17:58, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> In commit 8ad560d2565e, we changed xfs_rtalloc_query_range to constrain
> the range of bits in the realtime bitmap file that would actually be
> searched.  In commit a3a374bf1889, we changed the range again
> (incorrectly), leading to the fix in commit d88850bd5516, which finally
> corrected the range check code.  Unfortunately, the author never noticed
> that the function modifies its input parameters, which is a totaly no-no
> since none of the other range query functions change their input
> parameters.
>
> So, fix this function yet again to stash the upper end of the query
> range (i.e. the high key) in a local variable and hope this is the last
> time I have to fix my own function.  While we're at it, mark the key
> inputs const so nobody makes this mistake again. :(
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: 8ad560d2565e ("xfs: strengthen rtalloc query range checks")
> Not-fixed-by: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
> Not-fixed-by: d88850bd5516 ("xfs: fix high key handling in the rt allocator's query_range function")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c |   14 +++++++-------
>  fs/xfs/xfs_rtalloc.h         |    7 +++----
>  2 files changed, 10 insertions(+), 11 deletions(-)
>
>
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 483375c6a735..5740ba664867 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1009,8 +1009,8 @@ xfs_rtfree_extent(
>  int
>  xfs_rtalloc_query_range(
>  	struct xfs_trans		*tp,
> -	struct xfs_rtalloc_rec		*low_rec,
> -	struct xfs_rtalloc_rec		*high_rec,
> +	const struct xfs_rtalloc_rec	*low_rec,
> +	const struct xfs_rtalloc_rec	*high_rec,
>  	xfs_rtalloc_query_range_fn	fn,
>  	void				*priv)
>  {
> @@ -1018,6 +1018,7 @@ xfs_rtalloc_query_range(
>  	struct xfs_mount		*mp = tp->t_mountp;
>  	xfs_rtblock_t			rtstart;
>  	xfs_rtblock_t			rtend;
> +	xfs_rtblock_t			high_key;
>  	int				is_free;
>  	int				error = 0;
>  
> @@ -1026,12 +1027,12 @@ xfs_rtalloc_query_range(
>  	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
>  	    low_rec->ar_startext == high_rec->ar_startext)
>  		return 0;
> -	high_rec->ar_startext = min(high_rec->ar_startext,
> -			mp->m_sb.sb_rextents - 1);
> +
> +	high_key = min(high_rec->ar_startext, mp->m_sb.sb_rextents - 1);
>  
>  	/* Iterate the bitmap, looking for discrepancies. */
>  	rtstart = low_rec->ar_startext;
> -	while (rtstart <= high_rec->ar_startext) {
> +	while (rtstart <= high_key) {
>  		/* Is the first block free? */
>  		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
>  				&is_free);
> @@ -1039,8 +1040,7 @@ xfs_rtalloc_query_range(
>  			break;
>  
>  		/* How long does the extent go for? */
> -		error = xfs_rtfind_forw(mp, tp, rtstart,
> -				high_rec->ar_startext, &rtend);
> +		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
>  		if (error)
>  			break;
>  
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index ed885620589c..51097cb24311 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -124,10 +124,9 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		     xfs_rtblock_t start, xfs_extlen_t len,
>  		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
>  int xfs_rtalloc_query_range(struct xfs_trans *tp,
> -			    struct xfs_rtalloc_rec *low_rec,
> -			    struct xfs_rtalloc_rec *high_rec,
> -			    xfs_rtalloc_query_range_fn fn,
> -			    void *priv);
> +		const struct xfs_rtalloc_rec *low_rec,
> +		const struct xfs_rtalloc_rec *high_rec,
> +		xfs_rtalloc_query_range_fn fn, void *priv);
>  int xfs_rtalloc_query_all(struct xfs_trans *tp,
>  			  xfs_rtalloc_query_range_fn fn,
>  			  void *priv);


-- 
chandan
