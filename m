Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64ABAC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 21:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F69E613F5
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Apr 2021 21:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbhDTVZo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Apr 2021 17:25:44 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:55006 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233769AbhDTVZo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 17:25:44 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 6113C1035B2;
        Wed, 21 Apr 2021 07:25:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lYxrm-00HStI-N4; Wed, 21 Apr 2021 07:25:06 +1000
Date:   Wed, 21 Apr 2021 07:25:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 1/2] xfs: don't use in-core per-cpu fdblocks for
 !lazysbcount
Message-ID: <20210420212506.GW63242@dread.disaster.area>
References: <20210420110855.2961626-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420110855.2961626-1-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=YZ6mlx84j0dY4G8EoTsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
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

THis really needs a comment explaining why this is done this way.
It's not obvious from reading the code why we pull the the fdblock
count off disk and then, in  xfs_sb_to_disk(), we write it straight
back to disk.

It's also not clear to me that summing the inode counters is correct
in the case of the !lazysbcount for the similar reasons - the percpu
counter is not guaranteed to be absolutely accurate here, yet the
values in the disk buffer are. Perhaps we should be updating the
m_sb values in xfs_trans_apply_sb_deltas() for the !lazycount case,
and only summing them here for the lazycount case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
