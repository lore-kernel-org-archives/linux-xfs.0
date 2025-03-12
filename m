Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34631D5CD4;
	Wed, 12 Mar 2025 20:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811165; cv=none; b=LxRuaBciOZ38M8EaFr+yLNaYpO0OhEjhhnhDW1zj78GShRfFzsoobgfCiVdSIjKgzAxjvCzhgtZ648iXVnhi4u6rqc7qvfWAwiDXVXxA5QOO/rNtAdGWea40pSpd8qe/JxIFVtKQJAXcHXJd7nl80besoC5gjbAX4sN+r4Lqxmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811165; c=relaxed/simple;
	bh=XRVg3iP+L3SRL8579DKSriXXZTmJzjhLh0wpjqbfNbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MoQTclj2fww0z+QH+hqLVPiM2YAOadMYAmwWV4CzRdbtl3oJmmQK91zeXwnlDOafuXWRWHuJTt6kI0GHq7AuMOkoPZpkUoYHgrYOEfQ9siPRvPFYAa9mqshTw+1uglNGD42dSE0fD3KXUGHfQkWvgIZQUlMEu9QDWLlgnh4fY2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fwcQhpqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fwcQhpqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1F7C4CEDD;
	Wed, 12 Mar 2025 20:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741811164;
	bh=XRVg3iP+L3SRL8579DKSriXXZTmJzjhLh0wpjqbfNbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fwcQhpquIzUB5e0mqLlDTcbm8juTaIpfd6INZj1yLHIj+6SwwQO8awy6vssCEAEFc
	 PtynjdubUGnOZWlcZXONIzzxxodHnVkDqebbhlEcfLctCgpECKLevCFigd+HVzzmBM
	 R+beqps82im1xc28p1ZmkcAeeNV4uGvtsMzpOa7XHqHRKWkv1IoY3dHFQTV6/I78mf
	 Nx0STVoUHd1HcB0woeZgqOpUuwztGg7iqueThMdw26OQ1nLY0jSH2OWSMGsmyArDmY
	 30lH5n4I7qLNdzeL1027geDtM/mWSGx3wL4Bn/qg6DcJWvGyariTOUo139Nax4KrtF
	 oc/sNLdMuVpBw==
Date: Wed, 12 Mar 2025 13:26:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: skip filestreams tests on internal RT devices
Message-ID: <20250312202603.GO2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-15-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:06AM +0100, Christoph Hellwig wrote:
> The filestreams tests using _test_streams force a run on the data
> section, but for internal RT zoned devices the data section can be tiny
> and might not provide enough space.  Skip these tests as they aren't
> really useful when testing a zoned config anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, assuming you don't just want to kill filestreams entirely :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/filestreams | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/common/filestreams b/common/filestreams
> index 00b28066873f..bb8459405b3e 100644
> --- a/common/filestreams
> +++ b/common/filestreams
> @@ -108,6 +108,11 @@ _test_streams() {
>  		_scratch_mount
>  	fi
>  
> +	# Skip these tests on zoned file systems as filestreams don't work
> +	# with the zoned allocator, and the above would force it into the
> +	# tiny data section only used for metadata anyway.
> +	_require_xfs_scratch_non_zoned
> +
>  	cd $SCRATCH_MNT
>  
>  	# start $stream_count streams
> -- 
> 2.45.2
> 
> 
