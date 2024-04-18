Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5B116C447;
	Thu, 18 Apr 2024 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452200; cv=none; b=R71XDHPYwmsPcxD7aBKJ9cdmX9cJIJ2A7HBfSkf9sYittR01W40r+E84CQAsjllx6Ws6abB5U6p/KYfw4rgjpAPB8hkjJ8Gr9kYY/LuAlFiLj66Qa/QOp/9RBiVmjViZe7dz0OFW2l/UYnRPGepdqx4Wn0cfLt3JZVzZuSJWZtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452200; c=relaxed/simple;
	bh=bCbbprCnpDsVRxZIUWiLm62yk1qbmKtFCwulavZXzmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHyLQN5M95/ZeEyDrioifbxerlUYoxHgzFgLyCPXqj2WtVy5SQkTfzFRz1xWFV/NdmvfrnQLC5NRsXySX+03GaPnx7cR4z0xxvMYIBgC9VJi1VQeF5ioiCsXTcTYsHlGxt8byfki1gKw6eE1/89cbAZ6a7vW9llIxOi4g9hmZm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiIjqr2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiIjqr2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F4FC113CC;
	Thu, 18 Apr 2024 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713452200;
	bh=bCbbprCnpDsVRxZIUWiLm62yk1qbmKtFCwulavZXzmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GiIjqr2hUxbktbZ8BT0354TSE6hadIdqwb7msIP7b9qgk9z3EMGQYXFmHpQcDh8pt
	 EoDITkxmyJp8aX8gqFyYK1SZeM5p08cp0NDTjLuMyNqHhJLQIsnq5fBh2NXwrKDNUc
	 GGCOloF/7ecVmBhjkHVgEB700vC91GZa+SI3/TOtzXnIcuygHJtC5Kv0xGlRLyO8k1
	 1/fJ6v8GqXO/PUlG4FCrKPr/w8hbcP6UN04HmWvsxK8q18+Og+DUpExchSiY9+bWRh
	 QPm+RkLv/Fxra5KxTZzzgzd/V6bbw5LZJdOxoP3rzrBYNZkpv84GXvcVxZfPn27bRF
	 AFJ26s2ps74Rg==
Date: Thu, 18 Apr 2024 07:56:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs/512: split out v4 specific tests
Message-ID: <20240418145639.GH11948@frogsfrogsfrogs>
References: <20240418074046.2326450-1-hch@lst.de>
 <20240418074046.2326450-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418074046.2326450-4-hch@lst.de>

On Thu, Apr 18, 2024 at 09:40:44AM +0200, Christoph Hellwig wrote:
> Split the v4-specific tests into a new xfs/613.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/513     |  13 ---
>  tests/xfs/513.out |   9 ---
>  tests/xfs/613     | 198 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/613.out |  15 ++++

Such numerological coincidence!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  4 files changed, 213 insertions(+), 22 deletions(-)
>  create mode 100755 tests/xfs/613
>  create mode 100644 tests/xfs/613.out
> 
> diff --git a/tests/xfs/513 b/tests/xfs/513
> index ce2bb3491..3a85ed429 100755
> --- a/tests/xfs/513
> +++ b/tests/xfs/513
> @@ -193,10 +193,6 @@ do_mkfs -m crc=1
>  do_test "" pass "attr2" "true"
>  do_test "-o attr2" pass "attr2" "true"
>  do_test "-o noattr2" fail
> -do_mkfs -m crc=0
> -do_test "" pass "attr2" "true"
> -do_test "-o attr2" pass "attr2" "true"
> -do_test "-o noattr2" pass "attr2" "false"
>  
>  # Test discard
>  do_mkfs
> @@ -255,15 +251,6 @@ do_test "-o logbsize=128k" pass "logbsize=128k" "true"
>  do_test "-o logbsize=256k" pass "logbsize=256k" "true"
>  do_test "-o logbsize=8k" fail
>  do_test "-o logbsize=512k" fail
> -do_mkfs -m crc=0 -l version=1
> -# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
> -# prints "logbsize=N" in /proc/mounts, but old kernel not. So the default
> -# 'display' about logbsize can't be expected, disable this test.
> -#do_test "" pass "logbsize" "false"
> -do_test "-o logbsize=16384" pass "logbsize=16k" "true"
> -do_test "-o logbsize=16k" pass "logbsize=16k" "true"
> -do_test "-o logbsize=32k" pass "logbsize=32k" "true"
> -do_test "-o logbsize=64k" fail
>  
>  # Test logdev
>  do_mkfs
> diff --git a/tests/xfs/513.out b/tests/xfs/513.out
> index eec8155d7..399459071 100644
> --- a/tests/xfs/513.out
> +++ b/tests/xfs/513.out
> @@ -13,10 +13,6 @@ FORMAT: -m crc=1
>  TEST: "" "pass" "attr2" "true"
>  TEST: "-o attr2" "pass" "attr2" "true"
>  TEST: "-o noattr2" "fail"
> -FORMAT: -m crc=0
> -TEST: "" "pass" "attr2" "true"
> -TEST: "-o attr2" "pass" "attr2" "true"
> -TEST: "-o noattr2" "pass" "attr2" "false"
>  FORMAT: 
>  TEST: "" "pass" "discard" "false"
>  TEST: "-o discard" "pass" "discard" "true"
> @@ -51,11 +47,6 @@ TEST: "-o logbsize=128k" "pass" "logbsize=128k" "true"
>  TEST: "-o logbsize=256k" "pass" "logbsize=256k" "true"
>  TEST: "-o logbsize=8k" "fail"
>  TEST: "-o logbsize=512k" "fail"
> -FORMAT: -m crc=0 -l version=1
> -TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
> -TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
> -TEST: "-o logbsize=32k" "pass" "logbsize=32k" "true"
> -TEST: "-o logbsize=64k" "fail"
>  FORMAT: 
>  TEST: "" "pass" "logdev" "false"
>  TEST: "-o logdev=LOOP_SPARE_DEV" "fail"
> diff --git a/tests/xfs/613 b/tests/xfs/613
> new file mode 100755
> index 000000000..522358cb3
> --- /dev/null
> +++ b/tests/xfs/613
> @@ -0,0 +1,198 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
> +#
> +# FS QA Test No. 613
> +#
> +# XFS v4 mount options sanity check, refer to 'man 5 xfs'.
> +#
> +. ./common/preamble
> +_begin_fstest auto mount prealloc
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$UMOUNT_PROG $LOOP_MNT 2>/dev/null
> +	if [ -n "$LOOP_DEV" ];then
> +		_destroy_loop_device $LOOP_DEV 2>/dev/null
> +	fi
> +	if [ -n "$LOOP_SPARE_DEV" ];then
> +		_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
> +	fi
> +	rm -f $LOOP_IMG
> +	rm -f $LOOP_SPARE_IMG
> +	rmdir $LOOP_MNT
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_fixed_by_kernel_commit 237d7887ae72 \
> +	"xfs: show the proper user quota options"
> +
> +_require_test
> +_require_loop
> +_require_xfs_io_command "falloc"
> +
> +LOOP_IMG=$TEST_DIR/$seq.dev
> +LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
> +LOOP_MNT=$TEST_DIR/$seq.mnt
> +
> +echo "** create loop device"
> +$XFS_IO_PROG -f -c "truncate 32g" $LOOP_IMG
> +LOOP_DEV=`_create_loop_device $LOOP_IMG`
> +
> +echo "** create loop log device"
> +$XFS_IO_PROG -f -c "truncate 1g" $LOOP_SPARE_IMG
> +LOOP_SPARE_DEV=`_create_loop_device $LOOP_SPARE_IMG`
> +
> +echo "** create loop mount point"
> +rmdir $LOOP_MNT 2>/dev/null
> +mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
> +
> +filter_loop()
> +{
> +	sed -e "s,\B$LOOP_MNT,LOOP_MNT,g" \
> +	    -e "s,\B$LOOP_DEV,LOOP_DEV,g" \
> +	    -e "s,\B$LOOP_SPARE_DEV,LOOP_SPARE_DEV,g"
> +}
> +
> +filter_xfs_opt()
> +{
> +	sed -e "s,allocsize=$pagesz,allocsize=PAGESIZE,g"
> +}
> +
> +# avoid the effection from MKFS_OPTIONS
> +MKFS_OPTIONS=""
> +do_mkfs()
> +{
> +	echo "FORMAT: $@" | filter_loop | tee -a $seqres.full
> +	$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
> +	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
> +		_fail "Fails on _mkfs_dev $* $LOOP_DEV"
> +	fi
> +	. $tmp.mkfs
> +}
> +
> +is_dev_mounted()
> +{
> +	findmnt --source $LOOP_DEV >/dev/null
> +	return $?
> +}
> +
> +get_mount_info()
> +{
> +	findmnt --source $LOOP_DEV -o OPTIONS -n
> +}
> +
> +force_unmount()
> +{
> +	$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
> +}
> +
> +# _do_test <mount options> <should be mounted?> [<key string> <key should be found?>]
> +_do_test()
> +{
> +	local opts="$1"
> +	local mounted="$2"	# pass or fail
> +	local key="$3"
> +	local found="$4"	# true or false
> +	local rc
> +	local info
> +
> +	# mount test
> +	_mount $LOOP_DEV $LOOP_MNT $opts 2>>$seqres.full
> +	rc=$?
> +	if [ $rc -eq 0 ];then
> +		if [ "${mounted}" = "fail" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect mount to fail, but it succeeded"
> +			return 1
> +		fi
> +		is_dev_mounted
> +		if [ $? -ne 0 ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: fs not mounted even mount return 0"
> +			return 1
> +		fi
> +	else
> +		if [ "${mounted}" = "pass" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expect mount to succeed, but it failed"
> +			return 1
> +		fi
> +		is_dev_mounted
> +		if [ $? -eq 0 ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: fs is mounted even mount return non-zero"
> +			return 1
> +		fi
> +	fi
> +
> +	# Skip below checking if "$key" argument isn't specified
> +	if [ -z "$key" ];then
> +		return 0
> +	fi
> +	# Check the mount options after fs mounted.
> +	info=`get_mount_info`
> +	echo ${info} | grep -q "${key}"
> +	rc=$?
> +	if [ $rc -eq 0 ];then
> +		if [ "$found" != "true" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: expected to find \"$key\" in mount info \"$info\""
> +			return 1
> +		fi
> +	else
> +		if [ "$found" != "false" ];then
> +			echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
> +			echo "ERROR: did not expect to find \"$key\" in \"$info\""
> +			return 1
> +		fi
> +	fi
> +
> +	return 0
> +}
> +
> +do_test()
> +{
> +	# Print each argument, include nil ones
> +	echo -n "TEST:" | tee -a $seqres.full
> +	for i in "$@";do
> +		echo -n " \"$i\"" | filter_loop | filter_xfs_opt | tee -a $seqres.full
> +	done
> +	echo | tee -a $seqres.full
> +
> +	# force unmount before testing
> +	force_unmount
> +	_do_test "$@"
> +	# force unmount after testing
> +	force_unmount
> +}
> +
> +echo "** start xfs mount testing ..."
> +# Test attr2
> +do_mkfs -m crc=0
> +do_test "" pass "attr2" "true"
> +do_test "-o attr2" pass "attr2" "true"
> +do_test "-o noattr2" pass "attr2" "false"
> +
> +# Test logbsize=value.
> +do_mkfs -m crc=0 -l version=1
> +# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_size)
> +# prints "logbsize=N" in /proc/mounts, but old kernel not. So the default
> +# 'display' about logbsize can't be expected, disable this test.
> +#do_test "" pass "logbsize" "false"
> +do_test "-o logbsize=16384" pass "logbsize=16k" "true"
> +do_test "-o logbsize=16k" pass "logbsize=16k" "true"
> +do_test "-o logbsize=32k" pass "logbsize=32k" "true"
> +do_test "-o logbsize=64k" fail
> +
> +echo "** end of testing"
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/613.out b/tests/xfs/613.out
> new file mode 100644
> index 000000000..1624617ee
> --- /dev/null
> +++ b/tests/xfs/613.out
> @@ -0,0 +1,15 @@
> +QA output created by 613
> +** create loop device
> +** create loop log device
> +** create loop mount point
> +** start xfs mount testing ...
> +FORMAT: -m crc=0
> +TEST: "" "pass" "attr2" "true"
> +TEST: "-o attr2" "pass" "attr2" "true"
> +TEST: "-o noattr2" "pass" "attr2" "false"
> +FORMAT: -m crc=0 -l version=1
> +TEST: "-o logbsize=16384" "pass" "logbsize=16k" "true"
> +TEST: "-o logbsize=16k" "pass" "logbsize=16k" "true"
> +TEST: "-o logbsize=32k" "pass" "logbsize=32k" "true"
> +TEST: "-o logbsize=64k" "fail"
> +** end of testing
> -- 
> 2.39.2
> 
> 
