Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9D1371D04;
	Wed,  1 Jul 2026 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782927196; cv=none; b=QVYokTjKAGTgCXmpy5tVXNiHibD5leggif8GIre2wu3ZTf8bokxPjGW27pgJpgXcyU69SL/4luz0c5yutMq7Uthz22bBc0+eE4nrSkT3b2r4EUiZPyRpM2lHP36kWdKxJjhjMnebBhC6Knc/NqLgEE7tNgwYjagXteeHMSLVzTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782927196; c=relaxed/simple;
	bh=S3fQfD/NMhE5Whz/J1/eQ/0OXtvxJUW3Rrj3+sDAinQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+3sNCsIbcYJnS5d33QDPae81a9K++y4/4WjNFbHeKnELBORf+v3Bq+dXRsZ/U9yhGUY6ef3g7Ff8opUcJY2ERl6nVFr0EdnZt9sBg+DcWt5r3L8y8B/xjHtZh4Ab4hXjxqjFfof2a/dY7IlVIEebSZfuHtL34DbFDqyN2AVtag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lw9nn/qL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lw9nn/qL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BDEFF1F000E9;
	Wed,  1 Jul 2026 17:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782927195;
	bh=DT72m6PijCAONOaUhwmjfXMlmjpfNBh8evoXPnX3jsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lw9nn/qLQ4Jc7ZVwBb+skja3MPB21ut1EmQrQpaW6bQk1dBTy3VMrs4pVxIky1sXS
	 ea+HTBJwXzUCdQxnTe6xsFrAtZjNyOddMQft8OC9pCK47Aqks21U+m1mmA9Lg+eodn
	 t/4u6QRC23xMGO5m8fD5fCPyCGQ2BVjmVIY9wg45Pl3tnnVJHzAJ27t7RubuXZmAeJ
	 9786jE8nnWG0qu4Cii2c5Y3dgK+rw4BFqKojuon7gFRh5/XL7Zmnaos8ezZrRX+dzu
	 ndEFFTPoANoOO/+78f4Nioxiy/eUccv9mDuxUhab0wD8Y3i8DeX6UnQxEhGBPvyM/P
	 oBnkghFi+eKBg==
Date: Wed, 1 Jul 2026 10:33:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v7 06/11] fstests: verify f_fsid for cloned filesystems
Message-ID: <20260701173314.GH6517@frogsfrogsfrogs>
References: <cover.1781694879.git.asj@kernel.org>
 <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>

On Wed, Jun 17, 2026 at 07:20:33PM +0800, Anand Jain wrote:
> Verify that the cloned filesystem provides an f_fsid that is persistent
> across mount cycles, yet unique from the original filesystem's f_fsid.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/802     | 64 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/802.out |  4 +++
>  2 files changed, 68 insertions(+)
>  create mode 100644 tests/generic/802
>  create mode 100644 tests/generic/802.out
> 
> diff --git a/tests/generic/802 b/tests/generic/802
> new file mode 100644
> index 000000000000..910807c11584
> --- /dev/null
> +++ b/tests/generic/802
> @@ -0,0 +1,64 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 802
> +# Check that the cloned filesystem provides an f_fsid that is persistent
> +# across mount cycles if the block device maj:min remains unchanged.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_loop
> +
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +	"btrfs: use on-disk uuid for s_uuid in temp_fsid mounts"
> +_fixed_by_fs_commit btrfs xxxxxxxxxxxx \
> +	"btrfs: derive f_fsid from on-disk fsuuid and dev_t"
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

This is where I continue getting stuck on this patchset -- fsid is so
poorly defined that I don't think the rest of these fsid tests make
sense at all.  Nobody mandates that fsid is persistent or stable across
remounts.  Nobody even mandates that two cloned filesystems don't have
the same fsid value.

The statfs manpage says:

"Nobody knows what f_fsid is supposed to contain (but see below)"

and then:

"The general idea is that f_fsid contains some random stuff such that
the pair (f_fsid,ino) uniquely determines a file."

Based on that very weak statement, at most it might make sense to check
that two separate and simultaneously mounted filesystems don't end up
with the same fsid just in case there *are* programs foolish enough to
use (fsid,ino) as a uniqueness check.

--D

> +
> +status=0
> +exit
> diff --git a/tests/generic/802.out b/tests/generic/802.out
> new file mode 100644
> index 000000000000..0202a9a2c108
> --- /dev/null
> +++ b/tests/generic/802.out
> @@ -0,0 +1,4 @@
> +QA output created by 802
> +**** fsid after mount cycle ****
> +FSID_SCRATCH
> +FSID_CLONE
> -- 
> 2.43.0
> 
> 
