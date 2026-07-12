Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEFF1F30A9;
	Sun, 12 Jul 2026 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783870631; cv=none; b=m3zXTVUxga0Odrgw9MnzwkVPQ42ThmHgU/AHFn7X5rB0Yx+Z+1377pQNy8J41VyGvOUzWiN4aQe4B6xhdRzmBCahO1GVgxdzTngu34jfyqajL3df0619i/ETmb8hZhQBgNptB0aXMTRFgADT9GQsZ60i0vzs/tMQmePgpRI6JrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783870631; c=relaxed/simple;
	bh=GgVypNS77VsLC9Ytd5y/HYdnm45F0zjf11QKuCe+GPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ix5X+ivnahx7QScLb9ZBr18W9d4unbJplHnSc4MPDJmNSA+vhJftQZ+wJRMyelbT5wTFKjZ9dFlFq14cNwZVG/iYXFcUiEdgJ5n1JyBnZlFgijGBnFicMSNHM0lNtsjMvgByucClkOckfmZnU2dRuTssBCwqvnGv6taDl7KiBj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AL//+J2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AL//+J2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769DD1F000E9;
	Sun, 12 Jul 2026 15:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783870629;
	bh=HHMWQA769uToplyMIVH+2fOZJ67K3M802eCPDfTuhtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AL//+J2whMknfkr88kmN/rQ9oZ356S7JKmjZaaGYQh/ftiBJ2ufG8H7V4wcgyOzS9
	 HNHhSqrxr32XyV14SrfjP0CE91/XVTUGeZzF1Z24VEyFQWa80CfyPycZUL2y0ECoH7
	 CsuDHZQmCaT8Rw+KSBxmicXCJQK7k8mIIn0djicNhdLDMttvn2Q5jeYnIXb83OIYae
	 NV3DGnBmxjCqyCdZTDy6i4Fn6yGEaY1wf+4ygMXh6hMEmEhpTc/5Qw0DulWO20yrF7
	 8dXZMDzn1mKx6pIGeoxP82yXFnQ6v9XPbTqo8KTPWB3t9wduyl0Vq2a5VLjDL/ay/y
	 SUpUeRBnzMD2g==
Date: Sun, 12 Jul 2026 17:37:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: caina <caina@uniontech.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, hch@infradead.org, 
	linux-kernel@vger.kernel.org, kernel@uniontech.com
Subject: Re: [PATCH v3] xfs: clean up spelling and grammar errors in comments
Message-ID: <alO0W1-tul6jgB3l@nidhogg.toxiclabs.cc>
References: <20260703093402.3146-1-caina@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703093402.3146-1-caina@uniontech.com>

On Fri, Jul 03, 2026 at 05:34:02PM +0800, caina wrote:
> Clean up various spelling mistakes and grammar errors found in comments
> across the XFS filesystem code.
> 
> This is a follow-up cleanup to improve code readability. No functional
> changes.
> 
> Signed-off-by: caina <caina@uniontech.com>

This patch does not apply on top of for-next, please rebase it on top of
for-next and re-send.

Also don't forget to Cc me to the patch.

> ---
> Changes in v3:
> - Fix "looks" to "locks" in repair.c comment (suggested by Christoph Hellwig).
> 
> Changes in v2:
> - Keep "do so so that" in alloc_repair.c as the original wording is correct
>   (suggested by Christoph Hellwig).
> - Fix "Does" to "Do" in btree.c comment to match the plural subject "pointers"
>   (suggested by Christoph Hellwig).
> 
>  fs/xfs/libxfs/xfs_alloc.c     |  6 +++---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_btree.c     |  6 +++---
>  fs/xfs/scrub/alloc_repair.c   |  4 ++--
>  fs/xfs/scrub/btree.c          |  2 +-
>  fs/xfs/scrub/repair.c         |  4 ++--
>  fs/xfs/xfs_bmap_util.c        |  2 +-
>  fs/xfs/xfs_buf_item_recover.c |  4 ++--
>  fs/xfs/xfs_inode.c            |  4 ++--
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  fs/xfs/xfs_log.c              | 10 +++++-----
>  fs/xfs/xfs_log_cil.c          | 12 ++++++------
>  fs/xfs/xfs_log_recover.c      |  2 +-
>  fs/xfs/xfs_notify_failure.c   |  4 ++--
>  fs/xfs/xfs_trans.c            | 10 +++++-----
>  fs/xfs/xfs_trans_buf.c        |  2 +-
>  16 files changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index d99602bcc16f..8695b22d88ff 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -37,7 +37,7 @@ struct workqueue_struct *xfs_alloc_wq;
>  #define	XFSA_FIXUP_CNT_OK	2
>  
>  /*
> - * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
> + * Size of the AGFL.  For CRC-enabled filesystems we steal a couple of slots in
>   * the beginning of the block for a proper header with the location information
>   * and CRC.
>   */
> @@ -770,7 +770,7 @@ xfs_alloc_fixup_trees(
>   *
>   * However, we can't even do that for v4 format filesystems because there are
>   * old versions of mkfs out there that does not initialise the AGFL to known,
> - * verifiable values. HEnce we can't tell the difference between a AGFL block
> + * verifiable values. Hence we can't tell the difference between a AGFL block
>   * allocated by mkfs and a corrupted AGFL block here on v4 filesystems.
>   *
>   * As a result, we can only fully validate AGFL block numbers when we pull them
> @@ -3608,7 +3608,7 @@ xfs_alloc_vextent_finish(
>  	 * ABBA AGF deadlocks because a future allocation attempt in this
>  	 * transaction may attempt to lock a lower number AGF.
>  	 *
> -	 * We can't release the AGF until the transaction is commited, so at
> +	 * We can't release the AGF until the transaction is committed, so at
>  	 * this point we must update the "first allocation" tracker to point at
>  	 * this AG if the tracker is empty or points to a lower AG. This allows
>  	 * the next allocation attempt to be modified appropriately to avoid
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2b78041e8672..24be0fb6e56d 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1701,7 +1701,7 @@ xfs_attr3_leaf_add_work(
>  			/*
>  			 * This freemap entry starts at the old end of the
>  			 * leaf entry array, so we need to adjust its base
> -			 * upward to accomodate the larger array.
> +			 * upward to accommodate the larger array.
>  			 */
>  			diff = sizeof(struct xfs_attr_leaf_entry);
>  		} else if (ichdr->freemap[i].size > 0 &&
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 7012f3570c8d..b072222c1b8d 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -398,7 +398,7 @@ xfs_btree_check_ptr(
>   * Calculate CRC on the whole btree block and stuff it into the
>   * long-form btree header.
>   *
> - * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
> + * Prior to calculating the CRC, pull the LSN out of the buffer log item and put
>   * it into the buffer so recovery knows what the last modification was that made
>   * it to disk.
>   */
> @@ -436,7 +436,7 @@ xfs_btree_fsblock_verify_crc(
>   * Calculate CRC on the whole btree block and stuff it into the
>   * short-form btree header.
>   *
> - * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
> + * Prior to calculating the CRC, pull the LSN out of the buffer log item and put
>   * it into the buffer so recovery knows what the last modification was that made
>   * it to disk.
>   */
> @@ -4739,7 +4739,7 @@ xfs_btree_visit_blocks(
>   * Change the owner of a btree.
>   *
>   * The mechanism we use here is ordered buffer logging. Because we don't know
> - * how many buffers were are going to need to modify, we don't really want to
> + * how many buffers we are going to need to modify, we don't really want to
>   * have to make transaction reservations for the worst case of every buffer in a
>   * full size btree as that may be more space that we can fit in the log....
>   *
> diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
> index dce6ab0429dc..0b40de6331f7 100644
> --- a/fs/xfs/scrub/alloc_repair.c
> +++ b/fs/xfs/scrub/alloc_repair.c
> @@ -338,7 +338,7 @@ xrep_cntbt_extent_cmp(
>  }
>  
>  /*
> - * Sort the free extents by length so so that we can put the records into the
> + * Sort the free extents by length so that we can put the records into the
>   * cntbt in the correct order.  Don't let userspace kill us if we're resorting
>   * after allocating btree blocks.
>   */
> @@ -751,7 +751,7 @@ xrep_abt_build_new_trees(
>  		goto err_cur;
>  
>  	/*
> -	 * If we need to re-sort the free extents by length, do so so that we
> +	 * If we need to re-sort the free extents by length, do so that we
>  	 * can put the records into the cntbt in the correct order.
>  	 */
>  	if (needs_resort) {
> diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
> index 786b1e7c4dc3..0e90ac00717d 100644
> --- a/fs/xfs/scrub/btree.c
> +++ b/fs/xfs/scrub/btree.c
> @@ -342,7 +342,7 @@ xchk_btree_block_check_siblings(
>  	/*
>  	 * Does the left & right sibling pointers match the adjacent
>  	 * parent level pointers?
> -	 * (These function absorbs error codes for us.)
> +	 * (These functions absorb error codes for us.)
>  	 */
>  	error = xchk_btree_block_check_sibling(bs, level, -1, &leftsib);
>  	if (error)
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index ac8c592579bd..1b5a64c4583d 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -368,7 +368,7 @@ xrep_calc_ag_resblks(
>  		 * used blocks.  However, with reflink it's possible to have
>  		 * more than one rmap record per AG block.  We don't know how
>  		 * many rmaps there could be in the AG, so we start off with
> -		 * what we hope is an generous over-estimation.
> +		 * what we hope is a generous over-estimation.
>  		 */
>  		if (xfs_has_reflink(mp))
>  			rmapbt_sz = xfs_rmapbt_calc_size(mp,
> @@ -1257,7 +1257,7 @@ xrep_metadata_inode_forks(
>  
>  /*
>   * Set up an in-memory buffer cache so that we can use the xfbtree.  Allocating
> - * a shmem file might take loks, so we cannot be in transaction context.  Park
> + * a shmem file might take locks, so we cannot be in transaction context.  Park
>   * our resources in the scrub context and let the teardown function take care
>   * of them at the right time.
>   */
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0ab00615f1ad..151c4e68e0c8 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1607,7 +1607,7 @@ xfs_swap_extents(
>  		goto out_unlock;
>  
>  	/*
> -	 * Lock and join the inodes to the tansaction so that transaction commit
> +	 * Lock and join the inodes to the transaction so that transaction commit
>  	 * or cancel will unlock the inodes from this point onwards.
>  	 */
>  	xfs_lock_two_inodes(ip, XFS_ILOCK_EXCL, tip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 02b95b89d1b5..768358b12576 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -227,7 +227,7 @@ xlog_recover_validate_buf_type(
>  
>  	/*
>  	 * We can only do post recovery validation on items on CRC enabled
> -	 * fielsystems as we need to know when the buffer was written to be able
> +	 * filesystems as we need to know when the buffer was written to be able
>  	 * to determine if we should have replayed the item. If we replay old
>  	 * metadata over a newer buffer, then it will enter a temporarily
>  	 * inconsistent state resulting in verification failures. Hence for now
> @@ -806,7 +806,7 @@ xlog_recover_do_primary_sb_buffer(
>   *
>   * The magic number might not match the buffer type we are going to recover
>   * (e.g. reallocated blocks), so we ignore the xfs_buf_log_format flags.  Hence
> - * extract the LSN of the existing object in the buffer based on it's current
> + * extract the LSN of the existing object in the buffer based on its current
>   * magic number.  If we don't recognise the magic number in the buffer, then
>   * return a LSN of -1 so that the caller knows it was an unrecognised block and
>   * so can recover the buffer.
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 9978ac1422fc..86392ff08960 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1750,7 +1750,7 @@ xfs_ifree_cluster(
>  		 * IO and it won't be unlocked until the cluster freeing has
>  		 * been committed to the journal and the buffer unpinned. If it
>  		 * is written, we want to know about it, and we want it to
> -		 * fail. We can acheive this by adding a write verifier to the
> +		 * fail. We can achieve this by adding a write verifier to the
>  		 * buffer.
>  		 */
>  		bp->b_flags |= XBF_DONE;
> @@ -2658,7 +2658,7 @@ xfs_irele(
>  }
>  
>  /*
> - * Ensure all commited transactions touching the inode are written to the log.
> + * Ensure all committed transactions touching the inode are written to the log.
>   */
>  int
>  xfs_log_force_inode(
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 4ae81eed0442..bd78762c7701 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -978,7 +978,7 @@ xfs_iflush_ail_updates(
>  
>  		/*
>  		 * dgc: Not sure how this happens, but it happens very
> -		 * occassionaly via generic/388.  xfs_iflush_abort() also
> +		 * occasionally via generic/388.  xfs_iflush_abort() also
>  		 * silently handles this same "under writeback but not in AIL at
>  		 * shutdown" condition via xfs_trans_ail_delete().
>  		 */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f807f8f4f705..b76eb47505e7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -415,7 +415,7 @@ xfs_log_reserve(
>   * before we tear down the AIL.
>   *
>   * We avoid processing actively referenced iclogs so that we don't run callbacks
> - * while the iclog owner might still be preparing the iclog for IO submssion.
> + * while the iclog owner might still be preparing the iclog for IO submission.
>   * These will be caught by xlog_state_iclog_release() and call this function
>   * again to process any callbacks that may have been added to that iclog.
>   */
> @@ -446,7 +446,7 @@ xlog_state_shutdown_callbacks(
>  }
>  
>  /*
> - * Flush iclog to disk if this is the last reference to the given iclog and the
> + * Flush iclog to disk if this is the last reference to the given iclog and
>   * it is in the WANT_SYNC state.
>   *
>   * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
> @@ -632,7 +632,7 @@ xfs_log_mount(
>  	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
>  
>  	/*
> -	 * Now the log has been fully initialised and we know were our
> +	 * Now the log has been fully initialised and we know where our
>  	 * space grant counters are, we can initialise the permanent ticket
>  	 * needed for delayed logging to work.
>  	 */
> @@ -1554,7 +1554,7 @@ xlog_write_iclog(
>  	 * triggered during unmount, and that can occur asynchronously to the
>  	 * unmount thread, and hence we need to ensure that completes before
>  	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
> -	 * across the log IO to archieve that.
> +	 * across the log IO to achieve that.
>  	 */
>  	down(&iclog->ic_sema);
>  	if (xlog_is_shutdown(log)) {
> @@ -1747,7 +1747,7 @@ xlog_sync(
>  	if (bno + BTOBB(count) > log->l_logBBsize)
>  		xlog_split_iclog(log, iclog->ic_header, bno, count);
>  
> -	/* calculcate the checksum */
> +	/* calculate the checksum */
>  	iclog->ic_header->h_crc = xlog_cksum(log, iclog->ic_header,
>  			iclog->ic_datap, XLOG_REC_SIZE, size);
>  	/*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index edc368938f30..572cb864ddce 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -253,7 +253,7 @@ xlog_cil_iovec_space(
>   * the incoming modification. Then during the formatting of the item we can swap
>   * the active buffer with the new one if we can't reuse the existing buffer. We
>   * don't free the old buffer as it may be reused on the next modification if
> - * it's size is right, otherwise we'll free and reallocate it at that point.
> + * its size is right, otherwise we'll free and reallocate it at that point.
>   *
>   * This function builds a vector for the changes in each log item in the
>   * transaction. It then works out the length of the buffer needed for each log
> @@ -1223,7 +1223,7 @@ struct xlog_cil_trans_hdr {
>   *
>   * This is the only place we write a transaction header, so we also build the
>   * log opheaders that indicate the start of a log transaction and wrap the
> - * transaction header. We keep the start record in it's own log vector rather
> + * transaction header. We keep the start record in its own log vector rather
>   * than compacting them into a single region as this ends up making the logic
>   * in xlog_write() for handling empty opheaders for start, commit and unmount
>   * records much simpler.
> @@ -1369,7 +1369,7 @@ xlog_cil_cleanup_whiteouts(
>   * allocation context. However, we do not want to block on memory reclaim
>   * recursing back into the filesystem because this push may have been triggered
>   * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
> - * contraints here.
> + * constraints here.
>   */
>  static void
>  xlog_cil_push_work(
> @@ -1539,7 +1539,7 @@ xlog_cil_push_work(
>  	 * checks for this - ACTIVE can be either a past completed iclog or a
>  	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
>  	 * past or future iclog awaiting IO or ordered IO completion to be run.
> -	 * In the latter case, if it's a future iclog and we wait on it, the we
> +	 * In the latter case, if it's a future iclog and we wait on it, we
>  	 * will hang because it won't get processed through to ic_force_wait
>  	 * wakeup until this commit_iclog is written to disk.  Hence we use the
>  	 * iclog header lsn and compare it to the commit lsn to determine if we
> @@ -1574,7 +1574,7 @@ xlog_cil_push_work(
>  	 *
>  	 * If the push caller needs the commit to be immediately stable and the
>  	 * commit_iclog is not yet marked as XLOG_STATE_WANT_SYNC to indicate it
> -	 * will be written when released, switch it's state to WANT_SYNC right
> +	 * will be written when released, switch its state to WANT_SYNC right
>  	 * now.
>  	 */
>  	ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
> @@ -1984,7 +1984,7 @@ xlog_cil_force_seq(
>  
>  	/*
>  	 * We detected a shutdown in progress. We need to trigger the log force
> -	 * to pass through it's iclog state machine error handling, even though
> +	 * to pass through its iclog state machine error handling, even though
>  	 * we are already in a shutdown state. Hence we can't return
>  	 * NULLCOMMITLSN here as that has special meaning to log forces (i.e.
>  	 * LSN is already stable), so we return a zero LSN instead.
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 09e6678ca487..7da909930fa8 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2293,7 +2293,7 @@ xlog_recovery_process_trans(
>  
>  	/*
>  	 * Callees must not free the trans structure. We'll decide if we need to
> -	 * free it or not based on the operation being done and it's result.
> +	 * free it or not based on the operation being done and its result.
>  	 */
>  	switch (flags) {
>  	/* expected flag values */
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index b994ff15d5e4..86a6fe23446d 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -281,10 +281,10 @@ xfs_dax_notify_dev_failure(
>  		xfs_info(mp, "Device is about to be removed!");
>  		/*
>  		 * Freeze fs to prevent new mappings from being created.
> -		 * - Keep going on if others already hold the kernel forzen.
> +		 * - Keep going on if others already hold the kernel frozen.
>  		 * - Keep going on if other errors too because this device is
>  		 *   starting to fail.
> -		 * - If kernel frozen state is hold successfully here, thaw it
> +		 * - If kernel frozen state is held successfully here, thaw it
>  		 *   here as well at the end.
>  		 */
>  		kernel_frozen = xfs_dax_notify_failure_freeze(mp) == 0;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 148cc32449c1..9f093320e749 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -84,7 +84,7 @@ xfs_trans_free(
>   * permanent log reservation of the given transaction.  The remaining
>   * unused block and rt extent reservations are also inherited.  This
>   * implies that the original transaction is no longer allowed to allocate
> - * blocks.  Locks and log items, however, are no inherited.  They must
> + * blocks.  Locks and log items, however, are not inherited.  They must
>   * be added to the new transaction explicitly.
>   */
>  STATIC struct xfs_trans *
> @@ -1056,7 +1056,7 @@ xfs_trans_roll(
>  }
>  
>  /*
> - * Allocate an transaction, lock and join the inode to it, and reserve quota.
> + * Allocate a transaction, lock and join the inode to it, and reserve quota.
>   *
>   * The caller must ensure that the on-disk dquots attached to this inode have
>   * already been allocated and initialized.  The caller is responsible for
> @@ -1184,7 +1184,7 @@ xfs_trans_reserve_more_inode(
>  }
>  
>  /*
> - * Allocate an transaction in preparation for inode creation by reserving quota
> + * Allocate a transaction in preparation for inode creation by reserving quota
>   * against the given dquots.  Callers are not required to hold any inode locks.
>   */
>  int
> @@ -1234,7 +1234,7 @@ xfs_trans_alloc_icreate(
>  }
>  
>  /*
> - * Allocate an transaction, lock and join the inode to it, and reserve quota
> + * Allocate a transaction, lock and join the inode to it, and reserve quota
>   * in preparation for inode attribute changes that include uid, gid, or prid
>   * changes.
>   *
> @@ -1348,7 +1348,7 @@ xfs_trans_alloc_ichange(
>  }
>  
>  /*
> - * Allocate an transaction, lock and join the directory and child inodes to it,
> + * Allocate a transaction, lock and join the directory and child inodes to it,
>   * and reserve quota for a directory update.  If there isn't sufficient space,
>   * @dblocks will be set to zero for a reservationless directory update and
>   * @nospace_error will be set to a negative errno describing the space
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 95db73a37e57..f8e98f8b97e4 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -274,7 +274,7 @@ xfs_trans_read_buf_map(
>  		 *
>  		 * If the buffer passes verification we'll let this go, but if
>  		 * not we have to shut down.  Let the transaction cleanup code
> -		 * release this buffer when it kills the tranaction.
> +		 * release this buffer when it kills the transaction.
>  		 */
>  		ASSERT(bp->b_ops != NULL);
>  		error = xfs_buf_reverify(bp, ops);
> -- 
> 2.20.1
> 
> 
