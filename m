Return-Path: <SRS0=A2Vo=7C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836A4C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B57E20823
	for <linux-xfs@archiver.kernel.org>; Wed, 20 May 2020 20:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sp3jP+nT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgETUr7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 May 2020 16:47:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgETUr7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 May 2020 16:47:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKluKL026662;
        Wed, 20 May 2020 20:47:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=D8gLRSo2R7nRkek8azodUMMRzOi3JrxrPk0XyUOFRfk=;
 b=Sp3jP+nTPVVxvI2gLxRDC7tifHRaNGSryBbvzTHkzQ0RdNybWIlTwau3BzaS8BTYd57R
 QA0RgAIMU5uUeL6zHczSX/aFIgfGKFZWsWV+Fxc/ab0NLFbgvb05wZIf+Fuz2IcxDMGP
 Cjtx0v4Kw/Gm41Wqcy3z9W+sRYlEVRLipVkpzM+sOCcjkSqgUSGJGKESRsJ317LqBtCo
 iWKxQrCZ7D2ltEo9qBYZCydqK1cJNAD33mRkEdtHoCcsetDrIEfaRwe208VsKnptj6n/
 uSCePIJUsvm58TQiGpgdxl26OxLjUy4A4sP2+SCpsZfUB0n7Sd3PAX5PsAP7BpBmfesw ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3127krdcep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 20:47:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04KKhCnd066729;
        Wed, 20 May 2020 20:47:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3150210cjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 20:47:56 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04KKlt9X003475;
        Wed, 20 May 2020 20:47:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 20 May 2020 13:47:54 -0700
Date:   Wed, 20 May 2020 13:47:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove the m_active_trans counter
Message-ID: <20200520204754.GF17627@magnolia>
References: <20200519222310.2576434-1-david@fromorbit.com>
 <20200519222310.2576434-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519222310.2576434-3-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=5 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9627 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005200165
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 08:23:10AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's a global atomic counter, and we are hitting it at a rate of
> half a million transactions a second, so it's bouncing the counter
> cacheline all over the place on large machines. We don't actually
> need it anymore - it used to be required because the VFS freeze code
> could not track/prevent filesystem transactions that were running,
> but that problem no longer exists.
> 
> Hence to remove the counter, we simply have to ensure that nothing
> calls xfs_sync_sb() while we are trying to quiesce the filesytem.
> That only happens if the log worker is still running when we call
> xfs_quiesce_attr(). The log worker is cancelled at the end of
> xfs_quiesce_attr() by calling xfs_log_quiesce(), so just call it
> early here and then we can remove the counter altogether.
> 
> Concurrent create, 50 million inodes, identical 16p/16GB virtual
> machines on different physical hosts. Machine A has twice the CPU
> cores per socket of machine B:
> 
> 		unpatched	patched
> machine A:	3m16s		2m00s
> machine B:	4m04s		4m05s
> 
> Create rates:
> 		unpatched	patched
> machine A:	282k+/-31k	468k+/-21k
> machine B:	231k+/-8k	233k+/-11k
> 
> Concurrent rm of same 50 million inodes:
> 
> 		unpatched	patched
> machine A:	6m42s		2m33s
> machine B:	4m47s		4m47s
> 
> The transaction rate on the fast machine went from just under
> 300k/sec to 700k/sec, which indicates just how much of a bottleneck
> this atomic counter was.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/me kinda wonders why removing the counter entirely has so little effect
on machine B, but seeing as I've been pondering killing this counter
myself for years,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_mount.h |  1 -
>  fs/xfs/xfs_super.c | 17 +++++------------
>  fs/xfs/xfs_trans.c | 27 +++++++++++----------------
>  3 files changed, 16 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c1f92c1847bb2..3725d25ad97e8 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -176,7 +176,6 @@ typedef struct xfs_mount {
>  	uint64_t		m_resblks;	/* total reserved blocks */
>  	uint64_t		m_resblks_avail;/* available reserved blocks */
>  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> -	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct delayed_work	m_eofblocks_work; /* background eof blocks
>  						     trimming */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index aae469f73efeb..fa58cb07c8fdf 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -874,8 +874,10 @@ xfs_restore_resvblks(struct xfs_mount *mp)
>   * there is no log replay required to write the inodes to disk - this is the
>   * primary difference between a sync and a quiesce.
>   *
> - * Note: xfs_log_quiesce() stops background log work - the callers must ensure
> - * it is started again when appropriate.
> + * We cancel log work early here to ensure all transactions the log worker may
> + * run have finished before we clean up and log the superblock and write an
> + * unmount record. The unfreeze process is responsible for restarting the log
> + * worker correctly.
>   */
>  void
>  xfs_quiesce_attr(
> @@ -883,9 +885,7 @@ xfs_quiesce_attr(
>  {
>  	int	error = 0;
>  
> -	/* wait for all modifications to complete */
> -	while (atomic_read(&mp->m_active_trans) > 0)
> -		delay(100);
> +	cancel_delayed_work_sync(&mp->m_log->l_work);
>  
>  	/* force the log to unpin objects from the now complete transactions */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
> @@ -899,12 +899,6 @@ xfs_quiesce_attr(
>  	if (error)
>  		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
>  				"Frozen image may not be consistent.");
> -	/*
> -	 * Just warn here till VFS can correctly support
> -	 * read-only remount without racing.
> -	 */
> -	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
> -
>  	xfs_log_quiesce(mp);
>  }
>  
> @@ -1793,7 +1787,6 @@ static int xfs_init_fs_context(
>  	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
>  	spin_lock_init(&mp->m_perag_lock);
>  	mutex_init(&mp->m_growlock);
> -	atomic_set(&mp->m_active_trans, 0);
>  	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
>  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
>  	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index b055a5ab53465..217937d743dbb 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -68,7 +68,6 @@ xfs_trans_free(
>  	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
>  
>  	trace_xfs_trans_free(tp, _RET_IP_);
> -	atomic_dec(&tp->t_mountp->m_active_trans);
>  	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_end_intwrite(tp->t_mountp->m_super);
>  	xfs_trans_free_dqinfo(tp);
> @@ -125,8 +124,6 @@ xfs_trans_dup(
>  	xfs_defer_move(ntp, tp);
>  
>  	xfs_trans_dup_dqinfo(tp, ntp);
> -
> -	atomic_inc(&tp->t_mountp->m_active_trans);
>  	return ntp;
>  }
>  
> @@ -275,7 +272,6 @@ xfs_trans_alloc(
>  	 */
>  	WARN_ON(resp->tr_logres > 0 &&
>  		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
> -	atomic_inc(&mp->m_active_trans);
>  
>  	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
> @@ -299,20 +295,19 @@ xfs_trans_alloc(
>  
>  /*
>   * Create an empty transaction with no reservation.  This is a defensive
> - * mechanism for routines that query metadata without actually modifying
> - * them -- if the metadata being queried is somehow cross-linked (think a
> - * btree block pointer that points higher in the tree), we risk deadlock.
> - * However, blocks grabbed as part of a transaction can be re-grabbed.
> - * The verifiers will notice the corrupt block and the operation will fail
> - * back to userspace without deadlocking.
> + * mechanism for routines that query metadata without actually modifying them --
> + * if the metadata being queried is somehow cross-linked (think a btree block
> + * pointer that points higher in the tree), we risk deadlock.  However, blocks
> + * grabbed as part of a transaction can be re-grabbed.  The verifiers will
> + * notice the corrupt block and the operation will fail back to userspace
> + * without deadlocking.
>   *
> - * Note the zero-length reservation; this transaction MUST be cancelled
> - * without any dirty data.
> + * Note the zero-length reservation; this transaction MUST be cancelled without
> + * any dirty data.
>   *
> - * Callers should obtain freeze protection to avoid two conflicts with fs
> - * freezing: (1) having active transactions trip the m_active_trans ASSERTs;
> - * and (2) grabbing buffers at the same time that freeze is trying to drain
> - * the buffer LRU list.
> + * Callers should obtain freeze protection to avoid a conflict with fs freezing
> + * where we can be grabbing buffers at the same time that freeze is trying to
> + * drain the buffer LRU list.
>   */
>  int
>  xfs_trans_alloc_empty(
> -- 
> 2.26.2.761.g0e0b3e54be
> 
