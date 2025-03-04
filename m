Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8331F55FA
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 08:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078043; cv=none; b=eiUkqqtLM8IajmqoJKUQQKMoQcDe6kAKVa5UKvybsvp4zBPrmAKjRM2nwxfnZgwtfwuPGwEmZ3mNYLnbvRCMFpMzSjM1Gf0m3GPzxOlCJEpvyfH6rydCqSOtTAR6Dd2m2VTezcO7xgOILm6XpINhMy2yMk1GReUCCGlX6i5sGVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078043; c=relaxed/simple;
	bh=SNFi+wvuVKJd52l/MVR/oYr6VRZ9ud1FPbZkiy0EO8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lOUwq7tFe4RWwFQp/TIb8q5yiOB/fcEZW5ZzViU23grnBE0RiY/2OyYP2/1bSkpDojwG2OxikqM3e0DUkCxoTi4Xym1CY+AtIttSRsiwqu978YlqcOJvpPMksPa4Mgl2kqC/sRy/BVPujVxWHWD5u3B0n4ckyMx/kkpLXL5Ykf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VBMrJfan; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBMrJfan"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741078039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vxqqwkbC7AqnCAi5XVUY+yK6tRGhVKo/og0MttuAbI4=;
	b=VBMrJfanppUnisR0tx/4NsIHTnw+qxVJww+AybVbArg4XiW8BCbfIY+Ec/Cy0/bXMlxhCP
	OknvO3bq/iD3MOx7o6vkvVpAh7gfyPz4WaO7Gi8SZ1BhaODivXHCyZDShuYBL7Fu1pJPHB
	4zjJzzpDR/1Jo4CSMU1YHXRFtq0OiWM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-12rj6CNGMB2KQwCHrMasCw-1; Tue, 04 Mar 2025 03:47:17 -0500
X-MC-Unique: 12rj6CNGMB2KQwCHrMasCw-1
X-Mimecast-MFC-AGG-ID: 12rj6CNGMB2KQwCHrMasCw_1741078037
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2234c09240fso95300505ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Mar 2025 00:47:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741078036; x=1741682836;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vxqqwkbC7AqnCAi5XVUY+yK6tRGhVKo/og0MttuAbI4=;
        b=eL745Ls1rVLIYuJuZtZ72VhJpIjyLZolRzFl4t4oNMmQ2E2VIbc08asRrt6tTy44zW
         pzp+gvyuwhmGHVUT+nHn6ygJYEzD5cHdXvnPzPTYDWOYAWEAkk9u6YBqJwV0dDdTVCoB
         +bxIv7MUKMUtdf7jrn9YT27dz3d2bfkByIk1YoRFrui0XefWojLJqtstDMeUiUDabu/q
         36KS5zIfuM2Ykf+ppv1fOLf79Pzgk82DWVpIWBwukz9opFJa5qPUtMbe4a377haWIn0I
         5xgUSU6DQSSf+vGhI+C6i3ufTc6LJZK/81EkA2jJSAvzfu9aDrmVuvsLrcTEz2sfaNQI
         tu2g==
X-Forwarded-Encrypted: i=1; AJvYcCVfERts464gfzudMqdf2RhkgPg1aN3A5SrnVUNuE0VKSe9haB3bOs5gX4/POwx9LsZ4YgpDz0je7Xg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9mgxePLt0ZVux/bPPttFnK7pbT56qKJXkjKorxPczvq/duT89
	ZhDJov2puoOwTSquEkC3qsU1GPDBdQ67i0JFfKyriSXI2EoYyzp4j+LjbP0Jq4fQ84+vcDIY7Ns
	qxPkDhkzBtmDSQ/OOT/VmHbhEMBfkVlhNlsVQhTDhLEz9Cl4Uc4rv3dYEAA==
X-Gm-Gg: ASbGncvf2LwpkfM8sElAhIyfQOHxkwvQYIE40VVLHFE8BmWbhmuFV+xF8gyJAVfQAYV
	/pJpUrgFfHfwlY6p57SmaDBCQtAyBiDglvPnvafAv+5kduDO7DnEKm/JWjS29YKYnHjPIp+aUGV
	h2XwlFkc4DwZHoG/9zsFWZIJ77puW85dMxHfQdUUPB6m4Stuf8uspmryDELLwJFcXFHET/wqc5Q
	6rO7o+2oLvX8+xZYVmEkGEcYLe3QZ0y7vJ8GLlyze0JqFXUQmNmmFFkWLc8Y1nXBg7gvNCcpZ/m
	Gh5+KDDnldUakCxSv0IhHOdETbwdblZ7/FHIgGulb6+UHeRjCHEIDkn4
X-Received: by 2002:a17:903:2ca:b0:223:53fb:e1dd with SMTP id d9443c01a7336-22368f6dca8mr247611785ad.9.1741078036496;
        Tue, 04 Mar 2025 00:47:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKn6xzqyZL6B8w2VAtr1dSsuI8yvSG8WQiO/gJxf37+Y7h9LHByYn/7PlCpMdYj2YqBOEOQQ==
X-Received: by 2002:a17:903:2ca:b0:223:53fb:e1dd with SMTP id d9443c01a7336-22368f6dca8mr247611505ad.9.1741078036085;
        Tue, 04 Mar 2025 00:47:16 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223d4b94c25sm13503975ad.49.2025.03.04.00.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 00:47:15 -0800 (PST)
Date: Tue, 4 Mar 2025 16:47:12 +0800
From: Zorro Lang <zlang@redhat.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	"Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH v3] xfs: add a test for atomic writes
Message-ID: <20250304084712.xmodkmfbtyf4rf73@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250228002059.16750-1-catherine.hoang@oracle.com>
 <20250228021156.GX6242@frogsfrogsfrogs>
 <c95b0a815dc9ccfe6172b589c5d4810147dcc207.camel@gmail.com>
 <20250228154335.GZ6242@frogsfrogsfrogs>
 <DABD5AF4-1711-495C-8387-CB628A2B728D@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DABD5AF4-1711-495C-8387-CB628A2B728D@oracle.com>

On Mon, Mar 03, 2025 at 10:42:44PM +0000, Catherine Hoang wrote:
> 
> 
> > On Feb 28, 2025, at 7:43 AM, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Fri, Feb 28, 2025 at 07:01:50PM +0530, Nirjhar Roy (IBM) wrote:
> >> On Thu, 2025-02-27 at 18:11 -0800, Darrick J. Wong wrote:
> >>> On Thu, Feb 27, 2025 at 04:20:59PM -0800, Catherine Hoang wrote:
> >>>> Add a test to validate the new atomic writes feature.
> >>>> 
> >>>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >>>> Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> >>> 
> >>> Er.... what git tree is this based upon?  generic/762 is a project
> >>> quota
> >>> test.
> >> On which branch do you have tests/generic/762? I checked the latest
> >> master(commit - 8467552f09e1672a02712653b532a84bd46ea10e) and the for-
> >> next(commit - 5b56a2d888191bfc7131b096e611eab1881d8422) and it doesn't
> >> seem to exist there. However, tests/xfs/762 does exist.
> > 
> > Zorro's patches-in-queue, aka whatever gets pushed to for-next on
> > Sunday.  
> 
> This test was based on for-next, I wasn’t aware there was another
> branch. I will rebase this onto patches-in-queue.

I can help to deal with the case number conflict too. It's good to me if
your patch is base on for-next, if you don't need to deal with some
conflicts with other "in-queue" patches, or pre-test un-pushed patches :)

Thanks,
Zorro

> > My confusion stems from this patch modifying what looks like an
> > existing atomic writes test, but generic/762 isn't that test so now I
> > can't see everything that this test is examining.
> 
> I don’t think the atomic writes test was ever merged, unless I missed it?
> > 
> > (I suggest everyone please post urls to public git repos so reviewers
> > can get around these sorts of issues in the future.)
> > 
> > --D
> > 
> >> --NR
> >>> 
> >>> --D
> >>> 
> >>>> ---
> >>>> common/rc             |  51 ++++++++++++++
> >>>> tests/generic/762     | 160
> >>>> ++++++++++++++++++++++++++++++++++++++++++
> >>>> tests/generic/762.out |   2 +
> >>>> 3 files changed, 213 insertions(+)
> >>>> create mode 100755 tests/generic/762
> >>>> create mode 100644 tests/generic/762.out
> >>>> 
> >>>> diff --git a/common/rc b/common/rc
> >>>> index 6592c835..08a9d9b8 100644
> >>>> --- a/common/rc
> >>>> +++ b/common/rc
> >>>> @@ -2837,6 +2837,10 @@ _require_xfs_io_command()
> >>>> opts+=" -d"
> >>>> pwrite_opts+="-V 1 -b 4k"
> >>>> fi
> >>>> + if [ "$param" == "-A" ]; then
> >>>> + opts+=" -d"
> >>>> + pwrite_opts+="-D -V 1 -b 4k"
> >>>> + fi
> >>>> testio=`$XFS_IO_PROG -f $opts -c \
> >>>>        "pwrite $pwrite_opts $param 0 4k" $testfile
> >>>> 2>&1`
> >>>> param_checked="$pwrite_opts $param"
> >>>> @@ -5175,6 +5179,53 @@ _require_scratch_btime()
> >>>> _scratch_unmount
> >>>> }
> >>>> 
> >>>> +_get_atomic_write_unit_min()
> >>>> +{
> >>>> + $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> >>>> +        grep atomic_write_unit_min | grep -o '[0-9]\+'
> >>>> +}
> >>>> +
> >>>> +_get_atomic_write_unit_max()
> >>>> +{
> >>>> + $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> >>>> +        grep atomic_write_unit_max | grep -o '[0-9]\+'
> >>>> +}
> >>>> +
> >>>> +_get_atomic_write_segments_max()
> >>>> +{
> >>>> + $XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> >>>> +        grep atomic_write_segments_max | grep -o '[0-9]\+'
> >>>> +}
> >>>> +
> >>>> +_require_scratch_write_atomic()
> >>>> +{
> >>>> + _require_scratch
> >>>> +
> >>>> + export STATX_WRITE_ATOMIC=0x10000
> >>>> +
> >>>> + awu_min_bdev=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> >>>> + awu_max_bdev=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> >>>> +
> >>>> + if [ $awu_min_bdev -eq 0 ] && [ $awu_max_bdev -eq 0 ]; then
> >>>> + _notrun "write atomic not supported by this block
> >>>> device"
> >>>> + fi
> >>>> +
> >>>> + _scratch_mkfs > /dev/null 2>&1
> >>>> + _scratch_mount
> >>>> +
> >>>> + testfile=$SCRATCH_MNT/testfile
> >>>> + touch $testfile
> >>>> +
> >>>> + awu_min_fs=$(_get_atomic_write_unit_min $testfile)
> >>>> + awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> >>>> +
> >>>> + _scratch_unmount
> >>>> +
> >>>> + if [ $awu_min_fs -eq 0 ] && [ $awu_max_fs -eq 0 ]; then
> >>>> + _notrun "write atomic not supported by this filesystem"
> >>>> + fi
> >>>> +}
> >>>> +
> >>>> _require_inode_limits()
> >>>> {
> >>>> if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> >>>> diff --git a/tests/generic/762 b/tests/generic/762
> >>>> new file mode 100755
> >>>> index 00000000..d0a80219
> >>>> --- /dev/null
> >>>> +++ b/tests/generic/762
> >>>> @@ -0,0 +1,160 @@
> >>>> +#! /bin/bash
> >>>> +# SPDX-License-Identifier: GPL-2.0
> >>>> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> >>>> +#
> >>>> +# FS QA Test 762
> >>>> +#
> >>>> +# Validate atomic write support
> >>>> +#
> >>>> +. ./common/preamble
> >>>> +_begin_fstest auto quick rw
> >>>> +
> >>>> +_require_scratch_write_atomic
> >>>> +_require_xfs_io_command pwrite -A
> >>>> +
> >>>> +test_atomic_writes()
> >>>> +{
> >>>> +    local bsize=$1
> >>>> +
> >>>> +    case "$FSTYP" in
> >>>> +    "xfs")
> >>>> +        mkfs_opts="-b size=$bsize"
> >>>> +        ;;
> >>>> +    "ext4")
> >>>> +        mkfs_opts="-b $bsize"
> >>>> +        ;;
> >>>> +    *)
> >>>> +        ;;
> >>>> +    esac
> >>>> +
> >>>> +    # If block size is not supported, skip this test
> >>>> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> >>>> +    _try_scratch_mount >>$seqres.full 2>&1 || return
> >>>> +
> >>>> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> >>>> +
> >>>> +    testfile=$SCRATCH_MNT/testfile
> >>>> +    touch $testfile
> >>>> +
> >>>> +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> >>>> +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> >>>> +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> >>>> +
> >>>> +    # Check that atomic min/max = FS block size
> >>>> +    test $file_min_write -eq $bsize || \
> >>>> +        echo "atomic write min $file_min_write, should be fs block
> >>>> size $bsize"
> >>>> +    test $file_min_write -eq $bsize || \
> >>>> +        echo "atomic write max $file_max_write, should be fs block
> >>>> size $bsize"
> >>>> +    test $file_max_segments -eq 1 || \
> >>>> +        echo "atomic write max segments $file_max_segments, should
> >>>> be 1"
> >>>> +
> >>>> +    # Check that we can perform an atomic write of len = FS block
> >>>> size
> >>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> >>>> $bsize" $testfile | \
> >>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
> >>>> +    test $bytes_written -eq $bsize || echo "atomic write
> >>>> len=$bsize failed"
> >>>> +
> >>>> +    # Check that we can perform an atomic single-block cow write
> >>>> +    if [ "$FSTYP" == "xfs" ]; then
> >>>> +        testfile_cp=$SCRATCH_MNT/testfile_copy
> >>>> +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> >>>> +            cp --reflink $testfile $testfile_cp
> >>>> +        fi
> >>>> +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b
> >>>> $bsize 0 $bsize" $testfile_cp | \
> >>>> +            grep wrote | awk -F'[/ ]' '{print $2}')
> >>>> +        test $bytes_written -eq $bsize || echo "atomic write on
> >>>> reflinked file failed"
> >>>> +    fi
> >>>> +
> >>>> +    # Check that we can perform an atomic write on an unwritten
> >>>> block
> >>>> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> >>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize
> >>>> $bsize $bsize" $testfile | \
> >>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
> >>>> +    test $bytes_written -eq $bsize || echo "atomic write to
> >>>> unwritten block failed"
> >>>> +
> >>>> +    # Check that we can perform an atomic write on a sparse hole
> >>>> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> >>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> >>>> $bsize" $testfile | \
> >>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
> >>>> +    test $bytes_written -eq $bsize || echo "atomic write to sparse
> >>>> hole failed"
> >>>> +
> >>>> +    # Check that we can perform an atomic write on a fully mapped
> >>>> block
> >>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0
> >>>> $bsize" $testfile | \
> >>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
> >>>> +    test $bytes_written -eq $bsize || echo "atomic write to mapped
> >>>> block failed"
> >>>> +
> >>>> +    # Reject atomic write if len is out of bounds
> >>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))"
> >>>> $testfile 2>> $seqres.full && \
> >>>> +        echo "atomic write len=$((bsize - 1)) should fail"
> >>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))"
> >>>> $testfile 2>> $seqres.full && \
> >>>> +        echo "atomic write len=$((bsize + 1)) should fail"
> >>>> +
> >>>> +    # Reject atomic write when iovecs > 1
> >>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize"
> >>>> $testfile 2>> $seqres.full && \
> >>>> +        echo "atomic write only supports iovec count of 1"
> >>>> +
> >>>> +    # Reject atomic write when not using direct I/O
> >>>> +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile
> >>>> 2>> $seqres.full && \
> >>>> +        echo "atomic write requires direct I/O"
> >>>> +
> >>>> +    # Reject atomic write when offset % bsize != 0
> >>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize"
> >>>> $testfile 2>> $seqres.full && \
> >>>> +        echo "atomic write requires offset to be aligned to bsize"
> >>>> +
> >>>> +    _scratch_unmount
> >>>> +}
> >>>> +
> >>>> +test_atomic_write_bounds()
> >>>> +{
> >>>> +    local bsize=$1
> >>>> +
> >>>> +    case "$FSTYP" in
> >>>> +    "xfs")
> >>>> +        mkfs_opts="-b size=$bsize"
> >>>> +        ;;
> >>>> +    "ext4")
> >>>> +        mkfs_opts="-b $bsize"
> >>>> +        ;;
> >>>> +    *)
> >>>> +        ;;
> >>>> +    esac
> >>>> +
> >>>> +    # If block size is not supported, skip this test
> >>>> +    _scratch_mkfs $mkfs_opts >>$seqres.full 2>&1 || return
> >>>> +    _try_scratch_mount >>$seqres.full 2>&1 || return
> >>>> +
> >>>> +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> >>>> +
> >>>> +    testfile=$SCRATCH_MNT/testfile
> >>>> +    touch $testfile
> >>>> +
> >>>> +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize"
> >>>> $testfile 2>> $seqres.full && \
> >>>> +        echo "atomic write should fail when bsize is out of
> >>>> bounds"
> >>>> +
> >>>> +    _scratch_unmount
> >>>> +}
> >>>> +
> >>>> +sys_min_write=$(cat "/sys/block/$(_short_dev
> >>>> $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> >>>> +sys_max_write=$(cat "/sys/block/$(_short_dev
> >>>> $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> >>>> +
> >>>> +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> >>>> +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> >>>> +
> >>>> +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> >>>> +    echo "bdev min write != sys min write"
> >>>> +fi
> >>>> +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> >>>> +    echo "bdev max write != sys max write"
> >>>> +fi
> >>>> +
> >>>> +# Test all supported block sizes between bdev min and max
> >>>> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> >>>> +        test_atomic_writes $bsize
> >>>> +done;
> >>>> +
> >>>> +# Check that atomic write fails if bsize < bdev min or bsize >
> >>>> bdev max
> >>>> +test_atomic_write_bounds $((bdev_min_write / 2))
> >>>> +test_atomic_write_bounds $((bdev_max_write * 2))
> >>>> +
> >>>> +# success, all done
> >>>> +echo Silence is golden
> >>>> +status=0
> >>>> +exit
> >>>> diff --git a/tests/generic/762.out b/tests/generic/762.out
> >>>> new file mode 100644
> >>>> index 00000000..fbaeb297
> >>>> --- /dev/null
> >>>> +++ b/tests/generic/762.out
> >>>> @@ -0,0 +1,2 @@
> >>>> +QA output created by 762
> >>>> +Silence is golden
> >>>> -- 
> >>>> 2.34.1
> >>>> 
> >>>> 
> >> 
> >> 
> 

