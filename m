Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34993A23
	for <linux-xfs@vger.kernel.org>; Fri, 19 Jan 2024 00:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705625532; cv=none; b=pOH/ylwidxrFpeYrKqe60wUYYVaDqBdPySy0cVQVZdxnfF4/5r3H6fcNXhBNrywhm1JB8OsqioJGDOwXOmOg6j3Pfi8byxrkx1sRQ3NGNjqEsbtLJfBukOeSw5DPbamEQaANzn7GDp+rsRa6g+IifkaWM140U0c/VyUYlfYGxaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705625532; c=relaxed/simple;
	bh=3w17LugFdSzUHQ3RR1rCxmfhElgZLX6v6gvtqwdR6MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRKhPlomJNfcTpui3K7w/qsNyMOmClabmk50A3Dct9ptRnLPSfPvbJAxM0rVmSDsEz86AD3YOel9Ud7tfckl5Zz/ACnXXpUzYzUjpMC7we5U18t6Y43TYie9rvbXlh9g5mrJiQBn5pCyZxlcAw8dlp3O30InN4rT2D1hPBZREFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFMQPorI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFMQPorI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAFDC433C7;
	Fri, 19 Jan 2024 00:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705625531;
	bh=3w17LugFdSzUHQ3RR1rCxmfhElgZLX6v6gvtqwdR6MY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nFMQPorIPUbIxWv8XbX1uBprLU26fn4z+CbG21CAcfQZIUeRBplSOhQMFcL4XRtIq
	 9zC0UtSgBZRxRcrPWSdPu/vEMff0mEUrg2cuqzjlnec0VGNJ2usjif2QN6M1jZ1R3h
	 32pXNME5EvokjIRu4oS2o/PEuI3emoRjthd4xg3XA6/+180NsIIFAnRtCkchcqGZfJ
	 kXCawN4QAoVmwE50Yxi9kxLoYMfhV8NhCwwv+6C3HK5YRTJdH2nzDBpugBmlFi/Zn0
	 QWiO8dsJssUkAMprflSVeZvWpzD6QAezfjsGIDCtmGyjeGQ6eMqds1p0j4JPoRXzsc
	 NXqbUcmJ9c3Mg==
Date: Thu, 18 Jan 2024 16:52:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 11/12] xfs: clean up remaining GFP_NOFS users
Message-ID: <20240119005211.GO674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-12-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-12-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:49AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> These few remaining GFP_NOFS callers do not need to use GFP_NOFS at
> all. They are only called from a non-transactional context or cannot
> be accessed from memory reclaim due to other constraints. Hence they
> can just use GFP_KERNEL.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_btree_staging.c | 4 ++--
>  fs/xfs/xfs_attr_list.c            | 2 +-
>  fs/xfs/xfs_buf.c                  | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
> index 961f6b898f4b..f0c69f9bb169 100644
> --- a/fs/xfs/libxfs/xfs_btree_staging.c
> +++ b/fs/xfs/libxfs/xfs_btree_staging.c
> @@ -139,7 +139,7 @@ xfs_btree_stage_afakeroot(
>  	ASSERT(!(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE));
>  	ASSERT(cur->bc_tp == NULL);
>  
> -	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
> +	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
>  	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
>  	nops->free_block = xfs_btree_fakeroot_free_block;
> @@ -220,7 +220,7 @@ xfs_btree_stage_ifakeroot(
>  	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
>  	ASSERT(cur->bc_tp == NULL);
>  
> -	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_NOFS | __GFP_NOFAIL);
> +	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
>  	memcpy(nops, cur->bc_ops, sizeof(struct xfs_btree_ops));
>  	nops->alloc_block = xfs_btree_fakeroot_alloc_block;
>  	nops->free_block = xfs_btree_fakeroot_free_block;
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 0318d768520a..47453510c0ab 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -109,7 +109,7 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->count * sizeof(*sbuf);
> -	sbp = sbuf = kmalloc(sbsize, GFP_NOFS | __GFP_NOFAIL);
> +	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index de99368000b4..08f2fbc04db5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2008,7 +2008,7 @@ xfs_alloc_buftarg(
>  #if defined(CONFIG_FS_DAX) && defined(CONFIG_MEMORY_FAILURE)
>  	ops = &xfs_dax_holder_operations;
>  #endif
> -	btp = kzalloc(sizeof(*btp), GFP_NOFS | __GFP_NOFAIL);
> +	btp = kzalloc(sizeof(*btp), GFP_KERNEL | __GFP_NOFAIL);
>  
>  	btp->bt_mount = mp;
>  	btp->bt_bdev_handle = bdev_handle;
> -- 
> 2.43.0
> 
> 
