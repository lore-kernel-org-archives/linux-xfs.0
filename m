Return-Path: <SRS0=jVwY=2D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E7BC43603
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 21:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A2A624671
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Dec 2019 21:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eSFH2uBM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfLMVFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Dec 2019 16:05:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLMVFc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 16:05:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKsVO2090897;
        Fri, 13 Dec 2019 21:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=+CxyBUYNOKKH5a8vZMlq3lGRzD8G5U21GoBTkL8d1Dk=;
 b=eSFH2uBMxA94q/8a7fNWX5MdRXjngAcsXdDL2FOVoW4HOaCbQy71bhZQv/5/Ar6VkDGC
 ZuuG5tGKdkeVA26f1IDoGUqS91bV0BlRXDRrjQC0GW9Ux/Fjv1MhiHKvevDH7up2zlio
 ZTc0kbbY3bQIPFm0ByZ7g+MGtdS4KdScdhnwpapulmxgkG7mztPd5PKwStM2x8gvBOPB
 bU9yCYhr2X6UdLjtqmxQ6b+GMbW3FaOG98+4BsvJwbgKSADdkn73tm9s7+DJTlDWkIWf
 A0qM0YTBu4AKwxtw6eat1a3qwoBfb3VsV2+/oHByNqYXrOpmbbaPH3RJfZYDpazWkPcw OQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2wr41qubcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 21:05:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDKsf70098671;
        Fri, 13 Dec 2019 21:05:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2wvdwqwp38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 21:05:18 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDL5BNK030978;
        Fri, 13 Dec 2019 21:05:12 GMT
Received: from localhost (/10.145.178.64)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 13:05:11 -0800
Date:   Fri, 13 Dec 2019 13:05:09 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2 20/24] xfs: disallow broken ioctls without
 compat-32-bit-time
Message-ID: <20191213210509.GK99875@magnolia>
References: <20191213204936.3643476-1-arnd@arndb.de>
 <20191213205417.3871055-11-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213205417.3871055-11-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 13, 2019 at 09:53:48PM +0100, Arnd Bergmann wrote:
> When building a kernel that disables support for 32-bit time_t
> system calls, it also makes sense to disable the old xfs_bstat
> ioctls completely, as they truncate the timestamps to 32-bit
> values.

Note that current xfs doesn't support > 32-bit timestamps at all, so for
now the old bulkstat/swapext ioctls will never overflow.

Granted, I melded everyone's suggestions into a more fully formed
'bigtime' feature patchset that I'll dump out soon as part of my usual
end of year carpetbombing of the mailing list, so we likely still need
most of this patch anyway...

> Any application using these needs to be updated to use the v5
> interfaces.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/xfs/xfs_ioctl.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 7b35d62ede9f..a4a4eed8879c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -36,6 +36,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_ioctl.h"
>  
> +#include <linux/compat.h>
>  #include <linux/mount.h>
>  #include <linux/namei.h>
>  
> @@ -617,6 +618,23 @@ xfs_fsinumbers_fmt(
>  	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
>  }
>  
> +/* disallow y2038-unsafe ioctls with CONFIG_COMPAT_32BIT_TIME=n */
> +static bool xfs_have_compat_bstat_time32(unsigned int cmd)

The v5 bulkstat ioctls follow an entirely separate path through
xfs_ioctl.c, so I think you don't need the @cmd parameter.

> +{
> +	if (IS_ENABLED(CONFIG_COMPAT_32BIT_TIME))
> +		return true;
> +
> +	if (IS_ENABLED(CONFIG_64BIT) && !in_compat_syscall())
> +		return true;
> +
> +	if (cmd == XFS_IOC_FSBULKSTAT_SINGLE ||
> +	    cmd == XFS_IOC_FSBULKSTAT ||
> +	    cmd == XFS_IOC_SWAPEXT)
> +		return false;
> +
> +	return true;
> +}
> +
>  STATIC int
>  xfs_ioc_fsbulkstat(
>  	xfs_mount_t		*mp,
> @@ -637,6 +655,9 @@ xfs_ioc_fsbulkstat(
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> +	if (!xfs_have_compat_bstat_time32(cmd))
> +		return -EINVAL;
> +
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> @@ -1815,6 +1836,11 @@ xfs_ioc_swapext(
>  	struct fd	f, tmp;
>  	int		error = 0;
>  
> +	if (xfs_have_compat_bstat_time32(XFS_IOC_SWAPEXT)) {

if (!xfs_have...()) ?

--D

> +		error = -EINVAL;
> +		goto out;
> +	}
> +
>  	/* Pull information for the target fd */
>  	f = fdget((int)sxp->sx_fdtarget);
>  	if (!f.file) {
> -- 
> 2.20.0
> 
