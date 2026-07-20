Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9A13ACA7A;
	Mon, 20 Jul 2026 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537764; cv=none; b=M07rCoITF9m2tPjwLKrc6DQbyGZ0qiofgPKD5bpJeE0ohyvdlL+Enec/RHS0ADkerPIfeTeehU6ShCNL8iGptfegtj36oTG4SlUcOu6+ySlSb1W2SviZNOJ82yXcP8fVCTZV6V/tw0NniG5xcjKzmrEisTwBFezmdabCDf/liqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537764; c=relaxed/simple;
	bh=qz9V6dg6pTASM76yY8rObTXNSEtl8GXM6fYCkQTkKtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuoI3iAJ/9EMSWwFPiIO8XKsvBputDLsZDSR8ZyWPt1hGxQtzrrI2SVDlDN27YU6cFKKgVd8Q2GUt8jJZQAjiMrzbkene0qdPhGMjPiYEytfF3FFHtFN6J25/AmhSPsu/JDZ+SbZGPe80dQxjJMuepqrBnqsBz+eFM6vEwimIcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKRXWAzg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKRXWAzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FCE1F000E9;
	Mon, 20 Jul 2026 08:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784537763;
	bh=mv1fdLPKvH3U70lXDWNoKaHFtxGhSrTMWL65y56+LRs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XKRXWAzgYeNLY7mSyy0hlM67lIwstkMCT101kubD+TSs+tyU3/NPNu1tQrRBA06Re
	 5yu45vX4JLBrkR50iSiLQOvIMo8y7yn/rylzyZoR/jupw9qadRqRihaomzkSf5hrAV
	 mGr9APmOQ4IfL4bLlw5xXrcDToKT1JULuek/L92WPqCR87+GPaFJQmjNSsWM822KoL
	 VTClHWIqOoj5kgB+xtd1nClPBowY4z5ytTKbFU+KH1u6oECzUiYP8P6Da3GEjaufZl
	 JOy61L0o6E6B31KgHbviMHcoquXjPSeNekKGI8K18PRXeM+Nzfimw/mfQ7jThkCi64
	 b/79veGKSptwA==
Date: Mon, 20 Jul 2026 10:55:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Cihan Karadag <cihan.cihan@gmail.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: use kmalloc_objs() instead of kmalloc() in
 xfs_da_grow_inode_int
Message-ID: <al3imFx2EbfalN3u@nidhogg.toxiclabs.cc>
References: <20260716214827.21188-1-cihan.cihan@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716214827.21188-1-cihan.cihan@gmail.com>

On Thu, Jul 16, 2026 at 03:48:12PM -0600, Cihan Karadag wrote:
> Convert open-coded kmalloc() multiplication to the modern kmalloc_objs()
> interface to improve type safety and prevent potential integer
> overflows.
> 
> No functional changes are intended.
> 
> Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
> Changes since v1:
> - Use kmalloc_objs() instead of kmalloc_array(), per Darrick's suggestion.
> 
>  fs/xfs/libxfs/xfs_da_btree.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 9debb95d86fa0..f190c088591bc 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -2354,8 +2354,7 @@ xfs_da_grow_inode_int(
>  		 * If we didn't get it and the block might work if fragmented,
>  		 * try without the CONTIG flag.  Loop until we get it all.
>  		 */
> -		mapp = kmalloc(sizeof(*mapp) * count,
> -				GFP_KERNEL | __GFP_NOFAIL);
> +		mapp = kmalloc_objs(*mapp, count, GFP_KERNEL | __GFP_NOFAIL);
>  		for (b = *bno, mapi = 0; b < *bno + count; ) {
>  			c = (int)(*bno + count - b);
>  			nmap = min(XFS_BMAP_MAX_NMAP, c);
> -- 
> 2.54.0
> 
