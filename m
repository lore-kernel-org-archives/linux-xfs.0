Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A1822CBE6;
	Tue, 14 Apr 2026 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776193155; cv=none; b=cXab+Ss1pClWFJPpUt9KhWQ6TAyRrhMPBvf23gjI2nIreDdCWn5Tb0eVosDNifLWLjclofXD2Ok2ZmS7QOiX4/nqtTfOpiSLlE8XHPeWTbyEkSYL7b5J7J2I+CZ2ZBvB+ZviKRblYCFLQSOTu2RI5gFyatrNpnnSVxLIRNgU+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776193155; c=relaxed/simple;
	bh=ApwHzTg84wtAbCO/UVmT6oXcCjjpLdDCJti1sQ4VWAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETVFDoD1WJhZUTB+YX+fV9HBPTXTKUqELSgRNytbIUg9eHw7Rp8TKljmYGbPgA0nGgg3RDfjhlUNgzErgp+zKsX14JSIAerf0gkWUaa2bhKTMqont99V5Pw1RucBlb9uhQWihANzzoDEABdkNEzfI4caIglAVRBHw8hxgEhbvbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgfJR6Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgfJR6Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECC0C19425;
	Tue, 14 Apr 2026 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776193155;
	bh=ApwHzTg84wtAbCO/UVmT6oXcCjjpLdDCJti1sQ4VWAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgfJR6CyzlLMQfB6izMcSducAYth8KDVJJukjtCqHMSzTdOjYhbvJlK7EjOnBmuAO
	 Q5uOLXymgcsXFZcVkEn9BZkeQ3rA8F+LPPiwV4cAJo+zJgMEdo+DjIBQpQHWTHcBXW
	 sS2YktrLwihq0FKY8t7ImhzB65FvkMc/bWUOYwTnlQSuzsuxDdEwUxhDArVFdJuGEO
	 SCzEno4vcXP1Vq/nMSbqKM1/q5Dm1BIlEx34H4wbSVB9BzHep9fmKN80cdDOtvQfSy
	 00oUyqM80Jkxy1KBhe2c/gG49lqKpO5KGKYYK0dwn6/1mDsXySdO0te8zJ/T5+oKPt
	 +daIDlwYdHkEQ==
Date: Tue, 14 Apr 2026 11:59:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260414185914.GB150005@frogsfrogsfrogs>
References: <20260414075613.544106-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414075613.544106-1-hch@lst.de>

On Tue, Apr 14, 2026 at 09:55:47AM +0200, Christoph Hellwig wrote:
> Test that mounts of zoned file systems on conventional devices don't
> create more open zones than allowed when the last blocks in one or more
> zones have been invalidated.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v2:
>  - use raw mkfs to avoid injecting a real RT device
>  - _notrun with a useful message when the mkfs or mount fails due to lack
>    of RT device or zoned block device support
> 
>  tests/xfs/4201     | 69 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4201.out |  1 +
>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/xfs/4201
>  create mode 100644 tests/xfs/4201.out
> 
> diff --git a/tests/xfs/4201 b/tests/xfs/4201
> new file mode 100755
> index 000000000000..56084bca41c0
> --- /dev/null
> +++ b/tests/xfs/4201
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 4201
> +#
> +# Test that mounts of zoned file systems on conventional devices don't create
> +# more open zones than allowed when the last blocks in one or more zones have
> +# been invalidated.
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick zone
> +
> +_require_scratch_nocheck
> +_require_odirect
> +_require_non_zoned_device $SCRATCH_DEV
> +_require_non_zoned_device $SCRATCH_RTDEV

Seems fine to me still, though I wonder if you still need to check
SCRATCH_RTDEV if you're opencoding the mkfs/mount calls?

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +open_zones=5
> +blocks=16384
> +bsize=4096
> +
> +zone_size_mib=$((blocks * bsize / 1024 / 1024))
> +file_size_mib=$((zone_size_mib / 2))
> +nr_files=$((open_zones * 3 - 1))
> +
> +echo "zone size: $zone_size_mib" >>$seqres.full
> +echo "file size: $file_size_mib" >>$seqres.full
> +echo "nr files: $nr_files" >>$seqres.full
> +
> +# don't use _scratch_mkfs/_scratch_mount to avoid injection a real RT device
> +$MKFS_XFS_PROG -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
> +	$SCRATCH_DEV > "$seqres.full" 2>&1 || \
> +		_notrun "Zoned mkfs not supported"
> +_mount $SCRATCH_DEV $SCRATCH_MNT -o max_open_zones=${open_zones} || \
> +	_notrun "Zoned allocator not supported"
> +
> +_has_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones || \
> +	_notrun "This test requires /sys/fs/${FSTYP}/$SCRATCH_DEV/zoned/nr_open_zones"
> +
> +for i in $(seq 1 $nr_files); do
> +	dd if=/dev/zero of=$SCRATCH_MNT/$i bs=1M count=$file_size_mib \
> +		 oflag=direct > /dev/null 2>&1
> +done
> +
> +# delete odd numbered files as they should be at the end of the zones
> +for ((i = 0; i < $nr_files; i = $((i + 2)))); do
> +	rm $SCRATCH_MNT/$((i + 1))
> +done
> +
> +_scratch_unmount
> +_mount $SCRATCH_DEV $SCRATCH_MNT -o max_open_zones=${open_zones}
> +
> +max_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/max_open_zones)
> +nr_open=$(_get_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones)
> +
> +if [ ${max_open} -ne $((open_zones - 1)) ]; then
> +	_fail "Test needs adjustments for multiple open GC zones"
> +fi
> +
> +if [ ${nr_open} -gt ${max_open} ]; then
> +	_fail "Too many open zones: $nr_open/$max_open"
> +fi
> +
> +_scratch_unmount
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
> new file mode 100644
> index 000000000000..32e395dd4d6d
> --- /dev/null
> +++ b/tests/xfs/4201.out
> @@ -0,0 +1 @@
> +QA output created by 4201
> -- 
> 2.53.0
> 
> 
