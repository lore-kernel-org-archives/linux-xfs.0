Return-Path: <SRS0=dxv4=BH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A68C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B828E2053B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oTVkTY7f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgG1P5Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 11:57:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38324 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbgG1P5Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 11:57:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SFv5e6020762;
        Tue, 28 Jul 2020 15:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PhOH5oei66TCzS6aKruIHq9l4mkDpM1zY8WBrWpLMYE=;
 b=oTVkTY7fwTvyJ/8hnYFbhY9IzKB30sz0/Ib5ZGkev0iFvPulBXmIa3zMwCNCuiiUuvNn
 V1lgIJJ1YsBB6dojosf7FH2497PwB1ujbKiy5LItEHvxf1vl+r9mI4381+NBJykb8jku
 /JewwLE689QJ5R4EvCfVqGfrg/jPwGquO7ZV6jfwf3WfIzAI/IG9OgVFRu7tqGP7eN5F
 1n//AGYEXRYEO+jpK/xTHmm6fhpfBDRoCogBdFxm2ole3n9ieSDAmL22FsfqQ1JVvfcc
 kUQZDaqQiL54lfefhqc+Iy0gRfJ6oTtXltNfsok/MqIt3jBA2hJalKOXCgLXw+fSaPVE zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 32hu1j8ceh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Jul 2020 15:57:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06SFgpiv089784;
        Tue, 28 Jul 2020 15:57:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32hu5uayqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jul 2020 15:57:07 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06SFv7OL011721;
        Tue, 28 Jul 2020 15:57:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Jul 2020 08:57:06 -0700
Date:   Tue, 28 Jul 2020 08:57:05 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     ira.weiny@intel.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: Support that ioctl(SETXFLAGS/GETXFLAGS) can
 set/get inode DAX on XFS.
Message-ID: <20200728155705.GP7625@magnolia>
References: <20200727092744.2641-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727092744.2641-1-yangx.jy@cn.fujitsu.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007280119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9696 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 clxscore=1015
 malwarescore=0 spamscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007280120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 27, 2020 at 05:27:44PM +0800, Xiao Yang wrote:
> 1) FS_DAX_FL has been introduced by commit b383a73f2b83.
> 2) In future, chattr/lsattr command from e2fsprogs can set/get
>    inode DAX on XFS by calling ioctl(SETXFLAGS/GETXFLAGS).
> 
> Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index a190212ca85d..6f22a66777cd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1075,13 +1075,18 @@ xfs_merge_ioc_xflags(
>  		xflags |= FS_XFLAG_NODUMP;
>  	else
>  		xflags &= ~FS_XFLAG_NODUMP;
> +	if (flags & FS_DAX_FL)
> +		xflags |= FS_XFLAG_DAX;
> +	else
> +		xflags &= ~FS_XFLAG_DAX;
>  
>  	return xflags;
>  }
>  
>  STATIC unsigned int
>  xfs_di2lxflags(
> -	uint16_t	di_flags)
> +	uint16_t	di_flags,
> +	uint64_t	di_flags2)
>  {
>  	unsigned int	flags = 0;
>  
> @@ -1095,6 +1100,9 @@ xfs_di2lxflags(
>  		flags |= FS_NOATIME_FL;
>  	if (di_flags & XFS_DIFLAG_NODUMP)
>  		flags |= FS_NODUMP_FL;
> +	if (di_flags2 & XFS_DIFLAG2_DAX) {
> +		flags |= FS_DAX_FL;
> +	}
>  	return flags;
>  }
>  
> @@ -1565,7 +1573,7 @@ xfs_ioc_getxflags(
>  {
>  	unsigned int		flags;
>  
> -	flags = xfs_di2lxflags(ip->i_d.di_flags);
> +	flags = xfs_di2lxflags(ip->i_d.di_flags, ip->i_d.di_flags2);
>  	if (copy_to_user(arg, &flags, sizeof(flags)))
>  		return -EFAULT;
>  	return 0;
> @@ -1588,7 +1596,7 @@ xfs_ioc_setxflags(
>  
>  	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
>  		      FS_NOATIME_FL | FS_NODUMP_FL | \
> -		      FS_SYNC_FL))
> +		      FS_SYNC_FL | FS_DAX_FL))
>  		return -EOPNOTSUPP;
>  
>  	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
> -- 
> 2.21.0
> 
> 
> 
