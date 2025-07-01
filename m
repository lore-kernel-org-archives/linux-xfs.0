Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881B927780E;
	Tue,  1 Jul 2025 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751381601; cv=none; b=HZAulLUz9RkgBResfMTMxGYhjL2fk4Q4EXk2XtuEnz6A87Q9T/KAogGWKb42S2XyerpslhOrUn2hsEofc52qKV3XW7qpCL9FKDgOTvpgtZuCcOpl58XQQvRgKCt3svMt1naBK+t/cXYqnprKzxxjITia7eubeZp0R5OjH1KPQWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751381601; c=relaxed/simple;
	bh=XpGplpmeH4ucYWW5wTnXWbAFGKy6kNmM0V6V4qHCLT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxPRGNXyfhSIFuFFESrXkg8bgkPDI5diXjbqbJhA5nugT621JXqxze+g/ZFdZsn4Adai41Q3KlJk/BTzIyd+Q2pZPYSbM+V1e2qdqgnTD7stKRE9eCowUJeXdSnc6MiFEHta4NUfGCmFTxzz4GTG6EXE8MOnujMvtuli4W4gHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hb3yGqmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hb3yGqmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4A5C4CEEB;
	Tue,  1 Jul 2025 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751381600;
	bh=XpGplpmeH4ucYWW5wTnXWbAFGKy6kNmM0V6V4qHCLT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hb3yGqmdNqLVtfekHK7xXogGF0iBoEMCN72VSMD33iz5TyBdNgoFPTiTb1LaWd5O+
	 2oANMSNlLnoJC8trVOBWqievtH0D6flRTNLcbH2JHwsU4GYPlmWDGaf7oQJQFv760t
	 DjhEoVJ9WnollCfEojkGk6Y97vlHPElFOjk6LxzzFc5GDFn8Lzd751wq8KttOZ8vSe
	 WXsHwTKNVW/l0+Uynd6olQ936fdc5l1iD2NXFs8cs/Gbx6RQz4E+tEzKQwa0kXnpQM
	 VwNp8YlVUmVwcuhD5ICmS21WsgLIb+hQRYYyOZICCZfy+ywcJ0mPb1rcxAUwDzMcP4
	 NmMFZLpfBzsFw==
Date: Tue, 1 Jul 2025 07:53:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 6/6] xfs: refactor xfs_btree_diff_two_ptrs() to take
 advantage of cmp_int()
Message-ID: <20250701145319.GB10009@frogsfrogsfrogs>
References: <20250612102455.63024-1-pchelkin@ispras.ru>
 <20250612102455.63024-7-pchelkin@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612102455.63024-7-pchelkin@ispras.ru>

On Thu, Jun 12, 2025 at 01:24:50PM +0300, Fedor Pchelkin wrote:
> Use cmp_int() to yield the result of a three-way-comparison instead of
> performing subtractions with extra casts.
> 
> Found by Linux Verification Center (linuxtesting.org).
> 
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  fs/xfs/libxfs/xfs_btree.c | 6 +++---
>  fs/xfs/libxfs/xfs_btree.h | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index d3591728998e..9a227b6b3296 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -5353,15 +5353,15 @@ xfs_btree_count_blocks(
>  }
>  
>  /* Compare two btree pointers. */
> -int64_t
> +int
>  xfs_btree_diff_two_ptrs(

I'm surprised you didn't rename the diff.*ptr functions too -- there's
no inherent meaning in the difference between two pointers, but it is
useful to compare them.  Renaming would make the sole callsite much
clearer in purpose:

	if (xfs_btree_cmp_two_ptrs(cur, pp, sibling) != 0)
		xchk_btree_set_corrupt(bs->sc, cur, level);

Other than that, the logic changes look correct to me.

--D

>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_ptr	*a,
>  	const union xfs_btree_ptr	*b)
>  {
>  	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
> -		return (int64_t)be64_to_cpu(a->l) - be64_to_cpu(b->l);
> -	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
> +		return cmp_int(be64_to_cpu(a->l), be64_to_cpu(b->l));
> +	return cmp_int(be32_to_cpu(a->s), be32_to_cpu(b->s));
>  }
>  
>  struct xfs_btree_has_records {
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 1bf20d509ac9..23598f287af5 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -519,9 +519,9 @@ struct xfs_btree_block *xfs_btree_get_block(struct xfs_btree_cur *cur,
>  		int level, struct xfs_buf **bpp);
>  bool xfs_btree_ptr_is_null(struct xfs_btree_cur *cur,
>  		const union xfs_btree_ptr *ptr);
> -int64_t xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
> -				const union xfs_btree_ptr *a,
> -				const union xfs_btree_ptr *b);
> +int xfs_btree_diff_two_ptrs(struct xfs_btree_cur *cur,
> +			    const union xfs_btree_ptr *a,
> +			    const union xfs_btree_ptr *b);
>  void xfs_btree_get_sibling(struct xfs_btree_cur *cur,
>  			   struct xfs_btree_block *block,
>  			   union xfs_btree_ptr *ptr, int lr);
> -- 
> 2.49.0
> 
> 
