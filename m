Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA646C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 12:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC2B611AB
	for <linux-xfs@archiver.kernel.org>; Thu, 13 May 2021 12:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhEMMIh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 May 2021 08:08:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229466AbhEMMIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 May 2021 08:08:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620907639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r8JtJSKyZ2dBqMieLjrmrdUZBPYYrmBK4rpQFDO7Fds=;
        b=CoIy+yrPKLvI9ZH+kTLlz3tgjmeWP2GWbDufqnnLuHP0NWmiIqEm2O/9PbNHzUG2Y9/hGP
        6JlinqFhvLDxn9HCv966KtbEwFHyFdku24foIDyZ84Cu+muy3Ib8TVeMoAKJrkI5P0u7YI
        5ooKxyZfBHR11sOrtl9cCBLsEyNKJA8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-qOMZAwGOPM-OJ9Lx2mj_LA-1; Thu, 13 May 2021 08:07:18 -0400
X-MC-Unique: qOMZAwGOPM-OJ9Lx2mj_LA-1
Received: by mail-qt1-f199.google.com with SMTP id b19-20020ac84f130000b02901d543c52248so14625335qte.1
        for <linux-xfs@vger.kernel.org>; Thu, 13 May 2021 05:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r8JtJSKyZ2dBqMieLjrmrdUZBPYYrmBK4rpQFDO7Fds=;
        b=nHJ3rMjgI+8w0vgRF5lBPDAx1Bw/SSjWC2FFsWQqcUXXRQ0MI3eNkOSkfJ1oqoBZbR
         3yN9ehvgxRK4cxaSfX2eUSPNQccoI6bdDnI5hUlDFPvJisVQXWmrpHZp/TRNCRwxYpg0
         FOaP/w/cjR4IXt07LdUiHCDbXQN1KUs3WcL9aM8FzNBOpkcvkf6U1B4guogzrRgWF9E7
         AdRZWUrurpOrrnVir7ls0zSIhq1NWFAKfyE2Bg/lr4NaApmedEWwNGtbz3nIT8uAkYPQ
         dpsc6UV4cr9oJvRlBdm5ZnDaTUjC/DXg3xU7FRI3tk2sdfRWhK+3OjBevJRwu+f/ocdP
         j1Yg==
X-Gm-Message-State: AOAM533cnn0Eqn+l9+ViZ5LuFqwtMaooFOdtlUSV9v/YaeuLbfVArvcZ
        OKzAKACtNU7IQGt1pCDduJD4PM9KzO77RzOCirZYtPP8Bwtnp6YGbyC1tseTqoPnquRjENq9X69
        nxaLXjEuSsUM2wvlwzR9t
X-Received: by 2002:a05:620a:13a8:: with SMTP id m8mr27798507qki.213.1620907637525;
        Thu, 13 May 2021 05:07:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRlUb/9uuqbkxuBdxbPjiNEBZQali2w2CJnvfhkS/tbI5xvhFRjT0oUSsYMv6lcM/iOaItNw==
X-Received: by 2002:a05:620a:13a8:: with SMTP id m8mr27798500qki.213.1620907637369;
        Thu, 13 May 2021 05:07:17 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id y9sm2145638qkm.19.2021.05.13.05.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:07:17 -0700 (PDT)
Date:   Thu, 13 May 2021 08:07:15 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: restore old ioctl definitions
Message-ID: <YJ0Wc8xmwhPtxbDF@bfoster>
References: <162086768823.3685697.11936501771461638870.stgit@magnolia>
 <162086769988.3685697.8916977231906580597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162086769988.3685697.8916977231906580597.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 06:01:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These ioctl definitions in xfs_fs.h are part of the userspace ABI and
> were mistakenly removed during the 5.13 merge window.
> 
> Fixes: 9fefd5db08ce ("xfs: convert to fileattr")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Maybe we should add a comment if these need to stick around unused in
the kernel code..? Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index a83bdd0c47a8..bde2b4c64dbe 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -770,6 +770,8 @@ struct xfs_scrub_metadata {
>  /*
>   * ioctl commands that are used by Linux filesystems
>   */
> +#define XFS_IOC_GETXFLAGS	FS_IOC_GETFLAGS
> +#define XFS_IOC_SETXFLAGS	FS_IOC_SETFLAGS
>  #define XFS_IOC_GETVERSION	FS_IOC_GETVERSION
>  
>  /*
> @@ -780,6 +782,8 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_ALLOCSP		_IOW ('X', 10, struct xfs_flock64)
>  #define XFS_IOC_FREESP		_IOW ('X', 11, struct xfs_flock64)
>  #define XFS_IOC_DIOINFO		_IOR ('X', 30, struct dioattr)
> +#define XFS_IOC_FSGETXATTR	FS_IOC_FSGETXATTR
> +#define XFS_IOC_FSSETXATTR	FS_IOC_FSSETXATTR
>  #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
>  #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
>  #define XFS_IOC_GETBMAP		_IOWR('X', 38, struct getbmap)
> 

