Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B108DC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jun 2023 00:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjFBAZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 20:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjFBAZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 20:25:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A5E138
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 17:25:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E25D648EE
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jun 2023 00:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BE6C433D2;
        Fri,  2 Jun 2023 00:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685665501;
        bh=iLjPYiqgUti/SFGsPLe8ivaZmQ7oYhrHdlt6Rp8Bt+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gUnMKS+DnEUPo1A0BEucJdB8qvWqg80EmcEgCX7MK7yBiXHNshvh2NlcGfpuZoXpr
         DxXQTNe13OifoQySYNgPWaowZ9AyZqSr5UITbnuEdwhTB8Inki8g4DzC/dR9qLeEYj
         9PtosGgBnRjwrihJAYE7efj0teK0z66aTqW+zrNQal/X43WKSokyAKh3FklrDF/C+/
         9X4JTqlas+Mz/Et6tC+3fISN/AJVstMnl/cWm5KzColYqnK+L6yqcl0PtgmWGls/00
         2ft0vbvmE8Y4/yCjOzWw+6xHssb1dpbipQlIYZGKftDK0w3DHLmdVHT777pc+cEvmr
         jBUh/BynlwUww==
Date:   Thu, 1 Jun 2023 17:25:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: collect errors from inodegc for unlinked inode
 recovery
Message-ID: <20230602002500.GI16865@frogsfrogsfrogs>
References: <20230530001928.2967218-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530001928.2967218-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 30, 2023 at 10:19:28AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Unlinked list recovery requires errors removing the inode the from
> the unlinked list get fed back to the main recovery loop. Now that
> we offload the unlinking to the inodegc work, we don't get errors
> being fed back when we trip over a corruption that prevents the
> inode from being removed from the unlinked list.
> 
> This means we never clear the corrupt unlinked list bucket,
> resulting in runtime operations eventually tripping over it and
> shutting down.
> 
> Fix this by collecting inodegc worker errors and feed them
> back to the flush caller. This is largely best effort - the only
> context that really cares is log recovery, and it only flushes a
> single inode at a time so we don't need complex synchronised
> handling. Essentially the inodegc workers will capture the first
> error that occurs and the next flush will gather them and clear
> them. The flush itself will only report the first gathered error.
> 
> In the cases where callers can return errors, propagate the
> collected inodegc flush error up the error handling chain.
> 
> In the case of inode unlinked list recovery, there are several
> superfluous calls to flush queued unlinked inodes -
> xlog_recover_iunlink_bucket() guarantees that it has flushed the
> inodegc and collected errors before it returns. Hence nothing in the
> calling path needs to run a flush, even when an error is returned.

Hmm.  So I guess what you're saying is that xfs_inactive now returns
negative errnos, and everything that calls down to that function will
pass the error upwards through the stack?

Any of those call paths that already could handle a negative errno will
now fail on a corrupt inactive inode; and the only place that will
silently "drop" the negative errno is unmount?

If 'yes' and 'yes' and the kbuild robot warnings get fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c      | 46 ++++++++++++++++++++++++++++++++--------
>  fs/xfs/xfs_icache.h      |  4 ++--
>  fs/xfs/xfs_inode.c       | 18 +++++-----------
>  fs/xfs/xfs_inode.h       |  2 +-
>  fs/xfs/xfs_log_recover.c | 19 ++++++++---------
>  fs/xfs/xfs_mount.h       |  1 +
>  fs/xfs/xfs_super.c       |  1 +
>  fs/xfs/xfs_trans.c       |  4 +++-
>  8 files changed, 59 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 0f60e301eb1f..453890942d9f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -454,6 +454,27 @@ xfs_inodegc_queue_all(
>  	return ret;
>  }
>  
> +/* Wait for all queued work and collect errors */
> +static int
> +xfs_inodegc_wait_all(
> +	struct xfs_mount	*mp)
> +{
> +	int			cpu;
> +	int			error = 0;
> +
> +	flush_workqueue(mp->m_inodegc_wq);
> +	for_each_online_cpu(cpu) {
> +		struct xfs_inodegc	*gc;
> +
> +		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> +		if (gc->error && !error)
> +			error = gc->error;
> +		gc->error = 0;
> +	}
> +
> +	return error;
> +}
> +
>  /*
>   * Check the validity of the inode we just found it the cache
>   */
> @@ -1491,15 +1512,14 @@ xfs_blockgc_free_space(
>  	if (error)
>  		return error;
>  
> -	xfs_inodegc_flush(mp);
> -	return 0;
> +	return xfs_inodegc_flush(mp);
>  }
>  
>  /*
>   * Reclaim all the free space that we can by scheduling the background blockgc
>   * and inodegc workers immediately and waiting for them all to clear.
>   */
> -void
> +int
>  xfs_blockgc_flush_all(
>  	struct xfs_mount	*mp)
>  {
> @@ -1520,7 +1540,7 @@ xfs_blockgc_flush_all(
>  	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
>  		flush_delayed_work(&pag->pag_blockgc_work);
>  
> -	xfs_inodegc_flush(mp);
> +	return xfs_inodegc_flush(mp);
>  }
>  
>  /*
> @@ -1842,13 +1862,17 @@ xfs_inodegc_set_reclaimable(
>   * This is the last chance to make changes to an otherwise unreferenced file
>   * before incore reclamation happens.
>   */
> -static void
> +static int
>  xfs_inodegc_inactivate(
>  	struct xfs_inode	*ip)
>  {
> +	int			error;
> +
>  	trace_xfs_inode_inactivating(ip);
> -	xfs_inactive(ip);
> +	error = xfs_inactive(ip);
>  	xfs_inodegc_set_reclaimable(ip);
> +	return error;
> +
>  }
>  
>  void
> @@ -1880,8 +1904,12 @@ xfs_inodegc_worker(
>  
>  	WRITE_ONCE(gc->shrinker_hits, 0);
>  	llist_for_each_entry_safe(ip, n, node, i_gclist) {
> +		int	error;
> +
>  		xfs_iflags_set(ip, XFS_INACTIVATING);
> -		xfs_inodegc_inactivate(ip);
> +		error = xfs_inodegc_inactivate(ip);
> +		if (error && !gc->error)
> +			gc->error = error;
>  	}
>  
>  	memalloc_nofs_restore(nofs_flag);
> @@ -1905,13 +1933,13 @@ xfs_inodegc_push(
>   * Force all currently queued inode inactivation work to run immediately and
>   * wait for the work to finish.
>   */
> -void
> +int
>  xfs_inodegc_flush(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_inodegc_push(mp);
>  	trace_xfs_inodegc_flush(mp, __return_address);
> -	flush_workqueue(mp->m_inodegc_wq);
> +	return xfs_inodegc_wait_all(mp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 87910191a9dd..1dcdcb23796e 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -62,7 +62,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
>  		unsigned int iwalk_flags);
>  int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
>  int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
> -void xfs_blockgc_flush_all(struct xfs_mount *mp);
> +int xfs_blockgc_flush_all(struct xfs_mount *mp);
>  
>  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
>  void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
> @@ -80,7 +80,7 @@ void xfs_blockgc_start(struct xfs_mount *mp);
>  
>  void xfs_inodegc_worker(struct work_struct *work);
>  void xfs_inodegc_push(struct xfs_mount *mp);
> -void xfs_inodegc_flush(struct xfs_mount *mp);
> +int xfs_inodegc_flush(struct xfs_mount *mp);
>  void xfs_inodegc_stop(struct xfs_mount *mp);
>  void xfs_inodegc_start(struct xfs_mount *mp);
>  void xfs_inodegc_cpu_dead(struct xfs_mount *mp, unsigned int cpu);
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5808abab786c..c0d0466f3270 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1620,16 +1620,7 @@ xfs_inactive_ifree(
>  	 */
>  	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_ICOUNT, -1);
>  
> -	/*
> -	 * Just ignore errors at this point.  There is nothing we can do except
> -	 * to try to keep going. Make sure it's not a silent error.
> -	 */
> -	error = xfs_trans_commit(tp);
> -	if (error)
> -		xfs_notice(mp, "%s: xfs_trans_commit returned error %d",
> -			__func__, error);
> -
> -	return 0;
> +	return xfs_trans_commit(tp);
>  }
>  
>  /*
> @@ -1693,7 +1684,7 @@ xfs_inode_needs_inactive(
>   * now be truncated.  Also, we clear all of the read-ahead state
>   * kept for the inode here since the file is now closed.
>   */
> -void
> +int
>  xfs_inactive(
>  	xfs_inode_t	*ip)
>  {
> @@ -1736,7 +1727,7 @@ xfs_inactive(
>  		 * reference to the inode at this point anyways.
>  		 */
>  		if (xfs_can_free_eofblocks(ip, true))
> -			xfs_free_eofblocks(ip);
> +			error = xfs_free_eofblocks(ip);
>  
>  		goto out;
>  	}
> @@ -1773,7 +1764,7 @@ xfs_inactive(
>  	/*
>  	 * Free the inode.
>  	 */
> -	xfs_inactive_ifree(ip);
> +	error = xfs_inactive_ifree(ip);
>  
>  out:
>  	/*
> @@ -1781,6 +1772,7 @@ xfs_inactive(
>  	 * the attached dquots.
>  	 */
>  	xfs_qm_dqdetach(ip);
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 69d21e42c10a..7547caf2f2ab 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -470,7 +470,7 @@ enum layout_break_reason {
>  	(xfs_has_grpid((pip)->i_mount) || (VFS_I(pip)->i_mode & S_ISGID))
>  
>  int		xfs_release(struct xfs_inode *ip);
> -void		xfs_inactive(struct xfs_inode *ip);
> +int		xfs_inactive(struct xfs_inode *ip);
>  int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
>  			   struct xfs_inode **ipp, struct xfs_name *ci_name);
>  int		xfs_create(struct mnt_idmap *idmap,
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 322eb2ee6c55..82c81d20459d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2711,7 +2711,9 @@ xlog_recover_iunlink_bucket(
>  			 * just to flush the inodegc queue and wait for it to
>  			 * complete.
>  			 */
> -			xfs_inodegc_flush(mp);
> +			error = xfs_inodegc_flush(mp);
> +			if (error)
> +				break;
>  		}
>  
>  		prev_agino = agino;
> @@ -2719,10 +2721,15 @@ xlog_recover_iunlink_bucket(
>  	}
>  
>  	if (prev_ip) {
> +		int	error2;
> +
>  		ip->i_prev_unlinked = prev_agino;
>  		xfs_irele(prev_ip);
> +
> +		error2 = xfs_inodegc_flush(mp);
> +		if (error2 && !error)
> +			return error2;
>  	}
> -	xfs_inodegc_flush(mp);
>  	return error;
>  }
>  
> @@ -2789,7 +2796,6 @@ xlog_recover_iunlink_ag(
>  			 * bucket and remaining inodes on it unreferenced and
>  			 * unfreeable.
>  			 */
> -			xfs_inodegc_flush(pag->pag_mount);
>  			xlog_recover_clear_agi_bucket(pag, bucket);
>  		}
>  	}
> @@ -2806,13 +2812,6 @@ xlog_recover_process_iunlinks(
>  
>  	for_each_perag(log->l_mp, agno, pag)
>  		xlog_recover_iunlink_ag(pag);
> -
> -	/*
> -	 * Flush the pending unlinked inodes to ensure that the inactivations
> -	 * are fully completed on disk and the incore inodes can be reclaimed
> -	 * before we signal that recovery is complete.
> -	 */
> -	xfs_inodegc_flush(log->l_mp);
>  }
>  
>  STATIC void
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index aaaf5ec13492..6c09f89534d3 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -62,6 +62,7 @@ struct xfs_error_cfg {
>  struct xfs_inodegc {
>  	struct llist_head	list;
>  	struct delayed_work	work;
> +	int			error;
>  
>  	/* approximate count of inodes in the list */
>  	unsigned int		items;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 7e706255f165..4120bd1cba90 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1100,6 +1100,7 @@ xfs_inodegc_init_percpu(
>  #endif
>  		init_llist_head(&gc->list);
>  		gc->items = 0;
> +		gc->error = 0;
>  		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
>  	}
>  	return 0;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index f81fbf081b01..8c0bfc9a33b1 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -290,7 +290,9 @@ xfs_trans_alloc(
>  		 * Do not perform a synchronous scan because callers can hold
>  		 * other locks.
>  		 */
> -		xfs_blockgc_flush_all(mp);
> +		error = xfs_blockgc_flush_all(mp);
> +		if (error)
> +			return error;
>  		want_retry = false;
>  		goto retry;
>  	}
> -- 
> 2.40.1
> 
