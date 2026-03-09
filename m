Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91533AA1BC;
	Mon,  9 Mar 2026 16:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073632; cv=none; b=ZvHr3Z73pV43vEw54+t2MUojEc4x53fwol/ZoH3r+gTO6+VfDWmni2cubchmT8S9LaiXte6cefQ8K1NFaiPP/rcGjOxJmziUcSHjtLkWsOlFJf1v2Uu0yUp5kyq0A1E3LnaHzubpIS56dhG0yGtbK8l0/z76RB6teNuW+KdCudI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073632; c=relaxed/simple;
	bh=pXeQ0w0IhglN90PkBAEavTvZdYtVONAKMna7t6PhtYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igE0LUScQjyZc8SEfvAZI4Ilj0noiwGc2P89fFbWE+aqDdFXfiMGUSwfJl0m7U2rjUtMgNSUNCiP+feVVyUWHDGTxEPu2g9cv1KPgi6wvXgBUB6Z7uskWya9YQvrGR9rPlGoGCj/S7uN9GgzJuGt/zcEZf4AlslwmCiUKNDBTD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ce62ZJDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ce62ZJDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB13EC2BCB2;
	Mon,  9 Mar 2026 16:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773073631;
	bh=pXeQ0w0IhglN90PkBAEavTvZdYtVONAKMna7t6PhtYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ce62ZJDvsWPo7o+oLk4O00O9mWYrl7bk09FX7fHwiuIy6YDvz3sFcumWYbjuJVbSM
	 lOuOFvz/1tC9TBES9UDuwDwZPf8yjmonFMwBJepX/Y09cpOz3itSAoanbhqeJkIi2b
	 kQGbQl5SdgiKp8WETIw3l/Byr0Vzys3DllRcFKxIesL+jWnP/VvGJg5PilQebaU9gY
	 gXp4WGahAyQiIiqZSgXP5+dx86x2z8DLnbdbWZ6TeZJGfru46xqHTyI7GTSt/9H21q
	 vzY4G+sJpRTDLG/ke+VAtdAPoGuQZIOBMQtm9xgGeKeZtJ0/XbB9ge4VmCQRt4uaW6
	 /Y9lVqlkLoe6w==
Date: Mon, 9 Mar 2026 09:27:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: avoid dereferencing log items after push
 callbacks
Message-ID: <20260309162710.GC6033@frogsfrogsfrogs>
References: <20260308182804.33127-6-ytohnuki@amazon.com>
 <20260308182804.33127-9-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308182804.33127-9-ytohnuki@amazon.com>

On Sun, Mar 08, 2026 at 06:28:08PM +0000, Yuto Ohnuki wrote:
> After xfsaild_push_item() calls iop_push(), the log item may have been
> freed if the AIL lock was dropped during the push. The tracepoints in
> the switch statement dereference the log item after iop_push() returns,
> which can result in a use-after-free.

How difficult would it be to add a refcount to xfs_log_item so that any
other code walking through the AIL's log item list can't accidentally
suffer from this UAF?  I keep seeing periodic log item UAF bugfixes on
the list, which (to me anyway) suggests we ought to think about a
struct(ural) fix to this problem.

I /think/ the answer to that is "sort of nasty" because of things like
xfs_dquot embedding its own log item.  The other log item types might
not be so bad because at least they're allocated separately.  However,
refcount_t accesses also aren't free.

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
> ---
>  fs/xfs/xfs_trace.h     | 36 ++++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_trans_ail.c | 24 ++++++++++++++++--------
>  2 files changed, 48 insertions(+), 12 deletions(-)
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
> index ac747804e1d6..14ffb77b12ea 100644
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

This is true after the xfsaild_push_item call, correct?  If so then I
think the comment for the call needs updating too:

	/*
	 * Note that iop_push may unlock and reacquire the AIL lock.  We
	 * rely on the AIL cursor implementation to be able to deal with
	 * the dropped lock.
	 *
	 * The log item may have been freed by the push, so it must not
	 * be accessed or dereferenced below this line.
	 */
	lock_result = xfsaild_push_item(ailp, lip);

Otherwise this looks ok to me.

--D

> + */
>  static inline uint
>  xfsaild_push_item(
>  	struct xfs_ail		*ailp,
> @@ -462,11 +468,13 @@ static void
>  xfsaild_process_logitem(
>  	struct xfs_ail		*ailp,
>  	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn,
>  	int			*stuck,
>  	int			*flushing)
>  {
>  	struct xfs_mount	*mp = ailp->ail_log->l_mp;
> +	uint			type = lip->li_type;
> +	unsigned long		flags = lip->li_flags;
> +	xfs_lsn_t		item_lsn = lip->li_lsn;
>  	int			lock_result;
>  
>  	/*
> @@ -478,9 +486,9 @@ xfsaild_process_logitem(
>  	switch (lock_result) {
>  	case XFS_ITEM_SUCCESS:
>  		XFS_STATS_INC(mp, xs_push_ail_success);
> -		trace_xfs_ail_push(lip);
> +		trace_xfs_ail_push(ailp, type, flags, item_lsn);
>  
> -		ailp->ail_last_pushed_lsn = lsn;
> +		ailp->ail_last_pushed_lsn = item_lsn;
>  		break;
>  
>  	case XFS_ITEM_FLUSHING:
> @@ -496,22 +504,22 @@ xfsaild_process_logitem(
>  		 * AIL is being flushed.
>  		 */
>  		XFS_STATS_INC(mp, xs_push_ail_flushing);
> -		trace_xfs_ail_flushing(lip);
> +		trace_xfs_ail_flushing(ailp, type, flags, item_lsn);
>  
>  		(*flushing)++;
> -		ailp->ail_last_pushed_lsn = lsn;
> +		ailp->ail_last_pushed_lsn = item_lsn;
>  		break;
>  
>  	case XFS_ITEM_PINNED:
>  		XFS_STATS_INC(mp, xs_push_ail_pinned);
> -		trace_xfs_ail_pinned(lip);
> +		trace_xfs_ail_pinned(ailp, type, flags, item_lsn);
>  
>  		(*stuck)++;
>  		ailp->ail_log_flush++;
>  		break;
>  	case XFS_ITEM_LOCKED:
>  		XFS_STATS_INC(mp, xs_push_ail_locked);
> -		trace_xfs_ail_locked(lip);
> +		trace_xfs_ail_locked(ailp, type, flags, item_lsn);
>  
>  		(*stuck)++;
>  		break;
> @@ -572,7 +580,7 @@ xfsaild_push(
>  		if (test_bit(XFS_LI_FLUSHING, &lip->li_flags))
>  			goto next_item;
>  
> -		xfsaild_process_logitem(ailp, lip, lsn, &stuck, &flushing);
> +		xfsaild_process_logitem(ailp, lip, &stuck, &flushing);
>  		count++;
>  
>  		/*
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
