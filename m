Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828B1C433E5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 14:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CB7E207BC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 14:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kb06jFMV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgGPOkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:40:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44266 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbgGPOkE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 10:40:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GEb2Rs052083;
        Thu, 16 Jul 2020 14:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Fll4scLyJe+EbMalJoPV482QJoFsW6fcs9ktwDnwj/4=;
 b=Kb06jFMVx3FfiBWIwPx+JnEhhLQoQZFv2rFeKpYagtyoZqg9/DL5wvtpkiuzlxOmn+2f
 UwHwC7XJYbdBJcyHdiwZ3I+enJ9pEtLkPIHLjSFFFV2WgYJTWnIxDR+Sm4ZCOuu8RQiP
 sd1K6ueGWFQoSj35tmrR3mh9+8LbPhI5IugR9MqizHlL41N09jBwjLzS62d7/E4AJC3J
 RmUSgo1dkYuNTsLXYfaiKmDtemxSSI5jKq+aheOHnyE4yGKlTIXlut/rA0HRIMIcvQho
 cfzz3CSwlWELIIc9+KoZ7rMMUaoE+Y3CxAMbEIzFfcSSARYylCnKJrHagjwAnPyKVtTV xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3275cmhskk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 16 Jul 2020 14:40:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06GEbj9t160050;
        Thu, 16 Jul 2020 14:40:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 327q0tm7b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jul 2020 14:40:01 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06GEe0M8008565;
        Thu, 16 Jul 2020 14:40:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jul 2020 07:40:00 -0700
Date:   Thu, 16 Jul 2020 07:39:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: drain the buf delwri queue before xfsaild idles
Message-ID: <20200716143959.GJ3151642@magnolia>
References: <20200715123835.8690-1-bfoster@redhat.com>
 <20200716104941.32014-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716104941.32014-1-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160112
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 16, 2020 at 06:49:41AM -0400, Brian Foster wrote:
> xfsaild is racy with respect to transaction abort and shutdown in
> that the task can idle or exit with an empty AIL but buffers still
> on the delwri queue. This was partly addressed by cancelling the
> delwri queue before the task exits to prevent memory leaks, but it's
> also possible for xfsaild to empty and idle with buffers on the
> delwri queue. For example, a transaction that pins a buffer that
> also happens to sit on the AIL delwri queue will explicitly remove
> the associated log item from the AIL if the transaction aborts. The
> side effect of this is an unmount hang in xfs_wait_buftarg() as the
> associated buffers remain held by the delwri queue indefinitely.
> This is reproduced on repeated runs of generic/531 with an fs format
> (-mrmapbt=1 -bsize=1k) that happens to also reproduce transaction
> aborts.
> 
> Update xfsaild to not idle until both the AIL and associated delwri
> queue are empty and update the push code to continue delwri queue
> submission attempts even when the AIL is empty. This allows the AIL
> to eventually release aborted buffers stranded on the delwri queue
> when they are unlocked by the associated transaction. This should
> have no significant effect on normal runtime behavior because the
> xfsaild currently idles only when the AIL is empty and in practice
> the AIL is rarely empty with a populated delwri queue. The items
> must be AIL resident to land in the queue in the first place and
> generally aren't removed until writeback completes.
> 
> Note that the pre-existing delwri queue cancel logic in the exit
> path is retained because task stop is external, could technically
> come at any point, and xfsaild is still responsible to release its
> buffer references before it exits.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks fine to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> v2:
> - Move the out_done label up a bit.
> v1: https://lore.kernel.org/linux-xfs/20200715123835.8690-1-bfoster@redhat.com/
> 
>  fs/xfs/xfs_trans_ail.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index c3be6e440134..0c783d339675 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -448,16 +448,10 @@ xfsaild_push(
>  	target = ailp->ail_target;
>  	ailp->ail_target_prev = target;
>  
> +	/* we're done if the AIL is empty or our push has reached the end */
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
> -	if (!lip) {
> -		/*
> -		 * If the AIL is empty or our push has reached the end we are
> -		 * done now.
> -		 */
> -		xfs_trans_ail_cursor_done(&cur);
> -		spin_unlock(&ailp->ail_lock);
> +	if (!lip)
>  		goto out_done;
> -	}
>  
>  	XFS_STATS_INC(mp, xs_push_ail);
>  
> @@ -539,6 +533,8 @@ xfsaild_push(
>  			break;
>  		lsn = lip->li_lsn;
>  	}
> +
> +out_done:
>  	xfs_trans_ail_cursor_done(&cur);
>  	spin_unlock(&ailp->ail_lock);
>  
> @@ -546,7 +542,6 @@ xfsaild_push(
>  		ailp->ail_log_flush++;
>  
>  	if (!count || XFS_LSN_CMP(lsn, target) >= 0) {
> -out_done:
>  		/*
>  		 * We reached the target or the AIL is empty, so wait a bit
>  		 * longer for I/O to complete and remove pushed items from the
> @@ -638,7 +633,8 @@ xfsaild(
>  		 */
>  		smp_rmb();
>  		if (!xfs_ail_min(ailp) &&
> -		    ailp->ail_target == ailp->ail_target_prev) {
> +		    ailp->ail_target == ailp->ail_target_prev &&
> +		    list_empty(&ailp->ail_buf_list)) {
>  			spin_unlock(&ailp->ail_lock);
>  			freezable_schedule();
>  			tout = 0;
> -- 
> 2.21.3
> 
