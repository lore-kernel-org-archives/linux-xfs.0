Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504D8C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EFF620663
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:57:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GK7/9pR6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgCLO47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:56:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40060 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCLO47 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:56:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEgYBC088436;
        Thu, 12 Mar 2020 14:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=BOGJuYlKcv7ByTHSpmP0jRUP0NzqdNCYGHW84pyl62c=;
 b=GK7/9pR62IYueTuuTRtfDGmK03fjy82GRfOHlOFpU6nSb0M8ccbYhLIqMS6mRPGjiYPf
 4RsCACcU1WFTU+QUYKm/MX8IOituTkEaDUl+t8xztGlZ264S4a1YfXisbKSS5wDyUQGn
 x0tGFgM0HP20Lrf0EKoxFSV+oiumKCZ3Fe0V1iAnpIGMUzgwWSKOJKrhlvDZmdrba1bP
 4Vx/TacSzotuZeEYfoZHWx7/bksWiRZOk5G1rj3QMyK+8J4u7yBq1Fb7ViTCwE7ZiBGu
 VGHWllDrL/2YX4LafS/cwSJ/ggJ7EbXaCPT0U0dZXe2Xj0+gnwEW0T6GjZj7K8mUSGYy UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ym31ut32t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:56:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEoVNw023453;
        Thu, 12 Mar 2020 14:56:54 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yp8r0jhdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:56:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CEurSA016916;
        Thu, 12 Mar 2020 14:56:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:56:53 -0700
Date:   Thu, 12 Mar 2020 07:56:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: remove XFS_BUF_SET_BDSTRAT_FUNC
Message-ID: <20200312145652.GP8045@magnolia>
References: <20200312141715.550387-1-hch@lst.de>
 <20200312141715.550387-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312141715.550387-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120080
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120080
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 03:17:14PM +0100, Christoph Hellwig wrote:
> This function doesn't exist in the kernel and is purely a stub in
> xfsprogs, so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  libxfs/libxfs_priv.h | 1 -
>  libxfs/logitem.c     | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
> index 723dddcd..d07d8f32 100644
> --- a/libxfs/libxfs_priv.h
> +++ b/libxfs/libxfs_priv.h
> @@ -367,7 +367,6 @@ roundup_64(uint64_t x, uint32_t y)
>  #define XBF_DONE			0
>  #define xfs_buf_stale(bp)		((bp)->b_flags |= LIBXFS_B_STALE)
>  #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
> -#define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
>  
>  static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
>  		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c
> index b11df4fa..d0819dcb 100644
> --- a/libxfs/logitem.c
> +++ b/libxfs/logitem.c
> @@ -84,7 +84,6 @@ xfs_buf_item_init(
>  	 * the first.  If we do already have one, there is
>  	 * nothing to do here so return.
>  	 */
> -	XFS_BUF_SET_BDSTRAT_FUNC(bp, xfs_bdstrat_cb);
>  	if (bp->b_log_item != NULL) {
>  		lip = bp->b_log_item;
>  		if (lip->li_type == XFS_LI_BUF) {
> -- 
> 2.24.1
> 
