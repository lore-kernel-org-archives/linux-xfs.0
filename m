Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0A1C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:12:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E6C620828
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:12:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XfKs5DhR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389563AbfIFAMp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:12:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389391AbfIFAMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 20:12:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8609IsY127689;
        Fri, 6 Sep 2019 00:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=RaWutCGuvEsb/cGB2u4Huwvw8b9lk7OJdCQ71s2Hmi0=;
 b=XfKs5DhRZBN45xx2vG94EAoqGYd/f50NXiQAH/Ws9CCGiYAKQQh7ABe5IRN43lHWTnz0
 K137aVkp5jnm5u10bsTG9UvMScuRUjRDAbaDMZhRBXGDyrAexnynsNXla/qIBARRlaGm
 HjSauR2RyD2UTJ+ofToRqK2LBQAtokF+mFRTumrJnYlgdOxPcztFYhApke9s5kIgdm0I
 y0TlzJCcXi+RPaoSGpv/uJGZHoFWyWj/uvengEPQDZlRhnqlqMt1cGsOUxXfZ7BQdpzs
 Ehtu/+5tEh4Eoquz51IJAlIJGfxc5KEQ5fQQ2gTak1oUho8lSIJ5mUbQDknMyV+4zbl4 ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uucg2r15k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 00:12:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8608QeB124013;
        Fri, 6 Sep 2019 00:12:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b96c9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 00:12:42 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x860Cf8w024364;
        Fri, 6 Sep 2019 00:12:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 17:12:41 -0700
Date:   Thu, 5 Sep 2019 17:12:40 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: push the AIL in xlog_grant_head_wake
Message-ID: <20190906001240.GL2229799@magnolia>
References: <20190906000553.6740-1-david@fromorbit.com>
 <20190906000553.6740-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906000553.6740-2-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 10:05:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> In the situation where the log is full and the CIL has not recently
> flushed, the AIL push threshold is throttled back to the where the
> last write of the head of the log was completed. This is stored in
> log->l_last_sync_lsn. Hence if the CIL holds > 25% of the log space
> pinned by flushes and/or aggregation in progress, we can get the
> situation where the head of the log lags a long way behind the
> reservation grant head.
> 
> When this happens, the AIL push target is trimmed back from where
> the reservation grant head wants to push the log tail to, back to
> where the head of the log currently is. This means the push target
> doesn't reach far enough into the log to actually move the tail
> before the transaction reservation goes to sleep.
> 
> When the CIL push completes, it moves the log head forward such that
> the AIL push target can now be moved, but that has no mechanism for
> puhsing the log tail. Further, if the next tail movement of the log
> is not large enough wake the waiter (i.e. still not enough space for
> it to have a reservation granted), we don't wake anything up, and
> hence we do not update the AIL push target to take into account the
> head of the log moving and allowing the push target to be moved
> forwards.
> 
> To avoid this particular condition, if we fail to wake the first
> waiter on the grant head because we don't have enough space,
> push on the AIL again. This will pick up any movement of the log
> head and allow the push target to move forward due to completion of
> CIL pushing.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b159a9e9fef0..c2862b1a2780 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -214,15 +214,42 @@ xlog_grant_head_wake(
>  {
>  	struct xlog_ticket	*tic;
>  	int			need_bytes;
> +	bool			woken_task = false;
>  
>  	list_for_each_entry(tic, &head->waiters, t_queue) {
> +
> +		/*
> +		 * The is a chance that the size of the CIL checkpoints in

"There is a chance..."

Other than that,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +		 * progress at the last AIL push target calculation resulted in
> +		 * limiting the target to the log head (l_last_sync_lsn) at the
> +		 * time. This may not reflect where the log head is now as the
> +		 * CIL checkpoints may have completed.
> +		 *
> +		 * Hence when we are woken here, it may be that the head of the
> +		 * log that has moved rather than the tail. As the tail didn't
> +		 * move, there still won't be space available for the
> +		 * reservation we require.  However, if the AIL has already
> +		 * pushed to the target defined by the old log head location, we
> +		 * will hang here waiting for something else to update the AIL
> +		 * push target.
> +		 *
> +		 * Therefore, if there isn't space to wake the first waiter on
> +		 * the grant head, we need to push the AIL again to ensure the
> +		 * target reflects both the current log tail and log head
> +		 * position before we wait for the tail to move again.
> +		 */
> +
>  		need_bytes = xlog_ticket_reservation(log, head, tic);
> -		if (*free_bytes < need_bytes)
> +		if (*free_bytes < need_bytes) {
> +			if (!woken_task)
> +				xlog_grant_push_ail(log, need_bytes);
>  			return false;
> +		}
>  
>  		*free_bytes -= need_bytes;
>  		trace_xfs_log_grant_wake_up(log, tic);
>  		wake_up_process(tic->t_task);
> +		woken_task = true;
>  	}
>  
>  	return true;
> -- 
> 2.23.0.rc1
> 
