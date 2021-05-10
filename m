Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841F7C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 555B761042
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhEJNwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 09:52:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231782AbhEJNnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 09:43:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ksCNE7UcXnH6+uD+ghE6r1WllObuPK/5sBtTKJQycsc=;
        b=iKWAX6RrhF3/Yl/8ZG3zRhJ1ML/AfitQu4J0Ro8Q9V4bbtjb+9QM4Vu6r97TAmcyAMoCUY
        AJBxfBVq/FOPIde0Y1PJb/gG1SN99l43r7qbMAoxtrLjP9CwYluCxxF+fYc1RNV/FjO3Zs
        SV9vOh/Vu7CCj2O/wZLF+58FI2EjISM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-FG2GKg36M_uSmr9S29dzuQ-1; Mon, 10 May 2021 09:42:00 -0400
X-MC-Unique: FG2GKg36M_uSmr9S29dzuQ-1
Received: by mail-qk1-f200.google.com with SMTP id l6-20020a3770060000b02902fa5329f2b4so1077955qkc.18
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 06:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ksCNE7UcXnH6+uD+ghE6r1WllObuPK/5sBtTKJQycsc=;
        b=kzatU5RPuhH1PttWpH/EhSppVmZ+7axs605Hhwu88bCzcTn7CDwep7T64qNABQl7Nv
         Vc3vbvHMrnjxXj02v0tcKcCoJWZyxOBXnRPUg4/0tVrfH/gt9AGgQ6Wct8Zozh1XmF2m
         FW0xPvYv6avwcohHzf5YAlWOqn3JRAaDT7ITdquTmM+a2TCn2yYaYsBDaXnQKZrPWgSB
         nFXPuWfn+kb1ywpUx+iCsMecBqMg2dxZaSKI3uhNFDQBg3NCxDgTl1Lm10ZBXgJySXUK
         Etz+OuzocOk1Mqelieq5n10L91vW+kdFOHoc6K4aiMyG6rq3CMCvcuGb/DkoihR/MowS
         D8Hw==
X-Gm-Message-State: AOAM532gvyvZtk6a3EsG+m4kXlMLY/1/Bpw6TuknmKKyRl9TiH2Q1ljn
        DGohhbLIevkBFpW81F9/hRYS4LcghlFG/NcG8w8TVfzjqBREBERLleBP0z5tCqlrbGas9gbgBov
        UpsSWbdTsHQRHhTXfpvOs
X-Received: by 2002:ac8:6688:: with SMTP id d8mr6153938qtp.282.1620654120320;
        Mon, 10 May 2021 06:42:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywOnO5j5m0sA2SUh2GSE3KxjV2hdyzdJ0zP5u8IxfNT+uNvMfq3I12ty84tg/MASiuP1Enig==
X-Received: by 2002:ac8:6688:: with SMTP id d8mr6153919qtp.282.1620654120119;
        Mon, 10 May 2021 06:42:00 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id y13sm11401665qkj.84.2021.05.10.06.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:41:59 -0700 (PDT)
Date:   Mon, 10 May 2021 09:41:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/22] xfs: convert secondary superblock walk to use
 perags
Message-ID: <YJk4Jk3jX0zYhAbi@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up the last external manual AG walk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index cbcfce8cebf1..7d4c238540d4 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -25,6 +25,7 @@
>  #include "xfs_refcount_btree.h"
>  #include "xfs_da_format.h"
>  #include "xfs_health.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> @@ -856,17 +857,18 @@ int
>  xfs_update_secondary_sbs(
>  	struct xfs_mount	*mp)
>  {
> -	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno = 1;
>  	int			saved_error = 0;
>  	int			error = 0;
>  	LIST_HEAD		(buffer_list);
>  
>  	/* update secondary superblocks. */
> -	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> +	for_each_perag_from(mp, agno, pag) {
>  		struct xfs_buf		*bp;
>  
>  		error = xfs_buf_get(mp->m_ddev_targp,
> -				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
>  				 XFS_FSS_TO_BB(mp, 1), &bp);
>  		/*
>  		 * If we get an error reading or writing alternate superblocks,
> @@ -878,7 +880,7 @@ xfs_update_secondary_sbs(
>  		if (error) {
>  			xfs_warn(mp,
>  		"error allocating secondary superblock for ag %d",
> -				agno);
> +				pag->pag_agno);
>  			if (!saved_error)
>  				saved_error = error;
>  			continue;
> @@ -899,7 +901,7 @@ xfs_update_secondary_sbs(
>  		if (error) {
>  			xfs_warn(mp,
>  		"write error %d updating a secondary superblock near ag %d",
> -				error, agno);
> +				error, pag->pag_agno);
>  			if (!saved_error)
>  				saved_error = error;
>  			continue;
> -- 
> 2.31.1
> 

