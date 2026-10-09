Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082763E6392;
	Fri,  9 Oct 2026 12:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791547457; cv=none; b=gMFLxTMlyKonA1Oxy0KkjxcgX5gtNMB1uo8tPyjkbJ4/D3uoUSuKqFXgjOAeOvdsTiI2uHG0+cYw1g7vtqoss8/mh4CtQBikzeLUHfX7OdRXy+zU4ddHKXkOLhlfOFWBvA4Vd6auNp3ZbOyNO4KeBiU5uYhJenQznUaXqWMKh48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791547457; c=relaxed/simple;
	bh=lORZY4Mhn05+lNoB0gKe3EAnys6S7IQwNP3y7S0GEUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtVgDxgD2Z+AyqYagaB8iKpN8jsiQgHoBzmCC03wnmzBcmLZsXHSmdIydA9MoPmGDWsnIPo0TuhTt6LsAzVoo0sL3ZSiRW2bzq/B1gb7ehMHlERoXZMlaBacPvlT9H2QbUXJqQBc38fBW1pLhMHRPItcZtY/O0RsQAy21Fb7rjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iMAfsArL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iMAfsArL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DF21F000FF;
	Fri,  9 Oct 2026 12:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547447;
	bh=BljgmLXwIPPpLea6jl82aMNQWz9xy5hCV7ufsBKzDQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iMAfsArLtoXA43Y62BuMkMte0qrPprWzB+tZ9TgKC1rx9tbHiGZQ6wMxx8QEYCPVf
	 +pfe50pSmcsqCthSB6Si7cKbBiyQbSIdT4iEWLX4vnKdQwHT6TgxwnD4bRDr+ihHtp
	 LDwSstov2B6NYr7CZhgmaKP4M1t1gOxmb5CcsE5qQMSM3Sne59NzGTMzbL2yLim62l
	 opQPuufEI8p6R0hNwt/clKNjj6fkIRfyy4tpUrUYWHbZcudkYy7u6wnvAW/1o0N4AH
	 uF+o0NRBkz446bnd/NwJgLIXm9jC/3NkCpyQ/m5eICspM4ZTcTVex2pONUUe02SiAs
	 F8RcNqQW22cuA==
Date: Fri, 9 Oct 2026 14:04:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds cursor access from rtrmap level
 off-by-one
Message-ID: <asjVgZJijA4r1MlV@cronus.toxiclabs.cc>
References: <20261009114503.3669142-1-bsdhenrymartin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009114503.3669142-1-bsdhenrymartin@gmail.com>

On Fri, Oct 09, 2026 at 07:45:03PM +0800, Henry Martin wrote:
> m_rtrmap_maxlevels includes the inode root level, so a valid on-disk
> bb_level is strictly less than m_rtrmap_maxlevels.  Both
> xfs_rtrmapbt_verify() and xfs_iformat_rtrmap() compare with ">"
> instead of ">=", letting a forged block with level == maxlevels pass
> validation.

So you need a maliciously crafted filesystem image and enough privileges
to be able to mount it.

> The cursor is then sized for maxlevels entries while
> bc_nlevels is set to level + 1, so the generic btree code indexes one
> element past bc_levels[] - an out-of-bounds read/write on the cursor
> allocation.
> 
> xfs_rtrmapbt_mem_verify() in the same file (from commit
> 4a61f12eb1195 "xfs: create a shadow rmap btree during realtime rmap
> repair") already uses ">=".
> 
> This vulnerability was discovered by Tencent CodeBuddy Security.

What is the "vulnerability" you are claiming here? How can this be
exploited? For what you described, it requires a crafted filesystem
image, which should require a privileged user to mount, so while this is
a bug, calling it a vulnerability is a big stretch.
So, giving you claimed it to be a vulnerability, how can it be
exploited by a non-privileged user? Where is the reproducer? You can
even share it off-list if you prefer.

> 
> Cc: stable@vger.kernel.org
> Fixes: fc6856c6ff086 ("xfs: introduce realtime rmap btree ondisk definitions")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_rtrmap_btree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> index a15e460a1ec7..6833c924a383 100644
> --- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> @@ -256,7 +256,7 @@ xfs_rtrmapbt_verify(
>  	if (fa)
>  		return fa;
>  	level = be16_to_cpu(block->bb_level);
> -	if (level > mp->m_rtrmap_maxlevels)
> +	if (level >= mp->m_rtrmap_maxlevels)
>  		return __this_address;
> 
>  	return xfs_btree_fsblock_verify(bp, mp->m_rtrmap_mxr[level != 0]);
> @@ -888,7 +888,7 @@ xfs_iformat_rtrmap(
>  	numrecs = be16_to_cpu(dfp->bb_numrecs);
>  	level = be16_to_cpu(dfp->bb_level);
> 
> -	if (level > mp->m_rtrmap_maxlevels ||
> +	if (level >= mp->m_rtrmap_maxlevels ||
>  	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
>  		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
>  		return -EFSCORRUPTED;
> --
> 2.43.7
> 
> 
