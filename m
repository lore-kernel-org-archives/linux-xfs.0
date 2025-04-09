Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A195277030
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 19:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744226022; cv=none; b=VPdcWUT0C55aQo5qliwD4db4xKhETsA7TPx+UWQ9cL35Xq2Z6pGJGLpBjYpdZNJdlfkzPc3zx9jMGhX9yS/ySQz1mWVLitwT2JT3ZhWYGtIwfGktAKwrClGLIvOLRfsjK+nuFVhlWVwJ7/slQoif+uHoaHy0QwU3+Siay9ZaCZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744226022; c=relaxed/simple;
	bh=fhutdq0FBYAM9tmP31p8D5moHsxYby5LWWpP6cIbQXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKPv+1j2nnOXBG8aVoyVemJWISWITprvSpo2MtqsiY2GbQcZ6pCJ1J42aiCeM+c41uzvabSfFieJ0ljq8qSMFJNN2Zsl7MfCZs/D5pAaBODEKuEzClGaaV9BEBGK6f8CLluuy9CJWPOlem0WEfHQHf6Bf7kibxTxjdfZKKe2J2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5RQszhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5RQszhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D91C4CEE2;
	Wed,  9 Apr 2025 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744226021;
	bh=fhutdq0FBYAM9tmP31p8D5moHsxYby5LWWpP6cIbQXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F5RQszhP3CjWbrZv09AvoBL9fv42eJq5o1uNrnQcwpvbhOdFzSWG+41bQ4wt7g/9u
	 3PHc63KNqhHUvz2647DSCWmsNykalmmd8RjMG1M48Nndkn2cuPcrWspP18UtLBKTUY
	 MYnExFJuPhEHT5f+uY9g3dh5nSLEB9XxRUc1+P3xxsdRY2Wjs+BFdBfqeb7VI3wk+v
	 GHB+cmmeYr01Ao0IU5N1U3ZiNZ+zoGGnIZEpn7+sNBOPBB/ibgsoXLKY6irmECuw4D
	 piFYKLHEFNJuR+8jNcU+rrXAg1NKCVe7TN2L23ttVw2qx/5Iw0XK3ZUa/F8TViNr1A
	 dwzXVR8ZHngSQ==
Date: Wed, 9 Apr 2025 12:13:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/45] man: document XFS_FSOP_GEOM_FLAGS_ZONED
Message-ID: <20250409191340.GL6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-37-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-37-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:39AM +0200, Christoph Hellwig wrote:
> Document the new zoned feature flag and the two new fields added
> with it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  man/man2/ioctl_xfs_fsgeometry.2 | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
> index 502054f391e9..df7234e603d2 100644
> --- a/man/man2/ioctl_xfs_fsgeometry.2
> +++ b/man/man2/ioctl_xfs_fsgeometry.2
> @@ -50,7 +50,9 @@ struct xfs_fsop_geom {
>  	__u32         sick;
>  	__u32         checked;
>  	__u64         rgextents;
> -	__u64         reserved[16];
> +	__u64	      rtstart;
> +	__u64         rtreserved;
> +	__u64         reserved[14];
>  };
>  .fi
>  .in
> @@ -143,6 +145,20 @@ for more details.
>  .I rgextents
>  Is the number of RT extents in each rtgroup.
>  .PP
> +.I rtstart
> +Start of the internal RT device in fsblocks.  0 if an external log device

external RT device?

--D

> +is used.
> +This field is meaningful only if the flag
> +.B  XFS_FSOP_GEOM_FLAGS_ZONED
> +is set.
> +.PP
> +.I rtreserved
> +The amount of space in the realtime section that is reserved for internal use
> +by garbage collection and reorganization algorithms in fsblocks.
> +This field is meaningful only if the flag
> +.B  XFS_FSOP_GEOM_FLAGS_ZONED
> +is set.
> +.PP
>  .I reserved
>  is set to zero.
>  .SH FILESYSTEM FEATURE FLAGS
> @@ -221,6 +237,9 @@ Filesystem can exchange file contents atomically via XFS_IOC_EXCHANGE_RANGE.
>  .TP
>  .B XFS_FSOP_GEOM_FLAGS_METADIR
>  Filesystem contains a metadata directory tree.
> +.TP
> +.B XFS_FSOP_GEOM_FLAGS_ZONED
> +Filesystem uses the zoned allocator for the RT device.
>  .RE
>  .SH XFS METADATA HEALTH REPORTING
>  .PP
> -- 
> 2.47.2
> 
> 
