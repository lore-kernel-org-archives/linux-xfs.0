Return-Path: <SRS0=Vfs/=DQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7C4C433DF
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 15:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C25222E7
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Oct 2020 15:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sRQPqcV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389434AbgJIPsX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 11:48:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49086 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389144AbgJIPsX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 11:48:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099FiTuS154681;
        Fri, 9 Oct 2020 15:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HQsRcCttbyIiXm4hqGdtwne1sw4vSxHGN9/U5UbLh5E=;
 b=sRQPqcV/Yi1qiM38/xmNRMKStHnbR/Pkh/DvXd3hgvd7A3FW4ORrFB3gWf60e4hlf1My
 I/du3mYGK7Mv65g6Dvz/uu4rXQp9mOD276jW5khCmuHIK0Z+RXrsBoaY8o+feeH9bExG
 gI7XCx/zC09PIiH96DKeOP0O2hpvRmzvldyEcI7V7MlUYVTCMVgnuvqwb/GLg3k0RmqA
 Lw7V/VKragvyOs+Xs7FM9hwV7fsa2rt/JV5O7/79qQSsrGMltrT0p5xXP8MCcAdi0LEs
 tHIH9zVN2yhxkYq2IsIvKPQUDdcjgxGZLw22xaMCklTLpVk/60bDLZs74K7NaMFJf5yW EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3429juv96w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 09 Oct 2020 15:47:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 099FfIrc096653;
        Fri, 9 Oct 2020 15:45:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3429kjha6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Oct 2020 15:45:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 099Fj3b0030090;
        Fri, 9 Oct 2020 15:45:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Oct 2020 08:45:02 -0700
Date:   Fri, 9 Oct 2020 08:45:01 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [RFC PATCH] xfs: remove unnecessary null check in
 xfs_generic_create
Message-ID: <20201009154501.GU6540@magnolia>
References: <1602232150-28805-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602232150-28805-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9768 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=10 mlxscore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9769 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 bulkscore=0 suspectscore=10 lowpriorityscore=0 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010090117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 09, 2020 at 04:29:10PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The function posix_acl_release() test the passed-in argument and
> move on only when it is non-null, so maybe the null check in
> xfs_generic_create is unnecessary.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Heh, yep.  Nice cleanup.
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_iops.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 5e165456da68..5907e999642c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -206,10 +206,8 @@ xfs_generic_create(
>  	xfs_finish_inode_setup(ip);
>  
>   out_free_acl:
> -	if (default_acl)
> -		posix_acl_release(default_acl);
> -	if (acl)
> -		posix_acl_release(acl);
> +	posix_acl_release(default_acl);
> +	posix_acl_release(acl);
>  	return error;
>  
>   out_cleanup_inode:
> -- 
> 2.20.0
> 
