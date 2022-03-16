Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016D4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 11:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345749AbiCPL3n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 07:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355341AbiCPL3m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 07:29:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8CDCE39B84
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 04:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647430103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DBQCoz8qCairO5B/8lBxRWesfMetskAHdL6PPOwTX6U=;
        b=K525IOeznvV6FssOaGNVSX84leA5IuuBleQd0Nz+oxemoNG0wDJ4YQ68n9GBMcBSyqfrDQ
        NtJl0kcTyMfaEcjAvQo6ZWsvvQtVMnBq0DJ6GR8bW85gygrEwG7VniH6XccCz3pT28AHjc
        yawYFfrC7gaGalTKyJdk6v+W+1Jx4UQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450--2yQ4tOzOQyI_t2B5wBwLw-1; Wed, 16 Mar 2022 07:28:21 -0400
X-MC-Unique: -2yQ4tOzOQyI_t2B5wBwLw-1
Received: by mail-qk1-f197.google.com with SMTP id 12-20020a37090c000000b0067b32f93b90so1246453qkj.16
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 04:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DBQCoz8qCairO5B/8lBxRWesfMetskAHdL6PPOwTX6U=;
        b=LCQaHOT5YTnri3jPwdnHe9oHtIJP4bVHTFqDl8I0zH+yL7oEs2uGEjBIzQVGlaUtsS
         /1jQQge9HvTFYBnnB4nE1WsU77p4Jf6PkC4yz7fvgiy0eMZyjP2pDFpdhSTlHNClT0WY
         9LbqjGdbjgXqWYcrbQj3jI1EF+2/NyJhs2LSUjT1duPfFK+1qe7ydGm8rYqyoDaF51P+
         s5QL4c1a0E8ILzbzLOnirXDbBOpNyqqcTA/nPtC3e8nPfcd+w5j/aW1aD7CppZzA8b4D
         koaa2fp4APeK8j3WpstG1ESALkEfxlDnogwkda42NzhxiaWqfpFwA+gGdGv1L1Tal035
         bniA==
X-Gm-Message-State: AOAM533ETDGiFmBOsbHjyip8qBn8JFkn6cD5JLKFCLb1sWg5I1WWY7Dt
        J5ztb1udl9M7+6q1lpTv7rj3SP1OKdArgVIsccqX3DtriD5iiliFJayJraSJVF8hqDSSOhbuT0j
        zoEI3uVfOPCqZvXEW8qoa
X-Received: by 2002:a05:620a:4689:b0:67d:4c03:651c with SMTP id bq9-20020a05620a468900b0067d4c03651cmr20642753qkb.475.1647430101132;
        Wed, 16 Mar 2022 04:28:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4l6uhOJbcpz6eJLQ1LFV75T/NaF/017SCpgPrm5JLMZLCeCviWJ5ya+Y9M44D0KQ1YX81VA==
X-Received: by 2002:a05:620a:4689:b0:67d:4c03:651c with SMTP id bq9-20020a05620a468900b0067d4c03651cmr20642743qkb.475.1647430100866;
        Wed, 16 Mar 2022 04:28:20 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id k8-20020a05620a138800b00679fc7566fcsm770863qki.18.2022.03.16.04.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 04:28:20 -0700 (PDT)
Date:   Wed, 16 Mar 2022 07:28:18 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't include bnobt blocks when reserving free
 block pool
Message-ID: <YjHJ0qOUnmAUEgoV@bfoster>
References: <20220314180847.GM8224@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314180847.GM8224@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 14, 2022 at 11:08:47AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_reserve_blocks controls the size of the user-visible free space
> reserve pool.  Given the difference between the current and requested
> pool sizes, it will try to reserve free space from fdblocks.  However,
> the amount requested from fdblocks is also constrained by the amount of
> space that we think xfs_mod_fdblocks will give us.  We'll keep trying to
> reserve space so long as xfs_mod_fdblocks returns ENOSPC.
> 
> In commit fd43cf600cf6, we decided that xfs_mod_fdblocks should not hand
> out the "free space" used by the free space btrees, because some portion
> of the free space btrees hold in reserve space for future btree
> expansion.  Unfortunately, xfs_reserve_blocks' estimation of the number
> of blocks that it could request from xfs_mod_fdblocks was not updated to
> include m_allocbt_blks, so if space is extremely low, the caller hangs.
> 
> Fix this by including m_allocbt_blks in the estimation, and modify the
> loop so that it will not retry infinitely.
> 
> Found by running xfs/306 (which formats a single-AG 20MB filesystem)
> with an fstests configuration that specifies a 1k blocksize and a
> specially crafted log size that will consume 7/8 of the space (17920
> blocks, specifically) in that AG.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Fixes: fd43cf600cf6 ("xfs: set aside allocation btree blocks from block reservation")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 33e26690a8c4..78b6982ea5b0 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -379,6 +379,7 @@ xfs_reserve_blocks(
>  	int64_t			fdblks_delta = 0;
>  	uint64_t		request;
>  	int64_t			free;
> +	unsigned int		tries;
>  	int			error = 0;
>  
>  	/* If inval is null, report current values and return */
> @@ -432,9 +433,16 @@ xfs_reserve_blocks(
>  	 * perform a partial reservation if the request exceeds free space.
>  	 */
>  	error = -ENOSPC;
> -	do {
> -		free = percpu_counter_sum(&mp->m_fdblocks) -
> -						mp->m_alloc_set_aside;
> +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {

Any reason for the magic number of retries as opposed to perhaps just
not retrying at all? This seems a little odd when you think about it
given that the request is already intended to take available space into
account and modify the request from userspace. OTOH, another
consideration could be to retry some (really large?) number of times and
then bail out if we happen to iterate without an observable change in
free space (i.e., something is wrong), however I suppose that could be
racy as well. *shrug*

> +		/*
> +		 * The reservation pool cannot take space that xfs_mod_fdblocks
> +		 * will not give us.  This includes the per-AG set-aside space
> +		 * and free space btree blocks that are not available for
> +		 * allocation due to per-AG metadata reservations.
> +		 */
> +		free = percpu_counter_sum(&mp->m_fdblocks);
> +		free -= mp->m_alloc_set_aside;
> +		free -= atomic64_read(&mp->m_allocbt_blks);

Seems reasonable. Do we want to consider ->m_allocbt_blks in other
places where ->m_alloc_set_aside is used (i.e. xfs_fs_statfs(), etc.)?
Not sure how much it matters for space reporting purposes, but if so, it
might also be worth reconsidering the usefulness of a static field and
initialization helper (i.e. xfs_alloc_set_aside()) if the majority of
uses involve a dynamic calculation (due to ->m_allocbt_blks).

Brian

>  		if (free <= 0)
>  			break;
>  
> @@ -459,7 +467,7 @@ xfs_reserve_blocks(
>  		spin_unlock(&mp->m_sb_lock);
>  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
>  		spin_lock(&mp->m_sb_lock);
> -	} while (error == -ENOSPC);
> +	}
>  
>  	/*
>  	 * Update the reserve counters if blocks have been successfully
> 

