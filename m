Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A15AC4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 10:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 570C160F55
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 10:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhGZJkn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:40:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231820AbhGZJkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 05:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627294871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TZgkrPVgXp+x38cLtE7Lg78F3TT5cKyr80sThtj8s84=;
        b=Gj7aLAZf2gm9pA0OSEH5UUnb5VT5V2KEGdqEu2tBfbZVo/lmx6I4cCsmq3scK/3hiLF7os
        xJKOP6eXqskavHd7xa0Eyeo+yYxcvNrg9FK6cfCDO+K2xehVNQwbUDOAxYr6I/jxvlH0yi
        V+3/jXzcOiJmuVOcqi1VhpwvNnkD6Sg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-7dlUYjrsPAOeFTFx3IiuBA-1; Mon, 26 Jul 2021 06:21:08 -0400
X-MC-Unique: 7dlUYjrsPAOeFTFx3IiuBA-1
Received: by mail-wr1-f71.google.com with SMTP id z10-20020adfdf8a0000b02901536d17cd63so1827033wrl.21
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 03:21:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=TZgkrPVgXp+x38cLtE7Lg78F3TT5cKyr80sThtj8s84=;
        b=Cd7WSqnFT75x9CgxB25no/dmLmePymoZZpf1PwtnjQARrc5wrdIGA6XIzD42c96lKf
         qG84HAfbiBnli7Z+gLpqUg6Dji33/Vlcq0hhwlJy1UwbgntQvLofD3NyH5GeUi/c1Bv9
         YLPfM0/arPkH0+7meO3fb6/ZL2U0w7UqlNTTCxj32JMYEBQFYbu3s0Qho+udMEE0m2jA
         olab0UALD6D7hPFHvi8WhzM8bhQHm9kgCkJZkrKpG2fIOTONNiIU81Sqw102RPtdEpPE
         9kBvYrXct8GWWt3Ld7BT2YEEkoPmSsLi/gL0e8ieBT/kRp4AznZ3JRhXWPzFnwcHYFxC
         ryWA==
X-Gm-Message-State: AOAM531Vht1nCaFLIjUJ6RhvFbCTwC/TYO1Rx75ri/QqDTGAQ4Iwjqaf
        TbsN7UaLUfsIFAZl2ep5QCt1ZK+LXCtn7dEjvbvt7dKbNxt0AkU3DACUOrOjJBYEoTFR3HYaRTU
        tx9U7k0RcY23LhwwahKT7
X-Received: by 2002:adf:de11:: with SMTP id b17mr14505826wrm.403.1627294866923;
        Mon, 26 Jul 2021 03:21:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8cPBmCsZa8y3Zy++ZxQwwKtDvTrSVdKP3ZNs3v31hWoE4dWgr4CFyjZ+fi7CYOGJJWqgh/Q==
X-Received: by 2002:adf:de11:: with SMTP id b17mr14505802wrm.403.1627294866732;
        Mon, 26 Jul 2021 03:21:06 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id e5sm4629957wrr.36.2021.07.26.03.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 03:21:06 -0700 (PDT)
Date:   Mon, 26 Jul 2021 12:21:04 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] xfs: drop experimental warnings for bigtime and
 inobtcount
Message-ID: <20210726102104.jyzaojxtqjzpqgql@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20210707002313.GG11588@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707002313.GG11588@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 06, 2021 at 05:23:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These two features were merged a year ago, userspace tooling have been
> merged, and no serious errors have been reported by the developers.
> Drop the experimental tag to encourage wider testing.

And grub already supports it :) So.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_super.c |    8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index cbc1f0157bcd..321e3590c6fe 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1539,10 +1539,6 @@ xfs_fs_fill_super(
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
>  		sb->s_flags |= SB_I_VERSION;
>  
> -	if (xfs_sb_version_hasbigtime(&mp->m_sb))
> -		xfs_warn(mp,
> - "EXPERIMENTAL big timestamp feature in use. Use at your own risk!");
> -
>  	if (mp->m_flags & XFS_MOUNT_DAX_ALWAYS) {
>  		bool rtdev_is_dax = false, datadev_is_dax;
>  
> @@ -1598,10 +1594,6 @@ xfs_fs_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> -	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> -		xfs_warn(mp,
> - "EXPERIMENTAL inode btree counters feature in use. Use at your own risk!");
> -
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> 

-- 
Carlos

