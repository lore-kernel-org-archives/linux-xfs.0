Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33779 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729331AbfDQVwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 17:52:30 -0400
Date: Thu, 18 Apr 2019 07:52:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: allow scrubbers to pause background reclaim
Message-ID: <20190417215228.GS29573@dread.disaster.area>
References: <155546519998.176278.8300210828717055034.stgit@magnolia>
 <155546521227.176278.16067700926705972688.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155546521227.176278.16067700926705972688.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 16, 2019 at 06:40:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The forthcoming summary counter patch races with regular filesystem
> activity to compute rough expected values for the counters.  This design
> was chosen to avoid having to freeze the entire filesystem to check the
> counters, but while that's running we'd prefer to minimize background
> reclamation activity to reduce the perturbations to the incore free
> block count.  Therefore, provide a way for scrubbers to disable
> background posteof and cowblock reclamation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/common.c |   18 ++++++++++++++++++
>  fs/xfs/scrub/common.h |    2 ++
>  fs/xfs/scrub/scrub.c  |    2 ++
>  fs/xfs/scrub/scrub.h  |    1 +
>  4 files changed, 23 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 7076d5c98151..a406a22a734f 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -894,3 +894,21 @@ xchk_ilock_inverted(
>  	}
>  	return -EDEADLOCK;
>  }
> +
> +/* Pause background reclamation and inactivation. */
> +void
> +xchk_disable_reclaim(
> +	struct xfs_scrub	*sc)
> +{
> +	sc->flags |= XCHK_RECLAIM_DISABLED;
> +	xfs_icache_disable_reclaim(sc->mp);
> +}

Hmmm. Poorly named function.  "reclaim" in the context of
xfs_icache.c means inode cache reclaim...

We're not actually disabling inode reclaim here, we
are disabling background block reaping.

Can we change this all to be named more appropriately (including the
icache.c functions? Then it is all fine because I don't look at
it and think "that'll break under memory pressure"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
