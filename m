Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfFUQzP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 12:55:15 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGiM0g057984
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 16:55:13 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t7809qgk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 16:55:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGrTfD095747
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 16:55:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2t7rdxugge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 16:55:13 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LGtC8J025644
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2019 16:55:12 GMT
Subject: Re: [PATCH 1/2] xfs: refactor free space btree record initialization
References: <156105616866.1200596.7212155126558008316.stgit@magnolia>
 <156105617569.1200596.13164807309283607454.stgit@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <3a5790e5-6d80-706b-a67e-64c2083f1737@oracle.com>
Date: Fri, 21 Jun 2019 09:55:10 -0700
MIME-Version: 1.0
In-Reply-To: <156105617569.1200596.13164807309283607454.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:42 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that populates the free space btrees of a new AG so
> that we can avoid code duplication once things start getting
> complicated.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Looks fine
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   fs/xfs/libxfs/xfs_ag.c |   27 ++++++++++++++++-----------
>   1 file changed, 16 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 5efb82744664..80a3df7ccab3 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -56,37 +56,42 @@ xfs_btroot_init(
>   	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
>   }
>   
> -/*
> - * Alloc btree root block init functions
> - */
> +/* Finish initializing a free space btree. */
>   static void
> -xfs_bnoroot_init(
> +xfs_freesp_init_recs(
>   	struct xfs_mount	*mp,
>   	struct xfs_buf		*bp,
>   	struct aghdr_init_data	*id)
>   {
>   	struct xfs_alloc_rec	*arec;
>   
> -	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
>   	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>   	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
>   	arec->ar_blockcount = cpu_to_be32(id->agsize -
>   					  be32_to_cpu(arec->ar_startblock));
>   }
>   
> +/*
> + * Alloc btree root block init functions
> + */
>   static void
> -xfs_cntroot_init(
> +xfs_bnoroot_init(
>   	struct xfs_mount	*mp,
>   	struct xfs_buf		*bp,
>   	struct aghdr_init_data	*id)
>   {
> -	struct xfs_alloc_rec	*arec;
> +	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
> +	xfs_freesp_init_recs(mp, bp, id);
> +}
>   
> +static void
> +xfs_cntroot_init(
> +	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp,
> +	struct aghdr_init_data	*id)
> +{
>   	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
> -	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
> -	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> -	arec->ar_blockcount = cpu_to_be32(id->agsize -
> -					  be32_to_cpu(arec->ar_startblock));
> +	xfs_freesp_init_recs(mp, bp, id);
>   }
>   
>   /*
> 
