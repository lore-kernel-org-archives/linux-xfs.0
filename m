Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54D723536B;
	Fri, 17 Jul 2026 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301382; cv=none; b=LjDYwo7/i/VKGVblKg21mAf0n768Qk3hZd3MezwP1x3xa74sVDD1Qf6ua77nO3spb/uMRWm7rMhUyi/xa3nmGlJ4ZOeoXrvPX5pg/B5JB1+BtfnRc7qd3Fs/Y6LPzgaU7hlxIxID2BkEL3fV5rKNz36LfrQESx9ZRCUvtG6rI3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301382; c=relaxed/simple;
	bh=U+3xHbzfHiQWkxpOj1ePT1az7IgZVmNztKI900HJoxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4RROt75ISkpsjoFMZrO5qRK7gGO42ZpBNlKFXPqgmApBbr+YprSglbHnv5Ji39c2It1JW800KubjjweKV3gyvl1P0MhjjdkJmNvEds8xGBkTLEoSji9xNPBuR7nf2lS5gSgUYXcuPS6SemmLt1epya8dnc5J0Gc+rNckSRQFL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NP1Hg7xj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NP1Hg7xj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3B7D01F000E9;
	Fri, 17 Jul 2026 15:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784301381;
	bh=uoKoK7RKIab7QSYxpHThDEmEVpiFEQtzuYS86xjd1HY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NP1Hg7xjYyHYzGJUHESNmsRbetLZMdG4oDOsmXi7V+yVP0pV5U25wsStgJAC1Ncfx
	 vZJYYRcsCcvJMLkDVS6fXio4TO+EzVF8PUu5sm6n5nXwKpSzN42TYFTxOcVIDHbGo9
	 jtueWoyPxETVNLtH5jYs/0kquWlTPgeB7GOchQzMFmLMP9aYcdaT86J2LBrrexXi08
	 gxYKEpzewtAdpPGFHb33S7UW5ya5+2TfMe6LhQpbtyj1KUVMEyCsJeVNWq6dvr+0uy
	 bnjbxCg7DNNmBxUcSb0KrIZZy3hopjdUP8H5LQ7iouCQzYb983MdriWdgqS4iPKI/G
	 XRAK/0amajkCA==
Date: Fri, 17 Jul 2026 08:16:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Cihan Karadag <cihan.cihan@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: use kmalloc_objs() instead of kmalloc() in
 xfs_da_grow_inode_int
Message-ID: <20260717151620.GS7380@frogsfrogsfrogs>
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

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
> 
