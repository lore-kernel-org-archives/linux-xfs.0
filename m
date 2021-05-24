Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B06C04FF3
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 13:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84EEA61260
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 13:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhEXNIb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 May 2021 09:08:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24751 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232401AbhEXNI3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 May 2021 09:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621861619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h0RD4zeK6hQMV0jt+Je6PjOJ54LkTNnLT+emSmO30e8=;
        b=jBf5EefhL3RUeQfscBXEB+NqWmnXB/WXz8yGf06wG1kDvrTuy4X+9OaA8oEpXfSJ6q/qn9
        NgozX+gENgL8CNB399dCc2mBf5NYx/cco3BGLyj8t/el4uuxHOJA8h5UrIJ8N37F6pR0IK
        MyPrnis1uAj5mxU7yfSMWYm5EMnSEs4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-2UClHtlYNPiGILClVE3hZw-1; Mon, 24 May 2021 09:06:57 -0400
X-MC-Unique: 2UClHtlYNPiGILClVE3hZw-1
Received: by mail-ed1-f71.google.com with SMTP id c15-20020a05640227cfb029038d710bf29cso9508582ede.16
        for <linux-xfs@vger.kernel.org>; Mon, 24 May 2021 06:06:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=h0RD4zeK6hQMV0jt+Je6PjOJ54LkTNnLT+emSmO30e8=;
        b=qmREYGGbCZj4zvm7q7ojKipuW9KyjYAIGduNeFupch6YAhQI1DUB4gJgsvx2gr0nx0
         TbBPQEt+rio2S23tgfe19OptGkAUZztlM/Hwx2NApa0lQ5dREz49c3lSoeaQp+iE54GU
         LciqLxykc/G7Uox32TJtDwG0W2Xf/j0K7GZAqO5rTp+3T6INBo6wraOL5CuYT/g7HNBm
         m8Ng0h7c6NrG8rmxgvB4wzduzKi3WZ8/vH0kTo8lQIfoODs92SLHE2rrUp7Losv+Own4
         H/WjpjkBj0FSHRxlXV9XGutSezaSUG1V2QuR6hEc1vgMmU4Pzi/Wk2HFSf5UjodXxC1o
         aS6w==
X-Gm-Message-State: AOAM5306WmG0BYB49lpCLpkclRMGG0wPJftGnoOZluhaLco/9D02L6SD
        m7sT10f8P5dihtQmwz92SLYNt9Z/cTpwgDS2RqJmlFO1GrgDMkxiYz+Yw5KzVLW50g26bIEnkcU
        5jpuQquyrDzubRtxFNp4H
X-Received: by 2002:a17:906:f996:: with SMTP id li22mr23113711ejb.255.1621861616489;
        Mon, 24 May 2021 06:06:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz34tqS1DE2nRg/I1hhsWzu+278LHml4RDKcWiDoI+B3Q7hZ4Ac7bklVtbBCKkgrdX3wopbFg==
X-Received: by 2002:a17:906:f996:: with SMTP id li22mr23113693ejb.255.1621861616315;
        Mon, 24 May 2021 06:06:56 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id d17sm7813676ejp.90.2021.05.24.06.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:06:55 -0700 (PDT)
Date:   Mon, 24 May 2021 15:06:54 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
Subject: Re: [PATCH 1/1] xfs: check free AG space when making per-AG
 reservations
Message-ID: <20210524130654.kzmim2lpme5jyrtm@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
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
>  fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

Looks good

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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

-- 
Carlos

