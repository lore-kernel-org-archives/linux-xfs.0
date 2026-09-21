Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AEB48F83B
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 14:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790000555; cv=none; b=RyEy/X/LjNc3xsyo/7vvLZ7sqFctCoS5YjREHqrK5ojEySq4MkDTSJoaNBdvnT4yOyg2WCvPt1fK1rc2KiPwJGAT2zcLyP3TSbvGkKCNNOVoXtiZcXZC02cNdblAb1LMuejharfxlymYaorO3iRQAZ6wjvnjsTW3sCBiDF3RMzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790000555; c=relaxed/simple;
	bh=1KFHnS69LpPj5W2Qn0mCz3a3ruy4mssXcAWuYji8kjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDIJtagmvAOJxcx4wrpt+RtFobKhtCXRIfPpIXpbPF8MJ8zCoweZctSizOpOJfZamqApzeXCxbhOmvNRVxHeQWdd6q3PHlj39gDaftJye31a+rhXeXukePd06OgreZIVZxPXZKqXYcdJP6dpiW+Qh/zYwr3BTbPcoidz5RVZsWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bp4LIPw2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bp4LIPw2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E750A1F000FF;
	Mon, 21 Sep 2026 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790000554;
	bh=0wWlMvpuXXe4gOQ5wOJUHNpoCo7lIvpY62v6KBlte2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bp4LIPw233yF+SsJWl9IMw+rYqT9Y57FnRdaJeIRgP1B75mErw1HhL0lWF4KqasuD
	 f1oD9+IMzOPTfkbvqHMb5XAYZoxwH0rdLy4G91x/Z6+tWsZKSadJZKmI5eYE+AvNHf
	 qIszBsplXITbxFoMum0bczHqP3ozXC/bVr1kFy5yXQIPRDGdbeoWA4csGHy57xCSAk
	 +rlJvfI8KgxDdicvK4zwBsFCm3aoBoEjKk2phvxn2fIsgcWOp7Fo4r2xQGhMFuOjil
	 AbxPGLNU3zLtCErAMXo5nMc7l7KvqdTMgrB/kPZh+j+FcVEmHZzBdcrOYm6tSviSxz
	 wqJpnEBdBElnw==
Date: Mon, 21 Sep 2026 07:22:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH for-next v3] xfs: fix NOFS state corruption in btree
 split worker
Message-ID: <20260921142233.GL6283@frogsfrogsfrogs>
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

Looks good to me now, thanks for cleaning this up
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
