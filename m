Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC676C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9799161408
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhELMz5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:55:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233434AbhELMxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620823965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SsorM+LzPDwLSE1RVSafgExf3uaNFF0JLaHoGbYAWP8=;
        b=Ll4RD/XmaRB0nokn0rik/Z6zCul/Cqh83uT0ZbTloVEht6LWkLvAvXeg34OgDW4hv7yP6/
        Y3Rp8wViow/AX1tg5mRkM0pI6XsgeGsXjXsqPRAW46o8NXHKBpa9w2XwW08RCEUnzmy05V
        anmWlYLaox8/fGvU1HRC2YeJ264OcIc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-383mnIibMtCYh8U5CLcRSg-1; Wed, 12 May 2021 08:52:43 -0400
X-MC-Unique: 383mnIibMtCYh8U5CLcRSg-1
Received: by mail-qt1-f199.google.com with SMTP id e13-20020ac84e4d0000b02901e0f0a55411so3304314qtw.9
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:52:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SsorM+LzPDwLSE1RVSafgExf3uaNFF0JLaHoGbYAWP8=;
        b=I24ekMBIJTAEha3+3u0fTMf/fU8TyIeKSMlKmo6puxm8pdq1O5i2upB3hW3JYMN4HX
         o3WZs/GiBO2zzMEUTlqp6Sb0Jf6uE6SIQohIwbrbHIr7BASGyf6mZj3Z9IgBo+Ofmfsn
         l1VbujVLAfPu53Xu/Q5v317Naq+dFoXJxoxlas4tlzR521MGn0jhGwVQ6P4pSH1MQ96E
         CJChXIimh9DM+Q/TBDmOdrkuLSzqJwBBkBwCxTh7qWVpaeqnRQCCIDDp65ebufpyVQ6E
         5TUTVndoUggN2w2sXmCCb+owyu8Nc0LAG5I8B8e+29wOgNI+1TH5d3aa8dv7YiSeBaXU
         lS6A==
X-Gm-Message-State: AOAM533RZFBtj11OYzO/QxjcadEST4rCGeHyqTrosJrvmMZ1r/OXLuEV
        +YkK2vVF0n74M4osdAJgw79QOMmiipp0FVg53W2BlNPwGk+RdpCPRVzvhQhRYmoJDEnox12dt/b
        tjqC0bmacev7FCdMD4aZB
X-Received: by 2002:a05:622a:1192:: with SMTP id m18mr32783705qtk.108.1620823963229;
        Wed, 12 May 2021 05:52:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwteU38AiFH7QbQtTMB4i6zFwiUp4gsihGu/cV2u7DzEeRmPlLwRtQ3nggicFaJTPTz+Wm2Og==
X-Received: by 2002:a05:622a:1192:: with SMTP id m18mr32783692qtk.108.1620823963043;
        Wed, 12 May 2021 05:52:43 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id f7sm17987554qtm.41.2021.05.12.05.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:52:42 -0700 (PDT)
Date:   Wed, 12 May 2021 08:52:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs: inode allocation can use a single perag
 instance
Message-ID: <YJvPmbp5ZOpyt3hE@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-21-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-21-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we've internalised the two-phase inode allocation, we can
> now easily make the AG selection and allocation atomic from the
> perspective of a single perag context. This will ensure AGs going
> offline/away cannot occur between the selection and allocation
> steps.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 2c0ef2dd46d9..d749bb7c7a69 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1432,6 +1432,7 @@ int
>  xfs_dialloc_ag(
>  	struct xfs_trans	*tp,
>  	struct xfs_buf		*agbp,
> +	struct xfs_perag	*pag,
>  	xfs_ino_t		parent,
>  	xfs_ino_t		*inop)
>  {
> @@ -1446,7 +1447,6 @@ xfs_dialloc_ag(
>  	int				error;
>  	int				offset;
>  	int				i;
> -	struct xfs_perag		*pag = agbp->b_pag;
>  
>  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>  		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
> @@ -1761,9 +1761,9 @@ xfs_dialloc(
>  	xfs_perag_put(pag);
>  	return error ? error : -ENOSPC;
>  found_ag:
> -	xfs_perag_put(pag);
>  	/* Allocate an inode in the found AG */
> -	error = xfs_dialloc_ag(*tpp, agbp, parent, &ino);
> +	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
> +	xfs_perag_put(pag);
>  	if (error)
>  		return error;
>  	*new_ino = ino;
> -- 
> 2.31.1
> 

