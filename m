Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E28221D8E;
	Tue, 15 Apr 2025 18:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744742646; cv=none; b=E0JlNyfmSyON5W9JvStHiKC5IoyGhl8auBOBzI0RDhEV0Vo2SQM+mrJ3gFj2Y57GN/Wgjt1oGax7c24yG3761UHbANb+aR6mVEKI8BoUxC3C0ARNE5qmeIYZ4QmCrNARcdy4k9f09W4c5O7tj7c4xbs006KLSlHecGrEE2edkOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744742646; c=relaxed/simple;
	bh=aM4UpluWGCHv9ulHh4aymvs4fOWj8JvVA7vy5zbkE20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bauzCoecRjeCGzJix6YaWIlpz4tqOIM3OiCKVC4tYyUXIJOWs1uP6JyoQKys6/MzyUxQzhjob1F+YNKIbmienOfDpRBQOKr9hxsAVxcEHXcBuHER+Z+7ivv/U4Z3Tgi0rnQh4vYXesMVrf+W5Ng4whcHhk93sdAb9t59smddPto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9javjzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9javjzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F932C4CEE9;
	Tue, 15 Apr 2025 18:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744742645;
	bh=aM4UpluWGCHv9ulHh4aymvs4fOWj8JvVA7vy5zbkE20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y9javjzhc/ajJWmzTV++B1hBZZqF1dpDfe3+SJj7cnyQHm75k11TRzCnLaNPSzWE6
	 IOad8cZrAuMxC6AgFoTSpMUMN+wMTGyTC/1Ob7lWTdxKNINZh3PWW61UrjtCHus02u
	 vQ5dh73uEaI74dirb5DZCbsVxav08qnQ07wpt8G8J2zBPbZYe+E80pLGsrALNtG6dK
	 sxBjx17ctnsCF8SmHdPab/gDqAkBqayRlnhVEYF1qTIub8BCZHbTXkYd9rX1ejl7mM
	 QsmQlo098uy1OpdHml3g2AL4ObV9KItCDZTArQC/f2/3zQw2Yu0Y5SsF0POQvjem8o
	 r8ktYRh9zHx4g==
Date: Tue, 15 Apr 2025 11:44:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
Message-ID: <20250415184404.GC25667@frogsfrogsfrogs>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
 <87h62p1syo.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h62p1syo.fsf@gmail.com>

On Tue, Apr 15, 2025 at 06:29:11PM +0530, Ritesh Harjani wrote:
> Catherine Hoang <catherine.hoang@oracle.com> writes:
> 
> > Add a test to validate the new atomic writes feature.
> >
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > Reviewed-by: John Garry <john.g.garry@oracle.com>
> > ---
> >  common/rc             |  51 ++++++++++++
> >  tests/generic/765     | 188 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/765.out |   2 +
> >  3 files changed, 241 insertions(+)
> >  create mode 100755 tests/generic/765
> >  create mode 100644 tests/generic/765.out
> >
> > diff --git a/common/rc b/common/rc
> > index 16d627e1..25e6a1f7 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2996,6 +2996,10 @@ _require_xfs_io_command()
> >  			opts+=" -d"
> >  			pwrite_opts+="-V 1 -b 4k"
> >  		fi
> > +		if [ "$param" == "-A" ]; then
> > +			opts+=" -d"
> > +			pwrite_opts+="-D -V 1 -b 4k"
> 
> It's not strictly required for -A to also have -D in pwrite_opts.
> We might need to add tests later where we would like to test data
> integrity tests with atomic writes, correct? 
> 
> So do we really need to add pwrite_opts with -D too?  IMO, we can drop
> -D, as the test here suggests that -A can only work with the options
> specified in pwrite_opts.

pwrite -D sets RWF_DSYNC, doesn't it?  I think you need that to force
all the metadata updates to disk.... but for feature detection, I think
you have a point that it's not needed.

> > +		fi
> >  		testio=`$XFS_IO_PROG -f $opts -c \
> >  		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> >  		param_checked="$pwrite_opts $param"
> > @@ -5443,6 +5447,53 @@ _require_scratch_btime()
> >  	_scratch_unmount
> >  }
> >  
> > +_get_atomic_write_unit_min()
> > +{
> > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > +        grep atomic_write_unit_min | grep -o '[0-9]\+'
> > +}
> > +
> > +_get_atomic_write_unit_max()
> > +{
> > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > +        grep atomic_write_unit_max | grep -o '[0-9]\+'

Note that this will fail if/when xfs_io starts reporting
atomic_write_unit_max_opt in 6.16.  I think you want to grep for full
words, only:

		grep -w stat.atomic_write_unit_max | awk '{print $3}'

Also: It looks like Zorro merged this patch to for-next, so I guess
subsequent changes should be deltas from this one.

--D

> > +}
> > +
> > +_get_atomic_write_segments_max()
> > +{
> > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > +        grep atomic_write_segments_max | grep -o '[0-9]\+'
> > +}
> > +
> > +_require_scratch_write_atomic()
> > +{
> > +	_require_scratch
> > +
> > +	export STATX_WRITE_ATOMIC=0x10000
> > +
> > +	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> > +	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > +
> > +	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
> > +		_notrun "write atomic not supported by this block device"
> > +	fi
> > +
> > +	_scratch_mkfs > /dev/null 2>&1
> > +	_scratch_mount
> > +
> > +	testfile=$SCRATCH_MNT/testfile
> > +	touch $testfile
> > +
> > +	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> > +	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> > +
> > +	_scratch_unmount
> > +
> > +	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
> > +		_notrun "write atomic not supported by this filesystem"
> > +	fi
> > +}
> > +
> >  _require_inode_limits()
> >  {
> >  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> > diff --git a/tests/generic/765 b/tests/generic/765
> > new file mode 100755
> > index 00000000..9bab3b8a
> > --- /dev/null
> > +++ b/tests/generic/765
> > @@ -0,0 +1,188 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 765
> > +#
> > +# Validate atomic write support
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw
> > +
> > +_require_scratch_write_atomic
> > +_require_xfs_io_command pwrite -A
> > +
> > +get_supported_bsize()
> > +{
> > +    case "$FSTYP" in
> > +    "xfs")
> > +        min_bsize=1024
> > +        for ((i = 65536; i >= 1024; i /= 2)); do
> > +            _scratch_mkfs -b size=$i >> $seqres.full || continue
> > +            if _try_scratch_mount >> $seqres.full 2>&1; then
> > +                max_bsize=$i
> > +                _scratch_unmount
> > +                break;
> > +            fi
> > +        done
> > +        ;;
> > +    "ext4")
> > +        min_bsize=1024
> > +        max_bsize=4096
> 
> Shouldn't we keep max_bsize as system's pagesize? For systems with 64k
> pagesize max_bsize can be 64k.
> 
> max_bsize=$(_get_page_size)
> 
> > +        ;;
> > +    *)
> > +        _notrun "$FSTYP does not support atomic writes"
> > +        ;;
> > +    esac
> > +}
> > +
> > +get_mkfs_opts()
> > +{
> > +    local bsize=$1
> > +
> > +    case "$FSTYP" in
> > +    "xfs")
> > +        mkfs_opts="-b size=$bsize"
> > +        ;;
> > +    "ext4")
> > +        mkfs_opts="-b $bsize"
> > +        ;;
> > +    *)
> > +        _notrun "$FSTYP does not support atomic writes"
> > +        ;;
> > +    esac
> > +}
> > +
> > +test_atomic_writes()
> > +{
> > +    local bsize=$1
> > +
> > +    get_mkfs_opts $bsize
> > +    _scratch_mkfs $mkfs_opts >> $seqres.full
> > +    _scratch_mount
> > +
> > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> 
> Ok, this (_xfs_force_bdev()) clears the rtinherit flag on $SCRATCH_MNT
> in case if someone is passing that in MKFS_OPTIONS right? But since we
> are using our own mkfs_opts, then do we still need this?
> 
> 
> > +
> > +    testfile=$SCRATCH_MNT/testfile
> > +    touch $testfile
> > +
> > +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> > +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> > +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> > +
> > +    # Check that atomic min/max = FS block size
> > +    test $file_min_write -eq $bsize || \
> > +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> > +    test $file_min_write -eq $bsize || \
> 
> we should check for $file_max_write here ^^
> 
> > +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> > +    test $file_max_segments -eq 1 || \
> > +        echo "atomic write max segments $file_max_segments, should be 1"
> > +
> > +    # Check that we can perform an atomic write of len = FS block size
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> > +
> > +    # Check that we can perform an atomic single-block cow write
> > +    if [ "$FSTYP" == "xfs" ]; then
> > +        testfile_cp=$SCRATCH_MNT/testfile_copy
> > +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> > +            cp --reflink $testfile $testfile_cp
> > +        fi
> > +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
> > +            grep wrote | awk -F'[/ ]' '{print $2}')
> > +        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> > +    fi
> > +
> > +    # Check that we can perform an atomic write on an unwritten block
> > +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> > +
> > +    # Check that we can perform an atomic write on a sparse hole
> > +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> > +
> > +    # Check that we can perform an atomic write on a fully mapped block
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
> > +
> > +    # Reject atomic write if len is out of bounds
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> > +        echo "atomic write len=$((bsize - 1)) should fail"
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> > +        echo "atomic write len=$((bsize + 1)) should fail"
> > +
> > +    # Reject atomic write when iovecs > 1
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> > +        echo "atomic write only supports iovec count of 1"
> > +
> > +    # Reject atomic write when not using direct I/O
> > +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> > +        echo "atomic write requires direct I/O"
> > +
> > +    # Reject atomic write when offset % bsize != 0
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> > +        echo "atomic write requires offset to be aligned to bsize"
> > +
> > +    _scratch_unmount
> > +}
> > +
> > +test_atomic_write_bounds()
> > +{
> > +    local bsize=$1
> > +
> > +    get_mkfs_opts $bsize
> > +    _scratch_mkfs $mkfs_opts >> $seqres.full
> > +    _scratch_mount
> > +
> > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> 
> ditto
> 
> -ritesh
> 
> > +
> > +    testfile=$SCRATCH_MNT/testfile
> > +    touch $testfile
> > +
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> > +        echo "atomic write should fail when bsize is out of bounds"
> > +
> > +    _scratch_unmount
> > +}
> > +
> > +sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> > +sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> > +
> > +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> > +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > +
> > +# Test that statx atomic values are the same as sysfs values
> > +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> > +    echo "bdev min write != sys min write"
> > +fi
> > +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> > +    echo "bdev max write != sys max write"
> > +fi
> > +
> > +get_supported_bsize
> > +
> > +# Test all supported block sizes between bdev min and max
> > +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> > +    if [ "$bsize" -ge "$min_bsize" ] && [ "$bsize" -le "$max_bsize" ]; then
> > +        test_atomic_writes $bsize
> > +    fi
> > +done;
> > +
> > +# Check that atomic write fails if bsize < bdev min or bsize > bdev max
> > +if [ $((bdev_min_write / 2)) -ge "$min_bsize" ]; then
> > +    test_atomic_write_bounds $((bdev_min_write / 2))
> > +fi
> > +if [ $((bdev_max_write * 2)) -le "$max_bsize" ]; then
> > +    test_atomic_write_bounds $((bdev_max_write * 2))
> > +fi
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/765.out b/tests/generic/765.out
> > new file mode 100644
> > index 00000000..39c254ae
> > --- /dev/null
> > +++ b/tests/generic/765.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 765
> > +Silence is golden
> > -- 
> > 2.34.1
> 
