Return-Path: <SRS0=KYGq=CZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1EFC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 23:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F66A221EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Sep 2020 23:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uj7DYg2n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgIPXDX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:03:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbgIPXDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 19:03:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GGhpW8148913;
        Wed, 16 Sep 2020 16:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=PeFzVdbnEIgRJC9J9MZW2Wk4xYd9bvEyBoyHJtde3x8=;
 b=uj7DYg2nA8NqBCpD2oGpgMKNxSpsK0hIFpb4ms+EIBMHe303lELtLjGEW/jrOYMMet0C
 16TAckBic0B3dpNf0nu/vFq6re2srssyHcFGdtata4ZyXAevBR4YlmKeM0rxNT0wONh4
 zphliIDrh3Cp0zxyxofJQxKqYUqn57CsZgy1ZQfzraG82s4XZyP1PZtSterHOsYTJ7Yb
 qyLWGD2VtCiABnJ1ax3RUKojtOyxPdv5PhMYINCZKRjp0rs5rJmJqV52oX566UeCREgz
 ZRaImDZo7bqAVqx5xjdueJbaJK9uqqyURxw0hX3H9f0M0S9Dqchu0MtvPLq9Vrm9m264 eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33gnrr4a18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 16:45:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08GGfkpH090771;
        Wed, 16 Sep 2020 16:45:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33h888rjg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 16:45:30 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08GGjOWD014843;
        Wed, 16 Sep 2020 16:45:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 16:45:23 +0000
Date:   Wed, 16 Sep 2020 09:45:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: remove the unnecessary variable error in
 xfs_trans_unreserve_and_mod_sb
Message-ID: <20200916164522.GH7955@magnolia>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-7-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600255152-16086-7-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=3 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=3
 clxscore=1011 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160119
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 16, 2020 at 07:19:09PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> We can do the assert directly for the return value of xfs_mod_fdblocks()
> function, and the variable error is unnecessary, so remove it.
> 
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/xfs_trans.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index d33d0ba6f3bd..caa207220e2c 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -573,7 +573,6 @@ xfs_trans_unreserve_and_mod_sb(
>  	int64_t			rtxdelta = 0;
>  	int64_t			idelta = 0;
>  	int64_t			ifreedelta = 0;
> -	int			error;
>  
>  	/* calculate deltas */
>  	if (tp->t_blk_res > 0)
> @@ -596,10 +595,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	/* apply the per-cpu counters */
> -	if (blkdelta) {
> -		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
> -		ASSERT(!error);
> -	}
> +	if (blkdelta)
> +		ASSERT(!xfs_mod_fdblocks(mp, blkdelta, rsvd));

Um.... did you test this with ASSERTs disabled?  Because this compiles
the free block counter update out of the function on non-debug kernels,
which (AFAICT) will cause fs corruption...

--D

>  
>  	if (idelta) {
>  		percpu_counter_add_batch(&mp->m_icount, idelta,
> -- 
> 2.20.0
> 
