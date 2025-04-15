Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C00288CBE;
	Tue, 15 Apr 2025 13:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744723586; cv=none; b=L3aJBkDNAuweOGWydEnWqoEy1X7Q8jjxlbbumA2q2v4BWS2bNvH+7wFoAd0SIwzy6e8a+wv+84WzQdIofM3RY8JsVQ4JjQkn1Wmcrle+U2lksFU1jBiaY6Gaqvb5HNai2Bwo9EDA+ZgB4Helq4CVKpwA2thdBLTbDZ5A5Xycoow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744723586; c=relaxed/simple;
	bh=zGxN+JNnn3UpNuKsf8Ko8pjN03PPs8HjByyCXW5k7eM=;
	h=From:To:Subject:In-Reply-To:Date:Message-ID:References; b=RRyCegwLssRFTGEQsIiOdbHg9IC0uZf0BZsbWKSp+7ta3n7rEgSrM57cbab1SUI4w/LGRTKX0Db/LEOGIESRJ7av3uOMY+Q8RVAk424YRRfjZ6cs+pCSpkKbuMgkf7S9ir1W8oS20AJDJpJ+MaaLXBbkFbm2lYAx9EUcrYP26E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ALlFAp7S; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ALlFAp7S"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso7300538b3a.2;
        Tue, 15 Apr 2025 06:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744723583; x=1745328383; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:to:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aQwX1tssu1x8nj0Bjn1+M6U9hcyeMNDc5/kqwwEd9XM=;
        b=ALlFAp7SbjdFij7UaLBLvaE4xQ8zyVXHRJtHDZm75lBf35ICrd9Q2JbfND6MFLlxR3
         3HTRo1+ZVbhgydvixTAq2lHI9fj0n6xrnflntciTWcol0SLlLbgt3iAl+wwEPnprAhhA
         L4kmdwxl6ICnPtU8ku6M5gUmuETzJVTj+6OTZiQfgNyF+oGKOlePrqADk4cyZ4mfce2a
         o1MOL3gZTMh7doLSls98obJD1b6xvRJ/wIDD4otsFk/RfB8TF465LFQSl00GHOgCBAEk
         3VNIX/mwW8zU0t15kEtNxm9DAasQn5n6sOlnsHedvG9SKK0Qu0JQeF3ObUvCQu8fBxCo
         pHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744723583; x=1745328383;
        h=references:message-id:date:in-reply-to:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aQwX1tssu1x8nj0Bjn1+M6U9hcyeMNDc5/kqwwEd9XM=;
        b=S3kWQPN38QRDlyeH1dbQSCY2ks6dbQ2Lkyz8xAKxZbb+05t2lD+tTVsQeKZ5UsaSXF
         HPaIjYKdYAbP7ZJsn7rLFrQNJ/BjCnS2wVZKEEzuksSrrE3hGOKniVr7Uh1/voSenwcY
         I+Fh8mQbbo/QrfSGxSts3EPWWl87VisERb3H9GI2N61sUg1FouedGll/UcfvxsX74PSv
         5LS2ZRqzn8p9H0PlEQw7LAng94lcB54E/6sHYvmwSLFCJeozpogBoLVZDgfeNP35LV3F
         2o869BM0qObZfSTtiWjRaB9PRQwEfpsomf70UY9tp6eA8XmiAVs0I6XYnHGElaisLQbP
         Fa/A==
X-Forwarded-Encrypted: i=1; AJvYcCVFe17WmYN6AUUe6axY5pO0pGmAW7gvgBtroGhDwfCeFWJCgapfuO9ramq7AjcLe2bm9OmP41Y/@vger.kernel.org, AJvYcCVL7+aSLIfP2gMKzd4Ko4NtjhgD8bXJdXKXcGIL30HwWCX2OQYXRN0GcP7gTyI6E/tId/FN7GkcsI5a@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1ErcC96/KqezjfwgHizSWq1sUBE1Y86YICbgIjVqTFSlta/yA
	BpA2FVJzpIAqQfLwLtd8HfmIu82uGQhEanmqHngqTTZ2NHiR9CbbpZTKZw==
X-Gm-Gg: ASbGnctczlaa4jZEcExxfQaDts8kDs1IBhFf5hfUUyb2SidTzjmo8ot7rFWViZnGhNm
	5JHBMmEq0TYpoXjiyAjkrg81bkvl7LsEmj2qmb+BLpmxuQKghzSrrgDcNzNe/W7ZtoX6KpbHJG0
	Mjb12KVCQ5C9p7zrXzltXKhJZ6fLqHV0Tg+bmu3vYq6KlYZjZR0bFUYaRRaUH1U4N5VW/dospuA
	n5vBzcPMpBFJEgsuQKewa8K+b3Js4qCgGEaR2a6PNdlwvVg+mt8ZlRfcmofUa7/e/i9EKLFLhF0
	ALt1WmAzgT879tMujprWzwnaGkeh6wIQeA==
X-Google-Smtp-Source: AGHT+IHmKtNv+tc707ldfn/bIz47IYlr55LFQ4PTKouvHZVNWyqRLIGfeeBQzb2osiSIi8Wn7B6Gsg==
X-Received: by 2002:a05:6a00:328f:b0:736:5664:53f3 with SMTP id d2e1a72fcca58-73bd126165amr18364620b3a.15.1744723582876;
        Tue, 15 Apr 2025 06:26:22 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd22f0f8esm8737184b3a.103.2025.04.15.06.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 06:26:22 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
In-Reply-To: <20250410042317.82487-1-catherine.hoang@oracle.com>
Date: Tue, 15 Apr 2025 18:29:11 +0530
Message-ID: <87h62p1syo.fsf@gmail.com>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> Add a test to validate the new atomic writes feature.
>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>  common/rc             |  51 ++++++++++++
>  tests/generic/765     | 188 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/765.out |   2 +
>  3 files changed, 241 insertions(+)
>  create mode 100755 tests/generic/765
>  create mode 100644 tests/generic/765.out
>
> diff --git a/common/rc b/common/rc
> index 16d627e1..25e6a1f7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2996,6 +2996,10 @@ _require_xfs_io_command()
>  			opts+=" -d"
>  			pwrite_opts+="-V 1 -b 4k"
>  		fi
> +		if [ "$param" == "-A" ]; then
> +			opts+=" -d"
> +			pwrite_opts+="-D -V 1 -b 4k"

It's not strictly required for -A to also have -D in pwrite_opts.
We might need to add tests later where we would like to test data
integrity tests with atomic writes, correct? 

So do we really need to add pwrite_opts with -D too?  IMO, we can drop
-D, as the test here suggests that -A can only work with the options
specified in pwrite_opts.

> +		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
>  		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
>  		param_checked="$pwrite_opts $param"
> @@ -5443,6 +5447,53 @@ _require_scratch_btime()
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
> diff --git a/tests/generic/765 b/tests/generic/765
> new file mode 100755
> index 00000000..9bab3b8a
> --- /dev/null
> +++ b/tests/generic/765
> @@ -0,0 +1,188 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 765
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_require_scratch_write_atomic
> +_require_xfs_io_command pwrite -A
> +
> +get_supported_bsize()
> +{
> +    case "$FSTYP" in
> +    "xfs")
> +        min_bsize=1024
> +        for ((i = 65536; i >= 1024; i /= 2)); do
> +            _scratch_mkfs -b size=$i >> $seqres.full || continue
> +            if _try_scratch_mount >> $seqres.full 2>&1; then
> +                max_bsize=$i
> +                _scratch_unmount
> +                break;
> +            fi
> +        done
> +        ;;
> +    "ext4")
> +        min_bsize=1024
> +        max_bsize=4096

Shouldn't we keep max_bsize as system's pagesize? For systems with 64k
pagesize max_bsize can be 64k.

max_bsize=$(_get_page_size)

> +        ;;
> +    *)
> +        _notrun "$FSTYP does not support atomic writes"
> +        ;;
> +    esac
> +}
> +
> +get_mkfs_opts()
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
> +        _notrun "$FSTYP does not support atomic writes"
> +        ;;
> +    esac
> +}
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    get_mkfs_opts $bsize
> +    _scratch_mkfs $mkfs_opts >> $seqres.full
> +    _scratch_mount
> +
> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT

Ok, this (_xfs_force_bdev()) clears the rtinherit flag on $SCRATCH_MNT
in case if someone is passing that in MKFS_OPTIONS right? But since we
are using our own mkfs_opts, then do we still need this?


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

we should check for $file_max_write here ^^

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
> +    get_mkfs_opts $bsize
> +    _scratch_mkfs $mkfs_opts >> $seqres.full
> +    _scratch_mount
> +
> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT

ditto

-ritesh

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
> +# Test that statx atomic values are the same as sysfs values
> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> +    echo "bdev min write != sys min write"
> +fi
> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> +    echo "bdev max write != sys max write"
> +fi
> +
> +get_supported_bsize
> +
> +# Test all supported block sizes between bdev min and max
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +    if [ "$bsize" -ge "$min_bsize" ] && [ "$bsize" -le "$max_bsize" ]; then
> +        test_atomic_writes $bsize
> +    fi
> +done;
> +
> +# Check that atomic write fails if bsize < bdev min or bsize > bdev max
> +if [ $((bdev_min_write / 2)) -ge "$min_bsize" ]; then
> +    test_atomic_write_bounds $((bdev_min_write / 2))
> +fi
> +if [ $((bdev_max_write * 2)) -le "$max_bsize" ]; then
> +    test_atomic_write_bounds $((bdev_max_write * 2))
> +fi
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/765.out b/tests/generic/765.out
> new file mode 100644
> index 00000000..39c254ae
> --- /dev/null
> +++ b/tests/generic/765.out
> @@ -0,0 +1,2 @@
> +QA output created by 765
> +Silence is golden
> -- 
> 2.34.1
