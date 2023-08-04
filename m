Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDE4C001DF
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 18:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjHDSKp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjHDSKp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 14:10:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707D74C38
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 11:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E776620E3
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2023 18:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6676C433C7;
        Fri,  4 Aug 2023 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691172582;
        bh=qcqMoVfANqro1ZdfV7dW5pOkFzA5Urd1WFxrFyRvNeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jqZAy3tyIxkwBd0YujOtYkOGepHPNImkMqGGNlcTVsYd0/czqFSNwpRWsxDEN2/sE
         wyIMXPlCs7KMXFogbJeofjTC8fFek6i7YLqyORagZSg8lxWahiNgEevbkVjm6zsvwC
         Z6CAAsR9NUIKLG+ViqfpZkNNA1eP99wyLoKOgGbJfc8NJj5Tk8xxh6cEgRhnnCiuJM
         OdoHVjP5s/hfMyuDsHyPizxydlGt2UtgjUnkGpR4B3OKVFnMyUQCk1u2zHkICBEaXu
         WXS5229WPMX3YixauKzzDB6ybN+YnioSJPuWxLlCAQ7PQtjNEuQXew5JYiJnQSnxeb
         FsUYZvV8bAagw==
Date:   Fri, 4 Aug 2023 11:09:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, leah.rumancik@gmail.com,
        Dave Chinner <dchinner@redhat.com>,
        Chris Dunlop <chris@onthe.net.au>
Subject: Re: [PATCH CANDIDATE v5.15 9/9] xfs: introduce xfs_inodegc_push()
Message-ID: <20230804180942.GK11352@frogsfrogsfrogs>
References: <20230802205747.GE358316@mit.edu>
 <20230804171019.1392900-1-tytso@mit.edu>
 <20230804171019.1392900-9-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804171019.1392900-9-tytso@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 01:10:19PM -0400, Theodore Ts'o wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit 5e672cd69f0a534a445df4372141fd0d1d00901d upstream.
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
> [djwong: fix _getquota_next to use _inodegc_push too]
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Except for the inodegc parts, this series looks good...
Acked-by: Darrick J. Wong <djwong@kernel.org>

...but as for the inodegc part, I think you'll want to pull this in too:
https://lore.kernel.org/linux-xfs/20230715063114.1485841-1-amir73il@gmail.com/
lest other weird problems manifest.

--D

> ---
>  fs/xfs/xfs_icache.c      | 20 +++++++++++++++-----
>  fs/xfs/xfs_icache.h      |  1 +
>  fs/xfs/xfs_qm_syscalls.c |  9 ++++++---
>  fs/xfs/xfs_super.c       |  7 +++++--
>  fs/xfs/xfs_trace.h       |  1 +
>  5 files changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 2c3ef553f5ef..e9ebfe6f8015 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1872,19 +1872,29 @@ xfs_inodegc_worker(
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
> index 47fe60e1a887..322a111dfbc0 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -481,9 +481,12 @@ xfs_qm_scall_getquota(
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
> @@ -525,7 +528,7 @@ xfs_qm_scall_getquota_next(
>  
>  	/* Flush inodegc work at the start of a quota reporting scan. */
>  	if (*id == 0)
> -		xfs_inodegc_flush(mp);
> +		xfs_inodegc_push(mp);
>  
>  	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
>  	if (error)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 8fe6ca9208de..9b3af7611eaa 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -795,8 +795,11 @@ xfs_fs_statfs(
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
> index 1033a95fbf8e..ebd17ddba024 100644
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
> 2.31.0
> 
