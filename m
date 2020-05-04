Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC28C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCAA320663
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 17:41:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bfH8xPQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgEDRlu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 13:41:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56738 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729597AbgEDRlu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 13:41:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044HbWIF018471
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:41:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MERzQW4BreoDvKZwvb5eW6MZ/2ZyVevmvFogH+80OUQ=;
 b=bfH8xPQPD4z3sbkXK2mL2btUdQoi41G3ZcxZehdyAa/CKmyUniOII/NGiA5P1+OmPFPO
 r6Sr+wM/DQ0N13hPFRW6CmiJu9bANksuw/jNEJ5emYtlKeqSbJwjMpzIKy9/q1jC2ehL
 IRbspfWhwaT9/KDR7Jh1OJV5eHwcGXWr8muUfVc3GzuRFoBgAGq1JeP7CWyhPykjcz/x
 XRxsm8EUOhUGXCdz2Pr+54URRopuUkzVbn/CReeNDQy+f5rfER3l4evQAA9RkndDxy/f
 90xmDQzyDtF6/wY1vdRwjqqRXjpIeao/e3cW1noqXKuihLaDxEdrRLsSTyTeGj6yiiJV tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09r0e30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:41:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Hbdtc040134
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:41:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30t1r2t43f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 17:41:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044HfmUp013683
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 17:41:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 10:41:47 -0700
Date:   Mon, 4 May 2020 10:41:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 11/24] xfs: Pull up xfs_attr_rmtval_invalidate
Message-ID: <20200504174146.GE13783@magnolia>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-12-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040140
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:03PM -0700, Allison Collins wrote:
> This patch pulls xfs_attr_rmtval_invalidate out of
> xfs_attr_rmtval_remove and into the calling functions.  Eventually
> __xfs_attr_rmtval_remove will replace xfs_attr_rmtval_remove when we
> introduce delayed attributes.  These functions are exepcted to return
> -EAGAIN when they need a new transaction.  Because the invalidate does
> not need a new transaction, we need to separate it from the rest of the
> function that does.  This will enable __xfs_attr_rmtval_remove to
> smoothly replace xfs_attr_rmtval_remove later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c        | 12 ++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.c |  3 ---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0fc6436..4fdfab9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -669,6 +669,10 @@ xfs_attr_leaf_addname(
>  		args->rmtblkcnt = args->rmtblkcnt2;
>  		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_invalidate(args);
> +			if (error)
> +				return error;
> +
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
>  				return error;
> @@ -1027,6 +1031,10 @@ xfs_attr_node_addname(
>  		args->rmtblkcnt = args->rmtblkcnt2;
>  		args->rmtvaluelen = args->rmtvaluelen2;
>  		if (args->rmtblkno) {
> +			error = xfs_attr_rmtval_invalidate(args);
> +			if (error)
> +				return error;
> +
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
>  				return error;
> @@ -1152,6 +1160,10 @@ xfs_attr_node_removename(
>  		if (error)
>  			goto out;
>  
> +		error = xfs_attr_rmtval_invalidate(args);
> +		if (error)
> +			return error;
> +
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 02d1a44..f770159 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -685,9 +685,6 @@ xfs_attr_rmtval_remove(
>  
>  	trace_xfs_attr_rmtval_remove(args);
>  
> -	error = xfs_attr_rmtval_invalidate(args);
> -	if (error)
> -		return error;
>  	/*
>  	 * Keep de-allocating extents until the remote-value region is gone.
>  	 */
> -- 
> 2.7.4
> 
