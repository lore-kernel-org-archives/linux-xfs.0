Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A220C3A5A8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 07:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 436C322CEA
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 07:24:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UWJecWAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfIDHYY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 03:24:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41784 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbfIDHYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 03:24:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so9178779pls.8
        for <linux-xfs@vger.kernel.org>; Wed, 04 Sep 2019 00:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FWsObhQJfhrPfHv+Tq8mhfWHC9qobH9HkDFVxkGzwUs=;
        b=UWJecWALeQGg97zqS9WcT/+EKj3ZmyAzd2mpZ7p44Tay2sCYllYwO8uEibMIl1phqV
         Ljo08HCcew/5E2TG8LDtyQIbDBPTy0Hvh+x0xvbRLS6iQnIH1KpqmNs2ryAsInS7vYp6
         s+mGE1ukEBb56GdTqJJb43d4LukJycuB2svrg1aF+4KGhx/HmbsGxNet1/JYkzF0nBby
         varg2gCfoC4N+AUVmqKBiRrFoC1pL7Nlb8aqMBujKbvh4nk+PtT+wYYymzq5h304yxR4
         ABLHCig5vY6g8YxnW03egIhB1uZXtNIqhT0prai5N+wRnqq7uU4whCWzGkc2nhUMUbVY
         a8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FWsObhQJfhrPfHv+Tq8mhfWHC9qobH9HkDFVxkGzwUs=;
        b=IgAwPt809wwecMFv2FahFXtgLE1vcD2EYGgVWSKdhV5kl1F1ZOdI+2GvnoS4hSYPtH
         MypZFg2Dc7vDYLLNcpj+cnacSFMT+u8XzM5vLbUByVcAm5nwZoPsSlhI8Q9OFVL1tzHH
         OFTcrMfh2I7rVCUJLuzbrKJWwr5clDfM02vaO3L6lvpdWvOw/rYFtAdzXqsFYG2zYOEx
         94HebO9ztJ4ufK8TsxO8+sgc19h85FIsdNWk4tlPbqy7rrIOzB8aW4GEmTCSIIwkapSz
         yKJxjvonlF1MsST1g+mWNXj3JQiOP8no6yQtKyQ5fRh1yO/UEUVxfz9IYAKeF4khDz9l
         R+XA==
X-Gm-Message-State: APjAAAU0rTVDFFlPa6CW8hri/ZisnZ7HkTNVQrC20XBSdIo41i92lTlc
        kgNhiXrQhFDU1EZz8NUmIcebDJLT
X-Google-Smtp-Source: APXvYqwLi0uQk5IaVRCaz590GVxs921RLvtncN7Hlz1Y1KDMxQ0x2rQNBi8MvuUkmYle3yfxGghiLA==
X-Received: by 2002:a17:902:9f82:: with SMTP id g2mr39614551plq.63.1567581863994;
        Wed, 04 Sep 2019 00:24:23 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c12sm29188906pfc.22.2019.09.04.00.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 00:24:23 -0700 (PDT)
Date:   Wed, 4 Sep 2019 15:24:16 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Murphy Zhou <jencce.kernel@gmail.com>
Subject: Re: [PATCH v3] xfsprogs: provide a few compatibility typedefs
Message-ID: <20190904072416.r47jpatpmaqy5brc@XZHOUW.usersys.redhat.com>
References: <20190903125845.3117-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903125845.3117-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 02:58:45PM +0200, Christoph Hellwig wrote:
> Add back four typedefs that allow xfsdump to compile against the
> headers from the latests xfsprogs.
> 
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Works fine. Thanks~

> ---
>  include/xfs.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/xfs.h b/include/xfs.h
> index f2f675df..9c03d6bd 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #include <xfs/xfs_types.h>
>  #include <xfs/xfs_fs.h>
>  
> +/*
> + * Backards compatibility for users of this header, now that the kernel
> + * removed these typedefs from xfs_fs.h.
> + */
> +typedef struct xfs_bstat xfs_bstat_t;
> +typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
> +typedef struct xfs_fsop_geom_v1 xfs_fsop_geom_v1_t;
> +typedef struct xfs_inogrp xfs_inogrp_t;
> +
>  #endif	/* __XFS_H__ */
> -- 
> 2.20.1
> 
