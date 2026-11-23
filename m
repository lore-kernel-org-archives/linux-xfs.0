Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460409;
	b=a4teBaAnUe0FWJffPq628VA8NMw8MiOfWHHgy6PfxveqruAHGQmUFdJFsINXqnLw8mro
	 ZOul8pw6F+eDSoYW4USdqClX0r/fFdQ73WEgaspfEr1T6Q6XAKUijNuxZeXEpwfr3Rct3
	 q9AhLbFBNDt2/l4X/LD3Yq+4R5Jf1ZHHibn5HUTMJe6jGqklhSrIaietU1GNn5Jtc8ppD
	 XVZtUbeCVY+VlRQDq+ooH3rVhjMwQEYdMVSrA4x+VAm8udc1gnLeGX+t1ez7l4jAfTP22
	 vLdhLdaZJt/zdP1qZVaOwxH5/WX+7iLNsld0M9tRPt/TjHfcEE1Pl9hC/rln4wWPWeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460409;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=emheEOQkou06XepSqyP4hmHa7Pz+4doN2S3r24jNc0g=;
	b=uRhn1PKhGsVs8ITsFVsApL4cOufbX/ZKYUElpx4taOmZqb6XK+b2IT8OCMvibJTuLhhA
	 FpS5nvO3E/9c+1DkgY7W2mD/lNPD7hK8hA5dJ8MmWD9NpQciSLOixVzT5WTVF+5iMymkM
	 Yg8UCI5UqbY9zPr4WmVcpJrVcUsIMQ4CyHgO7TZFFpZiWOUWmAjEfgqKEhLJnKiEhakfu
	 QZ+zZmrHJAAlGhrOlik3B7fRem/UCLYnp2NFt/v5OXSbNi+SEau/wvLzsiJH4srsNNyku
	 5gebPB5i9T9ygq/aFzW74kl3GNDjfnVcjNczbe2x4tRfvv7ykmSlIxdTHPHWa1FQBrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJSDmHbG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAEF7606A321;
	Mon, 23 Nov 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SJSDmHbG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DD41F000C4;
	Mon, 23 Nov 2026 19:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460409;
	bh=emheEOQkou06XepSqyP4hmHa7Pz+4doN2S3r24jNc0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SJSDmHbG2GG5RavcVePuZOUeTweTxW4Loxe1K3eoNchxHON7lkheWMG3wBv0NBkC0
	 XGvrIQRuuTRn5/EPdLixBphkBezSw8TLAq9zeQNoAWfIOiAUemIqM4EefzHp8BUwgz
	 di658A5HtzYa+yDcjqePlVIcI/9aY8X2odPXqzP7iQTGXw+F8ePdr0WGWQsbm+3xxw
	 1FwXL69l/K3ocVKvLbkwvs13ij2TnIV94GldpEJmCO14xXiVC7C0TlCdaWjWaoLrg/
	 8fCXMo/o8JsjDErxaCdZHS2Vg0b1lugOBRTUMTx+tgfyU0GrO/wicR7/jwGohzWXS2
	 OBHWDz/hQSBiQ==
Date: Tue, 24 Nov 2026 03:00:01 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 18/21] fstests: test UUID consistency for clones with
 metadata_uuid
Message-ID: <awSM_yAiZm9rIFdG@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <97ba190c96d3fa545404d2c2f489d34f8f9466e9.1791272793.git.asj@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97ba190c96d3fa545404d2c2f489d34f8f9466e9.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:44PM +0800, Anand Jain wrote:
> Btrfs and xfs uses the metadata_uuid superblock feature to change the
> on-disk UUID without rewriting every block header. This patch adds a
> sanity check to ensure UUID consistency when a filesystem with
> metadata_uuid enabled is cloned.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---



>  tests/generic/906     | 74 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/906.out |  6 ++++
>  2 files changed, 80 insertions(+)
>  create mode 100644 tests/generic/906
>  create mode 100644 tests/generic/906.out
> 
> diff --git a/tests/generic/906 b/tests/generic/906
> new file mode 100644
> index 000000000000..99516f18aa39
> --- /dev/null
> +++ b/tests/generic/906
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test No. 906
> +#
> +# Verify that the cloned filesystem UUID remains consistent, even when the
> +# `metadata_uuid` feature is enabled.
> +#
> +
> +. ./common/preamble
> +. ./common/filter
> +
> +_begin_fstest auto quick mount tempfsid
> +
> +_require_test
> +_require_loop
> +_require_metadata_uuid
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	umount $mnt1 $mnt2 2>/dev/null

  _unmount

> +	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
> +}
> +
> +filter_pool()
> +{
> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
> +}
> +
> +rm -rf $TEST_DIR/$seq 2>/dev/null
> +mkdir -p $TEST_DIR/$seq
> +# Create base loop device and its clone, applying the metadata_uuid tuning
> +# callback to the base filesystem before the copy occurs.
> +devs=()
> +_create_cloned_loop_devs devs _change_metadata_uuid
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Get the uuid from the source device
> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
> +
> +# Mount both clone and baseline
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +
> +# Cycle mounts and reverse the initialization order to ensure UUID tracking
> +# doesn't mismatch or flip when metadata_uuid optimization is active.
> +echo "**** mount cycle ****"
> +_unmount $mnt1
> +_unmount $mnt2
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +
> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +
> +_exit 0
> diff --git a/tests/generic/906.out b/tests/generic/906.out
> new file mode 100644
> index 000000000000..b484c86d8e7f
> --- /dev/null
> +++ b/tests/generic/906.out
> @@ -0,0 +1,6 @@
> +QA output created by 906
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> +**** mount cycle ****
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> -- 
> 2.43.0
> 
