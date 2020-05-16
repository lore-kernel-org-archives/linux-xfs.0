Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F39C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1D1B2076A
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 18:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XUjBMxOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgEPSHp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 14:07:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58726 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbgEPSHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 14:07:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GI6x9l064177;
        Sat, 16 May 2020 18:07:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xCzZflf1jVLHzcNmTe+KFkGF0ASZqtfcCIr5R+Ap8YM=;
 b=XUjBMxOO1gH2jBgEE8KG17TENJ7tca8/CAxWkrCofNR0n2Q+5kKcvEIGkYieVl0VbcAa
 jTO78AgrTKSVWKCUftPFZP/Z0p8Q4OCDTFzh9YZwO1S5G4Y6ai1RcxAp/3JlDGuUPxmb
 0sQ5LRDYcB1BizdjxF6Qt2JIA6sjEmQ2K7Mm0SYiqyoM8FJN0beJWzk7docETiGH084o
 E9TYi76fq5TCH0nJlsCPiRDDgDZnQzqplPac+4Gj2a+Ui8l5KkJfFA1GBVPEy1r6/7sT
 bwqiZRXYDUj3b7KDPJZcSIA6hACQkhRBtF4vcPOGSdECl823LGMR3VUyRBZT1/IDmBfo Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127kqsg47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 18:07:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHwGMB022245;
        Sat, 16 May 2020 18:07:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 312679dxwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 18:07:40 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04GI7di9015616;
        Sat, 16 May 2020 18:07:39 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 11:07:38 -0700
Date:   Sat, 16 May 2020 11:07:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: remove xfs_ifree_local_data
Message-ID: <20200516180736.GE6714@magnolia>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510072404.986627-4-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=5 spamscore=0
 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005160162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 10, 2020 at 09:24:01AM +0200, Christoph Hellwig wrote:
> xfs_ifree only need to free inline data in the data fork, as we've
> already taken care of the attr fork before (and in fact freed the
> fork structure).  Just open code the freeing of the inline data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 549ff468b7b60..7d3144dc99b72 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2711,24 +2711,6 @@ xfs_ifree_cluster(
>  	return 0;
>  }
>  
> -/*
> - * Free any local-format buffers sitting around before we reset to
> - * extents format.
> - */
> -static inline void
> -xfs_ifree_local_data(
> -	struct xfs_inode	*ip,
> -	int			whichfork)
> -{
> -	struct xfs_ifork	*ifp;
> -
> -	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> -		return;
> -
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
> -}
> -
>  /*
>   * This is called to return an inode to the inode free list.
>   * The inode should already be truncated to 0 length and have
> @@ -2765,8 +2747,16 @@ xfs_ifree(
>  	if (error)
>  		return error;
>  
> -	xfs_ifree_local_data(ip, XFS_DATA_FORK);
> -	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
> +	/*
> +	 * Free any local-format data sitting around before we reset the
> +	 * data fork to extents format.  Note that the attr fork data has
> +	 * already been freed by xfs_attr_inactive.
> +	 */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		kmem_free(ip->i_df.if_u1.if_data);
> +		ip->i_df.if_u1.if_data = NULL;
> +		ip->i_df.if_bytes = 0;
> +	}
>  
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
> -- 
> 2.26.2
> 
