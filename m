Return-Path: <SRS0=Htpe=6U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790ECC28CBC
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 07:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 541D020661
	for <linux-xfs@archiver.kernel.org>; Wed,  6 May 2020 07:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5uLfd5P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEFH5H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 May 2020 03:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728280AbgEFH5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 May 2020 03:57:07 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71271C061A0F
        for <linux-xfs@vger.kernel.org>; Wed,  6 May 2020 00:57:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id q124so419237pgq.13
        for <linux-xfs@vger.kernel.org>; Wed, 06 May 2020 00:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yyQeQwGWrfYGuohRd9E2afe2sv8wmCUHxfp98OyfQjA=;
        b=B5uLfd5PvMndE5OpysvxyMxwesVQK0Y+v+7uBwD6AntL/GPCxqNarpYzm4svGkUhoH
         JEoicooZQov2Ow6nPVey1jkmmaOkVSs9I5aje6FZ1VWG9yUatu7zAQzh1SYI/7g5XTmO
         9vZNDRwfZsCe/nRMJhUlIksdeURkvTiq89DLOuLuVXrOtmIRwqIacQuiHL+P6Gys9Tdm
         p+xh5f4VFJ9CVBShMDVIAJHhNkj3GGFCiQkG3/1I/yMXcexJ7yzZ7kl6Gl2hvju+V9oz
         rY6m0OGv4eVpzteposwxUfDBtf1l1WW9FRcok3Pna8x+Hq0+9QIbotNdIwUhioRlPGgn
         ds3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yyQeQwGWrfYGuohRd9E2afe2sv8wmCUHxfp98OyfQjA=;
        b=PHKNGUTZHwzDpgmQ2T1nFa5q9lCLaz0QOItr6voCT3ZjqX74RXE8FRjierpEKu1V6L
         23XevSOdreFbAH2Bzcbm/f+oWdXfNISpMOKo4sRzXXbYdnZycPvtxsvrhxRkOraTaJxn
         dgAZ2fD/5hW9T8RD3kjyBp1fx0PMAK8ZAZ03AiEtuRrL2a6UHg92G73trQZMNJqoOQAl
         a9/vqof4xeNifj00uaLKmhP/XTiSmtBwafHPYE4dD633YeMHJr0RwjrA/1MJnOciN1/+
         nVI6xZYGL5rTkHKNSblX7C8mOLyIghi4FLQ9/AOcUwQjQStiGaohEKc5uUlm8FGm7kKO
         bltw==
X-Gm-Message-State: AGi0PuaVB7aowc1AoDipRmHd6AXQUKY2VLWtOwgPJbHg4NFzTwuDPGcp
        bc/UsJpxvuJDym/GRGLkuDDkf9l2O38=
X-Google-Smtp-Source: APiQypLj/kWCNFLCRxUo/+N53xWvQpLP9RjJJz8DQYzynIO4qc1RTSfgeHIvmAdTCITLyiE3nRu8Xg==
X-Received: by 2002:a65:67c5:: with SMTP id b5mr2461827pgs.62.1588751826904;
        Wed, 06 May 2020 00:57:06 -0700 (PDT)
Received: from garuda.localnet ([122.171.200.101])
        by smtp.gmail.com with ESMTPSA id y10sm1024403pfb.53.2020.05.06.00.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 00:57:06 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/28] xfs: use parallel processing to clear unlinked metadata
Date:   Wed, 06 May 2020 13:27:04 +0530
Message-ID: <1918235.FPgZJyNySB@garuda>
In-Reply-To: <158864121071.182683.2313546760215092713.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia> <158864121071.182683.2313546760215092713.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tuesday 5 May 2020 6:43:30 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Run all the unlinked metadata clearing work in parallel so that we can
> take advantage of higher-performance storage devices.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_unlink_recover.c |   42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
> index fe7fa3d623f2..92ea81969e02 100644
> --- a/fs/xfs/xfs_unlink_recover.c
> +++ b/fs/xfs/xfs_unlink_recover.c
> @@ -21,6 +21,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_icache.h"
> +#include "xfs_pwork.h"
>  
>  /*
>   * This routine performs a transaction to null out a bad inode pointer
> @@ -195,19 +196,54 @@ xlog_recover_process_iunlinked(
>  	return 0;
>  }
>  
> +struct xlog_recover_unlinked {
> +	struct xfs_pwork	pwork;
> +	xfs_agnumber_t		agno;
> +};
> +
> +static int
> +xlog_recover_process_unlinked_ag(
> +	struct xfs_mount		*mp,
> +	struct xfs_pwork		*pwork)
> +{
> +	struct xlog_recover_unlinked	*ru;
> +	int				error = 0;
> +
> +	ru = container_of(pwork, struct xlog_recover_unlinked, pwork);
> +	if (xfs_pwork_want_abort(pwork))
> +		goto out;
> +
> +	error = xlog_recover_process_iunlinked(mp, ru->agno);
> +out:
> +	kmem_free(ru);
> +	return error;
> +}
> +
>  int
>  xlog_recover_process_unlinked(
>  	struct xlog		*log)
>  {
>  	struct xfs_mount	*mp = log->l_mp;
> +	struct xfs_pwork_ctl	pctl;
> +	struct xlog_recover_unlinked *ru;
> +	unsigned int		nr_threads;
>  	xfs_agnumber_t		agno;
>  	int			error;
>  
> +	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
> +	error = xfs_pwork_init(mp, &pctl, xlog_recover_process_unlinked_ag,
> +			"xlog_recover", nr_threads);
> +	if (error)
> +		return error;
> +
>  	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		error = xlog_recover_process_iunlinked(mp, agno);
> -		if (error)
> +		if (xfs_pwork_ctl_want_abort(&pctl))
>  			break;
> +
> +		ru = kmem_zalloc(sizeof(struct xlog_recover_unlinked), 0);
> +		ru->agno = agno;
> +		xfs_pwork_queue(&pctl, &ru->pwork);
>  	}
>  
> -	return error;
> +	return xfs_pwork_destroy(&pctl);
>  }
> 
> 


-- 
chandan



