Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759AA839E8
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 23:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711410944; cv=none; b=Hwzs9ta5u90ikeB5Va8imM8XW0D3XI8B2zc1sQcwNNpEGTB1yjMgi1+yMmwq4miAKFvvRtmn+5xF26OPM7Byucj6KBs+k7wouh5rooZAAx2LUHzxYUkx7eeX6oVonhBqqVKaOLZb8Zi5gOM/Dt1zuh32kw0e8BfhW8lYyb/MaN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711410944; c=relaxed/simple;
	bh=afFtRJO6W88F5AV6mkROVMv3VBxzM2WouAxaMKedMTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHaIC/oGXCmWFl2FtKkZiVVh+aoqrNJqCjfXWAGpPf/jzujo3f8tuFAfQoO3+HrLlhACeG8eX0MkrnTh4UHnCYB6UrTLpKxO3GsJtV5Osd6RWBfEydqBsQofRuntghqTa2rLxSF/h4ViZDFCPRgQWCY6q8ydI4ta1Z2WurLjz6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tSHp7mPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tSHp7mPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36EBC433F1;
	Mon, 25 Mar 2024 23:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711410944;
	bh=afFtRJO6W88F5AV6mkROVMv3VBxzM2WouAxaMKedMTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tSHp7mPkfgC8YHk9TsQSdREG+SUjdoTSvfDTS2ZNH5Cr8m+Crt2sas4oUy/zFhNSW
	 H/GfZsk6sIic7sO6TydSmcVsFO9OVEYSB9grSsOW/3FUn/Ef1+/sZPqH/AB+EAPlME
	 kVZSdngQyP85zJik0wLW7lhWAst4hmJthAsilOT39VNKQbhp47b9Zg5nih96L3fInj
	 6qbpl1Gbg8O21eu99Ky8OsnHAcfkf3PwzJJ23DCs1/hTx/jVwMK0Y4Wbg6twflbWgJ
	 80gJRLDTU85OrKF1uuG4yMWPFs1OVdBWcPChM/5C4ngcZfs1bvt9w0HjKHfLTkg8TT
	 4Z9fI8LY/EsSg==
Date: Mon, 25 Mar 2024 16:55:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs: rework splitting of indirect block
 reservations
Message-ID: <20240325235543.GF6414@frogsfrogsfrogs>
References: <20240325022411.2045794-1-hch@lst.de>
 <20240325022411.2045794-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325022411.2045794-10-hch@lst.de>

On Mon, Mar 25, 2024 at 10:24:09AM +0800, Christoph Hellwig wrote:
> Move the check if we have enough indirect blocks and the stealing of
> the deleted extent blocks out of xfs_bmap_split_indlen and into the
> caller to prepare for handling delayed allocation of RT extents that
> can't easily be stolen.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++----------------------
>  1 file changed, 16 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cc250c33890bac..dda25a21100836 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4829,31 +4829,17 @@ xfs_bmapi_remap(
>   * ores == 1). The number of stolen blocks is returned. The availability and
>   * subsequent accounting of stolen blocks is the responsibility of the caller.
>   */
> -static xfs_filblks_t
> +static void
>  xfs_bmap_split_indlen(
>  	xfs_filblks_t			ores,		/* original res. */
>  	xfs_filblks_t			*indlen1,	/* ext1 worst indlen */
> -	xfs_filblks_t			*indlen2,	/* ext2 worst indlen */
> -	xfs_filblks_t			avail)		/* stealable blocks */
> +	xfs_filblks_t			*indlen2)	/* ext2 worst indlen */
>  {
>  	xfs_filblks_t			len1 = *indlen1;
>  	xfs_filblks_t			len2 = *indlen2;
>  	xfs_filblks_t			nres = len1 + len2; /* new total res. */
> -	xfs_filblks_t			stolen = 0;
>  	xfs_filblks_t			resfactor;
>  
> -	/*
> -	 * Steal as many blocks as we can to try and satisfy the worst case
> -	 * indlen for both new extents.
> -	 */
> -	if (ores < nres && avail)
> -		stolen = XFS_FILBLKS_MIN(nres - ores, avail);
> -	ores += stolen;
> -
> -	 /* nothing else to do if we've satisfied the new reservation */
> -	if (ores >= nres)
> -		return stolen;
> -
>  	/*
>  	 * We can't meet the total required reservation for the two extents.
>  	 * Calculate the percent of the overall shortage between both extents
> @@ -4898,8 +4884,6 @@ xfs_bmap_split_indlen(
>  
>  	*indlen1 = len1;
>  	*indlen2 = len2;
> -
> -	return stolen;
>  }
>  
>  int
> @@ -4915,7 +4899,7 @@ xfs_bmap_del_extent_delay(
>  	struct xfs_bmbt_irec	new;
>  	int64_t			da_old, da_new, da_diff = 0;
>  	xfs_fileoff_t		del_endoff, got_endoff;
> -	xfs_filblks_t		got_indlen, new_indlen, stolen;
> +	xfs_filblks_t		got_indlen, new_indlen, stolen = 0;
>  	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	uint64_t		fdblocks;
>  	int			error = 0;
> @@ -4994,8 +4978,19 @@ xfs_bmap_del_extent_delay(
>  		new_indlen = xfs_bmap_worst_indlen(ip, new.br_blockcount);
>  
>  		WARN_ON_ONCE(!got_indlen || !new_indlen);
> -		stolen = xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen,
> -						       del->br_blockcount);
> +		/*
> +		 * Steal as many blocks as we can to try and satisfy the worst
> +		 * case indlen for both new extents.
> +		 */
> +		da_new = got_indlen + new_indlen;
> +		if (da_new > da_old) {
> +			stolen = XFS_FILBLKS_MIN(da_new - da_old,
> +						 new.br_blockcount);

Huh.  We used to pass del->blockcount as one of the constraints on the
stolen block count.  Why pass new.br_blockcount instead?

--D

> +			da_old += stolen;
> +		}
> +		if (da_new > da_old)
> +			xfs_bmap_split_indlen(da_old, &got_indlen, &new_indlen);
> +		da_new = got_indlen + new_indlen;
>  
>  		got->br_startblock = nullstartblock((int)got_indlen);
>  
> @@ -5007,7 +5002,6 @@ xfs_bmap_del_extent_delay(
>  		xfs_iext_next(ifp, icur);
>  		xfs_iext_insert(ip, icur, &new, state);
>  
> -		da_new = got_indlen + new_indlen - stolen;
>  		del->br_blockcount -= stolen;
>  		break;
>  	}
> -- 
> 2.39.2
> 
