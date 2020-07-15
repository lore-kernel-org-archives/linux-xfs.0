Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75FAAC433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 12:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5107F20657
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 12:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NVvLooml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgGOMu0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 08:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgGOMu0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 08:50:26 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2266FC061755
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 05:50:26 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k71so3025514pje.0
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 05:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IQ6JNC5nceQtFROMyZhLB1RAcFGXCBIDgexWUomP2LQ=;
        b=NVvLooml+8SdfBkYEqL6SmsMXs5ZvFdbX6hSHB7/l542Yk68SlAWVxLjh3hof+Tt24
         cLT4BjwhSTzSEZMSdL2/HKQhG63SSw2w1y2320ddat++iP6Lbo07Y/KLMjVqdmNueod7
         HmGMi4owrHJuRgjn0K5amN4k6aRko/Ee+v8sKmL4/Vk/AUb8MUfeUW3XbVZAJfYU4dwb
         6o80T17Hf0A+P5//HrSodNaaNPi7W5EfnRcXCdFxS5UdoaAnIpczFtLe33ekplvAFME/
         VCqSOMrLM74QbuG9NnXLXcU76I/c2iccG/DaVcqfu9JjQkqRDXHwdHKMIng5Yeewx3L/
         JXsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IQ6JNC5nceQtFROMyZhLB1RAcFGXCBIDgexWUomP2LQ=;
        b=IySgQEqobbuUG3V+azOU3NrRu/2YPGdNyna9uGj79oSLLwXZRFNzTK0v750l2TrpiV
         QqM1zMbU2wBaV0wt0w8TXVjoRLCpQNZ8MYhcwn12QGa9D6X9eKMxYUMfq+rJM12kUfC3
         cq2KUJ8i49g6DNU6L0N2pSljGNt53GIfNsbcnZjaE2koF0C6TJUucEfA9G6r/OstDa15
         OQvWMICf1NzDELq4Da94nK0FgjtCOrujdyshbNaDOz/dYKufSA0b9rNFGGw2jKihYPeb
         3TNJPNqd0D8HakfFjnxkbuVDfxqFwvohWScdUuwazrRs9FDa4jpkXjIkk4GcmQ32HPMq
         JeGw==
X-Gm-Message-State: AOAM533l/PZ1GhXMZd+6IaXfx8iBiA9Dw62XurWg1rH7scB3TBPVSPRE
        dTzB/M4IewR4CPqgaxELkFZZg3F6
X-Google-Smtp-Source: ABdhPJzPxThfi/EwqQCPGGUc5bQupVxQq7jtlVUlVx7l9AQOlwKt2nT4XAwClcisPzg+ax6M76FXcg==
X-Received: by 2002:a17:90a:e511:: with SMTP id t17mr10559605pjy.87.1594817425718;
        Wed, 15 Jul 2020 05:50:25 -0700 (PDT)
Received: from garuda.localnet ([122.171.186.26])
        by smtp.gmail.com with ESMTPSA id d25sm2331746pgn.2.2020.07.15.05.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:50:25 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/26] xfs: move the flags argument of xfs_qm_scall_trunc_qfiles to XFS_QMOPT_*
Date:   Wed, 15 Jul 2020 18:20:11 +0530
Message-ID: <4091307.QZrKpWE3vW@garuda>
In-Reply-To: <159477785867.3263162.14797330963625412377.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia> <159477785867.3263162.14797330963625412377.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wednesday 15 July 2020 7:20:58 AM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since xfs_qm_scall_trunc_qfiles can take a bitset of quota types that we
> want to truncate, change the flags argument to take XFS_QMOPT_[UGP}QUOTA
> so that the next patch can start to deprecate XFS_DQ_*.
>

The changes look good to me.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm_syscalls.c |    8 ++++----
>  fs/xfs/xfs_quotaops.c    |    6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 7effd7a28136..35fad348e3a2 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -322,23 +322,23 @@ xfs_qm_scall_trunc_qfiles(
>  	int		error = -EINVAL;
>  
>  	if (!xfs_sb_version_hasquota(&mp->m_sb) || flags == 0 ||
> -	    (flags & ~XFS_DQ_ALLTYPES)) {
> +	    (flags & ~XFS_QMOPT_QUOTALL)) {
>  		xfs_debug(mp, "%s: flags=%x m_qflags=%x",
>  			__func__, flags, mp->m_qflags);
>  		return -EINVAL;
>  	}
>  
> -	if (flags & XFS_DQ_USER) {
> +	if (flags & XFS_QMOPT_UQUOTA) {
>  		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_uquotino);
>  		if (error)
>  			return error;
>  	}
> -	if (flags & XFS_DQ_GROUP) {
> +	if (flags & XFS_QMOPT_GQUOTA) {
>  		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_gquotino);
>  		if (error)
>  			return error;
>  	}
> -	if (flags & XFS_DQ_PROJ)
> +	if (flags & XFS_QMOPT_PQUOTA)
>  		error = xfs_qm_scall_trunc_qfile(mp, mp->m_sb.sb_pquotino);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
> index bf809b77a316..0868e6ee2219 100644
> --- a/fs/xfs/xfs_quotaops.c
> +++ b/fs/xfs/xfs_quotaops.c
> @@ -205,11 +205,11 @@ xfs_fs_rm_xquota(
>  		return -EINVAL;
>  
>  	if (uflags & FS_USER_QUOTA)
> -		flags |= XFS_DQ_USER;
> +		flags |= XFS_QMOPT_UQUOTA;
>  	if (uflags & FS_GROUP_QUOTA)
> -		flags |= XFS_DQ_GROUP;
> +		flags |= XFS_QMOPT_GQUOTA;
>  	if (uflags & FS_PROJ_QUOTA)
> -		flags |= XFS_DQ_PROJ;
> +		flags |= XFS_QMOPT_PQUOTA;
>  
>  	return xfs_qm_scall_trunc_qfiles(mp, flags);
>  }
> 
> 


-- 
chandan



