Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181B915E8B;
	Sat, 17 May 2025 03:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747454154; cv=none; b=go4cndqa5r7M2DlouQWt75tzQS97lHyl0dj9szp6E6Ek3gvgDGOYPBagrB8JQi3Fk+rw5eMXgWwYRPxnAB8bOF4H2cWtXHE50MFOcwWYY2L4ZQEHkDQNBajiywFhwb7Cehk5dz7QgrJrR1ctvXT8bPEDu07FZH8CPmZsx+ps2Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747454154; c=relaxed/simple;
	bh=DqH4lSyKCsNIDSCK9bG0PaxeXywNONO99F6QObJ5YCQ=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=gaRSuMhFkrRB13IcECnUJBFiZhxJGiMK0Q2DEf0MQ9eArH8ol1C3CK40I7hmpgS5Ny6Vee2aUGbPXSNLSPZ/O8xQq39LacE4zCGQodRHiKTB88iheg/DOi/A10iZ+p1GCwptg+1T2wc3QMOxgbrEej7lddILa3rDgGTDHdp7wTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VEC4MwfN; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VEC4MwfN"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-30ea8e2bbaaso221817a91.2;
        Fri, 16 May 2025 20:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747454152; x=1748058952; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vaxjr4KesTsk2M8k9r8mdNWHwOGqO2ZfxkBtvDmarI4=;
        b=VEC4MwfNkOhshLC4g0MgQbhc3zPykTTm8taZrQsHeQGGvyhagnyPkzHYWGnosjyoIE
         XM3q2KuT8CnJlEoWwlhEGcUT4ErmWTr8rfEA2RWYrlWkH/1P33CyC33ZP+VbOaE597Xg
         zXsMY2k2KURKxeOkjnllF6GzUbv9b1PE4ZoOokJ0tppLL62SLIC8mWT0Ra48c+l7/o2x
         dXQwxitasiPNPO5NYnQqM4kWuUU4DNKSgrJS6aipQycy92qVOOo2Eezr3jLKvuxdrEhW
         dJ8t05GcKj2mAP6yMWD8bRJu+tK3ga3Jyw5MFDXv86ocSqnwpUSArgr0g35hsltW4TnZ
         g9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747454152; x=1748058952;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vaxjr4KesTsk2M8k9r8mdNWHwOGqO2ZfxkBtvDmarI4=;
        b=bxQ4Atr3ntKM+vbpsU6sDkB2sIlU3mC4cgD5KGOAAW3Pty4O1x6diEIP1gAKOGG9dY
         uuqL18xZptZgp+R22B9yQOtH2Hi8GnWGmVpQFOmG/l6yQd9+E9CTDU7HRVjcqpZyIzYn
         kQUaRIfylv/il6dwRuSOtL7/SfnaPoRKrOIK+Uo0lGnpeKBbwDTQ6A0savEvUudRcxcN
         IVskI9D7mcuEprIEY/YHqsQfj5o8OjPO3aSCdqDDLZRjcghT5guGBVcEKdKImfyWUV91
         4LmFPBS0oSyeBZyhqfcfUE2/mRgzX0h/s8j9iHED3XiMI7hZ5sL4vWMgo1O4E9/F2inh
         1vjg==
X-Forwarded-Encrypted: i=1; AJvYcCU+7L++0n9tU+OjxICoEVKJOVsq1owYLPnP8ZTyCnsVXtqxwVW3MIoj5fdTJ8jyWwGUrpyTZFqTDlK5@vger.kernel.org, AJvYcCVacyXGa6oUTl/36LE7qVWEcv3Md+kNzJbdobSaxzerKx0CA1CEeFM4dSzymBY0XzHk/DMQovv/@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/d388PVwDd7ovsa4nnILQ3XYXzwvxCh5wTI35LqbIIs8OLrak
	4SukpZZ4qjHAyrUvxcehPAfiimDcT/ztg6fxYrJGq9nPJMym/ow+OZDabjVUrQ==
X-Gm-Gg: ASbGncvtTK1bYh2Hd0mvPW2C5J4wL/XTI9F4RZv0jiHtqnuC7obVTKsOIzWBmxfvf8J
	6kNkJNG7Y0JK2g7DOGnqtqWEaozmt22nblWsMqZOkWX/JclKMwSnApQde4sjWL5R09ZBB5xoUts
	AayKNxO64DkIZT/g57Zk69Mm+lN3d1FOeTDSU6/BjYLQ8P9paCSVzeSh+/NL5Aj8Bf/bf0HvEw6
	eWZyTjkZ2HfcAYc0mD87Oa7z+aVInqCwEfIFYMap8xxntMnCIQcTLi11BZ4wDgsO1P+KvTRC6a5
	X8xzqnDw8MscPvNPbOx7vQDKv7K0KSQOFUYXHHJ4wuZoapeD7fDc8g==
X-Google-Smtp-Source: AGHT+IEDQ4/j5c6WWw9lOOXiY9vfRA/hybLCX6qn7Cy1/0UPdmxCR7A0s2+d2zBFP9Y1z61/rHDZkg==
X-Received: by 2002:a17:90b:5188:b0:2ee:b4bf:2d06 with SMTP id 98e67ed59e1d1-30e7d558b85mr7449535a91.19.1747454152029;
        Fri, 16 May 2025 20:55:52 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30e8c587733sm1478165a91.14.2025.05.16.20.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 20:55:51 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 3/6] generic/765: move common atomic write code to a library file
In-Reply-To: <20250514002915.13794-4-catherine.hoang@oracle.com>
Date: Sat, 17 May 2025 09:19:24 +0530
Message-ID: <87frh3x5ff.fsf@gmail.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com> <20250514002915.13794-4-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Move the common atomic writes code to common/atomic so we can share
> them.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/atomicwrites | 111 ++++++++++++++++++++++++++++++++++++++++++++
>  common/rc           |  47 -------------------
>  tests/generic/765   |  53 ++-------------------
>  3 files changed, 114 insertions(+), 97 deletions(-)
>  create mode 100644 common/atomicwrites
>
> diff --git a/common/atomicwrites b/common/atomicwrites
> new file mode 100644
> index 00000000..fd3a9b71
> --- /dev/null
> +++ b/common/atomicwrites
> @@ -0,0 +1,111 @@
> +##/bin/bash
> +# SPDX-License-Identifier: GPL-2.0+
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# Routines for testing atomic writes.
> +
> +_get_atomic_write_unit_min()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep atomic_write_unit_min | grep -o '[0-9]\+'
> +}
> +
> +_get_atomic_write_unit_max()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
> +}
> +
> +_get_atomic_write_segments_max()
> +{
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> +        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
> +}
> +
> +_require_scratch_write_atomic()

NIT: It would be more convenient if we had this as _require_scratch_atomic_write()


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
> +_test_atomic_file_writes()
> +{
> +    local bsize="$1"
> +    local testfile="$2"
> +    local bytes_written
> +    local testfile_cp="$testfile.copy"
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
> +}
> diff --git a/common/rc b/common/rc
> index 3a70c707..781fc9ba 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5433,53 +5433,6 @@ _require_scratch_btime()
>  	_scratch_unmount
>  }
>  
> -_get_atomic_write_unit_min()
> -{
> -	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep atomic_write_unit_min | grep -o '[0-9]\+'
> -}
> -
> -_get_atomic_write_unit_max()
> -{
> -	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
> -}
> -
> -_get_atomic_write_segments_max()
> -{
> -	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
> -}
> -
> -_require_scratch_write_atomic()
> -{
> -	_require_scratch
> -
> -	export STATX_WRITE_ATOMIC=0x10000
> -
> -	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> -	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> -
> -	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
> -		_notrun "write atomic not supported by this block device"
> -	fi
> -
> -	_scratch_mkfs > /dev/null 2>&1
> -	_scratch_mount
> -
> -	testfile=$SCRATCH_MNT/testfile
> -	touch $testfile
> -
> -	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> -	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> -
> -	_scratch_unmount
> -
> -	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
> -		_notrun "write atomic not supported by this filesystem"
> -	fi
> -}
> -
>  _require_inode_limits()
>  {
>  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/generic/765 b/tests/generic/765
> index 84381730..09e9fa38 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -9,6 +9,8 @@
>  . ./common/preamble
>  _begin_fstest auto quick rw atomicwrites
>  
> +. ./common/atomicwrites
> +
>  _require_scratch_write_atomic
>  _require_xfs_io_command pwrite -A
>  
> @@ -87,56 +89,7 @@ test_atomic_writes()
>      test $file_max_segments -eq 1 || \
>          echo "atomic write max segments $file_max_segments, should be 1"
>  
> -    # Check that we can perform an atomic write of len = FS block size
> -    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> -        grep wrote | awk -F'[/ ]' '{print $2}')
> -    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> -
> -    # Check that we can perform an atomic single-block cow write
> -    if [ "$FSTYP" == "xfs" ]; then
> -        testfile_cp=$SCRATCH_MNT/testfile_copy
> -        if _xfs_has_feature $SCRATCH_MNT reflink; then
> -            cp --reflink $testfile $testfile_cp
> -        fi
> -        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
> -            grep wrote | awk -F'[/ ]' '{print $2}')
> -        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> -    fi
> -
> -    # Check that we can perform an atomic write on an unwritten block
> -    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> -    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
> -        grep wrote | awk -F'[/ ]' '{print $2}')
> -    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> -
> -    # Check that we can perform an atomic write on a sparse hole
> -    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> -    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> -        grep wrote | awk -F'[/ ]' '{print $2}')
> -    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> -
> -    # Check that we can perform an atomic write on a fully mapped block
> -    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> -        grep wrote | awk -F'[/ ]' '{print $2}')
> -    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
> -
> -    # Reject atomic write if len is out of bounds
> -    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> -        echo "atomic write len=$((bsize - 1)) should fail"
> -    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> -        echo "atomic write len=$((bsize + 1)) should fail"
> -
> -    # Reject atomic write when iovecs > 1
> -    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> -        echo "atomic write only supports iovec count of 1"
> -
> -    # Reject atomic write when not using direct I/O
> -    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> -        echo "atomic write requires direct I/O"
> -
> -    # Reject atomic write when offset % bsize != 0
> -    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> -        echo "atomic write requires offset to be aligned to bsize"
> +    _test_atomic_file_writes "$bsize" "$testfile"

I see this must be done since in later patches we are adding an atomic
write test using scsi debug.

Sure make sense in that case. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh

>  
>      _scratch_unmount
>  }
> -- 
> 2.34.1
