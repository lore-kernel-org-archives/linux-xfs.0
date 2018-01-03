Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:7454 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751029AbeACAoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 19:44:20 -0500
Date: Wed, 3 Jan 2018 11:44:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/20] xfs: standardize quota verification function
 outputs
Message-ID: <20180103004417.GG5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399133641.23543.18383563898958249777.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399133641.23543.18383563898958249777.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:08:56PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rename xfs_dqcheck to xfs_dquot_verify and make it return an
> xfs_failaddr_t like every other structure verifier function.
> This enables us to check on-disk quotas in the same way that we check
> everything else.  Callers are now responsible for logging errors, as
> XFS_QMOPT_DOWARN goes away.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

One minor nit:

> @@ -2701,11 +2701,14 @@ xlog_recover_do_reg_buffer(
>  					item->ri_buf[i].i_len, __func__);
>  				goto next;
>  			}
> -			error = xfs_dqcheck(mp, item->ri_buf[i].i_addr,
> -					       -1, 0, XFS_QMOPT_DOWARN,
> -					       "dquot_buf_recover");
> -			if (error)
> +			fa = xfs_dquot_verify(mp, item->ri_buf[i].i_addr,
> +					       -1, 0, 0);
> +			if (fa) {
> +				xfs_alert(mp,
> +					"dquot corrupt at %pS trying to replay into block 0x%llx",
> +					fa, bp->b_bn);
>  				goto next;
> +			}

Alert message line too long here, just pull the indent back for
it...

Otherwise it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
