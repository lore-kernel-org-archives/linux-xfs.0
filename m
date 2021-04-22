Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6E6C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 02:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE3E613B8
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 02:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhDVCHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:07:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229706AbhDVCHE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Apr 2021 22:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619057190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=othbS4CIvWgJ8McaeVkm6FxgwuVQlQmsEj+LQDfjcqE=;
        b=A0fXU4gYhe3YqCrTfuYjL4JjgHKKI0LBtWZc3oPiKk2TrRbN8dWn9lUCkI8131FFRaSecB
        rRBNZimeiOPLHQQHhJl79uP3naSMeV1BUaFyr1CQQ4UmUrMLlNeWa1gBSe1ONYxGfFGvjZ
        A0mZZy948aTPxhAY+P9NvQxSTTZtu0Q=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-QpzlX9DxM-23CEeF8S6WCw-1; Wed, 21 Apr 2021 22:06:26 -0400
X-MC-Unique: QpzlX9DxM-23CEeF8S6WCw-1
Received: by mail-pg1-f200.google.com with SMTP id 17-20020a6317510000b0290207249fa354so11681380pgx.8
        for <linux-xfs@vger.kernel.org>; Wed, 21 Apr 2021 19:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=othbS4CIvWgJ8McaeVkm6FxgwuVQlQmsEj+LQDfjcqE=;
        b=pyNeFzK9KpoShzM+HqgURUrssakNyXm5VbJdCpJys5XyN9YeX1o+Ui434I6OrPFEaL
         Zv/cPEjtAcicsPTdfUjeLObQMCmNyA4B2G/3fISA4k9Yw6//2RApvQ/zGhfAYzDOfDfZ
         A0wARn0g6M8suxU9dkmaWoMKslhyFdieVW/90R2fDfdd5Oq/pV6QVsZ6s6+sPkcW61/I
         twKzxoDhOrkLyZLOy2SxOU7yO3seDI8QLZj96zMmgt8TmaJn+APtlYyhsanzia0vmWcT
         ufxj6/KOY1KtAXMkiUgY27hTSg91Jy5WwqPQBLwLqNOkyQO9v2e7Y4UFnt1eaBW+Xb85
         wt9Q==
X-Gm-Message-State: AOAM531rtDBnBaQp0nh9pkCiuNG391vvM+z/f2R4Hbg3cFS5/AWNiiqs
        e4J2099TdskdeCdCoOiaSQwxCTKGf1VaQWriGUnrY7MN7VW+kTwnVlmhdNThPT9C+O4zWnHIrDE
        cXDllNkoXDdoczOL3nddZ
X-Received: by 2002:a62:e315:0:b029:263:8436:e784 with SMTP id g21-20020a62e3150000b02902638436e784mr844354pfh.69.1619057184951;
        Wed, 21 Apr 2021 19:06:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIeYDZ6/1goafv0m5MIdbZoCEb8D3UfDtcsW6M0hEWKH8gKwSO2HffNipQnA1vT2p4jDArZQ==
X-Received: by 2002:a62:e315:0:b029:263:8436:e784 with SMTP id g21-20020a62e3150000b02902638436e784mr844337pfh.69.1619057184636;
        Wed, 21 Apr 2021 19:06:24 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a16sm538345pgl.12.2021.04.21.19.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 19:06:24 -0700 (PDT)
Date:   Thu, 22 Apr 2021 10:06:13 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210422020613.GB3264012@xiangao.remote.csb>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
 <20210420212506.GW63242@dread.disaster.area>
 <20210420215443.GA3047037@xiangao.remote.csb>
 <20210421014526.GY63242@dread.disaster.area>
 <20210421030129.GA3095436@xiangao.remote.csb>
 <20210422014446.GZ63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210422014446.GZ63242@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On Thu, Apr 22, 2021 at 11:44:46AM +1000, Dave Chinner wrote:
> On Wed, Apr 21, 2021 at 11:01:29AM +0800, Gao Xiang wrote:
> > On Wed, Apr 21, 2021 at 11:45:26AM +1000, Dave Chinner wrote:
> > > On Wed, Apr 21, 2021 at 05:54:43AM +0800, Gao Xiang wrote:
> > > #1 is bad because there are cases where we want to write the
> > > counters even for !lazysbcount filesystems (e.g. mkfs, repair, etc).
> > > 
> > > #2 is essentially a hack around the fact that mp->m_sb is not kept
> > > up to date in the in-memory superblock for !lazysbcount filesystems.
> > > 
> > > #3 keeps the in-memory superblock up to date for !lazysbcount case
> > > so they are coherent with the on-disk values and hence we only need
> > > to update the in-memory superblock counts for lazysbcount
> > > filesystems before calling xfs_sb_to_disk().
> > > 
> > > #3 is my preferred solution.
> > > 
> > > > That will indeed cause more modification, I'm not quite sure if it's
> > > > quite ok honestly. But if you assume that's more clear, I could submit
> > > > an alternative instead later.
> > > 
> > > I think the version you posted doesn't fix the entire problem. It
> > > merely slaps a band-aid over the symptom that is being seen, and
> > > doesn't address all the non-coherent data that can be written to the
> > > superblock here.
> > 
> > As I explained on IRC as well, I think for !lazysbcount cases, fdblocks,
> > icount and ifree are protected by sb buffer lock. and the only users of
> > these three are:
> >  1) xfs_trans_apply_sb_deltas()
> >  2) xfs_log_sb()
> 
> That's just a happy accident and not intentional in any way. Just
> fixing the case that occurs while holding the sb buffer lock doesn't
> actually fix the underlying problem, it just uses this as a bandaid.

I think for !lazysbcases, sb buffer lock is only a reliable lock that
can be relied on for serialzing (since we need to make sure each sb
write matches the corresponding fdblocks, ifree, icount. So sb buffer
needs be locked every time. So so need to recalc on dirty log.)
> 
> > 
> > So I've seen no need to update sb_icount, sb_ifree in that way (I mean
> > my v2, although I agree it's a bit hacky.) only sb_fdblocks matters.
> > 
> > But the reason why this patch exist is only to backport to old stable
> > kernels, since after [PATCH v2 2/2], we can get rid of all of
> > !lazysbcount cases upstream.
> > 
> > But if we'd like to do more e.g. by taking m_sb_lock, I've seen the
> > xfs codebase quite varies these years. and I modified some version
> > like http://paste.debian.net/1194481/
> 
> I said on IRC that this is what xfs_trans_unreserve_and_mod_sb() is
> for. For !lazysbcount filesystems the transaction will be marked
> dirty (i.e XFS_TRANS_SB_DIRTY is set) and so we'll always run the
> slow path that takes the m_sb_lock and updates mp->m_sb. 
> 
> It's faster for me to explain this by patch than any other way. See
> below.

I know what you mean, but there exists 3 things:
 1) we be64_add_cpu() on-disk fdblocks, ifree, icount at
    xfs_trans_apply_sb_deltas(), and then do the same bahavior in
    xfs_trans_unreserve_and_mod_sb() for in-memory counters again.
    that is (somewhat) fragile.

 2) m_sb_lock behaves no effect at this. This lock between
    xfs_log_sb() and xfs_trans_unreserve_and_mod_sb() is still
    sb buffer lock for !lazysbcount cases.

 3) in-memory sb counters are serialized by some spinlock now,
    so I'm not sure sb per-CPU counters behave for lazysbcount
    cases, are these used for better performance?

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: update superblock counters correctly for !lazysbcount
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Keep the mount superblock counters up to date for !lazysbcount
> filesystems so that when we log the superblock they do not need
> updating in any way because they are already correct.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 16 +++++++++++++---
>  fs/xfs/xfs_trans.c     |  3 +++
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 9630f9e2f540..7d4c238540d4 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -794,9 +794,19 @@ xfs_log_sb(
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
> index bcc978011869..438e41931b55 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -629,6 +629,9 @@ xfs_trans_unreserve_and_mod_sb(
>  
>  	/* apply remaining deltas */
>  	spin_lock(&mp->m_sb_lock);
> +	mp->m_sb.sb_fdblocks += blkdelta;

not sure that is quite equal to blkdelta, since (I think) we might need
to apply t_res_fdblocks_delta for !lazysbcount cases but not lazysbcount
cases, but I'm not quite sure, just saw the comment above
xfs_trans_unreserve_and_mod_sb() and the implementation of
xfs_trans_apply_sb_deltas().

Thanks,
Gao Xiang

> +	mp->m_sb.sb_icount += idelta;
> +	mp->m_sb.sb_ifree += ifreedelta;
>  	mp->m_sb.sb_frextents += rtxdelta;
>  	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
>  	mp->m_sb.sb_agcount += tp->t_agcount_delta;
> 

