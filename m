Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B4BC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677142067C
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 22:09:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pQ5RcFlb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgHRWJ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 18:09:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHRWJ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 18:09:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IM8aHK115783;
        Tue, 18 Aug 2020 22:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9TDIhNc1fkK8G91AzeodEFprZVCjD2ZCiO8L40VbdzM=;
 b=pQ5RcFlbRcQhImFeLboDHTX90Yi6uEv6LdZz3hbklfGSy7QoVBAU+IjAzOWBzSFK/KHY
 MiS/QOnST7M8EjaOEql6SLuvsP7+Yr5g65DQ6J/yYUOhNi3MbcO/KR/GMnt+LbjVmokJ
 gSaYC+JHx9FabHcQqWKoAsPLjlAHhs7Xsp+lbXapwLeo2oW+MKAdjyq29hn6EEKLtJ/y
 /u5XpSc5GhTHX+ix14Cuair5V2GNB2QCCsLo8ycMAAlHzDvZW+5JlpEd+dEOpfmu/bo1
 hPxDEwu8ZkpBP9zeun/uh/pbb5PfddiIoorGEWOfCzU1Lk/KTHsr7+R+0bqn04NlqU2F oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 32x74r7jbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 22:09:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IM4FXc168683;
        Tue, 18 Aug 2020 22:09:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32xsfsdn3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 22:09:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07IM9FKc012077;
        Tue, 18 Aug 2020 22:09:15 GMT
Received: from localhost (/10.159.129.94)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 15:09:15 -0700
Date:   Tue, 18 Aug 2020 15:09:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/13] xfs: refactor the buf ioend disposition code
Message-ID: <20200818220913.GB6096@magnolia>
References: <20200709150453.109230-1-hch@lst.de>
 <20200709150453.109230-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709150453.109230-2-hch@lst.de>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=1 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=1 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 05:04:41PM +0200, Christoph Hellwig wrote:
> Handle the no-error case in xfs_buf_iodone_error as well, and to clarify
> the code rename the function, use the actual enum type as return value
> and then switch on it in the callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems pretty straightforward to me, sorry I didn't get to this earlier...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 115 +++++++++++++++++++++++-------------------
>  1 file changed, 62 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index e9428c30862a98..19896884189973 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1046,24 +1046,27 @@ xfs_buf_ioerror_permanent(
>   *
>   * Multi-state return value:
>   *
> - * XBF_IOERROR_FINISH: clear IO error retry state and run callback completions
> - * XBF_IOERROR_DONE: resubmitted immediately, do not run any completions
> - * XBF_IOERROR_FAIL: transient error, run failure callback completions and then
> + * XBF_IOEND_FINISH: run callback completions
> + * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
> + * XBF_IOEND_FAIL: transient error, run failure callback completions and then
>   *    release the buffer
>   */
> -enum {
> -	XBF_IOERROR_FINISH,
> -	XBF_IOERROR_DONE,
> -	XBF_IOERROR_FAIL,
> +enum xfs_buf_ioend_disposition {
> +	XBF_IOEND_FINISH,
> +	XBF_IOEND_DONE,
> +	XBF_IOEND_FAIL,
>  };
>  
> -static int
> -xfs_buf_iodone_error(
> +static enum xfs_buf_ioend_disposition
> +xfs_buf_ioend_disposition(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_mount;
>  	struct xfs_error_cfg	*cfg;
>  
> +	if (likely(!bp->b_error))
> +		return XBF_IOEND_FINISH;
> +
>  	if (xfs_buf_ioerror_fail_without_retry(bp))
>  		goto out_stale;
>  
> @@ -1073,7 +1076,7 @@ xfs_buf_iodone_error(
>  	if (xfs_buf_ioerror_retry(bp, cfg)) {
>  		xfs_buf_ioerror(bp, 0);
>  		xfs_buf_submit(bp);
> -		return XBF_IOERROR_DONE;
> +		return XBF_IOEND_DONE;
>  	}
>  
>  	/*
> @@ -1086,13 +1089,13 @@ xfs_buf_iodone_error(
>  	}
>  
>  	/* Still considered a transient error. Caller will schedule retries. */
> -	return XBF_IOERROR_FAIL;
> +	return XBF_IOEND_FAIL;
>  
>  out_stale:
>  	xfs_buf_stale(bp);
>  	bp->b_flags |= XBF_DONE;
>  	trace_xfs_buf_error_relse(bp, _RET_IP_);
> -	return XBF_IOERROR_FINISH;
> +	return XBF_IOEND_FINISH;
>  }
>  
>  static void
> @@ -1128,6 +1131,19 @@ xfs_buf_clear_ioerror_retry_state(
>  	bp->b_first_retry_time = 0;
>  }
>  
> +static void
> +xfs_buf_inode_io_fail(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip;
> +
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +		set_bit(XFS_LI_FAILED, &lip->li_flags);
> +
> +	xfs_buf_ioerror(bp, 0);
> +	xfs_buf_relse(bp);
> +}
> +
>  /*
>   * Inode buffer iodone callback function.
>   */
> @@ -1135,30 +1151,36 @@ void
>  xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (bp->b_error) {
> -		struct xfs_log_item *lip;
> -		int ret = xfs_buf_iodone_error(bp);
> -
> -		if (ret == XBF_IOERROR_FINISH)
> -			goto finish_iodone;
> -		if (ret == XBF_IOERROR_DONE)
> -			return;
> -		ASSERT(ret == XBF_IOERROR_FAIL);
> -		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> -			set_bit(XFS_LI_FAILED, &lip->li_flags);
> -		}
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_relse(bp);
> +	switch (xfs_buf_ioend_disposition(bp)) {
> +	case XBF_IOEND_DONE:
> +		return;
> +	case XBF_IOEND_FAIL:
> +		xfs_buf_inode_io_fail(bp);
>  		return;
> +	default:
> +		break;
>  	}
>  
> -finish_iodone:
>  	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_iflush_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> +static void
> +xfs_buf_dquot_io_fail(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_log_item	*lip;
> +
> +	spin_lock(&bp->b_mount->m_ail->ail_lock);
> +	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
> +		xfs_set_li_failed(lip, bp);
> +	spin_unlock(&bp->b_mount->m_ail->ail_lock);
> +	xfs_buf_ioerror(bp, 0);
> +	xfs_buf_relse(bp);
> +}
> +
>  /*
>   * Dquot buffer iodone callback function.
>   */
> @@ -1166,26 +1188,16 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (bp->b_error) {
> -		struct xfs_log_item *lip;
> -		int ret = xfs_buf_iodone_error(bp);
> -
> -		if (ret == XBF_IOERROR_FINISH)
> -			goto finish_iodone;
> -		if (ret == XBF_IOERROR_DONE)
> -			return;
> -		ASSERT(ret == XBF_IOERROR_FAIL);
> -		spin_lock(&bp->b_mount->m_ail->ail_lock);
> -		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> -			xfs_set_li_failed(lip, bp);
> -		}
> -		spin_unlock(&bp->b_mount->m_ail->ail_lock);
> -		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_relse(bp);
> +	switch (xfs_buf_ioend_disposition(bp)) {
> +	case XBF_IOEND_DONE:
> +		return;
> +	case XBF_IOEND_FAIL:
> +		xfs_buf_dquot_io_fail(bp);
>  		return;
> +	default:
> +		break;
>  	}
>  
> -finish_iodone:
>  	xfs_buf_clear_ioerror_retry_state(bp);
>  	/* a newly allocated dquot buffer might have a log item attached */
>  	xfs_buf_item_done(bp);
> @@ -1203,21 +1215,18 @@ void
>  xfs_buf_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (bp->b_error) {
> -		int ret = xfs_buf_iodone_error(bp);
> -
> -		if (ret == XBF_IOERROR_FINISH)
> -			goto finish_iodone;
> -		if (ret == XBF_IOERROR_DONE)
> -			return;
> -		ASSERT(ret == XBF_IOERROR_FAIL);
> +	switch (xfs_buf_ioend_disposition(bp)) {
> +	case XBF_IOEND_DONE:
> +		return;
> +	case XBF_IOEND_FAIL:
>  		ASSERT(list_empty(&bp->b_li_list));
>  		xfs_buf_ioerror(bp, 0);
>  		xfs_buf_relse(bp);
>  		return;
> +	default:
> +		break;
>  	}
>  
> -finish_iodone:
>  	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_buf_ioend_finish(bp);
> -- 
> 2.26.2
> 
