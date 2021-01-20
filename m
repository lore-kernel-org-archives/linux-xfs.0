Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D75C433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 00:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C92923718
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Jan 2021 00:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbhAUAcu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 19:32:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404204AbhATXfV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 18:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9F8F22B2A
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jan 2021 23:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611185679;
        bh=xnG1wb+uee2AEHJht5uSn/Ag8gAj3gHXrjWx84cVe/4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=P5T5Zd9B+5wNf+vZKtJ43NaXtD/1TXdFc5/Dxr3GuNDXCKnqIkJFDz0VSGOfC/INB
         CmGT99ZNv4EEUajWFoLSwUb6dUuPKpwFsLiQhqhDgkR1D2JE5P4Suk5Igbbrt5Im+R
         J1iXjXx81uWqzpbDuh+c7w1N6m2yc6Abwh/ac4ejVRaDlre/XGmGDzuPDD43sFWtYU
         8Q6398qT3au1K/tl97KeMw88NWE9uGjBRBlutpSRXITUfRnlrE+vu4yDR5szd1fRGY
         tiIaJaLfC67YVhtdRCPIp6mr+KIx32JeeJA70osei2cNp52cHE2XwkwJI7okaJKMgW
         3hSIzKDsJ1h/g==
Date:   Wed, 20 Jan 2021 15:34:39 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210120233439.GT3134581@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
 <161100800882.90204.6003697594198832699.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100800882.90204.6003697594198832699.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:13:28PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Increase the default parallelism level for pwork clients so that we can
> take advantage of computers with a lot of CPUs and a lot of hardware.
> The posteof/cowblocks cleanup series will use the functionality
> presented in this patch to constrain the number of background per-ag gc
> threads to our best estimate of the amount of parallelism that the
> filesystem can sustain.

Dave and I had a conversation on IRC about this trying to figure out the
"desired" parallelism of filesystem threads in which he pointed out that
we can't easily figure out the real iops capacity of the storage --
devices don't report "nonrotational" status correctly, hardware raid
with caches and nvram don't neatly fit our "spinning floppy" vs "ssd"
dichotomy, and in the end the device concurrency is the queue depth of
the underlying hardware.  For really fast storage, even one io submitter
per cpu isn't enough to saturate the device.

So rather than try to figure out the magic optimal number and introduce
override knobs, XFS should not articially limit its concurrency levels.
Wherever it is that the bottlenecks lie (data device, log device, log
grants, locks) we might as well schedule work items as they come so that
we can see all the hot spots as they arise.

I will rework this patch to remove the artificial limits, convert the
quotacheck pworker to be unbound (since we actually /want/ the workers
to spread out among the CPUs and we don't care about bounding), and add
WQ_SYSFS to all the workqueues so we can examine them in
/sys/bus/workqueue/devices.

--D

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iwalk.c |    2 +
>  fs/xfs/xfs_pwork.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_pwork.h |    3 +-
>  3 files changed, 76 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index eae3aff9bc97..bb31ef870cdc 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -624,7 +624,7 @@ xfs_iwalk_threaded(
>  	ASSERT(agno < mp->m_sb.sb_agcount);
>  	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
>  
> -	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
> +	nr_threads = xfs_pwork_guess_workqueue_threads(mp);
>  	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
>  			nr_threads);
>  	if (error)
> diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
> index b03333f1c84a..53606397ff54 100644
> --- a/fs/xfs/xfs_pwork.c
> +++ b/fs/xfs/xfs_pwork.c
> @@ -118,19 +118,85 @@ xfs_pwork_poll(
>  		touch_softlockup_watchdog();
>  }
>  
> +/* Estimate the amount of parallelism available for a storage device. */
> +static unsigned int
> +xfs_guess_buftarg_parallelism(
> +	struct xfs_buftarg	*btp)
> +{
> +	int			iomin;
> +	int			ioopt;
> +
> +	/*
> +	 * The device tells us that it is non-rotational, and we take that to
> +	 * mean there are no moving parts and that the device can handle all
> +	 * the CPUs throwing IO requests at it.
> +	 */
> +	if (blk_queue_nonrot(btp->bt_bdev->bd_disk->queue))
> +		return num_online_cpus();
> +
> +	/*
> +	 * The device has a preferred and minimum IO size that suggest a RAID
> +	 * setup, so infer the number of disks and assume that the parallelism
> +	 * is equal to the disk count.
> +	 */
> +	iomin = bdev_io_min(btp->bt_bdev);
> +	ioopt = bdev_io_opt(btp->bt_bdev);
> +	if (iomin > 0 && ioopt > iomin)
> +		return ioopt / iomin;
> +
> +	/*
> +	 * The device did not indicate that it has any capabilities beyond that
> +	 * of a rotating disk with a single drive head, so we estimate no
> +	 * parallelism at all.
> +	 */
> +	return 1;
> +}
> +
>  /*
> - * Return the amount of parallelism that the data device can handle, or 0 for
> - * no limit.
> + * Estimate the amount of parallelism that is available for metadata operations
> + * on this filesystem.
>   */
>  unsigned int
> -xfs_pwork_guess_datadev_parallelism(
> +xfs_pwork_guess_metadata_threads(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_buftarg	*btp = mp->m_ddev_targp;
> +	unsigned int		threads;
>  
>  	/*
> -	 * For now we'll go with the most conservative setting possible,
> -	 * which is two threads for an SSD and 1 thread everywhere else.
> +	 * Estimate the amount of parallelism for metadata operations from the
> +	 * least capable of the two devices that handle metadata.  Cap that
> +	 * estimate to the number of AGs to avoid unnecessary lock contention.
>  	 */
> -	return blk_queue_nonrot(btp->bt_bdev->bd_disk->queue) ? 2 : 1;
> +	threads = xfs_guess_buftarg_parallelism(mp->m_ddev_targp);
> +	if (mp->m_logdev_targp != mp->m_ddev_targp)
> +		threads = min(xfs_guess_buftarg_parallelism(mp->m_logdev_targp),
> +			      threads);
> +	threads = min(mp->m_sb.sb_agcount, threads);
> +
> +	/* If the storage told us it has fancy capabilities, we're done. */
> +	if (threads > 1)
> +		goto clamp;
> +
> +	/*
> +	 * Metadata storage did not even hint that it has any parallel
> +	 * capability.  If the filesystem was formatted with a stripe unit and
> +	 * width, we'll treat that as evidence of a RAID setup and estimate
> +	 * the number of disks.
> +	 */
> +	if (mp->m_sb.sb_unit > 0 && mp->m_sb.sb_width > mp->m_sb.sb_unit)
> +		threads = mp->m_sb.sb_width / mp->m_sb.sb_unit;
> +
> +clamp:
> +	/* Don't return an estimate larger than the CPU count. */
> +	return min(num_online_cpus(), threads);
> +}
> +
> +/* Estimate how many threads we need for a parallel work queue. */
> +unsigned int
> +xfs_pwork_guess_workqueue_threads(
> +	struct xfs_mount	*mp)
> +{
> +	/* pwork queues are not unbounded, so we have to abide WQ_MAX_ACTIVE. */
> +	return min_t(unsigned int, xfs_pwork_guess_metadata_threads(mp),
> +			WQ_MAX_ACTIVE);
>  }
> diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
> index 8133124cf3bb..6320bca9c554 100644
> --- a/fs/xfs/xfs_pwork.h
> +++ b/fs/xfs/xfs_pwork.h
> @@ -56,6 +56,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
>  void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
>  int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
>  void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
> -unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
> +unsigned int xfs_pwork_guess_metadata_threads(struct xfs_mount *mp);
> +unsigned int xfs_pwork_guess_workqueue_threads(struct xfs_mount *mp);
>  
>  #endif /* __XFS_PWORK_H__ */
> 
