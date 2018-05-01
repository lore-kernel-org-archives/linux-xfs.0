Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59036 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756016AbeEAQYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 12:24:11 -0400
Date: Tue, 1 May 2018 09:24:07 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: delay quota timelimit init until after
 quotacheck
Message-ID: <20180501162407.GI4127@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <49eeb340-2ff2-c274-d26b-fd8edd982d61@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49eeb340-2ff2-c274-d26b-fd8edd982d61@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 02:12:40PM -0500, Eric Sandeen wrote:
> Initializing the time limits in the quota info requires reading
> the default quota block.  If it's corrupt, this yields even more
> dmesg spew before kernelspace gets around to properly detecting
> and repairing the corruption.
> 
> If we move the read and initialization until post-quotacheck,
> we can avoid the noisy read if it's corrupted.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_qm.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index a4da46c..95487cb4 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -698,9 +698,9 @@ struct xfs_qm_isolate {
>  	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
>  	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
>  
> -	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
> +	/* Default quota will be read post-quotacheck to set timelimits */
>  
> -	xfs_qm_set_timelimits(mp, qinf);
> +	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
>  
>  	qinf->qi_shrinker.scan_objects = xfs_qm_shrink_scan;
>  	qinf->qi_shrinker.seeks = DEFAULT_SEEKS;
> @@ -1469,6 +1469,10 @@ struct xfs_qm_isolate {
>  			return;
>  		}
>  	}
> +
> +	/* Now that quotacheck is done, set time limits */
> +	xfs_qm_set_timelimits(mp, mp->m_quotainfo);
> +
>  	/*
>  	 * If one type of quotas is off, then it will lose its
>  	 * quotachecked status, since we won't be doing accounting for
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
