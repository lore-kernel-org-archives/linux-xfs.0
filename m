Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E23E1692;
	Tue, 30 Jun 2026 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782844821; cv=none; b=MW/KIWh/Jtg6rK3CEwtWS+G46l87+8qnTbq37PuUnaKG/9v6nwk3YaS88PDfxCWmXXa125csFoJsWv9R34rxTrK1czTCIVnY0j3QRxi6+zXc6FcV0cYbvUlQ7MI/ofH0kxwkn3DhSe63BiaeXh41pCCZxFLkJDnKUzJQ83ljCF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782844821; c=relaxed/simple;
	bh=rbUgvVufPGNjat2ny38shz9giGbv7u0tMuwAtcMhB4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LprXrZDZ30G7PJDwQiaB9Ick+wi5hO0xk2CBkV24qEgccLOblBGVcxelt48uT8tTVC5xmN4Z4fN4QvOIYriSZegxtzr3mp31m7hIh6gPOijEYEci8mL3zqlL/dvWZm1aeHuJDeepyZ8QllI08mLSKsm1/GrbZfceLkRLM70UUqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cid6rJoD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cid6rJoD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B31741F000E9;
	Tue, 30 Jun 2026 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782844819;
	bh=OIJaDfPl9hq1xwALMnt28I8x0v9nZLCiYw6EkBVVeJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cid6rJoDNeM34iMJEjiJLPc6/NL2J+VpTnh1z8ACkm9qZe/tcod8UVdysI673sEEw
	 QwbD7WPTUwaJ6egdAWBIcTtqN3IUMlQ97dQJo6BFUsYhNyNawvvhu79PIXQEASFp10
	 NYaSNYK+voS9jqH9SfdIPp4BiJDgb1ebhBWL/RLIYRtQwy0zwSrT3/ztpmJH11qSqj
	 UZJeBKXr61dDDejpRJqWF7WzBOVC9RWBotGG1RCXDJys9hA7VRU3oeEvTsJ8q6u2nn
	 De6wVj3HmU96Fqe4fKkL7Oa935CDK1QFgZxRIZqyKmKatEpx+ChdLsxA0sY+Edi8HN
	 CQTMlTMhVzMkw==
Date: Tue, 30 Jun 2026 11:40:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] formalize and fix disabling the RT subvolume
Message-ID: <20260630184018.GB6544@frogsfrogsfrogs>
References: <20260630113526.3601287-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630113526.3601287-1-hch@lst.de>

On Tue, Jun 30, 2026 at 01:35:26PM +0200, Christoph Hellwig wrote:
> Various test unset SCRATCH_RTDEV to avoid dealing with metadata
> allocations for the RT subvolume in the main device or differences
> in RT subvolume behavior.  Besides being rather ad-hoc, this unset
> also fails to disable the internal RT zoned subvolume.
> 
> Add a _disable_scratch_realtime helper that not only unsets
> SCRATCH_RTDEV, but also disables the zoned allocator and with
> that the internal RT subvolume.

What if we want to run these tests on the internal rt volume?
I guess this means I should go look at what exactly happens on that
QA config once I get the 7.2-rc1 rebase stabilized.

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
>  tests/xfs/655      | 2 +-
>  tests/xfs/656      | 2 +-
>  15 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/common/filestreams b/common/filestreams
> index 838b5921520a..459de8c6b6a6 100644
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
> diff --git a/tests/xfs/655 b/tests/xfs/655
> index a4162d70b321..d6a3d4a95cc0 100755
> --- a/tests/xfs/655
> +++ b/tests/xfs/655
> @@ -26,7 +26,7 @@ _require_xfs_io_command healthmon
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  echo "Format and mount"
>  _scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> diff --git a/tests/xfs/656 b/tests/xfs/656
> index 3830d7193fcb..1eb82991521c 100755
> --- a/tests/xfs/656
> +++ b/tests/xfs/656
> @@ -42,7 +42,7 @@ filter_healer_errors() {
>  
>  # Disable the scratch rt device to avoid test failures relating to the rt
>  # bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> +_disable_scratch_realtime
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> -- 
> 2.53.0
> 
