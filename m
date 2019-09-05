Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD83EC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE622137B
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 15:21:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OWCJ1eU8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbfIEPVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 11:21:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39880 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388057AbfIEPVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 11:21:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FBHuP087747;
        Thu, 5 Sep 2019 15:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=KeP+yPUHzIjfdK2cmQfnW1WKrqQaOnb37HuT4B5im+A=;
 b=OWCJ1eU8ZWlYeVvxkq2tunLP6luImThxNfxl4VxjSpQHtm7PK/KqDgurM7na9nMcbE5a
 xig2OrdzhE/oSlN37Tc7C+kgpFmvQxv7NkveM1KL/58zgpHn+1jq84LswcN70EZeQClK
 B25EinXMEfRk9Nt5a9P9hf3/xJhK+Y2DEZfJMfTHf6zaJwfojcMIVhbG4TT1NfNbnZ9t
 ba787t1f3IyyF4KHHKQMQ8IT+LMQyTSTwKmuTXxezt+dp4PGpuTITK6FGeW52LiFSmWM
 n9GfaQVpmWSZMlPEw3F3KCaK+vabFozs5X43YJArvU1PXeEUN8YNBdLo5zFY4cxySJZF Dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uu4rxg2gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:21:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85FB70s140930;
        Thu, 5 Sep 2019 15:21:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2uthq1urwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Sep 2019 15:21:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85FLZeT018197;
        Thu, 5 Sep 2019 15:21:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 08:21:35 -0700
Date:   Thu, 5 Sep 2019 08:21:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190905152134.GC2229799@magnolia>
References: <20190905084717.30308-1-david@fromorbit.com>
 <20190905084717.30308-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905084717.30308-3-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 05, 2019 at 06:47:11PM +1000, Dave Chinner wrote:
> From: Rik van Riel <riel@surriel.com>
> 
> The code in xlog_wait uses the spinlock to make adding the task to
> the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
> with respect to the waker.
> 
> Doing the wakeup after releasing the spinlock opens up the following
> race condition:
> 
> Task 1					task 2
> add task to wait queue
> 					wake up task
> set task state to UNINTERRUPTIBLE
> 
> This issue was found through code inspection as a result of kworkers
> being observed stuck in UNINTERRUPTIBLE state with an empty
> wait queue. It is rare and largely unreproducable.
> 
> Simply moving the spin_unlock to after the wake_up_all results
> in the waker not being able to see a task on the waitqueue before
> it has set its state to UNINTERRUPTIBLE.
> 
> This bug dates back to the conversion of this code to generic
> waitqueue infrastructure from a counting semaphore back in 2008
> which didn't place the wakeups consistently w.r.t. to the relevant
> spin locks.
> 
> [dchinner: Also fix a similar issue in the shutdown path on
> xc_commit_wait. Update commit log with more details of the issue.]
> 
> Fixes: d748c62367eb ("[XFS] Convert l_flushsema to a sv_t")
> Reported-by: Chris Mason <clm@fb.com>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5e21450fb8f5..8380ed065608 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2644,7 +2644,6 @@ xlog_state_do_callback(
>  	int		   funcdidcallbacks; /* flag: function did callbacks */
>  	int		   repeats;	/* for issuing console warnings if
>  					 * looping too many times */
> -	int		   wake = 0;
>  
>  	spin_lock(&log->l_icloglock);
>  	first_iclog = iclog = log->l_iclog;
> @@ -2840,11 +2839,9 @@ xlog_state_do_callback(
>  #endif
>  
>  	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR))
> -		wake = 1;
> -	spin_unlock(&log->l_icloglock);
> -
> -	if (wake)
>  		wake_up_all(&log->l_flush_wait);
> +
> +	spin_unlock(&log->l_icloglock);
>  }
>  
>  
> @@ -3944,7 +3941,9 @@ xfs_log_force_umount(
>  	 * item committed callback functions will do this again under lock to
>  	 * avoid races.
>  	 */
> +	spin_lock(&log->l_cilp->xc_push_lock);
>  	wake_up_all(&log->l_cilp->xc_commit_wait);
> +	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log, true, NULL);
>  
>  #ifdef XFSERRORDEBUG
> -- 
> 2.23.0.rc1
> 
