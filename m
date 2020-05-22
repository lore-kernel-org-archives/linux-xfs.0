Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748A5C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434902068D
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KaSdhJnc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgEVWBS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 18:01:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731051AbgEVWBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 18:01:16 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLvu3D048287;
        Fri, 22 May 2020 22:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=68QGJT9b4kqMLEdn/mML6FIO4H24MNY/Mz/ESvFED9A=;
 b=KaSdhJnccG+mmEsgYkokg+cn6xTrxPqnRLDN8bLe4PWf8KTAvmKGezI6ZBUZINbrHsvJ
 3+IL6uXbp5WhFjRNxlnTOwg532fKWMLZH9ysfKJLLtxbvaH3k/cQOQL8ARC5lLZif3hH
 Xf6i1Kzb/jW/N3xk4cmp0wNnEMS/UPQJ0vCxUZAletrKLdm0fzm9bduDw+skmC1Ljeby
 U4I2PbJTnielpLgYeswBU0laW0SXUDOc7XfPKd5Y4B2CeU2mtrDD6QKjJ+FchMuDf2UW
 vt019Rl8j+WKIKRAkdQBmQKBlmfRNzqnSDXYZriA61zxHwa32vM0RHwg51r523HWZSzk OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284mfwjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 22:01:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MLwkU0118095;
        Fri, 22 May 2020 22:01:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 313gj87u84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 22:01:14 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MM1D1x005473;
        Fri, 22 May 2020 22:01:13 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 15:01:13 -0700
Date:   Fri, 22 May 2020 15:01:12 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/24] xfs: clean up whacky buffer log item list reinit
Message-ID: <20200522220112.GK8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-8-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=1 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we've emptied the buffer log item list, it does a list_del_init
> on itself to reset it's pointers to itself. This is unnecessary as
> the list is already empty at this point. I'm guessing this was a
> bandaid for a iodone item leak or list corruption at some point in
> the past, and we've carried it ever since. Get rid of it.

It's not even a bandaid, it's merely an unnecessary wart from the
conversion to list_head... that I RVBd.  Sigh.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index c2e7d14e35c66..b7ffb117e141e 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -459,7 +459,6 @@ xfs_buf_item_unpin(
>  		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
>  			xfs_buf_do_callbacks(bp);
>  			bp->b_log_item = NULL;
> -			list_del_init(&bp->b_li_list);
>  		} else {
>  			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
>  			xfs_buf_item_relse(bp);
> @@ -1165,7 +1164,6 @@ xfs_buf_run_callbacks(
>  
>  	xfs_buf_do_callbacks(bp);
>  	bp->b_log_item = NULL;
> -	list_del_init(&bp->b_li_list);
>  }
>  
>  /*
> -- 
> 2.26.2.761.g0e0b3e54be
> 
