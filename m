Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E9BC4743C
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 16:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54514613CD
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Jun 2021 16:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbhFNQQu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Jun 2021 12:16:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51020 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233430AbhFNQQt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Jun 2021 12:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623687286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1tD1m0yEZ1nrBzI1qX/MjrJ3pKCfKCcfybVGs2OR6IY=;
        b=Kp0B+k/ZpLQ3aJRXF+kJQ7ZolrvzeShLRinVD/fxPNmpo5woMcjWQv2faW0zox4W19vDgf
        pLYD8HoxJywRIOyy+rU9FkcvCDvFJCM0eejB2Lb9eDTirPgn8H/UFYawzNwGwAiypFvRGE
        0Nnff21TmSM3LbuqxFC9wlPU8GRDAE8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-X7k3z1LLNMiKgtz1p8RExw-1; Mon, 14 Jun 2021 12:14:43 -0400
X-MC-Unique: X7k3z1LLNMiKgtz1p8RExw-1
Received: by mail-oi1-f199.google.com with SMTP id y137-20020aca4b8f0000b02901f1fb748c74so5829080oia.21
        for <linux-xfs@vger.kernel.org>; Mon, 14 Jun 2021 09:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tD1m0yEZ1nrBzI1qX/MjrJ3pKCfKCcfybVGs2OR6IY=;
        b=b5QlNG1DJzRIqZzrFzavFzZRneFjX21Dma711LNfrRoNEjaUqwCViNF7RrlZIEcmYq
         Tky5clpLx7p7hjS6LBGEVk0Iji0DulveRItlu59FVZPeneBX2tSafVXdj3aMMEqcPIol
         +NUPaZNwTbIb3+Fof8sq7Xw89xS3E/1Gzp27FJCaa2vESMcTp0Ppk67TNoDxMYCXMJtF
         tZ/JpYCXKgW0+JLONkdigoFXETuQ6iwynSxwhKV7aaE1b+3/djCfnh/ptQSe+4MnQHhr
         ism+C91qLuFNjp5FEnCsquKcqUMW8G/2np+kAZHXLR11C44K485qNjO8ZI8c/AHBm3LJ
         /bxg==
X-Gm-Message-State: AOAM5338cRRmcr+AVNjWiOln677My5b1wFF0uXqluLS2k4mzJL+AZ2Z9
        r/7ZZ4utPWPNBBgwNuLQ90likEMoYoLe1dukWgIm16UT1ByUwHlw4Y2wrbOpNoQwHhT6iR6Xjcz
        KUsQKEV27M+yBh71XydDf
X-Received: by 2002:a9d:4b98:: with SMTP id k24mr14434989otf.359.1623687282487;
        Mon, 14 Jun 2021 09:14:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlzG5IVVKyL0BRyecJq+UWc1QgvQnJCmLlX12Vwza6f4sw9UxlHqIWdzsg8dzxEoCdkQFwag==
X-Received: by 2002:a9d:4b98:: with SMTP id k24mr14434976otf.359.1623687282309;
        Mon, 14 Jun 2021 09:14:42 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id a7sm3176821ooo.9.2021.06.14.09.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 09:14:42 -0700 (PDT)
Date:   Mon, 14 Jun 2021 12:14:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH 05/16] xfs: separate primary inode selection criteria in
 xfs_iget_cache_hit
Message-ID: <YMeAb8FRxDhB3Gxh@bfoster>
References: <162360479631.1530792.17147217854887531696.stgit@locust>
 <162360482438.1530792.18197198406001465325.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162360482438.1530792.18197198406001465325.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 13, 2021 at 10:20:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> During review of the v6 deferred inode inactivation patchset[1], Dave
> commented that _cache_hit should have a clear separation between inode
> selection criteria and actions performed on a selected inode.  Move a
> hunk to make this true, and compact the shrink cases in the function.
> 
> [1] https://lore.kernel.org/linux-xfs/162310469340.3465262.504398465311182657.stgit@locust/T/#mca6d958521cb88bbc1bfe1a30767203328d410b5
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c |   39 ++++++++++++++++-----------------------
>  1 file changed, 16 insertions(+), 23 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7939eced3a47..4002f0b84401 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -562,13 +562,8 @@ xfs_iget_cache_hit(
>  	 * will not match, so check for that, too.
>  	 */
>  	spin_lock(&ip->i_flags_lock);
> -	if (ip->i_ino != ino) {
> -		trace_xfs_iget_skip(ip);
> -		XFS_STATS_INC(mp, xs_ig_frecycle);
> -		error = -EAGAIN;
> -		goto out_error;
> -	}
> -
> +	if (ip->i_ino != ino)
> +		goto out_skip;
>  
>  	/*
>  	 * If we are racing with another cache hit that is currently
> @@ -580,12 +575,8 @@ xfs_iget_cache_hit(
>  	 *	     wait_on_inode to wait for these flags to be cleared
>  	 *	     instead of polling for it.
>  	 */
> -	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
> -		trace_xfs_iget_skip(ip);
> -		XFS_STATS_INC(mp, xs_ig_frecycle);
> -		error = -EAGAIN;
> -		goto out_error;
> -	}
> +	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM))
> +		goto out_skip;
>  
>  	/*
>  	 * Check the inode free state is valid. This also detects lookup
> @@ -595,23 +586,21 @@ xfs_iget_cache_hit(
>  	if (error)
>  		goto out_error;
>  
> +	/* Skip inodes that have no vfs state. */
> +	if ((flags & XFS_IGET_INCORE) &&
> +	    (ip->i_flags & XFS_IRECLAIMABLE))
> +		goto out_skip;
> +
> +	/* The inode fits the selection criteria; process it. */
>  	if (ip->i_flags & XFS_IRECLAIMABLE) {
> -		if (flags & XFS_IGET_INCORE) {
> -			error = -EAGAIN;
> -			goto out_error;
> -		}
> -
>  		/* Drops i_flags_lock and RCU read lock. */
>  		error = xfs_iget_recycle(pag, ip);
>  		if (error)
>  			return error;
>  	} else {
>  		/* If the VFS inode is being torn down, pause and try again. */
> -		if (!igrab(inode)) {
> -			trace_xfs_iget_skip(ip);
> -			error = -EAGAIN;
> -			goto out_error;
> -		}
> +		if (!igrab(inode))
> +			goto out_skip;
>  
>  		/* We've got a live one. */
>  		spin_unlock(&ip->i_flags_lock);
> @@ -628,6 +617,10 @@ xfs_iget_cache_hit(
>  
>  	return 0;
>  
> +out_skip:
> +	trace_xfs_iget_skip(ip);
> +	XFS_STATS_INC(mp, xs_ig_frecycle);
> +	error = -EAGAIN;
>  out_error:
>  	spin_unlock(&ip->i_flags_lock);
>  	rcu_read_unlock();
> 

