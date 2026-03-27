Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0C03314AC;
	Fri, 27 Mar 2026 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774624939; cv=none; b=ucpZKizVaORR7LA9vzfI513RGcJIHKl/pkpPyFL1ecBXFvM3MPJ0hY/tQ41rIfv429RQAEf9wk4FfkD9JJTZZUDnVOBs21VW7G2Spftudf4hCAH6fb1XnYVsubjr1IrZfgf/0GMOBkTyEOqevxOVqsq/M3s+dD6Xrsvo0RFgahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774624939; c=relaxed/simple;
	bh=TtR7ue4TMqLjiOAa0Dr4QlejDLZp/g/tUeN9gs6Pkyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCLBX4NNC5oNcE+jOYsGk0DMD1qQ+RqGSeye1N2hNAcjGvD1a9PttrD1kBERFDgbvCUjxwuWdHiXTzlVLEvKmisvOHAwHqmMIBD+bvZZ/DlK/BiVuCTmRiKC7kd9uGae6AVe3imyoj4v0CipmxYv9mX5pJ1zwZ/0oTUcx8J4jO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t5pGDgMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t5pGDgMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39869C2BC87;
	Fri, 27 Mar 2026 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774624939;
	bh=TtR7ue4TMqLjiOAa0Dr4QlejDLZp/g/tUeN9gs6Pkyg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5pGDgMcsqfPd9m40Q/GdhMlo9rQXdHrJZ07naULVx4m/mm2VQI0iahTh6WvUST9P
	 VVfl/lwhgHhAzOXafZcv619n3o4+vVSUbuSPsdkOk5NH6Pc6drbQmQAtj+OJnOr1T/
	 1COrXNTAliX0yEZSZlFNhZxKVcPQkZ+puCD5fHcuVyx7SCkk+Ttq8vS26ygP7KTM26
	 +E9n3ODFeDjJF1U5AGnxzo57/TUuq5keP3u8qv0OBLS8W7jK5pH9Vf+1E1dIvPGVGg
	 uWhQa/i87CSyM8HARTv1oE+i53GSBJ4bU1htR2szSSDhnEvKw1PC20z4+DF6wgxp5x
	 yY/UEeCYrqVtg==
Date: Fri, 27 Mar 2026 08:22:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start gc
 for rw fses
Message-ID: <20260327152218.GC6223@frogsfrogsfrogs>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
 <20260327123429.39330-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327123429.39330-3-hans.holmberg@wdc.com>

On Fri, Mar 27, 2026 at 01:34:29PM +0100, Hans Holmberg wrote:
> Test that writes to the sysfs attribute zone_gc_low_space triggers
> garbage collection for rw (but not ro) file systems.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Looks good to me, given what I saw of the kernel patch.  It probably
needs a _fixed_by_kernel_commit tag once the patch goes upstream.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/xfs        | 17 +++++++++++
>  tests/xfs/999     | 72 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  3 files changed, 91 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/common/xfs b/common/xfs
> index c81f939e68d2..45d7f75d2064 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -748,6 +748,23 @@ _xfs_get_scratch_rtdev_bdev()
>  	fi
>  }
>  
> +# Get a stat from /proc/self/mountstats for a specific mount point
> +_xfs_get_mountstat() {
> +	awk -v mount="$1" -v stat="$2" \
> +		'$0~"mounted on "mount" with fstype xfs"{f=1} f&&index($0,stat){print $NF;exit}' \
> +		/proc/self/mountstats
> +}
> +
> +# Get the user available blocks for a rt mount
> +_xfs_get_user_available_rt_blocks() {
> +	_xfs_get_mountstat "$1" "user available RT blocks:"
> +}
> +
> +# Check if gc is required for a rt mount
> +_xfs_get_rt_gc_required () {
> +	_xfs_get_mountstat "$1" "RT GC required:"
> +}
> +
>  # Snapshot the metadata on the scratch device
>  _scratch_xfs_metadump()
>  {
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 000000000000..2c5b54368b6d
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,72 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Western Digital Corporation
> +#
> +# FS QA Test No. 999
> +#
> +# Tests that writes to zonegc_low_space will trigger start of garbage
> +# collection for rw (but not ro) file systems
> +#
> +. ./common/preamble
> +_begin_fstest auto rw zone quick
> +
> +. ./common/zoned
> +
> +_require_scratch
> +_require_odirect
> +
> +zdev="$(_xfs_get_scratch_rtdev_bdev)"
> +_require_zoned_device "$zdev"
> +capacity=$(_zone_capacity 0 $zdev)
> +_scratch_mkfs_sized $(($capacity * 6)) > $seqres.full 2>&1
> +
> +# limit max open zones to avoid gc to trigger before we want it to
> +export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
> +_try_scratch_mount || _notrun "mount option not supported"
> +_require_xfs_scratch_zoned
> +
> +# create three zone-sized files and invalidate 95% of the data
> +for i in $(seq 1 3); do
> +	filename=$SCRATCH_MNT/data_$i
> +	dd if=/dev/zero of=$filename bs=1M oflag=direct\
> +		count=$(($capacity / (1024 * 1024))) >> $seqres.full 2>&1
> +	truncate -s $(($capacity / 20)) $filename
> +done
> +
> +# remount read-only and set the gc limit to free up unused space
> +_scratch_remount ro
> +rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> +_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
> +
> +# reclaiming a zone with 5% used blocks should take way less than 1 second
> +sleep 1
> +
> +# gc should not run for read only file systems
> +rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> +[ "$rt_available_post" -gt "$rt_available_pre" ] && \
> +	_fail "gc should not run while read only"
> +
> +_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 0
> +
> +# remount rw and check that gc starts, frees up blocks and stops after
> +# the threshold is set to reclaim the unused blocks
> +_scratch_remount rw
> +
> +rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> +_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
> +
> +i=0
> +while [ $(_xfs_get_rt_gc_required "$SCRATCH_MNT") -eq "1" ]; do
> +	sleep 1
> +	let i=$i+1
> +	[ $i -gt 3 ] && _fail "gc did not complete within a reasonable time"
> +done
> +
> +rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> +[ "$rt_available_pre" -ge "$rt_available_post" ] && \
> +	_fail "gc did not free up space"
> +
> +echo "Silence is golden"
> +status=0
> +
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 000000000000..3b276ca804fc
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> -- 
> 2.34.1
> 
> 
