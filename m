Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4FBCA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D02206B7
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZD9kWQox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgELQEB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:04:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46908 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgELQEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 12:04:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CFuLdE183239;
        Tue, 12 May 2020 16:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bGC8QMuzT6078hVIaNnF2/ffxjSjUia5B81ZwK2pwAs=;
 b=ZD9kWQoxPNDjsqkG7Yif36vDu3KXfcwVTxstnPgrzoGf5HVKS6hA6WiURf06imA/koIa
 c/BpiurWtYHNZVXs4BrhMRpt+dMuTSIdB1YafxLtXOcFOhYnIF84W/SeTQ3AJxi+vJji
 BzgrtjNur37K9lpQDE/UYhyhozUn5YtyCOjj0PdeMXKkeJOl2Gd1kYOnq6WKzlwHBx7I
 3XPl2zrmfJTHX3vYsK/AXXHQxkj0LSUx1ti3HcAqCLWor2vS6J11Dd65SA54ehZDP6HV
 /B4VLpze1dJviFbWMO74r+aK4AnpLOy9R6xSOBqhRjbTEOf+fSZVnsLfAnLqh3/zqx5f Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30x3gmkym6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 16:03:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CFwaZc194200;
        Tue, 12 May 2020 16:03:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30xbgk4qh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 16:03:56 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CG3sl3021484;
        Tue, 12 May 2020 16:03:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 09:03:53 -0700
Date:   Tue, 12 May 2020 09:03:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200512160352.GE6714@magnolia>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512025949.1807131-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=5 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=5
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120121
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 12:59:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a global atomic counter, and we are hitting it at a rate of
> half a million transactions a second, so it's bouncing the counter
> cacheline all over the place on large machines. Convert it to a
> per-cpu counter.
> 
> And .... oh wow, that was unexpected!
> 
> Concurrent create, 50 million inodes, identical 16p/16GB virtual
> machines on different physical hosts. Machine A has twice the CPU
> cores per socket of machine B:
> 
> 		unpatched	patched
> machine A:	3m45s		2m27s
> machine B:	4m13s		4m14s
> 
> Create rates:
> 		unpatched	patched
> machine A:	246k+/-15k	384k+/-10k
> machine B:	225k+/-13k	223k+/-11k
> 
> Concurrent rm of same 50 million inodes:
> 
> 		unpatched	patched
> machine A:	8m30s		3m09s
> machine B:	4m02s		4m51s
> 
> The transaction rate on the fast machine went from about 250k/sec to
> over 600k/sec, which indicates just how much of a bottleneck this
> atomic counter was.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.h |  2 +-
>  fs/xfs/xfs_super.c | 12 +++++++++---
>  fs/xfs/xfs_trans.c |  6 +++---
>  3 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 712b3e2583316..af3d8b71e9591 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -84,6 +84,7 @@ typedef struct xfs_mount {
>  	 * extents or anything related to the rt device.
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
> +	struct percpu_counter	m_active_trans;	/* in progress xact counter */
>  
>  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
>  	char			*m_rtname;	/* realtime device name */
> @@ -164,7 +165,6 @@ typedef struct xfs_mount {
>  	uint64_t		m_resblks;	/* total reserved blocks */
>  	uint64_t		m_resblks_avail;/* available reserved blocks */
>  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> -	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e80bd2c4c279e..bc4853525ce18 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -883,7 +883,7 @@ xfs_quiesce_attr(
>  	int	error = 0;
>  
>  	/* wait for all modifications to complete */
> -	while (atomic_read(&mp->m_active_trans) > 0)
> +	while (percpu_counter_sum(&mp->m_active_trans) > 0)
>  		delay(100);

Hmm.  AFAICT, this counter stops us from quiescing the log while
transactions are still running.  We only quiesce the log for unmount,
remount-ro, and fs freeze.  Given that we now start_sb_write for
xfs_getfsmap and the background freeing threads, I wonder, do we still
need this at all?

--D

>  
>  	/* force the log to unpin objects from the now complete transactions */
> @@ -902,7 +902,7 @@ xfs_quiesce_attr(
>  	 * Just warn here till VFS can correctly support
>  	 * read-only remount without racing.
>  	 */
> -	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
> +	WARN_ON(percpu_counter_sum(&mp->m_active_trans) != 0);
>  
>  	xfs_log_quiesce(mp);
>  }
> @@ -1027,8 +1027,14 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_fdblocks;
>  
> +	error = percpu_counter_init(&mp->m_active_trans, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_delalloc_blocks;
> +
>  	return 0;
>  
> +free_delalloc_blocks:
> +	percpu_counter_destroy(&mp->m_delalloc_blks);
>  free_fdblocks:
>  	percpu_counter_destroy(&mp->m_fdblocks);
>  free_ifree:
> @@ -1057,6 +1063,7 @@ xfs_destroy_percpu_counters(
>  	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> +	percpu_counter_destroy(&mp->m_active_trans);
>  }
>  
>  static void
> @@ -1792,7 +1799,6 @@ static int xfs_init_fs_context(
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
>  	spin_lock_init(&mp->m_perag_lock);
>  	mutex_init(&mp->m_growlock);
> -	atomic_set(&mp->m_active_trans, 0);
>  	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 28b983ff8b113..636df5017782e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -68,7 +68,7 @@ xfs_trans_free(
>  	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
>  
>  	trace_xfs_trans_free(tp, _RET_IP_);
> -	atomic_dec(&tp->t_mountp->m_active_trans);
> +	percpu_counter_dec(&tp->t_mountp->m_active_trans);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
>  	xfs_trans_free_dqinfo(tp);
> @@ -126,7 +126,7 @@ xfs_trans_dup(
>  
>  	xfs_trans_dup_dqinfo(tp, ntp);
>  
> -	atomic_inc(&tp->t_mountp->m_active_trans);
> +	percpu_counter_inc(&tp->t_mountp->m_active_trans);
>  	return ntp;
>  }
>  
> @@ -275,7 +275,7 @@ xfs_trans_alloc(
>  	 */
>  	WARN_ON(resp->tr_logres > 0 &&
>  		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> -	atomic_inc(&mp->m_active_trans);
> +	percpu_counter_inc(&mp->m_active_trans);
>  
>  	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
> -- 
> 2.26.1.301.g55bc3eb7cb9
> 
