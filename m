Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573D6DDCD;
	Wed, 21 May 2025 02:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747794653; cv=none; b=fBUC/liW4fZkohoT8LrqT7E6N/NwqJT/OdrRAzkoJuZ8DfJbUe53+rz89wFXiRxxenaRnDQXWUvl82HhYy8geSwA1E5yOKP4gyR2JT61ExpPBLkMeQYr0Cx8y5YMF7uc2kP8dkkF72aIOoegh3IhWi2HCgiyMDYzU2/QQzB/rOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747794653; c=relaxed/simple;
	bh=ES9tsiJXpqPZ6Fl8WaPa0nEtALvD1YBBMXe94+SQcXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R/Q0T9Bz4Tm8JmseB1LIqsS2VJhr6x5CMoi0ZyjmAsWwr/ftxJIfspVldyW48hZ2Iv3MDjHJUZkNDguy+d4EmWHZJ0S4P0UILJIex7uFLzLqNsmNL2N+ZXAoQ3yKDjlJUcxdbF5llFzbM1IJorno2JSZ9O98I22gm7I4QrgiUDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXEwW7ho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXEwW7ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A340C4CEE9;
	Wed, 21 May 2025 02:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747794653;
	bh=ES9tsiJXpqPZ6Fl8WaPa0nEtALvD1YBBMXe94+SQcXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BXEwW7hoPsXSPBZowhsS9v38xi45GyG6abrC/1HLALx9MEK2gZ9o5hBbP0CyirHjX
	 6wA31Tsf25I3wYfzYHwbwSRqzWVLKcpevTXCAfnUkodbny7FdiBEXjjnW/FIbiHrFN
	 XnECydDK/LAmrJVUWBu9e2V+JniHlqEENakJOy/iX55wTOT9mPyWOD9BnU3GdBxaow
	 Bn2KXfBLcZ+2QemiVye/PdtzMCcFS2EQCls8PK+MyGWXOpe3yX0xHpg9rXGOYF3A8m
	 FZBEUWmU9TqwpYiWylCkdRKMOND+dQecX592FvoNeIemmcnVkFcb/ProGkP4aNMi1A
	 Vw6KI526JNpog==
Date: Tue, 20 May 2025 19:30:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH v2 6/6] generic: various atomic write tests with
 scsi_debug
Message-ID: <20250521023052.GC9705@frogsfrogsfrogs>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-7-catherine.hoang@oracle.com>
 <8734czwkqd.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8734czwkqd.fsf@gmail.com>

On Tue, May 20, 2025 at 05:35:30PM +0530, Ritesh Harjani wrote:
> Catherine Hoang <catherine.hoang@oracle.com> writes:
> 
> > From: "Darrick J. Wong" <djwong@kernel.org>
> >
> > Simple tests of various atomic write requests and a (simulated) hardware
> > device.
> >
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > ---
> >  common/atomicwrites    |  10 +++
> >  tests/generic/1222     |  86 +++++++++++++++++++++++++
> >  tests/generic/1222.out |  10 +++
> >  tests/generic/1223     |  66 +++++++++++++++++++
> >  tests/generic/1223.out |   9 +++
> >  tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/1224.out |  17 +++++
> >  tests/xfs/1216         |  67 ++++++++++++++++++++
> >  tests/xfs/1216.out     |   9 +++
> >  tests/xfs/1217         |  70 +++++++++++++++++++++
> >  tests/xfs/1217.out     |   3 +
> >  tests/xfs/1218         |  59 +++++++++++++++++
> >  tests/xfs/1218.out     |  15 +++++
> >  13 files changed, 561 insertions(+)
> >  create mode 100755 tests/generic/1222
> >  create mode 100644 tests/generic/1222.out
> >  create mode 100755 tests/generic/1223
> >  create mode 100644 tests/generic/1223.out
> >  create mode 100644 tests/generic/1224
> >  create mode 100644 tests/generic/1224.out
> >  create mode 100755 tests/xfs/1216
> >  create mode 100644 tests/xfs/1216.out
> >  create mode 100755 tests/xfs/1217
> >  create mode 100644 tests/xfs/1217.out
> >  create mode 100644 tests/xfs/1218
> >  create mode 100644 tests/xfs/1218.out
> >
> > diff --git a/common/atomicwrites b/common/atomicwrites
> > index 391bb6f6..c75c3d39 100644
> > --- a/common/atomicwrites
> > +++ b/common/atomicwrites
> > @@ -115,3 +115,13 @@ _test_atomic_file_writes()
> >      $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> >          echo "atomic write requires offset to be aligned to bsize"
> >  }
> > +
> > +_simple_atomic_write() {
> > +	local pos=$1
> > +	local count=$2
> > +	local file=$3
> > +	local directio=$4
> > +
> > +	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
> > +	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
> > +}
> > diff --git a/tests/generic/1222 b/tests/generic/1222
> > new file mode 100755
> > index 00000000..9d02bd70
> > --- /dev/null
> > +++ b/tests/generic/1222
> > @@ -0,0 +1,86 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1222
> > +#
> > +# Validate multi-fsblock atomic write support with simulated hardware support
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw atomicwrites
> > +
> > +. ./common/scsi_debug
> > +. ./common/atomicwrites
> > +
> > +_cleanup()
> > +{
> > +	_scratch_unmount &>/dev/null
> > +	_put_scsi_debug_dev &>/dev/null
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +_require_scsi_debug
> > +_require_scratch_nocheck
> > +# Format something so that ./check doesn't freak out
> > +_scratch_mkfs >> $seqres.full
> > +
> > +# 512b logical/physical sectors, 512M size, atomic writes enabled
> > +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> > +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> > +
> > +export SCRATCH_DEV=$dev
> > +unset USE_EXTERNAL
> > +
> > +_require_scratch_write_atomic
> > +_require_atomic_write_test_commands
> 
> Is it possible to allow pwrite -A to be tested on $SCRATCH_MNT rather
> than on TEST_MNT? For e.g. 
> 
> What happens when TEST_DEV is not atomic write capable? Then this test
> won't run even though we are passing scsi_debug which supports atomic writes.

Hrmmmm.  Maybe we need an open-coded version of the "make sure the
xfs_io commands are present" checks without actually doing live testing
of the $TEST_DIR since we're creating a scsi-debug with atomic write
capability anyway.

> > +
> > +echo "scsi_debug atomic write properties" >> $seqres.full
> > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > +
> > +testfile=$SCRATCH_MNT/testfile
> > +touch $testfile
> > +
> > +echo "filesystem atomic write properties" >> $seqres.full
> > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> > +
> > +sector_size=$(blockdev --getss $SCRATCH_DEV)
> > +min_awu=$(_get_atomic_write_unit_min $testfile)
> > +max_awu=$(_get_atomic_write_unit_max $testfile)
> > +
> > +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> > +
> > +# try outside the advertised sizes
> > +echo "two EINVAL for unsupported sizes"
> > +min_i=$((min_awu / 2))
> > +_simple_atomic_write $min_i $min_i $testfile -d
> > +max_i=$((max_awu * 2))
> > +_simple_atomic_write $max_i $max_i $testfile -d
> > +
> > +# try all of the advertised sizes
> > +echo "all should work"
> > +for ((i = min_awu; i <= max_awu; i *= 2)); do
> > +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> > +	_test_atomic_file_writes $i $testfile
> > +	_simple_atomic_write $i $i $testfile -d
> > +done
> > +
> > +# does not support buffered io
> > +echo "one EOPNOTSUPP for buffered atomic"
> > +_simple_atomic_write 0 $min_awu $testfile
> > +
> > +# does not support unaligned directio
> > +echo "one EINVAL for unaligned directio"
> > +_simple_atomic_write $sector_size $min_awu $testfile -d
> > +
> > +_scratch_unmount
> > +_put_scsi_debug_dev
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/1222.out b/tests/generic/1222.out
> > new file mode 100644
> > index 00000000..158b52fa
> > --- /dev/null
> > +++ b/tests/generic/1222.out
> > @@ -0,0 +1,10 @@
> > +QA output created by 1222
> > +two EINVAL for unsupported sizes
> > +pwrite: Invalid argument
> > +pwrite: Invalid argument
> > +all should work
> > +one EOPNOTSUPP for buffered atomic
> > +pwrite: Operation not supported
> > +one EINVAL for unaligned directio
> > +pwrite: Invalid argument
> > +Silence is golden
> > diff --git a/tests/generic/1223 b/tests/generic/1223
> > new file mode 100755
> > index 00000000..8a77386e
> > --- /dev/null
> > +++ b/tests/generic/1223
> > @@ -0,0 +1,66 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1223
> > +#
> > +# Validate multi-fsblock atomic write support with or without hw support
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw atomicwrites
> > +
> > +. ./common/atomicwrites
> > +
> > +_require_scratch
> > +_require_atomic_write_test_commands
> > +
> > +echo "scratch device atomic write properties" >> $seqres.full
> > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > +
> > +testfile=$SCRATCH_MNT/testfile
> > +touch $testfile
> > +
> > +echo "filesystem atomic write properties" >> $seqres.full
> > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> > +
> > +sector_size=$(blockdev --getss $SCRATCH_DEV)
> > +min_awu=$(_get_atomic_write_unit_min $testfile)
> > +max_awu=$(_get_atomic_write_unit_max $testfile)
> > +
> > +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> > +
> > +# try outside the advertised sizes
> > +echo "two EINVAL for unsupported sizes"
> > +min_i=$((min_awu / 2))
> > +_simple_atomic_write $min_i $min_i $testfile -d
> > +max_i=$((max_awu * 2))
> > +_simple_atomic_write $max_i $max_i $testfile -d
> > +
> > +# try all of the advertised sizes
> > +for ((i = min_awu; i <= max_awu; i *= 2)); do
> 
> If the kernel we are testing on doesn't have SW XFS atomic write patches
> and if the scratch device does not support HW atomic write, then this
> could cause an infinite loop, right? Since both min_awu and max_awu can
> come out to be 0? 

<nod> This should _notrun if max_awu is zero.

> > +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> > +	_test_atomic_file_writes $i $testfile
> > +	_simple_atomic_write $i $i $testfile -d
> > +done
> > +
> > +# does not support buffered io
> > +echo "one EOPNOTSUPP for buffered atomic"
> > +_simple_atomic_write 0 $min_awu $testfile
> > +
> > +# does not support unaligned directio
> > +echo "one EINVAL for unaligned directio"
> > +if [ $sector_size -lt $min_awu ]; then
> > +	_simple_atomic_write $sector_size $min_awu $testfile -d
> > +else
> > +	# not supported, so fake the output
> > +	echo "pwrite: Invalid argument"
> > +fi
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/1223.out b/tests/generic/1223.out
> > new file mode 100644
> > index 00000000..edf5bd71
> > --- /dev/null
> > +++ b/tests/generic/1223.out
> > @@ -0,0 +1,9 @@
> > +QA output created by 1223
> > +two EINVAL for unsupported sizes
> > +pwrite: Invalid argument
> > +pwrite: Invalid argument
> > +one EOPNOTSUPP for buffered atomic
> > +pwrite: Operation not supported
> > +one EINVAL for unaligned directio
> > +pwrite: Invalid argument
> > +Silence is golden
> 
> 
> Will continue reviewing from g/1224 and will let you know if I
> have any comments.

Ok.  Thanks for reviewing! :)

--D
