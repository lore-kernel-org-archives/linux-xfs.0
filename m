Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56732 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750927AbdAPOQ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Jan 2017 09:16:57 -0500
Received: from smtp.corp.redhat.com (int-mx16.intmail.prod.int.phx2.redhat.com [10.5.11.28])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF2CE68CB
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 14:16:57 +0000 (UTC)
Date: Mon, 16 Jan 2017 08:16:54 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 20/22] mkfs: move uuid empty string test to getstr()
Message-ID: <20170116141654.GF13191@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-21-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481117249-21273-21-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 02:27:27PM +0100, Jan Tulak wrote:
> No need for this separate check, when we can use getstr() for opts.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
>  mkfs/xfs_mkfs.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 9e726f7..9c1ad11 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2560,11 +2560,10 @@ main(
>  						value, &opts[OPT_M], M_FINOBT);
>  					break;
>  				case M_UUID:
> -					if (!value || *value == '\0')
> -						reqval('m', subopts, M_UUID);
> +					opts[OPT_M].subopt_params[M_UUID].value.s =
> +						getstr(value, &opts[OPT_M], M_UUID);
>  					if (platform_uuid_parse(value, &uuid))
>  						illegal(optarg, "m uuid");
> -					opts[OPT_M].subopt_params[M_UUID].value.s = value;
>  					break;
>  				case M_RMAPBT:
>  					sb_feat.rmapbt = getnum(
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
