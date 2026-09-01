Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B70288505;
	Tue,  1 Sep 2026 20:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788295870; cv=none; b=A/ppebqyNjwKYuT80MINVpfAFna2trSRwC4gyIoM1mZFDG4CSxASD5u8d0vGbjvKRk2pG2UtUJkbzCNyhMgEczQAzfYE5WgUdP710/FVnP3AehohJqB6o9CFiIDLSVbDmlXDdgwtZSAuhrff+QIPI1G2LTBurjoGdLbPql/FD+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788295870; c=relaxed/simple;
	bh=O6trVnOKCK60Y6liPwwhjr3/HRUcPg1FRLyohf6pdQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyTFEda2J8Sdi61pFffg9oqRFPfpYcaSbz53Mg3lnj6+TZBXP4lavuH2Pr+IZk5rEF/R9uO5XKpY+PYQt3S4s2L7Y56yojW7EKw6B+H3N2uIltPNa7SC8NzqmhBX89Ol4pKjyWMIek4apcwOq8a43JLnuKWC7UVvoud/JA4AcQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFwRo4Cy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFwRo4Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50DF1F000E9;
	Tue,  1 Sep 2026 20:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788295869;
	bh=lf99BDB39f+iJE0gbCCCR6NEsjsfCktKqPLXvOUL2No=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TFwRo4Cygqknk8EhEiieRS9uGZhsIJ9Z22D3dH+5lsUXHJx8QmetrmnIJX8Q3y8GS
	 YNFCZPGNjfM9YRlWexJwLj6D0rRzqZOGh+Kj4m/PSpX1N/zLd+GYZ14jxjeqv2LNYZ
	 U/557rsOuvQWBhcgYlIhwhOpgYL1eHYgdgPIUEsoifR4xTq/Tc491zI5v6Dej/jrvk
	 xOKarRl0NXzm2bv5iCDbkuXeqbj6WG8bLGUA9VTdxh6gbDXvrTZ4IrXYcVllrQUFv4
	 zTFzdEtHGsiRxCK+orp9Cwjvkd/l8UWsaWSyEQTbLkwNqbZdAb8rwuc733S5fuCVU8
	 CtWFJuYZK4qZg==
Date: Wed, 2 Sep 2026 04:51:02 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
Subject: Re: [PATCH v8 13/13] fstests: test UUID consistency for clones with
 metadata_uuid
Message-ID: <apc5PMJFYtrUyG8U@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, djwong@kernel.org
References: <cover.1784949154.git.asj@kernel.org>
 <905a961a3bb2ec345285f056053e3016ad3bef6e.1784949155.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905a961a3bb2ec345285f056053e3016ad3bef6e.1784949155.git.asj@kernel.org>

On Sat, Jul 25, 2026 at 03:39:10PM +0800, Anand Jain wrote:
> Btrfs and xfs uses the metadata_uuid superblock feature to change the
> on-disk UUID without rewriting every block header. This patch adds a
> sanity check to ensure UUID consistency when a filesystem with
> metadata_uuid enabled is cloned.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/806     | 74 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/806.out |  6 ++++
>  2 files changed, 80 insertions(+)
>  create mode 100644 tests/generic/806
>  create mode 100644 tests/generic/806.out
> 
> diff --git a/tests/generic/806 b/tests/generic/806
> new file mode 100644
> index 000000000000..6d3166491006
> --- /dev/null
> +++ b/tests/generic/806
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 806
> +#
> +# Verify that the cloned filesystem UUID remains consistent, even when the
> +# `metadata_uuid` feature is enabled.
> +#
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
> +filter_pool()
> +{
> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
> +}
> +
> +# Create base loop device and its clone, applying the metadata_uuid tuning
> +# callback to the base filesystem before the copy occurs.
> +devs=()
> +_loop_image_create_clone devs _change_metadata_uuid

Should we have and run a _require_metadata_uuid before changing it?
As I know, btrfs can do `_require_btrfs_fs_feature metadata_uuid`.

> +mkdir -p $TEST_DIR/$seq
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Get the uuid from the source device
> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
> +
> +# Mount both clone and baseline
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
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
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +
> +findmnt -o SOURCE,TARGET,UUID "${devs[0]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +findmnt -o SOURCE,TARGET,UUID "${devs[1]}" | tail -n +2 | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +
> +status=0
> +exit
> diff --git a/tests/generic/806.out b/tests/generic/806.out
> new file mode 100644
> index 000000000000..918f422ecddf
> --- /dev/null
> +++ b/tests/generic/806.out
> @@ -0,0 +1,6 @@
> +QA output created by 806
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> +**** mount cycle ****
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> -- 
> 2.43.0
> 
