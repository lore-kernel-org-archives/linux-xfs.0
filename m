Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561DDC47094
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 13:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D39610C7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 13:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhFGNPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 09:15:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230203AbhFGNPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jun 2021 09:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623071640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hs4yE34WnGZd3JFHSrloTR+6ttoxdUCGayaSBwNWKtY=;
        b=KjwLa/h4luUmwrqhD3u7KfgX568gSg6BDH4re+hh9iXjo6JZaKjQKKmv96Fu/pXFRDNzbh
        RJaZVz0aHTQXi7ypY1FEZFOVeHOPQsB6wbzsPu5Br/ICg9ENZujYZelFl1VSzW2sDOcN0O
        dK/7wOCxXhftcv5NUXnpkZpJiDsb4Yk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-vNeG9KXBMy2MK3gQjKMZCg-1; Mon, 07 Jun 2021 09:13:59 -0400
X-MC-Unique: vNeG9KXBMy2MK3gQjKMZCg-1
Received: by mail-wm1-f69.google.com with SMTP id z25-20020a1c4c190000b029019f15b0657dso4091502wmf.8
        for <linux-xfs@vger.kernel.org>; Mon, 07 Jun 2021 06:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Hs4yE34WnGZd3JFHSrloTR+6ttoxdUCGayaSBwNWKtY=;
        b=Nn4r+HJHOklU/FrzVg5Gu34tumVFg7KSulB/duSHKjZ6/ypf36VFbLoEYI77WbYwxq
         8QhoGQj6INkWx4MFYcbO16TzVhl5zwg7gBxFGgiUeh+Y7H5m7OUt189gRf+o6e6h9htg
         bpwEg9yqgT+OFDv8U6EEzUEk3rdON1ixHG5VMUyGhgEXqbI9KbyW0Ysy1iMStFmJSB1T
         ISpH/jbZ886vOLQ0cZuP97y2exuMCZ+TiojvEtczlKE37kZwuAQ61ItEvO5UcxvNqW4t
         ixGelbs6Qm1S9lzepfF0nESViDjlX7PGpVamFhCs4qsV16sCr/SqfWi6/2Vaa7mSlq2d
         /c0w==
X-Gm-Message-State: AOAM530/ijG7pvDpTLz0/yQ9QId6LtSX4p5wrctcsngZOjr1zLroHckS
        kic2crv3gAqiweO0ZGcayBXXU7xjEa6Zw1VgBZGRfhMzWwod0dceoLRcHd3H8/b/3m6ZkBSeDKn
        YyarOOWxS4FBNWBDoSOSv
X-Received: by 2002:a1c:4c18:: with SMTP id z24mr13504210wmf.27.1623071638087;
        Mon, 07 Jun 2021 06:13:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzU/yGT93RPfYj3GBKMynyqUdvtSWdnRPREgAt+DPRPDoOiamINOzbmrIdF4/wpM7J0slzs2w==
X-Received: by 2002:a1c:4c18:: with SMTP id z24mr13504180wmf.27.1623071637715;
        Mon, 07 Jun 2021 06:13:57 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id k42sm4746963wms.0.2021.06.07.06.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 06:13:57 -0700 (PDT)
Date:   Mon, 7 Jun 2021 15:13:55 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: remove redundant initialization of variable error
Message-ID: <20210607131355.bjdf7lovz5drofrw@omega.lan>
Mail-Followup-To: Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
References: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Sat, Jun 05, 2021 at 04:52:50PM +0800, Shaokun Zhang wrote:
> 'error' will be initialized, so clean up the redundant initialization.
> 
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>


This makes no difference in the resulting code.
Particularly, I'd rather have such variables explicitly initialized. This
function is small, so it's easy to see its initialization later in the code, but
still, IMHO, it's way better to see the 'default error values' explicit at the
beginning of the function. But, it's just my 'visual' preference :)


> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 592800c8852f..59991c8c7127 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -707,7 +707,7 @@ xfs_buf_get_map(
>  {
>  	struct xfs_buf		*bp;
>  	struct xfs_buf		*new_bp;
> -	int			error = 0;
> +	int			error;
>  
>  	*bpp = NULL;
>  	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
> -- 
> 2.7.4
> 

-- 
Carlos

