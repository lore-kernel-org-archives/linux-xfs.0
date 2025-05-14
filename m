Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C81F4ED;
	Wed, 14 May 2025 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747238504; cv=none; b=Z7tWkB+/bhFyJotcs0AaOLyZidjwQLi+aieJZ2zZxnM3MySytBH2+po5vcCkOHsrMUe2yVQECwETLx97F7LACORYyGHWUtWsOa8wJ/HImxGgsrPcQzONEm/4ye7RJT8HeZX6X4Z5ypLAO3NVw1utTBZg5imAhP4FFtEZjeoShAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747238504; c=relaxed/simple;
	bh=i5Oy+0Cf6/6WJIdi+1OpMQ6l12Rf56sqFwB8APP6HQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hN/IYK8DSEn3KV+id70FuLvA7msBT+lfCbUBVIfTm8OhFNYePu7liPd1kTdbljLRQGKJnTDi47mOR36hkDlTOudMH41kcrsr7QtzNgSXOLSD8fxhfcuZNAEerJc7C2agEMJB4V6GtQnbss147OAO05f8ov74n+isgQHFcKLafTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oWLqdzN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oWLqdzN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0EFC4CEE3;
	Wed, 14 May 2025 16:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747238504;
	bh=i5Oy+0Cf6/6WJIdi+1OpMQ6l12Rf56sqFwB8APP6HQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oWLqdzN9Qu7TrMbGnkgG2yt4Cq1DGt8JxoRcwtYDNofAxio9G8YJllnnyHjscFykm
	 INMYxJC9uUFv/mNXvN2HQDAWm2qKB0qMnzH6gwB5D1AxOK7mrqNlIUkiSqvFtmyoYn
	 s4oRdR3O6yHba352adaysoohdtsSZiynNrBBdxD96JT+xNTLCZ9C4LCX67Mj0J/7/F
	 fDhHV6k+wD4MFnhUK1gKLVF6oJg7GUKWYNUDtlK4pX/bdeFzeoeRj8DI3P6eSxxCMM
	 qYwENSDD4Ut+fpJr79ZzIbIsVkx8EKAIk5oW8+s7maI6HxqxUKBImC6sJkc0Oh19SP
	 Y98hF5P5ymanA==
Date: Wed, 14 May 2025 09:01:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] generic: various atomic write tests with scsi_debug
Message-ID: <20250514160143.GW25667@frogsfrogsfrogs>
References: <20250514002915.13794-1-catherine.hoang@oracle.com>
 <20250514002915.13794-7-catherine.hoang@oracle.com>
 <4120689f-27cd-4114-9052-adba0a7e91d4@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4120689f-27cd-4114-9052-adba0a7e91d4@oracle.com>

On Wed, May 14, 2025 at 02:41:40PM +0100, John Garry wrote:
> 
> > +++ b/tests/generic/1222
> > @@ -0,0 +1,86 @@

<snip>

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
> 
> I figure that $sector_size is default at 512, which would never be equal to
> fsblocksize (so the test looks ok)

For now, yes -- the only filesystems supporting atomic writes (ext4 and
XFS v5) don't support 512b fsblocks.

<snip>

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
> 
> It seems many sub-tests are same as 1222
> 
> It is difficult to factor them out?

Yes.  g/1222 will _notrun itself if the scsi_debug module isn't present
or the fake device cannot be created.  Apparently many of the people who
run fstests also have test infrastructure that cannot handle modules, so
they don't run anything involving scsi_debug.

That's why g/1223 only requires that the scratch fs advertises some sort
of atomic write capability, it doesn't care how it provides that.

<snip>

> > diff --git a/tests/generic/1224 b/tests/generic/1224
> > new file mode 100644
> > index 00000000..fb178be4
> > --- /dev/null
> > +++ b/tests/generic/1224

<snip>

> > +# atomic write max size
> > +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> > +aw_max=$(_get_atomic_write_unit_max $file1)
> > +cp $file1 $file1.chk
> > +$XFS_IO_PROG -dc "pwrite -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> > +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> > +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> > +#md5sum $file1 | _filter_scratch
> > +
> > +# atomic write max size on fragmented fs
> > +avail=`_get_available_space $SCRATCH_MNT`
> > +filesizemb=$((avail / 1024 / 1024 - 1))
> > +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> > +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> > +$here/src/punch-alternating $fragmentedfile
> > +touch $file3
> > +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> > +md5sum $file3 | _filter_scratch
> 
> nice :)
> 
> But we also test RWF_NOWAIT at some stage?
> 
> RWF_NOWAIT should fail always for filesystem-based atomic write

It's hard to test NOWAIT because the selected io path might not actually
encounter contention, and there are various things that NOWAIT will wait
on anyway (like memory allocation and metadata reads).

<snip>

> > diff --git a/tests/generic/1225 b/tests/generic/1225
> > new file mode 100644
> > index 00000000..600ada56
> > --- /dev/null
> > +++ b/tests/generic/1225
> 
> I think that we should now omit this test. We don't guarantee serialization
> of atomic writes, so no point in testing it.
> 
> I should have confirmed this earlier, sorry

Ok.

<snip>

> > diff --git a/tests/xfs/1216 b/tests/xfs/1216
> > new file mode 100755
> > index 00000000..d9a10ed9
> > --- /dev/null
> > +++ b/tests/xfs/1216
> > @@ -0,0 +1,68 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1216
> > +#
> > +# Validate multi-fsblock realtime file atomic write support with or without hw
> > +# support
> 
> nice to see rtvol being tested.

Thanks. :)

> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw atomicwrites
> > +
> > +. ./common/atomicwrites
> > +
> > +_require_realtime
> > +_require_scratch
> > +_require_atomic_write_test_commands
> > +
> > +echo "scratch device atomic write properties" >> $seqres.full
> > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +test "$FSTYP" = "xfs" && _xfs_force_bdev realtime $SCRATCH_MNT

Don't need this FSTYP test here, FSTYP is always xfs.

<snip>

> > diff --git a/tests/xfs/1217 b/tests/xfs/1217
> > new file mode 100755
> > index 00000000..012a1f46
> > --- /dev/null
> > +++ b/tests/xfs/1217
> > @@ -0,0 +1,70 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1217
> > +#
> > +# Check that software atomic writes can complete an operation after a crash.
> > +#
> 
> Could we prove that we get a torn write for a regular non-atomic write also?

Perhaps?  But I don't see the point -- non-atomic write completions
could be done atomically.

--D

> > +. ./common/preamble
> > +_begin_fstest auto quick rw atomicwrites
> > +
> 
> Thanks,
> John
> 
