Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DC2C47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 12:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E452C20746
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 12:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nz/V0xm6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgEKMjj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 08:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726934AbgEKMjj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 08:39:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25710C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 05:39:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q24so7721114pjd.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 05:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K2OKyUIik2ALR4QW4m8CZOyz7tS4gM2s4jw5OtbhgnY=;
        b=nz/V0xm6exvI4kNx53/3xp/CpTG7wTYwvme7QMRrf7OJzo63lUzZFYlU4FFt2izzXL
         vhb0Pjc/XFmPTm+4DJ3dH8x+WRsbdlUdX7FLjJ5phupXJIGVIhHR5zuYKrLmwDMoZ7sR
         0NefxCdQttNcTe0Q/EHuzHHTsF2ShfD/t3cIv2vGwCH9zTKIhDzdO0EbpC6pVzsGa1tW
         SGdaKAUzp6jUwBjSJklBdyhr7Dzo05H2pX2ICLXnieHlV9NZRaL7K69cBZgFu1/MxrU6
         MrM11z/RwpCI4kfO0h4U1MWx13FDYm+4r9var2G9e32Q2pftSCSGA3Ij847dgNuHGvLJ
         zQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2OKyUIik2ALR4QW4m8CZOyz7tS4gM2s4jw5OtbhgnY=;
        b=S6pXtVi3IxHn3h7paubBuy1/JsbH8pF+MXP1Zxg8X2YzqMQDkejO9rRHpa4Z9NzNwV
         lC93jpnR7qaYy07+f7ncCKBwJzv8oBpoXqtn+/ALr1TG5nJu1CiP/R2/Ho1MpE3PEvvk
         m/aYaWpc2Gm55i2MaE6XPeusUmgREFbub0gKaf201IL483AWMc2e+DNC9rr0541IO6bz
         Nx+SEsMjk6ULsjoTaBng2tAWSyOYbbieLAs3WBbTmwkfU3eKFifUyUOk6Dtcf2WfAKFY
         pTLTRIUQa4SqWyO83tGsF0SNmgLIBX1e4Ff1UDyiPlAlpm9v3iMecJQua2XUZrML7iGz
         UZwg==
X-Gm-Message-State: AGi0PuaXKzKYkhzwnFaVr3cRiaygnhSupyTuIsn5XcsYG2RKN3VZmwMa
        wpIHx8L6LIFcDuvSoxIXPzzI10qDw4o=
X-Google-Smtp-Source: APiQypJvUjWESDR4eAZo+o0rp4g36uqtiSTqVJ4SVW6FPpQhXpifF7FsctiL5qLaFSv+hECaDyjlpg==
X-Received: by 2002:a17:90b:3887:: with SMTP id mu7mr21313534pjb.168.1589200778690;
        Mon, 11 May 2020 05:39:38 -0700 (PDT)
Received: from garuda.localnet ([122.171.220.131])
        by smtp.gmail.com with ESMTPSA id o9sm10343885pje.47.2020.05.11.05.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 05:39:38 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: remove the XFS_DFORK_Q macro
Date:   Mon, 11 May 2020 18:09:36 +0530
Message-ID: <3471910.rezcp8hkpX@garuda>
In-Reply-To: <20200510072404.986627-3-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-3-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 10 May 2020 12:54:00 PM IST Christoph Hellwig wrote:
> Just checking di_forkoff directly is a little easier to follow.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h    | 5 ++---
>  fs/xfs/libxfs/xfs_inode_buf.c | 6 +++---
>  2 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 045556e78ee2c..3cc352000b8a1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -964,13 +964,12 @@ enum xfs_dinode_fmt {
>  /*
>   * Inode data & attribute fork sizes, per inode.
>   */
> -#define XFS_DFORK_Q(dip)		((dip)->di_forkoff != 0)
>  #define XFS_DFORK_BOFF(dip)		((int)((dip)->di_forkoff << 3))
>  
>  #define XFS_DFORK_DSIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
> +	((dip)->di_forkoff ? XFS_DFORK_BOFF(dip) : XFS_LITINO(mp))
>  #define XFS_DFORK_ASIZE(dip,mp) \
> -	(XFS_DFORK_Q(dip) ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
> +	((dip)->di_forkoff ? XFS_LITINO(mp) - XFS_DFORK_BOFF(dip) : 0)
>  #define XFS_DFORK_SIZE(dip,mp,w) \
>  	((w) == XFS_DATA_FORK ? \
>  		XFS_DFORK_DSIZE(dip, mp) : \
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 05f939adea944..5547bbb3cf945 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -265,7 +265,7 @@ xfs_inode_from_disk(
>  	error = xfs_iformat_data_fork(ip, from);
>  	if (error)
>  		return error;
> -	if (XFS_DFORK_Q(from)) {
> +	if (from->di_forkoff) {
>  		error = xfs_iformat_attr_fork(ip, from);
>  		if (error)
>  			goto out_destroy_data_fork;
> @@ -435,7 +435,7 @@ xfs_dinode_verify_forkoff(
>  	struct xfs_dinode	*dip,
>  	struct xfs_mount	*mp)
>  {
> -	if (!XFS_DFORK_Q(dip))
> +	if (!dip->di_forkoff)
>  		return NULL;
>  
>  	switch (dip->di_format)  {
> @@ -538,7 +538,7 @@ xfs_dinode_verify(
>  		return __this_address;
>  	}
>  
> -	if (XFS_DFORK_Q(dip)) {
> +	if (dip->di_forkoff) {
>  		fa = xfs_dinode_verify_fork(dip, mp, XFS_ATTR_FORK);
>  		if (fa)
>  			return fa;
> 


-- 
chandan



