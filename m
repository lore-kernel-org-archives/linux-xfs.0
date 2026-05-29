Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAED2E7391;
	Fri, 29 May 2026 04:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029597; cv=none; b=bVhZbPvFLnDoyeCUa1B8yUBLQuQi34qIQuyod/96FnkBOlIO5GVojVPFOAH1PO9m0pxuy/cJViXGnFV1+HYEJ6kRJoz6AqyfnE1uRziS5GwdzI8Dhohl1ZY8rvB+TpXS+Bl87ysSbJ9w/cTv3h/7MN4UJgc5mrQjzaQTkzKNuYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029597; c=relaxed/simple;
	bh=0LchzAw0rNobSeSvJsgPyZuJg/OSVCJgLjz7FG0eiGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XWmLIThiS2oBNxkJW3dzMsL/q/khrOUKP5WTldcvEVhH/sZBzVtkbG2eaI+6cJi8vl6Q0E012GuHR0L9Ifd16WiFJZpaKVRXOp8el1GcWTk023x6+zukEgTlyRoaGs/4c/DDXJXOgmCSDeHFdO+bH8l0xwICJWhxdkXR8VsWCi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZ+hKT45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZ+hKT45"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C44AD1F00893;
	Fri, 29 May 2026 04:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780029595;
	bh=8W0wLWUEVCd1iMnz4p4LRMZLuTVASNeXNrW/n7LnqKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OZ+hKT45oS1XCcQ318yI/N+b3pMC41KzsYRP8If9zg+AMzclXSDd1tVLyxgsUjzso
	 XlAd11dr6PzJsYf76l6W92SjuLhFlVoP22/IzyBG30Gveo76GuAOhRQQsWelcWngP+
	 PvLhjJ4JvHB1iOIjsSvMBxm+ufsBHWYiGJJ3Zq46oTUOV+DeyAZCWEtqGUwoiL+Cxn
	 poHbidH2TBQS2xbKHW5IITtdWxRwDW/zdPT2zVlvFr8vNWxwuNRcNN8tbA+Lnb4Sh+
	 D/adQOiWgU9NpphKHRfU6xfvix8X1JbJ4EeUx1A9QstnEbUSHcRXtEK6UiuhpeHkDn
	 AG4dkB7qPJJOw==
Date: Thu, 28 May 2026 21:39:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v6 06/11] fstests: verify f_fsid for cloned filesystems
Message-ID: <20260529043955.GG6070@frogsfrogsfrogs>
References: <cover.1779939330.git.asj@kernel.org>
 <e029755044a32de6ec2a0d3391f3ff0089fc3c30.1779939330.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e029755044a32de6ec2a0d3391f3ff0089fc3c30.1779939330.git.asj@kernel.org>

On Thu, May 28, 2026 at 12:05:37PM +0800, Anand Jain wrote:
> Verify that the cloned filesystem provides an f_fsid that is persistent
> across mount cycles, yet unique from the original filesystem's f_fsid.

Might want to add that last part to the test description itself, because
otherwise I don't know what 'verify' means.

> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/802     | 67 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/802.out |  7 +++++
>  2 files changed, 74 insertions(+)
>  create mode 100644 tests/generic/802
>  create mode 100644 tests/generic/802.out
> 
> diff --git a/tests/generic/802 b/tests/generic/802
> new file mode 100644
> index 000000000000..653e74e11b53
> --- /dev/null
> +++ b/tests/generic/802
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 802
> +# Verify f_fsid and s_uuid of cloned filesystems across mount cycle.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_loop
> +
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
> +[ "$FSTYP" = "btrfs" ] && _fixed_by_kernel_commit xxxxxxxxxxxx \
> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"

_fixed_by_fs_commit?

> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	umount $mnt1 $mnt2 2>/dev/null
> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
> +}
> +
> +# Setup base loop device and its clone
> +devs=()
> +_loop_image_create_clone devs
> +mkdir -p $TEST_DIR/$seq
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Mount both filesystems simultaneously using mandatory clone mount options
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +# Capture baseline filesystem IDs for comparison
> +fsid_scratch=$(stat -f -c "%i" $mnt1)
> +fsid_clone=$(stat -f -c "%i" $mnt2)
> +
> +echo "**** fsid initially ****"
> +echo $fsid_scratch | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
> +echo $fsid_clone | sed -e "s/$fsid_clone/FSID_CLONE/g"

Why echo only to sed?

--D

> +
> +# Verify that the fsids remain stable after a mount cycle, even when the
> +# mount order is reversed.
> +echo "**** fsid after mount cycle ****"
> +_unmount $mnt1
> +_unmount $mnt2
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +
> +# Compare post mount-cycle values against the baseline
> +stat -f -c "%i" $mnt1 | sed -e "s/$fsid_scratch/FSID_SCRATCH/g"
> +stat -f -c "%i" $mnt2 | sed -e "s/$fsid_clone/FSID_CLONE/g"
> +
> +status=0
> +exit
> diff --git a/tests/generic/802.out b/tests/generic/802.out
> new file mode 100644
> index 000000000000..d1e008f122bb
> --- /dev/null
> +++ b/tests/generic/802.out
> @@ -0,0 +1,7 @@
> +QA output created by 802
> +**** fsid initially ****
> +FSID_SCRATCH
> +FSID_CLONE
> +**** fsid after mount cycle ****
> +FSID_SCRATCH
> +FSID_CLONE
> -- 
> 2.43.0
> 
> 
