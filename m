Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6406FDDC1;
	Tue, 13 May 2025 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747147046; cv=none; b=lxc7k7nZ6OZXwxXCX6vl/1i/x/Zr24Iw1eGak/3LHz8Jnu8OytSzHRbAivBuw7+1eAMJ6S+bt3etlUA8Gl/f5ihYizL0v/hTTd3ompB6oOI2b/89oRGxPb2dtoj+xEqLU6DQjuA9g4B7XVDZ/jJoKSzf4CHArsj+8bfWoKOxvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747147046; c=relaxed/simple;
	bh=vW56jGB4uEcKxY5NWzPWXC+YLcQnAyq/DoZAoaNjqec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1nJ28yHKD3IzVkuT1FPfz5rseWEVR1af2fcg/bvmWvudsFqHGggcHJWw5SLPt6mJfFtsscGhFP+IG4oQpXzBGx8Xf+f5fXHXRUBvKToqNYnPXII9uAsrAyYemFGLNeJNTKs7ppJ1jswD718t4iicHeq4PBAotKT6EvgCWZKdYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tv2eUeiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tv2eUeiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC16BC4CEE4;
	Tue, 13 May 2025 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747147045;
	bh=vW56jGB4uEcKxY5NWzPWXC+YLcQnAyq/DoZAoaNjqec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Tv2eUeiP3YFoI0sObjBQNR3v9AmATb2EVGeOpL2wom9B6+6qAO4poNumgroJ+0EKf
	 2HiD8EXGfjXFdn1SQldDRqE5EbyarG9Ft+UtdfYuY+DmfUwP/S9SakzT9rQCkNjR+a
	 uVKyMaHaA5NJTLaz+TpoXPU1nja2Olm+zv1TSBupYu7c/WTSIWkSM4z6/mdwaxzt8h
	 uolQCjjjGdWy7BvdKpcmAsA46EUCy34T7UBJV14UCVfJ2DF6iqPS6WNzKXlVMuqNy0
	 YFwoifB/uy2ym9Dw7up8PQBaC9lGmPngvj/SN0Tx1twXaL7Rq6fFzKtS4T7UbOgRxT
	 iJq4PsLb52Zsg==
Date: Tue, 13 May 2025 07:37:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: skip test that want to mdrestore to block devices
 on zoned devices
Message-ID: <20250513143725.GK2701446@frogsfrogsfrogs>
References: <20250513051933.752414-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513051933.752414-1-hch@lst.de>

On Tue, May 13, 2025 at 07:19:33AM +0200, Christoph Hellwig wrote:
> mdrestore doesn't work on zoned device, so skip tests using to
> pre-populate a file system image.
> 
> This was previously papered over by requiring fallocate, which got
> removed in commit eff1baf42a79 ("common/populate: drop fallocate mode 0
> requirement").
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  common/populate |  2 +-
>  common/xfs      | 14 ++++++++++++++
>  tests/xfs/284   |  1 +
>  tests/xfs/598   |  1 +
>  4 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/common/populate b/common/populate
> index 50dc75d35259..1c0dd03e4ac7 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -19,7 +19,7 @@ _require_populate_commands() {
>  	"xfs")
>  		_require_command "$XFS_DB_PROG" "xfs_db"
>  		_require_command "$WIPEFS_PROG" "wipefs"
> -		_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> +		_require_scratch_xfs_mdrestore
>  		;;
>  	ext*)
>  		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
> diff --git a/common/xfs b/common/xfs
> index 96c15f3c7bb0..4ac29a95812b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -772,6 +772,20 @@ _scratch_xfs_mdrestore()
>  	_xfs_mdrestore "$metadump" "$SCRATCH_DEV" "$logdev" "$rtdev" "$@"
>  }
>  
> +# Check if mdrestore to the scratch device is supported
> +_require_scratch_xfs_mdrestore() {
> +	_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> +
> +	# mdrestore can't restore to zoned devices
> +        _require_non_zoned_device $SCRATCH_DEV
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ]; then
> +		_require_non_zoned_device $SCRATCH_LOGDEV
> +	fi
> +	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
> +		_require_non_zoned_device $SCRATCH_RTDEV
> +	fi
> +}
> +
>  # Do not use xfs_repair (offline fsck) to rebuild the filesystem
>  _xfs_skip_offline_rebuild() {
>  	touch "$RESULT_DIR/.skip_rebuild"
> diff --git a/tests/xfs/284 b/tests/xfs/284
> index 91c17690cabe..79bf80842234 100755
> --- a/tests/xfs/284
> +++ b/tests/xfs/284
> @@ -27,6 +27,7 @@ _require_xfs_copy
>  _require_test
>  _require_scratch
>  _require_no_large_scratch_dev
> +_require_scratch_xfs_mdrestore
>  
>  function filter_mounted()
>  {
> diff --git a/tests/xfs/598 b/tests/xfs/598
> index 20a80fcb6b91..82a9a79208ab 100755
> --- a/tests/xfs/598
> +++ b/tests/xfs/598
> @@ -28,6 +28,7 @@ _require_test
>  _require_scratch
>  _require_xfs_mkfs_ciname
>  _require_xfs_ciname
> +_require_scratch_xfs_mdrestore
>  
>  _scratch_mkfs -n version=ci > $seqres.full
>  _scratch_mount
> -- 
> 2.47.2
> 
> 
