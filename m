Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795460253;
	b=2+p4P4ts9zusEm01i5kLAI8lI71MaAaGLMVyZY72oCywsqGblpPkk36DhH/gIgHUc98t
	 9ry+WwhoIcvZSJv7hT4Pd0mUMluviv7UGxPWintCu5QN5+W2XzyQaj9nE1Myi7K2BRliL
	 aMGIA2NDykgtFS1rho86+O0VnHSsE1eVBaUJ5xMaicjO8J05u8mfSfKRy8/dTgk23ktK5
	 /10U1/Cw6gozQVRXmM4ZPo5vCkV1wa2Gz17acaYXJ1V24PXKBBzDCqb9JarsbQ3knGwLF
	 8D0JJUrc5D7U8DCSL9TrBS1Qu4pLacPEBXf3/hmT2xEwy2wtg9vh3p3+ZivoXgz3ikA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795460253;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=H93CB7j1oNhjdUYK0ZSNjTneR70X6EfbfNI+/55q5ew=;
	b=kQYzZHRw7R6P3gVgRhqMGH+IEETG84bwZYRXQbkaKvA9oQdsVhbu/zoZRcSnotMOfkDq
	 +LOeOlxfV7h61nklCuhXBTJvcirsl6PiqxMR+MvpRaos0V9PQDhgW6u0+ul4Q7GA4m0uZ
	 35VSaCSsOgdtkCryZsE/Yj9fYqQEGuL2FniQ5soPOOMzuo3mIw3GfH0NcyicmGpOyrQrf
	 G937zF5ewo6QDH4oqA9BVqVsFDMjwokrFukDmz3ZWmYh83LwrgJ4KxA1KhQuwXfB7M69b
	 UxkdImddLEmFj9W4ykzrgjOfvPq4xEX0y/Pu81EWMcShRMeECxvdjLCnl0Rmn5YcHQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N22qDFAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96470606A31A;
	Mon, 23 Nov 2026 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N22qDFAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8FC1F000C0;
	Mon, 23 Nov 2026 18:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460253;
	bh=H93CB7j1oNhjdUYK0ZSNjTneR70X6EfbfNI+/55q5ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N22qDFAebF8d4UjhzQWu2mMTYnWBxTYas5KtcaDCQSHOknLswE/0QUdWCR/N7nm9q
	 FCixJs2Lqu3BoFr+eAWHuXBPfYLhKp101i6rFpZnKgWAn649RoakvGSQMWG7AErDaG
	 G1Wn7Vqfd3Nx0lbQl1P0BvX69HH22fo7EOnHZC0OgMvQ7y0kUPZGKONNPA2psackpo
	 RQ4r6QgHnAjZZoTYvOt1iXG+O1ri/Y67sdmwY/kiQq6OX5cha94200fdg6pUC6JGx1
	 1o5UyvLCgLaUbkhdSlXYtD/Pd+DG6kpJwr0Ri56/bq7A4wBN+fDYCcSBxfxSTp2E+o
	 kR57gbbDYyloQ==
Date: Tue, 24 Nov 2026 02:57:24 +0800
From: Zorro Lang <zlang@kernel.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 15/21] fstests: verify exportfs file handles on cloned
 filesystems
Message-ID: <awSMZ6pYfpYH20bZ@zlang-mailbox>
Mail-Followup-To: Anand Jain <asj@kernel.org>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net
References: <cover.1791272793.git.asj@kernel.org>
 <40f9fa47341946da9edbe10498c3d8d789ce202f.1791272793.git.asj@kernel.org>
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
In-Reply-To: <40f9fa47341946da9edbe10498c3d8d789ce202f.1791272793.git.asj@kernel.org>

On Tue, Oct 06, 2026 at 04:55:41PM +0800, Anand Jain wrote:
> Ensure that exportfs can correctly decode file handles on a cloned
> filesystem across a mount cycle, by file handles generated on a
> cloned device remain valid after mount cycle.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/905     | 79 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/905.out |  2 ++
>  2 files changed, 81 insertions(+)
>  create mode 100644 tests/generic/905
>  create mode 100644 tests/generic/905.out
> 
> diff --git a/tests/generic/905 b/tests/generic/905
> new file mode 100644
> index 000000000000..d69c613110db
> --- /dev/null
> +++ b/tests/generic/905
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test No. 905
> +# Verify that file handles encoded on a cloned filesystem remain valid and
> +# resolvable via open_by_handle across a mount cycle and mount order swap.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick exportfs tempfsid
> +
> +_require_test
> +_require_exportfs
> +_require_loop
> +_require_test_program "open_by_handle"
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	_unmount $mnt1 2>/dev/null
> +	_unmount $mnt2 2>/dev/null
> +	_destroy_cloned_loop_devs "${devs[@]}" 2> /dev/null
> +}
> +
> +# Create test dir and test files, encode file handles and store to tmp file
> +create_test_files()
> +{
> +	rm -rf $testdir
> +	mkdir -p $testdir
> +	$here/src/open_by_handle -cwp -o $tmp.handles_file $testdir $NUMFILES
> +}
> +
> +# Attempt to read and decode the saved file handles on the targeted mount point.
> +test_file_handles()
> +{
> +	local opt=$1
> +	local when=$2
> +
> +	echo test_file_handles after $when
> +	$here/src/open_by_handle $opt -i $tmp.handles_file $mnt2 $NUMFILES
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
> +# Mount both identical UUID filesystems simultaneously
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +
> +NUMFILES=1
> +testdir=$mnt2/testdir
> +
> +# Decode file handles of files/dir after cycle mount
> +create_test_files
> +
> +# Cycle mounts and reverse initialization sequence to check if
> +# file handle lookups are okay
> +_unmount $mnt1
> +_unmount $mnt2
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[1]} $mnt2 || \
> +						_fail "Failed to mount dev2"
> +_mount $(_common_dev_mount_options) $(_clone_mount_options) ${devs[0]} $mnt1 || \
> +						_fail "Failed to mount dev1"
> +
> +# Verify file handles can still be resolved post-mount-cycle
> +test_file_handles -rp "cycle mount"
> +
> +_exit 0
> diff --git a/tests/generic/905.out b/tests/generic/905.out
> new file mode 100644
> index 000000000000..234f5ec35863
> --- /dev/null
> +++ b/tests/generic/905.out
> @@ -0,0 +1,2 @@
> +QA output created by 905
> +test_file_handles after cycle mount
> -- 
> 2.43.0
> 
