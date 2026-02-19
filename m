Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91F62F3C26
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771537336; cv=none; b=h3uc4dxNhhnOBvYA1K70zmhHWJq7wvUdQ8CpnMYu9JSjTrJH6Oa82XnCQrE1coYac27pPjlWHZXemnfPsLZTI0fxEtCtSqtt7jS7pJoMbu8bmsF2v4asHoboGon1O9Xj2f6XU+Q9JlEAHtrJuI5/wCV4TAxYUGiJAZt335NMNOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771537336; c=relaxed/simple;
	bh=faSHcVIXc4Y7cCFbbrOpep6mT/IvE4NPg+iY2xUeC/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9uxjQzrdryFTGsiFo+oAS+iFBZxfSAk1xozc+6H/hE2Go4ON3TFdv+nNxZmNHMgbUevmd+6ar64mGbuvCklxwwWR4pDk2uiRKRRPWF3+NptPxHFp6oQwaPZuk8O0hAVXEjAaBv13xdH8abBVRK3Ebiub/kOG74K2Jzj/g5bLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HB/sKGkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HB/sKGkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5263CC116D0;
	Thu, 19 Feb 2026 21:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771537336;
	bh=faSHcVIXc4Y7cCFbbrOpep6mT/IvE4NPg+iY2xUeC/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HB/sKGkgchMtfSameE+tX9BioeKPdQZzvKeG6lEEOu7e0rTSUaPQND/Zx6uAsBB34
	 QxwihNT9zWpmvzqgNK6ZvPBvLSq9xIzAl1GzCKygV1JoF1l4C7DJxMrxPPCOJQVzMA
	 4U40S+3X035F3CjhExeE6c8X+ueXwrELIc1XnNcXBDhuziYBuQ0y7hRJogqD/ncswX
	 HGkgeNsob5CVx9b+0JcbT35x5fjlVrie14Iau8eZt+L10UXL1f15HcUOZgkydP+yVK
	 +ik78idMPovdxf3tmCD1K0s2ep4qE7t/B8iuLrIi3qW+gpC2MPLdb2KjyAKBtu9sXo
	 4CBMMxksOq2EA==
Date: Thu, 19 Feb 2026 13:42:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	nirjhar.roy.lists@gmail.com
Subject: Re: [PATCH v3 1/4] xfs: Fix xfs_last_rt_bmblock()
Message-ID: <20260219214215.GP6490@frogsfrogsfrogs>
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
 <018c051440dc24200a223358b7ec302b88a8fde4.1771512159.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <018c051440dc24200a223358b7ec302b88a8fde4.1771512159.git.nirjhar.roy.lists@gmail.com>

On Thu, Feb 19, 2026 at 08:16:47PM +0530, Nirjhar Roy (IBM) wrote:
> From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> 
> Bug description:
> 
> If the size of the last rtgroup i.e, the rtg passed to
> xfs_last_rt_bmblock() is such that the last rtextent falls in 0th word
> offset of a bmblock of the bitmap file tracking this (last) rtgroup,
> then in that case xfs_last_rt_bmblock() incorrectly returns the next
> bmblock number instead of the current/last used bmblock number.
> When xfs_last_rt_bmblock() incorrectly returns the next bmblock,
> the loop to grow/modify the bmblocks in xfs_growfs_rtg() doesn't
> execute and xfs_growfs basically does a nop in certain cases.
> 
> xfs_growfs will do a nop when the new size of the fs will have the same
> number of rtgroups i.e, we are only growing the last rtgroup.
> 
> Reproduce:
> $ mkfs.xfs -m metadir=0 -r rtdev=/dev/loop1 /dev/loop0 \
> 	-r rgsize=32768b,size=32769b -f

/me is confused by metadir=0 and rgsize, but I think that's a red
herring, the key here is to create a filesystem with an rt bitmap that's
exactly one bit larger than a full bitmap block, right?  And the
reproducer also seems to work if you pass metadir=1 above.

> $ mount -o rtdev=/dev/loop1 /dev/loop0 /mnt/scratch
> $ xfs_growfs -R $(( 32769 + 1 )) /mnt/scratch
> $ xfs_info /mnt/scratch | grep rtextents
> $ # We can see that rtextents hasn't changed
> 
> Fix:
> Fix this by returning the current/last used bmblock when the last
> rtgroup size is not a multiple xfs_rtbitmap_rtx_per_rbmblock()
> and the next bmblock when the rtgroup size is a multiple of
> xfs_rtbitmap_rtx_per_rbmblock() i.e, the existing blocks are
> completely used up.
> Also, I have renamed xfs_last_rt_bmblock() to
> xfs_last_rt_bmblock_to_extend() to signify that this function
> returns the bmblock number to extend and NOT always the last used
> bmblock number.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  fs/xfs/xfs_rtalloc.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 90a94a5b6f7e..decbd07b94fd 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1079,17 +1079,27 @@ xfs_last_rtgroup_extents(
>  }
>  
>  /*
> - * Calculate the last rbmblock currently used.
> + * This will return the bitmap block number (indexed at 0) that will be
> + * extended/modified. There are 2 cases here:
> + * 1. The size of the rtg is such that it is a multiple of
> + *    xfs_rtbitmap_rtx_per_rbmblock() i.e, an integral number of bitmap blocks
> + *    are completely filled up. In this case, we should return
> + *    1 + (the last used bitmap block number).

Let me try to work through case #1.  In this case, there are 32768 rtx
per rtbitmap block and the rt volume is 32768 extents.
xfs_rtbitmap_blockcount_len turns into:

	howmany_64(32768, 32768) == 1

In the new code, bmbno will be set to 1-1==0, and mod will be 0, so we
bump bmbno and return 1.  IOWs, the growfsrt starts expanding from
rtbitmap block 1.

> + * 2. The size of the rtg is not an multiple of xfs_rtbitmap_rtx_per_rbmblock().
> + *    Here we will return the block number of last used block number. In this
> + *    case, we will modify the last used bitmap block to extend the size of the
> + *    rtgroup.

For case 2, there might be 32768 rtx per rtbitmap block, but now the rt
volume is 32769 rtx.  _blockcount_len becomes:

	howmany_64(32769, 32768) == 2

In the new code, bmbno will be set to 1.  mod will be 1, so we don't
increment bmbno and return 1, so the growfs again starts expanding from
rtbitmap block 1.

Now let's say the rt volume is 32767 rtx.  _blockcount_len becomes:

	howmany_64(32767, 32768) == 1

bmbno is set to 0.  mod now is 32767, so here we also leave bmbno alone.
We return 0, so the growfsrt starts at block 0.

>   *
>   * This also deals with the case where there were no rtextents before.

What about this case?  There are 32768 rtx per rtbitmap block, but the
rt volume is 0 rtx.  I think in this case sb_rgcount will be 0, so we
don't do any of the division stuff and simply return 0.

(This is effectively case #3)

I think the logic is correct.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>   */
>  static xfs_fileoff_t
> -xfs_last_rt_bmblock(
> +xfs_last_rt_bmblock_to_extend(
>  	struct xfs_rtgroup	*rtg)
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
>  	xfs_fileoff_t		bmbno = 0;
> +	unsigned int		mod = 0;
>  
>  	ASSERT(!mp->m_sb.sb_rgcount || rgno >= mp->m_sb.sb_rgcount - 1);
>  
> @@ -1097,9 +1107,16 @@ xfs_last_rt_bmblock(
>  		xfs_rtxnum_t	nrext = xfs_last_rtgroup_extents(mp);
>  
>  		/* Also fill up the previous block if not entirely full. */
> -		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext);
> -		if (xfs_rtx_to_rbmword(mp, nrext) != 0)
> -			bmbno--;
> +		/* We are doing a -1 to convert it to a 0 based index */
> +		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext) - 1;
> +		div_u64_rem(nrext, xfs_rtbitmap_rtx_per_rbmblock(mp), &mod);
> +		/*
> +		 * mod = 0 means that all the current blocks are full. So
> +		 * return the next block number to be used for the rtgroup
> +		 * growth.
> +		 */
> +		if (mod == 0)
> +			bmbno++;
>  	}
>  
>  	return bmbno;
> @@ -1204,7 +1221,8 @@ xfs_growfs_rtg(
>  			goto out_rele;
>  	}
>  
> -	for (bmbno = xfs_last_rt_bmblock(rtg); bmbno < bmblocks; bmbno++) {
> +	for (bmbno = xfs_last_rt_bmblock_to_extend(rtg); bmbno < bmblocks;
> +			bmbno++) {
>  		error = xfs_growfs_rt_bmblock(rtg, nrblocks, rextsize, bmbno);
>  		if (error)
>  			goto out_error;
> -- 
> 2.43.5
> 
> 
