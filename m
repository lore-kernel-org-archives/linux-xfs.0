Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA15C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 10:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E94B320722
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 10:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dUvxZlNF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgGAKTQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 06:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729834AbgGAKTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 06:19:10 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005AFC061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 03:19:09 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k71so7283144pje.0
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 03:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bV/p3+fYB4gfSGnZD1iDd3JeAq0/roj+X/IdIqKVNaM=;
        b=dUvxZlNFxdCTXpF2ejgi/8/t7CWa3UOVaZd8lmJLAsYxvSnSA8fhhqEa+ig3E+aoEb
         jDVnqvxnZdzy6JM1Cj4IRy7e0R1xpkH2Twh4jQUa9mPtQRw5RBcSq2WtmTnT4vnRKuxC
         GbZzb+qAkzaE6c/7GCSn2G0nXYpgqCmKMuiuwi0W6R98CoaAldxD1p68Y04PengZLTNQ
         9Gr5lf6m44yU+CGf9Po5DPdFOGD1nZNLWyGXYTCWvs/4FMt13Dlri5xjkFQ80hbHEC7y
         38QK4L9j8GZy6GOj69umku0HhkA7u4JJi3S4lgAg6w0Ys54scNMlzcFLMnjgOmYv30I9
         miig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bV/p3+fYB4gfSGnZD1iDd3JeAq0/roj+X/IdIqKVNaM=;
        b=VbeNPxBxPLBK4IkP6AgMpoO6Onz210FftCyfgXOhL8DDD/X3to4xU6MMwhZAZcEK0q
         xhk4N65jx+SaZhmrn9kw4cke06T5UEETPf2KXucedvLaKqlReu7ho6Fm+mYThKmcd0bm
         rDopsw/x6GjKOj0x8qQCD61UqSYjEjIAPs/nm+iNF7XJizxxwJmKutSng55QZqoDHfGY
         EPFiA8tKvovRVS6+fIshots+MPZXpiDZ7GK22kDTE16pUfDNhajPqfgZ+BEG4XqFnETQ
         SqMK50ibbjv4bSwhJ0H16KxbbgTYKbGIAP5gWQnL8SOqwKJfHoYrs3DYgQFxc4kHVYZj
         JmJg==
X-Gm-Message-State: AOAM530k6gFix+eFsI3gddFSWtoDG4GjePUYcUziiJV73fQxslnZWtl8
        JK4epdbuG73e9ve35MeoZI4=
X-Google-Smtp-Source: ABdhPJxBTYb+GoBjgGMI3hNDYj4YSN9MZLwOOKd6bC1EUk5Mv9woTK3OFD4mu4l5Vakk4LSN2CyzFQ==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr22128490pll.237.1593598749499;
        Wed, 01 Jul 2020 03:19:09 -0700 (PDT)
Received: from garuda.localnet ([122.171.188.144])
        by smtp.gmail.com with ESMTPSA id d5sm5255383pfa.71.2020.07.01.03.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 03:19:09 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/18] xfs: refactor quota exceeded test
Date:   Wed, 01 Jul 2020 15:49:06 +0530
Message-ID: <24519076.D1bH60dLAQ@garuda>
In-Reply-To: <159353180004.2864738.3571543752803090361.stgit@magnolia>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia> <159353180004.2864738.3571543752803090361.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 30 June 2020 9:13:20 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the open-coded test for whether or not we're over quota.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
>  1 file changed, 30 insertions(+), 65 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 35a113d1b42b..ef34c82c28a0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
>  		xfs_dquot_set_prealloc_limits(dq);
>  }
>  
> +/*
> + * Determine if this quota counter is over either limit and set the quota
> + * timers as appropriate.
> + */
> +static inline void
> +xfs_qm_adjust_res_timer(
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres)
> +{
> +	bool			over;
> +
> +#ifdef DEBUG
> +	if (res->hardlimit)
> +		ASSERT(res->softlimit <= res->hardlimit);
> +#endif
> +
> +	over = (res->softlimit && res->count > res->softlimit) ||
> +	       (res->hardlimit && res->count > res->hardlimit);
> +
> +	if (over && res->timer == 0)
> +		res->timer = ktime_get_real_seconds() + dres->timelimit;
> +	else if (!over && res->timer != 0)
> +		res->timer = 0;
> +	else if (!over && res->timer == 0)
> +		res->warnings = 0;
> +}
> +
>  /*
>   * Check the limits and timers of a dquot and start or reset timers
>   * if necessary.
> @@ -121,71 +148,9 @@ xfs_qm_adjust_dqtimers(
>  	ASSERT(dq->q_id);
>  	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
>  
> -#ifdef DEBUG
> -	if (dq->q_blk.hardlimit)
> -		ASSERT(dq->q_blk.softlimit <= dq->q_blk.hardlimit);
> -	if (dq->q_ino.hardlimit)
> -		ASSERT(dq->q_ino.softlimit <= dq->q_ino.hardlimit);
> -	if (dq->q_rtb.hardlimit)
> -		ASSERT(dq->q_rtb.softlimit <= dq->q_rtb.hardlimit);
> -#endif
> -
> -	if (!dq->q_blk.timer) {
> -		if ((dq->q_blk.softlimit &&
> -		     (dq->q_blk.count > dq->q_blk.softlimit)) ||
> -		    (dq->q_blk.hardlimit &&
> -		     (dq->q_blk.count > dq->q_blk.hardlimit))) {
> -			dq->q_blk.timer = ktime_get_real_seconds() +
> -					defq->dfq_blk.timelimit;
> -		} else {
> -			dq->q_blk.warnings = 0;
> -		}
> -	} else {
> -		if ((!dq->q_blk.softlimit ||
> -		     (dq->q_blk.count <= dq->q_blk.softlimit)) &&
> -		    (!dq->q_blk.hardlimit ||
> -		    (dq->q_blk.count <= dq->q_blk.hardlimit))) {
> -			dq->q_blk.timer = 0;
> -		}
> -	}
> -
> -	if (!dq->q_ino.timer) {
> -		if ((dq->q_ino.softlimit &&
> -		     (dq->q_ino.count > dq->q_ino.softlimit)) ||
> -		    (dq->q_ino.hardlimit &&
> -		     (dq->q_ino.count > dq->q_ino.hardlimit))) {
> -			dq->q_ino.timer = ktime_get_real_seconds() +
> -					defq->dfq_ino.timelimit;
> -		} else {
> -			dq->q_ino.warnings = 0;
> -		}
> -	} else {
> -		if ((!dq->q_ino.softlimit ||
> -		     (dq->q_ino.count <= dq->q_ino.softlimit))  &&
> -		    (!dq->q_ino.hardlimit ||
> -		     (dq->q_ino.count <= dq->q_ino.hardlimit))) {
> -			dq->q_ino.timer = 0;
> -		}
> -	}
> -
> -	if (!dq->q_rtb.timer) {
> -		if ((dq->q_rtb.softlimit &&
> -		     (dq->q_rtb.count > dq->q_rtb.softlimit)) ||
> -		    (dq->q_rtb.hardlimit &&
> -		     (dq->q_rtb.count > dq->q_rtb.hardlimit))) {
> -			dq->q_rtb.timer = ktime_get_real_seconds() +
> -					defq->dfq_rtb.timelimit;
> -		} else {
> -			dq->q_rtb.warnings = 0;
> -		}
> -	} else {
> -		if ((!dq->q_rtb.softlimit ||
> -		     (dq->q_rtb.count <= dq->q_rtb.softlimit)) &&
> -		    (!dq->q_rtb.hardlimit ||
> -		     (dq->q_rtb.count <= dq->q_rtb.hardlimit))) {
> -			dq->q_rtb.timer = 0;
> -		}
> -	}
> +	xfs_qm_adjust_res_timer(&dq->q_blk, &defq->dfq_blk);
> +	xfs_qm_adjust_res_timer(&dq->q_ino, &defq->dfq_ino);
> +	xfs_qm_adjust_res_timer(&dq->q_rtb, &defq->dfq_rtb);
>  }
>  
>  /*
> 
> 


-- 
chandan



