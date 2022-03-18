Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE7EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 12:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiCRMXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiCRMXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 08:23:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCEFC2E1A83
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647606117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B7fDBP0nYnp27droMCfTmfOneyguxS4pdba7vC5pRwQ=;
        b=g0uIpXKYAjUKNS1mgbMR0WpFnfyWdi1qH/GI+5ddunMrbZEY1l4TFYXZZ5cZ7mqwiaOd1j
        rsUT94GpDJotXnuQIWc5q89imsZf4wfEcw35gCVAHvMlFMZ1fHrLh5kLxlFVPhppJ1ct6v
        ZhyiasIwOtVimPsKuhWZD2kbFZMbNUA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-_bPDl4KvNHSTiQX_SXS-9Q-1; Fri, 18 Mar 2022 08:21:56 -0400
X-MC-Unique: _bPDl4KvNHSTiQX_SXS-9Q-1
Received: by mail-qt1-f200.google.com with SMTP id x10-20020ac8700a000000b002c3ef8fc44cso5495562qtm.8
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B7fDBP0nYnp27droMCfTmfOneyguxS4pdba7vC5pRwQ=;
        b=nC5i5beXfUfzV2W3LlfhCGliGc8maAGptLQkJOlVo8vkm24B5EGoEdE0CSzwmP1JU9
         B2hZkKRXJkB86L5PgLBrE9fnOhahYMWNNl7rUfSps5xOC8lVL9UbYlfc6CNQrPDIqHWN
         xJ+lfdw98+dcd6/JEsbTon+sBU4xdJZByFjfCKvOklrjkDtRDbpHVTi9WLQrGdaNr6FN
         +wuMoczc5tw49wJxqSI1+OIpQKCphDqBM61SjYvd6KWrqAQoGhAdO2E/WDJSEkzyGa6L
         nIZH8uCcxo+nXLhJyT3J0fXk9MDTqmfFCTALmmZWwP311bG3H6r9rBxdr8ro8yrXA0qu
         nY5w==
X-Gm-Message-State: AOAM531mdp5DO2rkRa20ElNL/6WPfe7zc0TaDHNsQeajqCPLk9IIlgeg
        fMuGhD81zh5Gqmw2t1j+KuYdbQEmVKb5oC1z44U1Xj1HYnk/+/V5Bu5HKgA3y1eKIHOu58cM/c3
        3aU79vi/nYgzwrHarTRzP
X-Received: by 2002:a05:6214:5186:b0:440:ef28:7eca with SMTP id kl6-20020a056214518600b00440ef287ecamr4977152qvb.33.1647606116256;
        Fri, 18 Mar 2022 05:21:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZyBMXzgaXefBJx1W24stEQR7D/rbkeXAdI6wU5lg+czBdPnWp1qYFl6LczV+7k8iDRIv9ag==
X-Received: by 2002:a05:6214:5186:b0:440:ef28:7eca with SMTP id kl6-20020a056214518600b00440ef287ecamr4977143qvb.33.1647606115981;
        Fri, 18 Mar 2022 05:21:55 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id o21-20020ac85a55000000b002e16389b501sm5403669qta.96.2022.03.18.05.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:21:55 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:21:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 6/6] xfs: rename "alloc_set_aside" to be more descriptive
Message-ID: <YjR5YVaiu8yWmgOJ@bfoster>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755208902.4194202.454742878504753117.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164755208902.4194202.454742878504753117.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 02:21:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We've established in this patchset that the "alloc_set_aside" pool is
> actually used to ensure that a bmbt split always succeeds so that the
> filesystem won't run out of space mid-transaction and crash.  Rename the
> variable and the function to be a little more suggestive of the purpose
> of this quantity.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    4 ++--
>  fs/xfs/libxfs/xfs_alloc.h |    2 +-
>  fs/xfs/xfs_fsops.c        |    2 +-
>  fs/xfs/xfs_log_recover.c  |    2 +-
>  fs/xfs/xfs_mount.c        |    4 ++--
>  fs/xfs/xfs_mount.h        |    7 ++++---
>  6 files changed, 11 insertions(+), 10 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 9336176dc706..eac9534338fd 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -656,7 +656,7 @@ xfs_mountfs(
>  	 * Compute the amount of space to set aside to handle btree splits now
>  	 * that we have calculated the btree maxlevels.
>  	 */
> -	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> +	mp->m_bmbt_split_setaside = xfs_bmbt_split_setaside(mp);
>  	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
>  
>  	/*
> @@ -1153,7 +1153,7 @@ xfs_mod_fdblocks(
>  	 * problems (i.e. transaction abort, pagecache discards, etc.) than
>  	 * slightly premature -ENOSPC.
>  	 */
> -	set_aside = mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> +	set_aside = mp->m_bmbt_split_setaside + atomic64_read(&mp->m_allocbt_blks);

IMO the whole end result would be more simple if the helper(s) were
written to fully isolate usage of >m_bmbt_split_setaside to within those
helpers, as opposed to continuing to leave around the need to open code
the set aside calculation anywhere. That said, this is more commentary
on the previous couple or so patches than this one and this is an
improvement overall:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
>  	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
>  				     XFS_FDBLOCKS_BATCH) >= 0) {
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 74e9b8558162..6c4cbd4a0c32 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -134,7 +134,8 @@ typedef struct xfs_mount {
>  	uint			m_refc_maxlevels; /* max refcount btree level */
>  	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
>  	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
> -	uint			m_alloc_set_aside; /* space we can't use */
> +	/* space reserved to ensure bmbt splits always succeed */
> +	unsigned int		m_bmbt_split_setaside;
>  	uint			m_ag_max_usable; /* max space per AG */
>  	int			m_dalign;	/* stripe unit */
>  	int			m_swidth;	/* stripe width */
> @@ -503,7 +504,7 @@ xfs_fdblocks_available(
>  {
>  	int64_t			free = percpu_counter_sum(&mp->m_fdblocks);
>  
> -	free -= mp->m_alloc_set_aside;
> +	free -= mp->m_bmbt_split_setaside;
>  	free -= atomic64_read(&mp->m_allocbt_blks);
>  	return free;
>  }
> @@ -516,7 +517,7 @@ xfs_fdblocks_available_fast(
>  	int64_t			free;
>  
>  	free = percpu_counter_read_positive(&mp->m_fdblocks);
> -	free -= mp->m_alloc_set_aside;
> +	free -= mp->m_bmbt_split_setaside;
>  	free -= atomic64_read(&mp->m_allocbt_blks);
>  	return free;
>  }
> 

