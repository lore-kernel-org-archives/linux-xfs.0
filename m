Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38532 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751874AbdDQTAK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Apr 2017 15:00:10 -0400
Date: Mon, 17 Apr 2017 11:59:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove use of do_div with 32-bit dividend in quota
 debug code
Message-ID: <20170417185959.GA5193@birch.djwong.org>
References: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6022a70-8f09-633d-e99a-30186ea8c3d2@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Apr 15, 2017 at 09:46:09AM -0500, Eric Sandeen wrote:
> The kbuild test robot caught this; in debug code we have another
> caller of do_div with a 32-bit dividend (j) which is caught now
> that we are using the kernel-supplied do_div.
> 
> None of the values used here are 64-bit; just use simple division.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index b669b12..dedeb7f 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -851,8 +851,7 @@ struct xfs_qm_isolate {
>  	 * started afresh by xfs_qm_quotacheck.
>  	 */
>  #ifdef DEBUG
> -	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> -	do_div(j, sizeof(xfs_dqblk_t));
> +	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) / sizeof(xfs_dqblk_t);

Uh...

#define XFS_FSB_TO_B(mp,fsbno)   ((xfs_fsize_t)(fsbno) << (mp)->m_sb.sb_blocklog)
typedef    __int64_t       xfs_fsize_t;    /* bytes in a file */

So the macro resolves to a 64-bit value, which is then fed directly into
an integer division, which breaks the i386 build with the usual __divdi3
complaint.

--D

>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>  #endif
>  	dqb = bp->b_addr;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
