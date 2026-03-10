Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3398226E165;
	Tue, 10 Mar 2026 00:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104229; cv=none; b=VAc1RGDkEVIWSOjQxyz8Lp7rNZT3adZnuT2Cytf2HZ9QKamu4u/Hg6i5mcP/dClxpW72p6OHmQ+tL2ijQgRTBNArXjzxS7V3gJL4eDpa7IrlhmWXtaO5byOhFdT5anhG6I51+qo39hdEvpECrxYA1IQ2QRv8qLvSUfEns2OO1FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104229; c=relaxed/simple;
	bh=wz9FtTAiGZesghj7C6sS86vSlnAC0bw6p2NQrxXfpWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QNlU7R+YyPY87SLu67mQGxLBQeyDaFUITf/BiTPb9Jftxpr0eVH5DjK5qS3Rlr+9i+9Fw1nwkIliqeIwPvKV1Cxj5zmu+Q5CnDI5472USp7k0EWOZh8p1Qqb0I1OSQ1gBTaz9TSkcEsYO2/ubDkyBDzpGtiAPltpPGKcjACdK+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2DUHIdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2DUHIdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928F2C4CEF7;
	Tue, 10 Mar 2026 00:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104228;
	bh=wz9FtTAiGZesghj7C6sS86vSlnAC0bw6p2NQrxXfpWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X2DUHIdd4HdTktdnXrVrH73GWKEILQj7xsjCIQO/YX++1DWtrf5DNumAu55sy2d0z
	 AJxrjiVzf4AWjkPbxIxqg6fvitbgMLjU7SnCITbvPA+RYHeQUViCWoxhsgquYc6+jD
	 5py8ayT2Y3s8WcjcEwZOwvuLXac9y+PeOfXhpQYiyLOaVzk0DGkPeSpcZkNHkyQpif
	 X3Ab15yAtquZA2sxOOwpXkQDR/bGVAkUfI6bfBwadyAMf8gfTVqDzM/59ZYkeEm1UE
	 OYgrdLK62q/jDdrAh1uNTzRNp1KrcMDZac/RUeHL0Gn19g2t7LnMtlJXEkk9bdhU/e
	 Q76tzqQ4f9O6Q==
Date: Mon, 9 Mar 2026 17:57:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 09/25] iomap: issue readahead for fsverity merkle tree
Message-ID: <20260310005708.GA6033@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-10-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-10-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:24PM +0100, Andrey Albershteyn wrote:
> Issue reading of fsverity merkle tree on the fsverity inodes. This way
> metadata will be available at I/O completion time.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/iomap/buffered-io.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index a335a18c307f..1d9481f00b41 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -593,6 +593,9 @@ void iomap_read_folio(const struct iomap_ops *ops,
>  
>  	if (iter.pos < i_size_read(iter.inode))
>  		ctx->vi = fsverity_get_info(iter.inode);
> +	if (ctx->vi)
> +		fsverity_readahead(ctx->vi, folio->index,
> +				   folio_nr_pages(folio));

Initiating merkle tree readahead before you start reading in the data
folios?  Ok, sounds reasonable, though the old-habits disk-using part
of my brain thinks "should we be allocating the merkle tree *before* the
data blocks?" to improve read bandwidth usage :P

Anyway we can sort through that later so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
>  		iter.status = iomap_read_folio_iter(&iter, ctx,
> -- 
> 2.51.2
> 
> 
