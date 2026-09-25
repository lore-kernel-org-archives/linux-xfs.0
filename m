Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75963B27F3
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 22:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790375910; cv=none; b=ZP9kK9IG898pw6Sy0nMGGGVBGQl21MI+vVH/Ss5vH5pIAIF3ZNAamER0DoXueDNNwbdOaVpbbtZ0M7iAk+3C+GKbg6iy2S9VFFSMqC3KFJrBxxMxRaGb2p9gOoyQk7jvVjZypwXdHDCASGfp2owRlcltn/4wX3FGPY+kmzlL3PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790375910; c=relaxed/simple;
	bh=pzYyz1hbLSFn5SBjbAzcQ3qDUwekOqoAli7t5IA26bc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dNbkzYHvuaJJi3OGnIUrZGT1tMxN8u3XmobhPeA8yuko11Lq5IvYaG2Wpo5d4jZHc/xzuS2PsoOw45wgBQAzuRuuOlXQ5vZVStw2kQJps5f5ZtRD6So6SOeo2DNZfm3HuRxgRsger7vjfg/1JNeBdh6OWoEwhnyIeDdqNYmiopQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUgG+zB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUgG+zB2"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7328D1F000FF;
	Fri, 25 Sep 2026 22:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790375909;
	bh=Cz820vuqakOd+sVlUIlr1Qh4FPBmYYf2lk1NiTyaalg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AUgG+zB2VztQVbFFQjVKYzDiKKW9n0XGfsco/iJIZCG7kvkZKLp0bGhdIB9ea+Uqb
	 Jwpln47Rq3ERTb8dQty88PDNjnOPMdbnB7xVnXGa1ueO2/hbnFB07RbV2C9rQRlbvL
	 3B8Cw8tC/CXKXora+0pz0L8UMhQqxn8A8OpX04nNULffel+dHDXKuHLBJwzpMHX7sL
	 7fjVvY8y4Ah8k+0mQLN+R81tUwar8ekWE8uH4Jw6YCZnK/WhJiQ19gvIT4hvOEGPk7
	 yGaILfOd314Vux6XnJjY0/35qKv2ybWJyjhW/74Sx+PzfY3mVWaToOzfzdwMBdCJTw
	 Me25rI8nHZNJw==
Date: Fri, 25 Sep 2026 15:38:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] libxfs: make the size check in rtmount_init
 internal RT device aware
Message-ID: <20260925223829.GT2705364@frogsfrogsfrogs>
References: <20260925051336.2997014-1-hch@lst.de>
 <20260925051336.2997014-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925051336.2997014-6-hch@lst.de>

On Fri, Sep 25, 2026 at 07:12:51AM +0200, Christoph Hellwig wrote:
> Add rtstart handling.  This is currently masked by broken setup of
> the rtdev targp to the ddev one for internal devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Urrrk. :(
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 65dadb1a23f7..85e0b3402bb2 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -330,7 +330,9 @@ rtmount_init(
>  			(unsigned long long) mp->m_sb.sb_rblocks);
>  		return -1;
>  	}
> -	error = libxfs_buf_read(mp->m_rtdev_targp, d - XFS_FSB_TO_BB(mp, 1),
> +	error = libxfs_buf_read(mp->m_rtdev_targp,
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart) +
> +				d - XFS_FSB_TO_BB(mp, 1),
>  			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
>  	if (error) {
>  		fprintf(stderr, _("%s: realtime size check failed\n"),
> -- 
> 2.53.0
> 
> 
