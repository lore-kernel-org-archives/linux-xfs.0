Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D16EC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6137A2065D
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="woB1KUqK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHRWyy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:54:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40900 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgHRWyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:54:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMqS89186136;
        Tue, 18 Aug 2020 22:54:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=TwWrV3B75+gMajlYbCM+4qAqKtnHxYI2wE18zQHwwWo=;
 b=woB1KUqKO8gjASU+X6rNiy9qMyZ+NmvS21JX1HC5lcuf8e77HfndqwuyUvoFGOxwetlA
 kT56q2zqm+MOMUaqw4nBf03VaGEDxdrMh2ThWucCkcAMTuvA+iH0TRIt2KUgLt/YnAml
 SPOe3YtE3RrytunjnldWP2XnKLoEl4oGwZOKnwcI7Gj+2/oojlhJT4c7DVUqihEDjrp3
 JNl39ftbpEV1fdh3Cd06bij1U8WKVD8AQjyTZE3wZ/UAD0oQ5+yczRewUBlmuW+5DHuL
 XwgAkhMBYGmm1uIWQyMgLgBbYZnpns0J02kQWaoSObS8K2M40dTKD/SbNAQHIyXWHH7+ rg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74r7pg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:54:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IMsFA0088114;
        Tue, 18 Aug 2020 22:54:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32xsfsekkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:54:50 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IMsnMG004154;
        Tue, 18 Aug 2020 22:54:49 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:54:49 -0700
Date:   Tue, 18 Aug 2020 15:54:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/13] xfs: remove xlog_recover_iodone
Message-ID: <20200818225447.GM6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-13-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:52PM +0200, Christoph Hellwig wrote:
> The log recovery I/O completion handler does not substancially differ from

"substantially"

> the normal one except for the fact that we:
> 
>  a) never retry failed writes
>  b) can have log items that aren't on the AIL
>  c) never have inode/dquot log items attached and thus don't need to
>     handle them
> 
> Add conditionals for (a) and (b) to the ioend code, while (c) doesn't
> need special handling anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With that one typo fixed:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_log_recover.h |  1 -
>  fs/xfs/xfs_buf.c                | 20 ++++++++++++--------
>  fs/xfs/xfs_buf_item.c           |  4 ++++
>  fs/xfs/xfs_buf_item_recover.c   |  2 +-
>  fs/xfs/xfs_log_recover.c        | 25 -------------------------
>  5 files changed, 17 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 641132d0e39ddd..3cca2bfe714cb2 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -121,7 +121,6 @@ struct xlog_recover {
>  void xlog_buf_readahead(struct xlog *log, xfs_daddr_t blkno, uint len,
>  		const struct xfs_buf_ops *ops);
>  bool xlog_is_buffer_cancelled(struct xlog *log, xfs_daddr_t blkno, uint len);
> -void xlog_recover_iodone(struct xfs_buf *bp);
>  
>  void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
>  		uint64_t intent_id);
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8bbd28f39a927b..1172d5fa06aad2 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1241,6 +1241,15 @@ xfs_buf_ioend_handle_error(
>  
>  	xfs_buf_ioerror_alert_ratelimited(bp);
>  
> +	/*
> +	 * We're not going to bother about retrying this during recovery.
> +	 * One strike!
> +	 */
> +	if (bp->b_flags & _XBF_LOGRECOVERY) {
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		return false;
> +	}
> +
>  	/*
>  	 * Synchronous writes will have callers process the error.
>  	 */
> @@ -1310,13 +1319,6 @@ xfs_buf_ioend(
>  			bp->b_ops->verify_read(bp);
>  		if (!bp->b_error)
>  			bp->b_flags |= XBF_DONE;
> -	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
> -		/*
> -		 * If this is a log recovery buffer, we aren't doing
> -		 * transactional I/O yet so we need to let the log recovery code
> -		 * handle I/O completions:
> -		 */
> -		xlog_recover_iodone(bp);
>  	} else {
>  		if (!bp->b_error) {
>  			bp->b_flags &= ~XBF_WRITE_FAIL;
> @@ -1343,9 +1345,11 @@ xfs_buf_ioend(
>  			xfs_buf_inode_iodone(bp);
>  		else if (bp->b_flags & _XBF_DQUOTS)
>  			xfs_buf_dquot_iodone(bp);
> +
>  	}
>  
> -	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
> +	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD |
> +			 _XBF_LOGRECOVERY);
>  
>  	if (bp->b_flags & XBF_ASYNC)
>  		xfs_buf_relse(bp);
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index ccfd747d32e410..ab87c1294f7584 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -967,8 +967,12 @@ xfs_buf_item_done(
>  	 * xfs_trans_ail_delete() takes care of these.
>  	 *
>  	 * Either way, AIL is useless if we're forcing a shutdown.
> +	 *
> +	 * Note that log recovery writes might have buffer items that are not on
> +	 * the AIL during normal operations.
>  	 */
>  	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
> +			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
>  			     SHUTDOWN_CORRUPT_INCORE);
>  	xfs_buf_item_relse(bp);
>  }
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 74c851f60eeeb1..1bbae3ab1322f7 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -414,7 +414,7 @@ xlog_recover_validate_buf_type(
>  	 *
>  	 * Write verifiers update the metadata LSN from log items attached to
>  	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
> -	 * the verifier. We'll clean it up in our ->iodone() callback.
> +	 * the verifier.
>  	 */
>  	if (bp->b_ops) {
>  		struct xfs_buf_log_item	*bip;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 741a2c247bc585..b181f3253e6e74 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -265,31 +265,6 @@ xlog_header_check_mount(
>  	return 0;
>  }
>  
> -void
> -xlog_recover_iodone(
> -	struct xfs_buf	*bp)
> -{
> -	if (!bp->b_error) {
> -		bp->b_flags |= XBF_DONE;
> -	} else if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
> -		/*
> -		 * We're not going to bother about retrying this during
> -		 * recovery. One strike!
> -		 */
> -		xfs_buf_ioerror_alert(bp, __this_address);
> -		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
> -	}
> -
> -	/*
> -	 * On v5 supers, a bli could be attached to update the metadata LSN.
> -	 * Clean it up.
> -	 */
> -	if (bp->b_log_item)
> -		xfs_buf_item_relse(bp);
> -	ASSERT(bp->b_log_item == NULL);
> -	bp->b_flags &= ~_XBF_LOGRECOVERY;
> -}
> -
>  /*
>   * This routine finds (to an approximation) the first block in the physical
>   * log which contains the given cycle.  It uses a binary search algorithm.
> -- 
> 2.26.2
> 
