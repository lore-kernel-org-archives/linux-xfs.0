Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CDBC147
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750938612; cv=none; b=WJ+w8S96hiOp4Wia6fmTo0n9f5wIoIOHt87e0/cMCFQboX1an/6F4jqpM5MleL5ka4EvjjKlULWkzAB6TFlkVw4D7YTlzgFVzwXDI2Xgdd0kgywEyt5kO1bl16sHZkIpOqzMztDTZut/Rvtmg6eerZqRy+Tnl16o5VvN/S4+jYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750938612; c=relaxed/simple;
	bh=FPzV0/u+EFmGaVog++EkyHi12RIjqXeGCuDMfKSnAYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KBVZpmY1hZVxnAg9XQW1HYqZnaakTnYrmKPmUsdM7/JYBxR5RRkpk60MLs5cbeS7XEKkkdbFlmB9hRbKuMyHEC/FK+Dg5BJPuaGapz8VqsLih59GxZ9HKxkN3LggERYzVwq0ksBOOB+A73ixncpmTwimg5PUqG3Rx5SFmZQbGxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBAoEWw2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBAoEWw2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053B9C4CEEB;
	Thu, 26 Jun 2025 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750938611;
	bh=FPzV0/u+EFmGaVog++EkyHi12RIjqXeGCuDMfKSnAYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hBAoEWw2k52iRAOxd5jMsArGeXm6Jc3hqPaz4jmpo8hq9LEdIOgHGaaLnnYFBwlUJ
	 dT3cw6H9w7iO0vxgeeH8ZC5+3bN78D+x6nq97H4wSAVPlFmL5KZ2Zw+fW20y7Vfa4h
	 OQ/sJH2iW73gZoKfJ5SDGn8HT3C2v6giZNnuETgQcUOeZblHIYbt3sc2xM5LfIf7Zd
	 H2NlQTiEEYMyFxCP1zafW/8sE8ikwDJWS31mz1pIRdZ3Q8jOOxjddZ3v85bq4KLF3h
	 uxdZQAAatR+bcYDXdK5cUNWd18nXzH6M2Nfqqpp0d+MnXeYJFtLp5/mrZP4EEEQNgJ
	 uFNbyCy+SHqVw==
Date: Thu, 26 Jun 2025 13:50:08 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: add tracepoints for stale pinned inode state
 debug
Message-ID: <zdxrlkeryhpxtk2w7duvygv7xvnpjb6ejpuwgu54bj6bj5vexo@ip5vzi7vfsqd>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <teU1fpPiecBrF7WMEg_Gw3H8ayghIxK5cTNorqnWA0Y0NTeHsCQQ5AZ9FrjiYCNukDguR2OYgqVNjyX-dFGsjw==@protonmail.internalid>
 <20250625224957.1436116-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-5-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:48:57AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I needed more insight into how stale inodes were getting stuck on
> the AIL after a forced shutdown when running fsstress. These are the
> tracepoints I added for that purpose.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I actually used something similar recently, (although temporarily with
trace_printk), I can see how useful those can be.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_inode_item.c | 5 ++++-
>  fs/xfs/xfs_log_cil.c    | 4 +++-
>  fs/xfs/xfs_trace.h      | 9 ++++++++-
>  fs/xfs/xfs_trans.c      | 4 +++-
>  4 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index c6cb0b6b9e46..285e27ff89e2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -758,11 +758,14 @@ xfs_inode_item_push(
>  		 * completed and items removed from the AIL before the next push
>  		 * attempt.
>  		 */
> +		trace_xfs_inode_push_stale(ip, _RET_IP_);
>  		return XFS_ITEM_PINNED;
>  	}
> 
> -	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
> +	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp)) {
> +		trace_xfs_inode_push_pinned(ip, _RET_IP_);
>  		return XFS_ITEM_PINNED;
> +	}
> 
>  	if (xfs_iflags_test(ip, XFS_IFLUSHING))
>  		return XFS_ITEM_FLUSHING;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index f66d2d430e4f..a80cb6b9969a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -793,8 +793,10 @@ xlog_cil_ail_insert(
>  		struct xfs_log_item	*lip = lv->lv_item;
>  		xfs_lsn_t		item_lsn;
> 
> -		if (aborted)
> +		if (aborted) {
> +			trace_xlog_ail_insert_abort(lip);
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> +		}
> 
>  		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
>  			lip->li_ops->iop_release(lip);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 9f0d6bc966b7..ba45d801df1c 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1146,6 +1146,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
>  		__field(xfs_ino_t, ino)
>  		__field(int, count)
>  		__field(int, pincount)
> +		__field(unsigned long, iflags)
>  		__field(unsigned long, caller_ip)
>  	),
>  	TP_fast_assign(
> @@ -1153,13 +1154,15 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
>  		__entry->ino = ip->i_ino;
>  		__entry->count = atomic_read(&VFS_I(ip)->i_count);
>  		__entry->pincount = atomic_read(&ip->i_pincount);
> +		__entry->iflags = ip->i_flags;
>  		__entry->caller_ip = caller_ip;
>  	),
> -	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d caller %pS",
> +	TP_printk("dev %d:%d ino 0x%llx count %d pincount %d iflags 0x%lx caller %pS",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->ino,
>  		  __entry->count,
>  		  __entry->pincount,
> +		  __entry->iflags,
>  		  (char *)__entry->caller_ip)
>  )
> 
> @@ -1249,6 +1252,8 @@ DEFINE_IREF_EVENT(xfs_irele);
>  DEFINE_IREF_EVENT(xfs_inode_pin);
>  DEFINE_IREF_EVENT(xfs_inode_unpin);
>  DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
> +DEFINE_IREF_EVENT(xfs_inode_push_pinned);
> +DEFINE_IREF_EVENT(xfs_inode_push_stale);
> 
>  DECLARE_EVENT_CLASS(xfs_namespace_class,
>  	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name),
> @@ -1653,6 +1658,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_mark);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_skip);
>  DEFINE_LOG_ITEM_EVENT(xfs_cil_whiteout_unpin);
> +DEFINE_LOG_ITEM_EVENT(xlog_ail_insert_abort);
> +DEFINE_LOG_ITEM_EVENT(xfs_trans_free_abort);
> 
>  DECLARE_EVENT_CLASS(xfs_ail_class,
>  	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index c6657072361a..b4a07af513ba 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -742,8 +742,10 @@ xfs_trans_free_items(
> 
>  	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
>  		xfs_trans_del_item(lip);
> -		if (abort)
> +		if (abort) {
> +			trace_xfs_trans_free_abort(lip);
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> +		}
>  		if (lip->li_ops->iop_release)
>  			lip->li_ops->iop_release(lip);
>  	}
> --
> 2.45.2
> 
> 
