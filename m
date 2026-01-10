Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4915819DF8D
	for <linux-xfs@vger.kernel.org>; Sat, 10 Jan 2026 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006808; cv=none; b=pUAgpIKVanl09iNmo4XUqOb2s8BZarVfbla3G/zFFmH+1KH5yzoVDcJZHp5D5469ABNsb5PkIt61CsUlNFvfHJMcc2K4aoVgzImPMMbANfhxk7oeDKsbO8hn6lvCWwazhmWnvoSPLi0sTm/AR0TqxOPHynWLRu235cHAe0QLhqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006808; c=relaxed/simple;
	bh=zvJViVqZRhQvkxCzSNmCl6sl53P4SrUqX1slhcoPF0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MqDJf7AGiqK8g1ZU5jvhc0YnPov88jF03UZXHpR55z6w1ALgf8VqjZCmM1sbWFJ4rH3Vrzsdz0TWPZyytnofW9Mj4njJ/66fbcMxC0SeEKelzM5lEvp1lemRjZV9VNSOafMfXT2IXG6yUS0f1iivANcCjKt+NMjgw/KSMDavx6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQl8NW7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQl8NW7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C0BC4CEF1;
	Sat, 10 Jan 2026 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768006807;
	bh=zvJViVqZRhQvkxCzSNmCl6sl53P4SrUqX1slhcoPF0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BQl8NW7x1LFqtXlzxNIeSycHlCpkGJXvHrVRMzi08llONAZVHfHL2tYf+wVo+1i7W
	 n+yJWubIih416xMxGkPJ1jrr8A1lRxMPlKLRdxrjWJvMiI3rt8nrBzDx/z3TTd5bUA
	 Bfq7asBycQ8cricdurCksjobjMzu7z0i1HcHnbqwDSra55e5sS+NGHXnpL3n6a8X1C
	 YL1dU9+NpRvH0/ahgZ3hoCnR9siDZD1aVYdJz3Q33A4qbbtbHJG/W6o/9zy+xR7ore
	 obrfVy678r/uiWGop18BDWNll1Gj2nhgaHu6VBSkJi43/sjX0LetQt/j8npGVINi4n
	 cxpSlREq68+lg==
Date: Fri, 9 Jan 2026 17:00:07 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: add a xfs_rtgroup_raw_size helper
Message-ID: <20260110010007.GW15551@frogsfrogsfrogs>
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109172139.2410399-3-hch@lst.de>

On Fri, Jan 09, 2026 at 06:20:47PM +0100, Christoph Hellwig wrote:
> Add a helper to figure the on-disk size of a group, accounting for the
> XFS_SB_FEAT_INCOMPAT_ZONE_GAPS feature if needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index 73cace4d25c7..c0b9f9f2c413 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -371,4 +371,19 @@ xfs_rtgs_to_rfsbs(
>  	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
>  }
>  
> +/*
> + * Return the "raw" size of a group on the hardware device.  This includes the
> + * daddr gaps present for XFS_SB_FEAT_INCOMPAT_ZONE_GAPS file systems.
> + */
> +static inline xfs_rgblock_t
> +xfs_rtgroup_raw_size(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +
> +	if (g->has_daddr_gaps)
> +		return 1U << g->blklog;
> +	return g->blocks;
> +}
> +
>  #endif /* __LIBXFS_RTGROUP_H */
> -- 
> 2.47.3
> 
> 
