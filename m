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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0474BC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 07:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E223660527
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 07:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhG2H5F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 03:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbhG2H5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Jul 2021 03:57:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7500C061757
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 00:57:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j1so9109959pjv.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Jul 2021 00:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=V+F5ZCf+Gg1Q7jp1N3GBLBGifRXpvww4uwR0h2x5pNQ=;
        b=K0j/h0XlL0WFXDaqJL3b8mmJvgfijqG5CvnuTd98ILbR4nw/Juxd8c2CpupQOZFcZi
         Y/8jYT+bsKbrWOIkzYg+OLuOcwNoCdJwhv1UKawHssiWQ8LNShyOmVmlYvXdFq7vQyht
         7VPA64WlJtcGSTzWIJB2xl0mS2p/+heaYPACYZscFmQCWu/UlJIt8xA2/OAKGyiWcx8/
         oqV1r9NPM0koTY3RtcWgk5aaIzGeiaIrevqY36rxLddd+l61+SJRPjL8ZTliIfsTLRtP
         nRqBtfShgXE0VwxQPyMia3Pp777svPmU+dfzdd33mypfgsMREg31xsI/PEfFCk8ULbco
         //Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=V+F5ZCf+Gg1Q7jp1N3GBLBGifRXpvww4uwR0h2x5pNQ=;
        b=Z89MBedr4dUjdgpN4P98jU/fD8WtJ0x7mRw8kEJ775tmMQTr5L5pqbrGgEUNPZ/6Jx
         QnljkfBUg1F4QvEx4ggtZURDBiKwVgKGLHORsKpjd7aSnnDof0OmtewBxO3yklYGw5mm
         CF93cINbgIZJX2Y/hh2J+ODpSKieYt2QUyp0vOqPJpdLhLQ0ZzU1OvC4GY7Q347weCZy
         okplcwL9O7Aum7I0Mu1kzyKMqw1D8PRVzdYrs4WJ0PiyOBEMpTy4K/8IZqrC41uP2XmV
         1m8BQwCzzNGtZhvhjFPF54daUDeo4IpJVARG0B2YP0E5myQ593PB1SK5O0MCuhSXe312
         f50Q==
X-Gm-Message-State: AOAM530iT96nEomBYGOd09MDJUb5yrpILD4tafRyqIUDGifInXRPp2k0
        Vb4GD6CIBSHD+Rcku29B1cRH7O/fmV+/Xg==
X-Google-Smtp-Source: ABdhPJwoO5NFlYGikWz+7rhZ6IB9cM5M7YMvJ3L45Uw/DTIMISHfwqZkSgQwFAXmlkg0ZHfjPAtR4A==
X-Received: by 2002:a17:90a:5b17:: with SMTP id o23mr3825594pji.25.1627545422291;
        Thu, 29 Jul 2021 00:57:02 -0700 (PDT)
Received: from garuda ([122.167.157.25])
        by smtp.gmail.com with ESMTPSA id i25sm2516965pfo.20.2021.07.29.00.57.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 29 Jul 2021 00:57:01 -0700 (PDT)
References: <20210727062053.11129-1-allison.henderson@oracle.com> <20210727062053.11129-7-allison.henderson@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v22 06/16] xfs: Rename __xfs_attr_rmtval_remove
In-reply-to: <20210727062053.11129-7-allison.henderson@oracle.com>
Date:   Thu, 29 Jul 2021 13:26:59 +0530
Message-ID: <875ywtft84.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 27 Jul 2021 at 11:50, Allison Henderson wrote:
> Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
> to xfs_attr_rmtval_remove
>

That was simple enough.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 6 +++---
>  fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
>  fs/xfs/libxfs/xfs_attr_remote.h | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b0c6c62..5ff0320 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -502,7 +502,7 @@ xfs_attr_set_iter(
>  		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>  		dac->dela_state = XFS_DAS_RM_LBLK;
>  		if (args->rmtblkno) {
> -			error = __xfs_attr_rmtval_remove(dac);
> +			error = xfs_attr_rmtval_remove(dac);
>  			if (error == -EAGAIN)
>  				trace_xfs_attr_set_iter_return(
>  					dac->dela_state, args->dp);
> @@ -615,7 +615,7 @@ xfs_attr_set_iter(
>  		/* Set state in case xfs_attr_rmtval_remove returns -EAGAIN */
>  		dac->dela_state = XFS_DAS_RM_NBLK;
>  		if (args->rmtblkno) {
> -			error = __xfs_attr_rmtval_remove(dac);
> +			error = xfs_attr_rmtval_remove(dac);
>  			if (error == -EAGAIN)
>  				trace_xfs_attr_set_iter_return(
>  					dac->dela_state, args->dp);
> @@ -1447,7 +1447,7 @@ xfs_attr_remove_iter(
>  			 * May return -EAGAIN. Roll and repeat until all remote
>  			 * blocks are removed.
>  			 */
> -			error = __xfs_attr_rmtval_remove(dac);
> +			error = xfs_attr_rmtval_remove(dac);
>  			if (error == -EAGAIN) {
>  				trace_xfs_attr_remove_iter_return(
>  						dac->dela_state, args->dp);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 70f880d..1669043 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -672,7 +672,7 @@ xfs_attr_rmtval_invalidate(
>   * routine until it returns something other than -EAGAIN.
>   */
>  int
> -__xfs_attr_rmtval_remove(
> +xfs_attr_rmtval_remove(
>  	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 61b85b9..d72eff3 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -12,7 +12,7 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> -int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>  int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>  int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);


-- 
chandan
