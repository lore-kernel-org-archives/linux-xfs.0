Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27081C4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0766860F58
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 05:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhHEFgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 01:36:42 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43059 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229525AbhHEFgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Aug 2021 01:36:42 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id E30C980C2A1;
        Thu,  5 Aug 2021 15:36:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBW3N-00Egcl-0l; Thu, 05 Aug 2021 15:36:25 +1000
Date:   Thu, 5 Aug 2021 15:36:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 08/14] xfs: queue inactivation immediately when free
 realtime extents are tight
Message-ID: <20210805053625.GY2757197@dread.disaster.area>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
 <162812922691.2589546.7668598169022490963.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162812922691.2589546.7668598169022490963.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=YhoWDECF3YfeS8cTOu4A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 07:07:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have made the inactivation of unlinked inodes a background
> task to increase the throughput of file deletions, we need to be a
> little more careful about how long of a delay we can tolerate.
> 
> Similar to the patch doing this for free space on the data device, if
> the file being inactivated is a realtime file and the realtime volume is
> running low on free extents, we want to run the worker ASAP so that the
> realtime allocator can make better decisions.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   24 ++++++++++++++++++++++++
>  fs/xfs/xfs_mount.c  |   13 ++++++++-----
>  fs/xfs/xfs_mount.h  |    3 ++-
>  3 files changed, 34 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index e5e90f09bcc6..4a062cf689c3 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1924,6 +1924,27 @@ xfs_inodegc_start(
>  	xfs_inodegc_queue_all(mp);
>  }
>  
> +#ifdef CONFIG_XFS_RT
> +static inline bool
> +xfs_inodegc_want_queue_rt_file(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	uint64_t		freertx;
> +
> +	if (!XFS_IS_REALTIME_INODE(ip))
> +		return false;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	freertx = mp->m_sb.sb_frextents;
> +	spin_unlock(&mp->m_sb_lock);

READ_ONCE() is probably sufficient here. We're not actually
serialising this against any specific operation, so I don't think
the lock is necessary to sample the value.

Other than that, all good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
