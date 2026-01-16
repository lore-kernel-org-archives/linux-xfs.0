Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424952C21FC
	for <linux-xfs@vger.kernel.org>; Fri, 16 Jan 2026 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768572295; cv=none; b=lGt60bBzg67g+Q1fr390kPHLlajwMC20be0znWeD5uWyH7Lu2cKmDf8zGpbgOrDoehDmhCygA6puge18wOoXiplEXaqWRz5jctrB+v8GIBcH4qz8S1wFWD5chMgIKfVmMpCGHswGhfhPO6Su4yJTYJqcvwaVQjAEZCrl025XPY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768572295; c=relaxed/simple;
	bh=/tlLedTqe/coTnfTDgAaJpVt3+hi9VT4+SiLDohdG00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3ATqVoJ4PjrwJnX6Rb39xoXWrHDsV2C/1L3pX0tDMQcm1b58jQTfibUYQapkh08mcuuwI5rk6prTFYGa83k33dPa91lySY+qYPlDaPQW1OHYL/jVFFr6TeKZYb/87idfylO8g3xi6iah8rAjUtx156hPnSwUHyJ1oEbZod34iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfgJ3/TJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfgJ3/TJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83BEC116C6;
	Fri, 16 Jan 2026 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768572294;
	bh=/tlLedTqe/coTnfTDgAaJpVt3+hi9VT4+SiLDohdG00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfgJ3/TJnloyeS/uk0g11C21CIIAlGClzM8YsxxlhjTpMXfG6Se7BKPCowtLYCooG
	 sG4p/VIet1vUvV2vYNeu7ZAcrv1AmCPJ1KilHYMdZP1917ptc01f/rnr6EkrYpxMHO
	 UQaejFVxhyZqUt7dpYbHW3INQC2hdMVoJi9BoJzM9vRm5mLq3A4q5q9L6twZr3tZRe
	 zVwdAgVLgdh4nQgAx4HWDzDYzkfi0dL+3v3uOSIi1UtZbfIRbxFr/2XtOEIgC4bidN
	 n35KmQy+errQ/Z7ZRp7ozw4rM5ZAcTj8IHVPSX6WJYeeaJybvj27p+8vta8pGnbdYe
	 NtFF1VawaJrJQ==
Date: Fri, 16 Jan 2026 15:04:50 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: add a xfs_rtgroup_raw_size helper
Message-ID: <aWpFfUAKYt7Qu7l8@nidhogg.toxiclabs.cc>
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114065339.3392929-3-hch@lst.de>

On Wed, Jan 14, 2026 at 07:53:25AM +0100, Christoph Hellwig wrote:
> Add a helper to figure the on-disk size of a group, accounting for the
> XFS_SB_FEAT_INCOMPAT_ZONE_GAPS feature if needed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  #endif /* __LIBXFS_RTGROUP_H */
> -- 
> 2.47.3
> 
> 
