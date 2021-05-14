Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB454C433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4E1613E9
	for <linux-xfs@archiver.kernel.org>; Fri, 14 May 2021 12:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhENMk5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 May 2021 08:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232712AbhENMk4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 May 2021 08:40:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620995985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EQQwhvgtwZyH320vXDMEGHFsETuo+DlrHUQlvvoka5g=;
        b=bgKZybPV4Rw+uMdJrnjZl7EFfIg8enVFhI2+HZiL53B3jfX/Qh3UE/UJc9wen0UsaBcciy
        D/P3M49QwVE3PFiXFELJuWsCNpdWTp8lF1xPkq/3qvmamOuWU6xJxHrgq6TU6FzrhjAxTS
        eAg0vHIoLHdXF6pCeBK3smMc1qzavaQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-JPsbijPfPLCWXktZrP8pjQ-1; Fri, 14 May 2021 08:39:43 -0400
X-MC-Unique: JPsbijPfPLCWXktZrP8pjQ-1
Received: by mail-qv1-f70.google.com with SMTP id t1-20020a0ca6810000b029019e892416e6so23722452qva.9
        for <linux-xfs@vger.kernel.org>; Fri, 14 May 2021 05:39:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EQQwhvgtwZyH320vXDMEGHFsETuo+DlrHUQlvvoka5g=;
        b=qQfcdbGVfzDDCF9xIYtEHQ+Fvm27+OgjW2LbXdJft4CD8GGb7IrtuCi0Cu/EN4eDEv
         HCKkQxabZdntHiCppAQemBZLwSGCqmx8mmQDQkaozXDR2spLTCyhBMUaSgS6kIWC7Qfg
         cHHboV01gOYYJeYcpMQwKKf8X2q/QCYITt7hicli4QvxOkOYlGcBn0sQyYfMWD9I2Wry
         zP4ryJ1zQF5rLXGbKuxvrLhoyAqJknQKGZCGeph9GdtrNl+L7n1YEp3ykbXS1W6DiScJ
         Jnr2V9ik1j2U+84ePwohjPtHVkpsSKphj5eTCu/+UOTh7bV4rHIpbCJzsshz98eL0XF0
         Vh5g==
X-Gm-Message-State: AOAM530IvHO283/giu3vQkvahmBNSbpti1t3ktHFJZ8Sic0qKjTlxo4a
        Fy14wg/lfsHMEDE+b8lD+Oa+3cGFYVVwE/tyTlsAZ+JSlY3HS8lf++yXiAdpNnM00l6Hnd1+RUX
        Cr5WspZRmDhlPuY3/IaLE
X-Received: by 2002:a37:6554:: with SMTP id z81mr44338692qkb.472.1620995982972;
        Fri, 14 May 2021 05:39:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwANspRqzw7nWKx7YLHmSb/WHwtLfQCVEIkilF2AyBk0QH3sdSQPKDOYHKj0XSfECGrpsDU9g==
X-Received: by 2002:a37:6554:: with SMTP id z81mr44338680qkb.472.1620995982818;
        Fri, 14 May 2021 05:39:42 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id z187sm4650871qkb.129.2021.05.14.05.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:39:42 -0700 (PDT)
Date:   Fri, 14 May 2021 08:39:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove redundant assignment to busy
Message-ID: <YJ5vjIKWtrulwO6M@bfoster>
References: <1620903078-58184-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620903078-58184-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 13, 2021 at 06:51:18PM +0800, Jiapeng Chong wrote:
> Variable busy is set to false, but this value is never read as it is
> overwritten or not used later on, hence it is a redundant assignment
> and can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> fs/xfs/libxfs/xfs_alloc.c:1679:2: warning: Value stored to 'busy' is
> never read [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---

Part of me wonders whether it would be better to still initialize the
variable where it's defined, assuming that would quiet the code analyzer
(?). Not a big deal either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 82b7cbb..ae46fe6 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1676,7 +1676,6 @@ struct xfs_alloc_cur {
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
>  		args->agno, XFS_BTNUM_CNT);
>  	bno_cur = NULL;
> -	busy = false;
>  
>  	/*
>  	 * Look for an entry >= maxlen+alignment-1 blocks.
> -- 
> 1.8.3.1
> 

