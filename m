Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D52C3A5A4
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35F862341B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PCHgwM5b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfH3PPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:15:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35696 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfH3PPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:15:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UFDF5P140520;
        Fri, 30 Aug 2019 15:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=sdDTBA/8oEbWx6V2F6UvlLiz5BIwaBwFsNeIVacy9Wk=;
 b=PCHgwM5brlQDjR7LaS3nK1TQ04sg5RqO1p7iisVLK5Y262vLcgU6G4kY/tv/6pPlqS20
 aQ2AWMYGDWOjaAYEXCJdfM1tiztoRnjcMpodXT/N1Yi3Lry3Wi5ep69bNVWagflssQxf
 skYn0XGIwYXuZcSemq76kS7E5mht/1wEH+kdiDpyeum4BE76vLsoZh+MiKgjmglgYdFj
 XyapOfazQRUyFjaSNwmdjae7XmhaAhfRvLUbEwu/HuAo0rDqzFT/9ZUJeO2kLCjr60xh
 n5uJBWj9X1oRvsRkK7KZH8G2Cmh3MFzWgUv51Q3MWEhUpknX+0aSaR2PwrvOltdNmG9k EA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2uq67401jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:15:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF8gie075052;
        Fri, 30 Aug 2019 15:15:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2upxabdu93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:15:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7UFFcmw027856;
        Fri, 30 Aug 2019 15:15:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 08:15:37 -0700
Date:   Fri, 30 Aug 2019 08:15:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     yu kuai <yukuai3@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhengbin13@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH] xfs: add function name in xfs_trans_ail_delete function
 header comments
Message-ID: <20190830151536.GE5354@magnolia>
References: <1567162789-137056-1-git-send-email-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567162789-137056-1-git-send-email-yukuai3@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 06:59:49PM +0800, yu kuai wrote:
> Fix following warning:
> make W=1 fs/xfs/xfs_trans_ail.o
> fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member 
> 'ailp' not described in 'xfs_trans_ail_delete'
> fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
> 'lip' not described in 'xfs_trans_ail_delete'
> fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
> 'shutdown_type' not described in 'xfs_trans_ail_delete'
> 
> Since function parameters are described in the comments aready,
> there is no need to add parameter comments.
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
>  fs/xfs/xfs_trans_ail.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 6ccfd75..b69cf59 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -764,8 +764,8 @@ xfs_ail_delete_one(
>  	return mlip == lip;
>  }
>  
> -/**
> - * Remove a log items from the AIL
> +/*
> + * xfs_trans_ail_delete - remove a log items from the AIL
>   *
>   * @xfs_trans_ail_delete_bulk takes an array of log items that all need to

xfs_trans_ail_delete_bulk no longer exists.  xfs_trans_ail_delete does
not take an array of log items.  The whole comment needs to be revised
since the bulk log itme delete code was pushed into _iflush_done:

See 27af1bbf52445996 ("xfs: remove xfs_trans_ail_delete_bulk")

Erp, my bad for letting that through. :(

--D

>   * removed from the AIL. The caller is already holding the AIL lock, and done
> -- 
> 2.7.4
> 
