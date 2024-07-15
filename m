Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E8B4EB37
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721064726; cv=none; b=LM6WaUrPIDWHfGpEtgmuNenNBQe6Z2z5zslqXFhEsvaCb5rj6DnCj0Sya6HA+TDf6ojRVEGgOsrn7BrdUNMSKGKaD8Z/sIkn56vPqN55tyQEPCHBrYBZtkOqkVknbBDCpR7QzjGBm+F7JWF62LMmeCVnNjW5hNW3QxEpJ4RTSmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721064726; c=relaxed/simple;
	bh=8TPyupCzBtewOiZ7Li257paDboQ/rvy5KmfzE26Ls/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jBOA6eS+ORZ4YNx47gxxOFU9L8YWfguW1Qb+m9sssM9MMtbAH0JP1WoWDggc6MSKihFFa4dFwlklZwT2riVa7DW6KiuCxuAdwWPhDHSZ9jDnbgJl3Tp/5KMNj0uJb9wZtzpwpAhfWqbUIgV0EgvvFhFtJ3LdYXK1Gyf18wioSsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szq35pql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szq35pql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8584AC32782;
	Mon, 15 Jul 2024 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721064725;
	bh=8TPyupCzBtewOiZ7Li257paDboQ/rvy5KmfzE26Ls/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=szq35pql2sYguAv5DfJtsEYhzfR9BuLSblpy2phDZRWPpEv9M/FLVlYLqqCFDDqw/
	 ClHvfJgXP/nB6RpIzosaq7By7A1+AxXLY5wEimliF7pFVApDfGsmYRThFFOE6YlQJf
	 QlcolGW8R5zaHGWAXJQFkaahkcWW7WhqfqANCuHkt8MI7HujIqz1Cvnl9oCQrcIZpO
	 OTtu9Y73FA1/SHlfCGeqB0+NfI1L9NZ0MIW9daOMOs3OX+FoVnlDpJ/Sul9ePMhaZ3
	 lqQd77aezjEE7lxjjC/k9LE9MRCfghvpLjJ2mUqYvs2YBV8BrznUTe016DH84c6JAz
	 QpoZOXA6bor5g==
Date: Mon, 15 Jul 2024 10:32:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] repair: btree blocks are never on the RT subvolume
Message-ID: <20240715173204.GW612460@frogsfrogsfrogs>
References: <20240715170915.776487-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715170915.776487-1-hch@lst.de>

On Mon, Jul 15, 2024 at 07:09:15PM +0200, Christoph Hellwig wrote:
> scan_bmapbt tries to track btree blocks in the RT duplicate extent
> AVL tree if the inode has the realtime flag set.  Given that the
> RT subvolume is only ever used for file data this is incorrect.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Did you actually hit this, or did you find it through code inspection?
AFAICT for attr forks, the (whichfork != XFS_DATA_FORK) check should
have been saving us this whole time?  And the (type != XR_INO_RTDATA)
check did the job for the data fork?

IOWs, is this merely cleaning out a logic bomb, or is it resolving some
false positive/customer complaint?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  repair/scan.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 338308ef8..8352b3ccf 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -390,22 +390,11 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
>  			break;
>  		}
>  		pthread_mutex_unlock(&ag_locks[agno].lock);
> -	} else  {
> -		/*
> -		 * attribute fork for realtime files is in the regular
> -		 * filesystem
> -		 */
> -		if (type != XR_INO_RTDATA || whichfork != XFS_DATA_FORK)  {
> -			if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
> -					XFS_FSB_TO_AGBNO(mp, bno),
> -					XFS_FSB_TO_AGBNO(mp, bno) + 1))
> -				return(1);
> -		} else  {
> -			xfs_rtxnum_t	ext = xfs_rtb_to_rtx(mp, bno);
> -
> -			if (search_rt_dup_extent(mp, ext))
> -				return 1;
> -		}
> +	} else {
> +		if (search_dup_extent(XFS_FSB_TO_AGNO(mp, bno),
> +				XFS_FSB_TO_AGBNO(mp, bno),
> +				XFS_FSB_TO_AGBNO(mp, bno) + 1))
> +			return 1;
>  	}
>  	(*tot)++;
>  	numrecs = be16_to_cpu(block->bb_numrecs);
> -- 
> 2.43.0
> 
> 
