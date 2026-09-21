Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CBC33E37A
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 03:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789962525; cv=none; b=bxdWd0WP8G/7NhmHC7uogXy2+UH4T4eiDv1VL3ZE4cNQYoE0Y8EbReSvaunFWR7x0keLVRg8XB0U5IAPFCa+I3Y4htIx5qnTfSG9F91nsRtWKb5UbEZyNrHkf6AQgPMiuyvSwAs+Ut5Spko8A6FpamvQyfzmboG+lIRKvZettOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789962525; c=relaxed/simple;
	bh=Z0DXPKp3e6m5V6VTG01bU7ScqqT0WXTzxgWGRbRutmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UhgHZSYiVdm0WNm3MGXNge8U8qGEWSy3mu6JvoTHqXkD5Sw9Dc4zWuGZPGx1ItULDnw0A6+drr6Iq7KxfCjF6bxInezNb1pe+NnYHeXq72R+UMBSdu6IVIKnzn5CFHxQ1gSML8llDuMlrT2+eXOFuDuRBdSdtxuHdE45kEhXUZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNrCaWZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNrCaWZ1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 544961F000FF;
	Mon, 21 Sep 2026 03:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789962523;
	bh=tudlUQulpcDVukUUgk5HnA09LjXI3z06uQKpcHQNYok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JNrCaWZ18DdHNZlUEpsLEwPWeZtEmZHKZpy0ql9Jx42OoYra9GeMm1L5pf+wH44j9
	 EQA7LRO63STmP3MDVeDKuvw522wk+XM9pStDQOs23UYVsuaaAcwE+6JXXBiCIpygpj
	 rHx0kiEjx/ef53KHkZPdMbcE9QezxJxDNGp75bgVrUcHWc3LkDtNhUSVoOZlx5B5mZ
	 dpjgnFGTJdxCRiPnXNDL64Yz8Exf+0utGRm3c1P5c2+NfPA1LwgYgi3yZaJL6tDikS
	 jH4EOLFwcw+r3ocVwE1e4Wp6jh1RCOGH0X0JQJ2P+USKPrPVHg6xPNb6RiP4zRewpV
	 Vazmf6aNf0bwA==
Date: Sun, 20 Sep 2026 20:48:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH for-next v2] xfs: fix NOFS state corruption in btree
 split worker
Message-ID: <20260921034842.GH2705364@frogsfrogsfrogs>
References: <20260920073014.2843814-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920073014.2843814-1-wangkefeng.wang@huawei.com>

On Sun, Sep 20, 2026 at 03:30:14PM +0800, Kefeng Wang wrote:
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
> ---
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
> +	unsigned long		nofs_flags;

Might want to call this old_pflags?  We're adding NOFS, which means that
this variable is just the old value.

Also, doesn't memalloc_nofs_save return an unsigned int?

--D

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
