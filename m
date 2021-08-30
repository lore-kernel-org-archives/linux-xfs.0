Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 245CFC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 12:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 057706023F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 Aug 2021 12:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhH3MFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 Aug 2021 08:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbhH3MEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Aug 2021 08:04:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F854C0613D9
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 05:04:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id z24-20020a17090acb1800b0018e87a24300so9850552pjt.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Aug 2021 05:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=O0USj/g+T20MKp8LcQsqnA/bqdZpN1vb1k0rh3FkHmE=;
        b=nscjXF93W/w5VRWpd3eVmKZ9PQnbUNW7zSCFRcD4Z+lkuBynMxv/T8PO8Cq8kEMK+V
         qj3Jf3lqYGOYmKU0SRAJyvZMM81HQHFRrtNKIGoMpcJiCv/Nz7YGadlw57VYk+fYpJWh
         nvT4myVQ0Kqfy2rau/hSaaGk3w8ltO/qG8jRkL/y+YM69QLJCFZIfvogqy0A+XRsH2lK
         ixpnXSCT1R5HjXgNkwO2bp9IK+x587sur76WPq4hT+Cy4mM+mTmlfufomBIHG8fiZep0
         DBZRPnU0z5Gh7hlR/l/Ehhiek7CuNgm5Nea8rIPEHcwZYL30y0BRGqWbBTVciTTwL2AH
         KOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=O0USj/g+T20MKp8LcQsqnA/bqdZpN1vb1k0rh3FkHmE=;
        b=dZ5jwL6IbZBm/j792X3KKOhfoOqoHBatoXHTWBTowWjmPBQlm2riur1gmHq0V7//rE
         lDn9N5Tf5k5f5cnsnhx88fR6im3BWP2tpohTKcIoqqmdpjWT9mOJcdCqWpS1MwOjF/fm
         XCmJmjEdoQRon2J/lLogn8pHzrunaF4GBnaYwKZIOF8xa6fcSzlLT6NTKg+kehVdIaQ/
         tqNzS+txIwd8aaEdUX0VyonrCG+Hn7T0321XQVXEDty0YWyjatfzTxDNrza2ePCq1evE
         buSdv0fLjxbCJZBHAby1kzAm2zYS8/grWofHYPiyfcgx/bM5i9qFIifvLAl18bzVzbWc
         2fjw==
X-Gm-Message-State: AOAM533++tvbFocObDNUVNui0phBQjTXB07mTx+iYTrfSmg68f4I8BAy
        tLWqN64ynwVLC60FQsjw/yJakSBFwZo=
X-Google-Smtp-Source: ABdhPJy0YAk48ecCd+JhrofSShjRd3lI9D8vnqHtrTU2nznp0nWCG/99CVfxQtCDZ4BWsMKwqvyIOw==
X-Received: by 2002:a17:902:a586:b0:132:6a9c:f8d9 with SMTP id az6-20020a170902a58600b001326a9cf8d9mr21559816plb.3.1630325039790;
        Mon, 30 Aug 2021 05:03:59 -0700 (PDT)
Received: from garuda ([122.171.149.36])
        by smtp.gmail.com with ESMTPSA id 202sm14785810pfw.150.2021.08.30.05.03.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Aug 2021 05:03:59 -0700 (PDT)
References: <20210824224434.968720-1-allison.henderson@oracle.com>
 <20210824224434.968720-10-allison.henderson@oracle.com>
User-agent: mu4e 1.4.15; emacs 27.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v24 09/11] xfs: Add larp debug option
In-reply-to: <20210824224434.968720-10-allison.henderson@oracle.com>
Message-ID: <875yvn9m1g.fsf@debian-BULLSEYE-live-builder-AMD64>
Date:   Mon, 30 Aug 2021 17:33:55 +0530
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Aug 2021 at 04:14, Allison Henderson wrote:
> This patch adds a mount option to enable log attribute replay. Eventually

s/mount option/debug option//

> this can be removed when delayed attrs becomes permanent.

The rest looks good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.h |  2 +-
>  fs/xfs/xfs_globals.c     |  1 +
>  fs/xfs/xfs_sysctl.h      |  1 +
>  fs/xfs/xfs_sysfs.c       | 24 ++++++++++++++++++++++++
>  4 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index efb7ac4fc41c..492762541174 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -30,7 +30,7 @@ struct xfs_attr_list_context;
>  
>  static inline bool xfs_has_larp(struct xfs_mount *mp)
>  {
> -	return false;
> +	return xfs_globals.larp;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
> index f62fa652c2fd..4d0a98f920ca 100644
> --- a/fs/xfs/xfs_globals.c
> +++ b/fs/xfs/xfs_globals.c
> @@ -41,5 +41,6 @@ struct xfs_globals xfs_globals = {
>  #endif
>  #ifdef DEBUG
>  	.pwork_threads		=	-1,	/* automatic thread detection */
> +	.larp			=	false,	/* log attribute replay */
>  #endif
>  };
> diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
> index 7692e76ead33..f78ad6b10ea5 100644
> --- a/fs/xfs/xfs_sysctl.h
> +++ b/fs/xfs/xfs_sysctl.h
> @@ -83,6 +83,7 @@ extern xfs_param_t	xfs_params;
>  struct xfs_globals {
>  #ifdef DEBUG
>  	int	pwork_threads;		/* parallel workqueue threads */
> +	bool	larp;			/* log attribute replay */
>  #endif
>  	int	log_recovery_delay;	/* log recovery delay (secs) */
>  	int	mount_delay;		/* mount setup delay (secs) */
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index 18dc5eca6c04..74180e05e8ed 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -227,6 +227,29 @@ pwork_threads_show(
>  	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
>  }
>  XFS_SYSFS_ATTR_RW(pwork_threads);
> +
> +static ssize_t
> +larp_store(
> +	struct kobject	*kobject,
> +	const char	*buf,
> +	size_t		count)
> +{
> +	ssize_t		ret;
> +
> +	ret = kstrtobool(buf, &xfs_globals.larp);
> +	if (ret < 0)
> +		return ret;
> +	return count;
> +}
> +
> +STATIC ssize_t
> +larp_show(
> +	struct kobject	*kobject,
> +	char		*buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.larp);
> +}
> +XFS_SYSFS_ATTR_RW(larp);
>  #endif /* DEBUG */
>  
>  static struct attribute *xfs_dbg_attrs[] = {
> @@ -236,6 +259,7 @@ static struct attribute *xfs_dbg_attrs[] = {
>  	ATTR_LIST(always_cow),
>  #ifdef DEBUG
>  	ATTR_LIST(pwork_threads),
> +	ATTR_LIST(larp),
>  #endif
>  	NULL,
>  };


-- 
chandan
