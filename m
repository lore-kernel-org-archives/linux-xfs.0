Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF11E26D5A2;
	Fri, 28 Feb 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740749402; cv=none; b=jxPMmolP2aKicLptWzkqhh46gXG6MMti12gMCqmmEcaykiNVWiuiYwH/FHjPeIF+atUS/b3m+nuA3rIa62UMPYhBEm8HUkpD7bO325m0bUxJ6OwCJTns/kcWnKpOdtQjyTzFUFs3PjsGBrSfp/2JPQxhtrztjn9SOIFggKPaAno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740749402; c=relaxed/simple;
	bh=7llgX2O0EprU2/HNA+vUzcv0NtLxvj3MfLCVC1VKsSU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=aeXCivn14fPLgD21XaUnlrbfcamtAYYljaLQEZNcyDCWScvpJD7xLwuua6XZgFW2gwksr00jdkZ9RJMorI+tlWdzvkauTHS0yTDp5VlsF9uCnK3KrpnPR3hphcDms0xL0k+6z8epZ3VAI0pyhOnzblkENlb6kwfSL1hwtIhfog0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DqRCUauZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqRCUauZ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2210d92292eso865155ad.1;
        Fri, 28 Feb 2025 05:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740749400; x=1741354200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z0Cf95R2SYVfLZQtvNiFTGPjF+Q8rvZHfbhj0BTuGF0=;
        b=DqRCUauZCGQbmCWw8jpigj0ZJZg2C5GFqAtTZn8VRrC2gc2KpCG19K6coODJU62bEt
         PuqbeattM6h6l9XBzKAcuIXSauTo5LalzBRRCmSSg9wytrdGtqmyWKk33mrhY4yXv2rF
         lfPRBMnPplpsRMwcL773avGDqQPi/SPEVSkhSlkPcwQrR3hVvYwJzjrGTtjlS7+qETZW
         GDQ4H7mG0mwndM2DbG5tre2sAtVXKTXImSOOayDd0p5WQhML659DvPf7seV24GJZZ1YM
         ZXoZpmfwKp63YbYDyu5vM3+uZijGscSf8TlJL+Urzpnjqhufa86RL5lGxftcjGIG3HKa
         vDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740749400; x=1741354200;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z0Cf95R2SYVfLZQtvNiFTGPjF+Q8rvZHfbhj0BTuGF0=;
        b=iXce8TDpwkibGHH8DPyJoTzqSAokdcvzy+gar1k1lzvFWAuFZbO1Exf2smkL9R9TP0
         n8GlqPF7EeCwns7uWD5a7fK13DBahHxibBzxHyKNYU5znvKPKFFOdIvTTL7epYdGwTUx
         YLmxO0UsbMuk8mRC057LZNol0x/k5T2UMgMsv3h3CKEJOdlvKkV2dW2nFohSBcIHUrCf
         p11ANAkwcS8AsLppAG9s14XwIZuddA4m3abB8MPyYLs658cDfVogbUOoEe9TRgkfTxfA
         Gwv99i/89b2wJQ3p31M6EmIhAZM0ODFiv9kgl6guFwZwCLX/6GNU0y02TXRvNNiWK1xA
         QxhA==
X-Forwarded-Encrypted: i=1; AJvYcCX2eOkK2MHj5wYyFF1eFynKwik0jZd/kcvxut9C+1+8lLqRdAJtuvXeO1peOoR9eYGTH8p+sMsZ0rPM@vger.kernel.org, AJvYcCXf1VAuqgdhWvilHl7TkichjlINxQekmjdfX7KIGHO0xM4dUU3y2lwlyTwV+BSVEZGTwbmy7Y9Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyU6JQXn9MzD3GUHKlkrjDWDhbilXSrhWx6aoUNssu5FB1Vus+D
	7Bg9A9uIqkZM/X6Ikuj7XvlyM9WZLm+sYOYM5MfPyq8Tk+gd/2HFrK5IIQ==
X-Gm-Gg: ASbGnctEEUM6OxYlBN1VgJ8CoGT1gAyHQSA1zNltY6QpuBzp/3PeuWD30GrEKR/QTaT
	F4iDvApMNdXQ+3V6ZbLc0//rsV/hinrQl+4ajU7Lz/WYbhpyz2eLUg6l8ICLfNcUiUKX/pWjGj9
	akYmsuldNo3BQMbd07lh9u+8UmO/llsv7eS3S+nF0FGuxHZlkhqgj2pLf35w1oZtBD+rvGKo9WU
	vlTEn3sqr8gZBI9AscOEFb8sp2ZgqjnBCISrrtBglgmj5iYqzsU4VMzzxczgT6ao5KCf0T60Ka1
	wLap2TC9s+l7/cdLrTPSjyveCMQ9py3vqNgF1MZohLiRyf0WtBtyx2PvEVM9C7XmIpm6EMP2q1p
	WsxrxaPDS7AI=
X-Google-Smtp-Source: AGHT+IGdVUZ0c9oTfBpWo+a8r2ZvH9LM7Bo6vZvlKVGfMqDNVdiBj/oR8h8MZ/QKnxww2m3PmgqggQ==
X-Received: by 2002:a05:6a21:2d85:b0:1ee:64c4:89bb with SMTP id adf61e73a8af0-1f2f4e4de61mr5806907637.42.1740749400132;
        Fri, 28 Feb 2025 05:30:00 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([2405:201:8010:506f:f5a4:e2f0:7213:65bd])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-aee7de39b58sm2941181a12.44.2025.02.28.05.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 05:29:59 -0800 (PST)
Message-ID: <5ed7c35daeda0dd754bd675d19a96f468c56078d.camel@gmail.com>
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
  fstests@vger.kernel.org
Date: Fri, 28 Feb 2025 18:59:56 +0530
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
Sorry, Please ignore my previous email about moving the test -
generic/762 doesn't exist. I mistakenly checked for tests/xfs/762. I
checked the latest master(commit -
8467552f09e1672a02712653b532a84bd46ea10e) and for-next(commit -
5b56a2d888191bfc7131b096e611eab1881d8422) and it doesn't seem to exist.
 Sorry for the confusion. 

--NR
> ++++++++++++++++++++++++++++++++++++++++++
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

