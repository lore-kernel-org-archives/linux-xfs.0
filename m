Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3D126ACC;
	Fri, 28 Feb 2025 13:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740749517; cv=none; b=Yk23JJMfA86xxOOCc1IbKPD6FSxB+m6HD6Pl8q1A34JCrWhXap3Rd1dkthf639Oo/TTb7RMvU5JuAM4oe4HTptXJyhPLZb4sT0j2xKe3Z4Ep6vZy3z3CbuVZV6CEGUbOZNHql/Ta5rTGPNiDYKzRJAnnPtRy4r5twxeVu5u6/NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740749517; c=relaxed/simple;
	bh=UORzGchQY6VIxlvnOcDzJQjCorBbeFWShu0cORXtfO4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=Kg2ImOd99XApzfimN6itSAnGMMzBssn/tzUnBIbCvlMpaX6kQ862hYmo0Ju/ZoTApubjmS2KFTOrdmfxAa/DA+HpXaLKmQitCoflmefQ2Fskddbx0E+pVuUKjOKSGDTP3JaZjS1dsD5smwOsZl6NYZkW8e88ORUHm90b/IBpGkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfTAIkIy; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfTAIkIy"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2235908a30aso1027755ad.3;
        Fri, 28 Feb 2025 05:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740749514; x=1741354314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dvfi3+nuYVlhPa06CfB7QM/5rvdePU+Kd64YnvdInsg=;
        b=GfTAIkIy5A/8CkZG4+SA2tjdr0aumvXxhtH4IAplwdbfp+HJh9UVERQI1lgiCYFlrL
         PBO52MNH3YHZ4imwy6ESlzWr0D2skVKICfwsSfFFhD0ndRWBN6MR9zMeN1cIZWtfXRse
         1q3bwhhdjYD9PBcgXKa7jXbSMouqvuIvDwyCTMv6hR1cJaKX/z7/0i7U7ZUIRWnWwWNi
         3mAvZY+0vogwMWovegB4LwO7aC5emsBIUy0mTMyTY8QlHh8G+ZR9fNpZ/sF7tVPp97SU
         acoTa2VhOdLAyaSQZCC/I7SwWV1lsW29oonbqWqHtrMTfWjWhszcWYk1S1x80nRUPinR
         NPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740749514; x=1741354314;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dvfi3+nuYVlhPa06CfB7QM/5rvdePU+Kd64YnvdInsg=;
        b=DK5dGOG/yjc43EcS5CnXjLjbZFc+S2b+o+ftqFNBOQZN5ASDK+gJX4Xhdu3fX9ue2y
         mGWEva9S7VOEAv5Qk5Q9Bcuog6EvpUqC/rn6W2cEBTntAa62ShD41h9xblW/QW0eHxM8
         t7asf1x/p51KxZIKM2/aEC7vHOEEj4QQrm4ER6zE6PxYcU3uKWQzBFah4ERLrJC5fKhb
         PhxiuHuhOCoGt+/Qdy92JX/Jag1EXmaygxA25LSRqOuye4jsfahgaUfxYr8hoW5jjjSN
         +a7fxDr+PO71sJcRg6hWDm5gOewL4Z16Q5OUP90vycVRlbV2sKlvQOLTc9iowBTQPrf0
         OviQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmUo1q4eNjleZTvst06Lj37gyd7gPHe3JbzHU+UkqbsNylpDYyn3bC5LyTjVaCn5rpYoQDzwDy@vger.kernel.org
X-Gm-Message-State: AOJu0YwrvrF2ha9tStxn9G3dY1Rv+qZ9fTW8Vm9Qfo+AgxREo4GWDvFc
	DH3HoYP4vVPlilJ2OO258/wkHsT2FC7axF7VCWAf/QAiSkVYFknAzcbI0Q==
X-Gm-Gg: ASbGncth30dnJF8Fy0Csf6IG0gBa6FJSOCw7JM/twANR6+WeLouOv9IKAx5uP72/87r
	7++o3c6uwo70lYlx6Zz2xpyOk0wVn/WGeKrwgOsRkeDXzrxTPCpuqi/BZ2lD7EHvKeINDnt43Ew
	NPq5qER+Ip/ndB01ZQKNYCS72mj+Zh3ZXEOibL3a61Ij4BRcwM1xlib5gJ+GTTXTKv5oXQ3WldU
	Jd7McAjWWb/OC81sU35L1VRt3E6ST1JvO+RU6Qcoj72OggD6wNd+ADlGjQ/5kgfmYLKHmyXYBsA
	Ja7kRTO9JCwVJoQhDGwd3Ufc9mbTyzqtxXKqVAepHORzH9oJVLHwmKtWp6+O9qLMjdM9UKJAFRQ
	JsN2S7iH7L7I=
X-Google-Smtp-Source: AGHT+IFUNeeu1oNhRuXty/PeHB1a2wzE1smsCN13mTrvbqUHF9loZmNemnhqBoUXhgn6zB0V4M2uAg==
X-Received: by 2002:a17:902:f54e:b0:223:58ea:6fdf with SMTP id d9443c01a7336-22368fa5939mr55530885ad.28.1740749514457;
        Fri, 28 Feb 2025 05:31:54 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([2405:201:8010:506f:f5a4:e2f0:7213:65bd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501f97cesm32784815ad.60.2025.02.28.05.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 05:31:54 -0800 (PST)
Message-ID: <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Catherine Hoang
	 <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date: Fri, 28 Feb 2025 19:01:50 +0530
In-Reply-To: <20250228021156.GX6242@frogsfrogsfrogs>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
	 <20250228021156.GX6242@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2025-02-27 at 18:11 -0800, Darrick J. Wong wrote:
> On Thu, Feb 27, 2025 at 04:20:59PM -0800, Catherine Hoang wrote:
> > Add a test to validate the new atomic writes feature.
> > 
> > Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> > Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> 
> Er.... what git tree is this based upon?  generic/762 is a project
> quota
> test.
On which branch do you have tests/generic/762? I checked the latest
master(commit - 8467552f09e1672a02712653b532a84bd46ea10e) and the for-
next(commit - 5b56a2d888191bfc7131b096e611eab1881d8422) and it doesn't
seem to exist there. However, tests/xfs/762 does exist. 
--NR
> 
> --D
> 
> > ---
> >  common/rc             |  51 ++++++++++++++
> >  tests/generic/762     | 160
> > ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/762.out |   2 +
> >  3 files changed, 213 insertions(+)
> >  create mode 100755 tests/generic/762
> >  create mode 100644 tests/generic/762.out
> > 
> > diff --git a/common/rc b/common/rc
> > index 6592c835..08a9d9b8 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2837,6 +2837,10 @@ _require_xfs_io_command()
> >  			opts+=" -d"
> >  			pwrite_opts+="-V 1 -b 4k"
> >  		fi
> > +		if [ "$param" == "-A" ]; then
> > +			opts+=" -d"
> > +			pwrite_opts+="-D -V 1 -b 4k"
> > +		fi
> >  		testio=`$XFS_IO_PROG -f $opts -c \
> >  		        "pwrite $pwrite_opts $param 0 4k" $testfile
> > 2>&1`
> >  		param_checked="$pwrite_opts $param"
> > @@ -5175,6 +5179,53 @@ _require_scratch_btime()
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
> > +		_notrun "write atomic not supported by this block
> > device"
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
> > diff --git a/tests/generic/762 b/tests/generic/762
> > new file mode 100755
> > index 00000000..d0a80219
> > --- /dev/null
> > +++ b/tests/generic/762
> > @@ -0,0 +1,160 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 762
> > +#
> > +# Validate atomic write support
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw
> > +
> > +_require_scratch_write_atomic
> > +_require_xfs_io_command pwrite -A
> > +
> > +test_atomic_writes()
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
> > +        ;;
> > +    esac
> > +
> > +    # If block size is not supported, skip this test
> > +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> > +    _try_scratch_mount >>$seqres.full 2>&1 || return
> > +
> > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
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
> > +        echo "atomic write min $file_min_write, should be fs block
> > size $bsize"
> > +    test $file_min_write -eq $bsize || \
> > +        echo "atomic write max $file_max_write, should be fs block
> > size $bsize"
> > +    test $file_max_segments -eq 1 || \
> > +        echo "atomic write max segments $file_max_segments, should
> > be 1"
> > +
> > +    # Check that we can perform an atomic write of len = FS block
> > size
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> > $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write
> > len=$bsize failed"
> > +
> > +    # Check that we can perform an atomic single-block cow write
> > +    if [ "$FSTYP" == "xfs" ]; then
> > +        testfile_cp=$SCRATCH_MNT/testfile_copy
> > +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> > +            cp --reflink $testfile $testfile_cp
> > +        fi
> > +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b
> > $bsize 0 $bsize" $testfile_cp | \
> > +            grep wrote | awk -F'[/ ]' '{print $2}')
> > +        test $bytes_written -eq $bsize || echo "atomic write on
> > reflinked file failed"
> > +    fi
> > +
> > +    # Check that we can perform an atomic write on an unwritten
> > block
> > +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize
> > $bsize $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to
> > unwritten block failed"
> > +
> > +    # Check that we can perform an atomic write on a sparse hole
> > +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> > $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to sparse
> > hole failed"
> > +
> > +    # Check that we can perform an atomic write on a fully mapped
> > block
> > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> > $bsize" $testfile | \
> > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > +    test $bytes_written -eq $bsize || echo "atomic write to mapped
> > block failed"
> > +
> > +    # Reject atomic write if len is out of bounds
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))"
> > $testfile 2>> $seqres.full && \
> > +        echo "atomic write len=$((bsize - 1)) should fail"
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))"
> > $testfile 2>> $seqres.full && \
> > +        echo "atomic write len=$((bsize + 1)) should fail"
> > +
> > +    # Reject atomic write when iovecs > 1
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize"
> > $testfile 2>> $seqres.full && \
> > +        echo "atomic write only supports iovec count of 1"
> > +
> > +    # Reject atomic write when not using direct I/O
> > +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile
> > 2>> $seqres.full && \
> > +        echo "atomic write requires direct I/O"
> > +
> > +    # Reject atomic write when offset % bsize != 0
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize"
> > $testfile 2>> $seqres.full && \
> > +        echo "atomic write requires offset to be aligned to bsize"
> > +
> > +    _scratch_unmount
> > +}
> > +
> > +test_atomic_write_bounds()
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
> > +        ;;
> > +    esac
> > +
> > +    # If block size is not supported, skip this test
> > +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> > +    _try_scratch_mount >>$seqres.full 2>&1 || return
> > +
> > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > +
> > +    testfile=$SCRATCH_MNT/testfile
> > +    touch $testfile
> > +
> > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize"
> > $testfile 2>> $seqres.full && \
> > +        echo "atomic write should fail when bsize is out of
> > bounds"
> > +
> > +    _scratch_unmount
> > +}
> > +
> > +sys_min_write=$(cat "/sys/block/$(_short_dev
> > $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> > +sys_max_write=$(cat "/sys/block/$(_short_dev
> > $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> > +
> > +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> > +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > +
> > +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> > +    echo "bdev min write != sys min write"
> > +fi
> > +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> > +    echo "bdev max write != sys max write"
> > +fi
> > +
> > +# Test all supported block sizes between bdev min and max
> > +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> > +        test_atomic_writes $bsize
> > +done;
> > +
> > +# Check that atomic write fails if bsize < bdev min or bsize >
> > bdev max
> > +test_atomic_write_bounds $((bdev_min_write / 2))
> > +test_atomic_write_bounds $((bdev_max_write * 2))
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/generic/762.out b/tests/generic/762.out
> > new file mode 100644
> > index 00000000..fbaeb297
> > --- /dev/null
> > +++ b/tests/generic/762.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 762
> > +Silence is golden
> > -- 
> > 2.34.1
> > 
> > 

