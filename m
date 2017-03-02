Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:17350 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdCBXTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Mar 2017 18:19:38 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v22NJadF009551
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 2 Mar 2017 23:19:36 GMT
Date: Thu, 2 Mar 2017 15:18:29 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Use xfs_icluster_size_fsb() to calculate inode
 alignment mask
Message-ID: <20170302231828.GD24806@birch.djwong.org>
References: <1488275816-26711-1-git-send-email-chandan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488275816-26711-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Feb 28, 2017 at 03:26:56PM +0530, Chandan Rajendra wrote:
> When block size is larger than inode cluster size, the call to
> XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size) returns 0. Also, mkfs.xfs
> would have set xfs_sb->sb_inoalignmt to 0. Hence in
> xfs_set_inoalignment(), xfs_mount->m_inoalign_mask gets initialized to
> -1 instead of 0. However, xfs_mount->m_sinoalign would get correctly
> intialized to 0 because for every positive value of xfs_mount->m_dalign,
> the condition "!(mp->m_dalign & mp->m_inoalign_mask)" would evaluate to
> false.
> 
> Also, xfs_imap() worked fine even with xfs_mount->m_inoalign_mask having
> -1 as the value because blks_per_cluster variable would have the value 1
> and hence we would never have a need to use xfs_mount->m_inoalign_mask
> to compute the inode chunk's agbno and offset within the chunk.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 450bde6..688ebff 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -513,8 +513,7 @@ STATIC void
>  xfs_set_inoalignment(xfs_mount_t *mp)
>  {
>  	if (xfs_sb_version_hasalign(&mp->m_sb) &&
> -	    mp->m_sb.sb_inoalignmt >=
> -	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
> +		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
>  		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
>  	else
>  		mp->m_inoalign_mask = 0;
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
