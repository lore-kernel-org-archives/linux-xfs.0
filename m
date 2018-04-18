Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752093AbeDRSd7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Apr 2018 14:33:59 -0400
Date: Wed, 18 Apr 2018 14:33:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/11] xfs: report failing address when dquot verifier
 fails
Message-ID: <20180418183357.GB22375@bfoster.bfoster>
References: <152401916729.11465.4212188839231900136.stgit@magnolia>
 <152401918598.11465.13251754451621038930.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152401918598.11465.13251754451621038930.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 17, 2018 at 07:39:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Pass the failing address through to the corruption report when dquot
> verifiers fail.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_dquot_buf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 8b7a6c3..a1e6cf1 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -229,7 +229,7 @@ xfs_dquot_buf_read_verify(
>  	else {
>  		fa = xfs_dquot_buf_verify(mp, bp);
>  		if (fa)
> -			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> +			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  	}
>  }
>  
> @@ -266,7 +266,7 @@ xfs_dquot_buf_write_verify(
>  
>  	fa = xfs_dquot_buf_verify(mp, bp);
>  	if (fa)
> -		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> +		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
>  }
>  
>  const struct xfs_buf_ops xfs_dquot_buf_ops = {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
