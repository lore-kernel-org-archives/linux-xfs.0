Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F5AEB64D9
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Jul 2023 22:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjGFWyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 18:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjGFWye (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2023 18:54:34 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2FC2108
        for <linux-xfs@vger.kernel.org>; Thu,  6 Jul 2023 15:54:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b8b4748fe4so6847195ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jul 2023 15:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1688684054; x=1691276054;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4txZ4IF2hjvPhQ6PshLCDaZ6l+0KG8ACDp/swWBKtTA=;
        b=UukUQC9tR8kXfMW4vgI0YqpdeffVOzFNFvHBkk6up7aFmWqnyUXkOWcaTNSVorhiS6
         D9FXY0b8jpwf16DL0sl17pVNZZD00CfU7GA4i1AgKAybagwYysOYyEkN6jc8pahWFRmL
         OvxhtTlGdWOlfpniD1zZevkuKLvYHFmLYb1QACplpdq6S6zRBff4wcyI5e1i56mVmoih
         zaO82TZUJ1EhqGGbfKmBmZI6a8WCW6AIKUpGyc9groAMNCn9uITTj/hldQ0EIzxQY//0
         giIjwRG59Zf/QwqWDgMSvzIRLVHdhpQdRHAjE1cc2VKDHSusMBVdllAjBizlpiHzEjCx
         biSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688684054; x=1691276054;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4txZ4IF2hjvPhQ6PshLCDaZ6l+0KG8ACDp/swWBKtTA=;
        b=jIIQxGvLeIaTa8gY+ODwk/S/rvBHgap7ypwluUkAGuUf2Vv/9OfwdeOfUDqA6qUq9x
         qNwLX+ZjOZdtu5dMDEobC+rhwrtQWwarFnhpxin/lTas+2WeMq9PN94Bfx3v0eNEPgmT
         rsQwjOc8ZjK0NL7J86QvV5apdZBWq/7iXYxgxwd2NcNUY1SwYV7PgEQR9sCR6Isos57M
         QX5+0vKYNxDp0sW3XO73dhBalr4iBDfsFaAjtFZYC9HYoTq/F/37HMk9yi1mk4EWX3LH
         /MXktTVIj3qbcK0V4sEuMztCqIno026DsAcTXuivzuQGxfTcRIapfYn/2demIF4+ElXv
         jgzw==
X-Gm-Message-State: ABy/qLaLahMYx0PgDNNjW4h1qoaL0tB7qyzESwu/D+F8xsG/5XANWedl
        TyXOxHQKp32QXqCR8iKV7dLNr/wyZ12k9IsW3Ck=
X-Google-Smtp-Source: APBJJlEczEeryukfzKs3lqYdWAP69VxTKhn9w5X4IBEa6DNUOeLhhHjXNLX+35c2GQzWUvW0mqUmYA==
X-Received: by 2002:a17:903:455:b0:1b8:95a2:d87e with SMTP id iw21-20020a170903045500b001b895a2d87emr2528269plb.2.1688684054039;
        Thu, 06 Jul 2023 15:54:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-214-123.pa.vic.optusnet.com.au. [49.186.214.123])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090274c400b001b025aba9edsm1872739plt.220.2023.07.06.15.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 15:54:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qHXrW-002ypZ-1A;
        Fri, 07 Jul 2023 08:54:10 +1000
Date:   Fri, 7 Jul 2023 08:54:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix uninit warning in xfs_growfs_data
Message-ID: <ZKdGEmx7T4fw4S7E@dread.disaster.area>
References: <20230706022630.GA11476@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230706022630.GA11476@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 05, 2023 at 07:26:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Quiet down this gcc warning:
> 
> fs/xfs/xfs_fsops.c: In function ‘xfs_growfs_data’:
> fs/xfs/xfs_fsops.c:219:21: error: ‘lastag_extended’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>   219 |                 if (lastag_extended) {
>       |                     ^~~~~~~~~~~~~~~
> fs/xfs/xfs_fsops.c:100:33: note: ‘lastag_extended’ was declared here
>   100 |         bool                    lastag_extended;
>       |                                 ^~~~~~~~~~~~~~~
> 
> By setting its value explicitly.  From code analysis I don't think this
> is a real problem, but I have better things to do than analyse this
> closely.

Huh. What compiler is complaining about that?


> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_fsops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 65473bc52c7d..96edc87bf030 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -97,7 +97,7 @@ xfs_growfs_data_private(
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
>  	int64_t			delta;
> -	bool			lastag_extended;
> +	bool			lastag_extended = false;
>  	xfs_agnumber_t		oagcount;
>  	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};

Looks good,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
