Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE25D3CF1FB;
	Mon, 20 Jul 2026 11:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784545826; cv=none; b=XBq+jSu9lQKGWN+7cCReTZ8kkDi7okST9g2Yn/ixxOd50GXkuqksv8VkVUnPcP4P5RoNBiCMUUnruzazGHLuUTq1Su2fouWaiIV26zEuX0dkeaeg8W/WFj7Go5tmNOBM12PSl6zmMoO/CbwP135as2WgWj5dbDLFYWi51IJXoTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784545826; c=relaxed/simple;
	bh=iFb/5Z/YH7CkhLoS7z+aACFB61qpVFboabZh6nnwF4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgSjcyNUiMaoK2JXpq9KN/ec3Jh1atgNFETytwMOycADpG9/hmkd/ODzK2cYlNfDXcQJXDGD6/pSDxr1YyJ21iVq2RmOwAE+Rz3YzM74gILAjnWDO2yROpSwmjbgkPQvwcSjjEx3dxIK08RgiKMNgYd+IAuCWP4t8vs8hfWxeNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h3d8B0xSCzYQtm3;
	Mon, 20 Jul 2026 19:09:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 98E714058D;
	Mon, 20 Jul 2026 19:10:11 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgAHZHAQAl5qvjOfBw--.54318S3;
	Mon, 20 Jul 2026 19:10:11 +0800 (CST)
Message-ID: <fb9a8b94-4bab-471e-b8ae-9093d55d13cd@huaweicloud.com>
Date: Mon, 20 Jul 2026 19:10:08 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
To: Pankaj Raghav <p.raghav@samsung.com>, zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
 pankaj.raghav@linux.dev, hch@lst.de, yi.zhang@huawei.com
References: <20260717064216.3254133-1-p.raghav@samsung.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20260717064216.3254133-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgAHZHAQAl5qvjOfBw--.54318S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuw47uFyxuFy7ZFyDCF18AFb_yoWfWFW7pF
	WFk3W5trZ7Ja47Z3yxCF1DZr98CwsYqFW2vr48KryjvFy5Wrn2kF4Ygry8trWkXr4fA3Z2
	vrs5G34UGw12kFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 7/17/2026 2:42 PM, Pankaj Raghav wrote:
> During the review of WRITE_ZEROES support to XFS, Zhang Yi pointed out
> some important semantics for the boundary blocks when WRITE_ZEROES
> command is used.[1]
> 
> The test cases check the boundary blocks when they are in different
> states and WRITE_ZEROES are issued that straddle the boundary. Along with that,
> test cases have been added when a EoF straddles an allocation unit.
> 
> [1] https://lore.kernel.org/linux-xfs/0b7f1a4f-da1c-4297-8099-98d738070ab7@huaweicloud.com/
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Looks good to me.

Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

> ---
> Changes since v2:
> - Move back to fiemap with the newly added '-e' option.
> 
> Changes since v1:
> - Use filefrag instead of FIEMAP as the latter uses FIEMAP_FLAG_SYNC by
>   default when used via xfs_io (Zhang yi)
> - Add an extra testcase for dirty-unwritten edges (Zhang Yi)
> 
>  common/rc             |   2 +-
>  tests/generic/795     | 177 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/795.out |  19 +++++
>  3 files changed, 197 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/795
>  create mode 100644 tests/generic/795.out
> 
> diff --git a/common/rc b/common/rc
> index 79189e7e..5e59968f 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3008,7 +3008,7 @@ _require_xfs_io_command()
>  		testio=`$XFS_IO_PROG -F -f -c "$command $param 0 1m" $testfile 2>&1`
>  		param_checked="$param"
>  		;;
> -	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
> +	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare" | "fwzero")
>  		local blocksize=$(_get_file_block_size $TEST_DIR)
>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 $((5 * $blocksize))" \
>  			-c "fsync" -c "$command $blocksize $((2 * $blocksize))" \
> diff --git a/tests/generic/795 b/tests/generic/795
> new file mode 100755
> index 00000000..964a8f9a
> --- /dev/null
> +++ b/tests/generic/795
> @@ -0,0 +1,177 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Samsung Electronics.  All Rights Reserved.
> +#
> +# FS QA Test 795
> +#
> +# Verify FALLOC_FL_WRITE_ZEROES (xfs_io "fwzero") on an unaligned range,
> +# exercising every state the two boundary allocation units can be in.
> +#
> +# WRITE_ZEROES must leave the whole requested range backed by *written*
> +# (zeroed) extents while preserving the out-of-range bytes of the partial
> +# boundary units. The possible scenarios are: written_edges, hole_edges,
> +# unwritten_edges and delalloc_edges.
> +#
> +# It then covers the EOF cases: a WRITE_ZEROES that *extends* the file to a
> +# non-unit-aligned size, followed by a further extension. WRITE_ZEROES must
> +# never leave written blocks beyond EOF.
> +
> +. ./common/preamble
> +_begin_fstest auto quick prealloc fiemap
> +
> +testfile=$TEST_DIR/$seq.testfile
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.*
> +	rm -f $testfile
> +}
> +
> +. ./common/filter
> +. ./common/punch
> +
> +_require_test
> +_require_xfs_io_command "fwzero"
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "fiemap" "-e"
> +_require_xfs_io_command "truncate"
> +
> +# The allocation unit: rt extent size on an rt config, otherwise the block
> +# size. Deriving the range from this makes the head/tail units straddle rt
> +# extents when rextsize > 1.
> +u=$(_get_file_block_size $TEST_DIR)
> +
> +# The fs block size. On rt with rextsize > 1 the allocation unit u is the rt
> +# extent (u > b). A WRITE_ZEROES that extends EOF must only write out to the
> +# block-rounded EOF and leave the rest of the straddling rt extent unwritten,
> +# rather than written past EOF.
> +b=$(_get_block_size $TEST_DIR)
> +
> +# Unaligned range within EOF: start 1.5 units in, span 4 units, so both the
> +# head unit [u, 2u) and the tail unit [5u, 6u) are only partially covered,
> +# with fully covered units in between and data on both sides.
> +off=$((u + u / 2))
> +len=$((4 * u))
> +filesz=$((8 * u))
> +pattern=0xab
> +
> +# Expected images.  For the written/delalloc cases the pattern surrounds the
> +# zeroed range; for the hole/unwritten cases the file reads back all zeroes.
> +$XFS_IO_PROG -f -c "pwrite -S $pattern 0 $filesz" $tmp.pattern >> $seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite -S 0 $off $len" $tmp.pattern >> $seqres.full 2>&1
> +$XFS_IO_PROG -f -c "truncate $filesz" $tmp.zero >> $seqres.full 2>&1
> +
> +# Assert the whole requested range is backed by written extents immediately
> +# after fwzero (before any sync/remount): no holes, no unwritten.
> +_check_range_written()
> +{
> +	local file=$1
> +	local bad
> +
> +	bad=$($XFS_IO_PROG -c "fiemap -v $off $len" "$file" | \
> +		_filter_fiemap | grep -E -c 'hole|unwritten')
> +	if [ "$bad" -eq 0 ]; then
> +		echo "extents: range fully written"
> +	else
> +		echo "extents: FAIL - $bad hole/unwritten extent(s) in range"
> +		$XFS_IO_PROG -c "fiemap -v $off $len" "$file" | _filter_fiemap
> +	fi
> +}
> +
> +_check_data()
> +{
> +	local file=$1
> +	local want=$2
> +
> +	if cmp -s "$file" "$want"; then
> +		echo "data: matches expected image"
> +	else
> +		echo "data: FAIL - mismatch against expected image"
> +		cmp "$file" "$want" | head
> +	fi
> +}
> +
> +# Assert [start, start+len) has no written extents (unwritten/hole only).  Used
> +# to verify the tail of the straddling rt extent, past the block-rounded EOF,
> +# was left unwritten.  len <= 0 means u == block size (no rt tail) -> nothing to
> +# check, but still emit the line so the output is config-independent.
> +_check_eof_tail()
> +{
> +	local file=$1 start=$2 len=$3 bad
> +
> +	if [ "$len" -le 0 ]; then
> +		echo "extents: eof tail unwritten"
> +		return
> +	fi
> +	bad=$($XFS_IO_PROG -c "fiemap -v $start $len" "$file" | \
> +		_filter_fiemap | grep -E -c 'data')
> +	if [ "$bad" -eq 0 ]; then
> +		echo "extents: eof tail unwritten"
> +	else
> +		echo "extents: FAIL - $bad written extent(s) past block-rounded EOF"
> +		$XFS_IO_PROG -c "fiemap -v $start $len" "$file" | _filter_fiemap
> +	fi
> +}
> +
> +_run_case()
> +{
> +	local name=$1
> +	local want=$2
> +
> +	echo "=== $name ==="
> +
> +	$XFS_IO_PROG -c "fwzero $off $len" $testfile >> $seqres.full 2>&1
> +
> +	echo "== $name fiemap after fwzero ==" >> $seqres.full
> +	$XFS_IO_PROG -c "fiemap -v" $testfile >> $seqres.full 2>&1
> +
> +	_check_range_written $testfile
> +	_test_cycle_mount
> +	_check_data $testfile $want
> +
> +	rm -f $testfile
> +}
> +
> +# 1) Boundary units already written, within i_size.
> +$XFS_IO_PROG -f -c "pwrite -S $pattern 0 $filesz" -c fsync $testfile \
> +	>> $seqres.full 2>&1
> +_run_case "written_edges" $tmp.pattern
> +
> +# 2) Boundary units are holes (sparse file).
> +$XFS_IO_PROG -f -c "truncate $filesz" $testfile >> $seqres.full 2>&1
> +_run_case "hole_edges" $tmp.zero
> +
> +# 3) Boundary units are unwritten preallocation.
> +$XFS_IO_PROG -f -c "falloc 0 $filesz" $testfile >> $seqres.full 2>&1
> +_run_case "unwritten_edges" $tmp.zero
> +
> +# 4) Boundary units are dirty/delalloc:
> +$XFS_IO_PROG -f -c "pwrite -S $pattern 0 $filesz" $testfile >> $seqres.full 2>&1
> +_run_case "delalloc_edges" $tmp.pattern
> +
> +# 5) Boundary units are dirty unwritten.
> +$XFS_IO_PROG -f -c "falloc 0 $filesz" -c "pwrite -S $pattern 0 $filesz" \
> +	$testfile >> $seqres.full 2>&1
> +_run_case "dirty_unwritten_edges" $tmp.pattern
> +
> +# 6) EOF cases. A WRITE_ZEROES that extends the file to a non-unit-aligned
> +#    size, followed by a further extend.
> +eof=$((3 * u + 1))
> +
> +echo "=== eof_then_truncate ==="
> +$XFS_IO_PROG -f -c "fwzero 0 $eof" $testfile >> $seqres.full 2>&1
> +# The write must stop at the block-rounded EOF; the rest of the rt extent that
> +# straddles EOF must be unwritten, not written past EOF.  Round EOF up to the
> +# fs block size (b is a power of two) the same way as generic/219.
> +eof_ru=$(( (eof + b - 1) & ~(b - 1) ))
> +_check_eof_tail $testfile $eof_ru $((4 * u - eof_ru))
> +
> +$XFS_IO_PROG -c "truncate $filesz" $testfile >> $seqres.full 2>&1
> +_test_cycle_mount
> +_check_data $testfile $tmp.zero
> +rm -f $testfile
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/795.out b/tests/generic/795.out
> new file mode 100644
> index 00000000..14667aef
> --- /dev/null
> +++ b/tests/generic/795.out
> @@ -0,0 +1,19 @@
> +QA output created by 795
> +=== written_edges ===
> +extents: range fully written
> +data: matches expected image
> +=== hole_edges ===
> +extents: range fully written
> +data: matches expected image
> +=== unwritten_edges ===
> +extents: range fully written
> +data: matches expected image
> +=== delalloc_edges ===
> +extents: range fully written
> +data: matches expected image
> +=== dirty_unwritten_edges ===
> +extents: range fully written
> +data: matches expected image
> +=== eof_then_truncate ===
> +extents: eof tail unwritten
> +data: matches expected image
> 
> base-commit: ffc8bad17e5b2f56e48dbac43f7c5ae8ac368fe5

