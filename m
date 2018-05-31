Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755753AbeEaRJj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 13:09:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4VH5sq0096045
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:39 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2j9ev87yqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4VH9cSm006517
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:39 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w4VH9cxd022374
        for <linux-xfs@vger.kernel.org>; Thu, 31 May 2018 17:09:38 GMT
Subject: Re: [PATCH 2/4] xfs: xfs_rtbuf_get should check the bmapi_read
 results
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
 <152778443693.6891.16527148773204429254.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <56ff1f92-65b6-d98b-dff1-52f4c0358d90@oracle.com>
Date: Thu, 31 May 2018 10:09:37 -0700
MIME-Version: 1.0
In-Reply-To: <152778443693.6891.16527148773204429254.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 05/31/2018 09:33 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The xfs_rtbuf_get function should check the block mapping it gets back
> from bmapi_read.  If there are no mappings or the mapping isn't a real
> extent, we should return -EFSCORRUPTED rather than trying to read a
> garbage value.  We also require realtime bitmap blocks to be real,
> written allocations.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/libxfs/xfs_rtbitmap.c |    3 +++
>   1 file changed, 3 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 106be2d0bb88..7712f282d172 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -90,6 +90,9 @@ xfs_rtbuf_get(
>   	if (error)
>   		return error;
>   
> +	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
> +		return -EFSCORRUPTED;
> +
>   	ASSERT(map.br_startblock != NULLFSBLOCK);
>   	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
>   				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
> 
Looks ok:
Reviewed by: Allison Henderson <allison.henderson@oracle.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=Nfk9xyeEu8tolNh3C6XthiC4BSuJcRRP0QGYJ_iBdDc&s=0bnHDf3AvXAlQ_rj_227qYXSraL5XP-OFUC8Mw3yI0E&e=
> 
