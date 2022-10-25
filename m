Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE70DFA373E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 19:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiJYTO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 15:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiJYTOz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 15:14:55 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DED32AB5
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:14:54 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ez6so11803367pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 12:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7OA81GbJ8NexZ0fmEMg/WSL+ByYDpEUAYPExBWuW9Y=;
        b=bWOepIfDAuHGI5Bs1RZfyoSB0ixPJwWmJLyYNFF5KE3zDstd4AHi9SYBfTufkRgqTp
         xiv+DhLdVfK8oii2qyJLmbNOop1mZI4mmtam3c17EO5lIg0WH2K4GI2Y3T6Kv37p7M8w
         p+DY1sf/Z1wyPTSznJLygpChFF89RFJLGZPS8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7OA81GbJ8NexZ0fmEMg/WSL+ByYDpEUAYPExBWuW9Y=;
        b=Zbem4ZWfA7YbDvetIARtQOcIOKtpZf1dJ/RlcAy6fdbNZgmglcyjNTcuAOsuFN3k9M
         W4H7TkytcnMBcfD/Th+ghKJYnyq3eKQYesXDZ5TCUlGf6nSh+Za60N+mUYupWaoBevrW
         0dWGg7+5e+DMUvKqyKKUZPg1bBHLx24pXVjrPP5JgCnslaI5fxdPlyjbeioaupJIHUXC
         ylHcpbjSnmgvos5s5DLipEtxTaF26RE4jJhLr8flDrUdvQUP+OBmY9gXLk/wQNx6wogA
         /AAn+idY+NmJXYlxJ3uvkLfWCJVZ9rWNuOkAAPI3RmfNy+NN0kM4usQJagqKZni+hx4W
         hrsw==
X-Gm-Message-State: ACrzQf3nhZMo7YpjWrV8YJtar9lj3YV4xAL3r7QblkjYNvmvfAdvhpzb
        OPqH2Xl8XJvlS/CawnbetZnssFyw5Ujesg==
X-Google-Smtp-Source: AMsMyM4CRHjSDYa45rSxytLkF2wQpNflkW5K+G3bxVd4bSnwjU6ctKBxV6972/EfujyMNwq/9G+7ag==
X-Received: by 2002:a17:90b:4a43:b0:212:fd76:be5d with SMTP id lb3-20020a17090b4a4300b00212fd76be5dmr17359087pjb.152.1666725294319;
        Tue, 25 Oct 2022 12:14:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id r10-20020a63d90a000000b00458a0649474sm1590895pgg.11.2022.10.25.12.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:14:53 -0700 (PDT)
Date:   Tue, 25 Oct 2022 12:14:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
Message-ID: <202210251210.9954A72C@keescook>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664718541.2688790.5847203715269286943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664718541.2688790.5847203715269286943.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor all the open-coded sizeof logic for EFI/EFD log item and log
> format structures into common helper functions whose names reflect the
> struct names.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |   48 ++++++++++++++++++++++++++++
>  fs/xfs/xfs_extfree_item.c      |   69 ++++++++++++----------------------------
>  fs/xfs/xfs_extfree_item.h      |   16 +++++++++
>  fs/xfs/xfs_super.c             |   12 ++-----
>  4 files changed, 88 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 2f41fa8477c9..f13e0809dc63 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -616,6 +616,14 @@ typedef struct xfs_efi_log_format {
>  	xfs_extent_t		efi_extents[];	/* array of extents to free */
>  } xfs_efi_log_format_t;
>  
> +static inline size_t
> +xfs_efi_log_format_sizeof(
> +	unsigned int		nr)
> +{
> +	return sizeof(struct xfs_efi_log_format) +
> +			nr * sizeof(struct xfs_extent);
> +}

These are all just open-coded versions of struct_size(). It's better
to use those, instead, as they will never overflow. (They saturate at
SIZE_MAX.) i.e. what you proposed here:
https://lore.kernel.org/linux-xfs/20210311031745.GT3419940@magnolia/

Otherwise, yeah, looks good.

-Kees

-- 
Kees Cook
