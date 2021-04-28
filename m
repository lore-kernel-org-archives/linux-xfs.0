Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC737C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 18:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BFFA61447
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 18:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbhD1SFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 14:05:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243400AbhD1SFY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 14:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619633079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rZtiAWBHQmlkFXmHoUSv+mteyIcHUJe0sGH0UK7yFt4=;
        b=KUD2AsB/xL0i1ZFJeFtAbDlD2R8BZj50HnRiRJE+3BbDcQ8ObcsFqrVYZZSY9i5JJHror1
        buE9WbDX30jlI2CQlS11CPdp8aaaaG76xWp23qBfSTZTkKvJ1nKRHvCWj4HORBk0YFkc0a
        iPOgc47DcDmvfbZdPfliRTogcB5lO+I=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-VVENAl7RORenr1up4WNXkg-1; Wed, 28 Apr 2021 14:04:27 -0400
X-MC-Unique: VVENAl7RORenr1up4WNXkg-1
Received: by mail-qt1-f199.google.com with SMTP id y10-20020a05622a004ab029019d4ad3437cso25853647qtw.12
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 11:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rZtiAWBHQmlkFXmHoUSv+mteyIcHUJe0sGH0UK7yFt4=;
        b=Glx9hBM3OC5/XhpVbmjclsE+i2XFuJqgn3+ZoXSPNCQOVW2taSpLp8Fq7vHOeOgCMW
         WIaCZdsc73TgOaXHy1Ifeod7cEUqtlnvDUSYJgLJI1F1E/YzlUUgRrBNTNilsjc9Lstc
         1yxMgEuyH1Hm/cZXj5jzSiIxV9Ee9f3n0a1BU+ZoStKXkbu+SNbeL7abBtsS+GkpR02h
         3PeWagEjKu4guH1sEHSWcC99/TL+1JQwdjmAOmBqxM85MuTPROtlDg1NAOOnyjNyCYUQ
         vpIa0HyqSwuWQPPYYhwUu7R2MYzxLBM1RlGt/aTbU+zEPjp6R9VkR2YT6V93HO2CvNDK
         ogOw==
X-Gm-Message-State: AOAM53111oHHr6WuDuPylzSzTcvAM+cWs0GY3QI99TgEVWSBGcqSPvIF
        GIqeIrjmLtuEhYIl3bkeyzZQ6D+oZca90j2JeoRE5EexIe49u80Pi+9XARDrtV3dmNhm9VNAvYm
        1ZHwAdaTZ0b+Sk4g3FAAW
X-Received: by 2002:a37:61c1:: with SMTP id v184mr30277365qkb.466.1619633067535;
        Wed, 28 Apr 2021 11:04:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxUiouegHY4bsE3/QNp7SwurCaSEGDzlLe0GbT6DDiGfdbHdr57yVpqzMhmTQkmlOFjLfo+yA==
X-Received: by 2002:a37:61c1:: with SMTP id v184mr30277348qkb.466.1619633067333;
        Wed, 28 Apr 2021 11:04:27 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id r125sm367969qkf.24.2021.04.28.11.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 11:04:27 -0700 (PDT)
Date:   Wed, 28 Apr 2021 14:04:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] common/rc: relax xfs swapfile support checks
Message-ID: <YImjqdwBfnhhIJ84@bfoster>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
 <161958298729.3452499.11374046947109958849.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958298729.3452499.11374046947109958849.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In commit 725feeff, I forgot that xfs has *not* always supported all
> swap file configurations -- the bmap swapfile activation prior to the
> introduction of iomap_swapfile_activate did not permit the use of
> unwritten extents in the swap file.  Therefore, kick xfs out of the
> always-supported list.
> 
> Fixes: 725feeff ("common/rc: swapon should not fail for given FS in _require_scratch_swapfile()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/rc |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/rc b/common/rc
> index 429cc24d..7882355a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2494,10 +2494,10 @@ _require_scratch_swapfile()
>  	statx_attr="$($XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT/swap 2>/dev/null | grep 'stat.attributes = ' | awk '{print $3}')"
>  	test "$((statx_attr & 0x200000))" -gt 0 && _notrun "swapfiles not supported on DAX"
>  
> -	# ext* and xfs have supported all variants of swap files since their
> +	# ext* has supported all variants of swap files since their
>  	# introduction, so swapon should not fail.
>  	case "$FSTYP" in
> -	ext2|ext3|ext4|xfs)
> +	ext2|ext3|ext4)
>  		if ! swapon "$SCRATCH_MNT/swap" >/dev/null 2>&1; then
>  			_scratch_unmount
>  			_fail "swapon failed for $FSTYP"
> 

