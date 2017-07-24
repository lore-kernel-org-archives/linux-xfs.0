Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36264 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbdGXPfG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 11:35:06 -0400
Date: Mon, 24 Jul 2017 08:33:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix quotacheck dquot id overflow infinite loop
Message-ID: <20170724153336.GA4352@magnolia>
References: <20170724150229.12549-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724150229.12549-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 11:02:29AM -0400, Brian Foster wrote:
> If a dquot has an id of U32_MAX, the next lookup index increment
> overflows the uint32_t back to 0. This starts the lookup sequence
> over from the beginning, repeats indefinitely and results in a
> livelock.
> 
> Update xfs_qm_dquot_walk() to explicitly check for the lookup
> overflow and exit the loop.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_qm.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 6ce948c..15751dc 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -111,6 +111,9 @@ xfs_qm_dquot_walk(
>  			skipped = 0;
>  			break;
>  		}
> +		/* we're done if id overflows back to zero */
> +		if (!next_index)
> +			break;
>  	}
>  
>  	if (skipped) {
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
