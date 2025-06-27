Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE532980A5
	for <linux-xfs@vger.kernel.org>; Fri, 27 Jun 2025 10:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751021643; cv=none; b=VUeHHPHtYmw9fdMVgCfJvJrii5zcNIM8LnRqgt/RolmxzA9PJuR8kHz4ovo6cdZsoT8ed/fPM4oiBv+/5Iy+EbF092lK7SlgTYRxHvp5P4XoW0e7GVK9gjmzbZzXxPZaerlpYeg86WekOCTQwzvq53/JX5+Aa19NeEvntv5sLcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751021643; c=relaxed/simple;
	bh=UDX+7iOrqEB97e4bAkMtzs8q7kkRHMZMiGkbGrMYgP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GO4ESx6qValVGlofDKrSf5mL+6XLPSd2atXa0aoXntLacbK3HzUXane3N93Lu8NuXZKnC7+dGK0yiIZuMN1G+4VA33EI3Zcb1oelt1t6Iu9xxWjKG7M6Ym+U4Jo7Rc5q9NRbfO5f1biuDd4o6MIXPSOOXonL+ta7XxWT9cJQZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmnakwO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmnakwO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BBEC4CEE3;
	Fri, 27 Jun 2025 10:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751021643;
	bh=UDX+7iOrqEB97e4bAkMtzs8q7kkRHMZMiGkbGrMYgP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UmnakwO4HhHstEuQMdYevdILiNo0oVzKgX/5Eb4O7flUNUV4wF8qELY7uVU8OJvWd
	 zxU3uYq23D+0wYsB0xZNqc1dxrpQS7Qd2YDt417e9RTh0yf0GYHFnbYTCwl9N2jklB
	 Zb1mDGGVhU6+IQlYnl9BdukFxuUhn+Rm+6BHdxpaGpf+tfvE1hUttekl7sa6uuN3Sr
	 GWSxj2yUDM9XMVCH3H3S23hWHxNA5HTTU4R5eXyedwVnJVFJMW6wJjE+4Xiylh+Wa/
	 SNPR6qGP/qLXODVbckwNUGftzzkqPSZdYZz7869senO8lMYOakQ2dDF5OMVCX4ldnz
	 AsBUVdg+voWUg==
Date: Fri, 27 Jun 2025 12:53:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: fix unmount hang with unflushable inodes stuck
 in the AIL
Message-ID: <jz7p42an7hxftf4n6syr3m42kszyuftlv7lvia3kmc3eh2lsqf@aqiob5lciud4>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <1FBaQCpT1BbEoYdujg5U6OYT-lKPDEXm84860kxsL4c5XeMF-ebWssWUeTVnQDNhaIXZJTwtXi5BqUB4CS_5zg==@protonmail.internalid>
 <20250625224957.1436116-8-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-8-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:49:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Unmount of a shutdown filesystem can hang with stale inode cluster
> buffers in the AIL like so:
> 
> [95964.140623] Call Trace:
> [95964.144641]  __schedule+0x699/0xb70
> [95964.154003]  schedule+0x64/0xd0
> [95964.156851]  xfs_ail_push_all_sync+0x9b/0xf0
> [95964.164816]  xfs_unmount_flush_inodes+0x41/0x70
> [95964.168698]  xfs_unmountfs+0x7f/0x170
> [95964.171846]  xfs_fs_put_super+0x3b/0x90
> [95964.175216]  generic_shutdown_super+0x77/0x160
> [95964.178060]  kill_block_super+0x1b/0x40
> [95964.180553]  xfs_kill_sb+0x12/0x30
> [95964.182796]  deactivate_locked_super+0x38/0x100
> [95964.185735]  deactivate_super+0x41/0x50
> [95964.188245]  cleanup_mnt+0x9f/0x160
> [95964.190519]  __cleanup_mnt+0x12/0x20
> [95964.192899]  task_work_run+0x89/0xb0
> [95964.195221]  resume_user_mode_work+0x4f/0x60
> [95964.197931]  syscall_exit_to_user_mode+0x76/0xb0
> [95964.201003]  do_syscall_64+0x74/0x130
> 
> Tracing on a hung system shows the AIL repeating every 50ms a log
> force followed by an attempt to push pinned, aborted inodes from the
> AIL (trimmed for brevity):
> 
>  xfs_log_force:   lsn 0x1c caller xfsaild+0x18e
>  xfs_log_force:   lsn 0x0 caller xlog_cil_flush+0xbd
>  xfs_log_force:   lsn 0x1c caller xfs_log_force+0x77
>  xfs_ail_pinned:  lip 0xffff88826014afa0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
>  xfs_ail_pinned:  lip 0xffff88814000a708 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
>  xfs_ail_pinned:  lip 0xffff88810b850c80 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
>  xfs_ail_pinned:  lip 0xffff88810b850af0 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
>  xfs_ail_pinned:  lip 0xffff888165cf0a28 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
>  xfs_ail_pinned:  lip 0xffff88810b850bb8 lsn 1/37472 type XFS_LI_INODE flags IN_AIL|ABORTED
>  ....
> 
> The inode log items are marked as aborted, which means that either:
> 
> a) a transaction commit has occurred, seen an error or shutdown, and
> called xfs_trans_free_items() to abort the items. This should happen
> before any pinning of log items occurs.
> 
> or
> 
> b) a dirty transaction has been cancelled. This should also happen
> before any pinning of log items occurs.
> 
> or
> 
> c) AIL insertion at journal IO completion is marked as aborted. In
> this case, the log item is pinned by the CIL until journal IO
> completes and hence needs to be unpinned. This is then done after
> the ->iop_committed() callback is run, so the pin count should be
> balanced correctly.
> 
> Yet none of these seemed to be occurring. Further tracing indicated
> this:
> 
> d) Shutdown during CIL pushing resulting in log item completion
> being called from checkpoint abort processing. Items are unpinned
> and released without serialisation against each other, journal IO
> completion or transaction commit completion.
> 
> In this case, we may still have a transaction commit in flight that
> holds a reference to a xfs_buf_log_item (BLI) after CIL insertion.
> e.g. a synchronous transaction will flush the CIL before the
> transaction is torn down.  The concurrent CIL push then aborts
> insertion it and drops the commit/AIL reference to the BLI. This can
> leave the transaction commit context with the last reference to the
> BLI which is dropped here:
> 
> xfs_trans_free_items()
>   ->iop_release
>     xfs_buf_item_release
>       xfs_buf_item_put
>         if (XFS_LI_ABORTED)
> 	  xfs_trans_ail_delete
> 	xfs_buf_item_relse()
> 
> Unlike the journal completion ->iop_unpin path, this path does not
> run stale buffer completion process when it drops the last
> reference, hence leaving the stale inodes attached to the buffer
> sitting the AIL. There are no other references to those inodes, so
> there is no other mechanism to remove them from the AIL. Hence
> unmount hangs.
> 
> The buffer lock context for stale buffers is passed to the last BLI
> reference. This is normally the last BLI unpin on journal IO
> completion. The unpin then processes the stale buffer completion and
> releases the buffer lock.  However, if the final unpin from journal
> IO completion (or CIL push abort) does not hold the last reference
> to the BLI, there -must- still be a transaction context that
> references the BLI, and so that context must perform the stale
> buffer completion processing before the buffer is unlocked and the
> BLI torn down.
> 
> The fix for this is to rework the xfs_buf_item_relse() path to run
> stale buffer completion processing if it drops the last reference to
> the BLI. We still hold the buffer locked, so the buffer owner and
> lock context is the same as if we passed the BLI and buffer to the
> ->iop_unpin() context to finish stale process on journal commit.
> 
> However, we have to be careful here. In a shutdown state, we can be
> freeing dirty BLIs from xfs_buf_item_put() via xfs_trans_brelse()
> and xfs_trans_bdetach().  The existing code handles this case by
> considering shutdown state as "aborted", but in doing so
> largely masks the failure to clean up stale BLI state from the
> xfs_buf_item_relse() path. i.e  regardless of the shutdown state and
> whether the item is in the AIL, we must finish the stale buffer
> cleanup if we are are dropping the last BLI reference from the
> ->iop_relse path in transaction commit context.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 121 +++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_buf_item.h |   2 +-
>  2 files changed, 86 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index c95826863c82..7fc54725c5f6 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -612,43 +612,42 @@ xfs_buf_item_push(
>   * Drop the buffer log item refcount and take appropriate action. This helper
>   * determines whether the bli must be freed or not, since a decrement to zero
>   * does not necessarily mean the bli is unused.
> - *
> - * Return true if the bli is freed, false otherwise.
>   */
> -bool
> +void
>  xfs_buf_item_put(
>  	struct xfs_buf_log_item	*bip)
>  {
> -	struct xfs_log_item	*lip = &bip->bli_item;
> -	bool			aborted;
> -	bool			dirty;
> +
> +	ASSERT(xfs_buf_islocked(bip->bli_buf));
> 
>  	/* drop the bli ref and return if it wasn't the last one */
>  	if (!atomic_dec_and_test(&bip->bli_refcount))
> -		return false;
> +		return;
> 
> -	/*
> -	 * We dropped the last ref and must free the item if clean or aborted.
> -	 * If the bli is dirty and non-aborted, the buffer was clean in the
> -	 * transaction but still awaiting writeback from previous changes. In
> -	 * that case, the bli is freed on buffer writeback completion.
> -	 */
> -	aborted = test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
> -			xlog_is_shutdown(lip->li_log);
> -	dirty = bip->bli_flags & XFS_BLI_DIRTY;
> -	if (dirty && !aborted)
> -		return false;
> +	/* If the BLI is in the AIL, then it is still dirty and in use */
> +	if (test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags)) {
> +		ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
> +		return;
> +	}
> 
>  	/*
> -	 * The bli is aborted or clean. An aborted item may be in the AIL
> -	 * regardless of dirty state.  For example, consider an aborted
> -	 * transaction that invalidated a dirty bli and cleared the dirty
> -	 * state.
> +	 * In shutdown conditions, we can be asked to free a dirty BLI that
> +	 * isn't in the AIL. This can occur due to a checkpoint aborting a BLI
> +	 * instead of inserting it into the AIL at checkpoint IO completion. If
> +	 * there's another bli reference (e.g. a btree cursor holds a clean
> +	 * reference) and it is released via xfs_trans_brelse(), we can get here
> +	 * with that aborted, dirty BLI. In this case, it is safe to free the
> +	 * dirty BLI immediately, as it is not in the AIL and there are no
> +	 * other references to it.
> +	 *
> +	 * We should never get here with a stale BLI via that path as
> +	 * xfs_trans_brelse() specifically holds onto stale buffers rather than
> +	 * releasing them.
>  	 */
> -	if (aborted)
> -		xfs_trans_ail_delete(lip, 0);
> +	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY) ||
> +			test_bit(XFS_LI_ABORTED, &bip->bli_item.li_flags));
> +	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
>  	xfs_buf_item_relse(bip);
> -	return true;
>  }
> 
>  /*
> @@ -669,6 +668,15 @@ xfs_buf_item_put(
>   * if necessary but do not unlock the buffer.  This is for support of
>   * xfs_trans_bhold(). Make sure the XFS_BLI_HOLD field is cleared if we don't
>   * free the item.
> + *
> + * If the XFS_BLI_STALE flag is set, the last reference to the BLI *must*
> + * perform a completion abort of any objects attached to the buffer for IO
> + * tracking purposes. This generally only happens in shutdown situations,
> + * normally xfs_buf_item_unpin() will drop the last BLI reference and perform
> + * completion processing. However, because transaction completion can race with
> + * checkpoint completion during a shutdown, this release context may end up
> + * being the last active reference to the BLI and so needs to perform this
> + * cleanup.
>   */
>  STATIC void
>  xfs_buf_item_release(
> @@ -676,18 +684,19 @@ xfs_buf_item_release(
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
>  	struct xfs_buf		*bp = bip->bli_buf;
> -	bool			released;
>  	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
>  	bool			stale = bip->bli_flags & XFS_BLI_STALE;
> -#if defined(DEBUG) || defined(XFS_WARN)
> -	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
> -	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
>  	bool			aborted = test_bit(XFS_LI_ABORTED,
>  						   &lip->li_flags);
> +	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
> +#if defined(DEBUG) || defined(XFS_WARN)
> +	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
>  #endif
> 
>  	trace_xfs_buf_item_release(bip);
> 
> +	ASSERT(xfs_buf_islocked(bp));
> +
>  	/*
>  	 * The bli dirty state should match whether the blf has logged segments
>  	 * except for ordered buffers, where only the bli should be dirty.
> @@ -703,16 +712,56 @@ xfs_buf_item_release(
>  	bp->b_transp = NULL;
>  	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
> 
> +	/* If there are other references, then we have nothing to do. */
> +	if (!atomic_dec_and_test(&bip->bli_refcount))
> +		goto out_release;
> +
>  	/*
> -	 * Unref the item and unlock the buffer unless held or stale. Stale
> -	 * buffers remain locked until final unpin unless the bli is freed by
> -	 * the unref call. The latter implies shutdown because buffer
> -	 * invalidation dirties the bli and transaction.
> +	 * Stale buffer completion frees the BLI, unlocks and releases the
> +	 * buffer. Neither the BLI or buffer are safe to reference after this
> +	 * call, so there's nothing more we need to do here.
> +	 *
> +	 * If we get here with a stale buffer and references to the BLI remain,
> +	 * we must not unlock the buffer as the last BLI reference owns lock
> +	 * context, not us.
>  	 */
> -	released = xfs_buf_item_put(bip);
> -	if (hold || (stale && !released))
> +	if (stale) {
> +		xfs_buf_item_finish_stale(bip);
> +		xfs_buf_relse(bp);
> +		ASSERT(!hold);
> +		return;
> +	}
> +
> +	/*
> +	 * Dirty or clean, aborted items are done and need to be removed from
> +	 * the AIL and released. This frees the BLI, but leaves the buffer
> +	 * locked and referenced.
> +	 */
> +	if (aborted || xlog_is_shutdown(lip->li_log)) {
> +		ASSERT(list_empty(&bip->bli_buf->b_li_list));
> +		xfs_buf_item_done(bp);
> +		goto out_release;
> +	}
> +
> +	/*
> +	 * Clean, unreferenced BLIs can be immediately freed, leaving the buffer
> +	 * locked and referenced.
> +	 *
> +	 * Dirty, unreferenced BLIs *must* be in the AIL awaiting writeback.
> +	 */
> +	if (!dirty)
> +		xfs_buf_item_relse(bip);
> +	else
> +		ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
> +
> +	/* Not safe to reference the BLI from here */
> +out_release:
> +	/*
> +	 * If we get here with a stale buffer, we must not unlock the
> +	 * buffer as the last BLI reference owns lock context, not us.
> +	 */
> +	if (stale || hold)
>  		return;
> -	ASSERT(!stale || aborted);
>  	xfs_buf_relse(bp);
>  }
> 
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 50dd79b59cf5..416890b84f8c 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -49,7 +49,7 @@ struct xfs_buf_log_item {
> 
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void	xfs_buf_item_done(struct xfs_buf *bp);
> -bool	xfs_buf_item_put(struct xfs_buf_log_item *);
> +void	xfs_buf_item_put(struct xfs_buf_log_item *bip);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
> --
> 2.45.2
> 
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
