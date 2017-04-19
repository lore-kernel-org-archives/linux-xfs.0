Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23953 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1765235AbdDSUBX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 16:01:23 -0400
Date: Wed, 19 Apr 2017 13:01:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: remove use of do_div with 32-bit dividend in
 quota debug code
Message-ID: <20170419200116.GL5193@birch.djwong.org>
References: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
 <e54544bf-9662-fa91-40b6-69a284aa66e2@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e54544bf-9662-fa91-40b6-69a284aa66e2@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 19, 2017 at 02:41:07PM -0500, Eric Sandeen wrote:
> The kbuild test robot caught this; in debug code we have another
> caller of do_div with a 32-bit dividend (j) which is caught now
> that we are using the kernel-supplied do_div.
> 
> None of the values used here are 64-bit; just use simple division.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, will throw it on the testing pile...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Seems to build ok on i386 too.)

--D

> ---
> 
> V2: now with less actual 64-bit division!
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b669b12..6b42db4 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -851,8 +851,8 @@ struct xfs_qm_isolate {
>  	 * started afresh by xfs_qm_quotacheck.
>  	 */
>  #ifdef DEBUG
> -	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> -	do_div(j, sizeof(xfs_dqblk_t));
> +	j = (int)XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) /
> +		sizeof(xfs_dqblk_t);
>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>  #endif
>  	dqb = bp->b_addr;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
