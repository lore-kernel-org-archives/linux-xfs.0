Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133C03085B8
	for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750270161; cv=none; b=IcnzjEWJlrw7Qz4lDkLHp9ROf3dbLfRmS9sxwMxcT6UC94GmAe7TxS7hqk4l9raoSfovk/wg7k0OP1Zk53w4r0nZvcoRocca0Tcje+QL5p4FRZ8ofAKj4fUMIY9XKxJy9HBxk1Yq4ZVDNNy59PZi8YGrRaamSht8TTX+IiSPe1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750270161; c=relaxed/simple;
	bh=VHKguEoDgWfXNBFAm+8Xizach2GTC/ZW4SCaGyukIXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cVwuh6JogDTs+lRoexbBX727mije1XI4HEDJBUt0UOppKsYp8ZtL6tvRCwB4mcAJM7BcV/jhye/8g48gIr5ELyHUijsFxjAUYZVHYdz9CfAgTXYxNHnz+D1XFwaw/j++UsmP5/yY6bkwjHUbhneewnXLyHwOX4nfRt7VXVKKCEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZQVlxXDz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZQVlxXDz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750270155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wGoA0erN9Mx1SwA5o4Blcbhhos//gvbMjjJ/4NYA/Gk=;
	b=ZQVlxXDztsaWxefBSQbMMxbTGoWrqWx9NwYauT5d7UQ4EiR2+lS5JZQY8yz3zqC1vsA6oD
	izL2A3/IBBYJBB4KktNlmLW4ov2zqyGpi139oMuZmFxc8A/x6a5VWfsMBH+iYjaD0st59d
	e8kH3pjyoPwi4QFF2x49tuAeq/VoPdc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-Xpdk1jYEOvSDfWQxCXG53Q-1; Wed, 18 Jun 2025 14:09:14 -0400
X-MC-Unique: Xpdk1jYEOvSDfWQxCXG53Q-1
X-Mimecast-MFC-AGG-ID: Xpdk1jYEOvSDfWQxCXG53Q_1750270153
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-31327b2f8e4so7224098a91.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jun 2025 11:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750270153; x=1750874953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wGoA0erN9Mx1SwA5o4Blcbhhos//gvbMjjJ/4NYA/Gk=;
        b=NLHq9wa5f/NRIKWZc8XBI6GxfkkT6xw7CSJXvl+hrhcVqNBEuRDCdL45WMUDXFfwf+
         5gdlNU6zYMz62pl/nKTdSe+bC5cI2XXb/uGJBsJrtDRUwwlBcErKuCU/y2TUjZtWOrsQ
         RL5ZK6NeyDvsfhOOy5foR2GfrJjwspyXpVb81ssSFCqLgm4kWSDBa9Qofm0oWSj/rLBJ
         GMUEn7yfO0xnB9S2DPkevboO0ynuVT0zaPdQ8wLUSHhckc5NENK1bzCnR/jGnaBm3beB
         cnvRs6t1ha+AbYSizstF9iBfdMCqoSMoUYyLmB94rdDUi83HJ3HkYG1R+x574rti4L3A
         vvrw==
X-Gm-Message-State: AOJu0YxVCU8JZgg5KTae85GAHhp1prdOCMgXEDlpHeL8v4hBZbUbAfSz
	uFfVVyn2vnoFgOWcNPlYkM0X77fQW76+NxDwAKX/N1uIl0FtuGbsLMmjIdBgaKC1bBdB4t4BQzH
	1HfmseJCtlGQZCDBxBnbpdiO/OiQhx8Bw4DtfvjjPBB999YobGrY9lKKEMgUyww==
X-Gm-Gg: ASbGncvVW6m5nBxLL1VmK3jpHI8Q7kJcQsE7owqgwX4TRC+UKwFRJJ1UHB85zQ6RqH4
	Q1A9z8h/572szHGZUMY3kiPp6feS5pXkVEpMXc51OPQ5GfU1tVhJ6g7xP+ErtMDU4/VMSa1Nxkx
	0Lr0HtRDoIh0uAIYbwGCGpI7hq9zKvt6wNuRn2ADYGp7CLPR9jFwUTVQNshSq37PFmKXhdDlKmV
	q/w4BT6Sq8csav2gicA44aCIpPVX05MAPj1SyXnL1xwI3N4t8sCZojT7ZrIuIRNx+rufYNAQi0g
	cR0RGWgbvdXsaF6yzgh1udFpgbRJLsZsnOiHogiSN+kx4L/Ifp1b2+bJDHW4+fc=
X-Received: by 2002:a17:90b:5485:b0:312:26d9:d5b2 with SMTP id 98e67ed59e1d1-313f1b75bd0mr33133451a91.0.1750270153062;
        Wed, 18 Jun 2025 11:09:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMWKFEPr2Bw6jSAAMdj4BgU9vhdZiE7sq/xqvOn+nikk+2i4enlM4aryGN42bHoCa+XwWxLg==
X-Received: by 2002:a17:90b:5485:b0:312:26d9:d5b2 with SMTP id 98e67ed59e1d1-313f1b75bd0mr33133399a91.0.1750270152505;
        Wed, 18 Jun 2025 11:09:12 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a23c133sm303451a91.15.2025.06.18.11.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 11:09:11 -0700 (PDT)
Date: Thu, 19 Jun 2025 02:09:07 +0800
From: Zorro Lang <zlang@redhat.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
	john.g.garry@oracle.com, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com
Subject: Re: [PATCH v5 2/3] generic: various atomic write tests with hardware
 and scsi_debug
Message-ID: <20250618180907.5r2p6gs77felb2o4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250616215213.36260-1-catherine.hoang@oracle.com>
 <20250616215213.36260-3-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616215213.36260-3-catherine.hoang@oracle.com>

On Mon, Jun 16, 2025 at 02:52:12PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Simple tests of various atomic write requests and a (simulated) hardware
> device.
> 
> The first test performs basic multi-block atomic writes on a scsi_debug device
> with atomic writes enabled. We test all advertised sizes between the atomic
> write unit min and max. We also ensure that the write fails when expected, such
> as when attempting buffered io or unaligned directio.
> 
> The second test is similar to the one above, except that it verifies multi-block
> atomic writes on actual hardware instead of simulated hardware. The device used
> in this test is not required to support atomic writes.
> 
> The final two tests ensure multi-block atomic writes can be performed on various
> interweaved mappings, including written, mapped, hole, and unwritten. We also
> test large atomic writes on a heavily fragmented filesystem. These tests are
> separated into reflink (shared) and non-reflink tests.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/atomicwrites    |  10 ++++
>  tests/generic/1222     |  88 ++++++++++++++++++++++++++++
>  tests/generic/1222.out |  10 ++++
>  tests/generic/1223     |  66 +++++++++++++++++++++
>  tests/generic/1223.out |   9 +++
>  tests/generic/1224     |  86 ++++++++++++++++++++++++++++
>  tests/generic/1224.out |  16 ++++++
>  tests/generic/1225     | 127 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1225.out |  21 +++++++
>  9 files changed, 433 insertions(+)
>  create mode 100755 tests/generic/1222
>  create mode 100644 tests/generic/1222.out
>  create mode 100755 tests/generic/1223
>  create mode 100644 tests/generic/1223.out
>  create mode 100755 tests/generic/1224
>  create mode 100644 tests/generic/1224.out
>  create mode 100755 tests/generic/1225
>  create mode 100644 tests/generic/1225.out
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index ac4facc3..95d545a6 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -136,3 +136,13 @@ _test_atomic_file_writes()
>      $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
>          echo "atomic write requires offset to be aligned to bsize"
>  }
> +
> +_simple_atomic_write() {
> +	local pos=$1
> +	local count=$2
> +	local file=$3
> +	local directio=$4
> +
> +	echo "testing pos=$pos count=$count file=$file directio=$directio" >> $seqres.full
> +	$XFS_IO_PROG $directio -c "pwrite -b $count -V 1 -A -D $pos $count" $file >> $seqres.full
> +}
> diff --git a/tests/generic/1222 b/tests/generic/1222
> new file mode 100755
> index 00000000..c718b244
> --- /dev/null
> +++ b/tests/generic/1222
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1222
> +#
> +# Validate multi-fsblock atomic write support with simulated hardware support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/scsi_debug
> +. ./common/atomicwrites
> +
> +_cleanup()
> +{
> +	_scratch_unmount &>/dev/null
> +	_put_scsi_debug_dev &>/dev/null
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +_require_scsi_debug
> +_require_scratch_nocheck
> +# Format something so that ./check doesn't freak out
> +_scratch_mkfs >> $seqres.full
> +
> +# 512b logical/physical sectors, 512M size, atomic writes enabled
> +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> +
> +export SCRATCH_DEV=$dev

These's a generic test case. As you use scsi_debug device. I'm wondering do we
need _require_block_device? Can this case works with FSTYP=nfs, cifs, tmpfs, overlayfs
and so on?

> +unset USE_EXTERNAL
> +
> +_require_scratch_write_atomic
> +_require_scratch_write_atomic_multi_fsblock
> +
> +xfs_io -c 'help pwrite' | grep -q RWF_ATOMIC || _notrun "xfs_io pwrite -A failed"
> +xfs_io -c 'help falloc' | grep -q 'not found' && _notrun "xfs_io falloc failed"

Can't these two lines be replaced by _require_xfs_io? e.g.
_require_xfs_io_command pwrite -A
_require_xfs_io_command falloc

> +
> +echo "scsi_debug atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full

_require_xfs_io_command statx -r ?

> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +echo "all should work"
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +_simple_atomic_write $sector_size $min_awu $testfile -d
> +
> +_scratch_unmount
> +_put_scsi_debug_dev
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1222.out b/tests/generic/1222.out
> new file mode 100644
> index 00000000..158b52fa
> --- /dev/null
> +++ b/tests/generic/1222.out
> @@ -0,0 +1,10 @@
> +QA output created by 1222
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +all should work
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1223 b/tests/generic/1223
> new file mode 100755
> index 00000000..db242e7f
> --- /dev/null
> +++ b/tests/generic/1223
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1223
> +#
> +# Validate multi-fsblock atomic write support with or without hw support
> +#

Same review points with above case.

> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_DEV)
> +min_awu=$(_get_atomic_write_unit_min $testfile)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +
> +# try outside the advertised sizes
> +echo "two EINVAL for unsupported sizes"
> +min_i=$((min_awu / 2))
> +_simple_atomic_write $min_i $min_i $testfile -d
> +max_i=$((max_awu * 2))
> +_simple_atomic_write $max_i $max_i $testfile -d
> +
> +# try all of the advertised sizes
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +done
> +
> +# does not support buffered io
> +echo "one EOPNOTSUPP for buffered atomic"
> +_simple_atomic_write 0 $min_awu $testfile
> +
> +# does not support unaligned directio
> +echo "one EINVAL for unaligned directio"
> +if [ $sector_size -lt $min_awu ]; then
> +	_simple_atomic_write $sector_size $min_awu $testfile -d
> +else
> +	# not supported, so fake the output
> +	echo "pwrite: Invalid argument"
> +fi
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/1223.out b/tests/generic/1223.out
> new file mode 100644
> index 00000000..edf5bd71
> --- /dev/null
> +++ b/tests/generic/1223.out
> @@ -0,0 +1,9 @@
> +QA output created by 1223
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/generic/1224 b/tests/generic/1224
> new file mode 100755
> index 00000000..3f83eebc
> --- /dev/null
> +++ b/tests/generic/1224
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1224
> +#
> +# reflink tests for large atomic writes with mixed mappings
> +#

Same review points as above case.

> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +_require_xfs_io_command pwrite -A
> +_require_cp_reflink

Do you just need _require_cp_reflink, or need _require_scratch_reflink too?

Thanks,
Zorro

> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 262144 || _notrun "test requires atomic writes up to 256k"
> +
> +min_awu=$(_get_atomic_write_unit_min $file1)
> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# reflink tests (files with shared extents)
> +
> +echo "atomic write shared data and unshared+shared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic write shared data and shared+unshared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic overwrite unshared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic write shared+unshared+shared data"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +echo "atomic write interweaved hole+unwritten+written+reflinked"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1224.out b/tests/generic/1224.out
> new file mode 100644
> index 00000000..89e5cd5a
> --- /dev/null
> +++ b/tests/generic/1224.out
> @@ -0,0 +1,16 @@
> +QA output created by 1224
> +atomic write shared data and unshared+shared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic write shared data and shared+unshared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic overwrite unshared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic write shared+unshared+shared data
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +atomic write interweaved hole+unwritten+written+reflinked
> +4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
> +93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
> diff --git a/tests/generic/1225 b/tests/generic/1225
> new file mode 100755
> index 00000000..b940afd3
> --- /dev/null
> +++ b/tests/generic/1225
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1225
> +#
> +# basic tests for large atomic writes with mixed mappings
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/filter
> +. ./common/reflink
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_scratch_write_atomic_multi_fsblock
> +
> +_scratch_mkfs_sized $((500 * 1048576)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +file1=$SCRATCH_MNT/file1
> +file2=$SCRATCH_MNT/file2
> +file3=$SCRATCH_MNT/file3
> +
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $file1)
> +test $max_awu -ge 65536 || _notrun "test requires atomic writes up to 64k"
> +
> +min_awu=$(_get_atomic_write_unit_min $file1)
> +test $min_awu -le 4096 || _notrun "test requires atomic writes down to 4k"
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# non-reflink tests
> +
> +echo "atomic write hole+mapped+hole"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write adjacent mapped+hole and hole+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write mapped+hole+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write unwritten+mapped+unwritten"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write adjacent mapped+unwritten and unwritten+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write mapped+unwritten+mapped"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -fc "falloc 0 4096000" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write interweaved hole+unwritten+written"
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_file_rainbow $blksz $nr $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write at EOF"
> +dd if=/dev/zero of=$file1 bs=32K count=12 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 360448 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +echo "atomic write preallocated region"
> +fallocate -l 10M $file1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write max size
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +aw_max=$(_get_atomic_write_unit_max $file1)
> +cp $file1 $file1.chk
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> +
> +echo "atomic write max size on fragmented fs"
> +avail=`_get_available_space $SCRATCH_MNT`
> +filesizemb=$((avail / 1024 / 1024 - 1))
> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> +$here/src/punch-alternating $fragmentedfile
> +touch $file3
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> +md5sum $file3 | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1225.out b/tests/generic/1225.out
> new file mode 100644
> index 00000000..c5a6de04
> --- /dev/null
> +++ b/tests/generic/1225.out
> @@ -0,0 +1,21 @@
> +QA output created by 1225
> +atomic write hole+mapped+hole
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write adjacent mapped+hole and hole+mapped
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write mapped+hole+mapped
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +atomic write unwritten+mapped+unwritten
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write adjacent mapped+unwritten and unwritten+mapped
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write mapped+unwritten+mapped
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +atomic write interweaved hole+unwritten+written
> +5577e46f20631d76bbac73ab1b4ed208  SCRATCH_MNT/file1
> +atomic write at EOF
> +0e44615ab08f3e8585a374fca9a6f5eb  SCRATCH_MNT/file1
> +atomic write preallocated region
> +3acf1ace00273bc4e2bf4a8d016611ea  SCRATCH_MNT/file1
> +atomic write max size on fragmented fs
> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
> -- 
> 2.34.1
> 
> 

