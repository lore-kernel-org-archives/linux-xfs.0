Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9158C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 17:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BEE02087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 17:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uxBMJfzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgH0RYe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:24:34 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgH0RYe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 13:24:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RHFgCb186311;
        Thu, 27 Aug 2020 17:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=K1YdmL4nl2FczcrYEdbj/7bbXfPk/UDgEkDmMtxz16s=;
 b=uxBMJfzuMrW8hSAvoWGUDyd7mZwBIEOYdDsmuChXngIwhrga3szrykN/JNfBocGwtZ95
 ONe/tEY7IPgp7U2hj4gzoANkkGJDlcJ1v91MFPHCmlAljHJKtICui+IJsEZv384Wg7YD
 6W6C6nbh3N8IAeUwaQoVsG9AjR7FsXL36uKi8TviqMIo1HtavMiccriYGDRTmsMgZlBZ
 z87HPcaSebv1ejujwJu4OJVF3/e3556j0bI3mbCMFY81026ifmSQkGFTWIBk/HlWWcuQ
 T1zWljtz+vbi8u1mhozH8/ZugSvuiyRGVIabkJ3lnPkSO6D9eZ9H2o8l1Vroi3YzeFCC yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6u68nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 17:24:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RHFQmM033292;
        Thu, 27 Aug 2020 17:22:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 333r9nh6yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 17:22:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RHMTtU031335;
        Thu, 27 Aug 2020 17:22:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 10:22:29 -0700
Date:   Thu, 27 Aug 2020 10:22:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: set b_ops to NULL in set_cur for types without
 verifiers
Message-ID: <20200827172228.GW6096@magnolia>
References: <06cdcef6-2f44-c702-198b-4ae53052ec28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06cdcef6-2f44-c702-198b-4ae53052ec28@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270129
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 11:53:33AM -0500, Eric Sandeen wrote:
> If we are using set_cur() to set a type that has no verifier ops,
> be sure to set b_ops to NULL so that the old verifiers don't run
> against the buffer anymore, which may have changed size.
> 
> Fixes: cdabe556 ("xfs_db: consolidate set_iocur_type behavior")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Seems to fix the xfs/070 regression, thanks.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/db/io.c b/db/io.c
> index 9309f361..c79cf105 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -561,8 +561,10 @@ set_cur(
>  		return;
>  	iocur_top->buf = bp->b_addr;
>  	iocur_top->bp = bp;
> -	if (!ops)
> +	if (!ops) {
> +		bp->b_ops = NULL;
>  		bp->b_flags |= LIBXFS_B_UNCHECKED;
> +	}
>  
>  	iocur_top->bb = blknum;
>  	iocur_top->blen = len;
> 
