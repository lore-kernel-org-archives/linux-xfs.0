Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468BC43550C;
	Mon, 10 Aug 2026 18:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786385284; cv=none; b=IU1Jx+Fmny9iERyo8X9uPymSEfVZCbPJ7+EIYZ3nkpuJBljPThsE7P8EwF6XV2qOaUjrc/D1QetlcAAzKvSr4YNVLvvMK5bL2HhaQy1j/koJFzDr0vvkUC/WsV9DGjhewnF3fwxIeTD/3PFQDn6X/dhO9X+G5ILwbn5TmGooMNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786385284; c=relaxed/simple;
	bh=Y18nlqh1sQM/qdCpiIn6ryk7c1+zESS/FHKriNMPvk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g0q7Q/kqeKAttBnLFvBz4YDwQnDao1jjyx46aT8KHdbwmtmQAdzDgLROrcDifzYmx6GV07nlotfSjh0iCnPXivbZq/Mgj/hURoBsTablF7H3/MGbeOHQvm8XQmynzdBecuCxjJREuob1S5Tf2bnuBkBLtxgjGap87yxl1PInFko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvV4UwSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvV4UwSY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DA1A81F000E9;
	Mon, 10 Aug 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786385283;
	bh=kwNQ6TAeDMxgeF7lijXgpeDObpbDXDmYmT4BTJkOX30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fvV4UwSYFfdeZCWE5n2KqRVbIn1RzKlBNvHPZr13gQjYrx+8WIK0RNUpvzmAc9Qhj
	 c/wahruYIsqbI/G1I4MtcMRJNFHMZsY0NUwobX4Frm4oGIdGZ9tFVSNGRKtDQPwXo0
	 LIzh/y+pXc9oI3DyNj44+oOdhFw4k5JAAsTQYOgEW57Y9p+EH3SjsjkifWiKKR1dd7
	 bcuV0CzGRAcr3iX/91ZKoIW8f+xwp/lQk51TFQTl9mUT2fzVsJcvFY3WFiO7s5jAu7
	 5h8qRRigNs2eSt9WTxt9i+RPt1u6nB799LZIKj8gWoCy6TGpZoDLpjU9mJeArp5PNS
	 ZbjjEPMVS6iwg==
Date: Mon, 10 Aug 2026 11:08:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Javier Tia <javier@peridio.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 5/6] xfs: initialise args->total for parent pointer
 updates
Message-ID: <20260810180802.GS3556460@frogsfrogsfrogs>
References: <20260808234016.246054-7-floss@jetm.me>
 <20260810164312.960721-8-floss@jetm.me>
 <20260810164312.960721-13-floss@jetm.me>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810164312.960721-13-floss@jetm.me>

On Mon, Aug 10, 2026 at 10:43:18AM -0600, Javier Tia wrote:
> xfs_parent_da_args_init() builds an xfs_da_args from a zeroed
> xfs_parent_args (kmem_cache_zalloc), leaving args->total == 0.
> xfs_da_grow_inode_int() treats that field as a running block reservation
> and subtracts from it; because it is an xfs_extlen_t (uint32_t), the
> first attr-fork growth wraps it to ~0U.  That defeats the free-space
> check in xfs_alloc_space_available(), and when it coincides with an AG
> that has exactly zero available blocks the allocation is clamped to
> maxlen 0 and returns -ENOSPC, which xfs_defer_finish_noroll() escalates
> to a filesystem shutdown.
> 
> Set args->total the way the log recovery path does
> (xfs_attri_recover_work(), xfs_attr_item.c:706), in the add and replace
> paths that can grow the fork.  Removals and lookups never grow it, so
> they leave the field alone, matching that switch.
> 
> Fixes: b7c62d90c12c ("xfs: parent pointer attribute creation")
> Cc: <stable@vger.kernel.org> # v6.10
> Signed-off-by: Javier Tia <floss@jetm.me>

Much improved, thanks for the corrections.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

(As a future note: please send new revisions of patchsets as a new
thread, not a continuation of the previous revision.)

--D

> ---
>  fs/xfs/libxfs/xfs_parent.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
> index 3509cc4b2175..312f33086d53 100644
> --- a/fs/xfs/libxfs/xfs_parent.c
> +++ b/fs/xfs/libxfs/xfs_parent.c
> @@ -194,7 +194,7 @@ xfs_parent_addname(
>  	const struct xfs_name	*parent_name,
>  	struct xfs_inode	*child)
>  {
> -	int			error;
> +	int			error, local;
>  
>  	error = xfs_parent_iread_extents(tp, child);
>  	if (error)
> @@ -204,6 +204,10 @@ xfs_parent_addname(
>  	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
>  			child->i_ino, parent_name);
>  
> +	/* Growing the attr fork needs a real reservation in args->total. */
> +	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
> +	ASSERT(local);
> +
>  	return xfs_attr_setname(&ppargs->args, 0);
>  }
>  
> @@ -240,7 +244,7 @@ xfs_parent_replacename(
>  	const struct xfs_name	*new_name,
>  	struct xfs_inode	*child)
>  {
> -	int			error;
> +	int			error, local;
>  
>  	error = xfs_parent_iread_extents(tp, child);
>  	if (error)
> @@ -250,6 +254,10 @@ xfs_parent_replacename(
>  	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
>  			child->i_ino, old_name);
>  
> +	/* Growing the attr fork needs a real reservation in args->total. */
> +	ppargs->args.total = xfs_attr_calc_size(&ppargs->args, &local);
> +	ASSERT(local);
> +
>  	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
>  
>  	ppargs->args.new_name = new_name->name;
> -- 
> Javier Tia
> 
> 
