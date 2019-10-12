Return-Path: <SRS0=POS4=YF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E14C47404
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:30:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D00EE21835
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Oct 2019 00:30:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bEcywwnu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfJLAaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Oct 2019 20:30:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53786 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbfJLAaH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Oct 2019 20:30:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0U25i104936;
        Sat, 12 Oct 2019 00:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sqfySJR2AX9Mn7ITNk2KaVjiKTP7FKS6INSiATBNI9k=;
 b=bEcywwnu02kIaZj8cvg6pCgNNpqgFwxDvoC0OLGxj4l4UodRZEddwkOqCFSm23Z94tO1
 0ynQ8KciqstIFQfarMp+/trdJDXiIroLgOgre17QhD460/f6SLYG2WStmdRzOmf8kMVx
 1s9fYiwOYe3R2AO9gz5f6Y4uh/RK4QheJCnxCW8SoUpvXbfLVn57AYQbEA6zEwx7oKRH
 2m0n9laAQpIzZFkI1vTNX86RoqDDEoE44cG06lSZ4PyhzVbI+RTN7DhgODTR9hiPiBHg
 qbL7itmlo38DOxeEqrciDvYotssFy0NP4TjCP+nCl+ZJJlOdD7QYhh2GII0UmBtPyn5g Eg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2vekts4bwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:30:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9C0SmKm172207;
        Sat, 12 Oct 2019 00:30:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2vk3533er9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 12 Oct 2019 00:30:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9C0TuP1005368;
        Sat, 12 Oct 2019 00:29:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Oct 2019 17:29:56 -0700
Date:   Fri, 11 Oct 2019 17:29:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: disable xfs_ioc_space for always COW inodes
Message-ID: <20191012002954.GM13108@magnolia>
References: <20191011130316.13373-1-hch@lst.de>
 <20191011130316.13373-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011130316.13373-2-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=822
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910120001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9407 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=902 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910120001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 11, 2019 at 03:03:15PM +0200, Christoph Hellwig wrote:
> If we always have to write out of place preallocating blocks is
> pointless.  We already check for this in the normal falloc path, but
> the check was missig in the legacy ALLOCSP path.

This function handles other things than preallocation, such as
XFS_IOC_ZERO_RANGE and XFS_IOC_UNRESVSP, which call xfs_zero_file_space
and xfs_free_file_space, respectively.  We don't prohibit fallocate
from calling those two functions on an always_cow inode, so why do that
here?

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_ioctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d58f0d6a699e..abf7a102376f 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -33,6 +33,7 @@
>  #include "xfs_sb.h"
>  #include "xfs_ag.h"
>  #include "xfs_health.h"
> +#include "xfs_reflink.h"
>  
>  #include <linux/mount.h>
>  #include <linux/namei.h>
> @@ -607,6 +608,9 @@ xfs_ioc_space(
>  	if (!S_ISREG(inode->i_mode))
>  		return -EINVAL;
>  
> +	if (xfs_is_always_cow_inode(ip))
> +		return -EOPNOTSUPP;
> +
>  	if (filp->f_flags & O_DSYNC)
>  		flags |= XFS_PREALLOC_SYNC;
>  	if (filp->f_mode & FMODE_NOCMTIME)
> -- 
> 2.20.1
> 
