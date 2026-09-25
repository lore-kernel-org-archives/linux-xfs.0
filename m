Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A183672A8
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 23:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790379118; cv=none; b=s06sGPg8UbB94yenv+EkrGf5DZrbMSTFyfq8ZcQVRa0ahqoWYG1O8JEUm9DtYLXaI4fd52WgqTGgkQXlIioNjl0CkzFHiFhzaBJrP2tZznmuFCWvKUUO9txB3eTCEJRKu/zjjg7trpqAjkj80N8viyyJ+kBz1m2lGIdvdZoMbXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790379118; c=relaxed/simple;
	bh=paivA9Zyld5/P8U0oPzI7mEOnTgvIqeHDO5DjT8hCTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fa6Q/wJ5hehF0EremeGTTkQfaqM8TVXKXV8TccZ5J+WXaRFp8f+VI3xxMtJ9KJQJs3j1n8OSt1V09e0zsIDsRGRsE7RfqnakvWsIPn18t+YfFY+KV2FILQwjxKH8nV2p0kqoushiEfDba1BZJ/Z35LMKR5frZiDdla5rBiJAOIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frIFVpz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frIFVpz6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 976C61F000FF;
	Fri, 25 Sep 2026 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790379116;
	bh=qXM36IvMCYydFGTQgw+UimdxJM0milW/6w3kWc2qy+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=frIFVpz60u3NtSgp6RZ8H6e2x/KS0j7hX8E6Df1QhECzyt2jZwtj9GyzZgQXh4Yua
	 uhjfveilq+IExPZVrmjbAjBTL+dXfEKTLX/ZDc12us6FKWHrIEW0Lw9+s/U8+PV8I9
	 oLm9CQgwR/Ua3heR5eLuAreLvNS1CPq2B92z0gItglWki8MXkvLlbFFoeSuXZL2bU9
	 +m6KtUItz8piXNpEUNWpnAqbfn/lwR3aHP7igQpIpc3g4q+DoRTUAhysJ48f9428hF
	 Wr3+t6IV+81v4aqqtEPEPIaWvZb6uKOFSkeB7kP5gpxoPWOp2QGDENY89d/nCZq8Ov
	 LfmGhfuki06Gg==
Date: Fri, 25 Sep 2026 16:31:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/32] man: document the rtcsum geom fields
Message-ID: <20260925233156.GL2705364@frogsfrogsfrogs>
References: <20260924100512.2733748-1-hch@lst.de>
 <20260924100512.2733748-27-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100512.2733748-27-hch@lst.de>

On Thu, Sep 24, 2026 at 12:04:16PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  man/man2/ioctl_xfs_fsgeometry.2 | 31 +++++++++++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
> index 6d30610b71be..97216df7525b 100644
> --- a/man/man2/ioctl_xfs_fsgeometry.2
> +++ b/man/man2/ioctl_xfs_fsgeometry.2
> @@ -52,7 +52,10 @@ struct xfs_fsop_geom {
>  	__u64         rgextents;
>  	__u64         rtstart;
>  	__u64         rtreserved;
> -	__u64         reserved[14];
> +	__u8          rtcsum_type;
> +	__u8          rtcsum_blklog;
> +	__u8          reserved_pad[6];
> +	__u64         reserved[13];
>  };
>  .fi
>  .in
> @@ -159,8 +162,32 @@ This field is meaningful only if the flag
>  .B  XFS_FSOP_GEOM_FLAGS_ZONED
>  is set.
>  .PP
> +.I rtcsum_type
> +Type of RT data checksum. This field is meaningful only if the flag
> +.B  XFS_FSOP_GEOM_FLAGS_DATA_CSUM
> +is set.
> +The following values are defined:
> +.RS 0.4i
> +.TP
> +.B XFS_CSUM_TYPE_NONE
> +Not data checksum.

"Data checksums are not enabled."

> +.TP
> +.B XFS_CSUM_TYPE_CRC32C
> +CRC32c as per NVMe.

Just for my education -- crc32c as per nvme is the same as crc32c
everywhere else right?

--D

> +.TP
> +.B XFS_CSUM_TYPE_CRC64
> +CRC64 as per NVMe.
> +.TP
> +.RE
> +.PP
> +.I rtcsum_blklog
> +log(2) of the RT data checksum block size.
> +This field is meaningful only if the flag
> +.PP
> +.I reserved_pad
> +and
>  .I reserved
> -is set to zero.
> +are set to zero.
>  .SH FILESYSTEM FEATURE FLAGS
>  Filesystem features are reported to userspace as a combination the following
>  flags:
> -- 
> 2.53.0
> 
> 
