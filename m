Return-Path: <SRS0=uPG+=3K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9AFC2D0CE
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D5E22522
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jan 2020 17:46:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JKg3U0/m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgAURqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Jan 2020 12:46:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53792 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgAURqC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 12:46:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHcALr143931;
        Tue, 21 Jan 2020 17:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KpS6xwrKyWJhk7DQPJTgXp+GQ0Sk4zF24Zkn8ftRw6o=;
 b=JKg3U0/mxjH94uFy0wzmV1apfVhn2YR0ZYMOSiSUkJ+BYw7FLSVK0bbqwsI79Ij7vgDl
 wnwNz4j8Hd83WGAcx+kel5fkzjtQQWP7TK/1X8gj9kHdpdb+dIRd3TRs838K31x/b3pw
 887fZFi1heNd6kHbzaezjEQLCuNsiy8+LfjfuwnQX9QYQuuKkRqgM7SBM6HDoRnfnxpO
 v6fO36akNb2WuM8jFjeXbxazStv3U+F3kY9xx5TJ6NRdcApoaqB571vbnvkPQDJmwBux
 aD9nbX+7bgYpwrSMkxU5Ws5XD5K0uHE4U0bdvUAvXTsgnQHKcaS9hE4iE2hoxjJQraBH Wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xktnr6hr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:45:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00LHd9Im156307;
        Tue, 21 Jan 2020 17:45:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xnsa936yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jan 2020 17:45:57 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00LHjuaH017472;
        Tue, 21 Jan 2020 17:45:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 09:45:56 -0800
Date:   Tue, 21 Jan 2020 09:45:55 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 04/29] xfs: use strndup_user in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20200121174555.GE8247@magnolia>
References: <20200114081051.297488-1-hch@lst.de>
 <20200114081051.297488-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114081051.297488-5-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001210136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001210136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 14, 2020 at 09:10:26AM +0100, Christoph Hellwig wrote:
> Simplify the user copy code by using strndup_user.  This means that we
> now do one memory allocation per operation instead of one per ioctl,
> but memory allocations are cheap compared to the actual file system
> operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_ioctl.c   | 17 +++++------------
>  fs/xfs/xfs_ioctl32.c | 17 +++++------------
>  2 files changed, 10 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6bd0684a3528..f4d5c865e29e 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -446,11 +446,6 @@ xfs_attrmulti_by_handle(
>  		goto out_dput;
>  	}
>  
> -	error = -ENOMEM;
> -	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> -	if (!attr_name)
> -		goto out_kfree_ops;
> -
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
>  		if ((ops[i].am_flags & ATTR_ROOT) &&
> @@ -460,12 +455,11 @@ xfs_attrmulti_by_handle(
>  		}
>  		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
>  
> -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> -				ops[i].am_attrname, MAXNAMELEN);
> -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> -		if (ops[i].am_error < 0)
> +		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> +		if (IS_ERR(attr_name)) {
> +			ops[i].am_error = PTR_ERR(attr_name);
>  			break;
> +		}
>  
>  		switch (ops[i].am_opcode) {
>  		case ATTR_OP_GET:
> @@ -496,13 +490,12 @@ xfs_attrmulti_by_handle(
>  		default:
>  			ops[i].am_error = -EINVAL;
>  		}
> +		kfree(attr_name);
>  	}
>  
>  	if (copy_to_user(am_hreq.ops, ops, size))
>  		error = -EFAULT;
>  
> -	kfree(attr_name);
> - out_kfree_ops:
>  	kfree(ops);
>   out_dput:
>  	dput(dentry);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 1092c66e48d6..e6a7f619a54c 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -443,11 +443,6 @@ xfs_compat_attrmulti_by_handle(
>  		goto out_dput;
>  	}
>  
> -	error = -ENOMEM;
> -	attr_name = kmalloc(MAXNAMELEN, GFP_KERNEL);
> -	if (!attr_name)
> -		goto out_kfree_ops;
> -
>  	error = 0;
>  	for (i = 0; i < am_hreq.opcount; i++) {
>  		if ((ops[i].am_flags & ATTR_ROOT) &&
> @@ -457,13 +452,12 @@ xfs_compat_attrmulti_by_handle(
>  		}
>  		ops[i].am_flags &= ~ATTR_KERNEL_FLAGS;
>  
> -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> -				compat_ptr(ops[i].am_attrname),
> +		attr_name = strndup_user(compat_ptr(ops[i].am_attrname),
>  				MAXNAMELEN);
> -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> -			error = -ERANGE;
> -		if (ops[i].am_error < 0)
> +		if (IS_ERR(attr_name)) {
> +			ops[i].am_error = PTR_ERR(attr_name);
>  			break;
> +		}
>  
>  		switch (ops[i].am_opcode) {
>  		case ATTR_OP_GET:
> @@ -494,13 +488,12 @@ xfs_compat_attrmulti_by_handle(
>  		default:
>  			ops[i].am_error = -EINVAL;
>  		}
> +		kfree(attr_name);
>  	}
>  
>  	if (copy_to_user(compat_ptr(am_hreq.ops), ops, size))
>  		error = -EFAULT;
>  
> -	kfree(attr_name);
> - out_kfree_ops:
>  	kfree(ops);
>   out_dput:
>  	dput(dentry);
> -- 
> 2.24.1
> 
