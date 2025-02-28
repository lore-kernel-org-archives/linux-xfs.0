Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8536D42A87;
	Fri, 28 Feb 2025 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740758660; cv=none; b=j8sGQfi0BuLj8zvIclfNg+JN4J+nLTqZlgBNendTMFX1bmtaT3KQyvnIxmP9NyeQU653BJHXV7hIDzLLYQvu50C3owZ6jEhNm3n9au0xxel1kFjwSrHH0OL+YX64F530azr9+hVJNAyshzZG4Zma9xtsCOiMqFD70TY8dEYKA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740758660; c=relaxed/simple;
	bh=AB/znJt0dwUsKwPPz4e9SNFmiZp8C10kBHQoi5Ft0CA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h0uB0VKkJAgNHRAaNJ4rgjgk1JOi3HACG6WkAmeY4eNehisQUmZIQYOia+2Q90yFvQ/LZiqqL+nFslx5syzNW6lCQ9nw2KpJqU53vWVO3pSJnEelGGlNv5Qm0H0xsLI762PYOFBRSRIhWOG4IPi7zjuLtH93QtKdVgot+OUHMXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l4zLyDpG; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4zLyDpG"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fa8ac56891so3903777a91.2;
        Fri, 28 Feb 2025 08:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740758657; x=1741363457; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FQd04NeIvCzCy5hC/K0wPLy+oMMXUgcVWwCoDREl3Vc=;
        b=l4zLyDpG8RtwIaYN1tYF39ZgeV2fzk/4JYLzBckagLWMf55dqunL5oxhbkIppkbtDC
         i6OASOpyzwET2jDeFuiXXtnH6KpYE+a/W31DS8u7dGOxQIT5FuG75SW2ya62ZL49FmEB
         KhSVhMOXA4nsT64a6xN2LUCyPxbb/VX3t1rRvmddCsyiyfj4oM4Pwj3MyzZ29hOFcn+a
         8pkK/lKBSaVEWr/NuRexnT7UKxlnj8ONe+Zk1FvEdW32QuFZyfh4esISLqJm2WzAznMt
         xW6v5IOiiSyag/yYiVCRbzEBGbJHUkqpHXULC1nX2TD1EdeGJLrW/WabOREB0LbYTxIP
         f4Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740758657; x=1741363457;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQd04NeIvCzCy5hC/K0wPLy+oMMXUgcVWwCoDREl3Vc=;
        b=R51g6M+tc79qDmur8zP7G8uimm5PMPS6gpwGM79gxrjtJfco/bmkaSRi10ICknTLY6
         ZWip/2dGCA/kOuEs2TJhQl62AYL0+0+KViAJaWco+j2s47J+K7o8Wl3A8qqBIU2964+E
         ARehe1lMtzxhzhgcwuqn+F1P2rKDcNj1iUco9pt5BPtImHzU4cd+Xl8ZW0rdtksyqaSv
         cqBnzBiSn1mP8+9GeG8vcW98eCJMJ91FLQI1SghIth8s5lrX64jEEBWqIwFppGBRh0EJ
         uurWaSwNgWRogOQNMvjiAU/VYnTSTS8a6fbeczhppzooIuqPCJ0OyBb6DTFDafb5rHKC
         qJ9g==
X-Forwarded-Encrypted: i=1; AJvYcCU2qHv8r6U9l1wNZ67aN8ng5Cg4idTOaleALYEQbnr1nLV5gWqEFtboK+BIgIzf/V7bOGMPkD7OUOaq@vger.kernel.org, AJvYcCXcbiP3e8NmgIv47dW7Q/XqUdFEPklVKfrtqTocqNbbrsgJynkSfBFzEFpOVmScbVJf+vv7bKlR@vger.kernel.org
X-Gm-Message-State: AOJu0YyPqi4qVLJHuIuyk3pjxilKQgJqHND+Vl8LaeFuPnezi3AE5lC6
	hix11vHf+8QpU3wVP9HDdvCyVUpB1RGoYHoBK4J1EVTyJBrmC308
X-Gm-Gg: ASbGncuiaMl8jHegQ3xV0c6batob4jiK7jBT9bE/tfBJeb2jh8iSOfcxAaULHRBrNSl
	7mpDIwlNg52eA3LvVS6nDAnBFcfsMIEH3HYfqdx4AQUwyXP4jx17F2zV96b0hGmKP7gZBBZRY2G
	JNBTnAbDzX1PmVQJGIIMEEUikvXCvP7sCgEP9SbGo2LELEfO+Onqd3b+DFPydtgiDisWNNmoGcs
	jhZAoxoz6vSWpBSjiLDOZQ+KNnbT0LnksumjtaXIKq7DHvjxJXRJ4TcddRv1YLAgE9B0gdxR1f8
	PFdBWrIsiuhp0dU4mOTZ7VsIB0zxfZNmNzvtGdyKIbhksuYv4VeuAMy4ALAtCEvTk/XL8rTXqFl
	Oq/gSCKyU
X-Google-Smtp-Source: AGHT+IHKjUWwb6f8j3AC7bV8v5vhl8irGVP+GkFcboTayQduppzRJgnDKVa1Ho/suuLpEV+jbkkZ7Q==
X-Received: by 2002:a17:90b:4c86:b0:2f4:423a:8fb2 with SMTP id 98e67ed59e1d1-2febab71370mr6431926a91.20.1740758656573;
        Fri, 28 Feb 2025 08:04:16 -0800 (PST)
Received: from ?IPV6:2405:201:8010:506f:f5a4:e2f0:7213:65bd? ([2405:201:8010:506f:f5a4:e2f0:7213:65bd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fe82840e57sm6060943a91.30.2025.02.28.08.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 08:04:15 -0800 (PST)
Message-ID: <1f2c0bcf-a2d2-459e-be8a-c0170fabc5fc@gmail.com>
Date: Fri, 28 Feb 2025 21:34:11 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
 fstests@vger.kernel.org
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
 <20250228021156.GX6242@frogsfrogsfrogs>
 <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>
 <20250228154335.GZ6242@frogsfrogsfrogs>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20250228154335.GZ6242@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/28/25 21:13, Darrick J. Wong wrote:
> On Fri, Feb 28, 2025 at 07:01:50PM +0530, Nirjhar Roy (IBM) wrote:
>> On Thu, 2025-02-27 at 18:11 -0800, Darrick J. Wong wrote:
>>> On Thu, Feb 27, 2025 at 04:20:59PM -0800, Catherine Hoang wrote:
>>>> Add a test to validate the new atomic writes feature.
>>>>
>>>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>>>> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>>> Er.... what git tree is this based upon?  generic/762 is a project
>>> quota
>>> test.
>> On which branch do you have tests/generic/762? I checked the latest
>> master(commit - 8467552f09e1672a02712653b532a84bd46ea10e) and the for-
>> next(commit - 5b56a2d888191bfc7131b096e611eab1881d8422) and it doesn't
>> seem to exist there. However, tests/xfs/762 does exist.
> Zorro's patches-in-queue, aka whatever gets pushed to for-next on
> Sunday.  My confusion stems from this patch modifying what looks like an
> existing atomic writes test, but generic/762 isn't that test so now I
> can't see everything that this test is examining.
>
> (I suggest everyone please post urls to public git repos so reviewers
> can get around these sorts of issues in the future.)

Noted. Thank you.

--NR

>
> --D
>
>> --NR
>>> --D
>>>
>>>> ---
>>>>   common/rc             |  51 ++++++++++++++
>>>>   tests/generic/762     | 160
>>>> ++++++++++++++++++++++++++++++++++++++++++
>>>>   tests/generic/762.out |   2 +
>>>>   3 files changed, 213 insertions(+)
>>>>   create mode 100755 tests/generic/762
>>>>   create mode 100644 tests/generic/762.out
>>>>
>>>> diff --git a/common/rc b/common/rc
>>>> index 6592c835..08a9d9b8 100644
>>>> --- a/common/rc
>>>> +++ b/common/rc
>>>> @@ -2837,6 +2837,10 @@ _require_xfs_io_command()
>>>>   			opts+=" -d"
>>>>   			pwrite_opts+="-V 1 -b 4k"
>>>>   		fi
>>>> +		if [ "$param" == "-A" ]; then
>>>> +			opts+=" -d"
>>>> +			pwrite_opts+="-D -V 1 -b 4k"
>>>> +		fi
>>>>   		testio=`$XFS_IO_PROG -f $opts -c \
>>>>   		        "pwrite $pwrite_opts $param 0 4k" $testfile
>>>> 2>&1`
>>>>   		param_checked="$pwrite_opts $param"
>>>> @@ -5175,6 +5179,53 @@ _require_scratch_btime()
>>>>   	_scratch_unmount
>>>>   }
>>>>   
>>>> +_get_atomic_write_unit_min()
>>>> +{
>>>> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
>>>> +        grep atomic_write_unit_min | grep -o '[0-9]\+'
>>>> +}
>>>> +
>>>> +_get_atomic_write_unit_max()
>>>> +{
>>>> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
>>>> +        grep atomic_write_unit_max | grep -o '[0-9]\+'
>>>> +}
>>>> +
>>>> +_get_atomic_write_segments_max()
>>>> +{
>>>> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
>>>> +        grep atomic_write_segments_max | grep -o '[0-9]\+'
>>>> +}
>>>> +
>>>> +_require_scratch_write_atomic()
>>>> +{
>>>> +	_require_scratch
>>>> +
>>>> +	export STATX_WRITE_ATOMIC=0x10000
>>>> +
>>>> +	awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>>>> +	awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>>>> +
>>>> +	if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
>>>> +		_notrun "write atomic not supported by this block
>>>> device"
>>>> +	fi
>>>> +
>>>> +	_scratch_mkfs > /dev/null 2>&1
>>>> +	_scratch_mount
>>>> +
>>>> +	testfile=$SCRATCH_MNT/testfile
>>>> +	touch $testfile
>>>> +
>>>> +	awu_min_fs=$(_get_atomic_write_unit_min $testfile)
>>>> +	awu_max_fs=$(_get_atomic_write_unit_max $testfile)
>>>> +
>>>> +	_scratch_unmount
>>>> +
>>>> +	if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
>>>> +		_notrun "write atomic not supported by this filesystem"
>>>> +	fi
>>>> +}
>>>> +
>>>>   _require_inode_limits()
>>>>   {
>>>>   	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
>>>> diff --git a/tests/generic/762 b/tests/generic/762
>>>> new file mode 100755
>>>> index 00000000..d0a80219
>>>> --- /dev/null
>>>> +++ b/tests/generic/762
>>>> @@ -0,0 +1,160 @@
>>>> +#! /bin/bash
>>>> +# SPDX-License-Identifier: GPL-2.0
>>>> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
>>>> +#
>>>> +# FS QA Test 762
>>>> +#
>>>> +# Validate atomic write support
>>>> +#
>>>> +. ./common/preamble
>>>> +_begin_fstest auto quick rw
>>>> +
>>>> +_require_scratch_write_atomic
>>>> +_require_xfs_io_command pwrite -A
>>>> +
>>>> +test_atomic_writes()
>>>> +{
>>>> +    local bsize=$1
>>>> +
>>>> +    case "$FSTYP" in
>>>> +    "xfs")
>>>> +        mkfs_opts="-b size=$bsize"
>>>> +        ;;
>>>> +    "ext4")
>>>> +        mkfs_opts="-b $bsize"
>>>> +        ;;
>>>> +    *)
>>>> +        ;;
>>>> +    esac
>>>> +
>>>> +    # If block size is not supported, skip this test
>>>> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
>>>> +    _try_scratch_mount >>$seqres.full 2>&1 || return
>>>> +
>>>> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
>>>> +
>>>> +    testfile=$SCRATCH_MNT/testfile
>>>> +    touch $testfile
>>>> +
>>>> +    file_min_write=$(_get_atomic_write_unit_min $testfile)
>>>> +    file_max_write=$(_get_atomic_write_unit_max $testfile)
>>>> +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
>>>> +
>>>> +    # Check that atomic min/max = FS block size
>>>> +    test $file_min_write -eq $bsize || \
>>>> +        echo "atomic write min $file_min_write, should be fs block
>>>> size $bsize"
>>>> +    test $file_min_write -eq $bsize || \
>>>> +        echo "atomic write max $file_max_write, should be fs block
>>>> size $bsize"
>>>> +    test $file_max_segments -eq 1 || \
>>>> +        echo "atomic write max segments $file_max_segments, should
>>>> be 1"
>>>> +
>>>> +    # Check that we can perform an atomic write of len = FS block
>>>> size
>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
>>>> $bsize" $testfile | \
>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>> +    test $bytes_written -eq $bsize || echo "atomic write
>>>> len=$bsize failed"
>>>> +
>>>> +    # Check that we can perform an atomic single-block cow write
>>>> +    if [ "$FSTYP" == "xfs" ]; then
>>>> +        testfile_cp=$SCRATCH_MNT/testfile_copy
>>>> +        if _xfs_has_feature $SCRATCH_MNT reflink; then
>>>> +            cp --reflink $testfile $testfile_cp
>>>> +        fi
>>>> +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b
>>>> $bsize 0 $bsize" $testfile_cp | \
>>>> +            grep wrote | awk -F'[/ ]' '{print $2}')
>>>> +        test $bytes_written -eq $bsize || echo "atomic write on
>>>> reflinked file failed"
>>>> +    fi
>>>> +
>>>> +    # Check that we can perform an atomic write on an unwritten
>>>> block
>>>> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize
>>>> $bsize $bsize" $testfile | \
>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>> +    test $bytes_written -eq $bsize || echo "atomic write to
>>>> unwritten block failed"
>>>> +
>>>> +    # Check that we can perform an atomic write on a sparse hole
>>>> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
>>>> $bsize" $testfile | \
>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>> +    test $bytes_written -eq $bsize || echo "atomic write to sparse
>>>> hole failed"
>>>> +
>>>> +    # Check that we can perform an atomic write on a fully mapped
>>>> block
>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
>>>> $bsize" $testfile | \
>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>> +    test $bytes_written -eq $bsize || echo "atomic write to mapped
>>>> block failed"
>>>> +
>>>> +    # Reject atomic write if len is out of bounds
>>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))"
>>>> $testfile 2>> $seqres.full && \
>>>> +        echo "atomic write len=$((bsize - 1)) should fail"
>>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))"
>>>> $testfile 2>> $seqres.full && \
>>>> +        echo "atomic write len=$((bsize + 1)) should fail"
>>>> +
>>>> +    # Reject atomic write when iovecs > 1
>>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize"
>>>> $testfile 2>> $seqres.full && \
>>>> +        echo "atomic write only supports iovec count of 1"
>>>> +
>>>> +    # Reject atomic write when not using direct I/O
>>>> +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile
>>>> 2>> $seqres.full && \
>>>> +        echo "atomic write requires direct I/O"
>>>> +
>>>> +    # Reject atomic write when offset % bsize != 0
>>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize"
>>>> $testfile 2>> $seqres.full && \
>>>> +        echo "atomic write requires offset to be aligned to bsize"
>>>> +
>>>> +    _scratch_unmount
>>>> +}
>>>> +
>>>> +test_atomic_write_bounds()
>>>> +{
>>>> +    local bsize=$1
>>>> +
>>>> +    case "$FSTYP" in
>>>> +    "xfs")
>>>> +        mkfs_opts="-b size=$bsize"
>>>> +        ;;
>>>> +    "ext4")
>>>> +        mkfs_opts="-b $bsize"
>>>> +        ;;
>>>> +    *)
>>>> +        ;;
>>>> +    esac
>>>> +
>>>> +    # If block size is not supported, skip this test
>>>> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
>>>> +    _try_scratch_mount >>$seqres.full 2>&1 || return
>>>> +
>>>> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
>>>> +
>>>> +    testfile=$SCRATCH_MNT/testfile
>>>> +    touch $testfile
>>>> +
>>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize"
>>>> $testfile 2>> $seqres.full && \
>>>> +        echo "atomic write should fail when bsize is out of
>>>> bounds"
>>>> +
>>>> +    _scratch_unmount
>>>> +}
>>>> +
>>>> +sys_min_write=$(cat "/sys/block/$(_short_dev
>>>> $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
>>>> +sys_max_write=$(cat "/sys/block/$(_short_dev
>>>> $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
>>>> +
>>>> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
>>>> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
>>>> +
>>>> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
>>>> +    echo "bdev min write != sys min write"
>>>> +fi
>>>> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
>>>> +    echo "bdev max write != sys max write"
>>>> +fi
>>>> +
>>>> +# Test all supported block sizes between bdev min and max
>>>> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
>>>> +        test_atomic_writes $bsize
>>>> +done;
>>>> +
>>>> +# Check that atomic write fails if bsize < bdev min or bsize >
>>>> bdev max
>>>> +test_atomic_write_bounds $((bdev_min_write / 2))
>>>> +test_atomic_write_bounds $((bdev_max_write * 2))
>>>> +
>>>> +# success, all done
>>>> +echo Silence is golden
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/generic/762.out b/tests/generic/762.out
>>>> new file mode 100644
>>>> index 00000000..fbaeb297
>>>> --- /dev/null
>>>> +++ b/tests/generic/762.out
>>>> @@ -0,0 +1,2 @@
>>>> +QA output created by 762
>>>> +Silence is golden
>>>> -- 
>>>> 2.34.1
>>>>
>>>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

