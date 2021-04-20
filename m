Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1CAC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81090613C9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 17:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhDTRnT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 13:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhDTRnT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Apr 2021 13:43:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5833E613C4;
        Tue, 20 Apr 2021 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618940567;
        bh=61MehX9uvJpHK4zo2OnSq5r86sOrizyZ4KEIHaUzw5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VRyZQfAu2uKpk+VbLMccosDp90BuV+YCEevwgyju6ALi4mWLaeQ+wUuAO0FE2bIlm
         v4md0zFhvfdztGhLOyvF5HVPZaQn/gXMy7kYOUd/d4iE2EEn0AqGAOYnMfoU/ew/Ac
         U8EPPHaKnmQV22Lf3WW5hlR4lDX4HpwnoEtA3om0kXt8RR0rPztiEveVLsPH0SwEEU
         jjoLlzMml70kT2OeVV+3ZcQptSnIvNikvCxllV+tSL+hbuTmAlGBojLMcLLz0qXwkP
         mXxu09z4DH53jg3J6R9MM47Eiirbqy6W5q+kA+12FPCsWLkkpluY8HNfRLs2QSXRmg
         94cRppBduIW2g==
Date:   Tue, 20 Apr 2021 10:42:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210420174246.GP3122264@magnolia>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420110855.2961626-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 20, 2021 at 07:08:54PM +0800, Gao Xiang wrote:
> There are many paths which could trigger xfs_log_sb(), e.g.
>   xfs_bmap_add_attrfork()
>     -> xfs_log_sb()
> , which overrides on-disk fdblocks by in-core per-CPU fdblocks.
> 
> However, for !lazysbcount cases, on-disk fdblocks is actually updated
> by xfs_trans_apply_sb_deltas(), and generally it isn't equal to
> in-core per-CPU fdblocks due to xfs_reserve_blocks() or whatever,
> see the comment in xfs_unmountfs().
> 
> It could be observed by the following steps reported by Zorro:
> 
> 1. mkfs.xfs -f -l lazy-count=0 -m crc=0 $dev
> 2. mount $dev $mnt
> 3. fsstress -d $mnt -p 100 -n 1000 (maybe need more or less io load)
> 4. umount $mnt
> 5. xfs_repair -n $dev
> 
> yet due to commit f46e5a174655 ("xfs: fold sbcount quiesce logging
> into log covering"), xfs_sync_sb() will also be triggered if log
> covering is needed and !lazysbcount when xfs_unmountfs(), so hard
> to reproduce on kernel 5.12+ for clean unmount.
> 
> on-disk sb_icount and sb_ifree are also updated in
> xfs_trans_apply_sb_deltas() for !lazysbcount cases, however, which
> are always equal to per-CPU counters, so only fdblocks matters.
> 
> After this patch, I've seen no strange so far on older kernels
> for the testcase above without lazysbcount.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Still seems a bit roundabout to me, but fmeh, this is all deprecated
anyways, so:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> changes since v1:
>  - update commit message.
> 
>  fs/xfs/libxfs/xfs_sb.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 60e6d255e5e2..423dada3f64c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -928,7 +928,13 @@ xfs_log_sb(
>  
>  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> -	mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	if (!xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +		struct xfs_dsb	*dsb = bp->b_addr;
> +
> +		mp->m_sb.sb_fdblocks = be64_to_cpu(dsb->sb_fdblocks);
> +	} else {
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> -- 
> 2.27.0
> 
