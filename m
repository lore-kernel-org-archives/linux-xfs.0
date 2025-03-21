Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF1E18DF6D;
	Fri, 21 Mar 2025 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742570315; cv=none; b=O1W8A88hR1j8tE/vZ3a3mCovYCUnvYz4f9cvrNaj0O6R5LJzKoATsLrRGSXUamrYL3Z4VOncT67DT+W1l5KqOQlxLg3FQnOSFz4p+L+rHvyhfKFdQUeUcOQPgWvY4WhXw0isPjV5EE7sNANlzKbaVUs84NnjYW1y3oc4zbUmuVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742570315; c=relaxed/simple;
	bh=+VqzibmBED6oxQTvyO4zJnXHd65WOWYvmJucCv0snKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe4tUfSqgfB5zs/LuaTFSOQ0lZmSBIXW9qhwd/b95eBOBYOPKv11KdcouTNmvixh0U9ZKPKWL2FN7X5Q0G4Q/6iM5L7deSa5pqVU7CLZEgVwmUWP74E0B4VY4Vkk6Slaf+0KPXaxU4oTtcvn2mjeakLAnTYXbQVr0a+NnEqRzBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7+Gd8PG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7+Gd8PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A891C4CEE3;
	Fri, 21 Mar 2025 15:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742570313;
	bh=+VqzibmBED6oxQTvyO4zJnXHd65WOWYvmJucCv0snKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7+Gd8PGcGWM53A9uiH0ki0J14CRfmv52qg55Kuf58GslgYdZuo281FjvSwEXnskh
	 1EobB3UTxu/36qnoy1vtyPtVDIeXDLkxPkbUB5Gv79Kru3yGm0v1BwfHpV8X80pK3Z
	 6DqnnMJgADC6HchB+dNnx+Cjlu1t+GJmJjwsuxGQpojZSAIkDc4KIhig3Z2cYEAU8P
	 DdaTvfvkUPdT4cvjh5ceX0iNjQrQD4o422KI8k4QXqYGlCGGBSzi4lHIPUTzBzu864
	 Vtk35YUg0iuoNlbQ59NCR5ISGEevCEe0pvC1wkiPf5ZD9fxlKHXPc8JBBEOlUuP3SE
	 5tC+eYd5jcZzw==
Date: Fri, 21 Mar 2025 08:18:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: handle zoned file systems in
 _scratch_xfs_force_no_metadir
Message-ID: <20250321151833.GG2803749@frogsfrogsfrogs>
References: <20250321072145.1675257-1-hch@lst.de>
 <20250321072145.1675257-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321072145.1675257-8-hch@lst.de>

On Fri, Mar 21, 2025 at 08:21:36AM +0100, Christoph Hellwig wrote:
> Zoned file systems required the metadir feature.  If the tests are run
> on a conventional block device as the RT device, we can simply remove
> the zoned flag an run the test, but if the file systems sits on a zoned
> block device there is no way to run a test that wants a non-metadir
> file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 3663e4cf03bd..c1b4c5577b2b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2049,6 +2049,12 @@ _scratch_xfs_find_metafile()
>  # Force metadata directories off.
>  _scratch_xfs_force_no_metadir()
>  {
> +	_require_non_zoned_device $SCRATCH_DEV
> +	# metadir is required for when the rt device is on a zoned device
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
> +		_require_non_zoned_device $SCRATCH_RTDEV
> +	fi
> +
>  	# Remove any mkfs-time quota options because those are only supported
>  	# with metadir=1
>  	for opt in uquota gquota pquota; do
> @@ -2068,6 +2074,12 @@ _scratch_xfs_force_no_metadir()
>  	# that option.
>  	if grep -q 'metadir=' $MKFS_XFS_PROG; then
>  		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
> +	fi	

Dumb nit: ^^^^^^ extra space here

> +
> +	# Replace any explicit zonedr option with zoned=0
> +	if echo "$MKFS_OPTIONS" | grep -q 'zoned='; then
> +		MKFS_OPTIONS="$(echo "$MKFS_OPTIONS" | sed -e 's/zoned=[0-9]*/zoned=0/g' -e 's/zoned\([, ]\)/zoned=0\1/g')"

With that fixed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		return
>  	fi
>  }
>  
> -- 
> 2.45.2
> 
> 
