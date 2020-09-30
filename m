Return-Path: <SRS0=giQg=DH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7617AC4727C
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE7E20759
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Sep 2020 15:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bBIl3oe7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgI3P7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:59:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54408 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3P7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 11:59:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UFxaF9048206;
        Wed, 30 Sep 2020 15:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JxICoHRryfQz+EZ089ifvYmwVj14cASraw0Phtv3QmA=;
 b=bBIl3oe73iKyJ2Q7Wi90+KkQJBPqYfKF1dujtXPIqjdN8lFWzHCRUtAWjBG3F1uGRn7s
 ehanbZz42pzHd8rBEbIciA8ri8kPW43/rNLTYPc1cupOuxeCffwgtcFzJA6OsGoHI5mE
 53Pa4P7NlhqzuXPnunefQPCb7mu6YrylmbQkbgj/0TEtjfeCcHS5JLp7jAqLJflFfgBQ
 LO+8TZCjC747SNHkwcwUTFjYbix00xdTpkWeI2V0AHE5t8sDDc7Hbqg6j6evCMl/BuGo
 KLp22u6d5/HN2GurkR21naBf/+euqQmwLumo50JrDpAIXaURzkjJezg09KEbQ1Qi7JIf uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 33swkm1bnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 30 Sep 2020 15:59:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08UFsseP121097;
        Wed, 30 Sep 2020 15:59:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2fjn4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Sep 2020 15:59:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08UFxkxn014494;
        Wed, 30 Sep 2020 15:59:46 GMT
Received: from localhost (/10.159.225.72)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 30 Sep 2020 08:59:45 -0700
Date:   Wed, 30 Sep 2020 08:59:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: be more helpful if rtdev is not specified
 for rt subvol
Message-ID: <20200930155945.GM49547@magnolia>
References: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee05a000-4c9d-ad5d-66d0-48655cb69e95@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9760 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009300127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 10:54:42AM -0500, Eric Sandeen wrote:
> Today, if one tries to repair a filesystem with a realtime subvol but
> forgets to specify the rtdev on the command line, the result sounds dire:
> 
> Phase 1 - find and verify superblock...
> xfs_repair: filesystem has a realtime subvolume
> xfs_repair: realtime device init failed
> xfs_repair: cannot repair this filesystem.  Sorry.
> 
> We can be a bit more helpful, following the log device example:
> 
> Phase 1 - find and verify superblock...
> This filesystem has a realtime subvolume.  Specify rt device with the -r option.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index cb8967bc..65cc3d4c 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -429,9 +429,9 @@ rtmount_init(
>  	if (sbp->sb_rblocks == 0)
>  		return 0;
>  	if (mp->m_rtdev_targp->dev == 0 && !(flags & LIBXFS_MOUNT_DEBUGGER)) {
> -		fprintf(stderr, _("%s: filesystem has a realtime subvolume\n"),
> -			progname);
> -		return -1;
> +		fprintf(stderr, _("This filesystem has a realtime subvolume.  "
> +			   "Specify rt device with the -r option.\n"));

_("%s: realtime subvolume must be specified.\n")?

--D

> +		exit(1);
>  	}
>  	mp->m_rsumlevels = sbp->sb_rextslog + 1;
>  	mp->m_rsumsize =
> 
