Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D117C3A59D
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 01:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F8332133F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 01:42:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ml0OLOfU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfHQBm0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Aug 2019 21:42:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60110 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfHQBm0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Aug 2019 21:42:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H1d8Xf028523;
        Sat, 17 Aug 2019 01:42:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Zne3b5GQiz2bvr6kfB6SOAiJzie5QNscwT/Ms44MoD0=;
 b=ml0OLOfUJirlmJvYs7A9RD9RlpTqyLIdMt8Jc4SUCp/WHwH8Q4BGx1ZKOVTwPXawUEh0
 2Ssx9I7edDkz9x/NYxOoZV/2hcq7tuQ+Kj0suyvkWGOk33g9jCwHtoeJeeMiCwn1N62r
 vJgHNRvX4p748A3vaKR7CcO9gC3+UM6MOJInF4FEnShJ0bYJQbSnpR/oQweGN4KCvMMp
 3d6CIMnKs7CIJOKiAffLy5LFmIH+EpLYd4XwGauIhcQAXFxah3giwGakxM3WkLUYsjwk
 CXVJ4x/8ft0OS9hmRleWll6tKKf6q42gvnAN+btiTpfXq1unCaH9rcS9vpSPR1cpPWEX DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u9nvpuebq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 01:42:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7H1bnF1153829;
        Sat, 17 Aug 2019 01:42:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2udscpybsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Aug 2019 01:42:20 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7H1gJ6D002776;
        Sat, 17 Aug 2019 01:42:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Aug 2019 18:42:18 -0700
Date:   Fri, 16 Aug 2019 18:42:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 2/2] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190817014218.GD752159@magnolia>
References: <20190816063547.1592-1-hch@lst.de>
 <20190816063547.1592-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816063547.1592-3-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908170015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9351 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908170015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 16, 2019 at 08:35:47AM +0200, Christoph Hellwig wrote:
> For 31-bit s390 user space, we have to pass pointer arguments through
> compat_ptr() in the compat_ioctl handler.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index bae08ef92ac3..7bd7534f5051 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -547,7 +547,7 @@ xfs_file_compat_ioctl(
>  	struct inode		*inode = file_inode(filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	void			__user *arg = (void __user *)p;
> +	void			__user *arg = compat_ptr(p);
>  	int			error;
>  
>  	trace_xfs_file_compat_ioctl(ip);
> @@ -655,6 +655,6 @@ xfs_file_compat_ioctl(
>  		return xfs_compat_fssetdm_by_handle(filp, arg);
>  	default:
>  		/* try the native version */
> -		return xfs_file_ioctl(filp, cmd, p);
> +		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);
>  	}
>  }
> -- 
> 2.20.1
> 
