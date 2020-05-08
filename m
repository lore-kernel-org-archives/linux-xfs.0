Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E6BC38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826F5207DD
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 15:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dOonx76Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEHPuu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 11:50:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49244 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbgEHPut (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 11:50:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048Flqql086966;
        Fri, 8 May 2020 15:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=1sTgKXU7W9dWR2eeT7XTGmnfbefUcqN0VWy9vFMDr1U=;
 b=dOonx76ZHWtn4huwnI3ZLFxk0XY5MK/L0BTBYwv3MbAZcEUYMQpR/6sjC17+HB3SkhuB
 hDrqvSpjehRazOIcIUPHp1ZmnAg4KzzHoehO4RwcpgONwg/s32+kcRJ7kmTmZDu5BGBO
 OMJHxgeeMtg4nRQKsUxVymf9T3U/TzFLsrsxlAynqy2C/UYFomhLpFrOo8j+fNvL9POI
 xy20TP/F/cFOS52YL0UgPSN2s4DjCOTn3cJHHxJWyf2YV3pZ4xQOkn3d/KOz/mNjZ5w1
 RYlnbCKXlimscTTiZEa6BTVTg8EArVxAns90GAXjwpQ75A0a/LAgv1rkjVvzNL9mXTqn BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30vtewur06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 15:50:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048FfsZ2193302;
        Fri, 8 May 2020 15:50:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30vtecsy1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 15:50:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 048Fojg4020012;
        Fri, 8 May 2020 15:50:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 08:50:45 -0700
Date:   Fri, 8 May 2020 08:50:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unused variable warning in buffer completion on
 !DEBUG
Message-ID: <20200508155044.GL6714@magnolia>
References: <20200508111518.27b22640@canb.auug.org.au>
 <20200508105559.27037-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508105559.27037-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 08, 2020 at 06:55:59AM -0400, Brian Foster wrote:
> The random buffer write failure errortag patch introduced a local
> mount pointer variable for the test macro, but the macro is compiled
> out on !DEBUG kernels. This results in an unused variable warning.
> 
> Access the mount structure through the buffer pointer and remove the
> local mount pointer to address the warning.
> 
> Fixes: 7376d745473 ("xfs: random buffer write failure errortag")
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Feel free to fold this into the original commit or merge independently.
> Sorry for the noise..
> 
> Brian
> 
>  fs/xfs/xfs_buf.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 9d8841ac7375..9c2fbb6bbf89 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1289,11 +1289,10 @@ xfs_buf_bio_end_io(
>  	struct bio		*bio)
>  {
>  	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
> -	struct xfs_mount	*mp = bp->b_mount;
>  
>  	if (!bio->bi_status &&
>  	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
> -	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
> +	    XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
>  		bio->bi_status = BLK_STS_IOERR;
>  
>  	/*
> -- 
> 2.21.1
> 
