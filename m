Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DBCC47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 15:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FEFC20675
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 15:30:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U2GFKOIo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgEKPap (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 11:30:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgEKPao (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 11:30:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04BFQwaw114286;
        Mon, 11 May 2020 15:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=boYafM/TKjcGiK+98gXQJM4Zqt/d1KIvWkRnIcpKHxk=;
 b=U2GFKOIoiv1riBbZiKDO/GCuDXAQXYvs62QElX1N2HESDE3P6aJAB3jYNtYErQka2irQ
 28F9OGcxHk5CXY2lvjwD2xWIAAMvppC0jXKHzQpwMkWvZDxszTty0W3YWcWm9B46i3/C
 a7XJPh+iDj5htOhz1/ZsPc9W7SYpGE5a8RoLFrblWq2Lj++A3PV5A4a0V/Csd5wXiGX2
 3IoWjw6xVLEf3FJZ5QTfD8GT5HdcG8LC4G20J6bUk/SRiuroyXM4s/8I0FDuINxcJOoL
 v2u+PyI6WNGJur90wUVSTtswtNDhrW6Z3sA8EpZYA3MlXoh7iYpsYzbsnVINVXWOYqc5 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30x3gsdst5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 May 2020 15:29:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04BFRZFU035472;
        Mon, 11 May 2020 15:27:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30x63mwy27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 May 2020 15:27:53 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04BFRn6p023079;
        Mon, 11 May 2020 15:27:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 08:27:49 -0700
Date:   Mon, 11 May 2020 08:27:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] xfs: fix the warning message in xfs_validate_sb_common()
Message-ID: <20200511152748.GB6730@magnolia>
References: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9617 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=3
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005110122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9617 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 09, 2020 at 10:59:47PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> The warning message should be PQUOTA/GQUOTA_{ENFD|CHKD} can't along
> with superblock earlier than version 5, so fix it.

Huh?

Oh, I see, you're trying to fix someone's shortcut in the logging
messages.  This is clearer (to me, anyway):

“Fix this error message to complain about project and group quota flag
bits instead of "PUOTA" and "QUOTA".”

I'll commit the patch with the above changelog if that's ok?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index c526c5e5ab76..4df87546bd40 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -243,7 +243,7 @@ xfs_validate_sb_common(
>  	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>  				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
>  			xfs_notice(mp,
> -"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
> +"Superblock earlier than Version 5 has XFS_{P|G}QUOTA_{ENFD|CHKD} bits.");
>  			return -EFSCORRUPTED;
>  	}
>  
> -- 
> 2.20.0
> 
