Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A28C4363D
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 18:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 715EA2086A
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 18:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LTqZoPwo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgIYSNx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 14:13:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbgIYSNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 14:13:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PI50W7087023;
        Fri, 25 Sep 2020 18:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IBy06mouCyiGFF06cD5T7Ka8egnyvLC2lubXzhd6aFU=;
 b=LTqZoPwoYPh7owoX/o2U7j0NFx1Yg25Axhmi6SMMFhRK3XiB72yWZLwzg9O4Iq0upO3Q
 DirvHCTjEQsY0xwqYd+UKWHnqR3h4Pm0fyAWHm/CBdlZmVDQq3eUjo68cjQ1uGwcQbdT
 WaFnmEFksFUry7gvXhDrkQhe5IbveAndVoOGrzglCfu3eV4Ph+l0CzVKMPiGkhGh0lnY
 1fKOFkjVjxYa+WOHKDdoxOl2aMYD6Xq4/y6TCln3IAODLEINz6wo9HQKyYQAhZIeQjLL
 nnTsjtqChJAPsOkAdPKMXjHM68balssn9ZEp5PeQPiAi6h0JObrUJRpuQgr2dvEOKvHL Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33ndnuy4me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 18:13:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PIAY5j032049;
        Fri, 25 Sep 2020 18:13:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 33s75k5k1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 18:13:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08PIDmEL001287;
        Fri, 25 Sep 2020 18:13:48 GMT
Received: from localhost (/10.159.232.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 11:13:48 -0700
Date:   Fri, 25 Sep 2020 11:13:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: remove deprecated mount options
Message-ID: <20200925181347.GL7955@magnolia>
References: <20200925165005.48903-1-preichl@redhat.com>
 <20200925165005.48903-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925165005.48903-2-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 25, 2020 at 06:50:04PM +0200, Pavel Reichl wrote:
> ikeep/noikeep was a workaround for old DMAPI code which is no longer
> relevant.
> 
> attr2/noattr2 - is for controlling upgrade behaviour from fixed attribute
> fork sizes in the inode (attr1) and dynamic attribute fork sizes (attr2).
> mkfs has defaulted to setting attr2 since 2007, hence just about every
> XFS filesystem out there in production right now uses attr2.
> 
> Signed-off-by: Pavel Reichl <preichl@redhat.com>
> ---
>  Documentation/admin-guide/xfs.rst |  2 ++
>  fs/xfs/xfs_super.c                | 31 ++++++++++++++++++-------------
>  2 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index f461d6c33534..717f63a3607a 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -217,6 +217,8 @@ Deprecated Mount Options
>  ===========================     ================
>    Name				Removal Schedule
>  ===========================     ================
> +  ikeep/noikeep			September 2025
> +  attr2/noattr2			September 2025
>  ===========================     ================
>  
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..1a04a03213c8 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1234,25 +1234,12 @@ xfs_fc_parse_param(
>  	case Opt_nouuid:
>  		mp->m_flags |= XFS_MOUNT_NOUUID;
>  		return 0;
> -	case Opt_ikeep:
> -		mp->m_flags |= XFS_MOUNT_IKEEP;
> -		return 0;
> -	case Opt_noikeep:
> -		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> -		return 0;
>  	case Opt_largeio:
>  		mp->m_flags |= XFS_MOUNT_LARGEIO;
>  		return 0;
>  	case Opt_nolargeio:
>  		mp->m_flags &= ~XFS_MOUNT_LARGEIO;
>  		return 0;
> -	case Opt_attr2:
> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> -		return 0;
> -	case Opt_noattr2:
> -		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> -		mp->m_flags |= XFS_MOUNT_NOATTR2;
> -		return 0;
>  	case Opt_filestreams:
>  		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
>  		return 0;
> @@ -1304,6 +1291,24 @@ xfs_fc_parse_param(
>  		xfs_mount_set_dax_mode(mp, result.uint_32);
>  		return 0;
>  #endif
> +	/* Following mount options well be removed on September 2025 */

well -> will, on -> in

I fixed that on commit, so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +	case Opt_ikeep:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags |= XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_noikeep:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_attr2:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +		return 0;
> +	case Opt_noattr2:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		mp->m_flags |= XFS_MOUNT_NOATTR2;
> +		return 0;
>  	default:
>  		xfs_warn(mp, "unknown mount option [%s].", param->key);
>  		return -EINVAL;
> -- 
> 2.26.2
> 
