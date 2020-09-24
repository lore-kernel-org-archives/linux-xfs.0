Return-Path: <SRS0=cWrc=DB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0606C4363D
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:11:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 875E32344C
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Sep 2020 15:11:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vyKg0Rz8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgIXPLj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:11:39 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728328AbgIXPLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 11:11:38 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OF3ZE8126845;
        Thu, 24 Sep 2020 15:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bPreJNRnfbvJexSejqPqxrVO7p8ZoAhF4nqOL6tsKT0=;
 b=vyKg0Rz8MVddrRtqQOuEvKEUkVBNHJrgC9URc2KLTKJwX2JJq6MimBi3HCopPTI57ej6
 nDwVinjRrjYzslpz+Rk5s5eEBdf94M+IMDoYZ3ujywmBcS9lE9FZ7nm4kzrp4wDB1jA5
 9GZ3hmXmcakg3Tudhn+hnf0jZKLIbt4XJH+odmhsWuW1CAChONEKpbkrLB8ZT/AbYk9y
 lIXUYxeaxfFAAc3QeTtOgzam2fgQEAaqMJ/rOdetI6TvMfMGcKosb7aoKYXDYbsVs7Iw
 a0fdovrhe5tT9kqNtKVQJFaPqSAyG0Cs1c8uEGzYuiYYDaWuOGY0oSjKZy1wndWxBVcr qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpu5snb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Sep 2020 15:10:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08OF5URh192342;
        Thu, 24 Sep 2020 15:08:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nux2wej4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Sep 2020 15:08:30 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08OF8RBM022087;
        Thu, 24 Sep 2020 15:08:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Sep 2020 08:08:27 -0700
Date:   Thu, 24 Sep 2020 08:08:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RFC PATCH] xfs: directly call xfs_generic_create() for
 ->create() and ->mkdir()
Message-ID: <20200924150827.GF7955@magnolia>
References: <1600957817-22969-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600957817-22969-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=699 phishscore=0 suspectscore=3 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxlogscore=681
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009240116
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 24, 2020 at 10:30:17PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The current create and mkdir handlers both call the xfs_vn_mknod()
> which is a wrapper routine around xfs_generic_create() function.
> Actually the create and mkdir handlers can directly call
> xfs_generic_create() function and reduce the call chain.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_iops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 80a13c8561d8..b29d5b25634c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -237,7 +237,7 @@ xfs_vn_create(
>  	umode_t		mode,
>  	bool		flags)
>  {
> -	return xfs_vn_mknod(dir, dentry, mode, 0);
> +	return xfs_generic_create(dir, dentry, mode, 0, false);
>  }
>  
>  STATIC int
> @@ -246,7 +246,7 @@ xfs_vn_mkdir(
>  	struct dentry	*dentry,
>  	umode_t		mode)
>  {
> -	return xfs_vn_mknod(dir, dentry, mode|S_IFDIR, 0);
> +	return xfs_generic_create(dir, dentry, mode|S_IFDIR, 0, false);

Might as well separate mode, the pipe, and S_IFDIR with a space...

--D

>  }
>  
>  STATIC struct dentry *
> -- 
> 2.20.0
> 
