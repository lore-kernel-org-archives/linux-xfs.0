Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5B3D81;
	Wed, 12 Mar 2025 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810795; cv=none; b=seOOCIBKNKHkVuWjkTlnB/FIzuo+ThHadnRf+XB32x34oQThCWSHqQzswHJl9LyOHyPdLldBxo6h67EsGGLtHlfLk2G0gC9TyYteFKVFDCtMAt4HWNeuZNuWqaLfQGrQfFpOja+bY4lOJPrux3rlqM6/5fsMU5i1+ocIgUxcRK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810795; c=relaxed/simple;
	bh=PsKuGOkxhHWcpmUZyPuGaR4q3n+plqeuir8KzenDx5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dev7UV7OpWBPljZ9p3EL4ncY1pU25J6LpOPVh8Fk+cglTgp9xMa77rPoOr/a3Uag7nkcI10bxS5cTIyU7+oXHDdTx7yCKfwTV1gkpjjqBZyVqGRpbkRwZgOmoBjK5miearkf8GjajmXEKWulW3ahRk1LEWMq+A+g1j/eW5wGG54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZMvSEVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZMvSEVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C45DC4CEDD;
	Wed, 12 Mar 2025 20:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810794;
	bh=PsKuGOkxhHWcpmUZyPuGaR4q3n+plqeuir8KzenDx5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kZMvSEVRRsG0yB3raNnShj8m7iR+Vsgt+9rE5lG26D1D63lTpJh6QVEKKCkR0sJA7
	 raRXDYWgZm0MpuTQ5bmLoHBHTck+Xk36Cicf2W1XK91IqAfYMCYD36sw/FnKjAjzfO
	 vlNpTEK0n5NAKuvWItlct36ErfymEnRSF3StvDgQuGKRrihq7D6Jm9W3sEkfTvnLWW
	 2IYTkTJZWMafkZFz2sgQxCnPJN522bTDYkkph/AKnwNvjyNefohDZ/w3I3BZp5pxjR
	 d39G6FtDTRJsAJGWcHis5iw3kK3AYk4mmjtpn/F3nhCqPsdggnPdMyE8lJ/q6VrQag
	 uH2NmcFNUzY1w==
Date: Wed, 12 Mar 2025 13:19:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/17] xfs: add helpers to require zoned/non-zoned file
 systems
Message-ID: <20250312201954.GJ2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-11-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:02AM +0100, Christoph Hellwig wrote:
> Looking at the max_open_zones sysfs attribute to see if a file system is
> zoned or not, as various tests depend on that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/xfs | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 807454d3e03b..86953b7310d9 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -2076,6 +2076,33 @@ _scratch_xfs_force_no_metadir()
>  	fi
>  }
>  
> +# do not run on zoned file systems
> +_require_xfs_scratch_non_zoned()
> +{
> +	if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
> +		_notrun "Not supported on zoned file systems"
> +	fi
> +}
> +
> +# only run on zoned file systems
> +_require_xfs_scratch_zoned()
> +{
> +	local attr="zoned/max_open_zones"
> +	local min_open_zones=$1
> +
> +	if ! _has_fs_sysfs_attr $SCRATCH_DEV $attr; then
> +		_notrun "Requires zoned file system"
> +	fi
> +
> +	if [ -n "${min_open_zones}" ]; then
> +		local has_open_zones=`_get_fs_sysfs_attr $SCRATCH_DEV $attr`
> +
> +		if [ "${min_open_zones}" -gt "${has_open_zones}" ]; then
> +			_notrun "Requires at least ${min_open_zones} open zones"
> +		fi
> +	fi
> +}
> +
>  # Decide if a mount filesystem has metadata directory trees.
>  _xfs_mount_has_metadir() {
>  	local mount="$1"
> -- 
> 2.45.2
> 
> 
