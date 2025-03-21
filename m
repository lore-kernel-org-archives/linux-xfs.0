Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05921C5F1B
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 09:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742551060; cv=none; b=WYqOk+H7Fmc5nm2xUGhf8pSy1uQeEtAemqXsXi+H+/SLSRoQykYIS102uUZPCQMgqvZbEDGhbDDvJ/4N1ndoHMRhve3h6UMWpHciEC5H4xVikwRrHWEYxMBrJzTXKXQ2N6yKrs6d3EqK49k1V1aktpU//MaEXWfec17mdc+otDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742551060; c=relaxed/simple;
	bh=QhNFq56LgtWp6yAoYJQHFopzDLCgrMBr2hVBGvfsShQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GSpav8Lt812vOvoeHAALLys7SCLM3HKYoTPMBl0nHIT0bincgYoUxasvO79IfyeQJIdwaLQzhkDOfuENsKZQwka4wIpAe5k2fW2lhD87FeNwuSKuzeZopf/PZvhWRtQKYDZ2uREjlixC5wk4898yW2ZrLYOLiLjtqlhvFIQ3rp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPE6kvH1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPE6kvH1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742551057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pH3fSFZ36dKu7o5Hs5WdvNVe9byLSOcPeCFEwXcky8Q=;
	b=VPE6kvH1ASMws03CD0A0It2myl3pfdJPOwJ9OhJZ3mYBOQZLy6pf+9lgbDMBpmtMAu/haM
	QO7GX8FehlYNSUXSEf87LxFK0SvhDlTGOSWiLoyDgWpvA53JYKzqdmEJFKfR530v2nQWby
	P7T779qQzmUUGybhClDKvmSa4LnwWoI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-1z2cTt38PiSdwP3-AzWmJg-1; Fri, 21 Mar 2025 05:57:36 -0400
X-MC-Unique: 1z2cTt38PiSdwP3-AzWmJg-1
X-Mimecast-MFC-AGG-ID: 1z2cTt38PiSdwP3-AzWmJg_1742551055
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2265a09dbfcso47694255ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 02:57:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742551055; x=1743155855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pH3fSFZ36dKu7o5Hs5WdvNVe9byLSOcPeCFEwXcky8Q=;
        b=CeAhXCrJ/5L+8x+fHwNGWYeB2x54myH4MQvzEjzjWSpc9IjlutdUVO0gTZQedoMO7K
         dBoyH7Zmf2Z8ETLzEqpXfV3J5kUrHjzUH1zs+AfpYXCQnTwMUwWp/lh2tZTiiB94Vlt9
         rqsHPtLXe8+1MS6Ye1ptqSFTSvhaApde+zq6clLNeX0tsTntPuQSlChsECk3ze0SUh2S
         Dz1dkZYMBQo7lnIqbaNND1t5988b47+YTvGxzDnvZqmZ8GvnuBJ4avCJBwtJW0SugEAI
         0buw4+K157lXKkIbnScTLE3PBnuvMOfxMj4+TCCPX1yv1+G9/Bv0bOHA6K/HPzEwFDTo
         UCjQ==
X-Gm-Message-State: AOJu0YwV8jzdmDi+tx5JIuCaYR0JuQ9RI8KoFGJFjLwXXPa+ozsKu7qQ
	jLvJiuX7THkxqLpNj/I3lLTnMscQgRn5+SPEs9vvyR7YTbN1+b1tTOI8DpsHRr2s9Z01vESe9W1
	OYDJJaLoEqnxqkIF0TYwrwmbfmL8eAQgh5pFmi73yQDbd99WJzx7qd9Ec73G59jlqeOt+
X-Gm-Gg: ASbGncs/shDEtxx8/AcrlIyLf3q/n0fHA2xLcLQjNkVyY0VwE5EEct+Atm/n9oEMwJE
	aifbW0njmYdPafXo7rVOhKCSYUe7i5nMNgyO5O63WcsRVp9veNYwe1D2/B6WUzOFuMSoseeaOQm
	pF6AUiBwtcjWkbmLB1yw8mF7KGLWf2MBDMyHlvjl1pBLXkbXq1BI99PjY1eHsf3qAhj1MC3lBF6
	WBR5b6h8Us1pvAhRqbN0C41F8yzac3O4gm51JwMcd25ikmeXgLhQzAUXsXsRzrCVceY3JpMKy9L
	qKd4cGmOac1B7S0TaSTuNxmt9PJCX+IF4mn7+loS5F4Er0PFskolfnO6
X-Received: by 2002:a17:902:d549:b0:224:a96:e39 with SMTP id d9443c01a7336-22780c55343mr47241975ad.9.1742551054906;
        Fri, 21 Mar 2025 02:57:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHyRuq9c1gj7R1ZbbjKh4vsmm4/BpUs82+YnxMFZ7ujxpSCaYSk+rudk4xJbywdIR/ezla6A==
X-Received: by 2002:a17:902:d549:b0:224:a96:e39 with SMTP id d9443c01a7336-22780c55343mr47241705ad.9.1742551054329;
        Fri, 21 Mar 2025 02:57:34 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811bb0dfsm12372325ad.108.2025.03.21.02.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 02:57:34 -0700 (PDT)
Date: Fri, 21 Mar 2025 17:57:30 +0800
From: Zorro Lang <zlang@redhat.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
Message-ID: <20250321095730.4wufzfwxb665lwld@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250228002059.16750-1-catherine.hoang@oracle.com>

On Thu, Feb 27, 2025 at 04:20:59PM -0800, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---

At first, the subject is "xfs: add a test for atomic writes", but it's
a generic test case, so please replace "xfs" with "generic".

>  common/rc             |  51 ++++++++++++++
>  tests/generic/762     | 160 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/762.out |   2 +
>  3 files changed, 213 insertions(+)
>  create mode 100755 tests/generic/762
>  create mode 100644 tests/generic/762.out
> 
> diff --git a/common/rc b/common/rc
> index 6592c835..08a9d9b8 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2837,6 +2837,10 @@ _require_xfs_io_command()
>  			opts+=" -d"
>  			pwrite_opts+="-V 1 -b 4k"
>  		fi
> +		if [ "$param" == "-A" ]; then
> +			opts+=" -d"
> +			pwrite_opts+="-D -V 1 -b 4k"
> +		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
>  		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
>  		param_checked="$pwrite_opts $param"
> @@ -5175,6 +5179,53 @@ _require_scratch_btime()
>  	_scratch_unmount
>  }
>  
> +_get_atomic_write_unit_min()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_unit_min | grep -o '[0-9]\+'
> +}
> +
> +_get_atomic_write_unit_max()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_unit_max | grep -o '[0-9]\+'
> +}
> +
> +_get_atomic_write_segments_max()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_segments_max | grep -o '[0-9]\+'
> +}
> +
> +_require_scratch_write_atomic()
> +{
> +	_require_scratch
> +
> +	export STATX_WRITE_ATOMIC=0x10000
> +
> +	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +
> +	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
> +		_notrun "write atomic not supported by this block device"
> +	fi
> +
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
> +
> +	testfile=$SCRATCH_MNT/testfile
> +	touch $testfile
> +
> +	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> +	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +
> +	_scratch_unmount
> +
> +	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
> +		_notrun "write atomic not supported by this filesystem"
> +	fi
> +}
> +
>  _require_inode_limits()
>  {
>  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/generic/762 b/tests/generic/762
> new file mode 100755
> index 00000000..d0a80219
> --- /dev/null
> +++ b/tests/generic/762
> @@ -0,0 +1,160 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 762
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_require_scratch_write_atomic
> +_require_xfs_io_command pwrite -A
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    case "$FSTYP" in
> +    "xfs")
> +        mkfs_opts="-b size=$bsize"
> +        ;;
> +    "ext4")
> +        mkfs_opts="-b $bsize"
> +        ;;
> +    *)
> +        ;;

Does that mean we only support xfs and ext4? What if ext2/3 ? What if other fs,
e.g. btrfs, nfs, overlay, exfat, tmpfs and so on?

> +    esac
> +
> +    # If block size is not supported, skip this test
> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> +    _try_scratch_mount >>$seqres.full 2>&1 || return

If mkfs or mount fails, this function returns directly. Below test_atomic_write_bounds
is similar. These two functions are the main test part of this case, if these two
functions returns directly without any check and output, won't this test report pass
without any testing?

Thanks,
Zorro

> +
> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> +
> +    # Check that atomic min/max = FS block size
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> +    test $file_max_segments -eq 1 || \
> +        echo "atomic write max segments $file_max_segments, should be 1"
> +
> +    # Check that we can perform an atomic write of len = FS block size
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> +
> +    # Check that we can perform an atomic single-block cow write
> +    if [ "$FSTYP" == "xfs" ]; then
> +        testfile_cp=$SCRATCH_MNT/testfile_copy
> +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> +            cp --reflink $testfile $testfile_cp
> +        fi
> +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
> +            grep wrote | awk -F'[/ ]' '{print $2}')
> +        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> +    fi
> +
> +    # Check that we can perform an atomic write on an unwritten block
> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> +
> +    # Check that we can perform an atomic write on a sparse hole
> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> +
> +    # Check that we can perform an atomic write on a fully mapped block
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
> +
> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize - 1)) should fail"
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize + 1)) should fail"
> +
> +    # Reject atomic write when iovecs > 1
> +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write only supports iovec count of 1"
> +
> +    # Reject atomic write when not using direct I/O
> +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write requires direct I/O"
> +
> +    # Reject atomic write when offset % bsize != 0
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write requires offset to be aligned to bsize"
> +
> +    _scratch_unmount
> +}
> +
> +test_atomic_write_bounds()
> +{
> +    local bsize=$1
> +
> +    case "$FSTYP" in
> +    "xfs")
> +        mkfs_opts="-b size=$bsize"
> +        ;;
> +    "ext4")
> +        mkfs_opts="-b $bsize"
> +        ;;
> +    *)
> +        ;;
> +    esac
> +
> +    # If block size is not supported, skip this test
> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> +    _try_scratch_mount >>$seqres.full 2>&1 || return
> +
> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> +        echo "atomic write should fail when bsize is out of bounds"
> +
> +    _scratch_unmount
> +}
> +
> +sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> +sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> +
> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> +
> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> +    echo "bdev min write != sys min write"
> +fi
> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> +    echo "bdev max write != sys max write"
> +fi
> +
> +# Test all supported block sizes between bdev min and max
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +        test_atomic_writes $bsize
> +done;
> +
> +# Check that atomic write fails if bsize < bdev min or bsize > bdev max
> +test_atomic_write_bounds $((bdev_min_write / 2))
> +test_atomic_write_bounds $((bdev_max_write * 2))
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/762.out b/tests/generic/762.out
> new file mode 100644
> index 00000000..fbaeb297
> --- /dev/null
> +++ b/tests/generic/762.out
> @@ -0,0 +1,2 @@
> +QA output created by 762
> +Silence is golden
> -- 
> 2.34.1
> 
> 

