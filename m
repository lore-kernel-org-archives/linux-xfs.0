Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3B41E5B62;
	Thu, 12 Jun 2025 04:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749701080; cv=none; b=Q8lC+H9j9aYSCDdpz+IhWZAecsrjauDABfDv7P0oWN+FKOLzT88Byhb7QPAGQRtalMffv9HlJ/BoYzJIlC2//c7bLDdL2yfTi15ms5+46V/DkJ7YhXuwPyIQO+S5b+quN5+PieLZMLlhWHDt4efWw1x5epBtBOYL2WG/80Okwt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749701080; c=relaxed/simple;
	bh=fn1ryekqKX8tGyHBMtk4ZKXOpKsu+6RAVXxl9SKpyXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRChCA58i6vdzw+Hme7LiaUMBk0pGpuWJOzCmNP/s9YMyHLZ0dAmBwQv2noOHIVBQy9i6O4J9ncwhcwffeNOO37LoDqvI3ay8m6qfn3xBqI5lPIOvjykpKEiwnh7+d5SwbgWpoJ8fllP6RgPGy317uODXnEalKSCT1g/dt/X1Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/dFVd8j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/dFVd8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4B8C4CEEB;
	Thu, 12 Jun 2025 04:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749701080;
	bh=fn1ryekqKX8tGyHBMtk4ZKXOpKsu+6RAVXxl9SKpyXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W/dFVd8jxmsc0WIRy6JZcYEK+fQEPC5HBQUE5hfqZy58ixFRyYs7KXy44VFD0IJhD
	 sfpduf1H50Y3KHij+z0gUr+nyC9G4wA/NG2/dzc+AHF5oKMeHPzZwCC/WUTYS9GUGY
	 8TVWPaLapcBl+pVP6pqL6bFtNV8/u/RkT+xan/3qlqQX/GY25RpVdaojklQquPgA2q
	 lRUyTcIRK2+/4Jmkk0t6pQWpQRwBmYGddgSq0SYlbv4e05GO/i1WmKyWYCLvbhFwTx
	 JKrTUkATAn1/PK9vOCTaAhSiLph6KYJAkbDFH57/Og72dmjgBE/xcECNMgjXYVi2DT
	 IYGpwTVVD6ZNQ==
Date: Wed, 11 Jun 2025 21:04:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	john.g.garry@oracle.com, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v4 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <20250612040439.GP6143@frogsfrogsfrogs>
References: <20250612015708.84255-1-catherine.hoang@oracle.com>
 <20250612015708.84255-3-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612015708.84255-3-catherine.hoang@oracle.com>

On Wed, Jun 11, 2025 at 06:57:07PM -0700, Catherine Hoang wrote:
> Simple tests of various atomic write requests and a (simulated) hardware
> device.
> 
> The first test performs basic multi-block atomic writes on a scsi_debug device
> with atomic writes enabled. We test all advertised sizes between the atomic
> write unit min and max. We also ensure that the write fails when expected, such
> as when attempting buffered io or unaligned directio.
> 
> The second test is similar to the one above, except that it verifies multi-block
> atomic writes on actual hardware instead of simulated hardware. The device used
> in this test is not required to support atomic writes.
> 
> The final two tests ensure multi-block atomic writes can be performed on various
> interweaved mappings, including written, mapped, hole, and unwritten. We also
> test large atomic writes on a heavily fragmented filesystem. These tests are
> separated into reflink (shared) and non-reflink tests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Since this came from me originally, the first line of the commit message
should have a from header to make it explicit that I wrote it (and hence
have the first SOB):

From: Darrick J. Wong <djwong@kernel.org>

Simple tests of various atomic write requests and a (simulated) hardware
device.
<snip>

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
<end of commit message>

> ---
>  common/atomicwrites    |  10 ++++
>  tests/generic/1222     |  89 ++++++++++++++++++++++++++++
>  tests/generic/1222.out |  10 ++++
>  tests/generic/1223     |  67 +++++++++++++++++++++
>  tests/generic/1223.out |   9 +++
>  tests/generic/1224     |  86 +++++++++++++++++++++++++++
>  tests/generic/1224.out |  16 ++++++
>  tests/generic/1225     | 128 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1225.out |  21 +++++++

Zorro: Do you care about making people submit one test per patch?  IMO
it's easier on code authors to add similar tests in one big email
because then it's easier to add small changes across all the new tests
instead of looping in <push><edit><commit><repeat>.

--D

>  9 files changed, 436 insertions(+)
>  create mode 100755 tests/generic/1222
>  create mode 100644 tests/generic/1222.out
>  create mode 100755 tests/generic/1223
>  create mode 100644 tests/generic/1223.out
>  create mode 100755 tests/generic/1224
>  create mode 100644 tests/generic/1224.out
>  create mode 100755 tests/generic/1225
>  create mode 100644 tests/generic/1225.out
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 88f49a1a..4ba945ec 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -136,3 +136,13 @@ _test_atomic_file_writes()
>      $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
>          echo "atomic write requires offset to be aligned to bsize"
>  }
> +
> +_simple_atomic_write() {
> +	local pos=$1
> +	local count=$2
> +	local file=$3
> +	local directio=$4
> +
> +	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
> +	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
> +}
> diff --git a/tests/generic/1222 b/tests/generic/1222
> new file mode 100755
> index 00000000..d3665d0b
> --- /dev/null
> +++ b/tests/generic/1222
> @@ -0,0 +1,89 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1222
> +#
> +# Validate multi-fsblock atomic write support with simulated hardware support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/scsi_debug
> +. ./common/atomicwrites
> +
> +_cleanup()
> +{
> +	_scratch_unmount &>/dev/null
> +	_put_scsi_debug_dev &>/dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_require_scsi_debug
> +_require_scratch_nocheck
> +# Format something so that ./check doesn't freak out
> +_scratch_mkfs >> $seqres.full
> +
> +# 512b logical/physical sectors, 512M size, atomic writes enabled
> +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> +
> +export SCRATCH_DEV=$dev
> +unset USE_EXTERNAL
> +
> +_require_scratch_write_atomic
> +_require_scratch_write_atomic_multi_fsblock
> +
> +xfs_io -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
> +xfs_io -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"
> +
> +echo "scsi_debug atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +echo "all should work"
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +_simple_atomic_write $sector_size $min_awu $testfile -d
> +
> +_scratch_unmount
> +_put_scsi_debug_dev
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1222.out b/tests/generic/1222.out
> new file mode 100644
> index 00000000..158b52fa
> --- /dev/null
> +++ b/tests/generic/1222.out
> @@ -0,0 +1,10 @@
> +QA output created by 1222
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +all should work
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1223 b/tests/generic/1223
> new file mode 100755
> index 00000000..e0b6f0a1
> --- /dev/null
> +++ b/tests/generic/1223
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1223
> +#
> +# Validate multi-fsblock atomic write support with or without hw support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +if [ $sector_size -lt $min_awu ]; then
> +	_simple_atomic_write $sector_size $min_awu $testfile -d
> +else
> +	# not supported, so fake the output
> +	echo "pwrite: Invalid argument"
> +fi
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1223.out b/tests/generic/1223.out
> new file mode 100644
> index 00000000..edf5bd71
> --- /dev/null
> +++ b/tests/generic/1223.out
> @@ -0,0 +1,9 @@
> +QA output created by 1223
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1224 b/tests/generic/1224
> new file mode 100755
> index 00000000..3f83eebc
> --- /dev/null
> +++ b/tests/generic/1224
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1224
> +#
> +# reflink tests for large atomic writes with mixed mappings
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +_require_xfs_io_command pwrite -A
> +_require_cp_reflink
> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> +
> +min_awu=$(_get_atomic_write_unit_min $file1)
> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# reflink tests (files with shared extents)
> +
> +echo "atomic write shared data and unshared+shared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic write shared data and shared+unshared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic overwrite unshared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic write shared+unshared+shared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic write interweaved hole+unwritten+written+reflinked"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1224.out b/tests/generic/1224.out
> new file mode 100644
> index 00000000..89e5cd5a
> --- /dev/null
> +++ b/tests/generic/1224.out
> @@ -0,0 +1,16 @@
> +QA output created by 1224
> +atomic write shared data and unshared+shared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic write shared data and shared+unshared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic overwrite unshared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic write shared+unshared+shared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic write interweaved hole+unwritten+written+reflinked
> +4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
> +93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
> diff --git a/tests/generic/1225 b/tests/generic/1225
> new file mode 100755
> index 00000000..f2dea804
> --- /dev/null
> +++ b/tests/generic/1225
> @@ -0,0 +1,128 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1225
> +#
> +# basic tests for large atomic writes with mixed mappings
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +_require_xfs_io_command pwrite -A
> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> +
> +min_awu=$(_get_atomic_write_unit_min $file1)
> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# non-reflink tests
> +
> +echo "atomic write hole+mapped+hole"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write adjacent mapped+hole and hole+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write mapped+hole+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write unwritten+mapped+unwritten"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write mapped+unwritten+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write interweaved hole+unwritten+written"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write at EOF"
> +dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write preallocated region"
> +fallocate -l 10M $file1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write max size
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +aw_max=$(_get_atomic_write_unit_max $file1)
> +cp $file1 $file1.chk
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> +
> +echo "atomic write max size on fragmented fs"
> +avail=`_get_available_space $SCRATCH_MNT`
> +filesizemb=$((avail / 1024 / 1024 - 1))
> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> +$here/src/punch-alternating $fragmentedfile
> +touch $file3
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> +md5sum $file3 | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1225.out b/tests/generic/1225.out
> new file mode 100644
> index 00000000..92302597
> --- /dev/null
> +++ b/tests/generic/1225.out
> @@ -0,0 +1,21 @@
> +QA output created by 1225
> +atomic write hole+mapped+hole
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write adjacent mapped+hole and hole+mapped
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write mapped+hole+mapped
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write unwritten+mapped+unwritten
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write adjacent mapped+unwritten and unwritten+mapped
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write mapped+unwritten+mapped
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write interweaved hole+unwritten+written
> +5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
> +atomic write at EOF
> +75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
> +atomic write preallocated region
> +27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
> +atomic write max size on fragmented fs
> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
> -- 
> 2.34.1
> 
> 
