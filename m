Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B578BF8
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 06:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734416352; cv=none; b=c29/WEZvgqRXVZt86hzmATjDT1c5UgQ/Jmx2inSubNUrAIjZYWy3MgW0U/KvV/4b/WtucOjd5n+dNWCvhhLm7U2hjqWu/wLViNVf4lZ6k+WpSzyEle6NVqK8baaYeGn6/HX2APiye3xAaVgS78zS54o+XCpJm/bvaIrtt1fZ1Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734416352; c=relaxed/simple;
	bh=DYHU91++DuOjFUPXtibaBRvyaA5DxZL1c7GycTAenVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWFA4lUPXpHpGEnS8bBSEHxPwhzkJL4UbqQ58F2gu74yEnXrpRNzTSnvEhhGFyWsSGYfGvEK6wLSTC06r2B6No2Bb1UZU3uwKx/+JV6ZUhQpq+zCxH9ImgUdDSptjTTxvUWSo1mpqz8OREIZLfnOO3XOThkHaqkIraemlbTCehM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U33I9b7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U33I9b7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67984C4CED3;
	Tue, 17 Dec 2024 06:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734416351;
	bh=DYHU91++DuOjFUPXtibaBRvyaA5DxZL1c7GycTAenVI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U33I9b7PSFThFj8havVtrtFLguoOAuRBj2PbjKQaYZC6CGro6dCX/dJ04lk2jdXg6
	 6C7WQbCVZCqS8VfwbXun7vQehDVFMJEgqjGWxo/Nls+Z9svVKnclfr4MQF8pAKSutc
	 pjhqRn5fxljuNRUWa46LQ0pMj7w8QOqY45xR6k3zB9xi7Z6myTsDnFwL1bJnZNd6BM
	 g9iRymZEzr+VZrK3+K0rx54djknwJ/H2CUm64kDF849xyGxA0QlcLStWf2o43qD3WD
	 vmBw0pt+lb54Xm+j0HnYHK13mEDzmsRAlSqJEdaTr22xNgvS7UHPoBHVY2TrcfBzFx
	 I4AT1zyieqZag==
Date: Mon, 16 Dec 2024 22:19:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't return an error from
 xfs_update_last_rtgroup_size for !XFS_RT
Message-ID: <20241217061910.GB6197@frogsfrogsfrogs>
References: <20241217042737.1755365-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217042737.1755365-1-hch@lst.de>

On Tue, Dec 17, 2024 at 05:27:35AM +0100, Christoph Hellwig wrote:
> Non-rtg file systems have a fake RT group even if they do not have a RT
> device, and thus an rgcount of 1.  Ensure xfs_update_last_rtgroup_size
> doesn't fail when called for !XFS_RT to handle this case.
> 
> Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index 7e7e491ff06f..2d7822644eff 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -272,7 +272,7 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
>  }
>  
>  # define xfs_rtgroup_extents(mp, rgno)		(0)
> -# define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
> +# define xfs_update_last_rtgroup_size(mp, rgno)	(0)
>  # define xfs_rtgroup_lock(rtg, gf)		((void)0)
>  # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
>  # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
> -- 
> 2.45.2
> 
