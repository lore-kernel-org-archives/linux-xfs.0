Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61ADC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 09:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A7E6134F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 09:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbhG0JiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 05:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbhG0JiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 05:38:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969F3C061757
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 02:38:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso3316768pjb.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 02:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Q3WlFru59QRmEgbtE56aF6kAyATI6mRVlvo/eAEa8LY=;
        b=DlyHO6KoJZL5X7+Wwh0O81mmvTQ/u/SClDvPiK5bWc6PKjbNbSsVDuOdlwq3W70vA+
         Uj2iciGEhpwvH1RDYycZkni40qP38UQaSwcc9Rog01z/tQlHfuPz9IfcQ3ef4tKajcis
         Wq+7WalhZ0PYCiI46Lqrj0QzipRSXMo51f9bw7r+vd5yWOOOOIoOvr01o8XBdqonb0uw
         qihPYvnakL0gZeqhsVbJcEXYc2qlU5K9jWHaLNvRQ2ObgUcNrNFHNhDsP+DcEGGmZ612
         o97TV5sjPDoVoJ8nalg22cH5suEsvRuo1Bg2H/AEvJF6EuIAPC1pNeTC8CTShn/lXRt6
         oKDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Q3WlFru59QRmEgbtE56aF6kAyATI6mRVlvo/eAEa8LY=;
        b=b/znKFZqeY8Oa/6shXT+BSf7ZTbI3FaDZ76J9dQqYQHBn81Fi2WZaxdzg7vldA5gMp
         KnOsHNbWbTT+5GJDOkEdUqs3mqY817gaD2avqwOKkhRDsXVL0f0WCaJC0lr+uFSNsvdw
         /ZSvSFSyJkchv4oah5VB1TXfX2vn2K4N4+iH1u3+6WungLV8r1PhSotMZkBDwKR45l0J
         Kab8RA4RwVC1gjiTaHCUEid0dFBl1nmb/PMNdhcaQh8CxaQBKdfmYEUtxBMyfki4UUfZ
         CP2ZBKvYRbyVZze1IdmsjkYRVpnvuAR5I++v92FqYtFFUtX+xmqfKnNn/e1w511AUz5K
         ufKQ==
X-Gm-Message-State: AOAM530y1DWYuHim0+I90gQn1Q82CI32hIeq3eODgfyO2ah/goKdWkYo
        nXBUd56cK3owoCHsQ9v6k2rlkahkG/Q=
X-Google-Smtp-Source: ABdhPJxhl52h9W6o3RgCFu4UqLXfaeivbZkzEG83ptNtQRqsku+u+BR7mF3GEGb8YdbRdykF3/L6Wg==
X-Received: by 2002:a17:90b:957:: with SMTP id dw23mr3512577pjb.123.1627378687008;
        Tue, 27 Jul 2021 02:38:07 -0700 (PDT)
Received: from garuda ([122.171.185.191])
        by smtp.gmail.com with ESMTPSA id q5sm2390886pjo.7.2021.07.27.02.38.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Jul 2021 02:38:06 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-10-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 09/16] xfs: Implement attr logging and replay
In-reply-to: <20210727062053.11129-10-allison.henderson@oracle.com>
Date:   Tue, 27 Jul 2021 15:08:04 +0530
Message-ID: <87czr4f66b.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> This patch adds the needed routines to create, log and recover logged
> extended attribute intents.
>
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   1 +
>  fs/xfs/libxfs/xfs_defer.h  |   1 +
>  fs/xfs/libxfs/xfs_format.h |  10 +-
>  fs/xfs/xfs_attr_item.c     | 377 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 388 insertions(+), 1 deletion(-)
>
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index eff4a12..e9caff7 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>  };
>
>  static void
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 0ed9dfa..72a5789 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_RMAP,
>  	XFS_DEFER_OPS_TYPE_FREE,
>  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> +	XFS_DEFER_OPS_TYPE_ATTR,
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
>
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 3a4da111..93c1263 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>
> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>  static inline bool
>  xfs_sb_has_incompat_log_feature(
> @@ -590,6 +592,12 @@ static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
>  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
>  }
>
> +static inline bool xfs_sb_version_hasdelattr(struct xfs_sb *sbp)
> +{
> +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);

The above should have been sbp->sb_features_log_incompat instead of
sbp->sb_features_incompat.

I found this when trying to understand sb_features_log_incompat's behaviour. I
will do a thorough review soon.

--
chandan
