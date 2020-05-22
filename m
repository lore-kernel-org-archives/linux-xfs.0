Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BBDC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66D22100A
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 22:27:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rZM6ApbL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731122AbgEVW1Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 May 2020 18:27:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVW1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 18:27:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMLYK3041287;
        Fri, 22 May 2020 22:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=gdyWEUZatYOMPj71m6kWWpvg6YkN1xe2eSBgjUSFiCg=;
 b=rZM6ApbLjAS0nt5YDq/6Y8W8ikJtDFjTur+QVkeAIqup/vvE3C8BBN5PGcgYZo2bmjYJ
 ttqoQQnbUt64L+7LLtb/PEZryOFeXt8LJzbiS8A+4tO8f21Rvt2/w22pwCw+/UMGwvjb
 Jj4+wOFM6W9nzaeFJhAjA35NYfd/Jw7+9hxhotI33S3BNjfazdtptjOzzjWnHflgiJtE
 V+B6IRXV1GL4vcPUCJ3yBKBVRcw1oul8q1DaRuSvY928UXmjVanyH9sZtEFRoWhf6Veg
 spKLzcTShWMHrdrXJH3dGNNmxpngq0FP7bBbuWzzWDsFEH15f6QOPzo1NnZH1pVm3bIB 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rpgtk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 22:27:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMDIXw137530;
        Fri, 22 May 2020 22:27:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t3fvpa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 22:27:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MMRKTH014345;
        Fri, 22 May 2020 22:27:20 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 15:27:20 -0700
Date:   Fri, 22 May 2020 15:27:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: get rid of log item callbacks
Message-ID: <20200522222719.GO8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-12-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> They are not used anymore, so remove them from the log item and the
> buffer iodone attachment interfaces.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 17 -----------------
>  fs/xfs/xfs_buf_item.h |  3 ---
>  fs/xfs/xfs_dquot.c    |  6 +++---
>  fs/xfs/xfs_inode.c    |  5 +++--
>  fs/xfs/xfs_trans.h    |  3 ---
>  5 files changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index d44b3e3f46613..d855a2b7486c5 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -955,23 +955,6 @@ xfs_buf_item_relse(
>  	xfs_buf_item_free(bip);
>  }
>  
> -
> -/*
> - * Add the given log item with its callback to the list of callbacks
> - * to be called when the buffer's I/O completes.
> - */
> -void
> -xfs_buf_attach_iodone(
> -	struct xfs_buf		*bp,
> -	void			(*cb)(struct xfs_buf *, struct xfs_log_item *),
> -	struct xfs_log_item	*lip)
> -{
> -	ASSERT(xfs_buf_islocked(bp));
> -
> -	lip->li_cb = cb;
> -	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
> -}
> -
>  /*
>   * Invoke the error state callback for each log item affected by the failed I/O.
>   *
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 3f436efb0b67a..ecfad1915a86b 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -54,9 +54,6 @@ void	xfs_buf_item_relse(struct xfs_buf *);
>  bool	xfs_buf_item_put(struct xfs_buf_log_item *);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
> -void	xfs_buf_attach_iodone(struct xfs_buf *,
> -			      void(*)(struct xfs_buf *, struct xfs_log_item *),
> -			      struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
>  void	xfs_buf_dquot_iodone(struct xfs_buf *);
>  void	xfs_buf_dirty_iodone(struct xfs_buf *);
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 1d7f34a9bc989..34fc1bcb1eefd 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1191,11 +1191,11 @@ xfs_qm_dqflush(
>  	}
>  
>  	/*
> -	 * Attach an iodone routine so that we can remove this dquot from the
> -	 * AIL and release the flush lock once the dquot is synced to disk.
> +	 * Attach the dquot to the buffer so that we can remove this dquot from
> +	 * the AIL and release the flush lock once the dquot is synced to disk.
>  	 */
>  	bp->b_flags |= _XBF_DQUOTS;
> -	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
> +	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
>  
>  	/*
>  	 * If the buffer is pinned then push on the log so we won't
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c75d625de7945..c5529853f513c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2690,7 +2690,8 @@ xfs_ifree_cluster(
>  			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
>  						&iip->ili_item.li_lsn);
>  
> -			xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
> +			list_add_tail(&iip->ili_item.li_bio_list,
> +						&bp->b_li_list);
>  
>  			if (ip != free_ip)
>  				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -3840,7 +3841,7 @@ xfs_iflush_int(
>  	 * the flush lock.
>  	 */
>  	bp->b_flags |= _XBF_INODES;
> -	xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
> +	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
>  
>  	/* generate the checksum. */
>  	xfs_dinode_calc_crc(mp, dip);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 8308bf6d7e404..d27429e3a82a6 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -37,9 +37,6 @@ struct xfs_log_item {
>  	unsigned long			li_flags;	/* misc flags */
>  	struct xfs_buf			*li_buf;	/* real buffer pointer */
>  	struct list_head		li_bio_list;	/* buffer item list */
> -	void				(*li_cb)(struct xfs_buf *,
> -						 struct xfs_log_item *);
> -							/* buffer item iodone */
>  							/* callback func */

You could get rid of this comment too.

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	const struct xfs_item_ops	*li_ops;	/* function list */
>  
> -- 
> 2.26.2.761.g0e0b3e54be
> 
