Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB241C43460
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 12:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94E4C613C3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 12:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237884AbhD0MrQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 08:47:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237872AbhD0MrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 08:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619527590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D3lVzauI3xFQhgEiuQETq4fmAtD0FPlhtRNQ/oCPIck=;
        b=AuP8ZvJXPy1XNbYX2JXFBEN74Zk8pI2iIZDK2MGFHWDO+Ni3elbDU5QE9BhFdfB2L9e4Pq
        vlpEw/dv+CNbKiVRy2qgsR/m3agr2qmiQf7/6r/W26TrMkridYA6+3sY5D2UvfaATykiza
        2qOC0PttzXRSxzxQ1w2us1/H0VpJheY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-81-ZuQaGGiOOuKe6mzbcDP3TA-1; Tue, 27 Apr 2021 08:46:28 -0400
X-MC-Unique: ZuQaGGiOOuKe6mzbcDP3TA-1
Received: by mail-qk1-f198.google.com with SMTP id g184-20020a3784c10000b02902e385de9adaso22404354qkd.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 05:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D3lVzauI3xFQhgEiuQETq4fmAtD0FPlhtRNQ/oCPIck=;
        b=AQ9V/Q9KbHHt7I1WvkSFhRkIFwxO3XPgLEDHEkgFS5X1rIAJ8A4R3Q3+MfJg96okQu
         fAJq3sjPCejwzqliXySCmwNWsLwD+sb/y4/OLEl8Gs9+0GmEMliAst+hXqckFCV3QqtY
         jPcAqMz8uiGietUtruB5vLgYuYKqADMy6JQ9bVJ+pB9ndTZ9ZS9JCdTpFY8wwuqa53aB
         gzPj7y8Rh5hH4TyjIYtglGe17LZdBJnQWNZpTMZ2hMZ//EqxzuvRTdrzKAXv1IQVIJ7v
         nuuL7elTnZTKLW+LGhqJdRYyEIvcmlDThXAIzrAIjlAE0uuwsZb4eH1lbOFw+DXAyeyn
         ImzA==
X-Gm-Message-State: AOAM5331d/v2If/jtmwy5KTVszY5Nh+p/y2eZg8/pcwK0TQ1QRAmPeG0
        Kef/hk1Dbp7Tx335boK+eFuztUgDgQx0xh3TtXQ/OMxmU4Pu8i+7Jp4iWRTpA+3SUPuohMv6WlN
        +GqubvebQQquzE1KSo/wI
X-Received: by 2002:ac8:574f:: with SMTP id 15mr20738805qtx.50.1619527587855;
        Tue, 27 Apr 2021 05:46:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNLSR/YmWjz4vFbF4zEgnZuBve4EwiXQuWZ2DQa0PWWYR+n8cYqGRAhpsVLHHfyJWrPmRFEg==
X-Received: by 2002:ac8:574f:: with SMTP id 15mr20738780qtx.50.1619527587602;
        Tue, 27 Apr 2021 05:46:27 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id t63sm2724433qkh.6.2021.04.27.05.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 05:46:27 -0700 (PDT)
Date:   Tue, 27 Apr 2021 08:46:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs: update superblock counters correctly for
 !lazysbcount
Message-ID: <YIgHoSvI4oj9bPER@bfoster>
References: <20210427011201.4175506-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427011201.4175506-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:12:01AM +0800, Gao Xiang wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Keep the mount superblock counters up to date for !lazysbcount
> filesystems so that when we log the superblock they do not need
> updating in any way because they are already correct.
> 
> It's found by what Zorro reported:
> 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> 2. mount $dev $mnt
> 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> 4. umount $mnt
> 5. xfs_repair -n $dev
> and I've seen no problem with this patch.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reported-by: Zorro Lang <zlang@redhat.com>
> Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Could you provide a bit more detail on the problem in the commit log?
From the description and code change, it seems like there is some
problem with doing the percpu aggregation in xfs_log_sb() on
!lazysbcount filesystems. Therefore this patch reserves that behavior
for lazysbcount, and instead enables per-transaction updates in the
!lazysbcount specific cleanup path. Am I following that correctly?

Brian

> 
> As per discussion earilier [1], use the way Dave suggested instead.
> Also update the line to
> 	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> so it can fix the case above.
> 
> with XFS debug off, xfstests auto testcases fail on my loop-device-based
> testbed with this patch and Darrick's [2]:
> 
> generic/095 generic/300 generic/600 generic/607 xfs/073 xfs/148 xfs/273
> xfs/293 xfs/491 xfs/492 xfs/495 xfs/503 xfs/505 xfs/506 xfs/514 xfs/515
> 
> MKFS_OPTIONS="-mcrc=0 -llazy-count=0"
> 
> and these testcases above still fail without these patches or with
> XFS debug on, so I've seen no regression due to this patch.
> 
> [1] https://lore.kernel.org/r/20210422030102.GA63242@dread.disaster.area/
> [2] https://lore.kernel.org/r/20210425154634.GZ3122264@magnolia/
> 
>  fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
>  fs/xfs/xfs_trans.c     |  3 +++
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 60e6d255e5e2..dfbbcbd448c1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -926,9 +926,19 @@ xfs_log_sb(
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*bp = xfs_trans_getsb(tp);
>  
> -	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> -	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	/*
> +	 * Lazy sb counters don't update the in-core superblock so do that now.
> +	 * If this is at unmount, the counters will be exactly correct, but at
> +	 * any other time they will only be ballpark correct because of
> +	 * reservations that have been taken out percpu counters. If we have an
> +	 * unclean shutdown, this will be corrected by log recovery rebuilding
> +	 * the counters from the AGF block counts.
> +	 */
> +	if (xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +		mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
> +		mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bcc978011869..1e37aa8eca5a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
>  
>  	/* apply remaining deltas */
>  	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_fdblocks += tp->t_fdblocks_delta + tp->t_res_fdblocks_delta;
> +	mp->m_sb.sb_icount += idelta;
> +	mp->m_sb.sb_ifree += ifreedelta;
>  	mp->m_sb.sb_frextents += rtxdelta;
>  	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
>  	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> -- 
> 2.27.0
> 

