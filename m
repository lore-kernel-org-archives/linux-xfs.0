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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E40BC43611
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4593F60FF3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhD0K3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbhD0K3G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 06:29:06 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4F1C061342
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 03:28:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lp8so587573pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 03:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=B7pPIxTCfzMykaMp5m/pI6lPYLhOI4PZZ+SqIlcI/Qc=;
        b=qPglCNhkhWBMzwN0hSJILLsyjdd79sGh/v6pmMugKW8VRO9e9m6ZtQmuK1PoHhUzxy
         qddVBJ7UM/qIVrQ3xKADASvJuPxwmHn/q/lIQJytqJxXMtVkDG/rWvBoHEoKuKvxV4th
         bewt275sU3p9HyA0V+8EryUOGkaHjV8c/bZqWgwZ3xDi6FkmrAtKetsfgmKRzNK4z3RQ
         HxPgb2KEUV2r9DpnHYBOuZzroPg9Hn6iQbIouWz5/rKsB2Jytv2mohbaxZJo0Sbakoi1
         bfHLtDY+o/qo5RktecEHJPo0z0k94w6618+aCZpTJolTHxVeHkfFC7UlcxAGRU5ezwKz
         os2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=B7pPIxTCfzMykaMp5m/pI6lPYLhOI4PZZ+SqIlcI/Qc=;
        b=DIZNj8lrYdcBk+9cCm05hFIJZL9KqvTxZ1DJScq+IW9b4DN6koJe59g/fGTbt7SVQw
         V4bOwqUl9zAKE6h1y0oSCTiN8u1c4gWowONYjKjQriC9KPOU1Q5tK9NwWlFtYCfgrCUa
         5OsasfdLgF1cz8WB7MyFsYGlGGH1CtEi1KGqpGnlmIF5jS5nmfVgAZHPSln+4C0VP2lg
         +pmn2vX1ZJCqrxHjxh7BS1uZsMDaaI3jG60TOfwXekw2YZGhGMEjmmdANGzJ4R/lgo71
         cZL/npXXgNojguBIXiMOZ9HgWuHX1qK4gPzQP7U1xE9GoO8B8mUsbZGA278xnN/2S6rF
         5HFg==
X-Gm-Message-State: AOAM5311pbNqkjYl87v5LRXFvi3r41xWyoKvv+XhcWpyrjQFIXJDzBke
        t/78/hbZJn7rbyxF9TJ43u6me+V91EA=
X-Google-Smtp-Source: ABdhPJwYd8dtA2FQjxJGR1dXmfrxtcxVVsZ9m0BFTxWBBaMFq7+6yaxQ1h2MM5bD7Y49u4B9i60ITg==
X-Received: by 2002:a17:90b:3796:: with SMTP id mz22mr4005645pjb.80.1619519299401;
        Tue, 27 Apr 2021 03:28:19 -0700 (PDT)
Received: from garuda ([122.171.173.111])
        by smtp.gmail.com with ESMTPSA id x3sm2287133pfj.95.2021.04.27.03.28.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Apr 2021 03:28:18 -0700 (PDT)
References: <20210423131050.141140-1-bfoster@redhat.com> <20210423131050.141140-3-bfoster@redhat.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/3] xfs: introduce in-core global counter of allocbt blocks
In-reply-to: <20210423131050.141140-3-bfoster@redhat.com>
Date:   Tue, 27 Apr 2021 15:58:16 +0530
Message-ID: <8735vcm37j.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 23 Apr 2021 at 18:40, Brian Foster wrote:
> Introduce an in-core counter to track the sum of all allocbt blocks
> used by the filesystem. This value is currently tracked per-ag via
> the ->agf_btreeblks field in the AGF, which also happens to include
> rmapbt blocks. A global, in-core count of allocbt blocks is required
> to identify the subset of global ->m_fdblocks that consists of
> unavailable blocks currently used for allocation btrees. To support
> this calculation at block reservation time, construct a similar
> global counter for allocbt blocks, populate it on first read of each
> AGF and update it as allocbt blocks are used and released.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c       | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.c |  2 ++
>  fs/xfs/xfs_mount.h              |  6 ++++++
>  3 files changed, 20 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index aaa19101bb2a..144e2d68245c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3036,6 +3036,7 @@ xfs_alloc_read_agf(
>  	struct xfs_agf		*agf;		/* ag freelist header */
>  	struct xfs_perag	*pag;		/* per allocation group data */
>  	int			error;
> +	uint32_t		allocbt_blks;
>
>  	trace_xfs_alloc_read_agf(mp, agno);
>
> @@ -3066,6 +3067,17 @@ xfs_alloc_read_agf(
>  		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
>  		pag->pagf_init = 1;
>  		pag->pagf_agflreset = xfs_agfl_needs_reset(mp, agf);
> +
> +		/*
> +		 * Update the global in-core allocbt block counter. Filter
> +		 * rmapbt blocks from the on-disk counter because those are
> +		 * managed by perag reservation.
> +		 */
> +		if (pag->pagf_btreeblks > be32_to_cpu(agf->agf_rmap_blocks)) {

pag->pagf_btreeblks gets incremented everytime a block is allocated to refill
AGFL (via xfs_alloc_get_freelist()). Apart from the allobt trees, blocks for
Rmap btree also get allocated from AGFL. Hence pag->pagf_btreeblks must be
larger than agf->agf_rmap_blocks.

Can you please describe the scenario in which pag->pagf_btreeblks has a value
that is <= agf->agf_rmap_blocks?

--
chandan
