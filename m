Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D952EA479
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760478463; cv=none; b=LvyIGuGNNEym6Kv6udszrYhZLzog8O7VmJYOwU6oApJOtIs2xlBJrYLTWg6zi4OMni6Uq5QjxoFUWg71ZxwajYWsd8DRycXmLx4j0bQAB+dxIOxYGIx/1Fq2vTHQ5zhHm16Y/gdlo5LOq2qDiRF5A2568xjIdwmrte5PLoVEucU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760478463; c=relaxed/simple;
	bh=v5oFlevulWVzuw/XCY526s8tTXY0QYr6y+ysaErH5OY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvhWryMC4/PFfzD4H0Zrm8Fy/oFxTjeZCSnQsPSsj2Sl73CNABh6qmtbfB/+8jVNsjVBMX78ftfNl72ypGakLII+dJ/Igdu/qgK/7SikytCd1JZfHWfm+8UeQmA6eSGt2Dd2WVWPJjKpDg5moovHC0X8BjrgmlL5Us94LndQH54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mwXWAAVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mwXWAAVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9FBC4CEE7;
	Tue, 14 Oct 2025 21:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760478463;
	bh=v5oFlevulWVzuw/XCY526s8tTXY0QYr6y+ysaErH5OY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mwXWAAVMaAw4z8uBSVYccYXM7VMT9EZ0ph9L5SSp/kbrdVssXugIQ5zVPFU261sZF
	 X8TimMzwcV9Xqx1Z5qCozJ3s/AgSF+rzPEL2SDcxWjnRm395TQeUm1k2ZNC4YxpjpB
	 yi/M6m3d+6l3jwYMEmJjKMAM6VJYlc6KQ3g7cGmAHLYBi5lZDfW6pO8TCkH97z+J13
	 O2e7ZVTM6V3tTJNPSsDNDCgHawuul0J5xr3wFHNJgjYvqAZWV7F1PL/EW/b/KRuXl8
	 HyGEkG85Jv1UYzkClxqjH1XXJVm7MGqAgBiyAXWZ3mq4Hj7TWDndnibx8ytuJvVFha
	 MsbCvVpEZ+Xvg==
Date: Tue, 14 Oct 2025 14:47:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: don't use xlog_in_core_2_t in struct
 xlog_in_core
Message-ID: <20251014214742.GI6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013024228.4109032-4-hch@lst.de>

On Mon, Oct 13, 2025 at 11:42:07AM +0900, Christoph Hellwig wrote:
> Most accessed to the on-disk log record header are for the original
> xlog_rec_header.  Make that the main structure, and case for the
> single remaining place using other union legs.
> 
> This prepares for removing xlog_in_core_2_t entirely.

Er... so xlog_rec_header is the header that gets written out at the
start of any log buffer?  And if a log record has more than
XLOG_CYCLE_DATA_SIZE basic blocks (BBs) in it, then it'll have some
quantity of "extended" headers in the form of a xlog_rec_ext_header
right after the xlog_rec_header, right?  And both the regular and ext
headers both have a __be32 array containing the original first four
bytes of each BB, because each BB has a munged version of the LSN cycle
stamped into the first four bytes, right?

The previous patch refactored how the cycle_data transformation
happened, right?

So this patch just gets rid of the strange ic_header #define, and
updates the code to access ic_data->hic_header directly?  And now that
we have xlog_cycle_data to abstract the xlog_rec_header ->
xlog_in_core_2_t casting, this just works fine here.  Right?

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 74 +++++++++++++++++++++----------------------
>  fs/xfs/xfs_log_cil.c  |  6 ++--
>  fs/xfs/xfs_log_priv.h |  9 ++----
>  fs/xfs/xfs_trace.h    |  2 +-
>  4 files changed, 44 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a569a4320a3a..d9476124def6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -534,8 +534,8 @@ xlog_state_release_iclog(
>  	 */
>  	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>  	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
> -	    !iclog->ic_header.h_tail_lsn) {
> -		iclog->ic_header.h_tail_lsn =
> +	    !iclog->ic_header->h_tail_lsn) {
> +		iclog->ic_header->h_tail_lsn =
>  				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
>  	}
>  
> @@ -1457,11 +1457,11 @@ xlog_alloc_log(
>  		iclog->ic_prev = prev_iclog;
>  		prev_iclog = iclog;
>  
> -		iclog->ic_data = kvzalloc(log->l_iclog_size,
> +		iclog->ic_header = kvzalloc(log->l_iclog_size,
>  				GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> -		if (!iclog->ic_data)
> +		if (!iclog->ic_header)
>  			goto out_free_iclog;
> -		head = &iclog->ic_header;
> +		head = iclog->ic_header;
>  		memset(head, 0, sizeof(xlog_rec_header_t));
>  		head->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
>  		head->h_version = cpu_to_be32(
> @@ -1476,7 +1476,7 @@ xlog_alloc_log(
>  		iclog->ic_log = log;
>  		atomic_set(&iclog->ic_refcnt, 0);
>  		INIT_LIST_HEAD(&iclog->ic_callbacks);
> -		iclog->ic_datap = (void *)iclog->ic_data + log->l_iclog_hsize;
> +		iclog->ic_datap = (void *)iclog->ic_header + log->l_iclog_hsize;
>  
>  		init_waitqueue_head(&iclog->ic_force_wait);
>  		init_waitqueue_head(&iclog->ic_write_wait);
> @@ -1504,7 +1504,7 @@ xlog_alloc_log(
>  out_free_iclog:
>  	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
>  		prev_iclog = iclog->ic_next;
> -		kvfree(iclog->ic_data);
> +		kvfree(iclog->ic_header);
>  		kfree(iclog);
>  		if (prev_iclog == log->l_iclog)
>  			break;
> @@ -1524,7 +1524,7 @@ xlog_pack_data(
>  	struct xlog_in_core	*iclog,
>  	int			roundoff)
>  {
> -	struct xlog_rec_header	*rhead = &iclog->ic_header;
> +	struct xlog_rec_header	*rhead = iclog->ic_header;
>  	__be32			cycle_lsn = CYCLE_LSN_DISK(rhead->h_lsn);
>  	char			*dp = iclog->ic_datap;
>  	int			i;
> @@ -1536,7 +1536,7 @@ xlog_pack_data(
>  	}
>  
>  	if (xfs_has_logv2(log->l_mp)) {
> -		xlog_in_core_2_t *xhdr = iclog->ic_data;
> +		xlog_in_core_2_t *xhdr = (xlog_in_core_2_t *)iclog->ic_header;
>  
>  		for (i = 1; i < log->l_iclog_heads; i++)
>  			xhdr[i].hic_xheader.xh_cycle = cycle_lsn;
> @@ -1658,11 +1658,11 @@ xlog_write_iclog(
>  
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  
> -	if (is_vmalloc_addr(iclog->ic_data)) {
> -		if (!bio_add_vmalloc(&iclog->ic_bio, iclog->ic_data, count))
> +	if (is_vmalloc_addr(iclog->ic_header)) {
> +		if (!bio_add_vmalloc(&iclog->ic_bio, iclog->ic_header, count))
>  			goto shutdown;
>  	} else {
> -		bio_add_virt_nofail(&iclog->ic_bio, iclog->ic_data, count);
> +		bio_add_virt_nofail(&iclog->ic_bio, iclog->ic_header, count);
>  	}
>  
>  	/*
> @@ -1791,19 +1791,19 @@ xlog_sync(
>  	size = iclog->ic_offset;
>  	if (xfs_has_logv2(log->l_mp))
>  		size += roundoff;
> -	iclog->ic_header.h_len = cpu_to_be32(size);
> +	iclog->ic_header->h_len = cpu_to_be32(size);
>  
>  	XFS_STATS_INC(log->l_mp, xs_log_writes);
>  	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
>  
> -	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
> +	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header->h_lsn));
>  
>  	/* Do we need to split this write into 2 parts? */
>  	if (bno + BTOBB(count) > log->l_logBBsize)
> -		xlog_split_iclog(log, &iclog->ic_header, bno, count);
> +		xlog_split_iclog(log, iclog->ic_header, bno, count);
>  
>  	/* calculcate the checksum */
> -	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
> +	iclog->ic_header->h_crc = xlog_cksum(log, iclog->ic_header,
>  			iclog->ic_datap, XLOG_REC_SIZE, size);
>  	/*
>  	 * Intentionally corrupt the log record CRC based on the error injection
> @@ -1814,11 +1814,11 @@ xlog_sync(
>  	 */
>  #ifdef DEBUG
>  	if (XFS_TEST_ERROR(log->l_mp, XFS_ERRTAG_LOG_BAD_CRC)) {
> -		iclog->ic_header.h_crc &= cpu_to_le32(0xAAAAAAAA);
> +		iclog->ic_header->h_crc &= cpu_to_le32(0xAAAAAAAA);
>  		iclog->ic_fail_crc = true;
>  		xfs_warn(log->l_mp,
>  	"Intentionally corrupted log record at LSN 0x%llx. Shutdown imminent.",
> -			 be64_to_cpu(iclog->ic_header.h_lsn));
> +			 be64_to_cpu(iclog->ic_header->h_lsn));
>  	}
>  #endif
>  	xlog_verify_iclog(log, iclog, count);
> @@ -1845,7 +1845,7 @@ xlog_dealloc_log(
>  	iclog = log->l_iclog;
>  	for (i = 0; i < log->l_iclog_bufs; i++) {
>  		next_iclog = iclog->ic_next;
> -		kvfree(iclog->ic_data);
> +		kvfree(iclog->ic_header);
>  		kfree(iclog);
>  		iclog = next_iclog;
>  	}
> @@ -1867,7 +1867,7 @@ xlog_state_finish_copy(
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> -	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
> +	be32_add_cpu(&iclog->ic_header->h_num_logops, record_cnt);
>  	iclog->ic_offset += copy_bytes;
>  }
>  
> @@ -2290,7 +2290,7 @@ xlog_state_activate_iclog(
>  	 * We don't need to cover the dummy.
>  	 */
>  	if (*iclogs_changed == 0 &&
> -	    iclog->ic_header.h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
> +	    iclog->ic_header->h_num_logops == cpu_to_be32(XLOG_COVER_OPS)) {
>  		*iclogs_changed = 1;
>  	} else {
>  		/*
> @@ -2302,11 +2302,11 @@ xlog_state_activate_iclog(
>  
>  	iclog->ic_state	= XLOG_STATE_ACTIVE;
>  	iclog->ic_offset = 0;
> -	iclog->ic_header.h_num_logops = 0;
> -	memset(iclog->ic_header.h_cycle_data, 0,
> -		sizeof(iclog->ic_header.h_cycle_data));
> -	iclog->ic_header.h_lsn = 0;
> -	iclog->ic_header.h_tail_lsn = 0;
> +	iclog->ic_header->h_num_logops = 0;
> +	memset(iclog->ic_header->h_cycle_data, 0,
> +		sizeof(iclog->ic_header->h_cycle_data));
> +	iclog->ic_header->h_lsn = 0;
> +	iclog->ic_header->h_tail_lsn = 0;
>  }
>  
>  /*
> @@ -2398,7 +2398,7 @@ xlog_get_lowest_lsn(
>  		    iclog->ic_state == XLOG_STATE_DIRTY)
>  			continue;
>  
> -		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
>  		if ((lsn && !lowest_lsn) || XFS_LSN_CMP(lsn, lowest_lsn) < 0)
>  			lowest_lsn = lsn;
>  	} while ((iclog = iclog->ic_next) != log->l_iclog);
> @@ -2433,7 +2433,7 @@ xlog_state_iodone_process_iclog(
>  		 * If this is not the lowest lsn iclog, then we will leave it
>  		 * for another completion to process.
>  		 */
> -		header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		header_lsn = be64_to_cpu(iclog->ic_header->h_lsn);
>  		lowest_lsn = xlog_get_lowest_lsn(log);
>  		if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
>  			return false;
> @@ -2616,7 +2616,7 @@ xlog_state_get_iclog_space(
>  		goto restart;
>  	}
>  
> -	head = &iclog->ic_header;
> +	head = iclog->ic_header;
>  
>  	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
>  	log_offset = iclog->ic_offset;
> @@ -2781,7 +2781,7 @@ xlog_state_switch_iclogs(
>  	if (!eventual_size)
>  		eventual_size = iclog->ic_offset;
>  	iclog->ic_state = XLOG_STATE_WANT_SYNC;
> -	iclog->ic_header.h_prev_block = cpu_to_be32(log->l_prev_block);
> +	iclog->ic_header->h_prev_block = cpu_to_be32(log->l_prev_block);
>  	log->l_prev_block = log->l_curr_block;
>  	log->l_prev_cycle = log->l_curr_cycle;
>  
> @@ -2825,7 +2825,7 @@ xlog_force_and_check_iclog(
>  	struct xlog_in_core	*iclog,
>  	bool			*completed)
>  {
> -	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
>  	int			error;
>  
>  	*completed = false;
> @@ -2837,7 +2837,7 @@ xlog_force_and_check_iclog(
>  	 * If the iclog has already been completed and reused the header LSN
>  	 * will have been rewritten by completion
>  	 */
> -	if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
> +	if (be64_to_cpu(iclog->ic_header->h_lsn) != lsn)
>  		*completed = true;
>  	return 0;
>  }
> @@ -2970,7 +2970,7 @@ xlog_force_lsn(
>  		goto out_error;
>  
>  	iclog = log->l_iclog;
> -	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> +	while (be64_to_cpu(iclog->ic_header->h_lsn) != lsn) {
>  		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
>  		iclog = iclog->ic_next;
>  		if (iclog == log->l_iclog)
> @@ -3236,7 +3236,7 @@ xlog_verify_dump_tail(
>  {
>  	xfs_alert(log->l_mp,
>  "ran out of log space tail 0x%llx/0x%llx, head lsn 0x%llx, head 0x%x/0x%x, prev head 0x%x/0x%x",
> -			iclog ? be64_to_cpu(iclog->ic_header.h_tail_lsn) : -1,
> +			iclog ? be64_to_cpu(iclog->ic_header->h_tail_lsn) : -1,
>  			atomic64_read(&log->l_tail_lsn),
>  			log->l_ailp->ail_head_lsn,
>  			log->l_curr_cycle, log->l_curr_block,
> @@ -3255,7 +3255,7 @@ xlog_verify_tail_lsn(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
>  {
> -	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
> +	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header->h_tail_lsn);
>  	int		blocks;
>  
>  	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
> @@ -3309,7 +3309,7 @@ xlog_verify_iclog(
>  	struct xlog_in_core	*iclog,
>  	int			count)
>  {
> -	struct xlog_rec_header	*rhead = &iclog->ic_header;
> +	struct xlog_rec_header	*rhead = iclog->ic_header;
>  	xlog_in_core_t		*icptr;
>  	void			*base_ptr, *ptr;
>  	ptrdiff_t		field_offset;
> @@ -3507,7 +3507,7 @@ xlog_iclogs_empty(
>  		/* endianness does not matter here, zero is zero in
>  		 * any language.
>  		 */
> -		if (iclog->ic_header.h_num_logops)
> +		if (iclog->ic_header->h_num_logops)
>  			return 0;
>  		iclog = iclog->ic_next;
>  	} while (iclog != log->l_iclog);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f443757e93c2..778ac47adb8c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -940,7 +940,7 @@ xlog_cil_set_ctx_write_state(
>  	struct xlog_in_core	*iclog)
>  {
>  	struct xfs_cil		*cil = ctx->cil;
> -	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
>  
>  	ASSERT(!ctx->commit_lsn);
>  	if (!ctx->start_lsn) {
> @@ -1458,9 +1458,9 @@ xlog_cil_push_work(
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	if (ctx->start_lsn != ctx->commit_lsn) {
> -		xfs_lsn_t	plsn;
> +		xfs_lsn_t	plsn = be64_to_cpu(
> +			ctx->commit_iclog->ic_prev->ic_header->h_lsn);
>  
> -		plsn = be64_to_cpu(ctx->commit_iclog->ic_prev->ic_header.h_lsn);
>  		if (plsn && XFS_LSN_CMP(plsn, ctx->commit_lsn) < 0) {
>  			/*
>  			 * Waiting on ic_force_wait orders the completion of
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index d2f17691ecca..f1aed6e8f747 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -158,10 +158,8 @@ struct xlog_ticket {
>  };
>  
>  /*
> - * - A log record header is 512 bytes.  There is plenty of room to grow the
> - *	xlog_rec_header_t into the reserved space.
> - * - ic_data follows, so a write to disk can start at the beginning of
> - *	the iclog.
> + * In-core log structure.
> + *
>   * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
>   * - ic_next is the pointer to the next iclog in the ring.
>   * - ic_log is a pointer back to the global log structure.
> @@ -198,8 +196,7 @@ typedef struct xlog_in_core {
>  
>  	/* reference counts need their own cacheline */
>  	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
> -	xlog_in_core_2_t	*ic_data;
> -#define ic_header	ic_data->hic_header
> +	struct xlog_rec_header	*ic_header;
>  #ifdef DEBUG
>  	bool			ic_fail_crc : 1;
>  #endif
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 79b8641880ab..aa3a3870f894 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -4934,7 +4934,7 @@ DECLARE_EVENT_CLASS(xlog_iclog_class,
>  		__entry->refcount = atomic_read(&iclog->ic_refcnt);
>  		__entry->offset = iclog->ic_offset;
>  		__entry->flags = iclog->ic_flags;
> -		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		__entry->lsn = be64_to_cpu(iclog->ic_header->h_lsn);
>  		__entry->caller_ip = caller_ip;
>  	),
>  	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx flags %s caller %pS",
> -- 
> 2.47.3
> 
> 
