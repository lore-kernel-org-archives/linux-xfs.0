Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76BC9C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 11:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 516AD206D4
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 11:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkVbDyHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgFVLBV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 07:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgFVLBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 07:01:20 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD6AC061794
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 04:01:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b7so6536898pju.0
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 04:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E9XZHYnZpj7exE5cgUt/TBbECmz+FXbqeVT+HAzUQbc=;
        b=WkVbDyHyL3B9PV8wPgrwFuBUTENKmZ1gklcTZlRiPwxlb66pz2bhrCdT7hnFTeQzj/
         E7qeYStIxlPMKV34/jmXa3ocZn0xGpSZe9pBA4tOrkFU5s5rfVKs7uKS9TalvKYhOn0L
         JuzxjmsI3CjJ69ys8Vbei9acpm9r9BiD56dQmVi05yElv+9HTgCqOt5t353Z4De0m8Ys
         ncRiJsbi8rPE3g1kP+QDAsvhChNDzNI7x1BNXhApA3FaZp2D4kzb/NwMZicNBMqw2EM7
         /C6IU5aJeKEimw2KTiaWq0bREwUfrXGs010CaxXqhIoHan4IoMVrNQ0g3xvtDN0Zj2xO
         o9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E9XZHYnZpj7exE5cgUt/TBbECmz+FXbqeVT+HAzUQbc=;
        b=g2jfBd+oK3LTEixzxAgjaHzlJnJixbsjiOB5k6pWwm1RyGPKGnaXkQ8WcwbHXja0Vy
         8fwSarDZnPwidwLv3kL1DOByukakj2+IQlYaSShNi20pZEkCittdrey42CT/oBECrreD
         WwP8Lx5y5C18vc1byXg3UMpq2b6DSvcxdZS+EHJP99dw2jn7YpljLaczdoSXv3A+BaAZ
         8RQg5QVB4RAwLg/3oDEwi7r1jBIC1YlL3EzUfMw8judeKRS8U3GR51Fnti7/RIDFx4Mh
         VMyT+FswKRJHSZSWlSVJCEQuaqgE6zO6eLWe7eE4SmozzfEw7+HvjuhmOW5XEc4EzOnZ
         H7pQ==
X-Gm-Message-State: AOAM5313uzT/UwRKbI4P7byxD+EKQzn46pl8BgnaUrtOAVhqgKBFFJFA
        qXH2JdwrTv5q9dKrVZ+vRpsLt/Ao
X-Google-Smtp-Source: ABdhPJzxnS1A1GqRP50ofz2o2k1VbOy8gpSIXEs4aw7c7/pZSaBM7puufK9NKHD5G1tM9WgMl8TMGQ==
X-Received: by 2002:a17:90a:bb95:: with SMTP id v21mr14085905pjr.140.1592823679777;
        Mon, 22 Jun 2020 04:01:19 -0700 (PDT)
Received: from garuda.localnet ([122.179.34.42])
        by smtp.gmail.com with ESMTPSA id h20sm13540501pfo.105.2020.06.22.04.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 04:01:19 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/15] xfs: cleanup xfs_fill_fsxattr
Date:   Mon, 22 Jun 2020 16:31:17 +0530
Message-ID: <1824421.L11i3aHg1m@garuda>
In-Reply-To: <20200620071102.462554-10-hch@lst.de>
References: <20200620071102.462554-1-hch@lst.de> <20200620071102.462554-10-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Saturday 20 June 2020 12:40:56 PM IST Christoph Hellwig wrote:
> Add a local xfs_mount variable, and use the XFS_FSB_TO_B helper.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 60544dd0f875b8..cabc86ed6756bc 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1104,15 +1104,14 @@ xfs_fill_fsxattr(
>  	bool			attr,
>  	struct fsxattr		*fa)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
> -	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
> -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
> -		fa->fsx_cowextsize =
> -			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> -	}
> +	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> +	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> +		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> 


-- 
chandan



