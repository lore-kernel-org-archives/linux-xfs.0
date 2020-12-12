Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28118C4361B
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 16:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA80D22AAF
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Dec 2020 16:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436649AbgLLQOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:14:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437122AbgLLQOe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Dec 2020 11:14:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607789587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJHtWEAaq9mILAH7ZOu8et1GbzEeBq8r2vbaNO9BgGg=;
        b=D84HDMRw7Me/scjOnhXWwy8pH9jilqmsTE1iogvhaN/90GEhqqb53yoYqcSv3YjtgHA9zR
        XinrGP/vIgWxlKYVjjyvB0NzqdiELH2mwVf8D2AjEpGRBc7ffuavSVd0iO75jaylGFRQLq
        IZ9LFFp29dncPnaFjUobyJqAnClP+4w=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-JPuWyAPyNxeWSPmwauCYsw-1; Sat, 12 Dec 2020 11:13:05 -0500
X-MC-Unique: JPuWyAPyNxeWSPmwauCYsw-1
Received: by mail-pf1-f200.google.com with SMTP id e4so8299151pfc.11
        for <linux-xfs@vger.kernel.org>; Sat, 12 Dec 2020 08:13:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PJHtWEAaq9mILAH7ZOu8et1GbzEeBq8r2vbaNO9BgGg=;
        b=fiWeJ9WvZBrOfvUnty1jXJo+MJfdmhD4tXj+RXtFC0DLD9ICevuT1oKJIo7GdX+nan
         oSdUx2V5A0pLbpStOwt8QtVdTvId7kmvtiJdyzt02y8xrOzhXptcUnb6LM//XihTkxR3
         HmiLMWEPj0oTPXZ9bdW5PWB071HnwopRSNxGvxLidiAfFNfIQzRyfLrhasf8UxjsCBZG
         Cm7R9r2c5xe5fTkv27r3DF9Pa+5Wu2azfZQEpnAZM0Pa8b43mPiuFXooQxxKHV3NmgHK
         rwa7RvOoPCtQGKmwfSgkeUsrv4xa67PKxNlXAof70qmipnEb1ZBY7A/4Zt5ZnkrWYQSe
         Y3sQ==
X-Gm-Message-State: AOAM532NYAQ2QxzXlaU7PaOM7ZtjIz/7BzY95/0XScXfJKwSF3wh4sXv
        LRdoFWzPalumdOFmGIUbsl99/4q+FUHMtAI8WOK5I26M4NcpoJePKVuNBMjaRfp7HAHt4LVnnO+
        PSxCvBFRFtSG8TIa7FQiZ
X-Received: by 2002:a17:902:b496:b029:da:d356:be8c with SMTP id y22-20020a170902b496b02900dad356be8cmr15659232plr.56.1607789584335;
        Sat, 12 Dec 2020 08:13:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxh+RUJIV50IX1HR5B62wzsB/9XVzjJcLZ6EHjfG9xO+P+UCA20WZh1fLRq0/TdAH+2B+Z3cw==
X-Received: by 2002:a17:902:b496:b029:da:d356:be8c with SMTP id y22-20020a170902b496b02900dad356be8cmr15659214plr.56.1607789584018;
        Sat, 12 Dec 2020 08:13:04 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k14sm14479519pfp.132.2020.12.12.08.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Dec 2020 08:13:03 -0800 (PST)
Date:   Sun, 13 Dec 2020 00:12:53 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     chenlei0x@gmail.com
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lei Chen <lennychen@tencent.com>
Subject: Re: [PATCH] xfs: clean code for setting bma length in xfs_bmapi_write
Message-ID: <20201212161253.GA94979@xiangao.remote.csb>
References: <1607777297-22269-1-git-send-email-lennychen@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1607777297-22269-1-git-send-email-lennychen@tencent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Dec 12, 2020 at 08:48:17PM +0800, chenlei0x@gmail.com wrote:
> From: Lei Chen <lennychen@tencent.com>
> 
> xfs_bmapi_write may need alloc blocks when it encounters a hole
> or delay extent. When setting bma.length, it does not need comparing
> MAXEXTLEN and the length that the caller wants, because
> xfs_bmapi_allocate will handle every thing properly for bma.length.
> 
> Signed-off-by: Lei Chen <lennychen@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index dcf56bc..e1b6ac6 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4417,18 +4417,7 @@ struct xfs_iread_state {
>  			bma.wasdel = wasdelay;
>  			bma.offset = bno;
>  			bma.flags = flags;
> -
> -			/*
> -			 * There's a 32/64 bit type mismatch between the
> -			 * allocation length request (which can be 64 bits in
> -			 * length) and the bma length request, which is
> -			 * xfs_extlen_t and therefore 32 bits. Hence we have to
> -			 * check for 32-bit overflows and handle them here.
> -			 */
> -			if (len > (xfs_filblks_t)MAXEXTLEN)
> -				bma.length = MAXEXTLEN;
> -			else
> -				bma.length = len;
> +			bma.length = len;

After refering to the definition of struct xfs_bmalloca, so I think
bma.length is still a xfs_extlen_t ===> uint32_t, so I'm afraid the commit
a99ebf43f49f ("xfs: fix allocation length overflow in xfs_bmapi_write()")

and the reason for adding this is still valid for now?

Thanks,
Gao Xiang

