Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D9BC433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E010613CD
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhELMut (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:50:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELMus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620823780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jZXwWK/6kzE4nGJ3BIPpYD9pw+d98jh9Qy8ZhVUpYFY=;
        b=dI+GEWbPFUdeGRYKDl+gWMoq7ZDOLGSFYPtu+sWXg+z+Fp5A2bsIUngNqPb32ESM8Mbpm9
        JbPQujpoAR1xQJxQAYDGkgsGyvTZEiM5gzNWq2Wx/03fD01QJIVkSUBm8ij7IZnNYAbKox
        KYiqhCIYPN4wDvvGtRAULFDF6Vm/hMY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-_jIp78EoOzivrrTaDClWJg-1; Wed, 12 May 2021 08:49:39 -0400
X-MC-Unique: _jIp78EoOzivrrTaDClWJg-1
Received: by mail-qv1-f69.google.com with SMTP id a18-20020a0cca920000b02901d3c6996bb7so18801549qvk.6
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:49:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jZXwWK/6kzE4nGJ3BIPpYD9pw+d98jh9Qy8ZhVUpYFY=;
        b=B91MDI2IJzJpRhpmVkQsbgRboR4i4yGElIzNkc4np8nrGXOH68pIOMgSAsMIiRDrGr
         q/KZA971tpZE4t56zUawXc5CBo7JTAZRevrjEVTrt8f5O15Jl7jNRrr6DZVcVgv2F9Em
         4e72SKj5Hw4YcJfvioYsCcIcy1Zd9Qo3EzEeJADBbfvUcGqDaDyu5NaPCSqN6EAzZXLM
         AG7odZRNF6/kgoabkqKruXzt42k1GX/PMJLXqIxiXJbDHg/DXgz6z8EajrInJ4v3CkgK
         qVmEaYlta42xImAuHylJcQ6y+92LKvDb/CSpD88/xAQtHJnP938yMjjFjg2/kpF/gQSl
         Ijkw==
X-Gm-Message-State: AOAM5332xvJw2s7OHviGMPd2zN4ZVu8iva5I+f5SpfEj7ZMNccyLQ59D
        /pFq/JG40BHgRtXmfDCAfJmmlUZK2I6aj5Vg9HfJ8KhCKndUE+w+Z9z/w9RN2U88ilSp8YiB+Wb
        beUXe3R9bX3hy3a/dHo5M
X-Received: by 2002:a37:9a16:: with SMTP id c22mr32844283qke.0.1620823778332;
        Wed, 12 May 2021 05:49:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjlLV1RmkHuh5fRTLclOf/8SBpulYT6TzWMAicPPl2z1xigfKHAMCd0GnUOmB1CihbaQ6yYg==
X-Received: by 2002:a37:9a16:: with SMTP id c22mr32844268qke.0.1620823778114;
        Wed, 12 May 2021 05:49:38 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 129sm16204360qkn.44.2021.05.12.05.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:49:37 -0700 (PDT)
Date:   Wed, 12 May 2021 08:49:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/22] xfs: simplify xfs_dialloc_select_ag() return values
Message-ID: <YJvO4Py+CbiEddNn@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-18-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-18-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The only caller of xfs_dialloc_select_ag() will always return
> -ENOSPC to it's caller if the agbp returned from
> xfs_dialloc_select_ag() is NULL. IOWs, failure to find a candidate
> AGI we can allocate inodes from is always an ENOSPC condition, so
> move this logic up into xfs_dialloc_select_ag() so we can simplify
> the return logic in this function.
> 
> xfs_dialloc_select_ag() now only ever returns 0 with a locked
> agbp, or an error with no agbp.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc.c | 23 ++++++++---------------
>  fs/xfs/xfs_inode.c         |  3 ---
>  2 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 4540fbcd68a3..872591e8f5cb 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1717,7 +1717,7 @@ xfs_dialloc_roll(
>   * This function will ensure that the selected AG has free inodes available to
>   * allocate from. The selected AGI will be returned locked to the caller, and it
>   * will allocate more free inodes if required. If no free inodes are found or
> - * can be allocated, no AGI will be returned.
> + * can be allocated, -ENOSPC be returned.
>   */
>  int
>  xfs_dialloc_select_ag(
> @@ -1730,7 +1730,6 @@ xfs_dialloc_select_ag(
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error;
> -	bool			noroom = false;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> @@ -1744,7 +1743,7 @@ xfs_dialloc_select_ag(
>  	 */
>  	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
>  	if (start_agno == NULLAGNUMBER)
> -		return 0;
> +		return -ENOSPC;
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> @@ -1757,7 +1756,6 @@ xfs_dialloc_select_ag(
>  	if (igeo->maxicount &&
>  	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
>  							> igeo->maxicount) {
> -		noroom = true;
>  		okalloc = false;
>  	}
>  
> @@ -1794,10 +1792,8 @@ xfs_dialloc_select_ag(
>  		if (error)
>  			break;
>  
> -		if (pag->pagi_freecount) {
> -			xfs_perag_put(pag);
> +		if (pag->pagi_freecount)
>  			goto found_ag;
> -		}
>  
>  		if (!okalloc)
>  			goto nextag_relse_buffer;
> @@ -1805,9 +1801,6 @@ xfs_dialloc_select_ag(
>  		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
>  		if (error < 0) {
>  			xfs_trans_brelse(*tpp, agbp);
> -
> -			if (error == -ENOSPC)
> -				error = 0;
>  			break;
>  		}
>  
> @@ -1818,12 +1811,11 @@ xfs_dialloc_select_ag(
>  			 * allocate one of the new inodes.
>  			 */
>  			ASSERT(pag->pagi_freecount > 0);
> -			xfs_perag_put(pag);
>  
>  			error = xfs_dialloc_roll(tpp, agbp);
>  			if (error) {
>  				xfs_buf_relse(agbp);
> -				return error;
> +				break;
>  			}
>  			goto found_ag;
>  		}
> @@ -1831,16 +1823,17 @@ xfs_dialloc_select_ag(
>  nextag_relse_buffer:
>  		xfs_trans_brelse(*tpp, agbp);
>  nextag:
> -		xfs_perag_put(pag);
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
>  		if (agno == start_agno)
> -			return noroom ? -ENOSPC : 0;
> +			break;
> +		xfs_perag_put(pag);
>  	}
>  
>  	xfs_perag_put(pag);
> -	return error;
> +	return error ? error : -ENOSPC;
>  found_ag:
> +	xfs_perag_put(pag);
>  	*IO_agbp = agbp;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 25910b145d70..3918c99fa95b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -923,9 +923,6 @@ xfs_dir_ialloc(
>  	if (error)
>  		return error;
>  
> -	if (!agibp)
> -		return -ENOSPC;
> -
>  	/* Allocate an inode from the selected AG */
>  	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
>  	if (error)
> -- 
> 2.31.1
> 

