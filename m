Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0981BBBF8
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730392678; cv=none; b=r8Zk97CXJf2USN5XH6OzI9s+c7KB2TXbaOR+h4XCvZivmEw187VmJ6161ukjAMbHcNetqDlobERhnqRQcokmwChtD6UmLevBkoPccsSebbNoq+CfALjuH2xWAqiWx4yFf5F/ZpWDsx2csWwQ2UwYR/NaKypcfEsJRNz+GSwh048=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730392678; c=relaxed/simple;
	bh=kjAoY/U2cVlMNnd6tuf9UlZvtcR4XrOaHAVp56VmScs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e57dsbp1esK+mTeaf4XcxSseUcZ74F/7XHB6Syu+mADRF4AkI/SS0oFyJs6NfKhlABFxeIbbUsScxK/t/7MTMrO+g/u2aQ+igHrWCz7MROFYZNKVOluua0VavlWBUXMNGsqlo6Qx0h7CH+tlTGWjivHS6pCHHlEshdfj3IHkIQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vMnGShLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vMnGShLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE7AC4CEDE;
	Thu, 31 Oct 2024 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730392678;
	bh=kjAoY/U2cVlMNnd6tuf9UlZvtcR4XrOaHAVp56VmScs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vMnGShLA4HYit3TDywV6qa+PhRczLjwg8h30MK55de6qG5lTbpH4iyq+Cskv5X7Mv
	 CrBdEFFA7HkQak6O18DRvfVaMX3QOVSyBpHFllZA4pIqhKai+KhaCBLZHPQi076TVU
	 kqRaDYyrgFuqSfkSseeDs7rebd8edaQ//LhmIqzCwyUj0dIxeeaD9t/6Ht2tkbYuJ9
	 tzMaAQESaIf9USe5Gsp0qLQOF1iA3pfaFLalo5h2S+Wkp07s17TjX5RRRVeMp1eSoD
	 bqvO3QiVRts6yS+NEBaZfaYmtLXOCJ2Wh+4qA5n7dAnZjN8vK+gG1rwNtxZCr9Nh2e
	 cl5SCYcnPwS1Q==
Date: Thu, 31 Oct 2024 09:37:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: simplify sector number calculation in
 xfs_zero_extent
Message-ID: <20241031163758.GZ2386201@frogsfrogsfrogs>
References: <20241031130854.163004-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031130854.163004-1-hch@lst.de>

On Thu, Oct 31, 2024 at 02:08:35PM +0100, Christoph Hellwig wrote:
> xfs_zero_extent does some really odd gymnstics to calculate the block
> layer sectors numbers passed to blkdev_issue_zeroout.  This is because it
> used to call sb_issue_zeroout and the calculations in that helper got
> open coded here in the rather misleadingly named commit 3dc29161070a
> ("dax: use sb_issue_zerout instead of calling dax_clear_sectors").
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_util.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index ba6092fcdeb8..05fd768f7dcd 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -49,10 +49,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
>  
>  /*
>   * Routine to zero an extent on disk allocated to the specific inode.
> - *
> - * The VFS functions take a linearised filesystem block offset, so we have to
> - * convert the sparse xfs fsb to the right format first.
> - * VFS types are real funky, too.
>   */
>  int
>  xfs_zero_extent(
> @@ -60,15 +56,10 @@ xfs_zero_extent(
>  	xfs_fsblock_t		start_fsb,
>  	xfs_off_t		count_fsb)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> -	xfs_daddr_t		sector = xfs_fsb_to_db(ip, start_fsb);
> -	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
> -
> -	return blkdev_issue_zeroout(target->bt_bdev,
> -		block << (mp->m_super->s_blocksize_bits - 9),
> -		count_fsb << (mp->m_super->s_blocksize_bits - 9),

Groossssss, this is a good cleanup.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> -		GFP_KERNEL, 0);
> +	return blkdev_issue_zeroout(xfs_inode_buftarg(ip)->bt_bdev,
> +			xfs_fsb_to_db(ip, start_fsb),
> +			XFS_FSB_TO_BB(ip->i_mount, count_fsb),
> +			GFP_KERNEL, 0);
>  }
>  
>  /*
> -- 
> 2.45.2
> 
> 
