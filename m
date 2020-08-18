Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1638DC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01E120786
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 15:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tBdX7xzT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHRPGu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 11:06:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59938 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgHRPGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 11:06:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF2tSn123504;
        Tue, 18 Aug 2020 15:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Lpoz5bDtr9KmNK8kZroBT/s5k3YVO3sObhLiTJ2E58k=;
 b=tBdX7xzTELU+x66MkNOBFh8y7CiI/ogmdqejZ9cBnViC7MPC7iJJlj7wO7km+9zJcdYg
 8CjF8/J4qTC9mNo5gQJk9+KyL26u3EDgNTQGXX87v/FkxrkJmNJWhrTnB+NAIM+PNp4o
 Lc3tvjAsCCfwckbsyZIJNAzH0pt0Mc/BdZM/flRttJoXIsAID9lKYedWmoNuInLkZQWC
 xGm6GBaNyoZNF19Rl8P/GHMB1Bv3K+NkEr/ShjmbS+6nmdsnTycKfWP7SpVCPOnAraTA
 78c5xLTtyPR1wFvO+L2BI6Mb291Q1kpusV4AlhdgcJmMJtN0Pd6JXAzfuLXdLwNsOFxK kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn5avs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 15:06:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IF2u03003084;
        Tue, 18 Aug 2020 15:06:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsmxbb9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 15:06:39 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IF6c4F021167;
        Tue, 18 Aug 2020 15:06:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 08:06:38 -0700
Date:   Tue, 18 Aug 2020 08:06:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: finish dfops on every insert range shift iteration
Message-ID: <20200818150637.GM6096@magnolia>
References: <20200713202151.64750-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713202151.64750-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1011 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180110
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 13, 2020 at 04:21:51PM -0400, Brian Foster wrote:
> The recent change to make insert range an atomic operation used the
> incorrect transaction rolling mechanism. The explicit transaction
> roll does not finish deferred operations. This means that intents
> for rmapbt updates caused by extent shifts are not logged until the
> final transaction commits. Thus if a crash occurs during an insert
> range, log recovery might leave the rmapbt in an inconsistent state.
> This was discovered by repeated runs of generic/455.
> 
> Update insert range to finish dfops on every shift iteration. This
> is similar to collapse range and ensures that intents are logged
> with the transactions that make associated changes.
> 
> Fixes: dd87f87d87fa ("xfs: rework insert range into an atomic operation")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Seems reasonable to me, sorry for dropping this by accident. :/

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_bmap_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index afdc7f8e0e70..feb277874a1f 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1165,7 +1165,7 @@ xfs_insert_file_space(
>  		goto out_trans_cancel;
>  
>  	do {
> -		error = xfs_trans_roll_inode(&tp, ip);
> +		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out_trans_cancel;
>  
> -- 
> 2.21.3
> 
