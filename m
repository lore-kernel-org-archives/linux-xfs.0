Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF3AC433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5903A207B8
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 20:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgLCUKv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 15:10:51 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:45088 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgLCUKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 15:10:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3K9C2Q157139;
        Thu, 3 Dec 2020 20:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Wpl0t89peb8Aq1S/CVdzUw1pJTWdXS8ZPdA4MwQ2TX0=;
 b=AczUgFWAQ8jzgukuzZbYDlYYt5Wx4gOPUoex1R3awki9/ixwyKTT7D19N0ayBgjeoGPu
 d25iFJDeghxLzNjVLnjLwUid2bBpdgbGI+jCo/1YDFcB9c7+ClguSSuHq2XDgPuvxzqx
 jRGGDgSHas1w5IM7YHJ2YOkaQeBUrgq6A+jtksCKQ9ccu/aqhn8cRcxRsQZauRiS9u0a
 36h4ztFZmvzDksbhi8sqLuzRT2laqeT5BfzZsMuDn/qiLzIGl8oEzncxerMxB2H9cSA6
 oz8KtsPBE+twML+wNJKRB1165dFLq309UkkVtfEOI9l1Z2ZlZZACiI+a61ZrILzJXKJc Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 353c2b83qq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 03 Dec 2020 20:10:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B3K0EHG094206;
        Thu, 3 Dec 2020 20:08:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540f2bq98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Dec 2020 20:08:08 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B3K88mh005879;
        Thu, 3 Dec 2020 20:08:08 GMT
Received: from localhost (/10.159.242.140)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Dec 2020 12:08:07 -0800
Date:   Thu, 3 Dec 2020 12:08:05 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] xfs_quota: Remove delalloc caveat from man page
Message-ID: <20201203200805.GK106272@magnolia>
References: <44dcd8f3-0585-e463-499f-44256d8bad8d@redhat.com>
 <8fe85780-d68e-6d33-349b-66dad73858c3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fe85780-d68e-6d33-349b-66dad73858c3@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9824 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012030117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 02:00:42PM -0600, Eric Sandeen wrote:
> Ever since
> 89605011915a ("xfs: include reservations in quota reporting")
> xfs quota has been in sync with delayed allocations, so this caveat
> is no longer relevant or correct; remove it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  man/man8/xfs_quota.8 | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
> index b3c4108e..bfdc2e4f 100644
> --- a/man/man8/xfs_quota.8
> +++ b/man/man8/xfs_quota.8
> @@ -725,17 +725,8 @@ Same as above without a need for configuration files.
>  .in -5
>  .fi
>  .SH CAVEATS
> -XFS implements delayed allocation (aka. allocate-on-flush) and this
> -has implications for the quota subsystem.
> -Since quota accounting can only be done when blocks are actually
> -allocated, it is possible to issue (buffered) writes into a file
> -and not see the usage immediately updated.
> -Only when the data is actually written out, either via one of the
> -kernels flushing mechanisms, or via a manual
> -.BR sync (2),
> -will the usage reported reflect what has actually been written.
>  .PP
> -In addition, the XFS allocation mechanism will always reserve the
> +The XFS allocation mechanism will always reserve the
>  maximum amount of space required before proceeding with an allocation.
>  If insufficient space for this reservation is available, due to the
>  block quota limit being reached for example, this may result in the
> -- 
> 2.17.0
> 
> 
