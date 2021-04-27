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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39FCC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E3260FDC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhD0KYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbhD0KX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 06:23:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C254BC06138B
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 03:22:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id lr7so12488589pjb.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 03:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ApAXA0/rQBvxEdLQEwwqd2xhK7ngunfxwkMrc8Mn7KI=;
        b=Vi0YLAXxYcDIxa0xtpCRhFhjYVesalGjeOnUYf5AnW+Xc5dNQrwIbR+TXo57JUJcVi
         8aDl/QQ7BPk7bNk4Eum7r3Jb6wHu+QoVxUQUQE0yQtJizLxBqs876ePPfUhMLflEz+zD
         vmhpUkZBO0w/ot/mU5MVqcQ6mGTQ4iNg25DNL47dpqk1hyIuoIXDJ3kCTsT8LU4IcdGL
         3msUgoUvpafREPxpNcOgo6uTsjiA+TD036u54kxYMtDAB7k/E8D2nCAS+f088lDy6KaD
         3WlRQIwVcTMqTqIY3nlN303QRPuXd531nscZFKeYE89craSSmdFlR6olx5wNo6MGAAdV
         eWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ApAXA0/rQBvxEdLQEwwqd2xhK7ngunfxwkMrc8Mn7KI=;
        b=J4wYvaAWZLaKIM3HLTDuv6dSYUG6t4mV0khi+JF8L0ZNd0rfrI5kgdIUdRLIg0pVFA
         W71NIR5TSPDNcp7HraGvBaWbKScpQJwAibav28CULxREULwcgH/c7Spd5bJW8VJ9pKw6
         y/gGfK1KHhsagXD5djUBx1iQpNA6nLw0DkM87CKQBKKZBy8EHrhVqOMVUUOQ5ExmsMo2
         eBT9Kzodmg6ui0AgdSdAe0f8nd7Jm5XHVOxNDPIS+7H96eug9eavrMVZIkjztlX1oZEH
         YY7vjHbcZgkBVwPM/pIVltz12G6BFGBkokcrdvuOJS91ic1Qv6YVdRX29fR0rOhnM0sM
         E8ug==
X-Gm-Message-State: AOAM531Ns0WNW9Q3IxaEOlYMRP/5Gv3FfVLUUAjxzzR7yZbxLShj7mI+
        7zrjzpLRZFFQWQbcdiPEk7TMtovXm5A=
X-Google-Smtp-Source: ABdhPJwuZNN+RPN8ED0ePLo9lpwZGiApdw74pMrJpY7ERefFo9Fhk0l1bncbB6Tod6hmDd/lV7a7Lw==
X-Received: by 2002:a17:90b:1bd0:: with SMTP id oa16mr26283614pjb.49.1619518949176;
        Tue, 27 Apr 2021 03:22:29 -0700 (PDT)
Received: from garuda ([122.171.173.111])
        by smtp.gmail.com with ESMTPSA id b21sm2127726pfl.82.2021.04.27.03.22.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Apr 2021 03:22:28 -0700 (PDT)
References: <20210423131050.141140-1-bfoster@redhat.com> <20210423131050.141140-2-bfoster@redhat.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] xfs: unconditionally read all AGFs on mounts with perag reservation
In-reply-to: <20210423131050.141140-2-bfoster@redhat.com>
Date:   Tue, 27 Apr 2021 15:52:26 +0530
Message-ID: <874kfsm3h9.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Apr 2021 at 18:40, Brian Foster wrote:
> perag reservation is enabled at mount time on a per AG basis. The
> upcoming change to set aside allocbt blocks from block reservation
> requires a populated allocbt counter as soon as possible after mount
> to be fully effective against large perag reservations. Therefore as
> a preparation step, initialize the pagf on all mounts where at least
> one reservation is active. Note that this already occurs to some
> degree on most default format filesystems as reservation requirement
> calculations already depend on the AGF or AGI, depending on the
> reservation type.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 6c5f8d10589c..e32a1833d523 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -253,7 +253,8 @@ xfs_ag_resv_init(
>  	xfs_agnumber_t			agno = pag->pag_agno;
>  	xfs_extlen_t			ask;
>  	xfs_extlen_t			used;
> -	int				error = 0;
> +	int				error = 0, error2;
> +	bool				has_resv = false;
>  
>  	/* Create the metadata reservation. */
>  	if (pag->pag_meta_resv.ar_asked == 0) {
> @@ -291,6 +292,8 @@ xfs_ag_resv_init(
>  			if (error)
>  				goto out;
>  		}
> +		if (ask)
> +			has_resv = true;
>  	}
>  
>  	/* Create the RMAPBT metadata reservation */
> @@ -304,19 +307,28 @@ xfs_ag_resv_init(
>  		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
>  		if (error)
>  			goto out;
> +		if (ask)
> +			has_resv = true;
>  	}
>  
> -#ifdef DEBUG
> -	/* need to read in the AGF for the ASSERT below to work */
> -	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
> -	if (error)
> -		return error;
> -
> -	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> -	       pag->pagf_freeblks + pag->pagf_flcount);
> -#endif
>  out:
> +	/*
> +	 * Initialize the pagf if we have at least one active reservation on the
> +	 * AG. This may have occurred already via reservation calculation, but
> +	 * fall back to an explicit init to ensure the in-core allocbt usage
> +	 * counters are initialized as soon as possible. This is important
> +	 * because filesystems with large perag reservations are susceptible to
> +	 * free space reservation problems that the allocbt counter is used to
> +	 * address.
> +	 */
> +	if (has_resv) {
> +		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
> +		if (error2)
> +			return error2;
> +		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> +		       pag->pagf_freeblks + pag->pagf_flcount);
> +	}
>  	return error;
>  }

-- 
chandan
