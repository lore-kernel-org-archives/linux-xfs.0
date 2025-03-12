Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714301EE7C6;
	Wed, 12 Mar 2025 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810504; cv=none; b=cJqcNHjVFIJuYYdkZsnnj5PK79naLsgNAyo35YeCuaCnzQkwrGiYLEzbXqRzmkVNI/ypZBCeA3VrV2Lrm6LJY/r+EgUynHFigqNU7lvA4xXL92bSz27tpUSj4zh6r9G0PtMcpzcNib65DrvHp5NmHdUaEiCPyntsqwe27+oeDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810504; c=relaxed/simple;
	bh=C9oFBihYBOJW8ZR++aW9cI3h9gpBwl/cJVOqaZFGjsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0Q9rfnRYe0tXzTl02pcJKxFknPQUkf6w0to1vjR2y8YgEHOaEaPmpf2JlN0WKRAOEZR8Q9dwsdnomn69tCscIBhwCltnNgOSOeKCCF0OdruKpTDXDN6URs5hJ5wqfeBNQkHRCkC8lS5WpMMTjfejKew+m57HtGKL1wi018xdY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZ4vd1x+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZ4vd1x+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE926C4CEDD;
	Wed, 12 Mar 2025 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810503;
	bh=C9oFBihYBOJW8ZR++aW9cI3h9gpBwl/cJVOqaZFGjsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IZ4vd1x+zK7dfdCHT3B5WuIUatOrgT+RJ26pZGSilpL9NaDeMabC5zS83iAzK79An
	 GbXZGZc9BSjBzUpbEwixgwqKEvfSn9xYpLNXdM4e64z70fgvfCuf0SNBzqZgW6BvuZ
	 RIMG0G4Vu0p+vKupTso55m2fj5rNqT61CTxcN6ytODSPeL5BAkVXAvqkaK9AMbcdeo
	 frniIPYMBoVr4UJt+KRsbgrNODeNyk6RNCSCv/Xk9Q3S1xlr61f6821MNQE1gX+4XB
	 eMyi+gzC43bNpMPlNN9uum5k647fu1IciNnZgkZX0eFru5p8vf7af2m+jta/xodVsN
	 Re8M4TknQJfTQ==
Date: Wed, 12 Mar 2025 13:15:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/17] common: support internal RT devices in
 scratch_mkfs_sized
Message-ID: <20250312201503.GG2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-8-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:59AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/rc | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 00a315db0fe7..5e56d90e5931 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1268,6 +1268,7 @@ _try_scratch_mkfs_sized()
>  	case $FSTYP in
>  	xfs)
>  		local rt_ops
> +		local zone_type=`_zone_type $SCRATCH_DEV`
>  
>  		if [ -b "$SCRATCH_RTDEV" ]; then
>  			local rtdevsize=`blockdev --getsize64 $SCRATCH_RTDEV`
> @@ -1275,6 +1276,12 @@ _try_scratch_mkfs_sized()
>  				_notrun "Scratch rt device too small"
>  			fi
>  			rt_ops="-r size=$fssize"
> +		elif [ "${zone_type}" != "none" ] ||
> +		     [[ $MKFS_OPTIONS =~ "zoned=1" ]]; then
> +			# Maybe also add back the size check, but it'll require
> +			# somewhat complicated arithmetics for the size of the
> +			# conventional zones
> +			rt_ops="-r size=$fssize"

Hmm, what happens if you pass -dsize=X and -rzoned=1,size=X?

Oh, you get a data section of size X followed by an internal zoned
section also of size X.

Might want to mention that in the commit message...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  		fi
>  
>  		# don't override MKFS_OPTIONS that set a block size.
> -- 
> 2.45.2
> 
> 
