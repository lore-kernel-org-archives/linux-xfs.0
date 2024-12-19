Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8335A225782;
	Thu, 19 Dec 2024 15:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734621232; cv=none; b=U14IeAG2MmQ1yBwpyxPepguWUxMdr05chWhccoCDSiHTs//AssDZ0huHELoxhmNaztB5/MEvuq1Ex870T0h5jxnUGXuiLAwCLgaOjMTX1CnRpJrIhEYVd8aDSTNj/zdD6N4SfJneG9VRgK8GHqYiL07Do/Dbe2yo6FrOVOLgdks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734621232; c=relaxed/simple;
	bh=huv/0kdznuz2tXxZVFEKAN6yQCK2KTrv/jNvF17NDWk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=UxU9NocVuf1kXcAs2Zdx9PeMQ0oN5SzeAO5ac21jJD9IcN+NNe6GwAx89wIpJrrjwv6PGTQc5pXmtZdXPksFmttFQh6nX/q697aXNaB/fj8CPw2TVUd/DWCth4YcPHMUJd2HomJ2SxIAJf+et0SjIXPtU3CF8ms3Czk87CJ0gkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sBIXAQTI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sBIXAQTI"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJ85WFu031388;
	Thu, 19 Dec 2024 15:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0rLV2e
	zYC0ftJb4q1cxvnRy/jIifNQm9OlolPti1X0c=; b=sBIXAQTIV5C329X0Iiew1B
	ycyEZHijV3tZwhzauZSkrInC4JPdStH/Uf2CGzJXtjghLyoYB2ARVTz33K/Fo30c
	YwaYH/1G0j7cOBAMxHx6yrPBMBVcZt5FG6Y+FeZLvB3jdHsDq1Bmi5Cl87mK9Zu7
	fQDAyrvcJHTKHS9KRX2aKYm0Mg+GT6sPWkJ0kd6YEYjfnI1/OjC4dt6YaCpxq02P
	E1w0UF8fEmwemFMHeYEUcNNxcyFF8Au1JQFVHo57iALi0FDJxyIAEgaOmdDn0h2Q
	kToTN/d84YmYHrtKP/liscMtzSEMcZNNT5ArGjsWwhaDCe1TOz5hHs3tMOJKWeKA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43mfp29wn2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 15:13:44 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BJEZXpx025570;
	Thu, 19 Dec 2024 15:13:43 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43mfp29wmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 15:13:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BJBds6Z014344;
	Thu, 19 Dec 2024 15:13:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43hmqydt9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 15:13:43 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BJFDd2J56885678
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Dec 2024 15:13:39 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C42720043;
	Thu, 19 Dec 2024 15:13:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A93F420040;
	Thu, 19 Dec 2024 15:13:37 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com (unknown [9.39.22.218])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Dec 2024 15:13:37 +0000 (GMT)
Message-ID: <a6a2dc60f34ac353e5ea628a9ea1feba4800be7a.camel@linux.ibm.com>
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
From: Nirjhar Roy <nirjhar@linux.ibm.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org
Cc: ritesh.list@gmail.com, ojaswin@linux.ibm.com, fstests@vger.kernel.org,
        djwong@kernel.org, zlang@kernel.org, nirjhar@linux.ibm.com
Date: Thu, 19 Dec 2024 20:43:36 +0530
In-Reply-To: <20241217020828.28976-1-catherine.hoang@oracle.com>
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-26.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: IhOjyn86ixhDbNG21XMsgPtNzbzgh1Yz
X-Proofpoint-GUID: YOKPiZXib6nWdB1pIx7zBGjRNo67aqjr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412190120

On Mon, 2024-12-16 at 18:08 -0800, Catherine Hoang wrote:
> Add a test to validate the new atomic writes feature.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/rc         | 14 ++++++++
>  tests/xfs/611     | 81
> +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/611.out |  2 ++
Now that ext4 also has support for block atomic writes, do you think it
appropritate to put it under generic?
>  3 files changed, 97 insertions(+)
>  create mode 100755 tests/xfs/611
>  create mode 100644 tests/xfs/611.out
> 
> diff --git a/common/rc b/common/rc
> index 2ee46e51..b9da749e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5148,6 +5148,20 @@ _require_scratch_btime()
>  	_scratch_unmount
>  }
>  
> +_require_scratch_write_atomic()
> +{
> +	_require_scratch
> +	_scratch_mkfs > /dev/null 2>&1
> +	_scratch_mount
Minor: Do we need the _scratch_mount and _scratch_unmount? We can
directly statx the underlying device too, right?
> +
> +	export STATX_WRITE_ATOMIC=0x10000
> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT
> \
> +		| grep atomic >>$seqres.full 2>&1 || \
> +		_notrun "write atomic not supported by this filesystem"
Are we assuming that the SCRATCH_DEV supports atomic writes here? If
not, do you think the idea of checking if the underlying device
supports atomic writes will be appropriate here?

I tried running the test with a loop device (with no atomic writes
support) and this function did not execute _notrun. The test did fail
expectedly with "atomic write min 0, should be fs block size 4096".
However, the test shouldn't have begun or reached this stage if the
underlying device doesn't support atomic writes, right?

Maybe look at how scsi_debug is used? Tests like tests/generic/704 and
common/scsi_debug?
> +
> +	_scratch_unmount
> +}
> +
>  _require_inode_limits()
>  {
>  	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
> diff --git a/tests/xfs/611 b/tests/xfs/611
> new file mode 100755
> index 00000000..a26ec143
> --- /dev/null
> +++ b/tests/xfs/611
> @@ -0,0 +1,81 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 611
> +#
> +# Validate atomic write support
> +#
> +. ./common/preamble
> +_begin_fstest auto quick rw
> +
> +_supported_fs xfs
> +_require_scratch
> +_require_scratch_write_atomic
> +
> +test_atomic_writes()
> +{
> +    local bsize=$1
> +
> +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
> +    _scratch_mount
> +    _xfs_force_bdev data $SCRATCH_MNT
> +
> +    testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    file_min_write=$($XFS_IO_PROG -c "statx -r -m
> $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_min | cut -d ' ' -f 3)
> +    file_max_write=$($XFS_IO_PROG -c "statx -r -m
> $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_unit_max | cut -d ' ' -f 3)
> +    file_max_segments=$($XFS_IO_PROG -c "statx -r -m
> $STATX_WRITE_ATOMIC" $testfile | \
> +        grep atomic_write_segments_max | cut -d ' ' -f 3)
> +
Minor: A refactoring suggestion. Can we put the commands to fetch the
atomic_write_unit_min , atomic_write_unit_max and
atomic_write_segments_max in a function and re-use them? We are using
these commands to get bdev_min_write/bdev_max_write as well, so a
function might make the code look more compact. Some maybe something
like:

_get_at_wr_unit_min()
{
	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | grep
atomic_write_unit_min | \
		grep -o '[0-9]\+'
}

_get_at_wr_unit_max()
{
	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | grep
atomic_write_unit_max | \
		grep -o '[0-9]\+'
}
 and then,
file_min_write=$(_get_at_wr_unit_min $testfile) and similarly for file_max_write, file_max_segments, bdev_min_write/bdev_max_write


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
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize"
> $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
is "$XFS_IO_PROG -dc pwrite -A -D 0 $bsize" $testfile actually making a
pwritev2 syscall? 

Let's look at the output below:
(tested with latest master of xfsprogs-dev (commit 90d6da68) on
pagesize and block size 4k (x86_64 vm)

mount /dev/sdc  /mnt1/test
touch /mnt1/test/new
strace -f xfs_io -c "pwrite -A -D 0 4096" /mnt1/test/new

<last few lines>
openat(AT_FDCWD, "/mnt1/test/new", O_RDWR) = 3
...
...
pwrite64(3,
"\315\315\315\315\315\315\315\315\315\315\315\315\315\315\315\315\315\3
15\315\315\315\315\315\315\315\315\315\315\315\315\315\315"..., 4096,
0) = 4096
newfstatat(1, "", {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x1),
...}, AT_EMPTY_PATH) = 0
write(1, "wrote 4096/4096 bytes at offset "..., 34wrote 4096/4096 bytes
at offset 0
) = 34
write(1, "4 KiB, 1 ops; 0.0001 sec (23.819"..., 644 KiB, 1 ops; 0.0001
sec (23.819 MiB/sec and 6097.5610 ops/sec)
) = 64
exit_group(0)           

So the issues are as follows:
1. file /mnt1/test/new is NOT opened with O_DIRECT flag i.e, direct io
mode which is one of the requirements for atomic write (buffered io
doesn't support atomic write, correct me if I am wrong). 
2. pwrite64 doesn't take the RWF_ATOMIC flag and hence I think this
write is just a non-atomic write with no stdout output difference as
such.

Also if you look at the function 

do_pwrite() in xfsprogs-dev/io/pwrite.c 

static ssize_t
do_pwrite(
	int		fd,
	off_t		offset,
	long long	count,
	size_t		buffer_size,
	int		pwritev2_flags)
{
	if (!vectors)
		return pwrite(fd, io_buffer, min(count, buffer_size),
offset);

	return do_pwritev(fd, offset, count, pwritev2_flags);
}

it will not call pwritev/pwritev2 unless we have vectors for which you
will need -V parameter with pwrite subcommand of xfs_io. 


So I think the correct way to do this would be the following:

bytes_written=$($XFS_IO_PROGS -c "open -d $testfile" -c "pwrite -A -D
-V 1 0 $bsize" | grep wrote | awk -F'[/ ]' '{print $2}').

This also bring us to 2 more test cases that we can add:

a. Atomic write with vec count > 1
$XFS_IO_PROGS -c "open -d $testfile" -c "pwrite -A -D -V 2 0 $bsize"
(This should fail with Invalid argument since currently iovec count is
restricted to 1)

b.
Open a file withOUT O_DIRECT and try to perform an atomic write. This
should fail with Operation not Supported (EOPNOTSUPP). So something
like 
$XFS_IO_PROGS -c "open -f $testfile" -c "pwrite -A -V 1 0 $bsize"

3. It is better to use -b $bsize with pwrite else, the write might be
spilitted into multiple atomic writes. For example try the following:

$XFS_IO_PROGS -c "open -fd $testfile" -c "pwrite -A -D -V 1 0 $((
$bsize * 2 ))" 
The above is expected to fail as the size of the atomic write is
greater than the limit i.e, 1 block but it will still succeed. Look at
the strace and you will see 2 pwritev2 system calls. However the
following will fail expectedly with -EINVAL:
$XFS_IO_PROGS -c "open -fd $testfile" -c "pwrite -A -D -V 1 -b $((
$bsize * 2 )) 0 $(( $bsize * 2 ))"




> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize
> failed"
> +
> +    # Check that we can perform an atomic write on an unwritten
> block
> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D $bsize $bsize"
> $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to
> unwritten block failed"
> +
> +    # Check that we can perform an atomic write on a sparse hole
> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize"
> $testfile | \
> +        grep wrote | awk -F'[/ ]' '{print $2}')
> +    test $bytes_written -eq $bsize || echo "atomic write to sparse
> hole failed"
> +
> +    # Reject atomic write if len is out of bounds
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile 2>>
> $seqres.full && \
> +        echo "atomic write len=$((bsize - 1)) should fail"
> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile 2>>
> $seqres.full && \
> +        echo "atomic write len=$((bsize + 1)) should fail"
Have we covered the scenario where the offset % len != 0 Should fail -
Should fail with Invalid arguments -EINVAL. 

Also do you think adding similar tests with raw writes to the
underlying devices bypassing the fs layer will add some value? There
are slight less strict or different rules in the block layer which IMO
worth to be tested. Please let me know your thoughts.
> +
> +    _scratch_unmount
> +}
> +
> +bdev_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC"
> $SCRATCH_DEV | \
> +    grep atomic_write_unit_min | cut -d ' ' -f 3)
> +bdev_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC"
> $SCRATCH_DEV | \
> +    grep atomic_write_unit_max | cut -d ' ' -f 3)
> +
Similar comment before - Refactor this into a function. 
> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> +    _scratch_mkfs_xfs_supported -b size=$bsize >> $seqres.full 2>&1
> && \
> +        test_atomic_writes $bsize
> +done;
Minor: This might fail on some archs(x86_64) if the kernel isn't
compiled without CONFIG_TRANSPARENT_HUGEPAGE to enable block size 
greater than 4k on x86_64. 

--
NR
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/611.out b/tests/xfs/611.out
> new file mode 100644
> index 00000000..b8a44164
> --- /dev/null
> +++ b/tests/xfs/611.out
> @@ -0,0 +1,2 @@
> +QA output created by 611
> +Silence is golden

