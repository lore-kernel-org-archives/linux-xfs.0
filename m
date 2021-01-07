Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB38AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:32:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91AD223443
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jan 2021 19:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbhAGTcX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jan 2021 14:32:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38466 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbhAGTcW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jan 2021 14:32:22 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JOpWf087321;
        Thu, 7 Jan 2021 19:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=hhXvnzKbxBt32G1BjRLD1RRVTW2Q+9Aagsp2Uy6EPs4=;
 b=QHL99MGccX/piwtPhY1hncqo4387dHdjSdDhNMzG2doZdLr4prFCqPLsz/7BHkgK5WQH
 I8W1XPTdH77AznaY2hkz5ierZCpO4HwT7cJRFdf9SySAC3DqkptaeSktDALjCN+vNP8n
 WQSAzE25etGXpcsdGIV9hmhad91B6DjLptX2NhKSxS/2mgVeOUfa32GhTOjx7Uoe9CJ6
 MPsHk6Td+W+9b1dJc9NCUh7vyaywEZC21fTbKcjbv2w64TTeK2O6BjQYSPyjCwZRPNYp
 RNgGvz8mhxdkWj9BRVZISILiqCbQlyK50SGRwXovDgQ2JJ4nNgCC1rofofo46Zgy7ruC ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35wcuxxbt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 07 Jan 2021 19:31:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 107JQVrq193681;
        Thu, 7 Jan 2021 19:31:39 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35v4redjrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jan 2021 19:31:39 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 107JVcg2003248;
        Thu, 7 Jan 2021 19:31:38 GMT
Received: from localhost (/10.159.138.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Jan 2021 19:31:38 +0000
Date:   Thu, 7 Jan 2021 11:31:37 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: fold sbcount quiesce logging into log covering
Message-ID: <20210107193137.GH6918@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-7-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106174127.805660-7-bfoster@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101070113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101070113
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 06, 2021 at 12:41:24PM -0500, Brian Foster wrote:
> xfs_log_sbcount() calls xfs_sync_sb() to sync superblock counters to
> disk when lazy superblock accounting is enabled. This occurs on
> unmount, freeze, and read-only (re)mount and ensures the final
> values are calculated and persisted to disk before each form of
> quiesce completes.
> 
> Now that log covering occurs in all of these contexts and uses the
> same xfs_sync_sb() mechanism to update log state, there is no need
> to log the superblock separately for any reason. Update the log
> quiesce path to sync the superblock at least once for any mount
> where lazy superblock accounting is enabled. If the log is already
> covered, it will remain in the covered state. Otherwise, the next
> sync as part of the normal covering sequence will carry the
> associated superblock update with it. Remove xfs_log_sbcount() now
> that it is no longer needed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

If all my previous ramblings were correct,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c   | 20 ++++++++++++++++++--
>  fs/xfs/xfs_mount.c | 31 -------------------------------
>  fs/xfs/xfs_mount.h |  1 -
>  fs/xfs/xfs_super.c |  8 --------
>  4 files changed, 18 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9b8564f280b7..83e2697d4e38 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1108,6 +1108,7 @@ xfs_log_cover(
>  {
>  	struct xlog		*log = mp->m_log;
>  	int			error = 0;
> +	bool			need_covered;
>  
>  	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
>  	        !xfs_ail_min_lsn(log->l_ailp)) ||
> @@ -1116,6 +1117,21 @@ xfs_log_cover(
>  	if (!xfs_log_writable(mp))
>  		return 0;
>  
> +	/*
> +	 * xfs_log_need_covered() is not idempotent because it progresses the
> +	 * state machine if the log requires covering. Therefore, we must call
> +	 * this function once and use the result until we've issued an sb sync.
> +	 * Do so first to make that abundantly clear.
> +	 *
> +	 * Fall into the covering sequence if the log needs covering or the
> +	 * mount has lazy superblock accounting to sync to disk. The sb sync
> +	 * used for covering accumulates the in-core counters, so covering
> +	 * handles this for us.
> +	 */
> +	need_covered = xfs_log_need_covered(mp);
> +	if (!need_covered && !xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		return 0;
> +
>  	/*
>  	 * To cover the log, commit the superblock twice (at most) in
>  	 * independent checkpoints. The first serves as a reference for the
> @@ -1125,12 +1141,12 @@ xfs_log_cover(
>  	 * covering the log. Push the AIL one more time to leave it empty, as
>  	 * we found it.
>  	 */
> -	while (xfs_log_need_covered(mp)) {
> +	do {
>  		error = xfs_sync_sb(mp, true);
>  		if (error)
>  			break;
>  		xfs_ail_push_all_sync(mp->m_ail);
> -	}
> +	} while (xfs_log_need_covered(mp));
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index a62b8a574409..f97b82d0e30f 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1124,12 +1124,6 @@ xfs_unmountfs(
>  		xfs_warn(mp, "Unable to free reserved block pool. "
>  				"Freespace may not be correct on next mount.");
>  
> -	error = xfs_log_sbcount(mp);
> -	if (error)
> -		xfs_warn(mp, "Unable to update superblock counters. "
> -				"Freespace may not be correct on next mount.");
> -
> -
>  	xfs_log_unmount(mp);
>  	xfs_da_unmount(mp);
>  	xfs_uuid_unmount(mp);
> @@ -1164,31 +1158,6 @@ xfs_fs_writable(
>  	return true;
>  }
>  
> -/*
> - * xfs_log_sbcount
> - *
> - * Sync the superblock counters to disk.
> - *
> - * Note this code can be called during the process of freezing, so we use the
> - * transaction allocator that does not block when the transaction subsystem is
> - * in its frozen state.
> - */
> -int
> -xfs_log_sbcount(xfs_mount_t *mp)
> -{
> -	if (!xfs_log_writable(mp))
> -		return 0;
> -
> -	/*
> -	 * we don't need to do this if we are updating the superblock
> -	 * counters on every modification.
> -	 */
> -	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
> -		return 0;
> -
> -	return xfs_sync_sb(mp, true);
> -}
> -
>  /*
>   * Deltas for the block count can vary from 1 to very large, but lock contention
>   * only occurs on frequent small block count updates such as in the delayed
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index dfa429b77ee2..452ca7654dc5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -399,7 +399,6 @@ int xfs_buf_hash_init(xfs_perag_t *pag);
>  void xfs_buf_hash_destroy(xfs_perag_t *pag);
>  
>  extern void	xfs_uuid_table_free(void);
> -extern int	xfs_log_sbcount(xfs_mount_t *);
>  extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
>  extern int	xfs_mountfs(xfs_mount_t *mp);
>  extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 09d956e30fd8..75ada867c665 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -884,19 +884,11 @@ void
>  xfs_quiesce_attr(
>  	struct xfs_mount	*mp)
>  {
> -	int	error = 0;
> -
>  	cancel_delayed_work_sync(&mp->m_log->l_work);
>  
>  	/* force the log to unpin objects from the now complete transactions */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -
> -	/* Push the superblock and write an unmount record */
> -	error = xfs_log_sbcount(mp);
> -	if (error)
> -		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
> -				"Frozen image may not be consistent.");
>  	xfs_log_clean(mp);
>  }
>  
> -- 
> 2.26.2
> 
