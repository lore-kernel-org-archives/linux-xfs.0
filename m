Return-Path: <SRS0=zZWs=CB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED88C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 23:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB2C6206C1
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 23:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgHWXyi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 19:54:38 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:59676 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726817AbgHWXyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 19:54:37 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id D75FF1AA313;
        Mon, 24 Aug 2020 09:54:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k9zoj-0000lI-US; Mon, 24 Aug 2020 09:54:29 +1000
Date:   Mon, 24 Aug 2020 09:54:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 01/11] xfs: explicitly define inode timestamp range
Message-ID: <20200823235429.GJ7941@dread.disaster.area>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797589388.965217.3068074933916806311.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797589388.965217.3068074933916806311.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=7-415B0cAAAA:8 a=OymTOJSBuDQEfvqSlZAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:11:34PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Formally define the inode timestamp ranges that existing filesystems
> support, and switch the vfs timetamp ranges to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |   19 +++++++++++++++++++
>  fs/xfs/xfs_ondisk.h        |   12 ++++++++++++
>  fs/xfs/xfs_super.c         |    5 +++--
>  3 files changed, 34 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index be86fa1a5556..b1b8a5c05cea 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -849,11 +849,30 @@ struct xfs_agfl {
>  	    ASSERT(xfs_daddr_to_agno(mp, d) == \
>  		   xfs_daddr_to_agno(mp, (d) + (len) - 1)))
>  
> +/*
> + * XFS Timestamps
> + * ==============
> + *
> + * Inode timestamps consist of signed 32-bit counters for seconds and
> + * nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC 1970.
> + */
>  typedef struct xfs_timestamp {
>  	__be32		t_sec;		/* timestamp seconds */
>  	__be32		t_nsec;		/* timestamp nanoseconds */
>  } xfs_timestamp_t;
>  
> +/*
> + * Smallest possible timestamp with traditional timestamps, which is
> + * Dec 13 20:45:52 UTC 1901.
> + */
> +#define XFS_INO_TIME_MIN	((int64_t)S32_MIN)
> +
> +/*
> + * Largest possible timestamp with traditional timestamps, which is
> + * Jan 19 03:14:07 UTC 2038.
> + */
> +#define XFS_INO_TIME_MAX	((int64_t)S32_MAX)

These are based on the Unix epoch. Can we call them something like
XFS_INO_UNIX_TIME_{MIN,MAX} to indicate what epoch they reference?

>  /*
>   * On-disk inode structure.
>   *
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index acb9b737fe6b..48a64fa49f91 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -15,6 +15,18 @@
>  		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
>  		"expected " #off)
>  
> +#define XFS_CHECK_VALUE(value, expected) \
> +	BUILD_BUG_ON_MSG((value) != (expected), \
> +		"XFS: value of " #value " is wrong, expected " #expected)
> +
> +static inline void __init
> +xfs_check_limits(void)
> +{
> +	/* make sure timestamp limits are correct */
> +	XFS_CHECK_VALUE(XFS_INO_TIME_MIN,			-2147483648LL);
> +	XFS_CHECK_VALUE(XFS_INO_TIME_MAX,			2147483647LL);
> +}

Not sure this really gains us anything? All it does is check that
S32_MIN/S32_MAX haven't changed value....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
