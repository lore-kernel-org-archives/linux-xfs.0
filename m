Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C23AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 05:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbiFVFVC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 01:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiFVFVC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 01:21:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD1E36171
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jun 2022 22:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 183426196E
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 05:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7617CC34114;
        Wed, 22 Jun 2022 05:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655875260;
        bh=Cp0S28m6Ik6zWR+7Qs7TdWsGHz+m2QL1STV6ahpS0uc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V/CzTlC4b301XHtlpQg/eUDU/xMGn+RT6cCMHOdflHsy3IGNN2Shen3DuawRudVXd
         MdGw9l8W6OY7+pZeuuWqrWT+BiQf3DlhC4bMoYtrqBwtdkCG8mMDm2Iim77jUH9Z3q
         JdsqhNIqB3HfxfLuDi/bgs9ZeXC58vS0/X7HUkyhczHggJwfbamZWOjhGQXkm798p7
         QKkF8Nz64sEhTc2DnfkFPaofNWzuwJpGZtTgXmU8Rk5GB6K5pGG3is29oyvTd2i9UG
         ddcPbxtbaqnUnqary+jxZFU1UuYk0dzdBImQQ36iw3vlcfiCf2Aet/rbpBdHVC1wMO
         DW+ajPdnntltw==
Date:   Tue, 21 Jun 2022 22:21:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Message-ID: <YrKmvD1yfo3R864n@magnolia>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615220416.3681870-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 16, 2022 at 08:04:16AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current blocking mechanism for pushing the inodegc queue out to
> disk can result in systems becoming unusable when there is a long
> running inodegc operation. This is because the statfs()
> implementation currently issues a blocking flush of the inodegc
> queue and a significant number of common system utilities will call
> statfs() to discover something about the underlying filesystem.
> 
> This can result in userspace operations getting stuck on inodegc
> progress, and when trying to remove a heavily reflinked file on slow
> storage with a full journal, this can result in delays measuring in
> hours.
> 
> Avoid this problem by adding "push" function that expedites the
> flushing of the inodegc queue, but doesn't wait for it to complete.
> 
> Convert xfs_fs_statfs() and xfs_qm_scall_getquota() to use this
> mechanism so they don't block but still ensure that queued
> operations are expedited.
> 
> Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> Reported-by: Chris Dunlop <chris@onthe.net.au>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c      | 20 +++++++++++++++-----
>  fs/xfs/xfs_icache.h      |  1 +
>  fs/xfs/xfs_qm_syscalls.c |  7 +++++--
>  fs/xfs/xfs_super.c       |  7 +++++--
>  fs/xfs/xfs_trace.h       |  1 +
>  5 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 46b30ecf498c..aef4097ffd3e 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1865,19 +1865,29 @@ xfs_inodegc_worker(
>  }
>  
>  /*
> - * Force all currently queued inode inactivation work to run immediately and
> - * wait for the work to finish.
> + * Expedite all pending inodegc work to run immediately. This does not wait for
> + * completion of the work.
>   */
>  void
> -xfs_inodegc_flush(
> +xfs_inodegc_push(
>  	struct xfs_mount	*mp)
>  {
>  	if (!xfs_is_inodegc_enabled(mp))
>  		return;
> +	trace_xfs_inodegc_push(mp, __return_address);
> +	xfs_inodegc_queue_all(mp);
> +}
>  
> +/*
> + * Force all currently queued inode inactivation work to run immediately and
> + * wait for the work to finish.
> + */
> +void
> +xfs_inodegc_flush(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_inodegc_push(mp);
>  	trace_xfs_inodegc_flush(mp, __return_address);
> -
> -	xfs_inodegc_queue_all(mp);
>  	flush_workqueue(mp->m_inodegc_wq);
>  }
>  
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 2e4cfddf8b8e..6cd180721659 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -76,6 +76,7 @@ void xfs_blockgc_stop(struct xfs_mount *mp);
>  void xfs_blockgc_start(struct xfs_mount *mp);
>  
>  void xfs_inodegc_worker(struct work_struct *work);
> +void xfs_inodegc_push(struct xfs_mount *mp);
>  void xfs_inodegc_flush(struct xfs_mount *mp);
>  void xfs_inodegc_stop(struct xfs_mount *mp);
>  void xfs_inodegc_start(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 74ac9ca9e119..a30f4d067746 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -454,9 +454,12 @@ xfs_qm_scall_getquota(
>  	struct xfs_dquot	*dqp;
>  	int			error;
>  
> -	/* Flush inodegc work at the start of a quota reporting scan. */
> +	/*
> +	 * Expedite pending inodegc work at the start of a quota reporting
> +	 * scan but don't block waiting for it to complete.
> +	 */
>  	if (id == 0)
> -		xfs_inodegc_flush(mp);
> +		xfs_inodegc_push(mp);
>  
>  	/*
>  	 * Try to get the dquot. We don't want it allocated on disk, so don't
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 651ae75a7e23..4edee1d3784a 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -798,8 +798,11 @@ xfs_fs_statfs(
>  	xfs_extlen_t		lsize;
>  	int64_t			ffree;
>  
> -	/* Wait for whatever inactivations are in progress. */
> -	xfs_inodegc_flush(mp);
> +	/*
> +	 * Expedite background inodegc but don't wait. We do not want to block
> +	 * here waiting hours for a billion extent file to be truncated.
> +	 */
> +	xfs_inodegc_push(mp);
>  
>  	statp->f_type = XFS_SUPER_MAGIC;
>  	statp->f_namelen = MAXNAMELEN - 1;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index d32026585c1b..0fa1b7a2918c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -240,6 +240,7 @@ DEFINE_EVENT(xfs_fs_class, name,					\
>  	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
>  	TP_ARGS(mp, caller_ip))
>  DEFINE_FS_EVENT(xfs_inodegc_flush);
> +DEFINE_FS_EVENT(xfs_inodegc_push);
>  DEFINE_FS_EVENT(xfs_inodegc_start);
>  DEFINE_FS_EVENT(xfs_inodegc_stop);
>  DEFINE_FS_EVENT(xfs_inodegc_queue);
> -- 
> 2.35.1
> 
