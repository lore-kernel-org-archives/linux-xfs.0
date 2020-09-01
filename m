Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC6CC2BC0E
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FD9214D8
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 16:58:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GIVML+4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732310AbgIAQ63 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 12:58:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbgIAQ63 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 12:58:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081GsqIC013967;
        Tue, 1 Sep 2020 16:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=chjhHiC2k/sqNWn5/4uxgE//BhRfgaLCUPDPnlhOZvA=;
 b=GIVML+4jINdApfy/Z8/1qy+I88HQCLU4AF036hMYtfUkxOWFhLoCDlPg7grEw4CZtpR0
 fJxdq4gnMxYOaCmugXiAxYjZlkLTZZcVas5EX2fLUN68+oX8ikzXXSepNJmErDAc7EFl
 Opp62q5j648nHV632GR5NYd5tCZxQMBbgfrlbci0tNt6jTMJCAGAeBR6u9RIoayyRaW3
 YQTvnBB1Xzs7V1UBG0u7dRIWpIORErCv/6naq+5qKWguJ8XvbpsZJTPdXoazVwfVRWdn
 QjsE5pjREueJT/H/Juakd1dLfvHChZDwEzld9t8JDfH5oLRESkxtdk0Y7H5bT4uer4o4 lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eeqwqgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 16:58:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081Gt2OP055502;
        Tue, 1 Sep 2020 16:58:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3380ss523n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 16:58:24 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 081GwOmN017517;
        Tue, 1 Sep 2020 16:58:24 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 09:58:23 -0700
Date:   Tue, 1 Sep 2020 09:58:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/15] xfs: simplify xfs_trans_getsb
Message-ID: <20200901165821.GF6096@magnolia>
References: <20200901155018.2524-1-hch@lst.de>
 <20200901155018.2524-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901155018.2524-14-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 05:50:16PM +0200, Christoph Hellwig wrote:
> Remove the mp argument as this function is only called in transaction
> context, and open code xfs_getsb given that the function already accesses
> the buffer pointer in the mount point directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks pretty straightforward to me,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c |  4 ++--
>  fs/xfs/xfs_trans.c     |  2 +-
>  fs/xfs/xfs_trans.h     |  2 +-
>  fs/xfs/xfs_trans_buf.c | 46 ++++++++++++++----------------------------
>  4 files changed, 19 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ae9aaf1f34bfcc..15d03d96753769 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -954,7 +954,7 @@ xfs_log_sb(
>  	struct xfs_trans	*tp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_buf		*bp = xfs_trans_getsb(tp, mp);
> +	struct xfs_buf		*bp = xfs_trans_getsb(tp);
>  
>  	mp->m_sb.sb_icount = percpu_counter_sum(&mp->m_icount);
>  	mp->m_sb.sb_ifree = percpu_counter_sum(&mp->m_ifree);
> @@ -1084,7 +1084,7 @@ xfs_sync_sb_buf(
>  	if (error)
>  		return error;
>  
> -	bp = xfs_trans_getsb(tp, mp);
> +	bp = xfs_trans_getsb(tp);
>  	xfs_log_sb(tp);
>  	xfs_trans_bhold(tp, bp);
>  	xfs_trans_set_sync(tp);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index ed72867b1a1937..ca18a040336a1d 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -468,7 +468,7 @@ xfs_trans_apply_sb_deltas(
>  	xfs_buf_t	*bp;
>  	int		whole = 0;
>  
> -	bp = xfs_trans_getsb(tp, tp->t_mountp);
> +	bp = xfs_trans_getsb(tp);
>  	sbp = bp->b_addr;
>  
>  	/*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index b752501818d257..f46534b7523698 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -209,7 +209,7 @@ xfs_trans_read_buf(
>  				      flags, bpp, ops);
>  }
>  
> -struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
> +struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
>  
>  void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
>  void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 11cd666cd99a63..42d63b830cb9c8 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -166,50 +166,34 @@ xfs_trans_get_buf_map(
>  }
>  
>  /*
> - * Get and lock the superblock buffer of this file system for the
> - * given transaction.
> - *
> - * We don't need to use incore_match() here, because the superblock
> - * buffer is a private buffer which we keep a pointer to in the
> - * mount structure.
> + * Get and lock the superblock buffer for the given transaction.
>   */
> -xfs_buf_t *
> +struct xfs_buf *
>  xfs_trans_getsb(
> -	xfs_trans_t		*tp,
> -	struct xfs_mount	*mp)
> +	struct xfs_trans	*tp)
>  {
> -	xfs_buf_t		*bp;
> -	struct xfs_buf_log_item	*bip;
> +	struct xfs_buf		*bp = tp->t_mountp->m_sb_bp;
>  
>  	/*
> -	 * Default to just trying to lock the superblock buffer
> -	 * if tp is NULL.
> +	 * Just increment the lock recursion count if the buffer is already
> +	 * attached to this transaction.
>  	 */
> -	if (tp == NULL)
> -		return xfs_getsb(mp);
> -
> -	/*
> -	 * If the superblock buffer already has this transaction
> -	 * pointer in its b_fsprivate2 field, then we know we already
> -	 * have it locked.  In this case we just increment the lock
> -	 * recursion count and return the buffer to the caller.
> -	 */
> -	bp = mp->m_sb_bp;
>  	if (bp->b_transp == tp) {
> -		bip = bp->b_log_item;
> +		struct xfs_buf_log_item	*bip = bp->b_log_item;
> +
>  		ASSERT(bip != NULL);
>  		ASSERT(atomic_read(&bip->bli_refcount) > 0);
>  		bip->bli_recur++;
> +
>  		trace_xfs_trans_getsb_recur(bip);
> -		return bp;
> -	}
> +	} else {
> +		xfs_buf_lock(bp);
> +		xfs_buf_hold(bp);
> +		_xfs_trans_bjoin(tp, bp, 1);
>  
> -	bp = xfs_getsb(mp);
> -	if (bp == NULL)
> -		return NULL;
> +		trace_xfs_trans_getsb(bp->b_log_item);
> +	}
>  
> -	_xfs_trans_bjoin(tp, bp, 1);
> -	trace_xfs_trans_getsb(bp->b_log_item);
>  	return bp;
>  }
>  
> -- 
> 2.28.0
> 
