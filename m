Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAAF2EACF9;
	Thu,  8 Jan 2026 16:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891279; cv=none; b=OORXy+n86dEXBTOrhhowFbLQAGeC8wO1bziAu+3XM6JX4+u6hsXPO2GIoDyJei5PkkH0PIUKeUex/g12Vb3/osSHv+9EmHQQ3qEC7lR/bktxw9o8R64hRkeEgUEkymvfWh9j6dhChh1GTJmssyr6xxM7NHVyxsqr6X5wGPM5dKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891279; c=relaxed/simple;
	bh=ZYjB1YJNAIJtgtXOIjL4Yv4AR5ZDUXeV3E6u3KdKjyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QRHPeWBdRdOkDut5F+J+tWRMUi686wgBhLIBQJb1nmaby5TXpYXu3IH4TUEa48BIFa85LWDIPMaWKD27eVSoNQOycyro7+4ydEobsI3LKzer0RpjZaWOL/NCqxoqPs2Um8l8YNB4bxhlwijjodVQtWNXZSUJsDvz8FER8ZNO9cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7h48H86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7h48H86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212DDC116C6;
	Thu,  8 Jan 2026 16:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767891279;
	bh=ZYjB1YJNAIJtgtXOIjL4Yv4AR5ZDUXeV3E6u3KdKjyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P7h48H86Ht8O6HI+IfGyRpXRflNFQHqeG8cP6Ix/N6Cm8pvMYgtoeJ87s8k+2TbT4
	 HcHchE1cpqhH95ivDL9FXOb2/dBETL7Zh/1C8H8udrqIPLHGtGrzAq8kLKUgBH42sW
	 LOguniwUU6fxg5IU5H+Ma41+wv37xV+EUYFkqvWlka2v8xkPFfI9ayxLMdNnNopDfn
	 mq7vzCrPU5kgeIUdwPIbt/YRPQr3tpPyz8t5pkzShOGnAmqlr/Klekp0IPup5jzjQF
	 y3Qn3I2KldqzU0so6tXeP8U2NwggrX2rjjNwy2JrsBygpuA6pUutc9U9oK42MgE6Yn
	 8slXVPGBF6+zg==
Date: Thu, 8 Jan 2026 08:54:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, hch@infradead.org,
	david@fromorbit.com, zlang@redhat.com
Subject: Re: [PATCH v6] xfs: test reproducible builds
Message-ID: <20260108165438.GJ15551@frogsfrogsfrogs>
References: <20260108142222.37304-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260108142222.37304-1-luca.dimaio1@gmail.com>

On Thu, Jan 08, 2026 at 03:22:22PM +0100, Luca Di Maio wrote:
> With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> DETERMINISTIC_SEED support, it is possible to create fully reproducible
> pre-populated filesystems. We should test them here.
> 
> v1 -> v2:
> - Changed test group from parent to mkfs
> - Fixed PROTO_DIR to point to a new dir
> - Populate PROTO_DIR with relevant file types
> - Move from md5sum to sha256sum
> v2 -> v3
> - Properly check if mkfs.xfs supports SOURCE_DATE_EPOCH and
>   DETERMINISTIC_SEED
> - use fsstress program to generate the PROTO_DIR content
> - simplify test output
> v3 -> v4
> - Add _cleanup function
> v4 -> v5
> - copy _cleanup from common/preamble
> v5 -> v6
> - remove debug typo/leftover
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>

Looks good to me still
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/841     | 173 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/841.out |   3 +
>  2 files changed, 176 insertions(+)
>  create mode 100755 tests/xfs/841
>  create mode 100644 tests/xfs/841.out
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> new file mode 100755
> index 00000000..5f981d0a
> --- /dev/null
> +++ b/tests/xfs/841
> @@ -0,0 +1,173 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Chainguard, Inc. All Rights Reserved.
> +#
> +# FS QA Test No. 841
> +#
> +# Test that XFS filesystems created with reproducibility options produce
> +# identical images across multiple runs. This verifies that the combination
> +# of SOURCE_DATE_EPOCH, DETERMINISTIC_SEED, and -m uuid= options result in
> +# bit-for-bit reproducible filesystem images.
> +
> +. ./common/preamble
> +_begin_fstest auto quick mkfs
> +
> +# Image file settings
> +IMG_SIZE="512M"
> +IMG_FILE="$TEST_DIR/xfs_reproducible_test.img"
> +PROTO_DIR="$TEST_DIR/proto"
> +
> +# Fixed values for reproducibility
> +FIXED_UUID="12345678-1234-1234-1234-123456789abc"
> +FIXED_EPOCH="1234567890"
> +
> +_cleanup() {
> +	cd /
> +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> +	rm -r -f $tmp.* "$PROTO_DIR" "$IMG_FILE"
> +}
> +
> +# Check if mkfs.xfs supports required options
> +_check_mkfs_xfs_options()
> +{
> +	local check_img="$TEST_DIR/mkfs_check.img"
> +	truncate -s 64M "$check_img" || return 1
> +
> +	# Check -m uuid support
> +	$MKFS_XFS_PROG -m uuid=00000000-0000-0000-0000-000000000000 \
> +		-N "$check_img" &> /dev/null
> +	local uuid_support=$?
> +
> +	# Check -p support (protofile/directory population)
> +	$MKFS_XFS_PROG 2>&1 | grep populate &> /dev/null
> +	local proto_support=$?
> +
> +	grep -q SOURCE_DATE_EPOCH "$MKFS_XFS_PROG"
> +	local reproducible_support=$?
> +
> +	rm -f "$check_img"
> +
> +	if [ $uuid_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support -m uuid= option"
> +	fi
> +	if [ $proto_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support -p option for directory population"
> +	fi
> +	if [ $reproducible_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support env options for reproducibility"
> +	fi
> +}
> +
> +# Create a prototype directory with all file types supported by mkfs.xfs -p
> +_create_proto_dir()
> +{
> +	rm -rf "$PROTO_DIR"
> +	mkdir -p "$PROTO_DIR"
> +
> +	$FSSTRESS_PROG -d $PROTO_DIR -s 1 -n 2000 -p 2 -z \
> +		-f creat=15 \
> +		-f mkdir=8 \
> +		-f write=15 \
> +		-f truncate=5 \
> +		-f symlink=8 \
> +		-f link=8 \
> +		-f setfattr=12 \
> +		-f chown=3 \
> +		-f rename=5 \
> +		-f unlink=2 \
> +		-f rmdir=1
> +
> +
> +	# FIFO (named pipe)
> +	mkfifo "$PROTO_DIR/fifo"
> +
> +	# Unix socket
> +	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
> +
> +	# Block device (requires root)
> +	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
> +
> +	# Character device (requires root)
> +	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
> +}
> +
> +_require_test
> +_check_mkfs_xfs_options
> +
> +# Create XFS filesystem with full reproducibility options
> +# Uses -p to populate from directory during mkfs (no mount needed)
> +_mkfs_xfs_reproducible()
> +{
> +	local img=$1
> +
> +	# Create fresh image file
> +	rm -f "$img"
> +	truncate -s $IMG_SIZE "$img" || return 1
> +
> +	# Set environment variables for reproducibility:
> +	# - SOURCE_DATE_EPOCH: fixes all inode timestamps to this value
> +	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544) instead of
> +	#   getrandom()
> +	#
> +	# mkfs.xfs options:
> +	# - -m uuid=: fixed filesystem UUID
> +	# - -p dir: populate filesystem from directory during creation
> +	SOURCE_DATE_EPOCH=$FIXED_EPOCH \
> +	DETERMINISTIC_SEED=1 \
> +	$MKFS_XFS_PROG \
> +		-f \
> +		-m uuid=$FIXED_UUID \
> +		-p "$PROTO_DIR" \
> +		"$img" >> $seqres.full 2>&1
> +
> +	return $?
> +}
> +
> +# Compute hash of the image file
> +_hash_image()
> +{
> +	sha256sum "$1" | awk '{print $1}'
> +}
> +
> +# Run a single reproducibility test iteration
> +_run_iteration()
> +{
> +	local iteration=$1
> +
> +	echo "Iteration $iteration: Creating filesystem with -p $PROTO_DIR" >> $seqres.full
> +	if ! _mkfs_xfs_reproducible "$IMG_FILE"; then
> +		echo "mkfs.xfs failed" >> $seqres.full
> +		return 1
> +	fi
> +
> +	local hash=$(_hash_image "$IMG_FILE")
> +	echo "Iteration $iteration: Hash = $hash" >> $seqres.full
> +
> +	echo $hash
> +}
> +
> +# Create the prototype directory with various file types
> +_create_proto_dir
> +
> +echo "Test: XFS reproducible filesystem image creation"
> +
> +# Run three iterations
> +hash1=$(_run_iteration 1)
> +[ -z "$hash1" ] && _fail "Iteration 1 failed"
> +
> +hash2=$(_run_iteration 2)
> +[ -z "$hash2" ] && _fail "Iteration 2 failed"
> +
> +hash3=$(_run_iteration 3)
> +[ -z "$hash3" ] && _fail "Iteration 3 failed"
> +
> +# Verify all hashes match
> +if [ "$hash1" = "$hash2" ] && [ "$hash2" = "$hash3" ]; then
> +	echo "All filesystem images are identical."
> +else
> +	echo "ERROR: Filesystem images differ!"
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/841.out b/tests/xfs/841.out
> new file mode 100644
> index 00000000..3bdfbfda
> --- /dev/null
> +++ b/tests/xfs/841.out
> @@ -0,0 +1,3 @@
> +QA output created by 841
> +Test: XFS reproducible filesystem image creation
> +All filesystem images are identical.
> -- 
> 2.51.0
> 
> 
