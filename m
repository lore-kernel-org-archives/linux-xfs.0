Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1719AC4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF419238D6
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 17:28:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lmyv+c9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgIXR2G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 13:28:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48098 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbgIXR2G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 13:28:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OHIp4x171314;
        Thu, 24 Sep 2020 17:28:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=jnDJz/EHNfRtC2mWM3lsafg+HVi/555NdvF4FpN2DyU=;
 b=lmyv+c9f+zQnP1wVYyRMG0dcgITd0qISMcmkYTmQWDr5dksbXD0UaC+Ds5SDIC3w0Kv9
 gGLxRwI0cMVZMG+LHvPUOdTEcePfCKB3UsRVCODiX5YSet3lUmMIrnnEuqQt48uRMVR3
 LUnSgMYmoT31q3J8qRy0fJLA5Uk2qqvRivqxqLX+W2huFcIa0QBd24b408QDkey6tR3k
 jECZOGgvuaaBh2iAu9UCD4DE2dwhDicm/XoSz1SOolY4v0pScQNgabKzpGBPldhT/Yt7
 jS4uguG8nvTXkbu3+VJlqrm1MkVp3NWlO2eVU7fvDDwKBpzTRzCDzAzgC0+JNHYEczwe sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33ndnusp9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 17:28:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OHPUgp088770;
        Thu, 24 Sep 2020 17:26:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nux34ybd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 17:26:02 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08OHQ1VY001807;
        Thu, 24 Sep 2020 17:26:01 GMT
Received: from localhost (/10.159.232.188)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 10:26:01 -0700
Date:   Thu, 24 Sep 2020 10:26:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: remove deprecated mount options
Message-ID: <20200924172600.GG7955@magnolia>
References: <20200924170747.65876-1-preichl@redhat.com>
 <20200924170747.65876-2-preichl@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924170747.65876-2-preichl@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9754 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=1 bulkscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 07:07:46PM +0200, Pavel Reichl wrote:
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
>  fs/xfs/xfs_super.c                | 30 +++++++++++++++++-------------
>  2 files changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index f461d6c33534..413f68efccc0 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -217,6 +217,8 @@ Deprecated Mount Options
>  ===========================     ================
>    Name				Removal Schedule
>  ===========================     ================
> +  ikeep/noikeep			TBD
> +  attr2/noattr2			TBD

Er... what date did you have in mind?

>  ===========================     ================
>  
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71ac6c1cdc36..4c26b283b7d8 100644
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
> @@ -1304,6 +1291,23 @@ xfs_fc_parse_param(
>  		xfs_mount_set_dax_mode(mp, result.uint_32);
>  		return 0;
>  #endif
> +	case Opt_ikeep:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags |= XFS_MOUNT_IKEEP;

It's a little odd that you didn't then remove these XFS_MOUNT_ flags.
It's strange to declare a mount option deprecated but still have it
change behavior.

In this case, I guess we should keep ikeep/noikeep in the mount options
table so that scripts won't fail, but then we remove XFS_MOUNT_IKEEP and
change the codebase to always take the IKEEP behavior and delete the
code that handled the !IKEEP behavior.

> +		return 0;
> +	case Opt_noikeep:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags &= ~XFS_MOUNT_IKEEP;
> +		return 0;
> +	case Opt_attr2:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags |= XFS_MOUNT_ATTR2;

If the kernel /does/ encounter an attr1 filesystem, what will it do now?
IIRC the default (if there is no attr2/noattr2 mount option) is to
auto-upgrade the fs, right?  So will we stop doing that, or are we
making the upgrade mandatory now?

> +		return 0;
> +	case Opt_noattr2:
> +		xfs_warn(mp, "%s mount option is deprecated.", param->key);
> +		mp->m_flags &= ~XFS_MOUNT_ATTR2;
> +		mp->m_flags |= XFS_MOUNT_NOATTR2;

Also, uh, why move these code hunks?

--D

> +		return 0;
>  	default:
>  		xfs_warn(mp, "unknown mount option [%s].", param->key);
>  		return -EINVAL;
> -- 
> 2.26.2
> 
