Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB40C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 19:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37CA1206A2
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 19:00:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JRyVNl3d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbgFBTAs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 15:00:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59514 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBTAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 15:00:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052Iw8BJ072990;
        Tue, 2 Jun 2020 19:00:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=EuiVg19W9jK5zM2sCQHLo1jzDY2PGQ/GN6RcR91V2V8=;
 b=JRyVNl3d+xiXxYqOy1qpRDicfEjfLBb0QUFfyGYwKZBcVWWI6Tv1LrRnDEu4GZpyambu
 uUAJZfxVZnkA8FcCk07ZtvY3HTUPZ5bHLWi2uwyy8zXoec4IwFrYj3MKaT2v78MLKSGu
 GkaJ3clJMIP3hQNpRkVdXSf/WuUGApllVM50L/p4iHTruT/90yDeE0t/pD9UgC2KXFsA
 i4kH2XpWTZFCJHz4lOEkQvSoLqfMQPG0DGee3lPbT//OAOpSVQtHOZ6tSsSUUSf6vkqx
 Nxw3SJKNItIjCDPTK8HA65zBj+VO+7f42xOMLepTnhT6LY5E9Nicezcnhj4K+6Vt8jTF 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31dkrujpp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 19:00:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IxFiA088522;
        Tue, 2 Jun 2020 19:00:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dxr9ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 19:00:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052J0j8t018403;
        Tue, 2 Jun 2020 19:00:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 12:00:44 -0700
Date:   Tue, 2 Jun 2020 12:00:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/30] xfs: mark dquot buffers in cache
Message-ID: <20200602190043.GF8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-6-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=1 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 suspectscore=1 malwarescore=0 clxscore=1015
 adultscore=0 mlxlogscore=999 cotscore=-2147483648 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020137
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:26AM +1000, Dave Chinner wrote:
> dquot buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
> 
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf.c       |  5 +++++
>  fs/xfs/xfs_buf.h       |  2 ++
>  fs/xfs/xfs_buf_item.c  | 10 ++++++++++
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_dquot.c     |  1 +
>  fs/xfs/xfs_trans_buf.c |  1 +
>  6 files changed, 20 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index fcf650575be61..3bffde8640a52 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1212,6 +1212,11 @@ xfs_buf_ioend(
>  		return;
>  	}
>  
> +	if (bp->b_flags & _XBF_DQUOTS) {
> +		xfs_buf_dquot_iodone(bp);
> +		return;
> +	}
> +
>  	if (bp->b_iodone) {
>  		(*(bp->b_iodone))(bp);
>  		return;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 2400cb90a04c6..c1d0843206dd6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -32,6 +32,7 @@
>  
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES	 (1 << 16)/* inode buffer */
> +#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> @@ -54,6 +55,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_INODES,		"INODES" }, \
> +	{ _XBF_DQUOTS,		"DQUOTS" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8659cf4282a64..a42cdf9ccc47d 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1210,6 +1210,16 @@ xfs_buf_inode_iodone(
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> +/*
> + * Dquot buffer iodone callback function.
> + */
> +void
> +xfs_buf_dquot_iodone(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
> +	xfs_buf_ioend_finish(bp);
> +}
>  
>  /*
>   * This is the iodone() function for buffers which have been
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index a342933ad9b8d..27d13d29b5bbb 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -60,6 +60,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
> +void	xfs_buf_dquot_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8d..2e2146fa0914c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1179,6 +1179,7 @@ xfs_qm_dqflush(
>  	 * Attach an iodone routine so that we can remove this dquot from the
>  	 * AIL and release the flush lock once the dquot is synced to disk.
>  	 */
> +	bp->b_flags |= _XBF_DQUOTS;
>  	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
>  				  &dqp->q_logitem.qli_item);
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 552d0869aa0fe..93d62cb864c15 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -788,5 +788,6 @@ xfs_trans_dquot_buf(
>  		break;
>  	}
>  
> +	bp->b_flags |= _XBF_DQUOTS;
>  	xfs_trans_buf_set_type(tp, bp, type);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 
