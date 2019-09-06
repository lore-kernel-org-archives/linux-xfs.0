Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4ECBC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 01:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5067206DE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 01:04:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PqMP+azE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391856AbfIFBEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 21:04:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44296 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731344AbfIFBEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 21:04:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x860xoX7190708;
        Fri, 6 Sep 2019 01:04:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SOR6tC4N6DYGI4BUXDQBAxEfjk4rHTg1hIgkQbDNcdA=;
 b=PqMP+azExfcXdpM10r37NVzuOdthjvhhFhaz9//EIMPIP8k18U0uLwYIYY1gADoYKwaN
 m39oIXNHO55RfzyBJVr/JDiE0CsH8+m/vZPj5y9Ny2cSPyPPYU7E4cna9x73l+HGkWdy
 7Vk5jq5U0oSVsjuh31ZMWlnyqgECMDBZ71L54pjaNC70wW1f+UVpUVAs5vzHWlucBVwX
 4cHKuq8Sq1UQcXJOeQClc6dxGpTm4LTh+ZCVlEgcTJx7Qe3QaJhIfmXTC0ryIOOc6jYn
 nZVhRxUG0inMwFxzl3xQnVbTYkWzlg5gXrAwxPFaBCruYu9f0exUkeeWNrp79mQPwE03 Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uud78g1eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:04:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8614U3R031692;
        Fri, 6 Sep 2019 01:04:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uu1b97awj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:04:37 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8613hU0018937;
        Fri, 6 Sep 2019 01:03:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 18:03:42 -0700
Date:   Thu, 5 Sep 2019 18:03:41 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix the dax supported check in
 xfs_ioctl_setattr_dax_invalidate
Message-ID: <20190906010341.GO2229799@magnolia>
References: <20190830102315.27325-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830102315.27325-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 12:23:15PM +0200, Christoph Hellwig wrote:
> Setting the DAX flag on the directory of a file system that is not on a
> DAX capable device makes as little sense as setting it on a regular file
> on the same file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Weirdly, I never explicitly acknoweledged this...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 9ea51664932e..d1d0929aa462 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1309,8 +1309,7 @@ xfs_ioctl_setattr_dax_invalidate(
>  	if (fa->fsx_xflags & FS_XFLAG_DAX) {
>  		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
>  			return -EINVAL;
> -		if (S_ISREG(inode->i_mode) &&
> -		    !bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
> +		if (!bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
>  				sb->s_blocksize))
>  			return -EINVAL;
>  	}
> -- 
> 2.20.1
> 
