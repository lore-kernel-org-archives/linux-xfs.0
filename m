Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED2C1D554;
	Fri, 28 Feb 2025 13:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740748584; cv=none; b=t2rzuhi/8f582K5J+BMHyvODphxuEiUkSLnSZjSJ09ZeNS+yr96zRv+kk/WDjCfXDF5aQmCB8bxYjwvl4UQS5NTg+NWrF4lyG1c2Z74OdCSNsQwMNuHYg+/7RmGiUY9umycfZQDSqIeXkCP8TLyJT0WG6yPCtLoDjbZVmfxhY+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740748584; c=relaxed/simple;
	bh=4i2Enmfdxl/iuTeRuIy8JQrSEU4K5dHGGNAv2O67eyk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=M1MuaqU7XxgkKqOidGxv6ACHWt2Q67pk8GtDC+rhzIyLjL2/V2wdMnZnTsh6Fk9zaveAIsuY9FWzP+fKuFv2lu1QH58p0Z4XhOmzvWwPWwArCkcNMCYs9sPbtb2C0BR0q8mcypA/mkdSU69rKJONtd/50qCm7yL48Etp4KSmCrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PK0jNySu; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PK0jNySu"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22104c4de96so34329975ad.3;
        Fri, 28 Feb 2025 05:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740748582; x=1741353382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sgGHp+BfpkFRg0w6KEa4o1o7jW/d3fMWe4hZH676I/g=;
        b=PK0jNySu/0mH1SyficSgv0t+cyCBMMY0qaWwFFkjszJAjsnaBEgDI6HISy3qEpf/e5
         tJheio0bU+bsObjhBVJHNl1apGt28cBN3GbafDLaYptu0ctAMKZnQL3Rq1gx1d6pS9nM
         Z17P+cXPOmZPlXPpD1sYv5Xt0aQUX8daKlZ9cy2oytSHkNlB1ImrBRpUog/6r2+VKpz9
         c5EowQoy7UYdjqwjVxwChlZMGYTWllxJu50sVPCL6Q/IMhqILcbilqj3/UvZn5pnmamj
         jPx6elwz+j5l2zn4EFPxFxlmFhh9P/MtzVmYu6fR2wUFto3ZCiHdKAiNyxZVBUqBL6Po
         4P4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740748582; x=1741353382;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sgGHp+BfpkFRg0w6KEa4o1o7jW/d3fMWe4hZH676I/g=;
        b=RgLh1ASPXOk8T/YLASbmn7qmYnhVyj9nwFjpshhfndjirgdFWX8phHnU1bkuS5yo4U
         6v5U/rHpIuxcrSPWv/0KD/3173hftFrl61KLnitkO6fw5Vx+1OCJ7QLHaz8jJHk6SsYY
         3R2ofLkCAe/nxYq79rpmMPUWftOSFNGUctSUxrdP3Arg4eAfVBzAfqWw5AQk70j8/nBi
         VrwfKi+sTXUIK3dGAkRnJLSxV2K75ccYA0fNQ4rQptjXQqW+H9r9r39MpxYZSe27D6Vn
         6cpMDo+KbKw0xYY0cPaJ/6pwJvLDPnmKruGEAFxNXPG74hL0ZKdo1vEb+VIACIfwI4pw
         4y6g==
X-Forwarded-Encrypted: i=1; AJvYcCXAKfD/I+SfeuL7RIEsLn+sfcOM7HTrXBgHA0dciSCNt3a/CGZfnLGbGC1xAR+IQcXOAZJaLnodBXRR@vger.kernel.org, AJvYcCXq7cPl1QnLcdHRbTuJqztt+AXpZCEnejjfWgM+M+1JJnedWaFSVH3FCfblaTGlT9b9c6zLjscv@vger.kernel.org
X-Gm-Message-State: AOJu0YwA6hcXOREXanmqWrR22Bk6Nmuqbm+FSbjRZhCq/pqxmTE1UkcN
	DXDFsTrNXD+ZeDjjP1VigYY7GCjHiqcifbUWQAYQCrKfbjp+x1jBRUtbkA==
X-Gm-Gg: ASbGncu3dAr0fDH4r8QWOUnyomUbW1zszXcwAgExoVkBuCw9h+AlqKhoOUwP3P40Os5
	34VGVHjsGk5zCtfMJdFFA607Fco4X2y/XuKwKVLiR+6pF36YlE8RvCjWdylLO9ccGfExy6ojwSt
	UsAPB1C4xbU6FGo+EzoFqSxuHJlgUcJ/aiJDC3pRlCvgbqOgAmkVfVrsb5ddINQGNtpkYGjusZ1
	vFu+UrVQ5TqRIX8Vrrffoe5vke4xmxQ0sb/LiNiEU95Akp8fhmlTEnvRhoUqzduqaSuDNCbNfxC
	iQRRN8NUEuk9z0jKqcehlS+aq8aqxqiuLNyUVlMqJZRIYXe1NRNutUHLdFdbvlF4W3xc47qpUmX
	ZXsCZuZYTHC4=
X-Google-Smtp-Source: AGHT+IFd7iT2Fk6mU+jnTl8A1bBDRTuRHvBbaGRjq99pv4Si06VUXlML1FQAtmU1JkWmdr4EyDpDqQ==
X-Received: by 2002:a05:6a00:4b4a:b0:734:9cc:a6db with SMTP id d2e1a72fcca58-734ac428906mr5859592b3a.21.1740748581792;
        Fri, 28 Feb 2025 05:16:21 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([2405:201:8010:506f:f5a4:e2f0:7213:65bd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a0024d2asm3747838b3a.106.2025.02.28.05.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 05:16:21 -0800 (PST)
Message-ID: <8c3ee5dc9ace37d4bd7ab53d22d258d8375245cb.camel@gmail.com>
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
  fstests@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 28 Feb 2025 18:46:16 +0530
In-Reply-To: <20250228002059.16750-1-catherine.hoang@oracle.com>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2025-02-27 at 16:20 -0800, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
>  common/rc             |  51 ++++++++++++++
>  tests/generic/762     | 160
> ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/762.out |   2 +
>  3 files changed, 213 insertions(+)
>  create mode 100755 tests/generic/762
Is this rebased to the latest for-next? This file already exists -
maybe try using ./tools/mvtest  --help to fix this?
--NR
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
>  		        "pwrite $pwrite_opts $param 0 4k" $testfile
> 2>&1`
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
> +		_notrun "write atomic not supported by this block
> device"
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
> +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> +
> +    # Check that atomic min/max = FS block size
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write min $file_min_write, should be fs block
> size $bsize"
> +    test $file_min_write -eq $bsize || \
> +        echo "atomic write max $file_max_write, should be fs block
> size $bsize"
> +    test $file_max_segments -eq 1 || \
> +        echo "atomic write max segments $file_max_segments, should
> be 1"
> +
> +    # Check that we can perform an atomic write of len = FS block
> size
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize
> failed"
> +
> +    # Check that we can perform an atomic single-block cow write
> +    if [ "$FSTYP" == "xfs" ]; then
> +        testfile_cp=$SCRATCH_MNT/testfile_copy
> +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> +            cp --reflink $testfile $testfile_cp
> +        fi
> +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize
> 0 $bsize" $testfile_cp | \
> +            grep wrote | awk -F'[/ ]' '{print $2}')
> +        test $bytes_written -eq $bsize || echo "atomic write on
> reflinked file failed"
> +    fi
> +
> +    # Check that we can perform an atomic write on an unwritten
> block
> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize
> $bsize $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to
> unwritten block failed"
> +
> +    # Check that we can perform an atomic write on a sparse hole
> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to sparse
> hole failed"
> +
> +    # Check that we can perform an atomic write on a fully mapped
> block
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> $bsize" $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to mapped
> block failed"
> +
> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))"
> $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize - 1)) should fail"
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))"
> $testfile 2>> $seqres.full && \
> +        echo "atomic write len=$((bsize + 1)) should fail"
> +
> +    # Reject atomic write when iovecs > 1
> +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile
> 2>> $seqres.full && \
> +        echo "atomic write only supports iovec count of 1"
> +
> +    # Reject atomic write when not using direct I/O
> +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>>
> $seqres.full && \
> +        echo "atomic write requires direct I/O"
> +
> +    # Reject atomic write when offset % bsize != 0
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile
> 2>> $seqres.full && \
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
> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile
> 2>> $seqres.full && \
> +        echo "atomic write should fail when bsize is out of bounds"
> +
> +    _scratch_unmount
> +}
> +
> +sys_min_write=$(cat "/sys/block/$(_short_dev
> $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> +sys_max_write=$(cat "/sys/block/$(_short_dev
> $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
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
> +# Check that atomic write fails if bsize < bdev min or bsize > bdev
> max
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

