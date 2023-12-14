Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8216A346
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 20:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrC4hKSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D72EC433C8;
	Thu, 14 Dec 2023 20:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702584896;
	bh=Mc+SdiU5nAOdaGxQZhKcg/VaBJVp1eJjA2y2CgiCcoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JrC4hKScHDEqFGjJ4e9m7kgLcyIt1QfmOcI7NV+iy0VTwEKxGs2P3T0fka4fIz3wa
	 JpNk7i/v7Sx9JSn6XjFVxfLksPfvAAaWitW3Hh5FiL2QE269mRvnS89K/ocK9j6WTX
	 WwwMxDLgaKgaQDjoqlspbnCNRRE7JDIwL5ONpKDUdBX3HqqfXXe4dvRindOO687dvl
	 dadln2QTAQqpvF00yUMDuCtFCqjOdIkqbLEvi7pMmxQHTd4fswi+ka/685eXChrp6I
	 rvbMUsX4Gb56jVt5hLfTXjlw7wt528Y9qsao/BBWHhKelT07O+v2wgPnHC8Gkz0uHV
	 HOPVeOuYwcmCw==
Date: Thu, 14 Dec 2023 12:14:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: short circuit xfs_growfs_data_private() if delta is
 zero
Message-ID: <20231214201455.GP361584@frogsfrogsfrogs>
References: <a6a7bfa4-a7bb-4103-9887-63c69356d187@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6a7bfa4-a7bb-4103-9887-63c69356d187@redhat.com>

On Thu, Dec 14, 2023 at 01:28:08PM -0600, Eric Sandeen wrote:
> Although xfs_growfs_data() doesn't call xfs_growfs_data_private()
> if in->newblocks == mp->m_sb.sb_dblocks, xfs_growfs_data_private()
> further massages the new block count so that we don't i.e. try
> to create a too-small new AG.
> 
> This may lead to a delta of "0" in xfs_growfs_data_private(), so
> we end up in the shrink case and emit the EXPERIMENTAL warning
> even if we're not changing anything at all.
> 
> Fix this by returning straightaway if the block delta is zero.
> 
> (nb: in older kernels, the result of entering the shrink case
> with delta == 0 may actually let an -ENOSPC escape to userspace,
> which is confusing for users.)
> 
> Fixes: fb2fc1720185 ("xfs: support shrinking unused space in the last AG")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Seems like a reasonable addition...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 7cb75cb6b8e9..80811d16dde0 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -134,6 +134,10 @@ xfs_growfs_data_private(
>  	if (delta < 0 && nagcount < 2)
>  		return -EINVAL;
> 
> +	/* No work to do */
> +	if (delta == 0)
> +		return 0;
> +
>  	oagcount = mp->m_sb.sb_agcount;
>  	/* allocate the new per-ag structures */
>  	if (nagcount > oagcount) {
> 
> 
