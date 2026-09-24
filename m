Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB04BFE64
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 20:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790281766; cv=none; b=ZXxAzCqEQTdRZxBspVb3/AZfpzxKhVGxN54v8MSoH+C41sgZ+CPslaf7cFP2G0YXy1b1nITU4n/p1E+fixNg39k/En3jupPtEhBPpgrNzl78VZCOR2NHgg9A5bpZEdNWG+TdM2Xur9c6GzB3Om2JOy4twwzGaaeu+pWf2X6lRWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790281766; c=relaxed/simple;
	bh=uGXtP1+1vjBpSPcxRoZfpPpyfJLveQZ3TJhu0ZggWEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsvUNX+wdPZrLvCut7/XurhiD7glVgODK5Cvn2D11jJ32yKV3oqTTW7zLVEEz2VeFuAvMzW98sTRM7yJ+pBJN0t8/H6Pk8WsQh3zZU7I33wYQHnIB7L7HSYoJDZP2RsIy4bKlZaWteeTRdTAJ92Z0m5HixinshzgxwdYDqzfdg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dza4FgET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dza4FgET"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 116C31F000FF;
	Thu, 24 Sep 2026 20:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281761;
	bh=hXj9QVJ2Lb8QWa9HQG0LeG34j+wOwG3eUqpDmtwmyl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dza4FgETV3wzepiq8PS54b3EsAuTFnTCQdEc/Sqdm714Rw01AWLpH4s0mmGor/sVb
	 F+xR6+GkJ53Mm/OVoXKoy3Qy4QplKdLVEFfe/OAG4zBodYSS0TYHE3DyOQtbXoWK8x
	 hrVvU1wA/4YbIPYBcfqr1Zp89YDkIW0bSKYZifIsqPCfjRTRtfYdoqfDez+vei7PfJ
	 dnPUbnIm9vhrkLAXukSYkrG63TG3hu2MbaP5MtIBc7dZ83M3JTXjeoPiUUePDAr9hC
	 eTJxQbtyxH+f1JZI1U0+nsZnH/gnjeh1ThMkoZVAhoAVPE7Kx0Wu0FzUg6B5WiS17h
	 wT5XsGZf/jgQQ==
Date: Thu, 24 Sep 2026 13:29:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: calculate end_fsb later in xfs_zoned_fill_srcmap
Message-ID: <20260924202919.GY2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-10-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:10AM +0200, Christoph Hellwig wrote:
> xfs_trim_extent doesn't need the updated end_fsb as it already is
> limited by the smap range.  Move the end_fsb calculation later to
> prepare additional reasons that could reduce the smap range.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Make sense.  Constricting *end_fsb to the smap and then trimming the
smap to *end_fsb is (for now anyway) commutable.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7bc17f179be7..6701be9325ef 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1613,8 +1613,8 @@ xfs_zoned_fill_srcmap(
>  	/*
>  	 * There is a data fork mapping, only map until the end of it.
>  	 */
> -	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
>  	xfs_trim_extent(&smap, offset_fsb, *end_fsb - offset_fsb);
> +	*end_fsb = min(*end_fsb, smap.br_startoff + smap.br_blockcount);
>  	return xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
>  			xfs_iomap_inode_sequence(ip, 0));
>  }
> -- 
> 2.53.0
> 
> 
