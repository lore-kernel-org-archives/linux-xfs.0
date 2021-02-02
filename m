Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB20DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 20:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E0AC64F60
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 20:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbhBBU1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233250AbhBBUZY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 15:25:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC2764F60;
        Tue,  2 Feb 2021 20:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612297483;
        bh=kYdZSnrpuzM0hyIZepF1vSyN4W8T3wBRwfKIkPFQCYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iele5+6vS3qeBHDiCfOEZgiLA3wKR2WnUUrWxisQng9GtCc4+p8ffDAPIEzP/T3W1
         QbF90WqXt/Cl4ggWc7d77RR0k+MoaF4PBfGC8Qtzv2ttxQ763KkDz6vaFMmND/Oh7W
         PRVrspkox1q734R/Tl1gYo73NZq8AgvNhnxCsaZUrzi6IDR+bteP2dGI3DP9lQ2Esj
         nX7mXXNGFVYuuLGR2LDmChEtOabkGJGSrU7+hCmt/F0TfX3LJhEdErE6JooyFE9GQd
         FOctes4lc3MlYGoXFXitPpqnggrYnLIdfWUDlc/Ry/OHzm+Gtw1LicXfwNV64xGXrC
         b/MTS0C3Mj1pg==
Date:   Tue, 2 Feb 2021 12:24:43 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't drain buffer lru on freeze and read-only
 remount
Message-ID: <20210202202443.GT7193@magnolia>
References: <20201210144607.1922026-1-bfoster@redhat.com>
 <20201210144607.1922026-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210144607.1922026-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 10, 2020 at 09:46:07AM -0500, Brian Foster wrote:
> xfs_buftarg_drain() is called from xfs_log_quiesce() to ensure the
> buffer cache is reclaimed during unmount. xfs_log_quiesce() is also
> called from xfs_quiesce_attr(), however, which means that cache
> state is completely drained for filesystem freeze and read-only
> remount. While technically harmless, this is unnecessarily
> heavyweight. Both freeze and read-only mounts allow reads and thus
> allow population of the buffer cache. Therefore, the transitional
> sequence in either case really only needs to quiesce outstanding
> writes to return the filesystem in a generally read-only state.
> 
> Additionally, some users have reported that attempts to freeze a
> filesystem concurrent with a read-heavy workload causes the freeze
> process to stall for a significant amount of time. This occurs
> because, as mentioned above, the read workload repopulates the
> buffer LRU while the freeze task attempts to drain it.
> 
> To improve this situation, replace the drain in xfs_log_quiesce()
> with a buffer I/O quiesce and lift the drain into the unmount path.
> This removes buffer LRU reclaim from freeze and read-only [re]mount,
> but ensures the LRU is still drained before the filesystem unmounts.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 20 +++++++++++++++-----
>  fs/xfs/xfs_buf.h |  1 +
>  fs/xfs/xfs_log.c |  6 ++++--
>  3 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index db918ed20c40..d3fce3129f6e 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1815,14 +1815,13 @@ xfs_buftarg_drain_rele(
>  	return LRU_REMOVED;
>  }
>  
> +/*
> + * Wait for outstanding I/O on the buftarg to complete.
> + */
>  void
> -xfs_buftarg_drain(
> +xfs_buftarg_wait(
>  	struct xfs_buftarg	*btp)
>  {
> -	LIST_HEAD(dispose);
> -	int			loop = 0;
> -	bool			write_fail = false;
> -
>  	/*
>  	 * First wait on the buftarg I/O count for all in-flight buffers to be
>  	 * released. This is critical as new buffers do not make the LRU until
> @@ -1838,6 +1837,17 @@ xfs_buftarg_drain(
>  	while (percpu_counter_sum(&btp->bt_io_count))
>  		delay(100);
>  	flush_workqueue(btp->bt_mount->m_buf_workqueue);
> +}
> +
> +void
> +xfs_buftarg_drain(
> +	struct xfs_buftarg	*btp)
> +{
> +	LIST_HEAD(dispose);
> +	int			loop = 0;
> +	bool			write_fail = false;
> +
> +	xfs_buftarg_wait(btp);
>  
>  	/* loop until there is nothing left on the lru list. */
>  	while (list_lru_count(&btp->bt_lru)) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index ea32369f8f77..96c6b478e26e 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -347,6 +347,7 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  extern struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *,
>  		struct block_device *, struct dax_device *);
>  extern void xfs_free_buftarg(struct xfs_buftarg *);
> +extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
>  extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5ad4d5e78019..46ea4017fcec 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -936,13 +936,13 @@ xfs_log_quiesce(
>  
>  	/*
>  	 * The superblock buffer is uncached and while xfs_ail_push_all_sync()
> -	 * will push it, xfs_buftarg_drain() will not wait for it. Further,
> +	 * will push it, xfs_buftarg_wait() will not wait for it. Further,
>  	 * xfs_buf_iowait() cannot be used because it was pushed with the
>  	 * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait for
>  	 * the IO to complete.
>  	 */
>  	xfs_ail_push_all_sync(mp->m_ail);
> -	xfs_buftarg_drain(mp->m_ddev_targp);
> +	xfs_buftarg_wait(mp->m_ddev_targp);
>  	xfs_buf_lock(mp->m_sb_bp);
>  	xfs_buf_unlock(mp->m_sb_bp);
>  
> @@ -962,6 +962,8 @@ xfs_log_unmount(
>  {
>  	xfs_log_quiesce(mp);
>  
> +	xfs_buftarg_drain(mp->m_ddev_targp);
> +
>  	xfs_trans_ail_destroy(mp);
>  
>  	xfs_sysfs_del(&mp->m_log->l_kobj);
> -- 
> 2.26.2
> 
