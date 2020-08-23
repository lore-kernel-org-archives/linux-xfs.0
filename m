Return-Path: <SRS0=zZWs=CB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046AEC433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 23:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA56D206C1
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 23:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgHWX5q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 19:57:46 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:38685 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbgHWX5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 19:57:46 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 34DA0D5BEB0;
        Mon, 24 Aug 2020 09:57:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k9zrl-0000m1-K4; Mon, 24 Aug 2020 09:57:37 +1000
Date:   Mon, 24 Aug 2020 09:57:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 02/11] xfs: refactor quota expiration timer modification
Message-ID: <20200823235737.GK7941@dread.disaster.area>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797590052.965217.10856208107922013686.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797590052.965217.10856208107922013686.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=CN6GEEx5FsJba2YsiFUA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:11:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Define explicit limits on the range of quota grace period expiration
> timeouts and refactor the code that modifies the timeouts into helpers
> that clamp the values appropriately.  Note that we'll deal with the
> grace period timer separately.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |   22 ++++++++++++++++++++++
>  fs/xfs/xfs_dquot.c         |   13 ++++++++++++-
>  fs/xfs/xfs_dquot.h         |    2 ++
>  fs/xfs/xfs_ondisk.h        |    2 ++
>  fs/xfs/xfs_qm_syscalls.c   |    9 +++++++--
>  5 files changed, 45 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b1b8a5c05cea..ef36978239ac 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1197,6 +1197,28 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  
>  #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
>  
> +/*
> + * XFS Quota Timers
> + * ================
> + *
> + * Quota grace period expiration timers are an unsigned 32-bit seconds counter;
> + * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
> + * of zero means that the quota limit has not been reached, and therefore no
> + * expiration has been set.
> + */
> +
> +/*
> + * Smallest possible quota expiration with traditional timestamps, which is
> + * Jan  1 00:00:01 UTC 1970.
> + */
> +#define XFS_DQ_TIMEOUT_MIN	((int64_t)1)
> +
> +/*
> + * Largest possible quota expiration with traditional timestamps, which is
> + * Feb  7 06:28:15 UTC 2106.
> + */
> +#define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)

Same as last patch - these reference the unix epoch, so perhaps
they should be named that way....

>   * This is the main portion of the on-disk representation of quota information
>   * for a user.  We pad this with some more expansion room to construct the on
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index bcd73b9c2994..2425b1c30d11 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -98,6 +98,16 @@ xfs_qm_adjust_dqlimits(
>  		xfs_dquot_set_prealloc_limits(dq);
>  }
>  
> +/* Set the expiration time of a quota's grace period. */
> +void
> +xfs_dquot_set_timeout(
> +	time64_t		*timer,
> +	time64_t		value)
> +{
> +	*timer = clamp_t(time64_t, value, XFS_DQ_TIMEOUT_MIN,
> +					  XFS_DQ_TIMEOUT_MAX);
> +}
> +

Not sure I see any benefit in passing *timer as a parameter over
just returning a time64_t value...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
