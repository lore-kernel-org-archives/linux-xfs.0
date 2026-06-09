Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7273209F43;
	Tue,  9 Jun 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016012; cv=none; b=hM+7vhHyxJ5HTvMRTadKokb1h0/PD2l1O2TYeYInP1qWjf2ZUKhy0HTWUKoH2nQDunlUremxd2HPqREKvAwdKxGOp3GW3FHiBUxRZ521O/sPH+eGSeM3VybEhUBakKdkKix8L3B81R0ctYiKdvJjSFI49Z9NmXNViOuOcvhxTek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016012; c=relaxed/simple;
	bh=04oMmw6/VVwDKxrGKu0XlbZoVuKCW4mHYaiGxMrYiWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/llFHq3ebRBSg9EQovnwNF1RSXuARb0lnq7018y9q+D7CZzzSfZ5MbJjX9Zo4iFmFrRozf4s5KfBrn7Pj9cT9sXHLOTVqLIqakxX8yq7nP3c5r59lquEhvnHhL7H5r6tlz7uxs3X9T6DVMnohzj87sSuQzDYCXnrFtAMMiHc1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d6pSHaul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d6pSHaul"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 44D921F00893;
	Tue,  9 Jun 2026 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016011;
	bh=4vqgsXibZl7UhG90nwQjrWcTqrfup+SR3L08VPDiQ6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6pSHaulScl7G6VMJ2+viRm5mAIW5IP8b2a8pDdZa/3Tw2zdy7KRnybPafZy67YhW
	 xLG7m+1PjgazVUMRemuuFZAkoqBk4mTaf1RdWBlFo8+WTWXBEXiLEqU5PcFbbFhIWY
	 VgN3GhW5nsHC78TnIocVK02rDrJZK3xyUvbzwaFm2fiQSgP7TJUXItUNKRYMkdUByY
	 zDtfODszZhUzJvB6MR6HJU4tG0TXQPjybFjdhj6rhVINW+4vfCGIBGjNGQsJ5W4D7x
	 90oNrb/+zByS2M6yAF2dUDtesxNC/16Jk6iuK6leth9L7R8GyhtVR1LCthOSwc4xpv
	 dMQwn914FZt4Q==
Date: Tue, 9 Jun 2026 07:40:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test that a grown RT section can be filled
Message-ID: <20260609144010.GN6070@frogsfrogsfrogs>
References: <20260609080051.1712103-1-hch@lst.de>
 <20260609080051.1712103-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609080051.1712103-3-hch@lst.de>

On Tue, Jun 09, 2026 at 10:00:44AM +0200, Christoph Hellwig wrote:
> This reproduces issues with zoned growfs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/4201     | 58 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4201.out |  3 +++
>  2 files changed, 61 insertions(+)
>  create mode 100755 tests/xfs/4201
>  create mode 100644 tests/xfs/4201.out
> 
> diff --git a/tests/xfs/4201 b/tests/xfs/4201
> new file mode 100755
> index 000000000000..1f1c8e7eb140
> --- /dev/null
> +++ b/tests/xfs/4201
> @@ -0,0 +1,58 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2026 Christoph Hellwig.
> +#
> +# FS QA Test No. 4201
> +#
> +# Test that the entire device capacity can be used after resizing a realtime
> +# device.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick realtime growfs zone
> +
> +. ./common/filter
> +. ./common/zoned
> +
> +_require_scratch
> +_require_external_realtime_device
> +
> +minrtdevsize=$((5 * 1024 * 1024)) #kB
> +rtdevsize=`_get_device_size $SCRATCH_RTDEV`
> +if [ $rtdevsize -lt $minrtdevsize ]; then
> +	_notrun "SCRATCH_RTDEV device too small, $rtdevsize < $minrtdevsize"
> +fi
> +
> +_scratch_mkfs -r size=1g  >> $seqres.full 2>&1
> +rblocks=`_scratch_xfs_get_sb_field rblocks`
> +
> +_scratch_mount
> +_xfs_force_bdev realtime $SCRATCH_MNT
> +free_zones_pre=$(_xfs_get_mountstat $SCRATCH_MNT "free zones:")
> +
> +echo "Growing file system"
> +$XFS_GROWFS_PROG $SCRATCH_MNT -R $((2 * rblocks)) >> $seqres.full 2>&1 || \
> +	_fail "growfs failed"
> +
> +# For zoned file systems, check that the growfs did increase the available free
> +# zones.  This avoids a hang on unfixed kernels when filling later.
> +free_zones_post=$(_xfs_get_mountstat $SCRATCH_MNT "free zones:")
> +if _has_fs_sysfs_attr $SCRATCH_DEV "zoned/max_open_zones"; then
> +	if [ "$free_zones_pre" == "$free_zones_post" ]; then
> +		_fail "growfs did not increase free zones"
> +	fi
> +fi
> +
> +echo "Filling grown file system"
> +writesize_mb=32
> +dd if=/dev/zero of=$SCRATCH_MNT/fill bs=${writesize_mb}M oflag=direct \
> +	>> $seqres.full 2>&1
> +
> +blocksize=$(_get_block_size $SCRATCH_MNT)
> +free_blocks=$(stat -f $SCRATCH_MNT -c '%f')
> +
> +# check that we really mostly filled the file system
> +_within_tolerance "free space after fill" \
> +	$free_blocks $((writesize_mb * 1024 * 1024 / blocksize)) 100%
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4201.out b/tests/xfs/4201.out
> new file mode 100644
> index 000000000000..2e7ac4019f3f
> --- /dev/null
> +++ b/tests/xfs/4201.out
> @@ -0,0 +1,3 @@
> +QA output created by 4201
> +Growing file system
> +Filling grown file system
> -- 
> 2.53.0
> 
> 
