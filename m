Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D3926E63C;
	Fri, 28 Feb 2025 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740757416; cv=none; b=nLYPxTTiO4Vcu0I9GiL5fX5vmXpGi2KH0DQQ9wfUUGM76CzTTxYBbLQc1fxcPXJ4xanUoqcpPkNnP/IdDU/+jOt1sXO/sS6+3uXiGmEtgFeE90aoxwfLjNR3ef5yfRvW4ZCwP2gwBZcvYJXyHKnYjox7VbRFKTgbzkhHrjozmcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740757416; c=relaxed/simple;
	bh=O8VQdjgqxxnKQ7Fm7LzoFdu/DwulGF5u+C7S5xtQujk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhmgdNvl159sbhaDmQg7dAwW+jViUieugyNLbZXUW9W9NuC0FH7ukcBsBp3rrEzScXCJ/JE1KNysC6aYC/nULDylkahUZDirWic6Mp9fVCfno/HVWevP2PVN9snB6QFnaD/+D5mJLyVY7FPMPs8FlbOCVBoa+t+rA4xFE+ro4jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+qQTWGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+qQTWGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6E8C4CEE2;
	Fri, 28 Feb 2025 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740757416;
	bh=O8VQdjgqxxnKQ7Fm7LzoFdu/DwulGF5u+C7S5xtQujk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o+qQTWGcr4hmZTDHfmgeYjyz8i/pw1VN1wkev7U3SNGgGQ8MYWA1wdrMue7VuR7jE
	 f42vG2k470+uViKdHRAecLZFhOoHy9JaOx/3j+Aqq+En3GqmizhYC1CLrV0agi4kt9
	 hqObCppr23v5VHpSg3cQiwxHevFeuByweFiw5ukUx7q3cNQBev9BJb49VEmbjNjAYI
	 KU2/dazfGFgjj97ZFHV+jeUWrdX1uS+0Ijkl+/Cxv26KjYHQtKt8Ufb6TATukRlTjV
	 +U+o145qFOhjDkQRXAICOE9zG6BdJ7RX7k8U8jg8YJ/KJB2K8QF3OMVPgizfO/lCw9
	 m+LqIGkJmwYFQ==
Date: Fri, 28 Feb 2025 07:43:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
Message-ID: <20250228154335.GZ6242@frogsfrogsfrogs>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
 <20250228021156.GX6242@frogsfrogsfrogs>
 <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>

On Fri, Feb 28, 2025 at 07:01:50PM +0530, Nirjhar Roy (IBM) wrote:
> On Thu, 2025-02-27 at 18:11 -0800, Darrick J. Wong wrote:
> > On Thu, Feb 27, 2025 at 04:20:59PM -0800, Catherine Hoang wrote:
> > > Add a test to validate the new atomic writes feature.
> > > 
> > > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > > Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > 
> > Er.... what git tree is this based upon?  generic/762 is a project
> > quota
> > test.
> On which branch do you have tests/generic/762? I checked the latest
> master(commit - 8467552f09e1672a02712653b532a84bd46ea10e) and the for-
> next(commit - 5b56a2d888191bfc7131b096e611eab1881d8422) and it doesn't
> seem to exist there. However, tests/xfs/762 does exist. 

Zorro's patches-in-queue, aka whatever gets pushed to for-next on
Sunday.  My confusion stems from this patch modifying what looks like an
existing atomic writes test, but generic/762 isn't that test so now I
can't see everything that this test is examining.

(I suggest everyone please post urls to public git repos so reviewers
can get around these sorts of issues in the future.)

--D

> --NR
> > 
> > --D
> > 
> > > ---
> > >  common/rc             |  51 ++++++++++++++
> > >  tests/generic/762     | 160
> > > ++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/762.out |   2 +
> > >  3 files changed, 213 insertions(+)
> > >  create mode 100755 tests/generic/762
> > >  create mode 100644 tests/generic/762.out
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 6592c835..08a9d9b8 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -2837,6 +2837,10 @@ _require_xfs_io_command()
> > >  			opts+=" -d"
> > >  			pwrite_opts+="-V 1 -b 4k"
> > >  		fi
> > > +		if [ "$param" == "-A" ]; then
> > > +			opts+=" -d"
> > > +			pwrite_opts+="-D -V 1 -b 4k"
> > > +		fi
> > >  		testio=`$XFS_IO_PROG -f $opts -c \
> > >  		        "pwrite $pwrite_opts $param 0 4k" $testfile
> > > 2>&1`
> > >  		param_checked="$pwrite_opts $param"
> > > @@ -5175,6 +5179,53 @@ _require_scratch_btime()
> > >  	_scratch_unmount
> > >  }
> > >  
> > > +_get_atomic_write_unit_min()
> > > +{
> > > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > > +        grep atomic_write_unit_min | grep -o '[0-9]\+'
> > > +}
> > > +
> > > +_get_atomic_write_unit_max()
> > > +{
> > > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > > +        grep atomic_write_unit_max | grep -o '[0-9]\+'
> > > +}
> > > +
> > > +_get_atomic_write_segments_max()
> > > +{
> > > +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> > > +        grep atomic_write_segments_max | grep -o '[0-9]\+'
> > > +}
> > > +
> > > +_require_scratch_write_atomic()
> > > +{
> > > +	_require_scratch
> > > +
> > > +	export STATX_WRITE_ATOMIC=0x10000
> > > +
> > > +	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> > > +	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > > +
> > > +	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
> > > +		_notrun "write atomic not supported by this block
> > > device"
> > > +	fi
> > > +
> > > +	_scratch_mkfs > /dev/null 2>&1
> > > +	_scratch_mount
> > > +
> > > +	testfile=$SCRATCH_MNT/testfile
> > > +	touch $testfile
> > > +
> > > +	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> > > +	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> > > +
> > > +	_scratch_unmount
> > > +
> > > +	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
> > > +		_notrun "write atomic not supported by this filesystem"
> > > +	fi
> > > +}
> > > +
> > >  _require_inode_limits()
> > >  {
> > >  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> > > diff --git a/tests/generic/762 b/tests/generic/762
> > > new file mode 100755
> > > index 00000000..d0a80219
> > > --- /dev/null
> > > +++ b/tests/generic/762
> > > @@ -0,0 +1,160 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 762
> > > +#
> > > +# Validate atomic write support
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick rw
> > > +
> > > +_require_scratch_write_atomic
> > > +_require_xfs_io_command pwrite -A
> > > +
> > > +test_atomic_writes()
> > > +{
> > > +    local bsize=$1
> > > +
> > > +    case "$FSTYP" in
> > > +    "xfs")
> > > +        mkfs_opts="-b size=$bsize"
> > > +        ;;
> > > +    "ext4")
> > > +        mkfs_opts="-b $bsize"
> > > +        ;;
> > > +    *)
> > > +        ;;
> > > +    esac
> > > +
> > > +    # If block size is not supported, skip this test
> > > +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> > > +    _try_scratch_mount >>$seqres.full 2>&1 || return
> > > +
> > > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > > +
> > > +    testfile=$SCRATCH_MNT/testfile
> > > +    touch $testfile
> > > +
> > > +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> > > +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> > > +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> > > +
> > > +    # Check that atomic min/max = FS block size
> > > +    test $file_min_write -eq $bsize || \
> > > +        echo "atomic write min $file_min_write, should be fs block
> > > size $bsize"
> > > +    test $file_min_write -eq $bsize || \
> > > +        echo "atomic write max $file_max_write, should be fs block
> > > size $bsize"
> > > +    test $file_max_segments -eq 1 || \
> > > +        echo "atomic write max segments $file_max_segments, should
> > > be 1"
> > > +
> > > +    # Check that we can perform an atomic write of len = FS block
> > > size
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> > > $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write
> > > len=$bsize failed"
> > > +
> > > +    # Check that we can perform an atomic single-block cow write
> > > +    if [ "$FSTYP" == "xfs" ]; then
> > > +        testfile_cp=$SCRATCH_MNT/testfile_copy
> > > +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> > > +            cp --reflink $testfile $testfile_cp
> > > +        fi
> > > +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b
> > > $bsize 0 $bsize" $testfile_cp | \
> > > +            grep wrote | awk -F'[/ ]' '{print $2}')
> > > +        test $bytes_written -eq $bsize || echo "atomic write on
> > > reflinked file failed"
> > > +    fi
> > > +
> > > +    # Check that we can perform an atomic write on an unwritten
> > > block
> > > +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize
> > > $bsize $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write to
> > > unwritten block failed"
> > > +
> > > +    # Check that we can perform an atomic write on a sparse hole
> > > +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> > > $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write to sparse
> > > hole failed"
> > > +
> > > +    # Check that we can perform an atomic write on a fully mapped
> > > block
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> > > $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write to mapped
> > > block failed"
> > > +
> > > +    # Reject atomic write if len is out of bounds
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))"
> > > $testfile 2>> $seqres.full && \
> > > +        echo "atomic write len=$((bsize - 1)) should fail"
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))"
> > > $testfile 2>> $seqres.full && \
> > > +        echo "atomic write len=$((bsize + 1)) should fail"
> > > +
> > > +    # Reject atomic write when iovecs > 1
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize"
> > > $testfile 2>> $seqres.full && \
> > > +        echo "atomic write only supports iovec count of 1"
> > > +
> > > +    # Reject atomic write when not using direct I/O
> > > +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile
> > > 2>> $seqres.full && \
> > > +        echo "atomic write requires direct I/O"
> > > +
> > > +    # Reject atomic write when offset % bsize != 0
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize"
> > > $testfile 2>> $seqres.full && \
> > > +        echo "atomic write requires offset to be aligned to bsize"
> > > +
> > > +    _scratch_unmount
> > > +}
> > > +
> > > +test_atomic_write_bounds()
> > > +{
> > > +    local bsize=$1
> > > +
> > > +    case "$FSTYP" in
> > > +    "xfs")
> > > +        mkfs_opts="-b size=$bsize"
> > > +        ;;
> > > +    "ext4")
> > > +        mkfs_opts="-b $bsize"
> > > +        ;;
> > > +    *)
> > > +        ;;
> > > +    esac
> > > +
> > > +    # If block size is not supported, skip this test
> > > +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> > > +    _try_scratch_mount >>$seqres.full 2>&1 || return
> > > +
> > > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > > +
> > > +    testfile=$SCRATCH_MNT/testfile
> > > +    touch $testfile
> > > +
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize"
> > > $testfile 2>> $seqres.full && \
> > > +        echo "atomic write should fail when bsize is out of
> > > bounds"
> > > +
> > > +    _scratch_unmount
> > > +}
> > > +
> > > +sys_min_write=$(cat "/sys/block/$(_short_dev
> > > $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> > > +sys_max_write=$(cat "/sys/block/$(_short_dev
> > > $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> > > +
> > > +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> > > +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > > +
> > > +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> > > +    echo "bdev min write != sys min write"
> > > +fi
> > > +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> > > +    echo "bdev max write != sys max write"
> > > +fi
> > > +
> > > +# Test all supported block sizes between bdev min and max
> > > +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> > > +        test_atomic_writes $bsize
> > > +done;
> > > +
> > > +# Check that atomic write fails if bsize < bdev min or bsize >
> > > bdev max
> > > +test_atomic_write_bounds $((bdev_min_write / 2))
> > > +test_atomic_write_bounds $((bdev_max_write * 2))
> > > +
> > > +# success, all done
> > > +echo Silence is golden
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/762.out b/tests/generic/762.out
> > > new file mode 100644
> > > index 00000000..fbaeb297
> > > --- /dev/null
> > > +++ b/tests/generic/762.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 762
> > > +Silence is golden
> > > -- 
> > > 2.34.1
> > > 
> > > 
> 
> 
