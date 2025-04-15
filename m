Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A4111BF
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 00:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677379; cv=none; b=qa5vM31CwuqMobMPutmrsd+QYMMDGsvcncStJ298zVFp079jr9shK9ghZEJDQiZUri5Ud5hVXampOw2P+qqOi2aDAvMiV6T7kISWhcYqolJU8fCp6aiUXmXyt/O9YJ4b4KrOFx3A97oP5mS20gBGQZdl8WF+DSVZwM3WX7BFwWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677379; c=relaxed/simple;
	bh=M03un8Kv5zNX2dWkWSKVGPeSnsfeznKmGtfa7Mtoyl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mA9hzMsL1JSE+NrQdDQzckO7v2jJq+ZweyytTGYPemXUMnCsklGb4vw+nm5+2UQasQbigBqqfP/4w5UQVbTPRDuS/Vdvs/pKe6qaUeflIQXNoOAR+b28yBETkXCgnpzXoQ2+0Nr7ZKw3g9ic0gTpEGIITe0IQxfabyfA27t6RbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kL9KlN+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kL9KlN+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF934C4CEE2;
	Tue, 15 Apr 2025 00:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677379;
	bh=M03un8Kv5zNX2dWkWSKVGPeSnsfeznKmGtfa7Mtoyl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kL9KlN+cHQ+GBGNdNAjSbmVd5iF3dzEsISRPA+pGZsfLtZn19BJi1/Jfg/ofVZtPJ
	 kdlu0pK5iBUtrteyytyK0ZFg3HSGtPeSWt3xf318+KUG+vsOBQ2k0N7SRzfqjuxYvv
	 iLYGiiTR95HwXvc0pH6UJ6o2WvWPceCLc8P8eweTuX9kJRRn438NsTHZNL6dX0pg3q
	 51XsUhnqvxSoBhjbCJJ4WFRpesLlVtE8B9J5rQchnMi1Sav5prVpGvHPVsJFRi6L8g
	 qRjNtleEdlIVAWPM3VS3RQFzI9fA3Y8VVtmZnTyGxVHLHhsabT6NJyd6EG4vb3EZsI
	 KxUNEf35nC9ug==
Date: Mon, 14 Apr 2025 17:36:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] man: document XFS_FSOP_GEOM_FLAGS_ZONED
Message-ID: <20250415003618.GI25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-37-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-37-hch@lst.de>

On Mon, Apr 14, 2025 at 07:36:19AM +0200, Christoph Hellwig wrote:
> Document the new zoned feature flag and the two new fields added
> with it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much better,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  man/man2/ioctl_xfs_fsgeometry.2 | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
> index 502054f391e9..037f8e15e415 100644
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
> +Start of the internal RT device in fsblocks.  0 if an external RT device
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
