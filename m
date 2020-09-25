Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0A8C4727E
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 18:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9546207C4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 18:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tYr+JIqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729713AbgIYSPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 14:15:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54368 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbgIYSPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 14:15:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PI3SYP117656;
        Fri, 25 Sep 2020 18:14:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=czucgyfktswJPssQIo8h1fAlamk07g24ftLQRJwXf8g=;
 b=tYr+JIqofUmjZFkuthoZtrUf6SnMZUxXYVTBJTxraqZx3q39c8FzhuskmOqBXnjdCnjG
 fLjNv0RL69CKKWpE8i9kdYtYuberaXYDT+5JvpEhF8TepufRqbuWkkMCRfsWyKCxm0b+
 4cilffDtTWsdThDOGDyrzS9T1CwziPvltCl/H+HfDj6ONP3oh2VeHxsvVY5PCh+zvMzZ
 RGCvzhi6loEVW3Sz19BMVHSf07VWzTUybj6UzxnapLlDLzGES5u8dblO0bi4uX4EL0aB
 2foSTDb7XzWdSkZHl7ZyESrZS4Ri5REsrvmQkTCErd6BJgAaW+ckVWKh4ZspTt0Y5VLG tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgwefd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 18:14:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PIADNM130223;
        Fri, 25 Sep 2020 18:14:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33r28yprmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 18:14:46 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08PIEjRJ001732;
        Fri, 25 Sep 2020 18:14:45 GMT
Received: from localhost (/10.159.232.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 11:14:45 -0700
Date:   Fri, 25 Sep 2020 11:14:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2] xfs: directly call xfs_generic_create() for
 ->create() and ->mkdir()
Message-ID: <20200925181444.GN7955@magnolia>
References: <1601001801-25508-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601001801-25508-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=765
 suspectscore=3 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=3 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=747 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 25, 2020 at 10:43:21AM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The current create and mkdir handlers both call the xfs_vn_mknod()
> which is a wrapper routine around xfs_generic_create() function.
> Actually the create and mkdir handlers can directly call
> xfs_generic_create() function and reduce the call chain.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> v2:
>  -add the necessary space.
> 
>  fs/xfs/xfs_iops.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 80a13c8561d8..5e165456da68 100644
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
> +	return xfs_generic_create(dir, dentry, mode | S_IFDIR, 0, false);
>  }
>  
>  STATIC struct dentry *
> -- 
> 2.20.0
> 
