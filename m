Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACA9330B05;
	Mon, 15 Dec 2025 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826902; cv=none; b=GLfGBkdS6GYPnfDRChIykR8gEB2aAJa77hwT7L56g6aUsSIisHCwqBeNYkzIfjrn3Gw/Lbn+3Wb1jgGd8kOaoFNEI62V/78zWB+VNxdlIrYHSmZNKuXx8PMxzxOCGFY2usw+hsCuXtvPWh23IzKkaMCLDIDalLv5Nf1689Ld8GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826902; c=relaxed/simple;
	bh=UPF0DA2voeR5gcIRiSHoBLbkAOCOtObwD7wg0y2Bgpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6ttb3pzQ4ljufw+UinhiL0FCCg7apvPHfXQ8XijvJOxIQsxOrQYzAFmFgV/Z1q/AuqtkkAsSzRxYGS0bYmJIXZd5jIC9BxQdVyC4Kku0FRNCKLz9SOd05b2U+CVnn81+mqM602EkyMkIcGieCqt85x+OzfKxWekSrF8z1AYsGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b8SMfoTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b8SMfoTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A97C4CEF5;
	Mon, 15 Dec 2025 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765826901;
	bh=UPF0DA2voeR5gcIRiSHoBLbkAOCOtObwD7wg0y2Bgpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b8SMfoTdn5eQ0UZAbpunX9Bf4VCTSddzu7JCx04fWDiQCzD4VWFK1wxSE/D4UU7+e
	 vwBXli0ZcpjmfgyIdZJ+RHBQzJRppRlj1tQvKoKFchXraBQEyazNwSFzHF7nTEktD+
	 zMZO22UEYqXQyV70x1cIP9wWdpgqBVkvdDWrmAVidW5DuV4hsN5Cj6hAhF2Cuwkq7Y
	 W/IahoK6PT8dF9GRKVe6Ynz2l5MF5UXomtWr5nyIkMZQqDdkEi16s6i7uKSLyZ8zdF
	 zJYwW4Cn1aB+WCBVAqOcmz2O7A+XDX8+fx/GpSpokQf75lqE+bEZRUJdeglKctVOKG
	 Y2y+8i1uFnoSg==
Date: Mon, 15 Dec 2025 11:28:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: test that RT growfs not aligned to zone size
 fails
Message-ID: <20251215192821.GL7725@frogsfrogsfrogs>
References: <20251215095036.537938-1-hch@lst.de>
 <20251215095036.537938-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215095036.537938-3-hch@lst.de>

On Mon, Dec 15, 2025 at 10:50:28AM +0100, Christoph Hellwig wrote:
> Check that a file system with a zoned RT subvolume can't be resized to
> a size not aligned to the zone size.
> 
> Uses a zloop device so that we can control the exact zone size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It seems to me that this test is creating a 10G zoned volume with a zone
size of 256M, and then growfs'ing to (12G + 52K) which is supposed to
fail, correct?

If so, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/652     | 58 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/652.out |  4 ++++
>  2 files changed, 62 insertions(+)
>  create mode 100755 tests/xfs/652
>  create mode 100644 tests/xfs/652.out
> 
> diff --git a/tests/xfs/652 b/tests/xfs/652
> new file mode 100755
> index 000000000000..91399be28df0
> --- /dev/null
> +++ b/tests/xfs/652
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2025 Christoph Hellwig.
> +#
> +# FS QA Test No. 652
> +#
> +# Tests that xfs_growfs to a realtime volume size that is not zone aligned is
> +# rejected.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick realtime growfs zone
> +
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_realtime
> +_require_zloop
> +_require_scratch
> +_require_scratch_size $((16 * 1024 * 1024)) # 16GiB in kiB units
> +
> +_cleanup()
> +{
> +	if [ -n "$mnt" ]; then
> +		_unmount $mnt 2>/dev/null
> +	fi
> +	_destroy_zloop $zloop
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +fsbsize=4096
> +unaligned_size=$((((12 * 1024 * 1024 * 1024) + (fsbsize * 13)) / fsbsize))
> +
> +mnt="$SCRATCH_MNT/mnt"
> +zloopdir="$SCRATCH_MNT/zloop"
> +
> +mkdir -p $mnt
> +zloop=$(_create_zloop $zloopdir 256 2)
> +
> +echo "Format and mount zloop file system"
> +_try_mkfs_dev -b size=4k -r size=10g $zloop >> $seqres.full 2>&1 ||\
> +	_notrun "cannot mkfs zoned filesystem"
> +_mount $zloop $mnt
> +
> +echo "Try to grow file system to a not zone aligned size"
> +$XFS_GROWFS_PROG -R $unaligned_size $mnt >> $seqres.full 2>&1 && \
> +	_fail "growfs to unaligned size succeeded"
> +
> +echo "Remount file system"
> +umount $mnt
> +_mount $zloop $mnt
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/652.out b/tests/xfs/652.out
> new file mode 100644
> index 000000000000..8de9ab41d47f
> --- /dev/null
> +++ b/tests/xfs/652.out
> @@ -0,0 +1,4 @@
> +QA output created by 652
> +Format and mount zloop file system
> +Try to grow file system to a not zone aligned size
> +Remount file system
> -- 
> 2.47.3
> 
> 
