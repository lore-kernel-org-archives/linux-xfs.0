Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA16C04AA5
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Aug 2022 08:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbiHYINB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Aug 2022 04:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbiHYINA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Aug 2022 04:13:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00C94DF0B
        for <linux-xfs@vger.kernel.org>; Thu, 25 Aug 2022 01:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661415177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+cXqLuCO6uAkCY0LNZwtb8AibmeBDE9lFGZQx4Nl9Tc=;
        b=Hf2SWPURtyOrgiN26XWj20jHfqMg/UguZhkSd9Up/GNtZ+LIHDGe8/bQioJ8g+oPkdkamg
        bXV9k3yH/8GmtqWnOWz1qvMZby8i2lDe0Wd/r5206Rajl6eNwCc7bI/lfg6VI56te+LY0n
        Rk8FxBB7GP6o2czjWRs/TsgnHkkiQK4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-610-b-IsAGPuPKiRCDqLFDiJ_A-1; Thu, 25 Aug 2022 04:12:56 -0400
X-MC-Unique: b-IsAGPuPKiRCDqLFDiJ_A-1
Received: by mail-ej1-f72.google.com with SMTP id gn32-20020a1709070d2000b0073d7a2dbc62so3797067ejc.14
        for <linux-xfs@vger.kernel.org>; Thu, 25 Aug 2022 01:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+cXqLuCO6uAkCY0LNZwtb8AibmeBDE9lFGZQx4Nl9Tc=;
        b=j82NxWuao9uhgP+VDNZyehfZvO3sBPSYHKkpu+TIGaPYTjQAE8VRjgDP3Boc9+FTzm
         /YNvQOZ5m/kftf+S8RfihMCQjYZLsfB79aVZfjibIa7h0zrvEULEVZxSNR56zpCX7x8U
         1+FH5tFrBk60mbreERQoQ/IYa3dtSkxlHfszVzl9HeuhRKYM92uMa9xbx7jq4WG6Jp50
         YI7VMmpaqyUWZXZ5omzBKdKJdpN2xjXxstIrMd6UmNKKj4Y/QWmj0/tvm7DjxvDqkUAm
         kZ4lcDJRsnqrYTrp/qrcelo1FlKcsusTymGxaPNj8mxAbDL9hz+zalcNNg7c47eroAfd
         obSg==
X-Gm-Message-State: ACgBeo2Qic+wiwL9LrnDTxb6FOE+je5fAwPuyIGd2uq6nyYg6MsgXFy9
        GDhd4DBGZiDEQkWBDYcQ2JN1G3RXkKdWfNh4hSd3bsMOl/b5LHhDKFkXd65x4A+SxoPF/1grly2
        EJFpVVN7ssVzH4BiLGDgq
X-Received: by 2002:a17:907:86aa:b0:73d:670d:3f8f with SMTP id qa42-20020a17090786aa00b0073d670d3f8fmr1612203ejc.723.1661415174947;
        Thu, 25 Aug 2022 01:12:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4BojPWh7zPdSAwloQFw5t0HoyVkTALkYPth8jgfqvrKKieyksHoKm8+jIbeKpFIYLQI3pjHA==
X-Received: by 2002:a17:907:86aa:b0:73d:670d:3f8f with SMTP id qa42-20020a17090786aa00b0073d670d3f8fmr1612190ejc.723.1661415174659;
        Thu, 25 Aug 2022 01:12:54 -0700 (PDT)
Received: from andromeda (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id lb20-20020a170907785400b007300d771a98sm2127171ejc.175.2022.08.25.01.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:12:54 -0700 (PDT)
Date:   Thu, 25 Aug 2022 10:12:52 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsdump: remove BMV_IF_NO_DMAPI_READ flag
Message-ID: <20220825081252.z66dkyzvjcirqa6d@andromeda>
References: <20210331162617.17604-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331162617.17604-2-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 06:26:17PM +0200, Anthony Iliopoulos wrote:
> Use of the flag has had no effect since kernel commit 288699fecaff
> ("xfs: drop dmapi hooks") which removed all dmapi related code, so we
> can remove it.
> 
> Given that there are no other flags that need to be specified for the
> bmap call, convert once instance of it from getbmapx to plain getbmap.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
> changes since v1:
>  - convert getbmapx to getbmap
> 
>  dump/content.c | 1 -
>  dump/inomap.c  | 7 +++----
>  2 files changed, 3 insertions(+), 5 deletions(-)

With my follow-up patch applied on top of this:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/dump/content.c b/dump/content.c
> index 75b79220daf6..a40b47101a12 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -4287,7 +4287,6 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
>  	gcp->eg_bmap[0].bmv_offset = 0;
>  	gcp->eg_bmap[0].bmv_length = -1;
>  	gcp->eg_bmap[0].bmv_count = BMAP_LEN;
> -	gcp->eg_bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
>  	gcp->eg_nextbmapp = &gcp->eg_bmap[1];
>  	gcp->eg_endbmapp = &gcp->eg_bmap[1];
>  	gcp->eg_bmapix = 0;
> diff --git a/dump/inomap.c b/dump/inomap.c
> index 85d61c353cf0..f3200be471e0 100644
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -1627,7 +1627,7 @@ static off64_t
>  quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
>  {
>  	int fd;
> -	getbmapx_t bmap[BMAP_LEN];
> +	struct getbmap bmap[BMAP_LEN];
>  	off64_t offset;
>  	off64_t offset_next;
>  	off64_t qty_accum;
> @@ -1647,7 +1647,6 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
>  	bmap[0].bmv_offset = 0;
>  	bmap[0].bmv_length = -1;
>  	bmap[0].bmv_count = BMAP_LEN;
> -	bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
>  	bmap[0].bmv_entries = -1;
>  	fd = jdm_open(fshandlep, statp, O_RDONLY);
>  	if (fd < 0) {
> @@ -1662,7 +1661,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
>  		int eix;
>  		int rval;
>  
> -		rval = ioctl(fd, XFS_IOC_GETBMAPX, bmap);
> +		rval = ioctl(fd, XFS_IOC_GETBMAP, bmap);
>  		if (rval) {
>  			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
>  			      "could not read extent map for ino %llu: %s\n"),
> @@ -1679,7 +1678,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
>  		}
>  
>  		for (eix = 1; eix <= bmap[0].bmv_entries; eix++) {
> -			getbmapx_t *bmapp = &bmap[eix];
> +			struct getbmap *bmapp = &bmap[eix];
>  			off64_t qty_new;
>  			if (bmapp->bmv_block == -1) {
>  				continue; /* hole */
> -- 
> 2.31.0
> 

-- 
Carlos

