Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAF1329C60;
	Fri, 10 Jul 2026 06:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783663852; cv=none; b=C0Nq5+75XMEGihEb7D15zH7AIDfErAosIZAHIRij8X20FB2QsotPFEbpNJV32Io12yCF6gcQ5scOHQPjUDy0fhIVWEURQsByVPlCdur0UsZWZKVnlZxPb9N3PQk4NZVbd6ikCPKCuHcNrk45XLMQiMCEsBqCPSbNpYFowsicvfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783663852; c=relaxed/simple;
	bh=JUb8HxHtlXTyTQ27bpiGqKmHKrlNu0sVvn57oxvKQF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aqgq9UyuS1o23i2PeqVhkQ5Y6AgdIskNt72AeomuD3QYDzntK7sFn37kz1DNX70C30qAoDcXgMEPSChvRo4Dyr/q76RMWDd1sMVcQcrUCJoJRgpH597NsoKfgX4yXzYxlsoG78JaBKvA9eY99jjfXKFW/eJSZ+vWiomnBXBQvvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXy/fhib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXy/fhib"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6F3D41F000E9;
	Fri, 10 Jul 2026 06:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783663850;
	bh=kgg81GxInWVhPevSpC4uTMhlqo47ViCg2BEmL6+GjI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kXy/fhib4n7fRupY2rue5RslZdsYSiIGY36PZkWuWq6OwCiBLMVY8xMDxgFkoYAUy
	 1estQdKx8Fg+QmWDeZ9M5khMwRvPGCj9gvxHTYHO9NP6OZJwynj2IAq/azx4I0NGb3
	 o1L1exhOUNvZWe59jHihYtJJOoB16tjryO869GlweWhNqpY9DRO3XkXazwjviBzqAP
	 RBTkn3z/H7e1lqbQuVtYcU7nXwgE9i5rxokNKCfxCuedzO9kiKuWZq77w2gaE4YwMT
	 rm9IszD/zyn2hCNxm9xXpEGnmpwFZREWhcGDVBImt3ICZ/n9/o+dil4VqCGuSF5eDG
	 lvFNxR8tAYKgg==
Date: Thu, 9 Jul 2026 23:10:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] formalize and fix disabling the RT subvolume
Message-ID: <20260710061049.GG15210@frogsfrogsfrogs>
References: <20260710052747.1841555-1-hch@lst.de>
 <20260710052747.1841555-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710052747.1841555-4-hch@lst.de>

On Fri, Jul 10, 2026 at 07:27:35AM +0200, Christoph Hellwig wrote:
> Various test unset SCRATCH_RTDEV to avoid dealing with metadata
> allocations for the RT subvolume in the main device or differences
> in RT subvolume behavior.  Besides being rather ad-hoc, this unset
> also fails to disable the internal RT zoned subvolume.
> 
> Add a _disable_scratch_realtime helper that not only unsets
> SCRATCH_RTDEV, but also disables the zoned allocator and with
> that the internal RT subvolume.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me now! :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/filestreams | 2 +-
>  common/rc          | 9 +++++++++
>  tests/generic/250  | 2 +-
>  tests/generic/252  | 2 +-
>  tests/generic/441  | 2 +-
>  tests/generic/484  | 2 +-
>  tests/generic/487  | 2 +-
>  tests/xfs/076      | 2 +-
>  tests/xfs/189      | 2 +-
>  tests/xfs/205      | 2 +-
>  tests/xfs/306      | 2 +-
>  tests/xfs/444      | 2 +-
>  tests/xfs/445      | 2 +-
>  13 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/common/filestreams b/common/filestreams
> index 2d83a3661b01..c5421ef3ff2b 100644
> --- a/common/filestreams
> +++ b/common/filestreams
> @@ -84,7 +84,7 @@ _test_streams() {
>  	# Disable the scratch rt device to avoid test failures relating to the
>  	# rt bitmap consuming free space in our small data device and throwing
>  	# off the filestreams allocator.
> -	unset SCRATCH_RTDEV
> +	_disable_scratch_realtime
>  
>  	# Skip these tests on zoned file systems as filestreams don't work
>  	# with the zoned allocator, and the operation below would force it into
> diff --git a/common/rc b/common/rc
> index 4947255479ca..d8d4d5292f8c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2435,6 +2435,15 @@ _require_no_realtime()
>  		_notrun "Test not compatible with realtime subvolumes, skipped this test"
>  }
>  
> +# Disable usage of internal or external scratch devices
> +_disable_scratch_realtime()
> +{
> +	unset SCRATCH_RTDEV
> +	if [ "$FSTYP" = "xfs" ]; then
> +		MKFS_OPTIONS="${MKFS_OPTIONS//-r zoned=1}"
> +	fi
> +}
> +
>  # this test requires that a specified command (executable) exists
>  # $1 - command, $2 - name for error message
>  #
> diff --git a/tests/generic/250 b/tests/generic/250
> index 605d7c8ade3d..32326114798c 100755
> --- a/tests/generic/250
> +++ b/tests/generic/250
> @@ -29,7 +29,7 @@ _require_odirect
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  fssize=$((196 * 1048576))
>  echo "Format and mount"
> diff --git a/tests/generic/252 b/tests/generic/252
> index 2ad0524c2037..2e462b61fce4 100755
> --- a/tests/generic/252
> +++ b/tests/generic/252
> @@ -30,7 +30,7 @@ AIO_TEST="$here/src/aio-dio-regress/aiocp"
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  fssize=$((196 * 1048576))
>  echo "Format and mount"
> diff --git a/tests/generic/441 b/tests/generic/441
> index cc370bea5052..c3a096926eaf 100755
> --- a/tests/generic/441
> +++ b/tests/generic/441
> @@ -47,7 +47,7 @@ _require_test_program dmerror
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> diff --git a/tests/generic/484 b/tests/generic/484
> index 0455efcb6000..e2fea8c6b18d 100755
> --- a/tests/generic/484
> +++ b/tests/generic/484
> @@ -35,7 +35,7 @@ _require_xfs_io_command "syncfs"
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> diff --git a/tests/generic/487 b/tests/generic/487
> index 364f7eb4c032..cc6c8f0e63d9 100755
> --- a/tests/generic/487
> +++ b/tests/generic/487
> @@ -40,7 +40,7 @@ _require_dm_target error
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> diff --git a/tests/xfs/076 b/tests/xfs/076
> index 2ea6459b0dbe..103ad7509e0f 100755
> --- a/tests/xfs/076
> +++ b/tests/xfs/076
> @@ -66,7 +66,7 @@ _require_xfs_sparse_inodes
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  _scratch_mkfs "-d size=96m -m crc=1 -i sparse" | tee -a $seqres.full | \
>  	_filter_mkfs > /dev/null 2> $tmp.mkfs
> diff --git a/tests/xfs/189 b/tests/xfs/189
> index 1770023760fd..aa9712afac35 100755
> --- a/tests/xfs/189
> +++ b/tests/xfs/189
> @@ -250,7 +250,7 @@ _require_no_realtime
>  _require_scratch
>  _require_noattr2
>  
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  unset SCRATCH_LOGDEV
>  
>  _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
> diff --git a/tests/xfs/205 b/tests/xfs/205
> index 73d51d8d602f..7d8c0e5e33dc 100755
> --- a/tests/xfs/205
> +++ b/tests/xfs/205
> @@ -18,7 +18,7 @@ _require_scratch_nocheck
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  fsblksz=1024
>  _scratch_mkfs_xfs -d size=$((32768*fsblksz)) -b size=$fsblksz >> $seqres.full 2>&1
> diff --git a/tests/xfs/306 b/tests/xfs/306
> index d48b753632d5..60c2b486f671 100755
> --- a/tests/xfs/306
> +++ b/tests/xfs/306
> @@ -26,7 +26,7 @@ _require_test_program "punch-alternating"
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  # Create a small fs with a large directory block size. We want to fill up the fs
>  # quickly and then create multi-fsb dirblocks over fragmented free space.
> diff --git a/tests/xfs/444 b/tests/xfs/444
> index 13c9de528ec8..949c5711e2c8 100755
> --- a/tests/xfs/444
> +++ b/tests/xfs/444
> @@ -31,7 +31,7 @@ _require_scratch_xfs_crc
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming free space in our small data device and throwing off the
>  # filestreams allocator.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  mount_loop() {
>  	if ! _try_scratch_mount >> $seqres.full 2>&1; then
> diff --git a/tests/xfs/445 b/tests/xfs/445
> index 0ea85ad018d6..2e9b6ca1be34 100755
> --- a/tests/xfs/445
> +++ b/tests/xfs/445
> @@ -42,7 +42,7 @@ _check_filestreams_support || _notrun "filestreams not available"
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming free space in our small data device and throwing off the
>  # filestreams allocator.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  # use small AGs for frequent stream switching
>  _scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1
> -- 
> 2.53.0
> 
> 
