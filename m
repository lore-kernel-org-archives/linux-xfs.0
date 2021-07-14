Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CB7C07E9A
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 11:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C671B61374
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 11:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhGNLOf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 07:14:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239236AbhGNLOf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 07:14:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626261103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ShDyfqu1SP+9DmcTRCtAwCgTKpF0tA/vGrl6Ux26IQ4=;
        b=H3e1x0qQ5X++4LVsaK/fCIIOhcfq1aV9QDji1wGtpHkYGIVxfuqpM/yabVj1VjaoaHJm/I
        b/NiAg9KkcSN9Kxss+3/LOXU6F0T1BnH8mQI4kUj+fngF6E6x5uJi1fgVgEf764evyorXo
        1K33nSuQLgvyUIsNBssQNFJpGnW8Tx8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-t7Bfs0BSOgO2VQ6uEw9W4Q-1; Wed, 14 Jul 2021 07:11:42 -0400
X-MC-Unique: t7Bfs0BSOgO2VQ6uEw9W4Q-1
Received: by mail-wm1-f71.google.com with SMTP id b26-20020a7bc25a0000b0290218757e2783so639644wmj.7
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 04:11:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ShDyfqu1SP+9DmcTRCtAwCgTKpF0tA/vGrl6Ux26IQ4=;
        b=JEAWKba7ZFiNhoNLaT+9xQpyYj1B6KsVVa6sJ+WTMbK7rjZG4NX49U/6FGj7DVypJY
         q29mGGKxfH15u+/rZff+AnDg21sITW5ozsAEaRM57vqOARAGhdZTFT/5j5rHsi5LX9ch
         GMQHBTvujG0RrmvQpC52gBBgnTSBiIHZaoFjVdlSSmE8vrUugOwQ0XO6I6paXIrAEk/j
         1Ad0w5YzbUKocZ7FJhvkrKY8EASkapyKAUoa9AHcrm8xKDC4kHGtzbQHhpmX4/7Is60j
         CQgUU6Q6G6tHOCzZdP+XTu/cpkLlmoYFai+tty1FKH/gejyyIiAPrr88h9V2EDRz6U+l
         iLbw==
X-Gm-Message-State: AOAM531LxupYL5pzGOh4COjS3za09chaJiSrAWQV2904s2SOYABdUWjP
        Szs5ZK8mMJXxO8AgyrTXDUm+ZC/IW6Q6D9OPzPRuxuTBHGKr4MQvqaQweG61CLSRIGx7Wjqz1Mh
        UDIaQKBvBHKhlMDFzUpbu
X-Received: by 2002:a5d:46cc:: with SMTP id g12mr11840536wrs.136.1626261100710;
        Wed, 14 Jul 2021 04:11:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJykZZupVc07QpvK87qaeThmg1730XxOfN2Izkn0HjG8d3B5L1OE8sQ6vAmeLyJRoRbiuPnqNQ==
X-Received: by 2002:a5d:46cc:: with SMTP id g12mr11840511wrs.136.1626261100529;
        Wed, 14 Jul 2021 04:11:40 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id d8sm2280298wra.41.2021.07.14.04.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 04:11:40 -0700 (PDT)
Date:   Wed, 14 Jul 2021 13:11:38 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remove the flags argument to xfs_qm_dquot_walk
Message-ID: <20210714111138.4vd6s4ukncx7zb6s@omega.lan>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20210712111426.83004-1-hch@lst.de>
 <20210712111426.83004-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111426.83004-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:14:25PM +0200, Christoph Hellwig wrote:
> We always purge all dquots now, so drop the argument.
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 580b9dba21122b..2b34273d0405e7 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -187,15 +187,11 @@ xfs_qm_dqpurge(
>   */
>  static void
>  xfs_qm_dqpurge_all(
> -	struct xfs_mount	*mp,
> -	uint			flags)
> +	struct xfs_mount	*mp)
>  {
> -	if (flags & XFS_QMOPT_UQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
> -	if (flags & XFS_QMOPT_GQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
> -	if (flags & XFS_QMOPT_PQUOTA)
> -		xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
> +	xfs_qm_dquot_walk(mp, XFS_DQTYPE_USER, xfs_qm_dqpurge, NULL);
> +	xfs_qm_dquot_walk(mp, XFS_DQTYPE_GROUP, xfs_qm_dqpurge, NULL);
> +	xfs_qm_dquot_walk(mp, XFS_DQTYPE_PROJ, xfs_qm_dqpurge, NULL);
>  }
>  
>  /*
> @@ -206,7 +202,7 @@ xfs_qm_unmount(
>  	struct xfs_mount	*mp)
>  {
>  	if (mp->m_quotainfo) {
> -		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
> +		xfs_qm_dqpurge_all(mp);
>  		xfs_qm_destroy_quotainfo(mp);
>  	}
>  }
> @@ -1359,7 +1355,7 @@ xfs_qm_quotacheck(
>  	 * at this point (because we intentionally didn't in dqget_noattach).
>  	 */
>  	if (error) {
> -		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
> +		xfs_qm_dqpurge_all(mp);
>  		goto error_return;
>  	}
>  
> -- 
> 2.30.2
> 

-- 
Carlos

