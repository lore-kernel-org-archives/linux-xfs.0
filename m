Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BB64A13AB;
	Tue,  1 Sep 2026 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788289977; cv=none; b=QSuPmdWEzcofLcW9uMXe7CDhryxvcJobfujuZDu2+U53k+0xB0jeT/AFifI8hTlEwWF0B0VrE4DbbCWZOX4g7yi8G2HrMPkbhNu0DxuZO87luH6Toz+bEZQ8DHDN5NbsnzoB5w0Nd2yfDPVmdrwrIZsX844VDegGvw2pC17ZvLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788289977; c=relaxed/simple;
	bh=zG74Q/zjTznsPd0k03N4eYzfxMQXjPXi7x9IYMEEp24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDpiR3sjNZqQiTbBjz9gwyV16n5rYDeMnF6kzW2XvZER4YXp5CNZE43TNvNzGqZiHntwwxEWRG7zFkTtlFdtvKsa/9UYOlFNxqN2SiuRrAeyHEnXGI3x730gy1/sY98Js5c72umb7kRnmo78Uaa0QTsNO9gvi7/anVMlxKOpi6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMM26e9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMM26e9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389AF1F000E9;
	Tue,  1 Sep 2026 19:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788289969;
	bh=sMIegqMJrkzX9C9fgmacw7fJ5Kh0SLb0eEV7TbF42uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BMM26e9anTVkORjuGbVltEI+EVaF1K99InI7KFBCCOB7jLGl3KrcxFbteHZmFLiQp
	 V5XX/2xoqyxZIn6XtIKpdhu/g1NWVsLXl4zGFnuxemGJuhX5gSYIS3SOq3GdY9kbNv
	 uelBKQzoOkCNWTuIHBuYbp3bJRXIbe6JFjLIva2dxOI3VgtcPYljJ2w0BLIgAGox63
	 oc5KtZs2qToTrwGLHPJ8RxHuGoQpDDPTmmUe58VMSJ3639w9aXgseZId1jYcUU4fS8
	 Qhsh/0Gg9eSfr7Cqg/I47fyADd3gN/JxrKADuS/lKC2wTylrr5w4RzkHdKvOvFw0UZ
	 UrrcMPXn/jFAw==
Date: Wed, 2 Sep 2026 03:12:43 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 09/13] fstests: verify libblkid resolution of
 duplicate UUIDs
Message-ID: <apchlvgfbKJDX1rO@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <0e530686fa2bfb9a4b8ec4596484a4fec6d849e4.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e530686fa2bfb9a4b8ec4596484a4fec6d849e4.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:06PM +0800, Anand Jain wrote:
> Verify how findmnt, df (libblkid) resolve device paths when multiple

I didn't find the `df` test part in this test case.

> block devices share the same FSUUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/803     | 72 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/803.out |  6 ++++
>  2 files changed, 78 insertions(+)
>  create mode 100644 tests/generic/803
>  create mode 100644 tests/generic/803.out
> 
> diff --git a/tests/generic/803 b/tests/generic/803
> new file mode 100644
> index 000000000000..77901592366c
> --- /dev/null
> +++ b/tests/generic/803
> @@ -0,0 +1,72 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 803
> +# Check if the mountinfo based findmnt would resolve to the common uuid
> +# as per the blkid (libblkid based).
> +
> +. ./common/preamble
> +. ./common/filter
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_block_device $TEST_DEV
> +_require_loop
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	umount $mnt1 $mnt2 2>/dev/null
> +	_loop_image_destroy "${devs[@]}" 2> /dev/null
> +}
> +
> +# Normalize pool devices and mount points names
> +filter_pool()
> +{
> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
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
> +# Get the uuid from the source device
> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
> +
> +# Mount both identical UUID filesystems simultaneously
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool

findmnt -n (or --noheadings) can be used here (and below) to avoid piping to
`tail -n +2`.

> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool

Same here

> +
> +# Btrfs assigned a random uuid for the clone fs before the fix.
> +# Cycle mounts and reverse the initialization (source and clone fs) order.
> +echo "**** mount cycle ****"
> +_unmount $mnt1
> +_unmount $mnt2
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +
> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool

Same here

> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool

Same here

> +
> +status=0
> +exit

_exit 0

> diff --git a/tests/generic/803.out b/tests/generic/803.out
> new file mode 100644
> index 000000000000..3a130c662430
> --- /dev/null
> +++ b/tests/generic/803.out
> @@ -0,0 +1,6 @@
> +QA output created by 803
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> +**** mount cycle ****
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> -- 
> 2.43.0
> 
