Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A1218AD1
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744237380; cv=none; b=nVTdhleTu48N7/of666xviNyg0YsPuA9OIUaXcfCwfocP2Q5hxbFm1S3UDFuuWE0Oj4Lx5lbdZIlFHlmuMrGkoP05wVFnmDfPBbnb9U3vN1nFMV9HiyPTfh+YWbIfHa7C8TZ/gEKzNTTdFMTyYt89hb5cVoHw4hOcCCfWu4Kq80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744237380; c=relaxed/simple;
	bh=IRngZFeebOcMkuOOR6fRlLCFSavilG+UFvUM5fqCysU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Npc4ItQXV/p8nm427gUc1rkNvYBCar0nBFABBqmYnbPaMaCL2DzzAHwghHcPaoHYHeQw0ifyYuo2iqFCiMcRtwCRg9VhNduQd6mtf9j0QAGY4bPjVV/kH6LAd9pQYKmf69nAHBFf9FkFDBiPBld97+a+Cl18+D4HjLsu4hvG0JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzTVCkv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzTVCkv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B4DC4CEE2;
	Wed,  9 Apr 2025 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744237379;
	bh=IRngZFeebOcMkuOOR6fRlLCFSavilG+UFvUM5fqCysU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kzTVCkv0ARqc6oJhy2zIdcx9ZSZV4cTAge1Md/0kiS9iB1vrlmeF84pHltVouMONR
	 TfoZwOK8GGauqCviVRVA2n6iCegllLUKJmZc3XXHBJhUjsljUPFLmiKLvHxYTWhWwp
	 7sv1CYEYSiCGGDrM7luJvzMwn3XxFLFDP4sjMkscZf3A7ZFOIlf5KRnoQGt6EMVb1l
	 qcYFX7CayItQgeht4Cf7PXm1HqJ/VM4N8hXwtrXFwQ9ITqP5uHDm1aGiSEcDrE0DLJ
	 yMpIWrod53qv1q5dL3l/ALFeA9XFruZxAT4I9UesoeT5aTRguppH+HbvBh/R0p6qQJ
	 +x9e7q2aak0SQ==
Date: Wed, 9 Apr 2025 15:22:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/45] xfs_io: correctly report RGs with internal rt dev
 in bmap output
Message-ID: <20250409222258.GU6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-38-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-38-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:40AM +0200, Christoph Hellwig wrote:
> Apply the proper offset.  Somehow this made gcc complain about
> possible overflowing abuf, so increase the size for that as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  io/bmap.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/io/bmap.c b/io/bmap.c
> index b2f6b4905285..944f658b35f0 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -257,18 +257,21 @@ bmap_f(
>  #define	FLG_BSW		0000010	/* Not on begin of stripe width */
>  #define	FLG_ESW		0000001	/* Not on end   of stripe width */
>  		int	agno;
> -		off_t	agoff, bbperag;
> +		off_t	agoff, bbperag, bstart;
>  		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
> -		char	rbuf[32], bbuf[32], abuf[32];
> +		char	rbuf[32], bbuf[32], abuf[64];
>  		int	sunit, swidth;
>  
>  		foff_w = boff_w = aoff_w = MINRANGE_WIDTH;
>  		tot_w = MINTOT_WIDTH;
>  		if (is_rt) {
> +			bstart = fsgeo.rtstart *
> +				(fsgeo.blocksize / BBSIZE);
>  			bbperag = bytes_per_rtgroup(&fsgeo) / BBSIZE;
>  			sunit = 0;
>  			swidth = 0;
>  		} else {
> +			bstart = 0;
>  			bbperag = (off_t)fsgeo.agblocks *
>  				  (off_t)fsgeo.blocksize / BBSIZE;
>  			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
> @@ -298,9 +301,11 @@ bmap_f(
>  						map[i + 1].bmv_length - 1LL));
>  				boff_w = max(boff_w, strlen(bbuf));
>  				if (bbperag > 0) {
> -					agno = map[i + 1].bmv_block / bbperag;
> -					agoff = map[i + 1].bmv_block -
> -							(agno * bbperag);
> +					off_t bno;
> +
> +					bno = map[i + 1].bmv_block - bstart;
> +					agno = bno / bbperag;
> +					agoff = bno % bbperag;
>  					snprintf(abuf, sizeof(abuf),
>  						"(%lld..%lld)",
>  						(long long)agoff,
> @@ -387,9 +392,11 @@ bmap_f(
>  				printf("%4d: %-*s %-*s", i, foff_w, rbuf,
>  					boff_w, bbuf);
>  				if (bbperag > 0) {
> -					agno = map[i + 1].bmv_block / bbperag;
> -					agoff = map[i + 1].bmv_block -
> -							(agno * bbperag);
> +					off_t bno;
> +
> +					bno = map[i + 1].bmv_block - bstart;
> +					agno = bno / bbperag;
> +					agoff = bno % bbperag;
>  					snprintf(abuf, sizeof(abuf),
>  						"(%lld..%lld)",
>  						(long long)agoff,
> -- 
> 2.47.2
> 
> 
