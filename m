Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508E9C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC62613FE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 12:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhELMzT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 08:55:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233371AbhELMxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 08:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620823949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oRnzp5D9QMx6M0O5GAC7QeS87YQo8Zp0WNtW2bXprZ0=;
        b=I2I6U+U52XKbJU8k7aSKrXOZjGl00h8P4oe45hr1d4HHjaJTFEs6IyuEW0lFOS5mpIvnNi
        zAlnbSLJ0SYe9xX1b/SnLtHdCsX7yM2va/8aySSvbqFww00r2mpc+yV23ySYahJk6dRzxS
        +JadyMz1ik7GRz91yz9QFP509dIRYso=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-i1dyw0qnODuoVfpyCgcz_w-1; Wed, 12 May 2021 08:52:28 -0400
X-MC-Unique: i1dyw0qnODuoVfpyCgcz_w-1
Received: by mail-qt1-f200.google.com with SMTP id b19-20020ac84f130000b02901d543c52248so12489304qte.1
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 05:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oRnzp5D9QMx6M0O5GAC7QeS87YQo8Zp0WNtW2bXprZ0=;
        b=nxsqRX5BefGvy0cPaatL0NmxADq0wvD1FW0nyZbkec6Ubov+C5OLOIJIfabYZ5WWrv
         6iskD4mzc+TY7mrKtoP6Q8Va5S0KZQTUjwjSVP1OEThwYXJbraP+FHnYpUuyBiTYbd5q
         jEj4uwMf/N3Z9cpEY+vrhalieuOnEOPLgksmjeNkP4GjDv8NNFHJny9nFIp1fSHxUjx7
         qk/alktawo34jkQrGIbp1eOYqGrmCgUL2kHcKsMQkM3yKe80OJqlgvUCjq3XCIkROWGW
         IVId78dXa9pG/nip1vqgL4CVTL9DX9M1soshRD1yF65ru0nBPZ5rIIvCtG1XOPdyXUum
         llWA==
X-Gm-Message-State: AOAM533u5i/DQhfoeI80wQXdagKM30q9v6+3wsxtSUXWD7Q0nPzVmRWf
        4PztRlnaFXGSzw0Q7rs/1wZT442JJMrpQ+l2iJSBnaiFhpxTtDXL5UBfjEFz5S+sBz+NFV5mTDS
        1UKZ2ryX9BoOReEne+Yee
X-Received: by 2002:a37:404a:: with SMTP id n71mr33262696qka.330.1620823947778;
        Wed, 12 May 2021 05:52:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6cQBFblm0EPgf1GS/yFmA8h9Av49KHWToxCX8XWY0C7EgNkxJFWT07d0XiLjMWAjlyrMKMg==
X-Received: by 2002:a37:404a:: with SMTP id n71mr33262682qka.330.1620823947554;
        Wed, 12 May 2021 05:52:27 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 25sm5385274qky.16.2021.05.12.05.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:52:27 -0700 (PDT)
Date:   Wed, 12 May 2021 08:52:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: collapse AG selection for inode allocation
Message-ID: <YJvPiWfS4Jp2has7@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-19-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-19-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_dialloc_select_ag() does a lot of repetitive work. It first
> calls xfs_ialloc_ag_select() to select the AG to start allocation
> attempts in, which can do up to two entire loops across the perags
> that inodes can be allocated in. This is simply checking if there is
> spce available to allocate inodes in an AG, and it returns when it
> finds the first candidate AG.
> 
> xfs_dialloc_select_ag() then does it's own iterative walk across
> all the perags locking the AGIs and trying to allocate inodes from
> the locked AG. It also doesn't limit the search to mp->m_maxagi,
> so it will walk all AGs whether they can allocate inodes or not.
> 
> Hence if we are really low on inodes, we could do almost 3 entire
> walks across the whole perag range before we find an allocation
> group we can allocate inodes in or report ENOSPC.
> 
> Because xfs_ialloc_ag_select() returns on the first candidate AG it
> finds, we can simply do these checks directly in
> xfs_dialloc_select_ag() before we lock and try to allocate inodes.
> This reduces the inode allocation pass down to 2 perag sweeps at
> most - one for aligned inode cluster allocation and if we can't
> allocate full, aligned inode clusters anywhere we'll do another pass
> trying to do sparse inode cluster allocation.
> 
> This also removes a big chunk of duplicate code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 221 +++++++++++++------------------------
>  1 file changed, 75 insertions(+), 146 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 872591e8f5cb..b22556556bba 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
...
> @@ -1778,10 +1669,41 @@ xfs_dialloc_select_ag(
>  				break;
>  		}
>  
> +		if (!pag->pagi_freecount)
> +			goto nextag;

It looks like this would never allow for allocation of new inode
chunks..?

> +		if (!okalloc)
> +			goto nextag;
> +
> +		if (!pag->pagf_init) {
> +			error = xfs_alloc_pagf_init(mp, *tpp, agno, flags);
> +			if (error)
> +				goto nextag;
> +		}
> +
>  		/*
> -		 * Do a first racy fast path check if this AG is usable.
> +		 * Check that there is enough free space for the file plus a
> +		 * chunk of inodes if we need to allocate some. If this is the
> +		 * first pass across the AGs, take into account the potential
> +		 * space needed for alignment of inode chunks when checking the
> +		 * longest contiguous free space in the AG - this prevents us
> +		 * from getting ENOSPC because we have free space larger than
> +		 * ialloc_blks but alignment constraints prevent us from using
> +		 * it.
> +		 *
> +		 * If we can't find an AG with space for full alignment slack to
> +		 * be taken into account, we must be near ENOSPC in all AGs.
> +		 * Hence we don't include alignment for the second pass and so
> +		 * if we fail allocation due to alignment issues then it is most
> +		 * likely a real ENOSPC condition.
>  		 */
> -		if (!pag->pagi_freecount && !okalloc)
> +		ineed = M_IGEO(mp)->ialloc_min_blks;
> +		if (flags && ineed > 1)
> +			ineed += M_IGEO(mp)->cluster_align;
> +		longest = pag->pagf_longest;
> +		if (!longest)
> +			longest = pag->pagf_flcount > 0;
> +
> +		if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
>  			goto nextag;

... and here we check for enough free space in the AG for chunk
allocation purposes. The pagi_freecount check is further down, however,
so it looks like we can skip the AG even if pagi_freecount > 0 and
allocation is not necessary.

Brian

>  
>  		/*
> @@ -1823,10 +1745,17 @@ xfs_dialloc_select_ag(
>  nextag_relse_buffer:
>  		xfs_trans_brelse(*tpp, agbp);
>  nextag:
> -		if (++agno == mp->m_sb.sb_agcount)
> -			agno = 0;
> -		if (agno == start_agno)
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			error = -EFSCORRUPTED;
>  			break;
> +		}
> +		if (++agno == mp->m_maxagi)
> +			agno = 0;
> +		if (agno == start_agno) {
> +			if (!flags)
> +				break;
> +			flags = 0;
> +		}
>  		xfs_perag_put(pag);
>  	}
>  
> -- 
> 2.31.1
> 

