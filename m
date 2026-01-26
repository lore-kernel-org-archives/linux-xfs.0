Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1209E246774;
	Mon, 26 Jan 2026 19:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769456685; cv=none; b=Wc727yKGx5iQIKhNmyhiyIR1jr2hrXoJ6mCy+BGey9Jb4jL7s8qiiMHOYog0TpNtD4Q6VrX5Zu1P4fFc1BjMKOk4JWDr+iD6nM6nsu409/R3ZbdBusyF4O/0EcqUeTMqgQWZkLqeNbV2RqglDypHU62i2GxDKVz/jIhfNdmSPiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769456685; c=relaxed/simple;
	bh=FxPXe18f9wbUacujY6pHpxnzlSfNytSUFBes6TJ81KE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6/sDRKYQ3JXb38I1h0cVMk7lYKcWbgd2D9GRcJ+TUDI6PM5FioxR7ahuJ4KqzPVbirluUyjIIOxAYelwuLtYUU6hIj1wvdRKiO1iUbaYt6CvgQiYGqAXRCdvczG0hWBp8ETL30zjrHvelqCGmvS5w32mS8bQtj46z6q2JCvQds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lww4tfGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lww4tfGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA1C116C6;
	Mon, 26 Jan 2026 19:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769456684;
	bh=FxPXe18f9wbUacujY6pHpxnzlSfNytSUFBes6TJ81KE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lww4tfGDWMaPRt19nSrazJCpgfzWCuhFhVpCeyYOAJbXtHhPLwkEqOyy2n9Se3ZfP
	 9lwMG1ba/9tgWbzisqlzYNCirXx7Nf+kSy894Ws+cSObVgNQDrXLKkenjkQNF/GFDX
	 MZcKDCfnpn/VKnuNeNzqlBzx+sGUvCVXwwP2TWn/gfwGt1GsEiitBcFBmZTJBWbOs4
	 /Le18K5nnvIhS8tcKRD5X7sZNREICdLvTq1x9KOVurlcTsHVgiBCBJ2jNIhJU0g43b
	 BjWaoBpBCNHHCh8tsaBUW8/XMXcgNvPDuHpx3tFGIKNvhF1Hhzq5t5YAxDkB+RLFww
	 n/J/tujg140MA==
Date: Mon, 26 Jan 2026 11:44:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shin Seong-jun <shinsj4653@gmail.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, sandeen@redhat.com,
	willy@infradead.org, dchinner@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix spacing style issues in xfs_alloc.c
Message-ID: <20260126194444.GZ5945@frogsfrogsfrogs>
References: <20260123150432.184945-1-shinsj4653@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123150432.184945-1-shinsj4653@gmail.com>

On Sat, Jan 24, 2026 at 12:04:32AM +0900, Shin Seong-jun wrote:
> Fix checkpatch.pl errors regarding missing spaces around assignment
> operators in xfs_alloc_compute_diff() and xfs_alloc_fixup_trees().
> 
> Adhere to the Linux kernel coding style by ensuring spaces are placed
> around the assignment operator '='.
> 
> Signed-off-by: Shin Seong-jun <shinsj4653@gmail.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index ad381c73abc4..c64e6c13f70d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -376,8 +376,8 @@ xfs_alloc_compute_diff(
>  	xfs_agblock_t	freeend;	/* end of freespace extent */
>  	xfs_agblock_t	newbno1;	/* return block number */
>  	xfs_agblock_t	newbno2;	/* other new block number */
> -	xfs_extlen_t	newlen1=0;	/* length with newbno1 */
> -	xfs_extlen_t	newlen2=0;	/* length with newbno2 */
> +	xfs_extlen_t	newlen1 = 0;	/* length with newbno1 */
> +	xfs_extlen_t	newlen2 = 0;	/* length with newbno2 */
>  	xfs_agblock_t	wantend;	/* end of target extent */
>  	bool		userdata = datatype & XFS_ALLOC_USERDATA;
>  
> @@ -577,8 +577,8 @@ xfs_alloc_fixup_trees(
>  	int		i;		/* operation results */
>  	xfs_agblock_t	nfbno1;		/* first new free startblock */
>  	xfs_agblock_t	nfbno2;		/* second new free startblock */
> -	xfs_extlen_t	nflen1=0;	/* first new free length */
> -	xfs_extlen_t	nflen2=0;	/* second new free length */
> +	xfs_extlen_t	nflen1 = 0;	/* first new free length */
> +	xfs_extlen_t	nflen2 = 0;	/* second new free length */
>  	struct xfs_mount *mp;
>  	bool		fixup_longest = false;
>  
> -- 
> 2.47.3
> 
> 
