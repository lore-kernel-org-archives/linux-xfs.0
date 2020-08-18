Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D34AC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67E312067C
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:10:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="riyB/2Ho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHRWKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:10:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40810 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHRWKX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:10:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IM6tcu091553;
        Tue, 18 Aug 2020 22:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=e143vqPwAGuzZT67QUmZCBVzHvJXFSRkHOh0msMP5nE=;
 b=riyB/2Ho39g7Wb++FmIevjIjcmWk30jciQtqHxJtOb6gOfcqTpSFkLfgvfConwxPSq/Z
 6bykQrzF0XEdZUQ4i0NMs25TVDGe/d25HY5EztwAQ++aig2v0rJ9qcTlF2L5eucLrca8
 JWptb4XAoKjAslnyo08t/NDcf1v9IfonfuDanENfvnyZN8iiFJh30faMhCqqWu0XWqM6
 0gm5GGt42iyfRHfi1gn2Y08aYxiJH/SGWD7pt4Z7inFUSzatQY0aQmDKNxkPiBnW9Lqj
 7xvjIKe1/mhHLzB/plSspcDkSwb3Z7BndZ2OuSFTw6x+p9m655P13T5vfsMZRrK56Bgn /w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32x8bn7exw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:10:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IM4FhL168658;
        Tue, 18 Aug 2020 22:10:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32xsfsdnx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:10:18 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IMAHMt001171;
        Tue, 18 Aug 2020 22:10:17 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:10:16 -0700
Date:   Tue, 18 Aug 2020 15:10:15 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: mark xfs_buf_ioend static
Message-ID: <20200818221015.GC6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-3-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:42PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  fs/xfs/xfs_buf.h | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index dda0c94458797a..1bce6457a9b943 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1176,7 +1176,7 @@ xfs_buf_wait_unpin(
>   *	Buffer Utility Routines
>   */
>  
> -void
> +static void
>  xfs_buf_ioend(
>  	struct xfs_buf	*bp)
>  {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 755b652e695ace..bea20d43a38191 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -269,7 +269,6 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
>  
>  /* Buffer Read and Write Routines */
>  extern int xfs_bwrite(struct xfs_buf *bp);
> -extern void xfs_buf_ioend(struct xfs_buf *bp);
>  static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
>  {
>  	if (bp->b_flags & XBF_ASYNC)
> -- 
> 2.26.2
> 
