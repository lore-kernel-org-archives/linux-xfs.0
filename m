Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216133DA5BA
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 10:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985967; cv=none; b=UKrQOMcE5yjcU8tPnbJpTKiZIz0QAVhm0siDdQHqTVOk08FvHb5LTvf6jl7YYnT9fJgteFqSu77uFhvPuAeBRFxuccbdeRc4p6u+Ls3xXZasnKzQo+0o1lsmcJkxVtK/adRsXKqZB9bYCnSmCUL8WaUiZDcR3RCrUabfayrzVJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985967; c=relaxed/simple;
	bh=HTDvIhVZtl8PsbKiyzZp7QHfRBTXkIbdr8ZpCyW1FI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwoc/272rRmQOkMJobYJNEodkIkcmwrR+eegnCo5RlIrkedjrVqOxOAL8NNx5ECydNIgTvkfsZpWDVYA1j/86Cf7BrrrjiPEunGuxW6fga/w5i0grUDYz4OkWkfRn7hwFeXo4g063XHoy5nsm/D6WyprwgqH5C4k+X8zFUR0e88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QWZgHtto; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QWZgHtto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9AB1F000FF;
	Mon, 21 Sep 2026 10:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789985960;
	bh=LOlL1F/RXL1Y+h6T0kH0C9COB6+6JaqyJ5gaeDR7Mtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QWZgHttoPIQh7X0bzty1zmBgh0mDSHdX5GoyJBIAB86qdtV0RyXehG9Zjni9qgTkg
	 tQJ8GuNW7siVaRZPhf5KdFpyGoVKsPufrKhPCNI6OeAFwUUvCz9WCahK59hV7x15k9
	 /L8jq/uLwPfVM9QsuinYu6imy+90s4kBhqaXCH5hAaTSwOLMqfkUMc6QBEt3vUPp1+
	 ZjVcbQOl2/SE31JsSfMImCd1Yo9J6Ms302jj54HkAnUbcIhSWdccRb6hpdWzgfdwih
	 PHlXxNLUB9zG3VZo3kcCcpN3ByLlAuQVKd+Qtzs34Lg5wzB4drK9rYGkedTkQMyXZW
	 +mpn3nJNdotEw==
Date: Mon, 21 Sep 2026 12:19:16 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <dchinner@redhat.com>, 
	Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH for-next v3] xfs: fix NOFS state corruption in btree
 split worker
Message-ID: <arEEdRBtMBxoPCEV@nidhogg.toxiclabs.cc>
References: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921071030.3214538-1-wangkefeng.wang@huawei.com>

On Mon, Sep 21, 2026 at 03:10:30PM +0800, Kefeng Wang wrote:
> xfs_btree_split_worker() calls xfs_trans_set_context() and
> xfs_trans_clear_context() on the caller's transaction, overwriting
> tp->t_pflags with the worker's NOFS state. When the caller already has
> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> the caller's NOFS protection.
> 
> Use memalloc_nofs_save/restore with a local variable instead so
> tp->t_pflags is never touched.
> 
> Closes: https://sashiko.dev/#/patchset/20260902131653.1338227-1-wangkefeng.wang@huawei.com
> Fixes: 756b1c343333 ("xfs: use current->journal_info for detecting transaction recursion")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> v3:
> - Using correct unsigned int type for nofs_flags, per Darrick
> 
> v2:
> - Send bugfix only based on xfs-linux/for-next, suggested by Carlos[1]
>   https://lore.kernel.org/linux-xfs/aqqGiu9W0G7dquoY@nidhogg.toxiclabs.cc/
> v1:
> - https://lore.kernel.org/linux-xfs/20260911104227.2028941-1-wangkefeng.wang@huawei.com/
> 
>  fs/xfs/libxfs/xfs_btree.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 60ef7f08b1d3..239741132914 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -3010,6 +3010,7 @@ xfs_btree_split_worker(
>  						struct xfs_btree_split_args, work);
>  	unsigned long		pflags;
>  	unsigned long		new_pflags = 0;
> +	unsigned int		nofs_flags;
>  
>  	/*
>  	 * we are in a transaction context here, but may also be doing work
> @@ -3021,12 +3022,17 @@ xfs_btree_split_worker(
>  		new_pflags |= PF_MEMALLOC | PF_KSWAPD;
>  
>  	current_set_flags_nested(&pflags, new_pflags);
> -	xfs_trans_set_context(args->cur->bc_tp);
> +
> +	/*
> +	 * Don't use xfs_trans_set_context() here: it would overwrite the
> +	 * caller's saved NOFS state in tp->t_pflags. Use a local scope.
> +	 */
> +	nofs_flags = memalloc_nofs_save();
>  
>  	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
>  					 args->key, args->curp, args->stat);
>  
> -	xfs_trans_clear_context(args->cur->bc_tp);
> +	memalloc_nofs_restore(nofs_flags);
>  	current_restore_flags_nested(&pflags, new_pflags);
>  
>  	/*
> -- 
> 2.55.0
> 
> 
