Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE62713633F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724255857; cv=none; b=tu4aWu3hcwi/lqomn08UoyjSUC5Ey8SLf7+/6SBIZwurAsTQVLgD4ToRFFoGF/RqKPcdlmEeYFS81bDKnQeSqj/zbYExZopi6D57OEm4Wn3Ph9/Y2mVlaGWF9rdNfqTXo6FHqPo7ve1WMg55kS47UkOlSYcnkdX2cCX1vNtzE30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724255857; c=relaxed/simple;
	bh=AngDiOhm1o2y7nyURoZLAXUGGhKT0ETTmBunKxiftO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oH2gCYZaKFToavMvvykbkriKxqRVmj4d7MmX8F209FijA3NYjrkKFjKKxa5/FnoJArhZnATFR1slwTbbgycremGGRvcxLCIHLrGqHDFlor1nQhlF6/TMZYnLJ6L6RAAxh6QtjDSilFJEgpCrZwFcfF/I/jK+wwW0qHkIHyp+3i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P39CaNxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P39CaNxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61EF5C32781;
	Wed, 21 Aug 2024 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724255857;
	bh=AngDiOhm1o2y7nyURoZLAXUGGhKT0ETTmBunKxiftO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P39CaNxesAkTvPrD+dF4e6nERpWzRABM04bX4gRBuVIPbmE6Bn2ToupLk03ZAxQMK
	 SjjWAuRFhevP7T3tYXbVgvncTXwCAXfpuWveXRp7h/tjFDgGjPE6MXoDqfhLw8t4VP
	 1Bpd45VuRF6j38PxEq2UYR5bK22w/GgLi3Xaz8MSIkYSIQbcw+fULuBBwuUJKMrkNf
	 19exGitFQxPq1s6RHY5Em+dZj+tzvRRl/MaZ5PHE6a8Ow07joLNTZxQKHmb4ZN0T+t
	 txhAOJaZ4i8MrnXKYaA41v5LgkTcoevWVqBOAmDQeyIvnjglGCl78XiGvMxGXbDNm0
	 PlF4Ddg+ZKkMQ==
Date: Wed, 21 Aug 2024 08:57:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: distinguish extra split from real ENOSPC from
 xfs_attr3_leaf_split
Message-ID: <20240821155736.GX865349@frogsfrogsfrogs>
References: <20240820170517.528181-1-hch@lst.de>
 <20240820170517.528181-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820170517.528181-4-hch@lst.de>

On Tue, Aug 20, 2024 at 07:04:54PM +0200, Christoph Hellwig wrote:
> xfs_attr3_leaf_split propagates the need for an extra btree split as
> -ENOSPC to it's only caller, but the same return value can also be
> returned from xfs_da_grow_inode when it fails to find free space.
> 
> Distinguish the two cases by returning 1 for the extra split case instead
> of overloading -ENOSPC.
> 
> This can be triggered relatively easily with the pending realtime group
> support and a file system with a lot of small zones that use metadata
> space on the main device.  In this case every about 5-10th run of
> xfs/538 runs into the following assert:
> 
> 	ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);
> 
> in xfs_attr3_leaf_split caused by an allocation failure.  Note that
> the allocation failure is caused by another bug that will be fixed
> subsequently, but this commit at least sorts out the error handling.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice cleanup
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
>  fs/xfs/libxfs/xfs_da_btree.c  | 5 +++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index bcaf28732bfcae..92acef51876e4b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1334,6 +1334,9 @@ xfs_attr3_leaf_create(
>  
>  /*
>   * Split the leaf node, rebalance, then add the new entry.
> + *
> + * Returns 0 if the entry was added, 1 if a further split is needed or a
> + * negative error number otherwise.
>   */
>  int
>  xfs_attr3_leaf_split(
> @@ -1390,7 +1393,7 @@ xfs_attr3_leaf_split(
>  	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
>  	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
>  	if (!added)
> -		return -ENOSPC;
> +		return 1;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 16a529a8878083..17d9e6154f1978 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -593,9 +593,8 @@ xfs_da3_split(
>  		switch (oldblk->magic) {
>  		case XFS_ATTR_LEAF_MAGIC:
>  			error = xfs_attr3_leaf_split(state, oldblk, newblk);
> -			if ((error != 0) && (error != -ENOSPC)) {
> +			if (error < 0)
>  				return error;	/* GROT: attr is inconsistent */
> -			}
>  			if (!error) {
>  				addblk = newblk;
>  				break;
> @@ -617,6 +616,8 @@ xfs_da3_split(
>  				error = xfs_attr3_leaf_split(state, newblk,
>  							    &state->extrablk);
>  			}
> +			if (error == 1)
> +				return -ENOSPC;
>  			if (error)
>  				return error;	/* GROT: attr inconsistent */
>  			addblk = newblk;
> -- 
> 2.43.0
> 
> 
