Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA161CF7DE
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 16:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732033318; cv=none; b=V8LC0Ogi4FHDz/JCX0uGpRPu1TlhZvVpsYfr/uF9yv9p2SbYUMTXgiZtn6YH/ROkzfaC81NX7GXXbrtIoKeXiAOO3WzqNCqogNxSlhmLzkvcE+DnXgbBFsftW2XmsWSvAkYN22Px9eSJFY4YPeYLIQtXiQLa/Pk2gVUVDlpMqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732033318; c=relaxed/simple;
	bh=Tte77ozcnV01tVrN+eg7lC31uA0V9rS9yVrg5QKfBss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4oedHBUS0Re5ZdHYtf/l2RWHs5W4prc0ELwvd65VHi7xh0qIBBcd4CLadJkuCS38B13WANafdkZFvaDEIIq96aVnpjNWpVAAjWem2gGs67DfMZ/mP0HuREi7lNrSGlQtcvcoB529vfuN71JagbL09SzW/1KZvD6Tcua/3WF5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3YX/4eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3YX/4eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD2CC4CECF;
	Tue, 19 Nov 2024 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732033317;
	bh=Tte77ozcnV01tVrN+eg7lC31uA0V9rS9yVrg5QKfBss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o3YX/4eqaLIkPL7e4xlHAvZXOC/i2qFA/zJ4OhYaKl91hmKaJmEzBIHKRNh+uS7ix
	 iuhUhT12UgAU/b7woLFvc76MX7kNR2jYR8i9SXThBXR1IL+nnWFal5m+2p0Oy85deM
	 ZAuY4TggvzU/n0dW1StfmSMCt+elXRXBavzWGlCOuWu8dAzwPqHX5V2hIOuf78NrEF
	 /GK71ZuFM6I8JXVrFcLCfh1pec4/J/D/eUeca3yFnrVod39KKcmktBVaQ2wHI6G8oH
	 qYd+KDgNG2DzS2c1hv1VAZSnx/8KeA57+eoNHOnjUhX60xBW5FTgvja1UILo2TO1bs
	 DrBgjXeOmMFQg==
Date: Tue, 19 Nov 2024 08:21:57 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: don't call xfs_bmap_same_rtgroup in
 xfs_bmap_add_extent_hole_delay
Message-ID: <20241119162157.GY9438@frogsfrogsfrogs>
References: <20241119154959.1302744-1-hch@lst.de>
 <20241119154959.1302744-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119154959.1302744-4-hch@lst.de>

On Tue, Nov 19, 2024 at 04:49:49PM +0100, Christoph Hellwig wrote:
> xfs_bmap_add_extent_hole_delay works entirely on delalloc extents, for
> which xfs_bmap_same_rtgroup doesn't make sense.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oooooops :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9052839305e2..5255f93bae31 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2620,8 +2620,7 @@ xfs_bmap_add_extent_hole_delay(
>  	 */
>  	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
>  	    left.br_startoff + left.br_blockcount == new->br_startoff &&
> -	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
> -	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
> +	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
>  		state |= BMAP_LEFT_CONTIG;
>  
>  	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
> @@ -2629,8 +2628,7 @@ xfs_bmap_add_extent_hole_delay(
>  	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
>  	    (!(state & BMAP_LEFT_CONTIG) ||
>  	     (left.br_blockcount + new->br_blockcount +
> -	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)) &&
> -	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
> +	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
>  		state |= BMAP_RIGHT_CONTIG;
>  
>  	/*
> -- 
> 2.45.2
> 
> 
