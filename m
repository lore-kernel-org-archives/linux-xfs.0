Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794FE6F2EB
	for <linux-xfs@vger.kernel.org>; Fri, 31 May 2024 15:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717170767; cv=none; b=FTjsthbAQHT5XrbupnAV4E4BBaMlNzhzwFU9tb09DeBsi7uW/AABnN4EgGL6PBuVVUdNGeLUkrTTSlFKnPtgGkmYgnC3rWcIAEo6lc68S6/sm4HgNFc2AxDJxp8sEnxmJ9mLMhsjnwpuyklVgdXxAFCjg8ZuOlw2thrCgpSYV8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717170767; c=relaxed/simple;
	bh=1RM340PhfdFEitMeiVrX4qP06w4JUyP8+ie+uEnEs30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FL61WIq9zvM3AmNhp/OEpaSodUmOQRPEThtOtuB9UDJcirrXdMqGvnQQlVJ3Kkheg3vcBSZCmyML7U5UTjdlktg6Da+TIlRF/bXK4jQ87+24wfp8nkmdqSuhBH2Im1NUbke7T83s85ZBDHv4TuHIZsZACmoy2C3ygJutB2PjlW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CrZwucKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CrZwucKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB90CC116B1;
	Fri, 31 May 2024 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717170766;
	bh=1RM340PhfdFEitMeiVrX4qP06w4JUyP8+ie+uEnEs30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrZwucKGRKliefsIOp27/vvyFLFNjWqcOmp968LGRoBB/3hnpMO6AIriVgZdtim9T
	 2SNaz+YON7NKp7AFowgG8J9kTSZJDgk6TB37LSxbXiO/vLXVNftFPGl2nOR1XQBah+
	 gI1Sxwh+Ioc1m3iZKKX73BQFa2YTlBMjcy7ZdCWVKm4g86fvQPUCShzLhPLOctksau
	 hmW0rD52yZVe7z9Bi8MYCuDl+tkVLVn+c8cGDA6rc6+QsTbrZ7H8Y4J93ezXJ/qFbQ
	 PNs6UXAyXkkuV2Sc4GdGlUhFF8l0OxBvYFyuEQ2mrU/svA8xAna22TTXAypD8ocCPs
	 AfZ3wSKwyiBXQ==
Date: Fri, 31 May 2024 08:52:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: make sure sb_fdblocks is non-negative
Message-ID: <20240531155245.GP52987@frogsfrogsfrogs>
References: <20240511003426.13858-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240511003426.13858-1-wen.gang.wang@oracle.com>

On Fri, May 10, 2024 at 05:34:26PM -0700, Wengang Wang wrote:

You might want to lead off with the origins of this fixpatch:

"A user with a completely full filesystem experienced an unexpected
shutdown when the filesystem tried to write the superblock during
runtime:"

<dmesg dump here>

"When xfs_log_sb writes a superblock to disk, sb_fdblocks is fetched..."

(or so I'm guessing from the other replies in this thread?)

((What was it doing?  Adding the ATTR/ATTR2 feature to the filesystem?))

> when writting super block to disk (in xfs_log_sb), sb_fdblocks is fetched from
> m_fdblocks without any lock. As m_fdblocks can experience a positive -> negativ

"negative"

>  -> positive changing when the FS reaches fullness (see xfs_mod_fdblocks)
> So there is a chance that sb_fdblocks is negative, and because sb_fdblocks is
> type of unsigned long long, it reads super big. And sb_fdblocks being bigger
> than sb_dblocks is a problem during log recovery, xfs_validate_sb_write()
> complains.
> 
> Fix:
> As sb_fdblocks will be re-calculated during mount when lazysbcount is enabled,
> We just need to make xfs_validate_sb_write() happy -- make sure sb_fdblocks is
> not genative.

"negative".

This otherwise looks good to me.

--D

> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 73a4b895de67..199756970383 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1037,7 +1037,7 @@ xfs_log_sb(
>  		mp->m_sb.sb_ifree = min_t(uint64_t,
>  				percpu_counter_sum(&mp->m_ifree),
>  				mp->m_sb.sb_icount);
> -		mp->m_sb.sb_fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +		mp->m_sb.sb_fdblocks = percpu_counter_sum_positive(&mp->m_fdblocks);
>  	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> -- 
> 2.39.3 (Apple Git-146)
> 
> 
