Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1972367D3;
	Tue, 29 Sep 2026 01:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645277; cv=none; b=twbcKnGMGZGgCkHbSN/XZi6Z17wuAWwc/Fs7cPNTTET2Hp7++lcP5Z2l7glMN3uT8nB02wbj8KYDyMrOhRS9XhaZ7DdKtDMxV7BOW9J6NjnW3uDVUmE8R9jMEdu3uiD7r73UIAmirz3SJG1I0+TUH3TyVQkR5W3Rdf3Zhvec6Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645277; c=relaxed/simple;
	bh=W0yUWpxzDN0NUKwSVqHZhupirjl8N8YpJpM5C2h80Cs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnAz4bzXGeVQ47lsD7+8OyARlwnMotA0jW2jdpofFNxwaFe7TVlGg2Cnw8LSrhUPfaXUp85WWX1pl5W76BEnuUKoqtyHx1neHHaar4t8NXwO4JWlPNkReEfIQiVF30P7uc7mI2J2AC5InRvLHxHu5hBJjE5BoexOi4pNTiBoIg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imxV00eh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imxV00eh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 907461F000FF;
	Tue, 29 Sep 2026 01:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645275;
	bh=GiIJHw5OFLIxxsQXkgJstCITFme/1+iBjXTmoooNbY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=imxV00eh6uCFSFr0pnNrkdm1Jg1HbHfPbnLiHHp7GWj2LL6SXbU/I/gpgLIW4R50C
	 j7gxDnCNkow6+EaqdC1W7/c9TYfouNrbBRqU1EepZtO6Z/ZdCErypU5Oty3wEsE128
	 RyIZnlBmYWpSHMiyqv4irqhFjXtjRPukLm9ETH8eav/y38N5NZ+RKzOmMWy9pZbpcq
	 a9SvAzugFzzh9dhI8n/YS9em855aMmYFSyk67OxcrvujwMQfQTea0BVCEUvrSH8CUY
	 m8f1YvgOjrVx1wsa6//2QwJUVpQsyWreW4vGUrzTBBCr5VOzagOPx/YMUzqG9jF8Qa
	 5IuQjUzpdaPQA==
Date: Mon, 28 Sep 2026 18:27:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/21] xfs: enable RT data checksums
Message-ID: <20260929012755.GC2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-22-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-22-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:53AM +0200, Christoph Hellwig wrote:
> All mandatory pieces are in place now, allow mounting.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.  I'll try to cough up an amendment to the ondisk metadata
documentation to go with this.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 1be3d21910a7..8b269fd3ed9f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -384,7 +384,8 @@ xfs_sb_has_compat_feature(
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_REFLINK| \
> -		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> +		 XFS_SB_FEAT_RO_COMPAT_INOBTCNT | \
> +		 XFS_SB_FEAT_RO_COMPAT_RTCSUM)
>  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
>  static inline bool
>  xfs_sb_has_ro_compat_feature(
> -- 
> 2.53.0
> 
> 
