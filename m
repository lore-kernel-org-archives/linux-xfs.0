Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92AE46D2DD;
	Thu, 24 Sep 2026 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790286274; cv=none; b=O7pW2oHHGuZFn9kD0/gfdu5bU4AI+XiWbu80xzMbkvH36eVWh+GvVjjfCeGS5q+y6LFaELY+e70fEDc/VjhgwL2fLCz5FHDQFTx4wGZTmLPZin8EXOrmVB9NAcOVf8xCcgV7FNyp91RWgi3ixm54TgyDEYtBgv+/ZD/DT0FvU3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790286274; c=relaxed/simple;
	bh=FYJdzWdy35EWvIaQfjc6mKGbCQ5/ubwW2SxQK4Z4N9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTjSYFGPZgX9zooo2NOdc9ovbuAbvbP2ufaEkapj/s09zk/kIyIQHJLalFfznh1SF9X+5zb4vIf5eBi5OdIUwSqONCI8dyJOjcEZXaJ7QqJkpnLxVaPzkz1Xl1jG1CAU0tar8G5rWTlFnoCXJYZfR/3oEdpF00N0gqm44gCpth0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FBq8CJwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FBq8CJwN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 64B4D1F000FF;
	Thu, 24 Sep 2026 21:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790286273;
	bh=sMBEXYozXHbNHle1TgCzeQRPHIw19XuqZrDcBOEOBYw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FBq8CJwN7DV3lZ076wvmXyKoF/MNF6C8eakX3qAsMza79lZM2NCFdK94Au7wqzd6I
	 KUcET1Kedi5NONFzE2XicYf3+0vAF6r/lfmJ3sQemn8SEEsTmU0vC7kAs+RhM2JFwm
	 NGqUisIEuMD5Q8LqDPbF38A63M0X7/S4G5KOJvzRkNOyQwggdCckTMV+vpDitctrRE
	 WnzlTI3WxMOCc4WOzcZKXBCD/VoG7Dy+XkmFi0yZQz04cTL8eMV7AsyhHGIAoFsdvK
	 M8jYcFBa2JEjj3Xqu0PYq4odvwvpQ0SNLpsKsfA4qXX+s8N8CCsyfz+9LFG01f/MMT
	 fhxV5s3FBZuiQ==
Date: Thu, 24 Sep 2026 14:44:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 04/21] xfs: add xfs_daddr_to_rgno and xfs_daddr_to_rgbno
 helpers
Message-ID: <20260924214432.GF2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-5-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:36AM +0200, Christoph Hellwig wrote:
> Translate from a disk address to the realtime group and group-relative
> block numbers.  This will be needed by the data checksumming code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index fca2eb74908c..f26e324f0de3 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -390,4 +390,24 @@ xfs_rtgroup_raw_size(
>  	return g->blocks;
>  }
>  
> +static inline xfs_rgnumber_t
> +xfs_daddr_to_rgno(struct xfs_mount *mp, xfs_daddr_t d)
> +{
> +	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
> +
> +	ASSERT(xfs_has_rtgroups(mp));
> +	return div_u64(rbno, xfs_rtgroup_raw_size(mp));
> +}
> +
> +static inline xfs_rgblock_t
> +xfs_daddr_to_rgbno(struct xfs_mount *mp, xfs_daddr_t d)
> +{
> +	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +	xfs_rfsblock_t		rbno = XFS_BB_TO_FSBT(mp, d) - g->start_fsb;
> +
> +	ASSERT(xfs_has_rtgroups(mp));
> +	return do_div(rbno, xfs_rtgroup_raw_size(mp));
> +}
> +
>  #endif /* __LIBXFS_RTGROUP_H */
> -- 
> 2.53.0
> 
> 
