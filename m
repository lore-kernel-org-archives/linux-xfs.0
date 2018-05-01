Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43738 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755877AbeEAQXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 12:23:41 -0400
Date: Tue, 1 May 2018 09:23:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/6] xfs: quieter quota initialization with bad dquots
Message-ID: <20180501162321.GG4127@magnolia>
References: <f0856054-551f-9139-39f7-1d5439910903@sandeen.net>
 <2ce33875-44dc-539c-50a9-c8808bd4b185@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce33875-44dc-539c-50a9-c8808bd4b185@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 04, 2018 at 02:06:17PM -0500, Eric Sandeen wrote:
> As of now, when we start quotacheck we read quotas with verifiers,
> then reread without them, if we saw corruption.  This is so the
> corruption is noted in the logs; this is all well and good, except that
> the verifier errors instruct the user to run xfs_repair, which won't
> actually do anything for corrupt dqblks.
> 
> We can quiet this down by doing the initial read without verifiers,
> knowing that we're going to validate the dqblks manually in later
> stages, and repair them if needed.
> 
> This adds new (more terse) messages stating whether a corrupted
> dquot was found and fixed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> I'm a bit on the fence about this one; we lose the hexdump too so we won't
> see what was wrong (I could add that back in, I suppose).
> 
>  fs/xfs/libxfs/xfs_dquot_buf.c |  4 ++++
>  fs/xfs/xfs_qm.c               | 30 +++++++++++++-----------------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 9f8b2c5..c13d440 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -136,6 +136,10 @@
>  				 XFS_DQUOT_CRC_OFF);
>  	}
>  
> +	xfs_alert(mp, "Repaired %s quota block for id %d.",
> +		  type == XFS_DQ_USER ? "user" :
> +		    (type == XFS_DQ_GROUP ? "group" : "project"), id);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b422382..328d770 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -868,8 +868,12 @@ struct xfs_qm_isolate {
>  		 * xfs_dquot_verify.
>  		 */
>  		fa = xfs_dquot_verify(mp, &dqb[j], id + j, type);
> -		if (fa)
> +		if (fa) {
> +			xfs_alert(mp,
> +"Metadata corruption error detected at %pS, xfs_dquot block 0x%llx.",
> +				  __this_address, bp->b_bn);
>  			xfs_dquot_repair(mp, &dqb[j], id + j, type);
> +		}
>  
>  		/*
>  		 * Reset type in case we are reusing group quota file for
> @@ -922,24 +926,16 @@ struct xfs_qm_isolate {
>  	 * everything if we were to crash in the middle of this loop.
>  	 */
>  	while (blkcnt--) {
> -		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> -			      XFS_FSB_TO_DADDR(mp, bno),
> -			      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> -			      &xfs_dquot_buf_ops);
> -
>  		/*
> -		 * CRC and validation errors will return a EFSCORRUPTED here. If
> -		 * this occurs, re-read without CRC validation so that we can
> -		 * repair the damage via xfs_qm_reset_dqcounts(). This process
> -		 * will leave a trace in the log indicating corruption has
> -		 * been detected.
> +		 * CRC and validation errors are possible here.  Because
> +		 * this may occur, we read without CRC validation so that we can
> +		 * repair the damage via xfs_qm_reset_dqcounts().
> +		 * Errors will be detected, declared, and repaired later in the
> +		 * quotacheck process.
>  		 */
> -		if (error == -EFSCORRUPTED) {
> -			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> -				      XFS_FSB_TO_DADDR(mp, bno),
> -				      mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> -				      NULL);
> -		}
> +		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
> +			      XFS_FSB_TO_DADDR(mp, bno),
> +			      mp->m_quotainfo->qi_dqchunklen, 0, &bp, NULL);
>  
>  		if (error)
>  			break;
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
