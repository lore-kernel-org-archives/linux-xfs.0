Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99551E4BE;
	Mon, 27 Apr 2026 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777281509; cv=none; b=sxxn2UYu5uqsr64F76xgh49oublyNJMrlbdPvsr3a0PBJRCbyIRHfAakcmfN8CP2aJNI43P2EaYKqrBjckrAqU8GarAmNiyRinVsJ/dccFQLhj0qhdBow6OhkjF+bK5Tl8CRWz3i52rI1taOYXnmvK6eiKxYPhN11A2OeD4LgOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777281509; c=relaxed/simple;
	bh=gdPOygJQcdhwkXiNTM+hJwzII1oH2iN1Avurh1yipic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gxv66TRxT0brpIcz38AayltFd23e/morZkSUpkzbcPAm5fQOWr/OYISjiXraaejODknE543zgvksury/b6kYPlHhUBuH+O/2e6XkeHnCquoEZHj36o1y25hoDD7ubbhL+gdaETdXBKNqvSApd8rfIJc7YMVR3fPxMpk/gPRAJp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovSMLHYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovSMLHYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA766C19425;
	Mon, 27 Apr 2026 09:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777281508;
	bh=gdPOygJQcdhwkXiNTM+hJwzII1oH2iN1Avurh1yipic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ovSMLHYIWW4/LRrNff/7pdKgYfm0M4f7+gGF2/qb6OL3faIum2hYd+EHjSizs2glj
	 ViY/rR7vPxjNYMPieWBo3VnTTTzX7myNEsHxG88NQyIXq2G5TDOxU7t3Dd78B4prHQ
	 R6QuOoFPhxGaxhOYy1GzuzF0JZ7iPinxsxJZGriuF5APN8HsLGbVxhCViEVbOYcH0y
	 DGCtuN5zArAi9/2qnxjQu8Nsy3VudgvlhJXmsryKw7DIS7Qhac+IhJZnRtn7txnMu2
	 sBcgEx5C9HzBNtv+IJuI5hXwbSC8kZyAXX70YRHR53gZHenaLOFeQv1TCT3UFjy7qC
	 eCYE5ix9TOLwQ==
Date: Mon, 27 Apr 2026 11:18:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Ravi Singh <ravising@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	djwong@kernel.org, dchinner@redhat.com, esandeen@redhat.com
Subject: Re: [PATCH v3] xfs: flush delalloc blocks on ENOSPC in
 xfs_trans_alloc_icreate
Message-ID: <ae8p1wX_EXPLuBrC@nidhogg.toxiclabs.cc>
References: <20260422073959.10056-1-ravising@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422073959.10056-1-ravising@redhat.com>

On Wed, Apr 22, 2026 at 07:39:59AM +0000, Ravi Singh wrote:
> xfs_trans_alloc_icreate() can fail with ENOSPC when delalloc
> reservations have consumed most of the available block count
> (fdblocks).  xfs_trans_alloc() already retries internally with
> xfs_blockgc_flush_all(), but that only trims post-EOF speculative
> preallocation and may not free enough space for the transaction
> reservation.
> 
> Add a retry with xfs_flush_inodes() when xfs_trans_alloc() returns
> ENOSPC.  This forces writeback of all dirty inodes via
> sync_inodes_sb(), converting delalloc reservations to real
> allocations and freeing the over-reserved portion back to fdblocks.
> 
> This fixes all callers of xfs_trans_alloc_icreate() and removes
> the existing caller-level retry from xfs_create(), which is now
> handled centrally.
> 
> Signed-off-by: Ravi Singh <ravising@redhat.com>
> ---

Looks good
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> v3:
>  - Moved comment to sit above the flush+retry code (Christoph)
> 
> v2:
>  - Moved xfs_flush_inodes() retry into xfs_trans_alloc_icreate()
>    instead of xfs_symlink() (Christoph)
>  - Removed caller-level retry from xfs_create()
>  - All callers now covered: xfs_create, xfs_symlink,
>    xfs_create_tmpfile, xcrep_tempfile_create
> 
> 
>  fs/xfs/xfs_inode.c |  6 ------
>  fs/xfs/xfs_trans.c | 11 +++++++++++
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index beaa26ec62da..9978ac1422fc 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -699,12 +699,6 @@ xfs_create(
>  	 */
>  	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
>  			&tp);
> -	if (error == -ENOSPC) {
> -		/* flush outstanding delalloc blocks and retry */
> -		xfs_flush_inodes(mp);
> -		error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
> -				resblks, &tp);
> -	}
>  	if (error)
>  		goto out_parent;
>  
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index bcc470f56e46..148cc32449c1 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1199,10 +1199,21 @@ xfs_trans_alloc_icreate(
>  {
>  	struct xfs_trans	*tp;
>  	bool			retried = false;
> +	bool			flushed = false;
>  	int			error;
>  
>  retry:
>  	error = xfs_trans_alloc(mp, resv, dblocks, 0, 0, &tp);
> +	if (error == -ENOSPC && !flushed) {
> +		/*
> +		 * Flush all delalloc blocks to reclaim space from speculative
> +		 * preallocation.  This is similar to the quota retry below
> +		 * but targets FS-wide ENOSPC.
> +		 */
> +		xfs_flush_inodes(mp);
> +		flushed = true;
> +		goto retry;
> +	}
>  	if (error)
>  		return error;
>  
> -- 
> 2.53.0
> 
> 
