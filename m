Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6B21991D4
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 20:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759955768; cv=none; b=kfshdHR+2mON56ZpUTKWcqOJKs+wJSKP6QmzwUufVb/JtikcW4j2kTpZ3wbc23rM067pd71Wx+S0l/supNnValfS6WVzoEl4vAb15iDmeXgXsuGQ/mo/dr5bd3LfWSXxW/XNXOpPbHt/ZU7DGcJtz0AYg1HM7Q5yESM9orbURQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759955768; c=relaxed/simple;
	bh=xL8l2AD/YkSl7gehVwvUFMLcsbUIQ0l2oQGnOyn04iY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjqDr/+SH/N8WkQVPVUdoWqHtTSOB0NX+Kke9dZ/TI3zhQK+QJt0P5xH+MScgekU8frl+UX5cvtpEgiNdIdqYyUlA4pTUMMz8DD6/7A1rxk9xRmgFxYXE51MKlw+LVvCvV5jCOSpF9zPVYnKuERvNyo754S/m5YKMcDJaNYhijI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JISFVo9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JISFVo9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C20C4CEE7;
	Wed,  8 Oct 2025 20:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759955768;
	bh=xL8l2AD/YkSl7gehVwvUFMLcsbUIQ0l2oQGnOyn04iY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JISFVo9d4fmiosjl8QrOhReUnlTxIDUJmuepg5ys8HYXUmhpg3fA4XIfD5VrxDrm7
	 oYK3QpVrHSLGpxzjad3i1S0rcFuIazuMGzF3D5AKvNpLcJgwBIqEhPUd05nJNrURJI
	 H8SWhc7+nrM6A4nWftztmCL3FQvft/9wmu3qDKGokOMjlAMXsQuSuUPAoZi0wRtxl8
	 /XTmXHuZHLX9g0YJRdvyfqTdRrQa33pysnGrUqwXVUNOMeMpL7Evh7LGN/NOBQnQr5
	 3iakY1bBuKcEVBfPJLvBzKckaQKkWwRcCAQXC+ESjNKpOtncMEjqX6vbVIJABuwRO9
	 /oiXPmQN476SA==
Date: Wed, 8 Oct 2025 13:36:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, hch@lst.de, pranav.tyagi03@gmail.com,
	sandeen@redhat.com
Subject: Re: [PATCH 3/11] [PATCH] xfs: refactor cmp_two_keys routines to take
 advantage of cmp_int()
Message-ID: <20251008203607.GA6215@frogsfrogsfrogs>
References: <cover.1759941416.patch-series@thinky>
 <iklfrlwctavbl6yf2jdfs2q4me2gqtzl3rqxttxecicdt4fcyi@5nwin5x7u2tb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <iklfrlwctavbl6yf2jdfs2q4me2gqtzl3rqxttxecicdt4fcyi@5nwin5x7u2tb>

On Wed, Oct 08, 2025 at 06:55:10PM +0200, Fedor Pchelkin wrote:
> Source kernel commit: 3b583adf55c649d5ba37bcd1ca87644b0bc10b86
> 
> The net value of these functions is to determine the result of a
> three-way-comparison between operands of the same type.
> 
> Simplify the code using cmp_int() to eliminate potential errors with
> opencoded casts and subtractions. This also means we can change the return
> value type of cmp_two_keys routines from int64_t to int and make the
> interface a bit clearer.
> 
> Found by Linux Verification Center (linuxtesting.org).
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  include/platform_defs.h       |  2 ++
>  libxfs/xfs_alloc_btree.c      | 21 ++++++++-------------
>  libxfs/xfs_bmap_btree.c       | 18 +++---------------
>  libxfs/xfs_btree.h            |  2 +-
>  libxfs/xfs_ialloc_btree.c     |  6 +++---
>  libxfs/xfs_refcount_btree.c   |  6 +++---
>  libxfs/xfs_rmap_btree.c       | 29 ++++++++++++-----------------
>  libxfs/xfs_rtrefcount_btree.c |  6 +++---
>  libxfs/xfs_rtrmap_btree.c     | 29 ++++++++++++-----------------
>  repair/rcbag_btree.c          |  2 +-
>  scrub/inodes.c                |  2 --
>  11 files changed, 48 insertions(+), 75 deletions(-)
> 
> diff --git a/include/platform_defs.h b/include/platform_defs.h
> index 74a00583eb..fa66551d99 100644
> --- a/include/platform_defs.h
> +++ b/include/platform_defs.h
> @@ -294,4 +294,6 @@
>  	__a > __b ? (__a - __b) : (__b - __a);	\
>  })
>  
> +#define cmp_int(l, r)		((l > r) - (l < r))
> +
>  #endif	/* __XFS_PLATFORM_DEFS_H__ */
> diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
> index 6e7af0020b..c3c69a9de3 100644
> --- a/libxfs/xfs_alloc_btree.c
> +++ b/libxfs/xfs_alloc_btree.c
> @@ -211,7 +211,7 @@
>  	return (int64_t)be32_to_cpu(kp->ar_startblock) - rec->ar_startblock;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_bnobt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
> @@ -220,29 +220,24 @@
>  {
>  	ASSERT(!mask || mask->alloc.ar_startblock);
>  
> -	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
> -			be32_to_cpu(k2->alloc.ar_startblock);
> +	return cmp_int(be32_to_cpu(k1->alloc.ar_startblock),
> +		       be32_to_cpu(k2->alloc.ar_startblock));
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_cntbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
>  	const union xfs_btree_key	*k2,
>  	const union xfs_btree_key	*mask)
>  {
> -	int64_t				diff;
> -
>  	ASSERT(!mask || (mask->alloc.ar_blockcount &&
>  			 mask->alloc.ar_startblock));
>  
> -	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
> -		be32_to_cpu(k2->alloc.ar_blockcount);
> -	if (diff)
> -		return diff;
> -
> -	return  be32_to_cpu(k1->alloc.ar_startblock) -
> -		be32_to_cpu(k2->alloc.ar_startblock);
> +	return cmp_int(be32_to_cpu(k1->alloc.ar_blockcount),
> +		       be32_to_cpu(k2->alloc.ar_blockcount)) ?:
> +	       cmp_int(be32_to_cpu(k1->alloc.ar_startblock),
> +		       be32_to_cpu(k2->alloc.ar_startblock));
>  }
>  
>  static xfs_failaddr_t
> diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
> index 3fc23444f3..19eab66fad 100644
> --- a/libxfs/xfs_bmap_btree.c
> +++ b/libxfs/xfs_bmap_btree.c
> @@ -377,29 +377,17 @@
>  				      cur->bc_rec.b.br_startoff;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_bmbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
>  	const union xfs_btree_key	*k2,
>  	const union xfs_btree_key	*mask)
>  {
> -	uint64_t			a = be64_to_cpu(k1->bmbt.br_startoff);
> -	uint64_t			b = be64_to_cpu(k2->bmbt.br_startoff);
> -
>  	ASSERT(!mask || mask->bmbt.br_startoff);
>  
> -	/*
> -	 * Note: This routine previously casted a and b to int64 and subtracted
> -	 * them to generate a result.  This lead to problems if b was the
> -	 * "maximum" key value (all ones) being signed incorrectly, hence this
> -	 * somewhat less efficient version.
> -	 */
> -	if (a > b)
> -		return 1;
> -	if (b > a)
> -		return -1;
> -	return 0;
> +	return cmp_int(be64_to_cpu(k1->bmbt.br_startoff),
> +		       be64_to_cpu(k2->bmbt.br_startoff));
>  }
>  
>  static xfs_failaddr_t
> diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
> index e72a10ba7e..fecd9f0b93 100644
> --- a/libxfs/xfs_btree.h
> +++ b/libxfs/xfs_btree.h
> @@ -184,7 +184,7 @@
>  	 * each key field to be used in the comparison must contain a nonzero
>  	 * value.
>  	 */
> -	int64_t (*cmp_two_keys)(struct xfs_btree_cur *cur,
> +	int	(*cmp_two_keys)(struct xfs_btree_cur *cur,
>  				const union xfs_btree_key *key1,
>  				const union xfs_btree_key *key2,
>  				const union xfs_btree_key *mask);
> diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
> index d56876c5be..973ae62d39 100644
> --- a/libxfs/xfs_ialloc_btree.c
> +++ b/libxfs/xfs_ialloc_btree.c
> @@ -273,7 +273,7 @@
>  			  cur->bc_rec.i.ir_startino;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_inobt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
> @@ -282,8 +282,8 @@
>  {
>  	ASSERT(!mask || mask->inobt.ir_startino);
>  
> -	return (int64_t)be32_to_cpu(k1->inobt.ir_startino) -
> -			be32_to_cpu(k2->inobt.ir_startino);
> +	return cmp_int(be32_to_cpu(k1->inobt.ir_startino),
> +		       be32_to_cpu(k2->inobt.ir_startino));
>  }
>  
>  static xfs_failaddr_t
> diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
> index 0924ab7eb7..668c788dca 100644
> --- a/libxfs/xfs_refcount_btree.c
> +++ b/libxfs/xfs_refcount_btree.c
> @@ -187,7 +187,7 @@
>  	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_refcountbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
> @@ -196,8 +196,8 @@
>  {
>  	ASSERT(!mask || mask->refc.rc_startblock);
>  
> -	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
> -			be32_to_cpu(k2->refc.rc_startblock);
> +	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
> +		       be32_to_cpu(k2->refc.rc_startblock));
>  }
>  
>  STATIC xfs_failaddr_t
> diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
> index ea946616bf..ab207b9cc2 100644
> --- a/libxfs/xfs_rmap_btree.c
> +++ b/libxfs/xfs_rmap_btree.c
> @@ -272,7 +272,7 @@
>  	return 0;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_rmapbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
> @@ -281,36 +281,31 @@
>  {
>  	const struct xfs_rmap_key	*kp1 = &k1->rmap;
>  	const struct xfs_rmap_key	*kp2 = &k2->rmap;
> -	int64_t				d;
> -	__u64				x, y;
> +	int				d;
>  
>  	/* Doesn't make sense to mask off the physical space part */
>  	ASSERT(!mask || mask->rmap.rm_startblock);
>  
> -	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
> -		     be32_to_cpu(kp2->rm_startblock);
> +	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
> +		    be32_to_cpu(kp2->rm_startblock));
>  	if (d)
>  		return d;
>  
>  	if (!mask || mask->rmap.rm_owner) {
> -		x = be64_to_cpu(kp1->rm_owner);
> -		y = be64_to_cpu(kp2->rm_owner);
> -		if (x > y)
> -			return 1;
> -		else if (y > x)
> -			return -1;
> +		d = cmp_int(be64_to_cpu(kp1->rm_owner),
> +			    be64_to_cpu(kp2->rm_owner));
> +		if (d)
> +			return d;
>  	}
>  
>  	if (!mask || mask->rmap.rm_offset) {
>  		/* Doesn't make sense to allow offset but not owner */
>  		ASSERT(!mask || mask->rmap.rm_owner);
>  
> -		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
> -		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
> -		if (x > y)
> -			return 1;
> -		else if (y > x)
> -			return -1;
> +		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
> +			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
> +		if (d)
> +			return d;
>  	}
>  
>  	return 0;
> diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
> index 7a4eec49ca..7fbbc6387c 100644
> --- a/libxfs/xfs_rtrefcount_btree.c
> +++ b/libxfs/xfs_rtrefcount_btree.c
> @@ -168,7 +168,7 @@
>  	return (int64_t)be32_to_cpu(kp->rc_startblock) - start;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_rtrefcountbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
> @@ -177,8 +177,8 @@
>  {
>  	ASSERT(!mask || mask->refc.rc_startblock);
>  
> -	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
> -			be32_to_cpu(k2->refc.rc_startblock);
> +	return cmp_int(be32_to_cpu(k1->refc.rc_startblock),
> +		       be32_to_cpu(k2->refc.rc_startblock));
>  }
>  
>  static xfs_failaddr_t
> diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
> index 59a99bb42c..0492cd55d5 100644
> --- a/libxfs/xfs_rtrmap_btree.c
> +++ b/libxfs/xfs_rtrmap_btree.c
> @@ -214,7 +214,7 @@
>  	return 0;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  xfs_rtrmapbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,
> @@ -223,36 +223,31 @@
>  {
>  	const struct xfs_rmap_key	*kp1 = &k1->rmap;
>  	const struct xfs_rmap_key	*kp2 = &k2->rmap;
> -	int64_t				d;
> -	__u64				x, y;
> +	int				d;
>  
>  	/* Doesn't make sense to mask off the physical space part */
>  	ASSERT(!mask || mask->rmap.rm_startblock);
>  
> -	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
> -		     be32_to_cpu(kp2->rm_startblock);
> +	d = cmp_int(be32_to_cpu(kp1->rm_startblock),
> +		    be32_to_cpu(kp2->rm_startblock));
>  	if (d)
>  		return d;
>  
>  	if (!mask || mask->rmap.rm_owner) {
> -		x = be64_to_cpu(kp1->rm_owner);
> -		y = be64_to_cpu(kp2->rm_owner);
> -		if (x > y)
> -			return 1;
> -		else if (y > x)
> -			return -1;
> +		d = cmp_int(be64_to_cpu(kp1->rm_owner),
> +			    be64_to_cpu(kp2->rm_owner));
> +		if (d)
> +			return d;
>  	}
>  
>  	if (!mask || mask->rmap.rm_offset) {
>  		/* Doesn't make sense to allow offset but not owner */
>  		ASSERT(!mask || mask->rmap.rm_owner);
>  
> -		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
> -		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
> -		if (x > y)
> -			return 1;
> -		else if (y > x)
> -			return -1;
> +		d = cmp_int(offset_keymask(be64_to_cpu(kp1->rm_offset)),
> +			    offset_keymask(be64_to_cpu(kp2->rm_offset)));
> +		if (d)
> +			return d;
>  	}
>  
>  	return 0;
> diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
> index 704e66e9fb..c42a2ca0d1 100644
> --- a/repair/rcbag_btree.c
> +++ b/repair/rcbag_btree.c
> @@ -72,7 +72,7 @@
>  	return 0;
>  }
>  
> -STATIC int64_t
> +STATIC int
>  rcbagbt_cmp_two_keys(
>  	struct xfs_btree_cur		*cur,
>  	const union xfs_btree_key	*k1,

Dumb nit: You could port this one too:

@@ -81,25 +81,19 @@ rcbagbt_cmp_two_keys(
 {
 	const struct rcbag_key		*kp1 = (const struct rcbag_key *)k1;
 	const struct rcbag_key		*kp2 = (const struct rcbag_key *)k2;
+	int				d;
 
 	ASSERT(mask == NULL);
 
-	if (kp1->rbg_startblock > kp2->rbg_startblock)
-		return 1;
-	if (kp1->rbg_startblock < kp2->rbg_startblock)
-		return -1;
-
-	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
-		return 1;
-	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
-		return -1;
+	d = cmp_int(kp1->rbg_startblock, kp2->rbg_startblock);
+	if (d)
+		return d;
 
-	if (kp1->rbg_ino > kp2->rbg_ino)
-		return 1;
-	if (kp1->rbg_ino < kp2->rbg_ino)
-		return -1;
+	d = cmp_int(kp1->rbg_blockcount, kp2->rbg_blockcount);
+	if (d)
+		return d;
 
-	return 0;
+	return cmp_int(kp1->rbg_ino, kp2->rbg_ino);
 }
 
 STATIC int

--D

> diff --git a/scrub/inodes.c b/scrub/inodes.c
> index 2f3c87be79..4ed7cd9963 100644
> --- a/scrub/inodes.c
> +++ b/scrub/inodes.c
> @@ -197,8 +197,6 @@
>  	return seen_mask;
>  }
>  
> -#define cmp_int(l, r)		((l > r) - (l < r))
> -
>  /* Compare two bulkstat records by inumber. */
>  static int
>  compare_bstat(
