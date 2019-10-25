Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91782CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59DF720679
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BQHtW7Nx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392384AbfJYFbt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:31:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33954 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390225AbfJYFbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:31:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5StDq135632;
        Fri, 25 Oct 2019 05:31:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ge7zy5IqyF4ejjh3ISJilIrGAiPKvbwO4AmBy1mKmq4=;
 b=BQHtW7NxoOmIyVYDK7SJfupHoKuPgEpH5+G9Mm5hQpi/gr95Nqxxj1PQwobRwVZefI2k
 Kbnc96XbM9h/qNgItWqt9OfLgqfk3iW4boh7TNHZOisV8IK9kaH1f/HVJq7C6RzGiv9Z
 NCzerQkymoBQyrs4WPCUu89V5HIlHds3fxD611D9+eUxGPvzwLx7z6F3hMNM1EcZWtwC
 tlTcEtqfR1juIWymOxgXkjTA7EaL3JsG6paLXwhTE8ARWX/EoNQxhKwDx1mH2VfxFyN7
 423cSOvm2DJ+YPNG0rnqM6o7iaZlYXq1wGns+FpIB23EMc/uJjsk5uCXg12YJ4UsRPyP nA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswu0b66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:31:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5Sf4D157327;
        Fri, 25 Oct 2019 05:29:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vunbkhkhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:29:45 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P5TiYX029052;
        Fri, 25 Oct 2019 05:29:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:29:44 -0700
Date:   Thu, 24 Oct 2019 22:29:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: use xfs_inode_buftarg in xfs_file_ioctl
Message-ID: <20191025052943.GB913374@magnolia>
References: <20191025021852.20172-1-hch@lst.de>
 <20191025021852.20172-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025021852.20172-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250053
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250053
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 11:18:52AM +0900, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index b7b5c17131cd..0fed56d3175c 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2135,10 +2135,8 @@ xfs_file_ioctl(
>  		return xfs_ioc_space(filp, cmd, &bf);
>  	}
>  	case XFS_IOC_DIOINFO: {
> -		struct dioattr	da;
> -		xfs_buftarg_t	*target =
> -			XFS_IS_REALTIME_INODE(ip) ?
> -			mp->m_rtdev_targp : mp->m_ddev_targp;
> +		struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> +		struct dioattr		da;
>  
>  		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
>  		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> -- 
> 2.20.1
> 
