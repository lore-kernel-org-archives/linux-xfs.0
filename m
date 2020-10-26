Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB74AC2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:12:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 563AD20780
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="prwzEeji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395500AbgJZXMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:12:01 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55784 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395499AbgJZXMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:12:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QN9Hv0150072;
        Mon, 26 Oct 2020 23:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fiuLekNsYghzR805mKMkKaK6eRCMd2jKBM5yv/ywfa8=;
 b=prwzEejiv/p6RAw8upayLpJfSwLQPZ3G0Ti+BNHXIR5UiEiaoyUApB7EkAvI94aGNurx
 VanHhwEsmQDcJlNqLpskq5K+ZjJ1ennogG3Oi2keS+3V+EtCtRdEqGh513PX3O4AGJHE
 fsdYVA2eV6/785SWNJk5ZGhjxlz8e5KCte7I2+hmiW76vJdJkgRydFK7Ec2Qf60Qmmji
 DP+DnjUTMEFR+NM2LhywMXts8/M87cGTz9QQbDfp4dziicK3eKfbVaMkOu1t2wxWXU8j
 +VAsSnWOJ1zioFZe7lJJyoVlbL9HXbU6hzBMwwJkKbxVlNH7O2bmcNSZ3dIjqVk5EYJa uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9saqbkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:11:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNAG5Y193634;
        Mon, 26 Oct 2020 23:11:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1q1v64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:11:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNBscE027676;
        Mon, 26 Oct 2020 23:11:54 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:11:54 -0700
Date:   Mon, 26 Oct 2020 16:11:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V7 11/14] xfs: Remove duplicate assert statement in
 xfs_bmap_btalloc()
Message-ID: <20201026231153.GB853509@magnolia>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-12-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019064048.6591-12-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 19, 2020 at 12:10:45PM +0530, Chandan Babu R wrote:
> The check for verifying if the allocated extent is from an AG whose
> index is greater than or equal to that of tp->t_firstblock is already
> done a couple of statements earlier in the same function. Hence this
> commit removes the redundant assert statement.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 505358839d2f..64c4d0e384a5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3699,7 +3699,6 @@ xfs_bmap_btalloc(
>  		ap->blkno = args.fsbno;
>  		if (ap->tp->t_firstblock == NULLFSBLOCK)
>  			ap->tp->t_firstblock = args.fsbno;
> -		ASSERT(nullfb || fb_agno <= args.agno);
>  		ap->length = args.len;
>  		/*
>  		 * If the extent size hint is active, we tried to round the
> -- 
> 2.28.0
> 
