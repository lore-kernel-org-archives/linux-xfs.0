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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62593C4338F
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 11:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 406C160560
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Aug 2021 11:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbhHMLFU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Aug 2021 07:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHMLFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Aug 2021 07:05:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3019EC061756
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 04:04:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k2so11388539plk.13
        for <linux-xfs@vger.kernel.org>; Fri, 13 Aug 2021 04:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:date:message-id
         :in-reply-to:mime-version;
        bh=MJTE7fBHq1v1+/PaSZz2VDH/jw6GnRCt3Dgf9+tbLSA=;
        b=R9HgN6xfeVrtNBxOBAO32cVf/Jl75/DaK5SM044u5uiz1IyIDPqSn9M9fQyuJHbCD6
         p3HnGjjqpZ9uwefsw6wbunHOd5GpzSPhfXJQpUZlzarLtBWiqknDVtgqUSMenT7QpvxO
         YkhL2ACcBP3l9mL+Cl2V6KXtITfHiIL+O2SQoeHWlJNAlJhsgkbBYHSlhyIVL5ObdCjH
         OSmNhQUnwhzbi8fptSAD5NjTRSNzYOjcdf5+A8XCw5Wzlco7pZxDMvfHp80ff3j64diL
         HFn10tIqJKJUDOz3Uo/x5ue2Z+r2d7mqxUmGAwmwrlUyB+zQicoNOul9CuQOIwWWcScp
         LlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :message-id:in-reply-to:mime-version;
        bh=MJTE7fBHq1v1+/PaSZz2VDH/jw6GnRCt3Dgf9+tbLSA=;
        b=B3EjtyQiQXQss5mzv9ABKdycBVVlvdXWgWhI33E0VZvsElzaJjUqc1p8Aq/U25MIJn
         Yy4RV1o0J7iI+tZOItnYjOszZ1LzyFoAHAXRJCasK8xPAYTFkoC+/fQWU7A9igBTmLHK
         pcAkFSVHo/LTyemS88lEetarNR4hPippfzPlSQ0AuB1TdngHKxlkQlzC9YJlhsJJ0g/t
         9iUnN6PwQGwSyv1y0regMrwXqommepFbbF1Wa80OdxM7JhIHKLp5b5SDiN7tZhmuSy66
         Y0/yMRYg8Wp2B13dgaHfV4FSbQlPJ6/6o5sMk9TtGKZCDd8aSSYYzoOy/Pj+afnksc/y
         Ae3A==
X-Gm-Message-State: AOAM532Kb5c0ynywdjC66g+D2ZtzjHrFR+YPZlRCvkjlp07iDB9nORaD
        pM8VU711JEX0llu7EkZ18IHLPudbC3kJAA==
X-Google-Smtp-Source: ABdhPJwC1QlxNTkjo5TlWj/nZHo9Ynj4cSFU5zMVzR4+YPYz40gw8VGRAc3Mj5dQSahUIfkcXDIqaQ==
X-Received: by 2002:a05:6a00:a0e:b029:3c3:538:b4b8 with SMTP id p14-20020a056a000a0eb02903c30538b4b8mr1934395pfh.25.1628852692632;
        Fri, 13 Aug 2021 04:04:52 -0700 (PDT)
Received: from garuda ([122.167.186.107])
        by smtp.gmail.com with ESMTPSA id x189sm2198192pfx.99.2021.08.13.04.04.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Aug 2021 04:04:52 -0700 (PDT)
References: <162872991654.1220643.136984377220187940.stgit@magnolia> <162872992772.1220643.10308054638747493338.stgit@magnolia>
User-agent: mu4e 1.6.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix off-by-one error when the last rt extent is in use
Date:   Fri, 13 Aug 2021 16:20:34 +0530
Message-ID: <87fsvdlijp.fsf@garuda>
In-reply-to: <162872992772.1220643.10308054638747493338.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Aug 2021 at 17:58, "Darrick J. Wong" <djwong@kernel.org> wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> The fsmap implementation for realtime devices uses the gap between
> info->next_daddr and a free rtextent reported by xfs_rtalloc_query_range
> to feed userspace fsmap records with an "unknown" owner.  We use this
> trick to report to userspace when the last rtextent in the filesystem is
> in use by synthesizing a null rmap record starting at the next block
> after the query range.
>
> Unfortunately, there's a minor accounting bug in the way that we
> construct the null rmap record.  Originally, ahigh.ar_startext contains
> the last rtextent for which the user wants records.  It's entirely
> possible that number is beyond the end of the rt volume, so the location
> synthesized rmap record /must/ be constrained to the minimum of the high
> key and the number of extents in the rt volume.
>

When the number of blocks on the realtime device is not an integral multiple
of xfs_sb->sb_rextsize, ahigh.ar_startext can contain a value which is one
more than the highest valid rtextent. Hence, without this patch, the last
record reported to the userpace might contain an invalid upper bound. Assuming
that my understanding is indeed correct,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsmap.c |   22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 7d0b09c1366e..a0e8ab58124b 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -523,27 +523,39 @@ xfs_getfsmap_rtdev_rtbitmap_query(
>  {
>  	struct xfs_rtalloc_rec		alow = { 0 };
>  	struct xfs_rtalloc_rec		ahigh = { 0 };
> +	struct xfs_mount		*mp = tp->t_mountp;
>  	int				error;
>  
> -	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> +	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED);
>  
> +	/*
> +	 * Set up query parameters to return free extents covering the range we
> +	 * want.
> +	 */
>  	alow.ar_startext = info->low.rm_startblock;
> +	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
> +
>  	ahigh.ar_startext = info->high.rm_startblock;
> -	do_div(alow.ar_startext, tp->t_mountp->m_sb.sb_rextsize);
> -	if (do_div(ahigh.ar_startext, tp->t_mountp->m_sb.sb_rextsize))
> +	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
>  		ahigh.ar_startext++;
> +
>  	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
>  			xfs_getfsmap_rtdev_rtbitmap_helper, info);
>  	if (error)
>  		goto err;
>  
> -	/* Report any gaps at the end of the rtbitmap */
> +	/*
> +	 * Report any gaps at the end of the rtbitmap by simulating a null
> +	 * rmap starting at the block after the end of the query range.
> +	 */
>  	info->last = true;
> +	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
> +
>  	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
>  	if (error)
>  		goto err;
>  err:
> -	xfs_iunlock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> +	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
>  	return error;
>  }
>  


-- 
chandan
