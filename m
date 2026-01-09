Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82CB15687D
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975659; cv=none; b=popH/usoDtH1HLV+n8srg943687ODUmZwI10jMR1SwVI9ODmVmr/vM3Gewws10Jl02e+k+dOp6qVh8wUFnT7gQumvnuworeVzvuy+pL4yzO/wNSZA2Vgmr8cLTgM+SZKXUfBRrWyorC9frgemnJWoomRKb9A/tE8I7vop2krMSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975659; c=relaxed/simple;
	bh=axf4vH9vYx2Q72UDb97byhApUKpab2p6E7Olaq4omic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxJu7xEGc5LzXqQ3geuKD5CabTfsBNftbbFHZDTLRxd5kAZFPexyaU9ZAGdHw8HpCf7q8d7AY41qaz3wzo5PA9f/OeOojheLO3Lq10WxOklRL8fYcd4xH2NeyyLsfijxrSRryETxuXDaT7uX0bS1sL/SggtNKfSf/WABX6KnQ3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWnw3ghi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWnw3ghi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EA4C4CEF1;
	Fri,  9 Jan 2026 16:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767975659;
	bh=axf4vH9vYx2Q72UDb97byhApUKpab2p6E7Olaq4omic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hWnw3ghiYP09KNamp4BpEn7xDEjWj/bXNHqR/aCPYM/HFOufMEMZAL6xmpDlJ6Dr1
	 6XcEnybHzyP2IAijv7Pd376KoU2suUEyMlScX7sxIkJYgKNLiLMtY/z20FSKhkVhvG
	 cZuWulGKGy4EWCkx7h8WjHhqjezgusRPvkb6U5NfjxTKK1kOEH7v4WgdbMdZOyoknA
	 o+vZqHohG1PKIH8WVY2uur2ixkR5ePEV6yO2AmdAeOGZcih9siU11eCxvruj/z5iKK
	 ToUV9WWrLdjsL4BXOlpi3u82bmC1Y2OLVFOXtnmhk4S/7GdGH5y/kDFh6qgvYkJfhe
	 XFBY94VwFfATA==
Date: Fri, 9 Jan 2026 08:20:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix an overly long line in
 xfs_rtgroup_calc_geometry
Message-ID: <20260109162059.GQ15551@frogsfrogsfrogs>
References: <20260109151901.2376971-1-hch@lst.de>
 <20260109151901.2376971-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109151901.2376971-2-hch@lst.de>

On Fri, Jan 09, 2026 at 04:18:54PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index 5a3d0dc6ae1b..be16efaa6925 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -83,7 +83,8 @@ xfs_rtgroup_calc_geometry(
>  	xfs_rtbxlen_t		rextents)
>  {
>  	rtg->rtg_extents = __xfs_rtgroup_extents(mp, rgno, rgcount, rextents);
> -	rtg_group(rtg)->xg_block_count = rtg->rtg_extents * mp->m_sb.sb_rextsize;
> +	rtg_group(rtg)->xg_block_count =
> +		rtg->rtg_extents * mp->m_sb.sb_rextsize;
>  	rtg_group(rtg)->xg_min_gbno = xfs_rtgroup_min_block(mp, rgno);
>  }
>  
> -- 
> 2.47.3
> 
> 
