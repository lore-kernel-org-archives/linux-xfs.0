Return-Path: <SRS0=UMh5=XB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0FCC43331
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBC02082E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Sep 2019 00:15:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CQo4P0NY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732342AbfIFAPz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 20:15:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46298 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732017AbfIFAPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 20:15:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8609HQP161865;
        Fri, 6 Sep 2019 00:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=6sbYG3yW5k+l9Dl1AuVbgi6ip2y7LkOJObk3VUORQRU=;
 b=CQo4P0NY1lFUs+e/0pvwvEqQbc3h2oP/fRY0lt1OC7hywIXoYktIzSuid2CnSW+ctfbw
 Vdvsd+Yq5fIBTr+dEbr50gzm0dw2hmbvNvIOFXfYND1T2D+SzrLLmOJ6mga74Pq6K4dG
 nhTolHJ5wy9/EvCi+6tPWj+7xRffD+vAHJh2ZLh+Dd065lPi3sjflVBd9OIl5bhD1OFW
 IakR33DFpC7V7Vgmy2/x9DcwE0ciWa7tM6OASaCJjhALMDzMerDvwRee5fNij1Tyn2rH
 9Fq3OCXdKYDQ1pKz/7j4A4P8uP/TOpDnM/P6gc5pPervOtIn+6FqScHniD6aiYh4odF8 MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uucger1gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 00:15:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8608PIv123962;
        Fri, 6 Sep 2019 00:15:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b96emw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 00:15:52 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x860FqJ0008064;
        Fri, 6 Sep 2019 00:15:52 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 17:15:51 -0700
Date:   Thu, 5 Sep 2019 17:15:50 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] xfs: prevent CIL push holdoff in log recovery
Message-ID: <20190906001550.GM2229799@magnolia>
References: <20190906000553.6740-1-david@fromorbit.com>
 <20190906000553.6740-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906000553.6740-4-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 10:05:48AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/530 on a machine with enough ram and a non-preemptible
> kernel can run the AGI processing phase of log recovery enitrely out
> of cache. This means it never blocks on locks, never waits for IO
> and runs entirely through the unlinked lists until it either
> completes or blocks and hangs because it has run out of log space.
> 
> It runs out of log space because the background CIL push is
> scheduled but never runs. queue_work() queues the CIL work on the
> current CPU that is busy, and the workqueue code will not run it on
> any other CPU. Hence if the unlinked list processing never yields
> the CPU voluntarily, the push work is delayed indefinitely. This
> results in the CIL aggregating changes until all the log space is
> consumed.
> 
> When the log recoveyr processing evenutally blocks, the CIL flushes
> but because the last iclog isn't submitted for IO because it isn't
> full, the CIL flush never completes and nothing ever moves the log
> head forwards, or indeed inserts anything into the tail of the log,
> and hence nothing is able to get the log moving again and recovery
> hangs.
> 
> There are several problems here, but the two obvious ones from
> the trace are that:
> 	a) log recovery does not yield the CPU for over 4 seconds,
> 	b) binding CIL pushes to a single CPU is a really bad idea.
> 
> This patch addresses just these two aspects of the problem, and are
> suitable for backporting to work around any issues in older kernels.
> The more fundamental problem of preventing the CIL from consuming
> more than 50% of the log without committing will take more invasive
> and complex work, so will be done as followup work.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 1 +
>  fs/xfs/xfs_super.c       | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index f05c6c99c4f3..c9665455431e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5080,6 +5080,7 @@ xlog_recover_process_iunlinks(
>  			while (agino != NULLAGINO) {
>  				agino = xlog_recover_process_one_iunlink(mp,
>  							agno, agino, bucket);
> +				cond_resched();

<urk> Now I wish I'd asked for a comment explaining why we
cond_resched()....

/* Don't let other workqueues (including the CIL ones) starve. */

(Dunno if you want to respin or if I'll just end up fixing it on the way
in...)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			}
>  		}
>  		xfs_buf_rele(agibp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f9450235533c..391b4748cae3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -818,7 +818,8 @@ xfs_init_mount_workqueues(
>  		goto out_destroy_buf;
>  
>  	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> +			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
> +			0, mp->m_fsname);
>  	if (!mp->m_cil_workqueue)
>  		goto out_destroy_unwritten;
>  
> -- 
> 2.23.0.rc1
> 
