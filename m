Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9B23CC7EB;
	Tue, 29 Sep 2026 01:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790646519; cv=none; b=Grauxw9kRnhxKhDHz+J6I+V8Dzhzc86oK/bgEJokrT9kyN3C4eKMdW4IdhdgmptWSGqSkyXkbrLZLKTghCwmDmGXRfK/dIJdWa/VNP6IUnxiNXxbhHDYiJlB0HPeSHOHcdmt41ko5InOMHIz4iGkaxV1g/a6Eoa/exyhTWLkTxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790646519; c=relaxed/simple;
	bh=5iPK0MZ1DCNkTQoHyV92zRWN4j/jr67uDYV2+I4JVpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEXdbkcrSMOqBlcoHxyd+ZZOi7fGazK7WFAInafim0jswNccZCu2i80VN8IJM+hVmn1jItX4l8Tcn2KfGMgIWPGQ30WmlDIHUX3Y0KVuaYW0OmPUE8mxAdxaPk5EqGA5QgQ5uPW7bt466bWRbJjxadIh/QXo0NGStGqXNF/LN5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QlGX1HUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QlGX1HUq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 53EF21F000FF;
	Tue, 29 Sep 2026 01:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790646515;
	bh=V4OY4uVFG1N/nJHEJkD2NhYAdbYGKtcJLSk0OLr2x8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QlGX1HUqB3nVc8TWJPoPN/4cK5HvCHiMLy2CgJ6hAnPGetlJSElbLu13Ry7w2UQOe
	 9Dea89Xn0zQQ+z0AhxzPxAIN23QW5J4oOQgB7i+8UtZJqXeQ6YxfAhAzhfPn9L+U7Y
	 aJmuYqctHrOMZRAMf/3mYXBqvOUgPB9javXGShurd/ELpU8s2p4fWPfO0rIdgiFEsO
	 goxAbVomxXnE34Cu2icN9qUtDW9GyYm01nEzvaRWvZg4W6TOpDyWTd0OmI8j/oQ3M6
	 x9uIQNrVOUo4/vul9w+TAUeW1IzrKc7mhA/rhmFsjWQBR/ZsdelWx65GFuNRqBb1r8
	 xVbVLSeHMzOqg==
Date: Mon, 28 Sep 2026 18:48:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs/2302: add a basic data checksum test
Message-ID: <20260929014834.GJ2705364@frogsfrogsfrogs>
References: <20260924100855.2734089-1-hch@lst.de>
 <20260924100855.2734089-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100855.2734089-8-hch@lst.de>

On Thu, Sep 24, 2026 at 12:07:48PM +0200, Christoph Hellwig wrote:
> Setup a zoned loop device, mess up the data and make sure both buffered
> and direct I/O catch it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/2302     | 96 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/2302.out | 25 ++++++++++++
>  2 files changed, 121 insertions(+)
>  create mode 100755 tests/xfs/2302
>  create mode 100644 tests/xfs/2302.out
> 
> diff --git a/tests/xfs/2302 b/tests/xfs/2302
> new file mode 100755
> index 000000000000..d0ef9abc87b0
> --- /dev/null
> +++ b/tests/xfs/2302
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Christoph Hellwig
> +#
> +# FS QA Test No. 2302
> +#
> +# Test that data checksums detect data corruption using all three bounce
> +# buffering modes.
> +#
> +. ./common/preamble
> +. ./common/filter
> +. ./common/zoned
> +
> +_begin_fstest auto zone quick datacsum
> +
> +cleanup_devices()
> +{
> +	[ -n "$mnt" ] && _unmount $mnt 2>/dev/null
> +	[ -n "$loop_dev" ] && _destroy_loop_device $loop_dev
> +	_destroy_zloop $zloop_dev
> +	cd /
> +	rm -rf $loopfile $zloopdir $mnt
> +}
> +
> +_cleanup()
> +{
> +	cleanup_devices
> +}
> +
> +_require_test
> +_require_loop
> +_require_zloop
> +# hack to only run for block based file systems
> +_require_block_device $SCRATCH_DEV

What XFS filesystem isn't block-based?

> +
> +loopfile="$TEST_DIR/loopfile"
> +zloopdir="$TEST_DIR/zloop"
> +mnt="$TEST_DIR/mnt"
> +
> +test_error_detection()
> +{
> +	local bounce_mode=$1
> +
> +	echo
> +	echo
> +	echo "Testing bounce mode: $bounce_mode"
> +	echo
> +
> +	rm -rf $loopfile $zloopdir $mnt
> +	mkdir -p $mnt
> +	truncate -s 1g $loopfile
> +
> +	local loop_dev=$(_create_loop_device $loopfile)
> +	local zloop_dev=$(_create_zloop $zloopdir 256 0)
> +	local zloop_id=$(echo $zloop_dev | grep -oE '[0-9]+$')
> +
> +	_try_mkfs_dev $loop_dev -r rtdev=$zloop_dev,csum=crc32c \
> +		>> $seqres.full 2>&1 || \
> +		_notrun "cannot mkfs filesystem with data checksums"
> +	_mount $loop_dev -o rtdev=$zloop_dev $mnt
> +
> +	dd if=/dev/urandom of=$mnt/file bs=1M count=200 conv=fsync >/dev/null 2>&1
> +
> +	local rg=`xfs_bmap -v $mnt/file | head -n 3 | _filter_bmap_gno`
> +	local zloop_filename=$(printf "seq-%06u\n" $rg)
> +	local backing_file="$zloopdir/$zloop_id/$zloop_filename"
> +
> +	_unmount $mnt 2>/dev/null
> +
> +	# intentionally corrupt the data on the backing device
> +	xfs_io $backing_file -d -c 'pwrite 0 16384' >> $seqres.full 2>&1

$XFS_IO_PROG here and elsewhere

> +
> +	# should return an error on buffered read
> +	_mount $loop_dev -o rtdev=$zloop_dev $mnt
> +	_set_fs_sysfs_attr $loop_dev csum/read_bounce $bounce_mode
> +	echo "Reading file using cat - should fail"
> +	cat $mnt/file > /dev/null | _filter_test_dir
> +
> +	sleep 1
> +	_unmount $mnt 2>/dev/null
> +
> +	# same with direct I/O
> +	_mount $loop_dev -o rtdev=$zloop_dev $mnt
> +	_set_fs_sysfs_attr $loop_dev csum/read_bounce $bounce_mode
> +	echo "Reading file using O_DIRECT - should fail"
> +	xfs_io -d $mnt/file -c 'pread 0 200M' | _filter_test_dir
> +
> +	sleep 1
> +	cleanup_devices
> +}
> +
> +test_error_detection "never"
> +test_error_detection "always"
> +test_error_detection "lazy"
> +
> +_exit 0
> diff --git a/tests/xfs/2302.out b/tests/xfs/2302.out
> new file mode 100644
> index 000000000000..5e2108b5cec0
> --- /dev/null
> +++ b/tests/xfs/2302.out
> @@ -0,0 +1,25 @@
> +QA output created by 2302
> +
> +
> +Testing bounce mode: never
> +
> +Reading file using cat - should fail
> +cat: /mnt/test/mnt/file: Input/output error

You need to _filter_test this out of the golden output.

Other than those complaints, I think this is a good functional test for
the xfs data checksum support.

--D

> +Reading file using O_DIRECT - should fail
> +pread: Input/output error
> +
> +
> +Testing bounce mode: always
> +
> +Reading file using cat - should fail
> +cat: /mnt/test/mnt/file: Input/output error
> +Reading file using O_DIRECT - should fail
> +pread: Input/output error
> +
> +
> +Testing bounce mode: lazy
> +
> +Reading file using cat - should fail
> +cat: /mnt/test/mnt/file: Input/output error
> +Reading file using O_DIRECT - should fail
> +pread: Input/output error
> -- 
> 2.53.0
> 
> 
