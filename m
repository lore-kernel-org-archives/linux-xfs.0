Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E62DC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 16:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238979AbiEXQRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 12:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbiEXQR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 12:17:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6574E38A
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 09:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10971B81722
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 16:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB35BC34113;
        Tue, 24 May 2022 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653409045;
        bh=kOIVQmYZfrWSjFuQ1nOSlWAs03j6oFZYXiI1c5Ce0s8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nSXezwtP0l0ouMYoAsrx6WpDAwRFtExomvkVR3oogaCW7y2zlUwFJAO1qI6pCc4Uv
         4js4bfghqo+GFUe2nhtCR7jeBoRspV/X+gY2T6fcPbBj255mAKADxtidg5dkI2bo9K
         Nriy41bAqnvrRjVAP04Yn3yVl+RdJkFc7lpDv1vRsivZSE1zaC2GnSnOuA/L+0ZMp4
         KXwsPzNQi/5UnhZ4scBy8MHuMQo6x/r5fsYViVxDjehdSTmTsAx6hhpX3pfoHwDsM5
         lTLcY6QkTaAL2N3r4QpAmPcz/MENrWhjmU1jE3gBqUxke3itYzzpQqmZwJCkZ2VS5j
         s4bFl+wd+9MJQ==
Date:   Tue, 24 May 2022 09:17:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chris@onthe.net.au
Subject: Re: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Message-ID: <Yo0FFWYECpIdKyZC@magnolia>
References: <20220524063802.1938505-1-david@fromorbit.com>
 <20220524063802.1938505-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524063802.1938505-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 24, 2022 at 04:38:02PM +1000, Dave Chinner wrote:
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
> Convert xfs_fs_statfs() to use this mechanism so it doesn't block
> but it does ensure that queued operations are expedited.
> 
> Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> Reported-by: Chris Dunlop <chris@onthe.net.au>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 20 +++++++++++++++-----
>  fs/xfs/xfs_icache.h |  1 +
>  fs/xfs/xfs_super.c  |  7 +++++--
>  fs/xfs/xfs_trace.h  |  1 +
>  4 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 786702273621..2609825d53ee 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1862,19 +1862,29 @@ xfs_inodegc_worker(
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
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 62f6b97355a2..e14101813851 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -796,8 +796,11 @@ xfs_fs_statfs(
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

I think the same "don't wait forever for inodegc during a stats call"
logic applies to the _inodegc_flush calls in xfs_qm_scall_getquota*,
wouldn't it?

The logic in this patch looks solid otherwise.

--D

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
