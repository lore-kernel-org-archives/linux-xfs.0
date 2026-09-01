Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAFF4A13B0;
	Tue,  1 Sep 2026 18:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788288717; cv=none; b=mUEkt9LR760mkfe+3S8rGRv/ujmSelrdBO18o7dCbrZqXxl0ZEpGUfAU2CFtZzPLnEopon+FvuBPP8q87Az+av7hwJ5JTPcEBtPL0Btv5z8RZfl1E/e6jzMEhCI4dcGuY4jBYb5XD2KAxlpxEbd/V4svnqOQ39gL6s6zWviUtjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788288717; c=relaxed/simple;
	bh=N2sreEKsDcVI84Eu5n2UeUAeL3ybecKJOOqlNYIxixA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QYsf3wJXIG5CunN+/TXcj6mWu4FcoLQeaw/S0fJTLn7WJOGKB7MXesOiNFDhVrwismeYgXjR+BJ5bUdmG11ghC5xsdTU6JBlDj6EICAj2+Wj7pnv444BcUWG8OXRCYGOKSDZL0RoLq2yKzK5O+oSeT3RwiQ/qmZUmoor4BzNte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gvy3hK2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gvy3hK2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3005B1F00A3E;
	Tue,  1 Sep 2026 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788288714;
	bh=DTElpTF2Qn/IaBTa9jxhtkZ5uzOwfG9EJYNuwd/znTA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gvy3hK2+4VwA8xWxUJnLCFolVKknSpywUJuPwq3DwufQTyePpWEUz+NacHISS8R3H
	 Cn3QVcVjDk0alKhMtuJwPAVTziMaX3gWBIjwheccHCkhUTvc5Y1hebQEtHvJUR3rOh
	 2/aTJPMOw3t6YKKJI+OyfDxnBkiQX/nPOrMztiXWWdaThjB+n0i0xo6ctaCTZ4v1yD
	 wdDG6Z7cZQ7qnKFvHR1Vn39OxXNl9faMkk5Od+iUGo47kRd8cki7vctKGKjVoiugF4
	 egymNTSWd4H49ToeYHqnlw1P9LJO9i80+9IKl5atvXvrmzA0fHSCPPJNdz5a/R7hnb
	 +/hk+fV9+/fMQ==
Date: Wed, 2 Sep 2026 02:51:48 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 08/13] fstests: verify f_fsid for cloned filesystems
Message-ID: <apcdo8K-Lfi5imbg@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <f68b3bd9fcee878289f8ddd7c85a6913c89772cd.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68b3bd9fcee878289f8ddd7c85a6913c89772cd.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:05PM +0800, Anand Jain wrote:
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

Better to `rm -rf $TEST_DIR/$seq` before creating a new one.

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

Hmm... what if "$fsid_scratch" is same with "$fsid_clone"?

> +
> +status=0
> +exit

_exit 0

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
