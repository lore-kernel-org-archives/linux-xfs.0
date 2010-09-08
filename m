Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88IqYUi055185 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 13:52:34 -0500
Received: from smtp-out.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D89059218
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 11:53:17 -0700 (PDT)
Received: from smtp-out.google.com (smtp-out.google.com [74.125.121.35]) by
	cuda.sgi.com with ESMTP id 8TuPk7MUOvH4gdQr for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 11:53:17 -0700 (PDT)
Received: from kpbe18.cbf.corp.google.com (kpbe18.cbf.corp.google.com
	[172.25.105.82]) by smtp-out.google.com with ESMTP id o88IrFtO014732
	for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 11:53:16 -0700
Received: from ywg4 (ywg4.prod.google.com [10.192.7.4])
	by kpbe18.cbf.corp.google.com with ESMTP id o88IqgCn001937
	for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 11:53:14 -0700
Received: by ywg4 with SMTP id 4so214817ywg.32
	for <xfs@oss.sgi.com>; Wed, 08 Sep 2010 11:53:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C87DB3D.4030709@sandeen.net>
References: <1282941224-5805-1-git-send-email-alal@google.com>
	<20100827233216.GJ705@dastard> <4C785254.2020708@sandeen.net>
	<20100828001703.GK705@dastard> <4C785710.9070405@sandeen.net>
	<AANLkTi=6gw_H0GkimuLHexsfkp-pe-9k8WVXYCT9SYZ+@mail.gmail.com>
	<4C868314.9090503@sandeen.net>
	<AANLkTi=1kv=ihFOO4pBoNkVqJedZ-yc-K1Tp4D7hYM4j@mail.gmail.com>
	<4C87DB3D.4030709@sandeen.net>
From: Akshay Lal <akshaylal@google.com>
Date: Wed, 8 Sep 2010 11:52:43 -0700
Message-ID: <AANLkTimySKQVvS26XCJk8cnUew6x-orCJEpG0YetwdKj@mail.gmail.com>
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset
	correctly.
Reply-To: alal@google.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Thanks Eric, as we move fwd, these patch will be better.


---
Cheers!
Akshay Lal



On Wed, Sep 8, 2010 at 11:51 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> Akshay Lal wrote:
>> There was a missing fi at the the end of the _check_ext4_eof_flag method.
>>
>> Also corrected some indentation.
>
> Thanks, I've committed this version.
>
> In the future, keeping patch resubmissions tidy is helpful, i.e.
>
> Subject: [PATCH Vx] subsystem: description
>
> patch description
>
> Signed-off-by:
> ---
> other information that won't go into the commit
>
> patch itself
>
> ... without the other cruft, forwarded snippets, etc :)
>
> see also Documentation/SubmittingPatches
> in the kernel tree.
>
> Thanks,
>
> -Eric
>
>> Signed-off-by: Akshay Lal <alal@google.com>
>> ------------------------------------------------------------------------=
---------------
>> Updated patch:
>> ------------------------------------------------------------------------=
---------------
>> From e6906071ab6c0ad38d3ee0a463b5c7944e71fd00 Mon Sep 17 00:00:00 2001
>> From: Akshay Lal <alal@google.com>
>> Date: Tue, 7 Sep 2010 12:54:33 -0700
>> Subject: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset corr=
ectly.
>>
>> As found by Theodore Ts'o:
>> If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
>> write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
>> This is bad since it forces e2fsck to complain about that inode.
>> If you have a large number of inodes that are written with fallocate
>> using KEEP_SIZE, and then fill them up to their expected size,
>> e2fsck will potentially complain about a _huge_ number of inodes.
>> This would also cause a huge increase in the time taken by e2fsck
>> to complete its check.
>>
>> Test scenarios covered:
>> 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
>> 2. Fallocating X bytes and writing Y (Y=3DX) (buffered and direct io)
>> 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
>>
>> These test cases exercise the normal and edge case conditions using
>> falloc (and KEEP_SIZE).
>>
>> Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
>> ---
>> =A0243 =A0 =A0 | =A0178 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A0243.out | =A0 13 +++++
>> =A0group =A0 | =A0 =A01 +
>> =A03 files changed, 192 insertions(+), 0 deletions(-)
>> =A0create mode 100644 243
>> =A0create mode 100644 243.out
>>
>> diff --git a/243 b/243
>> new file mode 100644
>> index 0000000..8b2e647
>> --- /dev/null
>> +++ b/243
>> @@ -0,0 +1,178 @@
>> +#! /bin/bash
>> +# FS QA Test No. 243
>> +#
>> +# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
>> +#
>> +# As found by Theodore Ts'o:
>> +# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
>> +# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
>> +# This is bad since it forces e2fsck to complain about that inode.
>> +# If you have a large number of inodes that are written with fallocate
>> +# using KEEP_SIZE, and then fill them up to their expected size,
>> +# e2fsck will potentially complain about a _huge_ number of inodes.
>> +# This would also cause a huge increase in the time taken by e2fsck
>> +# to complete its check.
>> +#
>> +# Test scenarios covered:
>> +# 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
>> +# 2. Fallocating X bytes and writing Y (Y=3DX) (buffered and direct io)
>> +# 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
>> +#
>> +# These test cases exercise the normal and edge case conditions using
>> +# falloc (and KEEP_SIZE).
>> +#
>> +# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2010 Google, Inc. =A0All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc., =A051 Franklin St, Fifth Floor, Boston, MA =A002110-1301 =A0USA
>> +#-----------------------------------------------------------------------
>> +#
>> +# creator
>> +owner=3Dalal@google.com
>> +
>> +seq=3D`basename $0`
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1 =A0 =A0 =A0 =A0# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +# Test specific macros.
>> +BIT_NOT_SET=3D0 =A0 # inode flag - 0x400000 bit is not set.
>> +BIT_SET=3D1 =A0 =A0 =A0 # inode flag - 0x400000 bit is set.
>> +
>> +# Generic test cleanup function.
>> +_cleanup()
>> +{
>> + =A0cd /
>> + =A0rm -f $tmp.*
>> +}
>> +
>> +# Ext4 uses the EOFBLOCKS_FL bit when fallocating blocks with KEEP_SIZE
>> +# enabled. The only time this bit should be set is when extending the a=
llocated
>> +# blocks further than what the i_size represents. In the situations whe=
rein the
>> +# i_size covers all allocated blocks, this bit should be cleared.
>> +
>> +# Checks the state of the sample file in the filesystem and returns whe=
ther
>> +# the inode flag 0x400000 is set or not.
>> +_check_ext4_eof_flag()
>> +{
>> + =A0# Check whether EOFBLOCK_FL is set.
>> + =A0# For ext4 filesystems: use debugfs to check if EOFBLOCKS_FL is set.
>> + =A0# Other filesystems: do nothing. The default fsck at the end of the=
 test
>> + =A0# should catch any potential errors.
>> + =A0if [ "${FSTYP}" =3D=3D "ext4" ]; then
>> + =A0 =A0bit_set=3D1
>> +
>> + =A0 =A0# Unmount the ${TEST_DEV}
>> + =A0 =A0umount ${TEST_DEV}
>> +
>> + =A0 =A0# Run debugfs to gather file_parameters - specifically iflags.
>> + =A0 =A0file_params=3D`debugfs ${TEST_DEV} -R "stat ${1}" 2>&1 | grep -=
e Flags:`
>> + =A0 =A0iflags=3D${file_params#*Flags: }
>> +
>> + =A0 =A0# Ensure that the iflags value was parsed correctly.
>> + =A0 =A0if [ -z ${iflags} ]; then
>> + =A0 =A0 =A0echo "iFlags value was not parsed successfully." >> $seq.fu=
ll
>> + =A0 =A0 =A0status=3D1
>> + =A0 =A0 =A0exit ${status}
>> + =A0 =A0fi
>> +
>> + =A0 =A0# Check if EOFBLOCKS_FL is set.
>> + =A0 =A0if ((${iflags} & 0x400000)); then
>> + =A0 =A0 =A0echo "EOFBLOCK_FL bit is set." >> $seq.full
>> + =A0 =A0 =A0bit_set=3D1
>> + =A0 =A0else
>> + =A0 =A0 =A0echo "EOFBLOCK_FL bit is not set." >> $seq.full
>> + =A0 =A0 =A0bit_set=3D0
>> + =A0 =A0fi
>> +
>> + =A0 =A0# Check current bit state to expected value.
>> + =A0 =A0if [ ${bit_set} -ne ${2} ]; then
>> + =A0 =A0 =A0echo "Error: Current bit state incorrect." >> $seq.full
>> + =A0 =A0 =A0status=3D1
>> + =A0 =A0 =A0exit ${status}
>> + =A0 =A0fi
>> +
>> + =A0 =A0# Mount the ${TEST_DEV}
>> + =A0 =A0mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
>> + =A0fi
>> +}
>> +
>> +# Get standard environment, filters and checks.
>> +. ./common.rc
>> +. ./common.filter
>> +
>> +# Prerequisites for the test run.
>> +_supported_fs ext4 xfs btrfs gfs2
>> +_supported_os Linux
>> +_require_xfs_io_falloc
>> +
>> +# Real QA test starts here.
>> +rm -f $seq.full
>> +
>> +# Begin test cases.
>> +echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io).=
" \
>> + =A0 =A0>> $seq.full
>> +${XFS_IO_PROG} -F -f =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'falloc -k 0 40960' =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'pwrite 0 4096' =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0${TEST_DIR}/test_1 | _filter_xfs_io_unique
>> +_check_ext4_eof_flag test_1 ${BIT_SET}
>> +
>> +echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
>> + =A0 =A0>> $seq.full
>> +${XFS_IO_PROG} -F -f -d =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0-c 'falloc -k 0 40960' =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'pwrite 0 4096' =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0${TEST_DIR}/test_2 | _filter_xfs_io_unique
>> +_check_ext4_eof_flag test_2 ${BIT_SET}
>> +
>> +echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)=
." \
>> + =A0 =A0>> $seq.full
>> +${XFS_IO_PROG} -F -f =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'falloc -k 0 40960' =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'pwrite 0 40960' =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0${TEST_DIR}/test_3 | _filter_xfs_io_unique
>> +_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
>> +
>> +echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)."=
 \
>> + =A0 =A0>> $seq.full
>> +${XFS_IO_PROG} -F -f -d =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0-c 'falloc -k 0 40960' =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'pwrite 0 40960' =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0${TEST_DIR}/test_4 | _filter_xfs_io_unique
>> +_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
>> +
>> +echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io=
)." \
>> + =A0 =A0>> $seq.full
>> +${XFS_IO_PROG} -F -f =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>> + =A0 =A0-c 'falloc -k 0 128k' =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0-c 'pwrite 256k 4k' =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0${TEST_DIR}/test_5 | _filter_xfs_io_unique
>> +_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
>> +
>> +echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct=
 io)." \
>> + =A0 =A0>> $seq.full
>> +${XFS_IO_PROG} -F -f -d =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0-c 'falloc -k 0 128k' =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0-c 'pwrite 256k 4k' =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 \
>> + =A0 =A0${TEST_DIR}/test_6 | _filter_xfs_io_unique
>> +_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
>> +
>> +status=3D0
>> +exit ${status}
>> diff --git a/243.out b/243.out
>> new file mode 100644
>> index 0000000..290a005
>> --- /dev/null
>> +++ b/243.out
>> @@ -0,0 +1,13 @@
>> +QA output created by 243
>> +wrote 4096/4096 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 40960/40960 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 40960/40960 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 262144
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> +wrote 4096/4096 bytes at offset 262144
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> diff --git a/group b/group
>> index ff16bb3..e6dab13 100644
>> --- a/group
>> +++ b/group
>> @@ -356,3 +356,4 @@ deprecated
>> =A0240 auto aio quick rw
>> =A0241 auto
>> =A0242 auto quick prealloc
>> +243 auto quick prealloc
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
