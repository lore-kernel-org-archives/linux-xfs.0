Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45636 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750938AbeABXgS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jan 2018 18:36:18 -0500
Date: Wed, 3 Jan 2018 10:36:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/20] xfs: have buffer verifier functions report failing
 address
Message-ID: <20180102233615.GA5858@dastard>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
 <151399126186.23543.3819575446280820300.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151399126186.23543.3819575446280820300.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 05:07:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Modify each function that checks the contents of a metadata buffer to
> return the instruction address of the failing test so that we can report
> more precise failure errors to the log.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
......
> @@ -211,17 +211,34 @@ __xfs_dir3_data_check(
>  				stale++;
>  			if (i > 0 && be32_to_cpu(lep[i].hashval) <
>  				     be32_to_cpu(lep[i - 1].hashval))
> -				return false;
> +				return __this_address;
>  		}
>  		if (count != be32_to_cpu(btp->count) - be32_to_cpu(btp->stale))
> -			return false;
> +			return __this_address;
>  		if (stale != be32_to_cpu(btp->stale))
> -			return false;
> +			return __this_address;
>  	}
> -	return true;
> +	return NULL;
>  }
>  
> -static bool
> +#ifdef DEBUG
> +void
> +xfs_dir3_data_check(
> +	struct xfs_inode	*dp,
> +	struct xfs_buf		*bp)
> +{
> +	xfs_failaddr_t		fa;
> +
> +	fa = __xfs_dir3_data_check(dp, bp);
> +	if (!fa)
> +		return;
> +	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, dp->i_mount,
> +			bp->b_addr, __FILE__, __LINE__, fa);
> +	ASSERT(0);
> +}
> +#endif

So the only concern I have here is what {__FILE__, __LINE__} resolve
to. The macro gave us call site file/line, while this only gives us
the file/line in xfs_dir3_data_check(). Hence we won't know from the
corruption output what call to xfs_dir3_data_check() generated the
report. We can turn the error level up if we want a stack trace on
error from a production machine, so I can live with this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
