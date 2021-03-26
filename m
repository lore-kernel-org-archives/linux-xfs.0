Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA6EC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 15:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2DC761A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 15:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhCZPes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 11:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:53040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230167AbhCZPeW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 11:34:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5030E61A1E;
        Fri, 26 Mar 2021 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616772862;
        bh=3ZINZ4PnmWWjeQ59heo94ow6RHwoi+OcwfMV8PFlnFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qgAsGnmmcqhP5dkmv3FE/p9JpUaSpcrN1/B0RV/O+VIj1MP2rpBryd39dNONH+2kT
         eSkxrGbLU+5NRfSBWP9bKEDKdtEfwQ/EW7q9cU48kCv/SnLDTjva8dGeffNztj0/bO
         yjezSvfDqTscn9gv24mXBGbw4Vb7cYA3mLxa/DWweYzCauyD7L8Tb0gsSY/8w6HtLB
         +Eq3wx/Pb1osfSqIr27Ob1BLBeEu29jT38hU7EbbFnJbl2R2+lr5HVriSeDxRIgYvd
         faHkrJHlBy0tmYL9Y8r7aBE37M7gMkK7+8x0wgxB2qrPTmbg+r4NIrJSRIQkVFd7if
         0FjAHBs8TGNcg==
Date:   Fri, 26 Mar 2021 08:34:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdump: remove BMV_IF_NO_DMAPI_READ flag
Message-ID: <20210326153422.GU4090233@magnolia>
References: <20210326125321.28047-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326125321.28047-2-ailiop@suse.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 01:53:20PM +0100, Anthony Iliopoulos wrote:
> Use of the flag has had no effect since kernel commit 288699fecaff
> ("xfs: drop dmapi hooks") which removed all dmapi related code, so
> we can remove it.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> ---
>  dump/content.c | 1 -
>  dump/inomap.c  | 1 -
>  2 files changed, 2 deletions(-)
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
> index 85d61c353cf0..1333ca5bb8a8 100644
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -1647,7 +1647,6 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
>  	bmap[0].bmv_offset = 0;
>  	bmap[0].bmv_length = -1;
>  	bmap[0].bmv_count = BMAP_LEN;
> -	bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;

I don't think bmap[0] is guaranteed to be initialized at this point,
so deleting this statement leaves bmv_iflags with random stack junk.

--D

>  	bmap[0].bmv_entries = -1;
>  	fd = jdm_open(fshandlep, statp, O_RDONLY);
>  	if (fd < 0) {
> -- 
> 2.31.0
> 
