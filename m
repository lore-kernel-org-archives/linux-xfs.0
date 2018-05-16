Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:17724 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752240AbeEPBIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 21:08:44 -0400
Date: Wed, 16 May 2018 11:08:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix refactor quota limits initialization
Message-ID: <20180516010841.GO23861@dastard>
References: <20180516010108.GA23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516010108.GA23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Tue, May 15, 2018 at 06:01:08PM -0700, Darrick J. Wong wrote:
> dquot warning fields are be16, not be32.  Fix this mistake.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_qm.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 913d46d01bfc..c3e014bfc848 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -636,11 +636,11 @@ xfs_qm_init_timelimits(
>  	if (ddqp->d_rtbtimer)
>  		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
>  	if (ddqp->d_bwarns)
> -		qinf->qi_bwarnlimit = be32_to_cpu(ddqp->d_bwarns);
> +		qinf->qi_bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
>  	if (ddqp->d_iwarns)
> -		qinf->qi_iwarnlimit = be32_to_cpu(ddqp->d_iwarns);
> +		qinf->qi_iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
>  	if (ddqp->d_rtbwarns)
> -		qinf->qi_rtbwarnlimit = be32_to_cpu(ddqp->d_rtbwarns);
> +		qinf->qi_rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

FWIW, this points out that we need to start de-typedef-ing the quota
code as well clean it up. We've been pretty good about this in the
rest of the XFS code over the years, perhaps it's time for the quota
code to catch up?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
