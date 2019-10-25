Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E96CA9EA0
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F26D20867
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 05:24:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfkFO9Pb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392773AbfJYFY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 01:24:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37294 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392755AbfJYFY1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 01:24:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5NsCM111021;
        Fri, 25 Oct 2019 05:24:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=19aagtolIr1T7psW7Wq7YoCVJrjScZsByD71MhXwClM=;
 b=kfkFO9PbZi340/ct+ip+ATrRwdmSsRowmTpi2tZsfNyYtu/N6JEt84lN1CW9F+t0Yw4I
 4JzFQD3oOspPIHEpmNpj7/b09/bZusC1jICQlDgZh/ftU5NR2HqyDG7W7vaTtiBGKrgX
 Kc3mOoCPJIuSKIfJgziUcJNbGwdMErVm+n78MRJ9sV4/xRh1h5H4psxzRZROH4xSfwHt
 5fti/q4RKDuwQQBXHUp5w1jSppiD9RfzYY70o98Gq3olrD8Ay8MDhkTaQrAaetjwWBm6
 F1NdevP8SDYPbt2NXOalMtmn9W6U46BLzdiEvLNAoqp8qTO2koa0zQgzrfmqBj3uFX1z dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4r80vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:24:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9P5N8vf094060;
        Fri, 25 Oct 2019 05:24:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2vu0fqsvdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 05:24:22 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9P5OKpV025661;
        Fri, 25 Oct 2019 05:24:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 22:24:20 -0700
Date:   Thu, 24 Oct 2019 22:24:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: mark xfs_buf_free static
Message-ID: <20191025052419.GA913374@magnolia>
References: <20191025021458.20007-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025021458.20007-1-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910250052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9420 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910250052
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 11:14:58AM +0900, Christoph Hellwig wrote:
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
> index 0abba171aa89..9640e4174552 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -304,7 +304,7 @@ _xfs_buf_free_pages(
>   * 	The buffer must not be on any hash - use xfs_buf_rele instead for
>   * 	hashed and refcounted buffers
>   */
> -void
> +static void
>  xfs_buf_free(
>  	xfs_buf_t		*bp)
>  {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index f6ce17d8d848..56e081dd1d96 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -244,7 +244,6 @@ int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
>  void xfs_buf_hold(struct xfs_buf *bp);
>  
>  /* Releasing Buffers */
> -extern void xfs_buf_free(xfs_buf_t *);
>  extern void xfs_buf_rele(xfs_buf_t *);
>  
>  /* Locking and Unlocking Buffers */
> -- 
> 2.20.1
> 
