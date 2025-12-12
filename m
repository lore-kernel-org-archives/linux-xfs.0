Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F6179F2
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 20:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765570802; cv=none; b=TsDi3uNUQK//0DuLnUMpyFJ4qfqzvc6cJUK8WU0OVY16t+aSNCuCXhYU+cX8KXIeBZxueusvKKEDly9Di3TJcKjy7M2hJA6xAgfDkv7XhGFD0hDzpevFAMpbnnWbWhJIrJN4sqTygcajzshcNxF76vfo1UY998RtbxMduseknuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765570802; c=relaxed/simple;
	bh=qWRej7fCHx+FIBK2odt+nz4xkI+lRmUCrnsGrAjSVKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2FiOElEd42Vz0X9q8I58VvcnjaDLCZOS3CwSWZxYvXRUQXvZUCYqo0x2KMD3kwRXOoMG9bRoYwDQJ2tt9u8HI/HMgAQ9x3tKcPomAhDVob7LVUheEcd9ta9qHDDBT1c7t1JxVAd4tkzvbu/qwJNhb+Vt68+h8/dhxPZvexe2ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVkpfGBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVkpfGBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94226C4CEF1;
	Fri, 12 Dec 2025 20:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765570801;
	bh=qWRej7fCHx+FIBK2odt+nz4xkI+lRmUCrnsGrAjSVKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IVkpfGBID5IVLMD+TkHMTxLPWoPhM4zN3JPxPODFikI9PLLGsmQ89jpGBpKurxNE5
	 ZNCd6ebXJHks6OFcBqv//+y7Melzfp/7xHIzfAG1dT/eKCISQi+NWKlMi6e6Egvb9k
	 AZqTxUuxZtnX1x5M4x5ccR+YnOjGedwOf5M2m7inN7RrnNfX27t1tGZQfXkfShyeqi
	 czx68q2YSeoUdk8cmY1FGFrda3pjAKoP5lfUmsMXt0rYS19bD5TA7FwAe2AGj/0SYo
	 OCTJB7skBL4LYO03P+83RklNQB2f/+rzKcdZw1tXt0C0Y07gyhBWxRO4lKvMXwhHv7
	 swVHz/KJKbZ9A==
Date: Fri, 12 Dec 2025 12:20:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: test reproducible builds
Message-ID: <20251212202000.GG7725@frogsfrogsfrogs>
References: <20251212081519.627879-1-luca.dimaio1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212081519.627879-1-luca.dimaio1@gmail.com>

On Fri, Dec 12, 2025 at 09:15:19AM +0100, Luca Di Maio wrote:
> With the addition of the `-p` populate option, SOURCE_DATE_EPOCH and
> DETERMINISTIC_SEED support, it is possible to create fully reproducible
> pre-populated filesystems. We should test them here.
> 
> Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> ---
>  tests/xfs/841     | 171 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/841.out |   3 +
>  2 files changed, 174 insertions(+)
>  create mode 100755 tests/xfs/841
>  create mode 100644 tests/xfs/841.out
> 
> diff --git a/tests/xfs/841 b/tests/xfs/841
> new file mode 100755
> index 00000000..e77533c3
> --- /dev/null
> +++ b/tests/xfs/841
> @@ -0,0 +1,171 @@
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

I forget, didn't mkfs.xfs -p appear before adding SOURCE_DATE_EPOCH /
DETERMINISTIC_SEED?  There's nothing in the --help screen, but I think
you could detect it with

	grep -q SOURCE_DATE_EPOCH $MKFS_XFS_PROG || \
		_notrun "mkfs.xfs does not support SOURCE_DATE_EPOCH"

> +
> +	rm -f "$check_img"
> +
> +	if [ $uuid_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support -m uuid= option"
> +	fi
> +	if [ $proto_support -ne 0 ]; then
> +		_notrun "mkfs.xfs does not support -p option for directory population"
> +	fi
> +}
> +
> +# Create a prototype directory with all file types supported by mkfs.xfs -p
> +_create_proto_dir()
> +{
> +	rm -rf "$PROTO_DIR"
> +	mkdir -p "$PROTO_DIR/subdir/nested"

If you really want to go wild you could (in addition to the code below)
run fsstress for a thousand or so fs ops to populate $PROTO_DIR with
xattrs and whatnot, which would make the inputs less predictable. ;)

(Just something to think about; the code below is quite all right for a
functional test.)

> +
> +	# Regular files with different content
> +	echo "test file content" > "$PROTO_DIR/regular.txt"
> +	dd if=/dev/zero of="$PROTO_DIR/zeros" bs=1k count=4 2> /dev/null
> +	echo "file in subdir" > "$PROTO_DIR/subdir/nested.txt"
> +	echo "deeply nested" > "$PROTO_DIR/subdir/nested/deep.txt"
> +
> +	# Empty file
> +	touch "$PROTO_DIR/empty"
> +
> +	# Symbolic links (file and directory)
> +	ln -s regular.txt "$PROTO_DIR/symlink"
> +	ln -s subdir "$PROTO_DIR/dirlink"
> +
> +	# Hardlink
> +	ln "$PROTO_DIR/regular.txt" "$PROTO_DIR/hardlink"
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
> +
> +	# File with extended attributes
> +	echo "file with xattrs" > "$PROTO_DIR/xattrfile"
> +	setfattr -n user.testattr -v "testvalue" "$PROTO_DIR/xattrfile" 2> /dev/null || true
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
> +	echo "Hash 1: $hash1"
> +	echo "Hash 2: $hash2"
> +	echo "Hash 3: $hash3"
> +	_fail "Reproducibility test failed - images are not identical"

As a general note, printing "ERROR: Filesystem images differ!" (or any
string that's not in the 841.out file) is enough to fail the test, so
there's no need to call _fail.

Other that those comments, this looks good.  Thanks for launching us
into the reproducible fs image era!

--D

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
> 2.52.0
> 
> 
