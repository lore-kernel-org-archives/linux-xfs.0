Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9F43D8123;
	Tue, 10 Mar 2026 20:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175256; cv=none; b=LofmEPB9fV+bnK0RNxaVYlnq452jEXshU510rRAODkS4sjv1Xk9eDDkiCwGElVk4UwTU0lyDcDFHthLLUEzHWgAfDHPKJEBDcJgsL4si8X8Lt0oDz7PG97vqMcBDLi5Or0aglEPGwlA4rvwDiTQmgVZA5jMLfWTSkB/eEkLqJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175256; c=relaxed/simple;
	bh=ZCEr9y6H2pqBw4O/TEzdGPAdahJAFjsn9PAQUf4ZC6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azmPa3hlbYO73TN0UU3pZ7L0+BoesExhLH3yS61Ur3DuxnYsz1topNqGw2AbXiCKuVlOnNDp9CWplsaoZLEVvVW/5KduGPPSCSzSdraksIOwbVRr7u+9QV5iUG+/ekiyqdqo7TiGOOC3nNY3uHF8XweoSqoO2RXfxyJ/5E9JIjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYLM6pvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYLM6pvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CFC19423;
	Tue, 10 Mar 2026 20:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773175256;
	bh=ZCEr9y6H2pqBw4O/TEzdGPAdahJAFjsn9PAQUf4ZC6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mYLM6pvzy8q0FH+KUvcMNueqpGSnhx7FoPm6cuN2Ts7jFt2CKIfh0t8X5dLNBFVko
	 0Lh1ex8eiDLXETsBFtWct5eH3QHw83KRNcTdUqEM87U9PaP6armSbiT5+fZOehmK4E
	 dkpN4Z2Ji8coOm/Qw2GEgkfyxXZfMYIlOUgG0PK7YKH3LyzxAwNBuz5CEJTn7btD9H
	 y2tjWAQ09gcB+M6rg0vt/tMlhIS/JEyKtTzK1182k/6RlZiyh0I15J4aftMUSqQ67j
	 U3w6d9bO6oRfUPIDILLLDThlPfKVHWXqVfiRaNYgFHbZ8gsfWrjq9n1Powl8yvF9sO
	 PcbHv4zT2tBXg==
Date: Tue, 10 Mar 2026 13:40:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 2/4] xfs: avoid dereferencing log items after push
 callbacks
Message-ID: <20260310204055.GX1105363@frogsfrogsfrogs>
References: <20260310183835.89827-6-ytohnuki@amazon.com>
 <20260310183835.89827-8-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310183835.89827-8-ytohnuki@amazon.com>

On Tue, Mar 10, 2026 at 06:38:38PM +0000, Yuto Ohnuki wrote:
> After xfsaild_push_item() calls iop_push(), the log item may have been
> freed if the AIL lock was dropped during the push. Background inode
> reclaim or the dquot shrinker can free the log item while the AIL lock
> is not held, and the tracepoints in the switch statement dereference
> the log item after iop_push() returns.
> 
> Fix this by capturing the log item type, flags, and LSN before calling
> xfsaild_push_item(), and introducing a new xfs_ail_push_class trace
> event class that takes these pre-captured values and the ailp pointer
> instead of the log item pointer.
> 
> Reported-by: syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=652af2b3c5569c4ab63c
> Fixes: 90c60e164012 ("xfs: xfs_iflush() is no longer necessary")
> Cc: <stable@vger.kernel.org> # v5.9
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

That looks like a solid fix to me; thanks for working on this!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trace.h     | 36 ++++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_trans_ail.c | 26 +++++++++++++++++++-------
>  2 files changed, 51 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 813e5a9f57eb..0e994b3f768f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -56,6 +56,7 @@
>  #include <linux/tracepoint.h>
>  
>  struct xfs_agf;
> +struct xfs_ail;
>  struct xfs_alloc_arg;
>  struct xfs_attr_list_context;
>  struct xfs_buf_log_item;
> @@ -1650,16 +1651,43 @@ TRACE_EVENT(xfs_log_force,
>  DEFINE_EVENT(xfs_log_item_class, name, \
>  	TP_PROTO(struct xfs_log_item *lip), \
>  	TP_ARGS(lip))
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
> -DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
>  DEFINE_LOG_ITEM_EVENT(xlog_ail_insert_abort);
>  DEFINE_LOG_ITEM_EVENT(xfs_trans_free_abort);
>  
> +DECLARE_EVENT_CLASS(xfs_ail_push_class,
> +	TP_PROTO(struct xfs_ail *ailp, uint type, unsigned long flags, xfs_lsn_t lsn),
> +	TP_ARGS(ailp, type, flags, lsn),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(uint, type)
> +		__field(unsigned long, flags)
> +		__field(xfs_lsn_t, lsn)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = ailp->ail_log->l_mp->m_super->s_dev;
> +		__entry->type = type;
> +		__entry->flags = flags;
> +		__entry->lsn = lsn;
> +	),
> +	TP_printk("dev %d:%d lsn %d/%d type %s flags %s",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  CYCLE_LSN(__entry->lsn), BLOCK_LSN(__entry->lsn),
> +		  __print_symbolic(__entry->type, XFS_LI_TYPE_DESC),
> +		  __print_flags(__entry->flags, "|", XFS_LI_FLAGS))
> +)
> +
> +#define DEFINE_AIL_PUSH_EVENT(name) \
> +DEFINE_EVENT(xfs_ail_push_class, name, \
> +	TP_PROTO(struct xfs_ail *ailp, uint type, unsigned long flags, xfs_lsn_t lsn), \
> +	TP_ARGS(ailp, type, flags, lsn))
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_push);
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_pinned);
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_locked);
> +DEFINE_AIL_PUSH_EVENT(xfs_ail_flushing);
> +
>  DECLARE_EVENT_CLASS(xfs_ail_class,
>  	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
>  	TP_ARGS(lip, old_lsn, new_lsn),
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 923729af4206..63266d31b514 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -365,6 +365,12 @@ xfsaild_resubmit_item(
>  	return XFS_ITEM_SUCCESS;
>  }
>  
> +/*
> + * Push a single log item from the AIL.
> + *
> + * @lip may have been released and freed by the time this function returns,
> + * so callers must not dereference the log item afterwards.
> + */
>  static inline uint
>  xfsaild_push_item(
>  	struct xfs_ail		*ailp,
> @@ -505,7 +511,10 @@ xfsaild_push(
>  
>  	lsn = lip->li_lsn;
>  	while ((XFS_LSN_CMP(lip->li_lsn, ailp->ail_target) <= 0)) {
> -		int	lock_result;
> +		int		lock_result;
> +		uint		type = lip->li_type;
> +		unsigned long	flags = lip->li_flags;
> +		xfs_lsn_t	item_lsn = lip->li_lsn;
>  
>  		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
>  			goto next_item;
> @@ -514,14 +523,17 @@ xfsaild_push(
>  		 * Note that iop_push may unlock and reacquire the AIL lock.  We
>  		 * rely on the AIL cursor implementation to be able to deal with
>  		 * the dropped lock.
> +		 *
> +		 * The log item may have been freed by the push, so it must not
> +		 * be accessed or dereferenced below this line.
>  		 */
>  		lock_result = xfsaild_push_item(ailp, lip);
>  		switch (lock_result) {
>  		case XFS_ITEM_SUCCESS:
>  			XFS_STATS_INC(mp, xs_push_ail_success);
> -			trace_xfs_ail_push(lip);
> +			trace_xfs_ail_push(ailp, type, flags, item_lsn);
>  
> -			ailp->ail_last_pushed_lsn = lsn;
> +			ailp->ail_last_pushed_lsn = item_lsn;
>  			break;
>  
>  		case XFS_ITEM_FLUSHING:
> @@ -537,22 +549,22 @@ xfsaild_push(
>  			 * AIL is being flushed.
>  			 */
>  			XFS_STATS_INC(mp, xs_push_ail_flushing);
> -			trace_xfs_ail_flushing(lip);
> +			trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
>  
>  			flushing++;
> -			ailp->ail_last_pushed_lsn = lsn;
> +			ailp->ail_last_pushed_lsn = item_lsn;
>  			break;
>  
>  		case XFS_ITEM_PINNED:
>  			XFS_STATS_INC(mp, xs_push_ail_pinned);
> -			trace_xfs_ail_pinned(lip);
> +			trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
>  
>  			stuck++;
>  			ailp->ail_log_flush++;
>  			break;
>  		case XFS_ITEM_LOCKED:
>  			XFS_STATS_INC(mp, xs_push_ail_locked);
> -			trace_xfs_ail_locked(lip);
> +			trace_xfs_ail_locked(ailp, type, flags, item_lsn);
>  
>  			stuck++;
>  			break;
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
