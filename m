Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E7B288503;
	Thu, 22 May 2025 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747911201; cv=none; b=ES/kdRw/xatFlGcmVceFosg/rmpi6SDtTtGvPLnVUTosz649YXzE+ZF8rT6n3ThelxsmflkoP26H78FgvoG3Uq0WyxBgRhTJA29w5T0OAsjrZNbZEs/lUrsCKZekHtMz16nEwtrp8zYGsteUCuDZT99BoDuafFGe0LLyPRW91kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747911201; c=relaxed/simple;
	bh=EobsxZRkLHONe22Zc6KI3dkaTz2w2mLwcG97oSWXCaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UtaxOmD8Uwb9VkNjoTWvatv0PPEvA5fmRTn2diYOncL0sqdAjXXXr1u6QpjCmn0lti/U0JriG2qFi8F5U4XAJi1pBpoJBUTvNmLidgpPNdCGWxLMbcLe9UYGkgFoMYR5kOjcih82shhe6c/WmHNxvqO3xns5e3aodjOYOpkDKc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jEtW5IhA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jEtW5IhA"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9F1nW020923;
	Thu, 22 May 2025 10:53:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uJMJp7DsKlI+tIFSP8CI3IyhdSduVE
	fjwvChR8ahF28=; b=jEtW5IhAk18Pr2YbwzCR4n0faaiN7QtJMvjkASNrH2LM83
	hk/jEemfVRDBDkb583scLXBJZ0w3EXo5sgsTAhH9r2FJ/8ePC6cNKOy3Dqb0xNeG
	tyzP8yaZPBHOY94BvkyQhErvSV81DimtrKXpLKoUP+L7H2M0fhijrNBvMDnyEXeB
	nClQFKKjO9ZbjIHWoGZoO38fmQekEOtgNVyF2AtrJaylk6b3kBBkbNksjNw2o3WK
	e1Pj8ULmbx0CP37qZhuLag5iQeyWUf5fRd8BGxY8hjHauejKF+PW2TlH3rMDE9wm
	61512FTxlCfKl+4MEh7gRkNepHI7Y85os2YyUcbg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t14jgem2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:53:13 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54MAr8Nv009667;
	Thu, 22 May 2025 10:53:13 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46t14jgekw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:53:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M9IAfC032056;
	Thu, 22 May 2025 10:53:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46rwmq92rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 10:53:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54MArAbc42336642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 10:53:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7005520043;
	Thu, 22 May 2025 10:53:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A30D720040;
	Thu, 22 May 2025 10:53:08 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.109.219.249])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 22 May 2025 10:53:08 +0000 (GMT)
Date: Thu, 22 May 2025 16:23:05 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org,
        john.g.garry@oracle.com, ritesh.list@gmail.com
Subject: Re: [PATCH v2 6/6] generic: various atomic write tests with
 scsi_debug
Message-ID: <aC8CETEDplUAwB5C@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-7-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520013400.36830-7-catherine.hoang@oracle.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: piB33txCezfl_VwYa4J_FQKF-TJQejw0
X-Authority-Analysis: v=2.4 cv=XOkwSRhE c=1 sm=1 tr=0 ts=682f0219 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=BZUj_GCgx7i1EvMinxoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwNyBTYWx0ZWRfX3nY0EZzCkQfH F2gxbMvkwTst1GHVGH/RfPnHa/3RXTyXEpwwKbVJMJFM0xdWlxXIM3eTiOKR5DUiL2IUhSMY1pE S6a3IDwPvqyZB1ti6TtzkL1k9iCJlLPkXSbOkjPaOav1Eo+c7A9SgWFCunSmKY1dTAZWQADAUSP
 6KXVQRUcSZputVKrRAceS7I6dwYuh+YuJqCMUQH0RMTY2A9KsdAfRKGyp/K+dUY/T0sUfop1u5j 64cwWya4aedGrtTYNvjI7bpSfNyHmdeFrRBHJWTs+5H/0wtwB1juJQfZ6k1xQqmY7kAjbAnacKs Ctb0W+OfbedEFtzzdXPUIWS3SJc9W8x5l4zZO4jPUNQuJi2g+/Q7IKeaudkHBVZMturNva7gObi
 EkUBA5jQcxpBtgODAmSYTTlzR+z0wGbZM9zL8fxrZWClF1Hmf8B3W2GXgKOSdBptkqlHpSwF
X-Proofpoint-GUID: QMep7Q0eS4ILcktXLStjNREYgFbuj20C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505220107

On Mon, May 19, 2025 at 06:34:00PM -0700, Catherine Hoang wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Simple tests of various atomic write requests and a (simulated) hardware
> device.

Hey Catherine, Darrick,

So while working on ext4 multi block we have also written some tests
which we plan to upstream soon. Ofcourse some were sort of identical to
the ones added here. So here and there while reviewing I might add a few
things we did differently, which we can think of incorporating.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/atomicwrites    |  10 +++
>  tests/generic/1222     |  86 +++++++++++++++++++++++++
>  tests/generic/1222.out |  10 +++
>  tests/generic/1223     |  66 +++++++++++++++++++
>  tests/generic/1223.out |   9 +++
>  tests/generic/1224     | 140 +++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1224.out |  17 +++++
>  tests/xfs/1216         |  67 ++++++++++++++++++++
>  tests/xfs/1216.out     |   9 +++
>  tests/xfs/1217         |  70 +++++++++++++++++++++
>  tests/xfs/1217.out     |   3 +
>  tests/xfs/1218         |  59 +++++++++++++++++
>  tests/xfs/1218.out     |  15 +++++
>  13 files changed, 561 insertions(+)
>  create mode 100755 tests/generic/1222
>  create mode 100644 tests/generic/1222.out
>  create mode 100755 tests/generic/1223
>  create mode 100644 tests/generic/1223.out
>  create mode 100644 tests/generic/1224
>  create mode 100644 tests/generic/1224.out
>  create mode 100755 tests/xfs/1216
>  create mode 100644 tests/xfs/1216.out
>  create mode 100755 tests/xfs/1217
>  create mode 100644 tests/xfs/1217.out
>  create mode 100644 tests/xfs/1218
>  create mode 100644 tests/xfs/1218.out
> 
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 391bb6f6..c75c3d39 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -115,3 +115,13 @@ _test_atomic_file_writes()
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
> index 00000000..9d02bd70
> --- /dev/null
> +++ b/tests/generic/1222
> @@ -0,0 +1,86 @@
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
> +unset USE_EXTERNAL
> +
> +_require_scratch_write_atomic

How about using a _require_scratch_write_atomic_multi_fsblock() helper.
This will help _notrun tests which are not really relevant for kernels
with single block aw support, like mixed mapping tests.

> +_require_atomic_write_test_commands
> +
> +echo "scsi_debug atomic write properties" >> $seqres.full
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
> +echo "all should work"
> +for ((i = min_awu; i <= max_awu; i *= 2)); do
> +	$XFS_IO_PROG -f -c "falloc 0 $((max_awu * 2))" -c fsync $testfile
> +	_test_atomic_file_writes $i $testfile
> +	_simple_atomic_write $i $i $testfile -d
Why do we need the _simple_atomic_write here?
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
> index 00000000..8a77386e
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
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_scratch
> +_require_atomic_write_test_commands
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
> +	_simple_atomic_write $i $i $testfile -d
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
> new file mode 100644
> index 00000000..fb178be4
> --- /dev/null
> +++ b/tests/generic/1224
> @@ -0,0 +1,140 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1224
> +#
> +# test large atomic writes with mixed mappings
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
> +_require_xfs_io_command pwrite -A
> +_require_cp_reflink
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

I usually use a scsi_debug disk with 64kb max awu. I can always use 256k
but any reason why we need to have it this high?
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
> +# atomic write shared data and unshared+shared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write shared data and shared+unshared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic overwrite unshared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write shared+unshared+shared data
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +cp --reflink=always $file1 $file2
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# atomic write interweaved hole+unwritten+written+reflinked
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +blksz=4096
> +nr=32
> +_weave_reflink_rainbow $blksz $nr $file1 $file2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +md5sum $file2 | _filter_scratch
> +
> +# non-reflink tests
> +
> +# atomic write hole+mapped+hole
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write adjacent mapped+hole and hole+mapped
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 32768" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 32768 32768" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write mapped+hole+mapped
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 4096000 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -D -V1 61440 4096" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch

I think some combos for unwritten would be good as well.

> +
> +# atomic write at EOF
> +dd if=/dev/zero of=$file1 bs=128K count=3 conv=fsync >>$seqres.full 2>&1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 262144 262144" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write preallocated region
> +fallocate -l 10M $file1
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file1 >>$seqres.full 2>&1
> +md5sum $file1 | _filter_scratch
> +
> +# atomic write max size
> +dd if=/dev/zero of=$file1 bs=1M count=10 conv=fsync >>$seqres.full 2>&1
> +aw_max=$(_get_atomic_write_unit_max $file1)
> +cp $file1 $file1.chk
> +$XFS_IO_PROG -dc "pwrite -D -V1 0 $aw_max" $file1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -c "pwrite 0 $aw_max" $file1.chk >>$seqres.full 2>&1
> +cmp -s $file1 $file1.chk || echo "file1 doesnt match file1.chk"
> +#md5sum $file1 | _filter_scratch
> +
> +# atomic write max size on fragmented fs
> +avail=`_get_available_space $SCRATCH_MNT`
> +filesizemb=$((avail / 1024 / 1024 - 1))
> +fragmentedfile=$SCRATCH_MNT/fragmentedfile
> +$XFS_IO_PROG -fc "falloc 0 ${filesizemb}m" $fragmentedfile
> +$here/src/punch-alternating $fragmentedfile
> +touch $file3
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 0 65536" $file3 >>$seqres.full 2>&1
> +md5sum $file3 | _filter_scratch

This will have a unwrit to hole sort of mapping.  Maybe we should stress
with a more random layout. A rough snippet with multiple iterations to
stress this a bit more:

		operations=("W" "H" "U")

    for ((iteration=1; iteration<=10; iteration++)); do
        echo "=== Mixed Mapping Test Iteration $iteration ===" >> $seqres.full

        $XFS_IO_PROG -c "truncate 0" $testfile >> $seqres.full

        # Create a random mixed mapping for all blocks in the 64K region
        echo "Random block mapping pattern:" >> $seqres.full
        off=0
        mapping=""

        for ((i=0; i<num_blocks; i++)); do
            # Randomly select an operation (W, H, or U)
            index=$((RANDOM % ${#operations[@]}))
            map="${operations[$index]}"
            mapping="${mapping}${map}"

            echo "Block $i: Operation $map at offset $off" >> $seqres.full

            case "$map" in
                "W")
                    $XFS_IO_PROG -dc "pwrite -S 0x61 -b $blksz $off $blksz" $testfile >> $seqres.full
                    ;;
                "H")
                    # No operation needed for hole
                    ;;
                "U")
                    $XFS_IO_PROG -c "falloc $off $blksz" $testfile >> $seqres.full
                    ;;
            esac
            off=$((off + blksz))
        done

        sync $testfile
        echo "Full mapping pattern: $mapping" >> $seqres.full

        # Now perform the atomic write over the entire region with O_SYNC
        echo "Performing O_SYNC atomic write over the entire $awu_max region" >> $seqres.full
        bytes_written=$($XFS_IO_PROG -dsc "pwrite -A -V1 -b $awu_max 0 $awu_max" $testfile | \
                      grep wrote | awk -F'[/ ]' '{print $2}')

        # Check if the atomic write was successful
        test $bytes_written -eq $awu_max || echo "atomic write len=$awu_max failed"
        check_data_integrity
        echo "Iteration $iteration completed: OK" >> $seqres.full
    done

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1224.out b/tests/generic/1224.out
> new file mode 100644
> index 00000000..1c788420
> --- /dev/null
> +++ b/tests/generic/1224.out
> @@ -0,0 +1,17 @@
> +QA output created by 1224
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +111ce6bf29d5b1dbfb0e846c42719ece  SCRATCH_MNT/file1
> +f1c9645dbc14efddc7d8a322685f26eb  SCRATCH_MNT/file2
> +4edfbc469bed9965219ea80c9ae54626  SCRATCH_MNT/file1
> +93243a293a9f568903485b0b2a895815  SCRATCH_MNT/file2
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +9464b66461bc1d20229e1b71733539d0  SCRATCH_MNT/file1
> +75572c4929fde8faf131e84df4c6a764  SCRATCH_MNT/file1
> +27a248351cd540bc9ac2c2dc841abca2  SCRATCH_MNT/file1
> +27c9068d1b51da575a53ad34c57ca5cc  SCRATCH_MNT/file3
> diff --git a/tests/xfs/1216 b/tests/xfs/1216
> new file mode 100755
> index 00000000..04aa77fe
> --- /dev/null
> +++ b/tests/xfs/1216
> @@ -0,0 +1,67 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1216
> +#
> +# Validate multi-fsblock realtime file atomic write support with or without hw
> +# support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +
> +_require_realtime
> +_require_scratch
> +_require_atomic_write_test_commands
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +sector_size=$(blockdev --getss $SCRATCH_RTDEV)
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
> +	_simple_atomic_write $i $i $testfile -d
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
> diff --git a/tests/xfs/1216.out b/tests/xfs/1216.out
> new file mode 100644
> index 00000000..51546082
> --- /dev/null
> +++ b/tests/xfs/1216.out
> @@ -0,0 +1,9 @@
> +QA output created by 1216
> +two EINVAL for unsupported sizes
> +pwrite: Invalid argument
> +pwrite: Invalid argument
> +one EOPNOTSUPP for buffered atomic
> +pwrite: Operation not supported
> +one EINVAL for unaligned directio
> +pwrite: Invalid argument
> +Silence is golden
> diff --git a/tests/xfs/1217 b/tests/xfs/1217
> new file mode 100755
> index 00000000..0816d05f
> --- /dev/null
> +++ b/tests/xfs/1217
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1217
> +#
> +# Check that software atomic writes can complete an operation after a crash.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw atomicwrites
> +
> +. ./common/atomicwrites
> +. ./common/inject
> +. ./common/filter
> +
> +_require_scratch
> +_require_atomic_write_test_commands
> +_require_xfs_io_error_injection "free_extent"
> +_require_test_program "punch-alternating"
> +
> +echo "scratch device atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_RTDEV >> $seqres.full
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +testfile=$SCRATCH_MNT/testfile
> +touch $testfile
> +
> +echo "filesystem atomic write properties" >> $seqres.full
> +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> +
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +
> +test $max_awu -gt $((bsize * 2)) || \
> +	_notrun "max atomic write $max_awu less than 2 fsblocks $bsize"
> +
> +# Create a fragmented file to force a software fallback
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile >> $seqres.full
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((max_awu * 2))" $testfile.check >> $seqres.full
> +$here/src/punch-alternating $testfile
> +$here/src/punch-alternating $testfile.check
> +$XFS_IO_PROG -c "pwrite -S 0xcd 0 $max_awu" $testfile.check >> $seqres.full
> +$XFS_IO_PROG -c syncfs $SCRATCH_MNT
> +
> +# inject an error to force crash recovery on the second block
> +_scratch_inject_error "free_extent"
> +_simple_atomic_write 0 $max_awu $testfile -d >> $seqres.full
> +
> +# make sure we're shut down
> +touch $SCRATCH_MNT/barf 2>&1 | _filter_scratch
> +
> +# check that recovery worked
> +_scratch_cycle_mount
> +
> +test -e $SCRATCH_MNT/barf && \
> +	echo "saw $SCRATCH_MNT/barf that should not exist"
> +
> +if ! cmp -s $testfile $testfile.check; then
> +	echo "crash recovery did not work"
> +	md5sum $testfile
> +	md5sum $testfile.check
> +
> +	od -tx1 -Ad -c $testfile >> $seqres.full
> +	od -tx1 -Ad -c $testfile.check >> $seqres.full
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/xfs/1217.out b/tests/xfs/1217.out
> new file mode 100644
> index 00000000..6e5b22be
> --- /dev/null
> +++ b/tests/xfs/1217.out
> @@ -0,0 +1,3 @@
> +QA output created by 1217
> +pwrite: Input/output error
> +touch: cannot touch 'SCRATCH_MNT/barf': Input/output error
> diff --git a/tests/xfs/1218 b/tests/xfs/1218
> new file mode 100644
> index 00000000..f3682e42
> --- /dev/null
> +++ b/tests/xfs/1218
> @@ -0,0 +1,59 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1218
> +#
> +# hardware large atomic writes error inject test
> +#
> +. ./common/preamble
> +_begin_fstest auto rw quick atomicwrites
> +
> +. ./common/filter
> +. ./common/inject
> +. ./common/atomicwrites
> +
> +_require_scratch_write_atomic
> +_require_xfs_io_command pwrite -A
> +_require_xfs_io_error_injection "bmap_finish_one"
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Create files"
> +file1=$SCRATCH_MNT/file1
> +touch $file1
> +
> +max_awu=$(_get_atomic_write_unit_max $testfile)
> +test $max_awu -ge 4096 || _notrun "cannot perform 4k atomic writes"
> +
> +file2=$SCRATCH_MNT/file2
> +_pwrite_byte 0x66 0 64k $SCRATCH_MNT/file1 >> $seqres.full
> +cp --reflink=always $file1 $file2
> +
> +echo "Check files"
> +md5sum $SCRATCH_MNT/file1 | _filter_scratch
> +md5sum $SCRATCH_MNT/file2 | _filter_scratch
> +
> +echo "Inject error"
> +_scratch_inject_error "bmap_finish_one"
> +
> +echo "Atomic write to a reflinked file"
> +$XFS_IO_PROG -dc "pwrite -A -D -V1 -S 0x67 0 4096" $file1
> +
> +echo "FS should be shut down, touch will fail"
> +touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
> +
> +echo "Remount to replay log"
> +_scratch_remount_dump_log >> $seqres.full
> +
> +echo "Check files"
> +md5sum $SCRATCH_MNT/file1 | _filter_scratch
> +md5sum $SCRATCH_MNT/file2 | _filter_scratch
> +
> +echo "FS should be online, touch should succeed"
> +touch $SCRATCH_MNT/goodfs 2>&1 | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1218.out b/tests/xfs/1218.out
> new file mode 100644
> index 00000000..02800213
> --- /dev/null
> +++ b/tests/xfs/1218.out
> @@ -0,0 +1,15 @@
> +QA output created by 1218
> +Create files
> +Check files
> +77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file1
> +77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
> +Inject error
> +Atomic write to a reflinked file
> +pwrite: Input/output error
> +FS should be shut down, touch will fail
> +touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
> +Remount to replay log
> +Check files
> +0df1f61ed02a7e9bee2b8b7665066ddc  SCRATCH_MNT/file1
> +77e3a730e3c75274c9ce310d7e39f938  SCRATCH_MNT/file2
> +FS should be online, touch should succeed
> -- 
> 2.34.1
> 
