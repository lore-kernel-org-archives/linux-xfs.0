Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B31DE4CE;
	Wed, 12 Mar 2025 20:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741809914; cv=none; b=TXjCxGnufCAxNTsH87oB72vdJapUM9YjNWkgdq7hUNRSdeyHyVhzjGdLX69prHEnjx9huJCsJgwV599WVgiLaO7xq6ip9sp5DDCcqYti6lv5FWT2wE02DVZjiavQN2r97f/j/v2kitY6SuS06O/RAUclx8Fkh9RMnl8s+CoC1lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741809914; c=relaxed/simple;
	bh=E5Ev4FVW+jPVZtVG4xxa3T70uDsHYPEkb0BZRIWsFKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujKI2f4cCGPG0F13/359H0/gKCu+I56qg/ZxvBIe8E3Gw5RU30XI+lGWN0Z9tKVext6y0siatCwE1ggEKcCZwPNHZ34+Ine6Ri4HhN2yKlJulyZoMCBuXDkpiYlx0TTL6DMVuqAQOdTTiZ1Uk910lri+3ntS4uYHl849VoFaiTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csF4Ab4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csF4Ab4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6178EC4CEDD;
	Wed, 12 Mar 2025 20:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741809913;
	bh=E5Ev4FVW+jPVZtVG4xxa3T70uDsHYPEkb0BZRIWsFKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=csF4Ab4VRtS19dzDxdqB+Uv/KTUlwk8GcYSTG+B46eryCiftdJ1rKsx388tVVpb82
	 fipar1nk5kGzdKj3ErBfbfjGjIgsdLTRwzAiNa0YhlU61U0h60wizc1v4OToWLiocu
	 dR83jjqtjy44SQkgXZZOLVMQ5NeJo1Mx5euVwlEWj46SE6x3hUt2sC5viFSgjHCAFa
	 fE4Qk6pc3x3/Dg2rtEUy8RnwLX1AjBPyTKRfswRKzz5Gypn3d50bbITAIbUHX/DkA7
	 y5IWLSYGqfmLz3Do4WlfJmUfxYKnLkya7DAfEkNp+S3O+OVkS3CIkCMO/SivKgnYI4
	 0qHuQl6/SNbZw==
Date: Wed, 12 Mar 2025 13:05:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] xfs/419: use _scratch_mkfs_xfs
Message-ID: <20250312200512.GB2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-3-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:54AM +0100, Christoph Hellwig wrote:
> So that the test is _notrun instead of failed for conflicting options.

Which options are those?  I'm assuming that you're forcing -r zoned=1?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/419 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/419 b/tests/xfs/419
> index b9cd21faf443..5e122a0b8763 100755
> --- a/tests/xfs/419
> +++ b/tests/xfs/419
> @@ -39,7 +39,7 @@ $MKFS_XFS_PROG -d rtinherit=0 "${mkfs_args[@]}" &>> $seqres.full || \
>  	echo "mkfs should succeed with uninheritable rtext-unaligned extent hint"
>  
>  # Move on to checking the kernel's behavior
> -_scratch_mkfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
> +_scratch_mkfs_xfs -r extsize=7b | _filter_mkfs >> $seqres.full 2> $tmp.mkfs

Yeah, seems fine to me -- if we didn't get the extsize=7b then the test
would have aborted anyway.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  cat $tmp.mkfs >> $seqres.full
>  . $tmp.mkfs
>  _scratch_mount
> -- 
> 2.45.2
> 
> 
