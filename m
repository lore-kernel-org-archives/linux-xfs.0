Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19E6C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 13:02:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbiHKNCK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiHKNCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 09:02:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B68554F69E
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 06:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660222927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FJdeEhDHWFr1dPxUpOHMNDdpxPpgUciIwe5FLalH2qk=;
        b=C1fC5nf13B2XtJkDolq4Ow0BZYNTfRzpxUIqQeh92zdXfJ+LwQfh0QC8zp+hRB/NCsd0E8
        2s8AYNZ3mm1b4aSuxJGR06FsXGa3ap84qP6gvnKobKXyHPHO9DxSRlObWYUp19cXuxUuCe
        jgaYRlOV35osnKgpmooOgt0CVizgJXM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-168-qNEhmLsXOP-7mE_GB6ovqw-1; Thu, 11 Aug 2022 09:02:05 -0400
X-MC-Unique: qNEhmLsXOP-7mE_GB6ovqw-1
Received: by mail-ed1-f72.google.com with SMTP id w17-20020a056402269100b0043da2189b71so10659035edd.6
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 06:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=FJdeEhDHWFr1dPxUpOHMNDdpxPpgUciIwe5FLalH2qk=;
        b=WMM4hNel7IdM/t+sKv9Khfc4z4Se6Jw+anJpUl1O9PyrVaPlUJbkZ/cML2x9Iws9CE
         7EaGxtjDBOt6I1Gq+yRa07Rg8enspMGb453FzRI8qpPpBg/mA2x4sLM1iPbytdEnTd6h
         Cfw8rYEKdVgs7htjxpulFUivz7HLdnVeMkcnks1WQYa/a58wUD2wId6oKeKqLeEV+8Ew
         TR8uX1c/QzZHmLrH0VGu3SkJelrcKc3Is1ZlaAUXGf1pOKNi73rZkVYml31NrRSNOQpg
         xTODJdCRCIYxvwtRQQ1NGgXsYra4hMtloLW9vsfPYF5gTRhTaXkvVf+B9i5TikeNjMQH
         6AsA==
X-Gm-Message-State: ACgBeo2kNX/jRU48XBzTbYCi+70eBpdltVAaB0kbCWmRuGJb9Jzc035r
        IeXlnVqTg28cPN4vubR2una+QLYIaG2AtQuQkGrU5LNRHlabCQ1p9HfKUdNc7YUt0iPN3A2M6kM
        iBJrSRgO+Yu9cNenMwpnf
X-Received: by 2002:a05:6402:194e:b0:442:c81c:ca25 with SMTP id f14-20020a056402194e00b00442c81cca25mr6933522edz.137.1660222924310;
        Thu, 11 Aug 2022 06:02:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5iw/QjdgrjadGt7oZSIklzIdS5GRz6KjlHAX+riTPK8HR2GWDY9qyovi0NIWJXlqUJP8WttQ==
X-Received: by 2002:a05:6402:194e:b0:442:c81c:ca25 with SMTP id f14-20020a056402194e00b00442c81cca25mr6933506edz.137.1660222924017;
        Thu, 11 Aug 2022 06:02:04 -0700 (PDT)
Received: from orion (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id f12-20020a17090631cc00b0072ee9790894sm3454532ejf.197.2022.08.11.06.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 06:02:03 -0700 (PDT)
Date:   Thu, 11 Aug 2022 15:02:01 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfsdump: remove BMV_IF_NO_DMAPI_READ flag
Message-ID: <20220811130201.c52a6vfejtzb2cw6@orion>
References: <20210331162617.17604-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331162617.17604-2-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Reviving this old patch since changes have been pushed to xfsprogs.

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

This seems ok, but I still think this should be properly initialized here, like:

struct getbmap bmap[BMAP_LEN] = {0};


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

