Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F152C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 18:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiJYSxD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 14:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiJYSwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 14:52:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3AA1211DD
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:52:35 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b11so5610815pjp.2
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 11:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vf9i6qmjV40bGMrlCTotNuCYCmEzW27qZZCCeAP6cDA=;
        b=KmjMHLDNAca/vKivMJ6ecRgxggEBUU7BM315AqLPRFQISuDfHGgTcv2UREtR/FcTUw
         Uw2DAmPempLOrvC7ZHotrOLCjKV2x/TSuVHHQNreJe6BAwxwQVn7O6ck/dh9c7IeUm1Z
         eQShbCP8aVbCnql5NEx6D7fkIWFLdAF4j8AZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vf9i6qmjV40bGMrlCTotNuCYCmEzW27qZZCCeAP6cDA=;
        b=BfAAGhOIffRmxHRpYOY8Yj1yvSkf4A86BUNfidJjlcCys8rdVgV3JzYSUBLdhF4ayn
         yJRVetdLuYe2fzohDSC9/VBJt42+C2sG8C/sD2pGqueeCLx4e4NIJN02clQnqWwKFu9a
         Je2digdp5OpJlJGXh7ij8n/FjYrYukIfSgdn2bK+KsnwOy67J5nXgQEoVqZG1xCOaKyD
         k8X84kT3V0ZWDIX3qsouP+C0Quq0lt93xBHxVt80qy2FDBN1/JoJ80f0GI5k16z7DVOy
         4OHJATXSsfMPO8gZnJwJBUazCMq+mmMSxNOIjtFrCmG3Y80uqTQI73XFUjNof0AyPe9s
         CMFg==
X-Gm-Message-State: ACrzQf0gZhDucFDT90EjeuJhtjIbumVgYATZ5u8z5GlUT/4ws2I9hVR1
        HdX18vpLi6BmiL40cKvxEIKgEw==
X-Google-Smtp-Source: AMsMyM6MvDZH+KKXVVT0om8ZSoY5P+srChQ6CW5HlDQNGLG981uYhtfwvifbkJqYWVSwJPHF0vOSFA==
X-Received: by 2002:a17:903:41cc:b0:186:b756:a5f0 with SMTP id u12-20020a17090341cc00b00186b756a5f0mr7959900ple.132.1666723954524;
        Tue, 25 Oct 2022 11:52:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090a2b8900b0020d24ea4400sm5668779pjd.38.2022.10.25.11.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 11:52:33 -0700 (PDT)
Date:   Tue, 25 Oct 2022 11:52:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/6] xfs: fix memcpy fortify errors in BUI log format
 copying
Message-ID: <202210251151.547458E05@keescook>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664716290.2688790.11246233896801948595.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664716290.2688790.11246233896801948595.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:32:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
> memcpy.  Unfortunately, it doesn't handle flex arrays correctly:
> 
> ------------[ cut here ]------------
> memcpy: detected field-spanning write (size 48) of single field "dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)
> 
> Fix this by refactoring the xfs_bui_copy_format function to handle the
> copying of the head and the flex array members separately.  While we're
> at it, fix a minor validation deficiency in the recovery function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_item.c |   46 ++++++++++++++++++++++------------------------
>  fs/xfs/xfs_ondisk.h    |    5 +++++
>  2 files changed, 27 insertions(+), 24 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 51f66e982484..a1da6205252b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -608,28 +608,18 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
>  	.iop_relog	= xfs_bui_item_relog,
>  };
>  
> -/*
> - * Copy an BUI format buffer from the given buf, and into the destination
> - * BUI format structure.  The BUI/BUD items were designed not to need any
> - * special alignment handling.
> - */
> -static int
> +static inline void
>  xfs_bui_copy_format(
> -	struct xfs_log_iovec		*buf,
> -	struct xfs_bui_log_format	*dst_bui_fmt)
> +	struct xfs_bui_log_format	*dst,
> +	const struct xfs_bui_log_format	*src)
>  {
> -	struct xfs_bui_log_format	*src_bui_fmt;
> -	uint				len;
> +	unsigned int			i;
>  
> -	src_bui_fmt = buf->i_addr;
> -	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
> +	memcpy(dst, src, offsetof(struct xfs_bui_log_format, bui_extents));

I think this would work:

	*dst = *src;

>  
> -	if (buf->i_len == len) {
> -		memcpy(dst_bui_fmt, src_bui_fmt, len);
> -		return 0;
> -	}
> -	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
> -	return -EFSCORRUPTED;
> +	for (i = 0; i < src->bui_nextents; i++)
> +		memcpy(&dst->bui_extents[i], &src->bui_extents[i],
> +				sizeof(struct xfs_map_extent));

Same here:

		dst->bui_extents[i] = src->bui_extents[i];

No reason to bring memcpy into this at all. :)


-- 
Kees Cook
