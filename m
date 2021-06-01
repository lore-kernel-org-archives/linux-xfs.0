Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2AAC47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 10:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7CC613AB
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 10:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhFAKp7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 06:45:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37315 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhFAKp6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 06:45:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622544257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=85sAomWQ4UCXm7YZ5YESx+eUYZ6nv4OK1R+TP2CLNKM=;
        b=XiR93yRlc+g3qFtddUp+w62SAZI6VgPIIAdY5QA1AGaXuVfTJqmWQjlaoiqMk89pXwCkcS
        ZLpbOGkOsAESVzzQ7AVZtNucksW6W/A3Uct3kw43m2eQ4oFFdHrc3d8HeGRa3+tL4k1CWk
        ibXr3X0bA3SbHvlNj8iddKDJ4+BT+44=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-I3HAgD8-PmS9yJSPUjeDKg-1; Tue, 01 Jun 2021 06:44:14 -0400
X-MC-Unique: I3HAgD8-PmS9yJSPUjeDKg-1
Received: by mail-wm1-f69.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso1132425wmj.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jun 2021 03:44:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=85sAomWQ4UCXm7YZ5YESx+eUYZ6nv4OK1R+TP2CLNKM=;
        b=bEF4gFTD9TCkp9Crasl2JaBLboQCFxasQpqwrwG/R0y3HwwWuRByinuakcUOzoctqA
         V+CfWgpc4Qb41nhe15S+zJXS5AQuqmm1QPTcYAtxfUFL8ybwRSsoU8jAEUOY6WNt1lkn
         H4iENcHNk+Waihvo6AFxZIYf2imVTgB6+Q/fr1urDqOPGmqsDVoCpAPBwG6udnoScaeo
         YocYIeyEJTmdXFmTsHnsivRh6XFxnTwdMqIsMgu5Bryi4SRkXLFctU2u98wzKledkNDN
         x3AW70BNrjjTxraNq915abwS5s769p4hO1CzI+zVM0XwYUSHE/7pZJvnfSPdFbX8NhIV
         vb1A==
X-Gm-Message-State: AOAM5330uyW6ooAXbA89FrBOv9lOOBQ/tGXXV3pitNR/jAMVwgflqWX5
        rGQjNSq/NFwKo22rZfDqqYsaIy1CqwSA4bqNW3G6IUGvEdEcAXDifsR/oirCe+e39P5am4+M38o
        HPBdxeQw6tg0FDnuvL92y
X-Received: by 2002:adf:f305:: with SMTP id i5mr9982370wro.29.1622544253616;
        Tue, 01 Jun 2021 03:44:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwR/60f8CEPqHe+lopI4IxNs0E4AcjsviyGve3CDqCbx+sYb4fVSDKOEtbL+qPY7QK5VR4CoA==
X-Received: by 2002:adf:f305:: with SMTP id i5mr9982350wro.29.1622544253463;
        Tue, 01 Jun 2021 03:44:13 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id r14sm2498253wrx.74.2021.06.01.03.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 03:44:13 -0700 (PDT)
Date:   Tue, 1 Jun 2021 12:44:11 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 3/3] xfs: remove unnecessary shifts
Message-ID: <20210601104411.njynhaqasoq6ezi2@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, hch@infradead.org
References: <162250083252.490289.17618066691063888710.stgit@locust>
 <162250084916.490289.453146390591474194.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250084916.490289.453146390591474194.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:40:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The superblock verifier already validates that (1 << blocklog) ==
> blocksize, so use the value directly instead of doing math.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_bmap_util.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0936f3a96fe6..997eb5c6e9b4 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -945,7 +945,7 @@ xfs_flush_unmap_range(
>  	xfs_off_t		rounding, start, end;
>  	int			error;
>  
> -	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
> +	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
>  	start = round_down(offset, rounding);
>  	end = round_up(offset + len, rounding) - 1;
>  
> @@ -1053,9 +1053,9 @@ xfs_prepare_shift(
>  	 * extent (after split) during the shift and corrupt the file. Start
>  	 * with the block just prior to the start to stabilize the boundary.
>  	 */
> -	offset = round_down(offset, 1 << mp->m_sb.sb_blocklog);
> +	offset = round_down(offset, mp->m_sb.sb_blocksize);
>  	if (offset)
> -		offset -= (1 << mp->m_sb.sb_blocklog);
> +		offset -= mp->m_sb.sb_blocksize;
>  
>  	/*
>  	 * Writeback and invalidate cache for the remainder of the file as we're
> 

-- 
Carlos

