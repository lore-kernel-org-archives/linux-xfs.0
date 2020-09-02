Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22481C433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2EE6207EA
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 17:38:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NXg4kbnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIBRit (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 13:38:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgIBRip (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 13:38:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HYEeg002933
        for <linux-xfs@vger.kernel.org>; Wed, 2 Sep 2020 17:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mKr8mpvi1Dlma2k+GI3UuiDOnafqYciUJa6xNR61BIY=;
 b=NXg4kbnD4zBZ/69s52q28B0trA5ltSbu/CV5TkSpDLmqwqdPfa0RGGZ8UtAkwx2cjtJE
 3X3TeJIb9w14C/ANDp4mxAKc5BZJl+6ektTDJKntn7KFc80d+2mUyMNbUJtYr4c2C44p
 wsL7vQuBnHbQO+Hf82yNcSw7qS8wgP4nTp3TIJVNn9vEFdWi5toJoukxaGY1fc0OUGnt
 DZsLoxIjH3j/22S7gJeGeFbTliXf4YjyyNb9Azd38+rYnb9Pd16NROldwbQpdVjf0edg
 R1t3IK1GxUQ3MrFr30Vm7GL2r3Lo6rDiGPg3ABiltezpxoI4mGgG6PlVwYK4gwwMHNkK jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 337eymc3s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 17:38:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082HYdZn136259
        for <linux-xfs@vger.kernel.org>; Wed, 2 Sep 2020 17:38:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3380x7a98g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2020 17:38:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082Hchwq013881
        for <linux-xfs@vger.kernel.org>; Wed, 2 Sep 2020 17:38:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 10:38:43 -0700
Date:   Wed, 2 Sep 2020 10:38:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix xfs_bmap_validate_extent_raw when checking attr
 fork of rt files
Message-ID: <20200902173842.GT6096@magnolia>
References: <20200902164012.GN6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902164012.GN6096@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 02, 2020 at 09:40:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The realtime flag only applies to the data fork, so don't use the
> realtime block number checks on the attr fork of a realtime file.
> 
> Fixes: 30b0984d9117 ("xfs: refactor bmap record validation")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

NAK, I should've sent this from my stable tree, not my dev tree.

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index ce2e702b6b43..d35250c9bb07 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6310,7 +6310,7 @@ xfs_bmap_validate_extent_raw(
>  	xfs_fsblock_t		endfsb;
>  
>  	endfsb = irec->br_startblock + irec->br_blockcount - 1;
> -	if (isrt) {
> +	if (isrt && whichfork == XFS_DATA_FORK) {
>  		if (!xfs_verify_rtbno(mp, irec->br_startblock))
>  			return __this_address;
>  		if (!xfs_verify_rtbno(mp, endfsb))
