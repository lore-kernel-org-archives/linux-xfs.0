Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804A24DCE2;
	Wed, 28 Jan 2026 01:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564576; cv=none; b=CDy2U0NmVxCbrFEx881Zq+Pme66+ED1Ogcbvl2QiaJbg2Yu1gNKNb+5abLtL5/MacjXoMKh3R1eBxXFXRoAXbMAFQpDPIK4L/uWBlYo3h/DTrAZzGhsbTBJeTtEtSeSVb7B1mflRV2znocNudlzXVtsNKToGqOPw6uISz6uOiXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564576; c=relaxed/simple;
	bh=o6bobqa9ifM38ea0uEPiKBtaKssoMnhVgiRsC9iN2jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9K6O52Oy/nUwrGdaRqDEXPHk5CGjtxHCixj7EGfZHStNDMjQSKMjB3T+74d7cGp7k3X+vgsybsUN4Filp4DiYWx1y+qvkhBAaLKUYax+THskSAVWVZSkhTg/wM0xM7y+Z63qDUOYjhS+acJer0Hm0ZbnIsP1do6+Hmd0IYs19s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6boIvUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6boIvUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D96C116C6;
	Wed, 28 Jan 2026 01:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564576;
	bh=o6bobqa9ifM38ea0uEPiKBtaKssoMnhVgiRsC9iN2jk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6boIvUJfAEZUX8FtoUKiAVDzxIr2RyJ37LbcnSFH0s8X0ekhSZdkCB/hdhbe3N5e
	 FWV4jA+piRWqxmFsB36sBDAByLdPp17nY/A/NgMhVY7kJ9iipOsrVsFetmJYxxjBfM
	 PSTiyj8km6QyZbI3mAzl6g8qD58JMqJmTjTF7Z7cAwQfxO989tNQe6k4xZe3G3CXjE
	 tk0d4MCzf1+/0t78NG98kR3nH83N2ZcLY8/0BQVtGMDEDqJOtzzXp9S7/Kox5EQZir
	 5d3dTdmcx4UVBfanRvkOfGRDjhY6MG/06GynihAOjuGO65FboShyDTUS3YmhonSTpv
	 Qn5xjwOHHMiWg==
Date: Tue, 27 Jan 2026 17:42:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: test zone reset error handling
Message-ID: <20260128014255.GK5945@frogsfrogsfrogs>
References: <20260127160906.330682-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160906.330682-1-hch@lst.de>

On Tue, Jan 27, 2026 at 05:09:06PM +0100, Christoph Hellwig wrote:
> Add a test that exercises the zone gc error handling, aka shutting
> down the file system or not mounting it using the new error
> injection knob and stats.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/842     | 63 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/842.out |  2 ++
>  2 files changed, 65 insertions(+)
>  create mode 100755 tests/xfs/842
>  create mode 100644 tests/xfs/842.out
> 
> diff --git a/tests/xfs/842 b/tests/xfs/842
> new file mode 100755
> index 000000000000..8f6c13f1b19c
> --- /dev/null
> +++ b/tests/xfs/842
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 842
> +#
> +# Test that GC defragments sequentially written files.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick mount zone
> +
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_scratch
> +_require_fs_sysfs stats/stats
> +
> +count_zone_resets() {
> +	_get_fs_sysfs_attr $SCRATCH_DEV stats/stats | awk '/zoned/ {print $4}'
> +}
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +
> +# figure out how much space we need for 3 zones worth of user data...
> +blocksize=`_scratch_xfs_get_sb_field blocksize`
> +rgblocks=`_scratch_xfs_get_sb_field rgextents`
> +rgsize=$((3 * rgblocks * blocksize))
> +echo "blocksize=${blocksize}, rgblocks=${rgblocks}, rgsize=${rgsize}" >>$seqres.full 2>&1
> +
> +# .. and create a file system with that size
> +_scratch_mkfs_sized $rgsize >>$seqres.full 2>&1
> +
> +SAVED_MOUNT_OPTIONS="$MOUNT_OPTIONS"
> +export MOUNT_OPTIONS="$MOUNT_OPTIONS -o errortag=zone_reset"
> +_try_scratch_mount || _notrun "mount option not supported"
> +_require_xfs_scratch_zoned
> +
> +# fill the file system and remove the data again, this should trigger zone
> +# resets that will fail due to the error detection
> +dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M >/dev/null 2>&1
> +sync $SCRATCH_MNT
> +rm $SCRATCH_MNT/foo
> +sync $SCRATCH_MNT
> +sleep 1
> +
> +touch $SCRATCH_MNT/bar 2>/dev/null && _fail "file system not shutdown"
> +
> +# unmount the shutdown file system
> +_scratch_unmount
> +
> +# try mounting with error injection still enabled.  This should fail.
> +_try_scratch_mount && _fail "file system mounted despite zone reset errors"

Is it necessary to _fail here explicitly?  Or could you just echo that
string and let the golden output disturbance cause the test to fail?

--D

> +# now try without the error injection
> +MOUNT_OPTIONS="$SAVED_MOUNT_OPTIONS"
> +_scratch_mount
> +
> +# all three zones should be reset on mount
> +nr_resets=$(count_zone_resets)
> +echo "zone resets: $nr_resets"
> +
> +status=0
> +exit
> diff --git a/tests/xfs/842.out b/tests/xfs/842.out
> new file mode 100644
> index 000000000000..718805b5766e
> --- /dev/null
> +++ b/tests/xfs/842.out
> @@ -0,0 +1,2 @@
> +QA output created by 842
> +zone resets: 3
> -- 
> 2.47.3
> 
> 
