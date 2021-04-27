Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB781C433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 12:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A48BB613C0
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 12:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbhD0MrU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 08:47:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237845AbhD0MrU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 08:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619527597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SOesPR5PBi8jh2gK4ErWbfsxdw1vZg+yg/8NiaqEQjM=;
        b=HZUwnW6j0VSGJbU1sNl99eqzErTQ/1KmMpFwhvzDNJVpvcxlNZRpZ0NFvNfCnmH81w36BY
        Z+dGgTehsUllyzozVYNlwkMxNKbS9zZB4N2TMVOvk3PYOFqGj74+V7z2KsxLQwEFhGyW3q
        gEoShaUU7ZF2VIZzq6VCTt+U+tPdcGo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-sOeAuVjRPNS9AabLBzbnRA-1; Tue, 27 Apr 2021 08:46:35 -0400
X-MC-Unique: sOeAuVjRPNS9AabLBzbnRA-1
Received: by mail-qv1-f72.google.com with SMTP id g26-20020a0caada0000b02901b93eb92373so4619636qvb.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 05:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SOesPR5PBi8jh2gK4ErWbfsxdw1vZg+yg/8NiaqEQjM=;
        b=G17OPydGu/VWe8nsV4X8xgD+zefgBgAsQLXgM8ntDtTZOgzM4dyEZi30Wricw56ZrU
         6C33/n46Bti2X/K1yx51cYDqpHrdZzukGuBzl+IhmHVd9cZOCtIX3emMppYaTJ0wGKJF
         WknMit2OdA0upPxPHbpw0I/4h3d22EWngtq3bi8gTdweFDipbrQx33o5S9AtP1+UqtES
         jnEE535zQbfvZ+nRXUbXnYtfld1Y3GFrqPbKmeGwXJyR1MkJUUNokxn3QabTKqDce6ur
         J7mvARD+qXH1vi4j7QqHw46DvMPprz8GhlNIc78V9NgRaggw5gcztWTkrSa3PgL1VAl4
         oK3A==
X-Gm-Message-State: AOAM533lKD5E2qUV1mgvaZC2sPgk8tMzmPh/t3keuNUQKxL7lffNrXZP
        eAIFUZHsToa9I0ua8ugHl0p/atay4nPzKg/z82cnTO9MZKJIZs/3JHqbzT9dpl5AuE1eVw1Tjrq
        MmEtdgbsGustFjMza0xnG
X-Received: by 2002:a37:c57:: with SMTP id 84mr23189851qkm.340.1619527594437;
        Tue, 27 Apr 2021 05:46:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx50T/Liyx9ZGQ03TrwoI5pOHWR32XkNsKM8iXtaZK7q3jbEUJ9Y+nHfAMFqC7O+oKead4T4w==
X-Received: by 2002:a37:c57:: with SMTP id 84mr23189837qkm.340.1619527594260;
        Tue, 27 Apr 2021 05:46:34 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id u190sm2827978qkc.18.2021.04.27.05.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 05:46:33 -0700 (PDT)
Date:   Tue, 27 Apr 2021 08:46:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Gao Xiang <hsiangkao@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: count free space btree blocks when scrubbing
 pre-lazysbcount fses
Message-ID: <YIgHqM/ukFqvHN3K@bfoster>
References: <20210427030232.GE3122264@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427030232.GE3122264@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 26, 2021 at 08:02:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since agf_btreeblks didn't exist before the lazysbcount feature, the fs
> summary count scrubber needs to walk the free space btrees to determine
> the amount of space being used by those btrees.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Note: I /think/ the four patches on the list right now fix all the
> obvious problems with !lazysbcount filesystems, except for xfs/49[12]
> which fuzz the summary counters.
> ---
>  fs/xfs/scrub/fscounters.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 318b81c0f90d..87476a00de9d 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -13,6 +13,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_health.h"
> +#include "xfs_btree.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> @@ -143,6 +144,35 @@ xchk_setup_fscounters(
>  	return xchk_trans_alloc(sc, 0);
>  }
>  
> +/* Count free space btree blocks manually for pre-lazysbcount filesystems. */
> +static int
> +xchk_fscount_btreeblks(
> +	struct xfs_scrub	*sc,
> +	struct xchk_fscounters	*fsc,
> +	xfs_agnumber_t		agno)
> +{
> +	xfs_extlen_t		blocks;
> +	int			error;
> +
> +	error = xchk_ag_init(sc, agno, &sc->sa);
> +	if (error)
> +		return error;
> +
> +	error = xfs_btree_count_blocks(sc->sa.bno_cur, &blocks);
> +	if (error)
> +		goto out_free;
> +	fsc->fdblocks += blocks - 1;
> +
> +	error = xfs_btree_count_blocks(sc->sa.cnt_cur, &blocks);
> +	if (error)
> +		goto out_free;
> +	fsc->fdblocks += blocks - 1;
> +
> +out_free:
> +	xchk_ag_free(sc, &sc->sa);
> +	return error;
> +}
> +
>  /*
>   * Calculate what the global in-core counters ought to be from the incore
>   * per-AG structure.  Callers can compare this to the actual in-core counters
> @@ -184,6 +214,13 @@ xchk_fscount_aggregate_agcounts(
>  		fsc->fdblocks += pag->pagf_flcount;
>  		if (xfs_sb_version_haslazysbcount(&sc->mp->m_sb))
>  			fsc->fdblocks += pag->pagf_btreeblks;
> +		else {
> +			error = xchk_fscount_btreeblks(sc, fsc, agno);
> +			if (error) {
> +				xfs_perag_put(pag);
> +				break;
> +			}
> +		}
>  
>  		/*
>  		 * Per-AG reservations are taken out of the incore counters,
> 

