Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708CBC5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 15:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409A12187F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 15:58:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AuN18Jnu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfKFP6i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 10:58:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50510 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfKFP6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 10:58:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6FvcFk095971;
        Wed, 6 Nov 2019 15:58:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=z2DPWMc3TKp1oFbPYOXdhDkuZDHNEjaRiG/t99Bj+Vs=;
 b=AuN18JnuOGoe/JpvfkXBWlPG1alUPMAZIK/8tDhZenMyV72fWeJ92TUOFLCE67sl5a45
 16XSpKbn8YLleS5zPwsX0MNrtynoaTIw7PY8ga1r0+R5ab5LTcYeZQzRlFz9WGoQI+Uk
 Vl4dWI34rvOBbCS1VuQWxVjKL6e2mkYurfVtotKGI9bGj56VtvCshMe+FoWSD2ZYFChD
 CqMkIF+fMOo6PbsHuii78O1FX9PL9kF/qv/ykMWTjeiDTvs3gy8H4FHNw0DmBqQrkk2b
 ztcFuIE+MhVnS0p5optw76GYHFOzbS/DWsVm3M8nONXgj4TA6MzscXETw/FYDc1nl2id WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117u7rpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 15:58:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6FrASK157567;
        Wed, 6 Nov 2019 15:56:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2w3163tmay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 15:56:34 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6FuXZI007616;
        Wed, 6 Nov 2019 15:56:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 07:56:32 -0800
Date:   Wed, 6 Nov 2019 07:56:31 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xfs: remove redundant assignment to variable error
Message-ID: <20191106155631.GJ4153244@magnolia>
References: <20191106155248.266489-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106155248.266489-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 03:52:48PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable error is being initialized with a value that is never read
> and is being re-assigned a couple of statements later on. The
> assignment is redundant and hence can be removed.
> 
> Addresses-Coverity: ("Unused value")

Er... is there a coverity id that goes with this?

Patch looks fine otherwise.

--D

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b3188ea49413..2302f67d1a18 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1362,7 +1362,7 @@ xfs_fc_fill_super(
>  {
>  	struct xfs_mount	*mp = sb->s_fs_info;
>  	struct inode		*root;
> -	int			flags = 0, error = -ENOMEM;
> +	int			flags = 0, error;
>  
>  	mp->m_super = sb;
>  
> -- 
> 2.20.1
> 
