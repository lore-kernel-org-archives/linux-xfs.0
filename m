Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAADE811E7;
	Wed, 21 Feb 2024 15:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708530821; cv=none; b=rgz+CnaHB2EHjy8+nknSGd1flV4+rhh2DZMDmOQX7zuxTvNFfLzDhw4DJ6h1uy9K91aGnNiOZWNDHdpmD+A3cxKk1CTriqs8gWbyHPGkZ27RA9coXcmHcqxMHqn+eLgX6LHDjGS6JLxoiOyLnzyjZIBOHwvgZbYeaafPUvHLZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708530821; c=relaxed/simple;
	bh=L8h6fmxX3pRDkloTW4YJmr4FZiEeI2L+eRYgyBcy7N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyA1cGNnIK+1e3pO01JyMf3dt5303xfD1lRpGJAveT9X9caKl2aYJ3c6MNGKt2Py02T09v1R52o6NiUMUlnTZJNwvosLwuvd73ztSeTav4bEioJATGb6LzdKPwCIjGJ4nexoUm1+DQBFqNdWmCj+IwRkGgXcHIUNXD1cL0rFEUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqfL7FvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqfL7FvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84619C433C7;
	Wed, 21 Feb 2024 15:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708530819;
	bh=L8h6fmxX3pRDkloTW4YJmr4FZiEeI2L+eRYgyBcy7N4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqfL7FvGsUcQAjDKHQYrJDdwtkj7XWbXmOXDiCrdL+GnYLvJ16HQMVuzoL1UciVXI
	 vHhwKguOAoaxO8Xh+AzZ/rPYQzVfozURTYFZglhBj5I+UZsHHN0MibLnYtA10RW5GC
	 SutLrEvM7I+W8OZtKDvWRXy37ec2s0yqRGwCM6ZwiDIEEHOLWmypH+yItCn44KCsTs
	 zOuumr+Qck5zg3Z3yG88dLlrPfLoIuZGgo1GbIvrAEXJWfhWd0PEBiyEJcPjwgTt+H
	 B5qqqCxBrv8psJRhNPzQTMomWZIoQWvJaoIafKUuYTtVpT48Iyzpn4J6UVkXlWDl8k
	 1SUbwf2O6Hcvg==
Date: Wed, 21 Feb 2024 07:53:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/449: don't run with RT devices
Message-ID: <20240221155338.GF616564@frogsfrogsfrogs>
References: <20240221063524.3562890-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221063524.3562890-1-hch@lst.de>

On Wed, Feb 21, 2024 at 07:35:24AM +0100, Christoph Hellwig wrote:
> generic/449 tests of xattr behavior when we run out of disk space for
> xattrs which are on the main device, but _scratch_mkfs_sized will control
> the size of the RT device.
> 
> Skip it when a RT device is in used, as otherwise it won't test what it
> is supposed to while taking a long time to fill the unrestricted data
> device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/generic/449 | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/tests/generic/449 b/tests/generic/449
> index 2b77a6a49..4269703f6 100755
> --- a/tests/generic/449
> +++ b/tests/generic/449
> @@ -24,14 +24,15 @@ _require_test
>  _require_acls
>  _require_attrs trusted
>  
> +# This is a test of xattr behavior when we run out of disk space for xattrs,
> +# but _scratch_mkfs_sized will control the size of the RT device.  Skip it
> +# when a RT device is in used, as otherwise it won't test what it is supposed
> +# to while taking a long time to fill the unrestricted data device
> +_require_no_realtime
> +
>  _scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1

Odd... this test only takes ~50s on my rt testing rig.

_scratch_mkfs_sized should restrict the size of both the data device and
the rt volume to 256M, right?  Looking at tot, it sets "-d size=$fssize"
and "-r size=$fssize", so I don't think I understand what's going on
here.

>  _scratch_mount || _fail "mount failed"
>  
> -# This is a test of xattr behavior when we run out of disk space for xattrs,
> -# so make sure the pwrite goes to the data device and not the rt volume.
> -test "$FSTYP" = "xfs" && \
> -	_xfs_force_bdev data $SCRATCH_MNT

Shouldn't this ^^^^ be sufficient to cause $TFILE and all the xattrs to
be allocated from the data device?  Or are they ending up on the rt
volume?

<confused>

--D

> -
>  TFILE=$SCRATCH_MNT/testfile.$seq
>  
>  # Create the test file and choose its permissions
> -- 
> 2.39.2
> 
> 
