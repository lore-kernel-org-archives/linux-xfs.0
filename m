Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E315BC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 12:13:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0CF46104F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 12:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbhHLMNe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 08:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbhHLMNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 08:13:33 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C665C061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 05:13:08 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n17so6521990ioc.7
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 05:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bJ1JKJd6emAleN7J5eXHmFpDRuYcicelI5RpsjkyxuY=;
        b=RU5hQpp7+3ABW/AFvfIxLo1c/fI8niye6h7ekM3mhzjTtXzSKrCfi3NDdmjV1DuFen
         AtQrMIJ7PUrFwmrZaAEtflaNiXVfxkKunAVekAwpNdNqzfpmu95NPOrVh5rxnhPmgZvT
         TB6REacYv0dVbcWKH5Ay9inZP1/Hm0quXu8a8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bJ1JKJd6emAleN7J5eXHmFpDRuYcicelI5RpsjkyxuY=;
        b=XUXYWOzQLkDODfE/uIKq3uPc6BfHECvw46q1sOSyyowHPzHM5xQOLCEQYcuhQ4hSdn
         MJhPcitUxFnP2CHrcHfE3dn19xLyR776NNg4xlz8YrmSeCm7bivjk1iuZ/+hX29bxreM
         lHVtqMwIRFncryom9eCkX/hG8canRgr3mZ7Z/I8l5ugqaNcKDrbSHcKD+1+e/WtSJHLq
         +l4c2DNyMXy2mEwIf5COAAXUpDEcGA/RUOiP3qYvwIpLjLOuzb5/mL+S4HbX7nPMJfX2
         L9EdGb236rcFtvIA7lnwP88gOdxq1ckZpZZXE5Mn0JljW90xnnDsbCU/VKgzlHV6TszK
         T15w==
X-Gm-Message-State: AOAM532HffvICdAuBFBBT7aWOBjyHoqBCDZe58501gh0sWuQ5JtfvsNT
        7preZb+EAbW4Mlwu9HOiCkgtY8ug8qcrTw==
X-Google-Smtp-Source: ABdhPJwsXXnGQCG/3c2ghMLHM7JNkoMRW4PbQ7wNlVFJ0KHtQkaTC6rRZenDrODAm+QVYeDPQNLDFA==
X-Received: by 2002:a05:6602:1848:: with SMTP id d8mr2775335ioi.72.1628770386101;
        Thu, 12 Aug 2021 05:13:06 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w14sm1196736ioa.47.2021.08.12.05.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 05:13:05 -0700 (PDT)
Subject: Re: [PATCH 2/3] xfs: remove the xfs_dsb_t typedef
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-3-hch@lst.de>
From:   Alex Elder <elder@ieee.org>
Message-ID: <651ac76d-4562-d772-94d0-f2b667c0adf6@ieee.org>
Date:   Thu, 12 Aug 2021 07:13:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210812084343.27934-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/21 3:43 AM, Christoph Hellwig wrote:
> Remove the few leftover instances of the xfs_dinode_t typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Fix the description:  s/xfs_dinode_t/xfs_dsb_t/

> ---
>  fs/xfs/libxfs/xfs_format.h | 5 ++---
>  fs/xfs/libxfs/xfs_sb.c     | 4 ++--
>  fs/xfs/xfs_trans.c         | 8 ++++----
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f601049b65f465..5819c25c1478d0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -184,7 +184,7 @@ typedef struct xfs_sb {
>   * Superblock - on disk version.  Must match the in core version above.
>   * Must be padded to 64 bit alignment.
>   */
> -typedef struct xfs_dsb {
> +struct xfs_dsb {
>  	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
>  	__be32		sb_blocksize;	/* logical block size, bytes */
>  	__be64		sb_dblocks;	/* number of data blocks */
> @@ -263,8 +263,7 @@ typedef struct xfs_dsb {
>  	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
>  
>  	/* must be padded to 64 bit alignment */
> -} xfs_dsb_t;
> -
> +};
>  
>  /*
>   * Misc. Flags - warning - these will be cleared by xfs_repair unless
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 04f5386446dbb0..56d241cb17ee1b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -391,7 +391,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  static void
>  __xfs_sb_from_disk(
>  	struct xfs_sb	*to,
> -	xfs_dsb_t	*from,
> +	struct xfs_dsb	*from,
>  	bool		convert_xquota)
>  {
>  	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
> @@ -466,7 +466,7 @@ __xfs_sb_from_disk(
>  void
>  xfs_sb_from_disk(
>  	struct xfs_sb	*to,
> -	xfs_dsb_t	*from)
> +	struct xfs_dsb	*from)
>  {
>  	__xfs_sb_from_disk(to, from, true);
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 83abaa21961605..7f4f431bc256ce 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -477,7 +477,7 @@ STATIC void
>  xfs_trans_apply_sb_deltas(
>  	xfs_trans_t	*tp)
>  {
> -	xfs_dsb_t	*sbp;
> +	struct xfs_dsb	*sbp;
>  	struct xfs_buf	*bp;
>  	int		whole = 0;
>  
> @@ -541,14 +541,14 @@ xfs_trans_apply_sb_deltas(
>  		/*
>  		 * Log the whole thing, the fields are noncontiguous.
>  		 */
> -		xfs_trans_log_buf(tp, bp, 0, sizeof(xfs_dsb_t) - 1);
> +		xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
>  	else
>  		/*
>  		 * Since all the modifiable fields are contiguous, we
>  		 * can get away with this.
>  		 */
> -		xfs_trans_log_buf(tp, bp, offsetof(xfs_dsb_t, sb_icount),
> -				  offsetof(xfs_dsb_t, sb_frextents) +
> +		xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
> +				  offsetof(struct xfs_dsb, sb_frextents) +
>  				  sizeof(sbp->sb_frextents) - 1);
>  }
>  
> 

