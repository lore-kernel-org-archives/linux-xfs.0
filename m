Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2E14C62;
	Tue, 24 Dec 2024 05:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735017059; cv=none; b=ZLSC3+aRQzg5aE9UYTp10XLL4ECKbEihznLRsUrZQs8w0s41yLjiM6+e2Rw3G1M6YMEMtVm43VNwJtCOvTvORJdx4nloTcBHoHp20EhMxIGwsdpA21Y6fiWJ9iAzR4Pi23KEhG3IjAxNJ0F8ppPEx2TtO1QNAlMHtss6HpJWWRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735017059; c=relaxed/simple;
	bh=AbBCemRm6a+mV0EuqZ2v1BvHSg21q4OWxqRYIt3UQHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDbDjn2ICdpzTzSs/kUv4rmu5vZERQwG8rDcYHpR03Wfwiw/mkJaAnb+53o/DNn5ahpfdKTZk8bpYYbPXzs+am5sYBrGwgUiMlExoXAOPSmG4zWHdGPNiBUVcYZQeKpgpoly78kK+HeM9LLvsbocxu+6BZN8bsK71v+OH5khZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MQHNm1qJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MQHNm1qJ"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BNNw2wd024564;
	Tue, 24 Dec 2024 05:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nxTRo5
	MQovt+bxArhqy89qgRg4FJqEJtM3uZ/avGH/A=; b=MQHNm1qJrem+oNYmomGXvE
	P132SoOZaltYe/PADMObp2WokTdcrUEnBS4Y7ezJKosR7dbCSdAsHbN8+JKKSds3
	ZJGXyrPjokoPb4PDFoyERr2RNCgIC/IqzYYEYysoyZVLVpTL/6Kac4Z3MQbNWjjJ
	eLyIb/chvriicLxJNlf//3L8JA8dYxM7gVddHML2Zn9qVF0/mN6UZokoN3HD8pYk
	IRJcBZHJA+xS+UgCzKkVKGy8qwbr8JbDuamPvebBNVSD/ePiz5nccVyTmpA95SOi
	PY3guasYayoXFKTpim++5xMw/vaj8eYRYIUiIuFja3rOIQHg4VWfK086/o9OXNtA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43qj0h8vr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Dec 2024 05:10:46 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BO57QSb024849;
	Tue, 24 Dec 2024 05:10:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43qj0h8vr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Dec 2024 05:10:46 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BO13Y9M029913;
	Tue, 24 Dec 2024 05:10:45 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43p9gkgme8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Dec 2024 05:10:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BO5AhNx34800158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Dec 2024 05:10:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1558E2004F;
	Tue, 24 Dec 2024 05:10:43 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CF092004B;
	Tue, 24 Dec 2024 05:10:41 +0000 (GMT)
Received: from [9.39.24.171] (unknown [9.39.24.171])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Dec 2024 05:10:41 +0000 (GMT)
Message-ID: <a49db46c-d593-4cf8-bbe2-960b4b9eb820@linux.ibm.com>
Date: Tue, 24 Dec 2024 10:40:40 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: add a test for atomic writes
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, ojaswin@linux.ibm.com, fstests@vger.kernel.org,
        zlang@kernel.org
References: <20241217020828.28976-1-catherine.hoang@oracle.com>
 <a6a2dc60f34ac353e5ea628a9ea1feba4800be7a.camel@linux.ibm.com>
 <20241219172734.GE6160@frogsfrogsfrogs>
 <b6b5055f-e5ad-4e93-93b6-546584a6910a@linux.ibm.com>
 <20241223172652.GL6160@frogsfrogsfrogs>
From: Nirjhar Roy <nirjhar@linux.ibm.com>
In-Reply-To: <20241223172652.GL6160@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KdJvSW867wsr38OVQsULsqetzdID87sa
X-Proofpoint-GUID: wc9u8_MclfSI8oCJlr1Voy0CclbYK1qW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412240037


On 12/23/24 22:56, Darrick J. Wong wrote:
> On Fri, Dec 20, 2024 at 10:32:51AM +0530, Nirjhar Roy wrote:
>> On 12/19/24 22:57, Darrick J. Wong wrote:
>>> On Thu, Dec 19, 2024 at 08:43:36PM +0530, Nirjhar Roy wrote:
>>>> On Mon, 2024-12-16 at 18:08 -0800, Catherine Hoang wrote:
>>>>> Add a test to validate the new atomic writes feature.
>>>>>
>>>>> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
>>>>> ---
>>>>>    common/rc         | 14 ++++++++
>>>>>    tests/xfs/611     | 81
>>>>> +++++++++++++++++++++++++++++++++++++++++++++++
>>>>>    tests/xfs/611.out |  2 ++
>>>> Now that ext4 also has support for block atomic writes, do you think it
>>>> appropritate to put it under generic?
> Yeah, it ought to be a generic test.
>
>>>>>    3 files changed, 97 insertions(+)
>>>>>    create mode 100755 tests/xfs/611
>>>>>    create mode 100644 tests/xfs/611.out
>>>>>
>>>>> diff --git a/common/rc b/common/rc
>>>>> index 2ee46e51..b9da749e 100644
>>>>> --- a/common/rc
>>>>> +++ b/common/rc
>>>>> @@ -5148,6 +5148,20 @@ _require_scratch_btime()
>>>>>    	_scratch_unmount
>>>>>    }
>>>>> +_require_scratch_write_atomic()
>>>>> +{
>>>>> +	_require_scratch
>>>>> +	_scratch_mkfs > /dev/null 2>&1
>>>>> +	_scratch_mount
>>>> Minor: Do we need the _scratch_mount and _scratch_unmount? We can
>>>> directly statx the underlying device too, right?
>>> Yes, we need the scratch fs, because the filesystem might not support
>>> untorn writes even if the underlying block device does.  Or it can
>>> decide to constrain the supported io sizes.
>> Oh, right. We need both the file system and the device to support the atomic
>> write feature.
>>>>> +
>>>>> +	export STATX_WRITE_ATOMIC=0x10000
>>>>> +	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_MNT
>>>>> \
>>>>> +		| grep atomic >>$seqres.full 2>&1 || \
>>>>> +		_notrun "write atomic not supported by this filesystem"
>>>> Are we assuming that the SCRATCH_DEV supports atomic writes here? If
>>>> not, do you think the idea of checking if the underlying device
>>>> supports atomic writes will be appropriate here?
>>>>
>>>> I tried running the test with a loop device (with no atomic writes
>>>> support) and this function did not execute _notrun. The test did fail
>>>> expectedly with "atomic write min 0, should be fs block size 4096".
>>> Oh, yeah, awu_min==awu_max==0 should be an automatic _notrun.
>> Yes.
>>>> However, the test shouldn't have begun or reached this stage if the
>>>> underlying device doesn't support atomic writes, right?
>>> _require* helpers decide if the test preconditions have been satisfied,
>>> so this is exactly where the test would bail out.
>>>> Maybe look at how scsi_debug is used? Tests like tests/generic/704 and
>>>> common/scsi_debug?
>>>>> +
>>>>> +	_scratch_unmount
>>>>> +}
>>>>> +
>>>>>    _require_inode_limits()
>>>>>    {
>>>>>    	if [ $(_get_free_inode $TEST_DIR) -eq 0 ]; then
>>>>> diff --git a/tests/xfs/611 b/tests/xfs/611
>>>>> new file mode 100755
>>>>> index 00000000..a26ec143
>>>>> --- /dev/null
>>>>> +++ b/tests/xfs/611
>>>>> @@ -0,0 +1,81 @@
>>>>> +#! /bin/bash
>>>>> +# SPDX-License-Identifier: GPL-2.0
>>>>> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
>>>>> +#
>>>>> +# FS QA Test 611
>>>>> +#
>>>>> +# Validate atomic write support
>>>>> +#
>>>>> +. ./common/preamble
>>>>> +_begin_fstest auto quick rw
>>>>> +
>>>>> +_supported_fs xfs
>>>>> +_require_scratch
>>>>> +_require_scratch_write_atomic
>>>>> +
>>>>> +test_atomic_writes()
>>>>> +{
>>>>> +    local bsize=$1
>>>>> +
>>>>> +    _scratch_mkfs_xfs -b size=$bsize >> $seqres.full
>>>>> +    _scratch_mount
>>>>> +    _xfs_force_bdev data $SCRATCH_MNT
>>>>> +
>>>>> +    testfile=$SCRATCH_MNT/testfile
>>>>> +    touch $testfile
>>>>> +
>>>>> +    file_min_write=$($XFS_IO_PROG -c "statx -r -m
>>>>> $STATX_WRITE_ATOMIC" $testfile | \
>>>>> +        grep atomic_write_unit_min | cut -d ' ' -f 3)
>>>>> +    file_max_write=$($XFS_IO_PROG -c "statx -r -m
>>>>> $STATX_WRITE_ATOMIC" $testfile | \
>>>>> +        grep atomic_write_unit_max | cut -d ' ' -f 3)
>>>>> +    file_max_segments=$($XFS_IO_PROG -c "statx -r -m
>>>>> $STATX_WRITE_ATOMIC" $testfile | \
>>>>> +        grep atomic_write_segments_max | cut -d ' ' -f 3)
>>>>> +
>>>> Minor: A refactoring suggestion. Can we put the commands to fetch the
>>>> atomic_write_unit_min , atomic_write_unit_max and
>>>> atomic_write_segments_max in a function and re-use them? We are using
>>>> these commands to get bdev_min_write/bdev_max_write as well, so a
>>>> function might make the code look more compact. Some maybe something
>>>> like:
>>>>
>>>> _get_at_wr_unit_min()
>>> Don't reuse another English word ("at") as an abbreviation, please.
>>>
>>> _atomic_write_unit_min()
>> Okay.
>>>> {
>>>> 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | grep
>>>> atomic_write_unit_min | \
>>>> 		grep -o '[0-9]\+'
>>>> }
>>>>
>>>> _get_at_wr_unit_max()
>>>> {
>>>> 	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | grep
>>>> atomic_write_unit_max | \
>>>> 		grep -o '[0-9]\+'
>>>> }
>>>>    and then,
>>>> file_min_write=$(_get_at_wr_unit_min $testfile) and similarly for file_max_write, file_max_segments, bdev_min_write/bdev_max_write
>>>>
>>>>
>>>>> +    # Check that atomic min/max = FS block size
>>>>> +    test $file_min_write -eq $bsize || \
>>>>> +        echo "atomic write min $file_min_write, should be fs block
>>>>> size $bsize"
>>>>> +    test $file_min_write -eq $bsize || \
>>>>> +        echo "atomic write max $file_max_write, should be fs block
>>>>> size $bsize"
>>>>> +    test $file_max_segments -eq 1 || \
>>>>> +        echo "atomic write max segments $file_max_segments, should
>>>>> be 1"
>>>>> +
>>>>> +    # Check that we can perform an atomic write of len = FS block
>>>>> size
>>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize"
>>>>> $testfile | \
>>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>> is "$XFS_IO_PROG -dc pwrite -A -D 0 $bsize" $testfile actually making a
>>>> pwritev2 syscall?
>>>>
>>>> Let's look at the output below:
>>>> (tested with latest master of xfsprogs-dev (commit 90d6da68) on
>>>> pagesize and block size 4k (x86_64 vm)
>>>>
>>>> mount /dev/sdc  /mnt1/test
>>>> touch /mnt1/test/new
>>>> strace -f xfs_io -c "pwrite -A -D 0 4096" /mnt1/test/new
>>> You need to pass -d to xfs_io to get directio mode.  The test does that,
>>> but your command line doesn't.
>> Yes. Sorry I missed that.
>>>> <last few lines>
>>>> openat(AT_FDCWD, "/mnt1/test/new", O_RDWR) = 3
>>>> ...
>>>> ...
>>>> pwrite64(3,
>>>> "\315\315\315\315\315\315\315\315\315\315\315\315\315\315\315\315\315\3
>>>> 15\315\315\315\315\315\315\315\315\315\315\315\315\315\315"..., 4096,
>>>> 0) = 4096
>>> That seems like a bug though.  "pwrite -A -D -V1 0 4096"?
>> Sorry, what is the bug that you are pointing out here?
>>
>> The command given by you i.e,  xfs_io -dc "pwrite -A -D -V1 4096" <path>
>> works fine.
> Yeah, sorry, I was clumsily agreeing with your version.  Zarro boogs
> here, as it were. :)
>
> --D

Okay got it.

--

NR

>
>> --
>>
>> NR
>>
>>>> newfstatat(1, "", {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x1),
>>>> ...}, AT_EMPTY_PATH) = 0
>>>> write(1, "wrote 4096/4096 bytes at offset "..., 34wrote 4096/4096 bytes
>>>> at offset 0
>>>> ) = 34
>>>> write(1, "4 KiB, 1 ops; 0.0001 sec (23.819"..., 644 KiB, 1 ops; 0.0001
>>>> sec (23.819 MiB/sec and 6097.5610 ops/sec)
>>>> ) = 64
>>>> exit_group(0)
>>>>
>>>> So the issues are as follows:
>>>> 1. file /mnt1/test/new is NOT opened with O_DIRECT flag i.e, direct io
>>>> mode which is one of the requirements for atomic write (buffered io
>>>> doesn't support atomic write, correct me if I am wrong).
>>>> 2. pwrite64 doesn't take the RWF_ATOMIC flag and hence I think this
>>>> write is just a non-atomic write with no stdout output difference as
>>>> such.
>>>>
>>>> Also if you look at the function
>>>>
>>>> do_pwrite() in xfsprogs-dev/io/pwrite.c
>>>>
>>>> static ssize_t
>>>> do_pwrite(
>>>> 	int		fd,
>>>> 	off_t		offset,
>>>> 	long long	count,
>>>> 	size_t		buffer_size,
>>>> 	int		pwritev2_flags)
>>>> {
>>>> 	if (!vectors)
>>>> 		return pwrite(fd, io_buffer, min(count, buffer_size),
>>>> offset);
>>>>
>>>> 	return do_pwritev(fd, offset, count, pwritev2_flags);
>>>> }
>>>>
>>>> it will not call pwritev/pwritev2 unless we have vectors for which you
>>>> will need -V parameter with pwrite subcommand of xfs_io.
>>>>
>>>>
>>>> So I think the correct way to do this would be the following:
>>>>
>>>> bytes_written=$($XFS_IO_PROGS -c "open -d $testfile" -c "pwrite -A -D
>>>> -V 1 0 $bsize" | grep wrote | awk -F'[/ ]' '{print $2}').
>>> Agreed.
>>>
>>>> This also bring us to 2 more test cases that we can add:
>>>>
>>>> a. Atomic write with vec count > 1
>>>> $XFS_IO_PROGS -c "open -d $testfile" -c "pwrite -A -D -V 2 0 $bsize"
>>>> (This should fail with Invalid argument since currently iovec count is
>>>> restricted to 1)
>>>>
>>>> b.
>>>> Open a file withOUT O_DIRECT and try to perform an atomic write. This
>>>> should fail with Operation not Supported (EOPNOTSUPP). So something
>>>> like
>>>> $XFS_IO_PROGS -c "open -f $testfile" -c "pwrite -A -V 1 0 $bsize"
>>> Yeah, those are good subcases.
>>>
>>>> 3. It is better to use -b $bsize with pwrite else, the write might be
>>>> spilitted into multiple atomic writes. For example try the following:
>>>>
>>>> $XFS_IO_PROGS -c "open -fd $testfile" -c "pwrite -A -D -V 1 0 $((
>>>> $bsize * 2 ))"
>>>> The above is expected to fail as the size of the atomic write is
>>>> greater than the limit i.e, 1 block but it will still succeed. Look at
>>>> the strace and you will see 2 pwritev2 system calls. However the
>>>> following will fail expectedly with -EINVAL:
>>>> $XFS_IO_PROGS -c "open -fd $testfile" -c "pwrite -A -D -V 1 -b $((
>>>> $bsize * 2 )) 0 $(( $bsize * 2 ))"
>>> Good catch.
>>>
>>>>
>>>>> +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize
>>>>> failed"
>>>>> +
>>>>> +    # Check that we can perform an atomic write on an unwritten
>>>>> block
>>>>> +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
>>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D $bsize $bsize"
>>>>> $testfile | \
>>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>>> +    test $bytes_written -eq $bsize || echo "atomic write to
>>>>> unwritten block failed"
>>>>> +
>>>>> +    # Check that we can perform an atomic write on a sparse hole
>>>>> +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
>>>>> +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D 0 $bsize"
>>>>> $testfile | \
>>>>> +        grep wrote | awk -F'[/ ]' '{print $2}')
>>>>> +    test $bytes_written -eq $bsize || echo "atomic write to sparse
>>>>> hole failed"
>>>>> +
>>>>> +    # Reject atomic write if len is out of bounds
>>>>> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize - 1))" $testfile 2>>
>>>>> $seqres.full && \
>>>>> +        echo "atomic write len=$((bsize - 1)) should fail"
>>>>> +    $XFS_IO_PROG -dc "pwrite -A -D 0 $((bsize + 1))" $testfile 2>>
>>>>> $seqres.full && \
>>>>> +        echo "atomic write len=$((bsize + 1)) should fail"
>>>> Have we covered the scenario where the offset % len != 0 Should fail -
>>>> Should fail with Invalid arguments -EINVAL.
>>> I think you're right.
>>>
>>>> Also do you think adding similar tests with raw writes to the
>>>> underlying devices bypassing the fs layer will add some value? There
>>>> are slight less strict or different rules in the block layer which IMO
>>>> worth to be tested. Please let me know your thoughts.
>>> That should be in blktests.
>>>
>>>>> +
>>>>> +    _scratch_unmount
>>>>> +}
>>>>> +
>>>>> +bdev_min_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC"
>>>>> $SCRATCH_DEV | \
>>>>> +    grep atomic_write_unit_min | cut -d ' ' -f 3)
>>>>> +bdev_max_write=$($XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC"
>>>>> $SCRATCH_DEV | \
>>>>> +    grep atomic_write_unit_max | cut -d ' ' -f 3)
>>>>> +
>>>> Similar comment before - Refactor this into a function.
>>>>> +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
>>>>> +    _scratch_mkfs_xfs_supported -b size=$bsize >> $seqres.full 2>&1
>>>>> && \
>>>>> +        test_atomic_writes $bsize
>>>>> +done;
>>>> Minor: This might fail on some archs(x86_64) if the kernel isn't
>>>> compiled without CONFIG_TRANSPARENT_HUGEPAGE to enable block size
>>>> greater than 4k on x86_64.
>>> Oh, yeah, that's a good catch.
>>>
>>> --D
>>>
>>>> --
>>>> NR
>>>>> +
>>>>> +# success, all done
>>>>> +echo Silence is golden
>>>>> +status=0
>>>>> +exit
>>>>> diff --git a/tests/xfs/611.out b/tests/xfs/611.out
>>>>> new file mode 100644
>>>>> index 00000000..b8a44164
>>>>> --- /dev/null
>>>>> +++ b/tests/xfs/611.out
>>>>> @@ -0,0 +1,2 @@
>>>>> +QA output created by 611
>>>>> +Silence is golden
>> -- 
>> ---
>> Nirjhar Roy
>> Linux Kernel Developer
>> IBM, Bangalore
>>
>>
-- 
---
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

