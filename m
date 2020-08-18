Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CF5AC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7285C21744
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:53:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GLe1aOXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgHRWxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:53:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37094 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHRWxC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:53:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMqxHa162393;
        Tue, 18 Aug 2020 22:52:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rA1BpOJ36mN1diowjTX6+1gHB9YxpjoyyyYR3j5Yo94=;
 b=GLe1aOXm+H3a68nf520GW2MK985C3c0uwoQaRsmDMhfe09KGJj7DCYTaGdiVSa9db0PW
 uPmUH7MFH2I8fQf1RufMzrra4NxV1jvUO17jktCxAXj7SKHrbtsujmkqDpJh/C+h1rv7
 /i/2/VBrHWYCJW1mWrp7yB1+i6TQ3wjziFHQFAgLAtela5F9gj8ElfiIj1WDnKgSjAiK
 Ay379X2sx9mg5tkYs8XhwD2Uyr2aXgUFasaFT6LohjuulHlutWiQfEQFLbKXt1sDdPNn
 CwLG1EaOhQ4Fc2QQbz2vg1jpcd7/F08aNyyZD7bah/boONPZtLjPAGNCqvoEfKfaYISp Ag== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn7js6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:52:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMHs1s056470;
        Tue, 18 Aug 2020 22:52:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 330pvhn048-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:52:58 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMqu5i000540;
        Tue, 18 Aug 2020 22:52:57 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:52:56 -0700
Date:   Tue, 18 Aug 2020 15:52:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs: use xfs_buf_item_relse in xfs_buf_item_done
Message-ID: <20200818225255.GK6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-11-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=5 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=5 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:50PM +0200, Christoph Hellwig wrote:
> Reuse xfs_buf_item_relse instead of duplicating it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index ccc9d69683fae4..ccfd747d32e410 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -959,8 +959,6 @@ void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -
>  	/*
>  	 * If we are forcibly shutting down, this may well be off the AIL
>  	 * already. That's because we simulate the log-committed callbacks to
> @@ -970,8 +968,7 @@ xfs_buf_item_done(
>  	 *
>  	 * Either way, AIL is useless if we're forcing a shutdown.
>  	 */
> -	xfs_trans_ail_delete(&bip->bli_item, SHUTDOWN_CORRUPT_INCORE);
> -	bp->b_log_item = NULL;
> -	xfs_buf_item_free(bip);
> -	xfs_buf_rele(bp);
> +	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
> +			     SHUTDOWN_CORRUPT_INCORE);
> +	xfs_buf_item_relse(bp);
>  }
> -- 
> 2.26.2
> 
