Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B303FC2B9F7
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 10:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8514A6044F
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 10:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbhEXKoP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 06:44:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232547AbhEXKoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 06:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621852959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NoxEjuEWgkg5fs2WbwAcatgBZ7aZiGncK9IsbeTbOwo=;
        b=br/VHNhz+Co1iSkBGhZ0rp6JAx2sw/bUByEnSJSKBvw0UdRvMFFwIJTSH2aXzxJJiTxje+
        lTk8/uv9b7JizpmahKz63LT84ZRvTqEIqtYPo4JbBfG54CISgirZBoMuiZAtDr032MDX0H
        5pxUkeMXNQ8uyfsb2qiR90tanLg2Tl0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-mBtfQwr_M-SabFulbOQTqA-1; Mon, 24 May 2021 06:42:37 -0400
X-MC-Unique: mBtfQwr_M-SabFulbOQTqA-1
Received: by mail-qv1-f71.google.com with SMTP id b5-20020a0cc9850000b02901eece87073bso25511339qvk.21
        for <linux-xfs@vger.kernel.org>; Mon, 24 May 2021 03:42:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NoxEjuEWgkg5fs2WbwAcatgBZ7aZiGncK9IsbeTbOwo=;
        b=RG25ko/dxpoL5xnO6A8y+AnA+rOsnHohzIoxVttaqkqRIIPpfpEEDWzchHvopGG8l3
         FPAdJ0+iylYGqv9TZdV0d2ZgcxTYRkm68x0kSaFRFM9IP7m4OU7jL9Xtb8eOcbxKxu9H
         98/SxTelGXFlvRkHTxXqLh0f2xIyO0HDqsdMNaJpMWvh/g3KGGHJAUyMxJPAWqrXu4Ik
         wwpNFVorgOElMz3lGO0pydSrQF6+YejmXRt8BX5LXmc98SeSTdTFYkPzvw3l7PIlhdj2
         b29CRmyDXjChquXttF8Or/SAH19Qma90rl5esqHnoRaAqjnTsM3KNxnDpZD4zJTqwq+x
         Evpg==
X-Gm-Message-State: AOAM532+4AhdCAbJJMvHpMFEeXD8aGLBZMyfKyVpWfklnWmCbte+GZ6z
        8quZiH3uewzVmB4a458lUjwcE5CNRH3/IOpABbwLPSkhiJWqjQw/s8xmTga08u0wtVedmk+/l+j
        mHH301YSXSL5cxmRJxEiS
X-Received: by 2002:ac8:6751:: with SMTP id n17mr2692132qtp.376.1621852957062;
        Mon, 24 May 2021 03:42:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPZ3RzVOEgsEfHu+hf/2M1+OEtWMvdqqjyUrUIDDBUcLEXeXdEqwhNeACPIREJmwHBqoMXww==
X-Received: by 2002:ac8:6751:: with SMTP id n17mr2692112qtp.376.1621852956875;
        Mon, 24 May 2021 03:42:36 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id h2sm11061115qkf.106.2021.05.24.03.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 03:42:36 -0700 (PDT)
Date:   Mon, 24 May 2021 06:42:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
Subject: Re: [PATCH 1/1] xfs: check free AG space when making per-AG
 reservations
Message-ID: <YKuDGt2/Hj/eEHGX@bfoster>
References: <162181808760.203030.18032062235913134439.stgit@locust>
 <162181809311.203030.14398379924057321012.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162181809311.203030.14398379924057321012.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 23, 2021 at 06:01:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The new online shrink code exposed a gap in the per-AG reservation
> code, which is that we only return ENOSPC to callers if the entire fs
> doesn't have enough free blocks.  Except for debugging mode, the
> reservation init code doesn't ever check that there's enough free space
> in that AG to cover the reservation.
> 
> Not having enough space is not considered an immediate fatal error that
> requires filesystem offlining because (a) it's shouldn't be possible to
> wind up in that state through normal file operations and (b) even if
> one did, freeing data blocks would recover the situation.
> 
> However, online shrink now needs to know if shrinking would not leave
> enough space so that it can abort the shrink operation.  Hence we need
> to promote this assertion into an actual error return.
> 
> Observed by running xfs/168 with a 1k block size, though in theory this
> could happen with any configuration.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index e32a1833d523..bbfea8022a3b 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -325,10 +325,22 @@ xfs_ag_resv_init(
>  		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
>  		if (error2)
>  			return error2;
> -		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> -		       pag->pagf_freeblks + pag->pagf_flcount);
> +
> +		/*
> +		 * If there isn't enough space in the AG to satisfy the
> +		 * reservation, let the caller know that there wasn't enough
> +		 * space.  Callers are responsible for deciding what to do
> +		 * next, since (in theory) we can stumble along with
> +		 * insufficient reservation if data blocks are being freed to
> +		 * replenish the AG's free space.
> +		 */
> +		if (!error &&
> +		    xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
> +		    pag->pagf_freeblks + pag->pagf_flcount)
> +			error = -ENOSPC;
>  	}
> +
>  	return error;
>  }
>  
> 

