Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBF410E9;
	Wed,  2 Oct 2024 14:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727881037; cv=none; b=Mq2fphQ2M1RmzUTFDYQ86Y+6QW1+ml0bmad/+oLIxbByX388mdOxI7sNPna9oiwy+ChRKEM8sslB4SVj+AprKtLzRKM2BUQW0EPKqcY4Z0n0ny5uulbDe2AXKtongRO5wbFnRYhYHFSRRPCobbzQjjicoJD249oHIV/EbPCtvTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727881037; c=relaxed/simple;
	bh=DxC0jKrpIV1pn6n9A6/dOvNcU+PHDuLEbqw3nvBKq9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PoEwBnKcTndeyK+nACGnuM0CHe4apaCL3uioZ2SYVKh6514j9OeIThTdam7fRRP+yb4kDq0zUYqEtSsEfmdD/jKqAiRy/Xf7n/XFwUljcUA/5bSyuGHU6jielwIx/AO85X8tTINOSqm4k30x18AHfzijprrSopOXycIeXqMhooQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uMKkEhTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMKkEhTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8E2C4CECD;
	Wed,  2 Oct 2024 14:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727881036;
	bh=DxC0jKrpIV1pn6n9A6/dOvNcU+PHDuLEbqw3nvBKq9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uMKkEhTJZX8jZs+fpKauy+oHu4Jnt02J+jIYWSNEjIx8iYK6WuetDgqYa51h2M3bN
	 VjJXrNhOnQozA4rDz/CloUVQNeoPoqq/TuSDAcdO8IthbeuD3ozbwIFHYvFFpcQRbk
	 jRCyKIIO+T8L4VKRhK3KUO8Gi1HQfq+Cg1ERIzqE1xAea6LTY2LTkJSChNkbIvK0uh
	 6tGnf5pS00Cht34089I6S9p1JN7dR96F6RYB1fQJ1UGOEORqi2obz7ihjA+o6A3rRf
	 tnbAv3hgCC/yYtBvb5yLlyP2f4aN8kibYE7VgYkLnraNSG880D7LLHd4cLooUu1t+R
	 M+BIRxLUolUWw==
Date: Wed, 2 Oct 2024 07:57:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Zorro Lang <zlang@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241002145715.GF21840@frogsfrogsfrogs>
References: <20240924084551.1802795-1-hch@lst.de>
 <20240924084551.1802795-2-hch@lst.de>
 <20241001145944.GE21840@frogsfrogsfrogs>
 <20241002133800.pk3kb5powlqjbm3m@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <Zv1aS4vk55b8sPgN@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv1aS4vk55b8sPgN@bfoster>

On Wed, Oct 02, 2024 at 10:35:55AM -0400, Brian Foster wrote:
> On Wed, Oct 02, 2024 at 09:38:00PM +0800, Zorro Lang wrote:
> > On Tue, Oct 01, 2024 at 07:59:44AM -0700, Darrick J. Wong wrote:
> > > On Tue, Sep 24, 2024 at 10:45:48AM +0200, Christoph Hellwig wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > These tests create substantial file fragmentation as a result of
> > > > application actions that defeat post-EOF preallocation
> > > > optimisations. They are intended to replicate known vectors for
> > > > these problems, and provide a check that the fragmentation levels
> > > > have been controlled. The mitigations we make may not completely
> > > > remove fragmentation (e.g. they may demonstrate speculative delalloc
> > > > related extent size growth) so the checks don't assume we'll end up
> > > > with perfect layouts and hence check for an exceptable level of
> > > > fragmentation rather than none.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > [move to different test number, update to current xfstest APIs]
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  tests/xfs/1500     | 66 +++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1500.out |  9 ++++++
> > > >  tests/xfs/1501     | 68 ++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1501.out |  9 ++++++
> > > >  tests/xfs/1502     | 68 ++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1502.out |  9 ++++++
> > > >  tests/xfs/1503     | 77 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1503.out | 33 ++++++++++++++++++++
> > > >  8 files changed, 339 insertions(+)
> > > >  create mode 100755 tests/xfs/1500
> > > >  create mode 100644 tests/xfs/1500.out
> > > >  create mode 100755 tests/xfs/1501
> > > >  create mode 100644 tests/xfs/1501.out
> > > >  create mode 100755 tests/xfs/1502
> > > >  create mode 100644 tests/xfs/1502.out
> > > >  create mode 100755 tests/xfs/1503
> > > >  create mode 100644 tests/xfs/1503.out
> > > > 
> > > > diff --git a/tests/xfs/1500 b/tests/xfs/1500
> > > > new file mode 100755
> > > > index 000000000..de0e1df62
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1500
> > > > @@ -0,0 +1,66 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test xfs/500
> > > > +#
> > > > +# Post-EOF preallocation defeat test for O_SYNC buffered I/O.
> > > > +#
> > > > +
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick prealloc rw
> > > > +
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +
> > > > +_require_scratch
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	# try to kill all background processes
> > > > +	wait
> > > > +	cd /
> > > > +	rm -r -f $tmp.*
> > > > +}
> > > > +
> > > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Write multiple files in parallel using synchronous buffered writes. Aim is to
> > > > +# interleave allocations to fragment the files. Synchronous writes defeat the
> > > > +# open/write/close heuristics in xfs_file_release() that prevent EOF block
> > > > +# removal, so this should fragment badly. Typical problematic behaviour shows
> > > > +# per-file extent counts of >900 (almost worse case) whilst fixed behaviour
> > > > +# typically shows extent counts in the low 20s.
> > > 
> > > Now that these are in for-next, I've noticed that these new tests
> > > consistently fail in the above-documented manner on various configs --
> > > fsdax, always_cow, rtextsize > 1fsb, and sometimes 1k fsblock size.
> > > 
> > > I'm not sure why this happens, but it probably needs to be looked at
> > > along with all the FALLOC_FL_UNSHARE_RANGE brokenness that's also been
> > > exposed by fstests that /does/ need to be fixed.
> > 
> > Yes, some fsx tests fail on xfs, after the FALLOC_FL_UNSHARE_RANGE supporting.
> > e.g. g/091, g/127, g/263, g/363 and g/616. I thought they're known issues as
> > you known. If they're not, better to check. Hi Brian, are these failures as you
> > known?
> > 
> 
> So I'm aware of two fundamental issues that fsx unshare range support
> uncovers. First is the XFS data loss issue that is addressed here[1],
> second is the iomap unshare range warning/error splat that Julian Sun
> has been working on (last version posted here[2] I believe).
> 
> My initial testing of the fsx unshare range patch was to run fsx
> directly on the fs until I could run for some notable number of
> operations without triggering a failure (probably at least 1m+, but I
> don't recall exactly). I was initially able to do that with the patches
> from [1] plus a local hack to trim to i_size in iomap_unshare_range(),
> so based on that I _think_ these are the only two outstanding issues
> with unshare range.
> 
> [1] https://lore.kernel.org/linux-xfs/20240906114051.120743-1-bfoster@redhat.com/
> [2] https://lore.kernel.org/linux-fsdevel/20240927065344.2628691-1-sunjunchao2870@gmail.com/
> 
> The patches at [1] have been reviewed, but I'm not really sure where
> they stand in terms of the XFS pipeline. Carlos?
> 
> It looks like the fix associated with [2] is still under
> development/review. In any event, I just ran the set of tests noted by
> Zorro above (w/ unshare range support) and they all fail on my distro
> kernel, but all but generic/363 pass on current master (6.12.0-rc1+)
> plus [1]. The generic/363 failure produces the iomap error associated
> with [2], so I suspect that all of these test failures can be
> categorized into one of those two known issues.

Yep.  [1] fixes a lot of the splats, and the rest of the splats can be
fixed by a couple of other patches that I'll send out today.

Those same fsx tests above are still broken on fsdax though, so
something is still wrong. :(

--D

> Brian
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > +# Failure is determined by golden output mismatch from _within_tolerance().
> > > > +
> > > > +workfile=$SCRATCH_MNT/file
> > > > +nfiles=8
> > > > +wsize=4096
> > > > +wcnt=1000
> > > > +
> > > > +write_sync_file()
> > > > +{
> > > > +	idx=$1
> > > > +
> > > > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > > > +		$XFS_IO_PROG -f -s -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> > > > +	done
> > > > +}
> > > > +
> > > > +rm -f $workfile*
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	write_sync_file $n > /dev/null 2>&1 &
> > > > +done
> > > > +wait
> > > > +sync
> > > > +
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	count=$(_count_extents $workfile.$n)
> > > > +	# Acceptible extent count range is 1-40
> > > > +	_within_tolerance "file.$n extent count" $count 21 19 -v
> > > > +done
> > > > +
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1500.out b/tests/xfs/1500.out
> > > > new file mode 100644
> > > > index 000000000..414df87ed
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1500.out
> > > > @@ -0,0 +1,9 @@
> > > > +QA output created by 1500
> > > > +file.0 extent count is in range
> > > > +file.1 extent count is in range
> > > > +file.2 extent count is in range
> > > > +file.3 extent count is in range
> > > > +file.4 extent count is in range
> > > > +file.5 extent count is in range
> > > > +file.6 extent count is in range
> > > > +file.7 extent count is in range
> > > > diff --git a/tests/xfs/1501 b/tests/xfs/1501
> > > > new file mode 100755
> > > > index 000000000..cf3cbf8b5
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1501
> > > > @@ -0,0 +1,68 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test xfs/501
> > > > +#
> > > > +# Post-EOF preallocation defeat test for buffered I/O with extent size hints.
> > > > +#
> > > > +
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick prealloc rw
> > > > +
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +
> > > > +_require_scratch
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	# try to kill all background processes
> > > > +	wait
> > > > +	cd /
> > > > +	rm -r -f $tmp.*
> > > > +}
> > > > +
> > > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Write multiple files in parallel using buffered writes with extent size hints.
> > > > +# Aim is to interleave allocations to fragment the files. Writes w/ extent size
> > > > +# hints set defeat the open/write/close heuristics in xfs_file_release() that
> > > > +# prevent EOF block removal, so this should fragment badly. Typical problematic
> > > > +# behaviour shows per-file extent counts of 1000 (worst case!) whilst
> > > > +# fixed behaviour should show very few extents (almost best case).
> > > > +#
> > > > +# Failure is determined by golden output mismatch from _within_tolerance().
> > > > +
> > > > +workfile=$SCRATCH_MNT/file
> > > > +nfiles=8
> > > > +wsize=4096
> > > > +wcnt=1000
> > > > +extent_size=16m
> > > > +
> > > > +write_extsz_file()
> > > > +{
> > > > +	idx=$1
> > > > +
> > > > +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> > > > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > > > +		$XFS_IO_PROG -f -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> > > > +	done
> > > > +}
> > > > +
> > > > +rm -f $workfile*
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	write_extsz_file $n > /dev/null 2>&1 &
> > > > +done
> > > > +wait
> > > > +sync
> > > > +
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	count=$(_count_extents $workfile.$n)
> > > > +	# Acceptible extent count range is 1-10
> > > > +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> > > > +done
> > > > +
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1501.out b/tests/xfs/1501.out
> > > > new file mode 100644
> > > > index 000000000..a266ef74b
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1501.out
> > > > @@ -0,0 +1,9 @@
> > > > +QA output created by 1501
> > > > +file.0 extent count is in range
> > > > +file.1 extent count is in range
> > > > +file.2 extent count is in range
> > > > +file.3 extent count is in range
> > > > +file.4 extent count is in range
> > > > +file.5 extent count is in range
> > > > +file.6 extent count is in range
> > > > +file.7 extent count is in range
> > > > diff --git a/tests/xfs/1502 b/tests/xfs/1502
> > > > new file mode 100755
> > > > index 000000000..f4228667a
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1502
> > > > @@ -0,0 +1,68 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test xfs/502
> > > > +#
> > > > +# Post-EOF preallocation defeat test for direct I/O with extent size hints.
> > > > +#
> > > > +
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick prealloc rw
> > > > +
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +
> > > > +_require_scratch
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	# try to kill all background processes
> > > > +	wait
> > > > +	cd /
> > > > +	rm -r -f $tmp.*
> > > > +}
> > > > +
> > > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Write multiple files in parallel using O_DIRECT writes w/ extent size hints.
> > > > +# Aim is to interleave allocations to fragment the files. O_DIRECT writes defeat
> > > > +# the open/write/close heuristics in xfs_file_release() that prevent EOF block
> > > > +# removal, so this should fragment badly. Typical problematic behaviour shows
> > > > +# per-file extent counts of ~1000 (worst case) whilst fixed behaviour typically
> > > > +# shows extent counts in the low single digits (almost best case)
> > > > +#
> > > > +# Failure is determined by golden output mismatch from _within_tolerance().
> > > > +
> > > > +workfile=$SCRATCH_MNT/file
> > > > +nfiles=8
> > > > +wsize=4096
> > > > +wcnt=1000
> > > > +extent_size=16m
> > > > +
> > > > +write_direct_file()
> > > > +{
> > > > +	idx=$1
> > > > +
> > > > +	$XFS_IO_PROG -f -c "extsize $extent_size" $workfile.$idx
> > > > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > > > +		$XFS_IO_PROG -f -d -c "pwrite $((cnt * wsize)) $wsize" $workfile.$idx
> > > > +	done
> > > > +}
> > > > +
> > > > +rm -f $workfile*
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	write_direct_file $n > /dev/null 2>&1 &
> > > > +done
> > > > +wait
> > > > +sync
> > > > +
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	count=$(_count_extents $workfile.$n)
> > > > +	# Acceptible extent count range is 1-10
> > > > +	_within_tolerance "file.$n extent count" $count 2 1 8 -v
> > > > +done
> > > > +
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1502.out b/tests/xfs/1502.out
> > > > new file mode 100644
> > > > index 000000000..82c8760a3
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1502.out
> > > > @@ -0,0 +1,9 @@
> > > > +QA output created by 1502
> > > > +file.0 extent count is in range
> > > > +file.1 extent count is in range
> > > > +file.2 extent count is in range
> > > > +file.3 extent count is in range
> > > > +file.4 extent count is in range
> > > > +file.5 extent count is in range
> > > > +file.6 extent count is in range
> > > > +file.7 extent count is in range
> > > > diff --git a/tests/xfs/1503 b/tests/xfs/1503
> > > > new file mode 100755
> > > > index 000000000..9002f87e6
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1503
> > > > @@ -0,0 +1,77 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test xfs/503
> > > > +#
> > > > +# Post-EOF preallocation defeat test with O_SYNC buffered I/O that repeatedly
> > > > +# closes and reopens the files.
> > > > +#
> > > > +
> > > > +. ./common/preamble
> > > > +_begin_fstest auto prealloc rw
> > > > +
> > > > +. ./common/rc
> > > > +. ./common/filter
> > > > +
> > > > +_require_scratch
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	# try to kill all background processes
> > > > +	wait
> > > > +	cd /
> > > > +	rm -r -f $tmp.*
> > > > +}
> > > > +
> > > > +_scratch_mkfs > "$seqres.full" 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Write multiple files in parallel using synchronous buffered writes that
> > > > +# repeatedly close and reopen the fails. Aim is to interleave allocations to
> > > > +# fragment the files. Assuming we've fixed the synchronous write defeat, we can
> > > > +# still trigger the same issue with a open/read/close on O_RDONLY files. We
> > > > +# should not be triggering EOF preallocation removal on files we don't have
> > > > +# permission to write, so until this is fixed it should fragment badly.  Typical
> > > > +# problematic behaviour shows per-file extent counts of 50-350 whilst fixed
> > > > +# behaviour typically demonstrates post-eof speculative delalloc growth in
> > > > +# extent size (~6 extents for 50MB file).
> > > > +#
> > > > +# Failure is determined by golden output mismatch from _within_tolerance().
> > > > +
> > > > +workfile=$SCRATCH_MNT/file
> > > > +nfiles=32
> > > > +wsize=4096
> > > > +wcnt=1000
> > > > +
> > > > +write_file()
> > > > +{
> > > > +	idx=$1
> > > > +
> > > > +	$XFS_IO_PROG -f -s -c "pwrite -b 64k 0 50m" $workfile.$idx
> > > > +}
> > > > +
> > > > +read_file()
> > > > +{
> > > > +	idx=$1
> > > > +
> > > > +	for ((cnt=0; cnt<$wcnt; cnt++)); do
> > > > +		$XFS_IO_PROG -f -r -c "pread 0 28" $workfile.$idx
> > > > +	done
> > > > +}
> > > > +
> > > > +rm -f $workdir/file*
> > > > +for ((n=0; n<$((nfiles)); n++)); do
> > > > +	write_file $n > /dev/null 2>&1 &
> > > > +	read_file $n > /dev/null 2>&1 &
> > > > +done
> > > > +wait
> > > > +
> > > > +for ((n=0; n<$nfiles; n++)); do
> > > > +	count=$(_count_extents $workfile.$n)
> > > > +	# Acceptible extent count range is 1-40
> > > > +	_within_tolerance "file.$n extent count" $count 6 5 10 -v
> > > > +done
> > > > +
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1503.out b/tests/xfs/1503.out
> > > > new file mode 100644
> > > > index 000000000..1780b16df
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1503.out
> > > > @@ -0,0 +1,33 @@
> > > > +QA output created by 1503
> > > > +file.0 extent count is in range
> > > > +file.1 extent count is in range
> > > > +file.2 extent count is in range
> > > > +file.3 extent count is in range
> > > > +file.4 extent count is in range
> > > > +file.5 extent count is in range
> > > > +file.6 extent count is in range
> > > > +file.7 extent count is in range
> > > > +file.8 extent count is in range
> > > > +file.9 extent count is in range
> > > > +file.10 extent count is in range
> > > > +file.11 extent count is in range
> > > > +file.12 extent count is in range
> > > > +file.13 extent count is in range
> > > > +file.14 extent count is in range
> > > > +file.15 extent count is in range
> > > > +file.16 extent count is in range
> > > > +file.17 extent count is in range
> > > > +file.18 extent count is in range
> > > > +file.19 extent count is in range
> > > > +file.20 extent count is in range
> > > > +file.21 extent count is in range
> > > > +file.22 extent count is in range
> > > > +file.23 extent count is in range
> > > > +file.24 extent count is in range
> > > > +file.25 extent count is in range
> > > > +file.26 extent count is in range
> > > > +file.27 extent count is in range
> > > > +file.28 extent count is in range
> > > > +file.29 extent count is in range
> > > > +file.30 extent count is in range
> > > > +file.31 extent count is in range
> > > > -- 
> > > > 2.45.2
> > > > 
> > > > 
> > > 
> > 
> 
> 
