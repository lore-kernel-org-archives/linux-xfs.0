Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B6BC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1239206D4
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZyCZi6wD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgEPRwK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:52:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgEPRwK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 May 2020 13:52:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHhvPM034348;
        Sat, 16 May 2020 17:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MTCONODdUiZEFQPjVXtOiueVyqX4Dt41EDP5sr6Wa3w=;
 b=ZyCZi6wDPgyR0yvj3WGat3h17V76Obl3EulYBtQo+W78xCMkRsAJj5hCQDkZRkXQlVrx
 MaSbHD4RMuOq/9y8bf64g64zuWViX3GF8MNr6xldHVn68C31QZn0mkzo4+PDX44mO5jd
 UjKQWVctlFLohkbd+/1Wv574OzX1Un8hXaqPZDynkcW/r7ddtcYR0S21EyuDgO975oiM
 s5E8yRyEPsTiqybUsRgvUZQqh1xQ2yUt5Wh+e/uulcBRg6/pguJu2TCnTOOCEwb4hXfO
 Geuh+YCoxUNAMz2LIAuaSfh24RqEsVpmkzqWdzliLH/Zpusb4vAfuUzsjy0C7r0tQr0f cQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tn1bmx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 16 May 2020 17:52:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04GHgnT4015172;
        Sat, 16 May 2020 17:52:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312801ak3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 16 May 2020 17:52:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04GHq1Ni005044;
        Sat, 16 May 2020 17:52:02 GMT
Received: from localhost (/10.159.131.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 16 May 2020 10:52:01 -0700
Date:   Sat, 16 May 2020 10:52:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/12] xfs: remove the special COW fork handling in
 xfs_bmapi_read
Message-ID: <20200516175200.GA6714@magnolia>
References: <20200508063423.482370-1-hch@lst.de>
 <20200508063423.482370-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508063423.482370-12-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=1 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9623 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1015 cotscore=-2147483648 suspectscore=1 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005160159
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 08:34:22AM +0200, Christoph Hellwig wrote:
> We don't call xfs_bmapi_read for the COW fork anymore, so remove the
> special casing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

I was surprised this assertion, but apparently it's true, even in my dev
tree, so:
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fda13cd7add0e..76be1a18e2442 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3902,8 +3902,7 @@ xfs_bmapi_read(
>  	int			whichfork = xfs_bmapi_whichfork(flags);
>  
>  	ASSERT(*nmap >= 1);
> -	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
> -			   XFS_BMAPI_COWFORK)));
> +	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
>  
>  	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
> @@ -3918,16 +3917,6 @@ xfs_bmapi_read(
>  
>  	ifp = XFS_IFORK_PTR(ip, whichfork);
>  	if (!ifp) {
> -		/* No CoW fork?  Return a hole. */
> -		if (whichfork == XFS_COW_FORK) {
> -			mval->br_startoff = bno;
> -			mval->br_startblock = HOLESTARTBLOCK;
> -			mval->br_blockcount = len;
> -			mval->br_state = XFS_EXT_NORM;
> -			*nmap = 1;
> -			return 0;
> -		}
> -
>  		/*
>  		 * A missing attr ifork implies that the inode says we're in
>  		 * extents or btree format but failed to pass the inode fork
> -- 
> 2.26.2
> 
