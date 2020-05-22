Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D496AC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7582073B
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 23:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IzwKSVak"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbgEVXL2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 19:11:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731227AbgEVXL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:11:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMwshY145822;
        Fri, 22 May 2020 23:11:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bBRf6tMphlAV0+7/FftV1lrHE/5z+ekBSvzzChDmOvA=;
 b=IzwKSVak8nJeNpR7cf03yjz8YfIe9HL8UUB6RMqgYIywuKa8CEtfrH5EsdLotQyzLLVL
 BIHlixvTouoVAtHBVD23yyM8xwbvSsNJhcqnsW29p3dkMr84EkSwAyGs6OKN6c6gGsqY
 vNuDzlRYngF5tvqRBb2XBJuaM8fOXPX/gBxuLFzQMl/B1GVlVugBwkyhAJDHroAMU48t
 vRwuvQzXTPFyJ5WdeWNvScuDgNj6+SL0Dm+WYFhem+ifIwIQsRKywXYaPK/Ct4ft3Pi4
 qPg2rZNZMkbSVUqm7vN3jkwBb009CondcVhyRRP1+od+pmTR5Jo/DJP0dxaNijfU5WV+ xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284mg2cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:11:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMwjLF103670;
        Fri, 22 May 2020 23:11:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj8aava-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:11:25 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MNBOrG011898;
        Fri, 22 May 2020 23:11:24 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:11:24 -0700
Date:   Fri, 22 May 2020 16:11:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/24] xfs: don't block inode reclaim on the ILOCK
Message-ID: <20200522231123.GT8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-17-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-17-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:21PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we attempt to reclaim an inode, the first thing we do it take

"...we do is take the inode lock."

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> the inode lock. This is blocking right now, so if the inode being
> accessed by something else (e.g. being flushed to the cluster
> buffer) we will block here.
> 
> Change this to a trylock so that we do not block inode reclaim
> unnecessarily here.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f44493b2eae77..c020d2379e12e 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1138,9 +1138,10 @@ xfs_reclaim_inode(
>  {
>  	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
>  
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (!xfs_iflock_nowait(ip))
> +	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
>  		goto out;
> +	if (!xfs_iflock_nowait(ip))
> +		goto out_iunlock;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  		xfs_iunpin_wait(ip);
> @@ -1157,8 +1158,9 @@ xfs_reclaim_inode(
>  
>  out_ifunlock:
>  	xfs_ifunlock(ip);
> -out:
> +out_iunlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +out:
>  	xfs_iflags_clear(ip, XFS_IRECLAIM);
>  	return false;
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 
