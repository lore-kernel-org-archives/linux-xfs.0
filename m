Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795459816;
	b=DGxdpBYNRHh633O1uJ3bCjuajzPGCE/Zcp/+I7J7Nnw1Xw46oGtWLHu5EhyQKQgX+dzz
	 57uup+Kz7XFJR3c7Rz328T+H1JXLf6zqvRcjKXEFIsFQM+xYLTQp7seY6lOaoxpz9X6j0
	 M/R1T0HD2/l4ZKWFPsz9nYIWr3k/6Pjh3TsU+Tfv8fcw4fqYPEJuLhHFsfvh5uTkw32jP
	 RGqpxnxYP3IFsuMws34RL4d81Ty23iEiu2ayUbnXrIcwPkXeC3wgZw/fdLUmLlw2Lt0v1
	 E9jMkGK8s225qkJw0fQ0l9T2hxWTqu4vU3kRtkLMwxBGXrihAWvmvMLDd3i5qFRmz+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459816;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Mf06FWxHhnhiAGhq4W+H/SgH1QQ43askODqmccvcZiQ=;
	b=fcUF7L9NF7IgW+6wRAm1fp2OCeE2RC04BnEJQRBw/eLwakNqcVafp/TvSyrPob/Bu0MV
	 jZSnvFg62mask1qmwEsAcL9biq4KPkiSuHUpinQ68J3ZiYobITDmvuRB9psYVMz4DGD4P
	 364sxxHczzCko+obBlmgNVz5lU81BeglS8+eRVa3Fg+vJ9uHUTHCDegyChVZkWzoTmlkP
	 hEVgRBYG+V9zko9sP8HClZZBt+aDubxLiBct2f1rDftKOmg5JpIGl/4yTT/j7h3lIWdZR
	 INRMoahPoG33FnGJQ8uTAK6PP6koTJM1y3jl1SPSNH6Wuhiv3ToIqOKr7AoXbkbtIVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bOmWzehn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7284C606A31E;
	Mon, 23 Nov 2026 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bOmWzehn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84A31F000D0;
	Mon, 23 Nov 2026 18:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459815;
	bh=Mf06FWxHhnhiAGhq4W+H/SgH1QQ43askODqmccvcZiQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bOmWzehndH0k1dcnMDGz9vKpHEArNWA4J9L/qVTGnNw+pcoij5M3Y1Grt7yBxz91L
	 wXYO67R9ZEzwXzaWRrT7K/jUOK7Jd8SFlYltyIbOllUb5Q6xriuM9fIwmkX77cBHdT
	 EiARmq2a1q24rfG8V0eNkrBSo8NZAU9oDZIAX1yzDlHc85SmMq25gDmPUWFYRmdX2V
	 UnOVWZmdQW2R7IU+AQTF+yp+EHPHiiYpomaFntvlFVYexJTPbaLarAGk/tjSfv9gqX
	 +w2LxXSC2ZNALMnxzjDfkVJaAyjFQAvik5kesG2UhQk1J3R2gZV5v0IwakHOodmG10
	 GSBDdoNhSDxtg==
Date: Tue, 24 Nov 2026 02:50:06 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 12/21] fstests: verify libblkid resolution of duplicate
 UUIDs
Message-ID: <awSKKSvBRMrcFfcR@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <819a40991baec14ff589da95f3e68af91c33fdf1.1791272793.git.asj@kernel.org>
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
In-Reply-To: <819a40991baec14ff589da95f3e68af91c33fdf1.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:38PM +0800, Anand Jain wrote:
> Verify how findmnt, df (libblkid) resolve device paths when multiple
> block devices share the same FSUUID.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  tests/generic/903     | 71 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/903.out |  6 ++++
>  2 files changed, 77 insertions(+)
>  create mode 100644 tests/generic/903
>  create mode 100644 tests/generic/903.out
> 
> diff --git a/tests/generic/903 b/tests/generic/903
> new file mode 100644
> index 000000000000..d8aeba691fd4
> --- /dev/null
> +++ b/tests/generic/903
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test No. 903
> +# Check if the mountinfo based findmnt would resolve to the common uuid
> +# as per the blkid (libblkid based).
> +
> +. ./common/preamble
> +. ./common/filter
> +
> +_begin_fstest auto quick mount tempfsid
> +
> +_require_test
> +_require_loop
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	umount $mnt1 $mnt2 2>/dev/null
    ^^^^^^
   _unmount

> +	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
> +}
> +
> +# Normalize pool devices and mount points names
> +filter_pool()
> +{
> +	sed -e "s|${devs[0]}|DEV1|g" -e "s|${mnt1}|MNT1|g" \
> +	    -e "s|${devs[1]}|DEV2|g" -e "s|${mnt2}|MNT2|g" | _filter_spaces
> +}
> +
> +rm -rf $TEST_DIR/$seq 2>/dev/null
> +mkdir -p $TEST_DIR/$seq
> +# Setup base loop device and its clone
> +devs=()
> +_create_cloned_loop_devs devs
> +mnt1=$TEST_DIR/$seq/mnt1
> +mnt2=$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +# Get the uuid from the source device
> +fsuuid=$(blkid -s UUID -o value ${devs[0]})
> +
> +# Mount both identical UUID filesystems simultaneously
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[0]}" | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[1]}" | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +
> +# Btrfs assigned a random uuid for the clone fs before the fix.
> +# Cycle mounts and reverse the initialization (source and clone fs) order.
> +echo "**** mount cycle ****"
> +_unmount $mnt1
> +_unmount $mnt2
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +
> +findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[0]}" | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +findmnt --noheadings -o SOURCE,TARGET,UUID "${devs[1]}" | \
> +				sed -e "s/${fsuuid}/FSUUID/g" | filter_pool
> +
> +_exit 0
> diff --git a/tests/generic/903.out b/tests/generic/903.out
> new file mode 100644
> index 000000000000..7683506e1c94
> --- /dev/null
> +++ b/tests/generic/903.out
> @@ -0,0 +1,6 @@
> +QA output created by 903
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> +**** mount cycle ****
> +DEV1 MNT1 FSUUID
> +DEV2 MNT2 FSUUID
> -- 
> 2.43.0
> 
