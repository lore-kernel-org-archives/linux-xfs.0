Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94301A265E
	for <linux-xfs@vger.kernel.org>; Sat, 21 Jun 2025 12:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750508429; cv=none; b=IQe7GRfGsHzK9K5EeL73FhqXNyXHO114YOwbSmEoeTyEAghTeWUAuQjzT4tfNpr07HziFw56znJwp5gk8Iv1wlH7YOR/pKkKM03uFPVFAMBS+RAZOy45h6rRXP3E5nXWZ1FNVHspjonKhLryRAU0zLjlwPjWEmM6DwarZlhTooA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750508429; c=relaxed/simple;
	bh=Lv9YX7yDj8CaHzFEetfi1bS0++xg2ypidKhEbZYRFsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B43IW0mX6cqs6igqi7cZ0LeLdeSz6e1YOHlaDuSnqx7uPcTxVduYW+kWoDCAFyFKPzJ1bDD+8IISCYVGR2su1x6R2SswEWswBxFm8poP8UjUB8opcevIpaSsF8lWNezTgG96Dn1BdDen9t3AfkaPLSug1KKOscCbvdIq2Y+dQaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQuXZspm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQuXZspm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750508425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLrzYLvLWzdmXM/DCxLmeArMs4zbQJGmmytOTDiczlI=;
	b=HQuXZspmNBONfEVMKuUDP8ebLEDa2vN3C6tBsFRjOIvfyj9w7QOaGN3LSifzTJkxb1aCRL
	WmW4sk0kTE1M33cEnlXJTPQvxeOmsaWRjFS2VgUNF1Up++UDIMleZ756OP39PYcBC4e/P7
	A4Snsssol47/xe/fx6vD3FWyIjo1WTs=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-91D9e49AP6Gco6uKXsu5mg-1; Sat, 21 Jun 2025 08:20:24 -0400
X-MC-Unique: 91D9e49AP6Gco6uKXsu5mg-1
X-Mimecast-MFC-AGG-ID: 91D9e49AP6Gco6uKXsu5mg_1750508423
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-313f8835f29so3692389a91.3
        for <linux-xfs@vger.kernel.org>; Sat, 21 Jun 2025 05:20:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750508423; x=1751113223;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLrzYLvLWzdmXM/DCxLmeArMs4zbQJGmmytOTDiczlI=;
        b=XRdie2C2YaSjEVIRx5yhxFMkY0pWAka9VLEztx8YUH3XBa7LVewH8jv9NyLIUrVJOn
         xV7bq84zFVg8n/Rik2jbnu+rLp62x4vxy8ZEx1vYed1hLKrNd2W0vi1SgKdS4VP6tWzv
         sJhOlbTHhpYE5oeNRUEhn5xPHu7uSXW/yrfLsrnXgOZBUC3kFxUdeNr2HBrHCA1tSdGh
         qs8fszu1CdOZRbaKfCjI/OwIW0p9emt8294u32wQrLIwSGrA4i1zepjtKapzy20wFJuh
         nyy7DEhog9+q4zuFeT68HDyyDcZyvyEw0ojH6aL+skW+QExyw0E1TZlu9wmCvEps//4y
         sRuw==
X-Gm-Message-State: AOJu0YzXwdRfwBCIPP5/xguG/2GGfBiHKsOwWGIUcLpBc3rOz2COcVYh
	QMsxLaOiElGzqeRqjUqO94+uFefRi+U1cZf3D0SALFPWgfFjwc3Qa5cnAtstlPH/hTp74StnbLq
	osTiASUEGXrVgGDhkZUKpEsV3zqd2K0ycjwITaobGX683i++NQz8vc+EP/4UvDw==
X-Gm-Gg: ASbGnct+cBrXQioXuNiIwIxD1P8jM+DJcSKmc24fVLaqRMtin43uyPe1PUADjNb+eSX
	ilNnm1LQR/bTaB008OFlJ5HQlvdzSzK/X1mtW5Nvvfz90u0zIRNJHEvCAbR5GzpGToLFqRBwAYf
	4+CB6KK/OcwyG6edIqY0X8B1Hz2u38TVRSE8LzAxUUhRScEfS0LLST9AikIF+gkT6LAvH5jYLg4
	bPbxaLrmRdP3rP4lBIOXB9VJevVb9QIlGjhDGVTJgfN5BdBqfQCMYCUtdAZtq7ozMjhCo6ZiKX0
	Y+hCxJ36DR+mKoHTm9l4AhtMHd81ywiDkUmTlwljldZRftDy2GjGxE4ze223BNA=
X-Received: by 2002:a17:90b:5685:b0:311:da03:3437 with SMTP id 98e67ed59e1d1-3159d8d8913mr8862132a91.27.1750508422790;
        Sat, 21 Jun 2025 05:20:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVQf68GMEwRnn7L93eZrCwS2wv4f4dKTzz1tIjoFajroGLf9/ZWsYbs/cyCKxx1Kky0XAHNQ==
X-Received: by 2002:a17:90b:5685:b0:311:da03:3437 with SMTP id 98e67ed59e1d1-3159d8d8913mr8862087a91.27.1750508422249;
        Sat, 21 Jun 2025 05:20:22 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d871f10fsm39014285ad.233.2025.06.21.05.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jun 2025 05:20:21 -0700 (PDT)
Date: Sat, 21 Jun 2025 20:20:16 +0800
From: Zorro Lang <zlang@redhat.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>
Subject: Re: [PATCH v5 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <20250621122016.h7qwtxvzz67vo6bl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
 <20250616215213.36260-3-catherine.hoang@oracle.com>
 <20250618180907.5r2p6gs77felb2o4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <5D0123B1-C325-41F4-8BB9-7D74F482295B@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5D0123B1-C325-41F4-8BB9-7D74F482295B@oracle.com>

On Fri, Jun 20, 2025 at 11:02:05PM +0000, Catherine Hoang wrote:
> 
> > On Jun 18, 2025, at 11:09 AM, Zorro Lang <zlang@redhat.com> wrote:
> > 
> > On Mon, Jun 16, 2025 at 02:52:12PM -0700, Catherine Hoang wrote:
> >> From: "Darrick J. Wong" <djwong@kernel.org>
> >> 
> >> Simple tests of various atomic write requests and a (simulated) hardware
> >> device.
> >> 
> >> The first test performs basic multi-block atomic writes on a scsi_debug device
> >> with atomic writes enabled. We test all advertised sizes between the atomic
> >> write unit min and max. We also ensure that the write fails when expected, such
> >> as when attempting buffered io or unaligned directio.
> >> 
> >> The second test is similar to the one above, except that it verifies multi-block
> >> atomic writes on actual hardware instead of simulated hardware. The device used
> >> in this test is not required to support atomic writes.
> >> 
> >> The final two tests ensure multi-block atomic writes can be performed on various
> >> interweaved mappings, including written, mapped, hole, and unwritten. We also
> >> test large atomic writes on a heavily fragmented filesystem. These tests are
> >> separated into reflink (shared) and non-reflink tests.
> >> 
> >> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> >> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> >> ---
> >> common/atomicwrites    |  10 ++++
> >> tests/generic/1222     |  88 ++++++++++++++++++++++++++++
> >> tests/generic/1222.out |  10 ++++
> >> tests/generic/1223     |  66 +++++++++++++++++++++
> >> tests/generic/1223.out |   9 +++
> >> tests/generic/1224     |  86 ++++++++++++++++++++++++++++
> >> tests/generic/1224.out |  16 ++++++
> >> tests/generic/1225     | 127 +++++++++++++++++++++++++++++++++++++++++
> >> tests/generic/1225.out |  21 +++++++
> >> 9 files changed, 433 insertions(+)
> >> create mode 100755 tests/generic/1222
> >> create mode 100644 tests/generic/1222.out
> >> create mode 100755 tests/generic/1223
> >> create mode 100644 tests/generic/1223.out
> >> create mode 100755 tests/generic/1224
> >> create mode 100644 tests/generic/1224.out
> >> create mode 100755 tests/generic/1225
> >> create mode 100644 tests/generic/1225.out
> >> 
> >> diff --git a/common/atomicwrites b/common/atomicwrites
> >> index ac4facc3..95d545a6 100644
> >> --- a/common/atomicwrites
> >> +++ b/common/atomicwrites
> >> @@ -136,3 +136,13 @@ _test_atomic_file_writes()
> >>     $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> >>         echo "atomic write requires offset to be aligned to bsize"
> >> }
> >> +
> >> +_simple_atomic_write() {
> >> + local pos=$1
> >> + local count=$2
> >> + local file=$3
> >> + local directio=$4
> >> +
> >> + echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
> >> + $XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
> >> +}
> >> diff --git a/tests/generic/1222 b/tests/generic/1222
> >> new file mode 100755
> >> index 00000000..c718b244
> >> --- /dev/null
> >> +++ b/tests/generic/1222
> >> @@ -0,0 +1,88 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 1222
> >> +#
> >> +# Validate multi-fsblock atomic write support with simulated hardware support
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick rw atomicwrites
> >> +
> >> +. ./common/scsi_debug
> >> +. ./common/atomicwrites
> >> +
> >> +_cleanup()
> >> +{
> >> + _scratch_unmount &>/dev/null
> >> + _put_scsi_debug_dev &>/dev/null
> >> + cd /
> >> + rm -r -f $tmp.*
> >> +}
> >> +
> >> +_require_scsi_debug
> >> +_require_scratch_nocheck
                       ^^^^^^^

> >> +# Format something so that ./check doesn't freak out
> >> +_scratch_mkfs >> $seqres.full
> >> +
> >> +# 512b logical/physical sectors, 512M size, atomic writes enabled
> >> +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> >> +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> >> +
> >> +export SCRATCH_DEV=$dev
> > 
> > These's a generic test case. As you use scsi_debug device. I'm wondering do we
> > need _require_block_device? Can this case works with FSTYP=nfs, cifs, tmpfs, overlayfs
> > and so on?

Did you make sure that this generic test case will _notrun on other fs, won't break
their fs testing?

> > 
> >> +unset USE_EXTERNAL
> >> +
> >> +_require_scratch_write_atomic

This function calls _require_scratch, that means the $SCRATCH_DEV still need to be
checked at the end of this test. So your above _require_scratch_nocheck isn't
real "nocheck".

> >> +_require_scratch_write_atomic_multi_fsblock
> >> +
> >> +xfs_io -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
> >> +xfs_io -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"
> > 
> > Can't these two lines be replaced by _require_xfs_io? e.g.
> > _require_xfs_io_command pwrite -A
> > _require_xfs_io_command falloc
> 
> We can't use _require_xfs_io here because this checks $TEST_DIR, but we are
> running these tests on a scsi_debug device located at $SCRATCH_MNT. Even
> if $TEST_DIR doesn't support atomic writes, we still want to run this test as long
> as the scsi_debug device has atomic writes enabled. So we need to manually
> check that the scsi_debug device supports the commands we need.

Oh, makes sense :) But that means you only check the command is supported by xfs_io,
not by the fs.

Please add a comment to explain that, and replace "xfs_io" with "$XFS_IO_PROG" at least.

> 
> I will address the other review comments in the next version. Thanks!
> > 
> >> +
> >> +echo "scsi_debug atomic write properties" >> $seqres.full
> >> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> > 
> > _require_xfs_io_command statx -r ?
> > 
> >> +
> >> +_scratch_mkfs >> $seqres.full
> >> +_scratch_mount
> >> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> >> +
> >> +testfile=$SCRATCH_MNT/testfile
> >> +touch $testfile
> >> +
> >> +echo "filesystem atomic write properties" >> $seqres.full
> >> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> >> +
> >> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> >> +min_awu=$(_get_atomic_write_unit_min $testfile)
> >> +max_awu=$(_get_atomic_write_unit_max $testfile)
> >> +
> >> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> >> +
> >> +# try outside the advertised sizes
> >> +echo "two EINVAL for unsupported sizes"
> >> +min_i=$((min_awu / 2))
> >> +_simple_atomic_write $min_i $min_i $testfile -d
> >> +max_i=$((max_awu * 2))
> >> +_simple_atomic_write $max_i $max_i $testfile -d
> >> +
> >> +# try all of the advertised sizes
> >> +echo "all should work"
> >> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> >> + $XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> >> + _test_atomic_file_writes $i $testfile
> >> +done
> >> +
> >> +# does not support buffered io
> >> +echo "one EOPNOTSUPP for buffered atomic"
> >> +_simple_atomic_write 0 $min_awu $testfile
> >> +
> >> +# does not support unaligned directio
> >> +echo "one EINVAL for unaligned directio"
> >> +_simple_atomic_write $sector_size $min_awu $testfile -d
> >> +
> >> +_scratch_unmount
> >> +_put_scsi_debug_dev
> >> +
> >> +# success, all done
> >> +echo Silence is golden
> >> +status=0
> >> +exit
> >> diff --git a/tests/generic/1222.out b/tests/generic/1222.out
> >> new file mode 100644
> >> index 00000000..158b52fa
> >> --- /dev/null
> >> +++ b/tests/generic/1222.out
> >> @@ -0,0 +1,10 @@
> >> +QA output created by 1222
> >> +two EINVAL for unsupported sizes
> >> +pwrite: Invalid argument
> >> +pwrite: Invalid argument
> >> +all should work
> >> +one EOPNOTSUPP for buffered atomic
> >> +pwrite: Operation not supported
> >> +one EINVAL for unaligned directio
> >> +pwrite: Invalid argument
> >> +Silence is golden
> >> diff --git a/tests/generic/1223 b/tests/generic/1223
> >> new file mode 100755
> >> index 00000000..db242e7f
> >> --- /dev/null
> >> +++ b/tests/generic/1223
> >> @@ -0,0 +1,66 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 1223
> >> +#
> >> +# Validate multi-fsblock atomic write support with or without hw support
> >> +#
> > 
> > Same review points with above case.
> > 
> >> +. ./common/preamble
> >> +_begin_fstest auto quick rw atomicwrites
> >> +
> >> +. ./common/atomicwrites
> >> +
> >> +_require_scratch
> >> +_require_atomic_write_test_commands
> >> +_require_scratch_write_atomic_multi_fsblock
> >> +
> >> +echo "scratch device atomic write properties" >> $seqres.full
> >> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> >> +
> >> +_scratch_mkfs >> $seqres.full
> >> +_scratch_mount
> >> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> >> +
> >> +testfile=$SCRATCH_MNT/testfile
> >> +touch $testfile
> >> +
> >> +echo "filesystem atomic write properties" >> $seqres.full
> >> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> >> +
> >> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> >> +min_awu=$(_get_atomic_write_unit_min $testfile)
> >> +max_awu=$(_get_atomic_write_unit_max $testfile)
> >> +
> >> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> >> +
> >> +# try outside the advertised sizes
> >> +echo "two EINVAL for unsupported sizes"
> >> +min_i=$((min_awu / 2))
> >> +_simple_atomic_write $min_i $min_i $testfile -d
> >> +max_i=$((max_awu * 2))
> >> +_simple_atomic_write $max_i $max_i $testfile -d
> >> +
> >> +# try all of the advertised sizes
> >> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> >> + $XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> >> + _test_atomic_file_writes $i $testfile
> >> +done
> >> +
> >> +# does not support buffered io
> >> +echo "one EOPNOTSUPP for buffered atomic"
> >> +_simple_atomic_write 0 $min_awu $testfile
> >> +
> >> +# does not support unaligned directio
> >> +echo "one EINVAL for unaligned directio"
> >> +if [ $sector_size -lt $min_awu ]; then
> >> + _simple_atomic_write $sector_size $min_awu $testfile -d
> >> +else
> >> + # not supported, so fake the output
> >> + echo "pwrite: Invalid argument"
> >> +fi
> >> +
> >> +# success, all done
> >> +echo Silence is golden
> >> +status=0
> >> +exit
> >> diff --git a/tests/generic/1223.out b/tests/generic/1223.out
> >> new file mode 100644
> >> index 00000000..edf5bd71
> >> --- /dev/null
> >> +++ b/tests/generic/1223.out
> >> @@ -0,0 +1,9 @@
> >> +QA output created by 1223
> >> +two EINVAL for unsupported sizes
> >> +pwrite: Invalid argument
> >> +pwrite: Invalid argument
> >> +one EOPNOTSUPP for buffered atomic
> >> +pwrite: Operation not supported
> >> +one EINVAL for unaligned directio
> >> +pwrite: Invalid argument
> >> +Silence is golden
> >> diff --git a/tests/generic/1224 b/tests/generic/1224
> >> new file mode 100755
> >> index 00000000..3f83eebc
> >> --- /dev/null
> >> +++ b/tests/generic/1224
> >> @@ -0,0 +1,86 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 1224
> >> +#
> >> +# reflink tests for large atomic writes with mixed mappings
> >> +#
> > 
> > Same review points as above case.
> > 
> >> +. ./common/preamble
> >> +_begin_fstest auto quick rw atomicwrites
> >> +
> >> +. ./common/atomicwrites
> >> +. ./common/filter
> >> +. ./common/reflink
> >> +
> >> +_require_scratch
> >> +_require_atomic_write_test_commands
> >> +_require_scratch_write_atomic_multi_fsblock
> >> +_require_xfs_io_command pwrite -A
> >> +_require_cp_reflink
> > 
> > Do you just need _require_cp_reflink, or need _require_scratch_reflink too?
> > 
> > Thanks,
> > Zorro
> > 
> >> +
> >> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> >> +_scratch_mount
> >> +
> >> +file1=$SCRATCH_MNT/file1
> >> +file2=$SCRATCH_MNT/file2
> >> +file3=$SCRATCH_MNT/file3
> >> +
> >> +touch $file1
> >> +
> >> +max_awu=$(_get_atomic_write_unit_max $file1)
> >> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> >> +
> >> +min_awu=$(_get_atomic_write_unit_min $file1)
> >> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> >> +
> >> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> >> +test $max_awu -gt $((bsize * 2)) || \
> >> + _notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> >> +
> >> +# reflink tests (files with shared extents)
> >> +
> >> +echo "atomic write shared data and unshared+shared data"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +cp --reflink=always $file1 $file2
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +md5sum $file2 | _filter_scratch
> >> +
> >> +echo "atomic write shared data and shared+unshared data"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +cp --reflink=always $file1 $file2
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +md5sum $file2 | _filter_scratch
> >> +
> >> +echo "atomic overwrite unshared data"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +cp --reflink=always $file1 $file2
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +md5sum $file2 | _filter_scratch
> >> +
> >> +echo "atomic write shared+unshared+shared data"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +cp --reflink=always $file1 $file2
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +md5sum $file2 | _filter_scratch
> >> +
> >> +echo "atomic write interweaved hole+unwritten+written+reflinked"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +blksz=4096
> >> +nr=32
> >> +_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +md5sum $file2 | _filter_scratch
> >> +
> >> +# success, all done
> >> +status=0
> >> +exit
> >> diff --git a/tests/generic/1224.out b/tests/generic/1224.out
> >> new file mode 100644
> >> index 00000000..89e5cd5a
> >> --- /dev/null
> >> +++ b/tests/generic/1224.out
> >> @@ -0,0 +1,16 @@
> >> +QA output created by 1224
> >> +atomic write shared data and unshared+shared data
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> >> +atomic write shared data and shared+unshared data
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> >> +atomic overwrite unshared data
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> >> +atomic write shared+unshared+shared data
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> >> +atomic write interweaved hole+unwritten+written+reflinked
> >> +4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
> >> +93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
> >> diff --git a/tests/generic/1225 b/tests/generic/1225
> >> new file mode 100755
> >> index 00000000..b940afd3
> >> --- /dev/null
> >> +++ b/tests/generic/1225
> >> @@ -0,0 +1,127 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 1225
> >> +#
> >> +# basic tests for large atomic writes with mixed mappings
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick rw atomicwrites
> >> +
> >> +. ./common/atomicwrites
> >> +. ./common/filter
> >> +. ./common/reflink
> >> +
> >> +_require_scratch
> >> +_require_atomic_write_test_commands
> >> +_require_scratch_write_atomic_multi_fsblock
> >> +
> >> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> >> +_scratch_mount
> >> +
> >> +file1=$SCRATCH_MNT/file1
> >> +file2=$SCRATCH_MNT/file2
> >> +file3=$SCRATCH_MNT/file3
> >> +
> >> +touch $file1
> >> +
> >> +max_awu=$(_get_atomic_write_unit_max $file1)
> >> +test $max_awu -ge 65536 || _notrun "test requires atomic writes up to 64k"
> >> +
> >> +min_awu=$(_get_atomic_write_unit_min $file1)
> >> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> >> +
> >> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> >> +test $max_awu -gt $((bsize * 2)) || \
> >> + _notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> >> +
> >> +# non-reflink tests
> >> +
> >> +echo "atomic write hole+mapped+hole"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write adjacent mapped+hole and hole+mapped"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write mapped+hole+mapped"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write unwritten+mapped+unwritten"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write mapped+unwritten+mapped"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write interweaved hole+unwritten+written"
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +blksz=4096
> >> +nr=32
> >> +_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write at EOF"
> >> +dd if=/dev/zero of=$file1 bs=32K count=12 conv=fsync >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 360448 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +echo "atomic write preallocated region"
> >> +fallocate -l 10M $file1
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> >> +md5sum $file1 | _filter_scratch
> >> +
> >> +# atomic write max size
> >> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> >> +aw_max=$(_get_atomic_write_unit_max $file1)
> >> +cp $file1 $file1.chk
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> >> +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> >> +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> >> +
> >> +echo "atomic write max size on fragmented fs"
> >> +avail=`_get_available_space $SCRATCH_MNT`
> >> +filesizemb=$((avail / 1024 / 1024 - 1))
> >> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> >> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> >> +$here/src/punch-alternating $fragmentedfile
> >> +touch $file3
> >> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> >> +md5sum $file3 | _filter_scratch
> >> +
> >> +# success, all done
> >> +status=0
> >> +exit
> >> diff --git a/tests/generic/1225.out b/tests/generic/1225.out
> >> new file mode 100644
> >> index 00000000..c5a6de04
> >> --- /dev/null
> >> +++ b/tests/generic/1225.out
> >> @@ -0,0 +1,21 @@
> >> +QA output created by 1225
> >> +atomic write hole+mapped+hole
> >> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> >> +atomic write adjacent mapped+hole and hole+mapped
> >> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> >> +atomic write mapped+hole+mapped
> >> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> >> +atomic write unwritten+mapped+unwritten
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +atomic write adjacent mapped+unwritten and unwritten+mapped
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +atomic write mapped+unwritten+mapped
> >> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> >> +atomic write interweaved hole+unwritten+written
> >> +5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
> >> +atomic write at EOF
> >> +0e44615ab08f3e8585a374fca9a6f5eb  SCRATCH_MNT/file1
> >> +atomic write preallocated region
> >> +3acf1ace00273bc4e2bf4a8d016611ea  SCRATCH_MNT/file1
> >> +atomic write max size on fragmented fs
> >> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
> >> -- 
> >> 2.34.1
> >> 
> >> 
> > 
> 

