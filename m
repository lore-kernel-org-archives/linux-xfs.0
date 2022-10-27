Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E220ECAAA1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 21:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbiJ0VPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 17:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236619AbiJ0VPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 17:15:38 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B760145987
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:15:35 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ez6so2850702pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 14:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=43B5eIv2QSQDVk3aIQHeuYjyv2fB1Hc7YP40mOwKvec=;
        b=3B+1/Io7Nxwt67heTsPXIJnZAXHVMIMz4uirauvOKcOmMdfTSqqjCNaWD2SK7ASftp
         K56f0gXWBUww++lQqlWuIbgEVxqLmIVrt7fyeCRI69kky4ZM9i/oj+bzmWB1UHm3JUHa
         pfCYfLcLpjT8QwpOMuamtRH/lmWBjnVQqtT7c+OlDWyzUyxex/FZbfas0lZpwe2vFDzr
         h5Ux96r58WnVFlr7sbWCbmuZKHlWPfDiwVPzb6eVRGrDEPZZ8cgbBm52FAZQ23B8GYPZ
         HWsFGlhzSKa3Z5iJ/wD0ibisyiKmm+KerUzU2+hFPh8edWm2LcLBBZgYW6dkjVgJz+lP
         /+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=43B5eIv2QSQDVk3aIQHeuYjyv2fB1Hc7YP40mOwKvec=;
        b=H9omC9HvJLYQpRdBItZQKxntyO09c2nI5U+iMnKsb0MQUCav7p9sPDTn/xuJ7DRxCe
         RIj5D0ria/IsvO/b2wfwGnwoImpsnvdlehsAil63rRAxAO0LdxJOYT/E2sSZA8OF2X9v
         DiZAsksYqsY7Zwic/yo+G7r7GA5RqHDVDWtrcFvJ+/SJeVYnCOYuXpTViihybB3pzQT8
         12aMuaOBbjyWaWQJwXvKEy8j0jOZ/GlRD+XNhvhDsMmII6uM4OaBuaxtmnB5ABQd9L3T
         5Hl+75/Q8TSjE6Pwp4j9boVbZjWyb8cDbkoadhzV7y2uqx/x9HO3Iv0eK8RL/AHXlo29
         eOSQ==
X-Gm-Message-State: ACrzQf0n4QloiWUt6NX2zbkGcR7/p2DFUsSV2XbOXsNWUN0zsyStv/Pv
        P2E4lihs9aNOK0+nj6epKoLvvQ==
X-Google-Smtp-Source: AMsMyM5njOVlSwXc8qs+sMUNKmtQEd99LZZYsEjnQ4Qq2K7rCoFtIx7Vz0c0mPNAIHr/MGgK12lb/g==
X-Received: by 2002:a17:90a:6c21:b0:212:f53b:fe22 with SMTP id x30-20020a17090a6c2100b00212f53bfe22mr12351809pjj.27.1666905334796;
        Thu, 27 Oct 2022 14:15:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902ee8a00b00186dcc37e17sm1596129pld.210.2022.10.27.14.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:15:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ooADr-0079j4-JP; Fri, 28 Oct 2022 08:15:31 +1100
Date:   Fri, 28 Oct 2022 08:15:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: check record domain when accessing refcount
 records
Message-ID: <20221027211531.GW3600936@dread.disaster.area>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
 <166689089384.3788582.15595498616742667720.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166689089384.3788582.15595498616742667720.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 27, 2022 at 10:14:53AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've separated the startblock and CoW/shared extent domain in
> the incore refcount record structure, check the domain whenever we
> retrieve a record to ensure that it's still in the domain that we want.
> Depending on the circumstances, a change in domain either means we're
> done processing or that we've found a corruption and need to fail out.
> 
> The refcount check in xchk_xref_is_cow_staging is redundant since
> _get_rec has done that for a long time now, so we can get rid of it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   53 ++++++++++++++++++++++++++++++++----------
>  fs/xfs/scrub/refcount.c      |    4 ++-
>  2 files changed, 43 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 3b1cb0578770..608a122eef16 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -386,6 +386,8 @@ xfs_refcount_split_extent(
>  		goto out_error;
>  	}
>  
> +	if (rcext.rc_domain != domain)
> +		return 0;
>  	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
>  		return 0;
>  
> @@ -434,6 +436,9 @@ xfs_refcount_merge_center_extents(
>  	int				error;
>  	int				found_rec;
>  
> +	ASSERT(left->rc_domain == center->rc_domain);
> +	ASSERT(right->rc_domain == center->rc_domain);
> +
>  	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
>  			cur->bc_ag.pag->pag_agno, left, center, right);

Can you move the asserts to after the trace points? That way we if
need to debug the assert, we'll have a tracepoint with the record
information that triggered the assert emitted immediately before it
fires...

>  
> @@ -510,6 +515,8 @@ xfs_refcount_merge_left_extent(
>  	int				error;
>  	int				found_rec;
>  
> +	ASSERT(left->rc_domain == cleft->rc_domain);
> +
>  	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
>  			cur->bc_ag.pag->pag_agno, left, cleft);
>  
> @@ -571,6 +578,8 @@ xfs_refcount_merge_right_extent(
>  	int				error;
>  	int				found_rec;
>  
> +	ASSERT(right->rc_domain == cright->rc_domain);
> +
>  	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
>  			cur->bc_ag.pag->pag_agno, cright, right);
>  
> @@ -654,12 +663,10 @@ xfs_refcount_find_left_extents(
>  		goto out_error;
>  	}
>  
> +	if (tmp.rc_domain != domain)
> +		return 0;
>  	if (xfs_refc_next(&tmp) != agbno)
>  		return 0;
> -	if (domain == XFS_REFC_DOMAIN_SHARED && tmp.rc_refcount < 2)
> -		return 0;
> -	if (domain == XFS_REFC_DOMAIN_COW && tmp.rc_refcount > 1)
> -		return 0;

Ah, as these go away, you can ignore my comment about them in the
previous patches... :)

Otherwise, looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
