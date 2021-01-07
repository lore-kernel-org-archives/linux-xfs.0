Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B6B4C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526E823436
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbhAGTEx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:04:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbhAGTEx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:04:53 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107Ix6fe084784;
        Thu, 7 Jan 2021 19:04:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uGvsE+wMFkPeU7G6Qlv0fTnWw0eaj68tF1Btn3l+l6Q=;
 b=XMCONxhNGv94T7OPUw/H7IL42bfh9a2KOEwsRZG9DG2EcrILwuTsZWaKn7bHV6f/BlX1
 kxt5XeXAUyraMwuzQKaUxhSW1/lREMEKwiF6VvHrMqj637/3nImpEMtTMFvrzJiEAayw
 O6+QLpLsLfSK+yQ/ayVtOBaGgZ0xnp28ea7P7UXioGwvgGhqpL6xWUf/zAwOnK2h4HLm
 geKdmZ6Lu82bCpN5DnNR6SkpzYOl85DwdOIjt2fErYQKvizjbgFuN6q8dDyUqnwJ4PR+
 mjGCO8a+4ENPl1pjP25VUmEg7IcmFiHtAzKMXlyXtwupFhWyscNahzNjO7V1fneIgaVQ yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35wepmdvj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:04:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107IxVt3159804;
        Thu, 7 Jan 2021 19:04:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35w3g36h5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:04:09 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107J4964019990;
        Thu, 7 Jan 2021 19:04:09 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 11:04:08 -0800
Date:   Thu, 7 Jan 2021 11:04:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: cover the log during log quiesce
Message-ID: <20210107190408.GD6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-5-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:22PM -0500, Brian Foster wrote:
> The log quiesce mechanism historically terminates by marking the log
> clean with an unmount record. The primary objective is to indicate
> that log recovery is no longer required after the quiesce has
> flushed all in-core changes and written back filesystem metadata.
> While this is perfectly fine, it is somewhat hacky as currently used
> in certain contexts. For example, filesystem freeze quiesces (i.e.
> cleans) the log and immediately redirties it with a dummy superblock
> transaction to ensure that log recovery runs in the event of a
> crash.
> 
> While this functions correctly, cleaning the log from freeze context
> is clearly superfluous given the current redirtying behavior.
> Instead, the desired behavior can be achieved by simply covering the
> log. This effectively retires all on-disk log items from the active
> range of the log by issuing two synchronous and sequential dummy
> superblock update transactions that serve to update the on-disk log
> head and tail. The subtle difference is that the log technically
> remains dirty due to the lack of an unmount record, though recovery
> is effectively a no-op due to the content of the checkpoints being
> clean (i.e. the unmodified on-disk superblock).
> 
> Log covering currently runs in the background and only triggers once
> the filesystem and log has idled. The purpose of the background
> mechanism is to prevent log recovery from replaying the most
> recently logged items long after those items may have been written
> back. In the quiesce path, the log has been deliberately idled by
> forcing the log and pushing the AIL until empty in a context where
> no further mutable filesystem operations are allowed. Therefore, we
> can cover the log as the final step in the log quiesce codepath to
> reflect that all previously active items have been successfully
> written back.
> 
> This facilitates selective log covering from certain contexts (i.e.
> freeze) that only seek to quiesce, but not necessarily clean the
> log. Note that as a side effect of this change, log covering now
> occurs when cleaning the log as well. This is harmless, facilitates
> subsequent cleanups, and is mostly temporary as various operations
> switch to use explicit log covering.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 49 +++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_log.h |  2 +-
>  2 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1b3227a033ad..f7b23044723d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -91,6 +91,9 @@ STATIC int
>  xlog_iclogs_empty(
>  	struct xlog		*log);
>  
> +static int
> +xfs_log_cover(struct xfs_mount *);
> +
>  static void
>  xlog_grant_sub_space(
>  	struct xlog		*log,
> @@ -936,10 +939,9 @@ xfs_log_unmount_write(
>   * To do this, we first need to shut down the background log work so it is not
>   * trying to cover the log as we clean up. We then need to unpin all objects in
>   * the log so we can then flush them out. Once they have completed their IO and
> - * run the callbacks removing themselves from the AIL, we can write the unmount
> - * record.
> + * run the callbacks removing themselves from the AIL, we can cover the log.
>   */
> -void
> +int
>  xfs_log_quiesce(
>  	struct xfs_mount	*mp)
>  {
> @@ -957,6 +959,8 @@ xfs_log_quiesce(
>  	xfs_wait_buftarg(mp->m_ddev_targp);
>  	xfs_buf_lock(mp->m_sb_bp);
>  	xfs_buf_unlock(mp->m_sb_bp);
> +
> +	return xfs_log_cover(mp);
>  }
>  
>  void
> @@ -1092,6 +1096,45 @@ xfs_log_need_covered(
>  	return needed;
>  }
>  
> +/*
> + * Explicitly cover the log. This is similar to background log covering but
> + * intended for usage in quiesce codepaths. The caller is responsible to ensure
> + * the log is idle and suitable for covering. The CIL, iclog buffers and AIL
> + * must all be empty.
> + */
> +static int
> +xfs_log_cover(
> +	struct xfs_mount	*mp)
> +{
> +	struct xlog		*log = mp->m_log;
> +	int			error = 0;
> +
> +	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
> +	        !xfs_ail_min_lsn(log->l_ailp)) ||
> +	       XFS_FORCED_SHUTDOWN(mp));
> +
> +	if (!xfs_log_writable(mp))
> +		return 0;
> +
> +	/*
> +	 * To cover the log, commit the superblock twice (at most) in
> +	 * independent checkpoints. The first serves as a reference for the
> +	 * tail pointer. The sync transaction and AIL push empties the AIL and
> +	 * updates the in-core tail to the LSN of the first checkpoint. The
> +	 * second commit updates the on-disk tail with the in-core LSN,
> +	 * covering the log. Push the AIL one more time to leave it empty, as
> +	 * we found it.
> +	 */

Hm.  At first I looked at _need_covered and wondered how this could work
properly if we are in state DONE or DONE2, because this not-quite
predicate returns zero in that case.

I think it's the case that the only way the log can end up in DONE state
is if the background log worker had previously been in NEED, written the
first of the dummy transactions, moved the state to DONE, and waited for
xlog_covered_state to move the log from DONE to NEED2.  Similarly, the
log can only be in DONE2 state if the background worker wrote the second
dummy and is now waiting for xlog_covered_state to move the log from
DONE2 to IDLE.

Since xfs_log_quiesce cancelled the log worker and waited for it to
finish before calling xfs_log_cover, the covering state here can only be
IDLE, NEED, or NEED2, right?  And hence the while loop pushes the log to
IDLE no matter where it is now, right?

(I also wondered why this isn't a do-while loop but patch 6 addresses
that.)

--D

> +	while (xfs_log_need_covered(mp)) {
> +		error = xfs_sync_sb(mp, true);
> +		if (error)
> +			break;
> +		xfs_ail_push_all_sync(mp->m_ail);
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * We may be holding the log iclog lock upon entering this routine.
>   */
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index b0400589f824..044e02cb8921 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -138,7 +138,7 @@ void	xlog_cil_process_committed(struct list_head *list);
>  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
>  
>  void	xfs_log_work_queue(struct xfs_mount *mp);
> -void	xfs_log_quiesce(struct xfs_mount *mp);
> +int	xfs_log_quiesce(struct xfs_mount *mp);
>  void	xfs_log_clean(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  bool	xfs_log_in_recovery(struct xfs_mount *);
> -- 
> 2.26.2
> 
