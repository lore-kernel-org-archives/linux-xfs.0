Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3788C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA54120724
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 17:25:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HDcvFgCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHTRZU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:25:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43598 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgHTRZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 13:25:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KHN1JW167985;
        Thu, 20 Aug 2020 17:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CMqqQff8VLTGlR5+TX8GkMi4vQysYhGfbLK/IaokpeM=;
 b=HDcvFgCc6rIC91+ptxmw1tniqPrQlCLWVduyIvP6dFXcgxF6R3H/A0iSiTv56W1kY1Ny
 wyVitUGaEcvUqxxbEfoSYyu2tag+HheiAiNcTa1+aiSD1qFDbsToa+V06XcZltlaS8Nc
 VBSsePZOwR7+JNOUgfviI33MP9oCxSx4MBZHu9J/HDM7ftQEWEY6R4A815WOXgaHUZgo
 W5FES6vPeCTwSCv/si+1Oj3rIuWf+a7lMeEslsZrn1gZOjk+aU1i69lH72/pueVvDlTs
 gh7FjmRu6Q7hNd+0bhBr+iUjUlKlMuZSqdipaXYPulnKu92cfND86ssEBtadbOb8xBIW Xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32x74rhxt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 20 Aug 2020 17:25:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KHNtIL193143;
        Thu, 20 Aug 2020 17:25:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 330pvpn1ba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Aug 2020 17:25:14 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07KHPD8S028413;
        Thu, 20 Aug 2020 17:25:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 10:25:13 -0700
Date:   Thu, 20 Aug 2020 10:25:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix off-by-one in inode alloc block reservation
 calculation
Message-ID: <20200820172512.GJ6096@magnolia>
References: <20200820170734.200502-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820170734.200502-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=5 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=5 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 01:07:34PM -0400, Brian Foster wrote:
> The inode chunk allocation transaction reserves inobt_maxlevels-1
> blocks to accommodate a full split of the inode btree. A full split
> requires an allocation for every existing level and a new root
> block, which means inobt_maxlevels is the worst case block
> requirement for a transaction that inserts to the inobt. This can
> lead to a transaction block reservation overrun when tmpfile
> creation allocates an inode chunk and expands the inobt to its
> maximum depth. This problem has been observed in conjunction with
> overlayfs, which makes frequent use of tmpfiles internally.
> 
> The existing reservation code goes back as far as the Linux git repo
> history (v2.6.12). It was likely never observed as a problem because
> the traditional file/directory creation transactions also include
> worst case block reservation for directory modifications, which most
> likely is able to make up for a single block deficiency in the inode
> allocation portion of the calculation. tmpfile support is relatively
> more recent (v3.15), less heavily used, and only includes the inode
> allocation block reservation as tmpfiles aren't linked into the
> directory tree on creation.
> 
> Fix up the inode alloc block reservation macro and a couple of the
> block allocator minleft parameters that enforce an allocation to
> leave enough free blocks in the AG for a full inobt split.

Looks all fine to me, but... does a similar logic apply to the other
maxlevels uses in the kernel?

fs/xfs/libxfs/xfs_trans_resv.c:73:      blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
fs/xfs/libxfs/xfs_trans_resv.c:75:              blocks += max(num_ops * (2 * mp->m_rmap_maxlevels - 1),
fs/xfs/libxfs/xfs_trans_resv.c:78:              blocks += num_ops * (2 * mp->m_refc_maxlevels - 1);

Can we end up in the same kind of situation with those other trees
{bno,cnt,rmap,refc} where we have a maxlevels-1 tall tree and split each
level all the way to the top?

> Signed-off-by: Brian Foster <bfoster@redhat.com>

For this bit,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c      | 4 ++--
>  fs/xfs/libxfs/xfs_trans_space.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index f742a96a2fe1..a6b37db55169 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -688,7 +688,7 @@ xfs_ialloc_ag_alloc(
>  		args.minalignslop = igeo->cluster_align - 1;
>  
>  		/* Allow space for the inode btree to split. */
> -		args.minleft = igeo->inobt_maxlevels - 1;
> +		args.minleft = igeo->inobt_maxlevels;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  
> @@ -736,7 +736,7 @@ xfs_ialloc_ag_alloc(
>  		/*
>  		 * Allow space for the inode btree to split.
>  		 */
> -		args.minleft = igeo->inobt_maxlevels - 1;
> +		args.minleft = igeo->inobt_maxlevels;
>  		if ((error = xfs_alloc_vextent(&args)))
>  			return error;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
> index c6df01a2a158..7ad3659c5d2a 100644
> --- a/fs/xfs/libxfs/xfs_trans_space.h
> +++ b/fs/xfs/libxfs/xfs_trans_space.h
> @@ -58,7 +58,7 @@
>  #define	XFS_IALLOC_SPACE_RES(mp)	\
>  	(M_IGEO(mp)->ialloc_blks + \
>  	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
> -	  (M_IGEO(mp)->inobt_maxlevels - 1)))
> +	  M_IGEO(mp)->inobt_maxlevels))
>  
>  /*
>   * Space reservation values for various transactions.
> -- 
> 2.25.4
> 
