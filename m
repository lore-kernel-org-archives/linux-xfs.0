Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o88Iow98055060 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 13:50:59 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E658317BCE4E
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 11:51:42 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id NNjbP88yVJfTtGHX for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 11:51:42 -0700 (PDT)
Message-ID: <4C87DB3D.4030709@sandeen.net>
Date: Wed, 08 Sep 2010 13:51:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Test to ensure that the EOFBLOCK_FL gets
	set/unset	correctly.
References: <1282941224-5805-1-git-send-email-alal@google.com>	<20100827233216.GJ705@dastard>
	<4C785254.2020708@sandeen.net>	<20100828001703.GK705@dastard>
	<4C785710.9070405@sandeen.net>	<AANLkTi=6gw_H0GkimuLHexsfkp-pe-9k8WVXYCT9SYZ+@mail.gmail.com>	<4C868314.9090503@sandeen.net>
	<AANLkTi=1kv=ihFOO4pBoNkVqJedZ-yc-K1Tp4D7hYM4j@mail.gmail.com>
In-Reply-To: <AANLkTi=1kv=ihFOO4pBoNkVqJedZ-yc-K1Tp4D7hYM4j@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: alal@google.com
Cc: xfs@oss.sgi.com

Akshay Lal wrote:
> There was a missing fi at the the end of the _check_ext4_eof_flag method.
> 
> Also corrected some indentation.

Thanks, I've committed this version.

In the future, keeping patch resubmissions tidy is helpful, i.e.

Subject: [PATCH Vx] subsystem: description

patch description

Signed-off-by: 
---
other information that won't go into the commit

patch itself

... without the other cruft, forwarded snippets, etc :)

see also Documentation/SubmittingPatches
in the kernel tree.

Thanks,

-Eric

> Signed-off-by: Akshay Lal <alal@google.com>
> ---------------------------------------------------------------------------------------
> Updated patch:
> ---------------------------------------------------------------------------------------
> From e6906071ab6c0ad38d3ee0a463b5c7944e71fd00 Mon Sep 17 00:00:00 2001
> From: Akshay Lal <alal@google.com>
> Date: Tue, 7 Sep 2010 12:54:33 -0700
> Subject: [PATCH] Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
> 
> As found by Theodore Ts'o:
> If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
> write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
> This is bad since it forces e2fsck to complain about that inode.
> If you have a large number of inodes that are written with fallocate
> using KEEP_SIZE, and then fill them up to their expected size,
> e2fsck will potentially complain about a _huge_ number of inodes.
> This would also cause a huge increase in the time taken by e2fsck
> to complete its check.
> 
> Test scenarios covered:
> 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
> 2. Fallocating X bytes and writing Y (Y=X) (buffered and direct io)
> 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
> 
> These test cases exercise the normal and edge case conditions using
> falloc (and KEEP_SIZE).
> 
> Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
> ---
>  243     |  178 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  243.out |   13 +++++
>  group   |    1 +
>  3 files changed, 192 insertions(+), 0 deletions(-)
>  create mode 100644 243
>  create mode 100644 243.out
> 
> diff --git a/243 b/243
> new file mode 100644
> index 0000000..8b2e647
> --- /dev/null
> +++ b/243
> @@ -0,0 +1,178 @@
> +#! /bin/bash
> +# FS QA Test No. 243
> +#
> +# Test to ensure that the EOFBLOCK_FL gets set/unset correctly.
> +#
> +# As found by Theodore Ts'o:
> +# If a 128K file is falloc'ed using the KEEP_SIZE flag, and then
> +# write exactly 128K, the EOFBLOCK_FL doesn't get cleared correctly.
> +# This is bad since it forces e2fsck to complain about that inode.
> +# If you have a large number of inodes that are written with fallocate
> +# using KEEP_SIZE, and then fill them up to their expected size,
> +# e2fsck will potentially complain about a _huge_ number of inodes.
> +# This would also cause a huge increase in the time taken by e2fsck
> +# to complete its check.
> +#
> +# Test scenarios covered:
> +# 1. Fallocating X bytes and writing Y (Y<X) (buffered and direct io)
> +# 2. Fallocating X bytes and writing Y (Y=X) (buffered and direct io)
> +# 3. Fallocating X bytes and writing Y (Y>X) (buffered and direct io)
> +#
> +# These test cases exercise the normal and edge case conditions using
> +# falloc (and KEEP_SIZE).
> +#
> +# Ref: http://thread.gmane.org/gmane.comp.file-systems.ext4/20682
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Google, Inc.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=alal@google.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1        # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# Test specific macros.
> +BIT_NOT_SET=0   # inode flag - 0x400000 bit is not set.
> +BIT_SET=1       # inode flag - 0x400000 bit is set.
> +
> +# Generic test cleanup function.
> +_cleanup()
> +{
> +  cd /
> +  rm -f $tmp.*
> +}
> +
> +# Ext4 uses the EOFBLOCKS_FL bit when fallocating blocks with KEEP_SIZE
> +# enabled. The only time this bit should be set is when extending the allocated
> +# blocks further than what the i_size represents. In the situations wherein the
> +# i_size covers all allocated blocks, this bit should be cleared.
> +
> +# Checks the state of the sample file in the filesystem and returns whether
> +# the inode flag 0x400000 is set or not.
> +_check_ext4_eof_flag()
> +{
> +  # Check whether EOFBLOCK_FL is set.
> +  # For ext4 filesystems: use debugfs to check if EOFBLOCKS_FL is set.
> +  # Other filesystems: do nothing. The default fsck at the end of the test
> +  # should catch any potential errors.
> +  if [ "${FSTYP}" == "ext4" ]; then
> +    bit_set=1
> +
> +    # Unmount the ${TEST_DEV}
> +    umount ${TEST_DEV}
> +
> +    # Run debugfs to gather file_parameters - specifically iflags.
> +    file_params=`debugfs ${TEST_DEV} -R "stat ${1}" 2>&1 | grep -e Flags:`
> +    iflags=${file_params#*Flags: }
> +
> +    # Ensure that the iflags value was parsed correctly.
> +    if [ -z ${iflags} ]; then
> +      echo "iFlags value was not parsed successfully." >> $seq.full
> +      status=1
> +      exit ${status}
> +    fi
> +
> +    # Check if EOFBLOCKS_FL is set.
> +    if ((${iflags} & 0x400000)); then
> +      echo "EOFBLOCK_FL bit is set." >> $seq.full
> +      bit_set=1
> +    else
> +      echo "EOFBLOCK_FL bit is not set." >> $seq.full
> +      bit_set=0
> +    fi
> +
> +    # Check current bit state to expected value.
> +    if [ ${bit_set} -ne ${2} ]; then
> +      echo "Error: Current bit state incorrect." >> $seq.full
> +      status=1
> +      exit ${status}
> +    fi
> +
> +    # Mount the ${TEST_DEV}
> +    mount ${TEST_DEV} -t ${FSTYP} ${TEST_DIR}
> +  fi
> +}
> +
> +# Get standard environment, filters and checks.
> +. ./common.rc
> +. ./common.filter
> +
> +# Prerequisites for the test run.
> +_supported_fs ext4 xfs btrfs gfs2
> +_supported_os Linux
> +_require_xfs_io_falloc
> +
> +# Real QA test starts here.
> +rm -f $seq.full
> +
> +# Begin test cases.
> +echo "Test 1: Fallocate 40960 bytes and write 4096 bytes (buffered io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f                    \
> +    -c 'falloc -k 0 40960'              \
> +    -c 'pwrite 0 4096'                  \
> +    ${TEST_DIR}/test_1 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_1 ${BIT_SET}
> +
> +echo "Test 2: Fallocate 40960 bytes and write 4096 bytes (direct io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f -d                 \
> +    -c 'falloc -k 0 40960'              \
> +    -c 'pwrite 0 4096'                  \
> +    ${TEST_DIR}/test_2 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_2 ${BIT_SET}
> +
> +echo "Test 3: Fallocate 40960 bytes and write 40960 bytes (buffered io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f                    \
> +    -c 'falloc -k 0 40960'              \
> +    -c 'pwrite 0 40960'                 \
> +    ${TEST_DIR}/test_3 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_3 ${BIT_NOT_SET}
> +
> +echo "Test 4: Fallocate 40960 bytes and write 40960 bytes (direct io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f -d                 \
> +    -c 'falloc -k 0 40960'              \
> +    -c 'pwrite 0 40960'                 \
> +    ${TEST_DIR}/test_4 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_4 ${BIT_NOT_SET}
> +
> +echo "Test 5: Fallocate 128k, seek 256k and write 4k block (buffered io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f                    \
> +    -c 'falloc -k 0 128k'               \
> +    -c 'pwrite 256k 4k'                 \
> +    ${TEST_DIR}/test_5 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_5 ${BIT_NOT_SET}
> +
> +echo "Test 6: Fallocate 128k, seek to 256k and write a 4k block (direct io)." \
> +    >> $seq.full
> +${XFS_IO_PROG} -F -f -d                 \
> +    -c 'falloc -k 0 128k'               \
> +    -c 'pwrite 256k 4k'                 \
> +    ${TEST_DIR}/test_6 | _filter_xfs_io_unique
> +_check_ext4_eof_flag test_6 ${BIT_NOT_SET}
> +
> +status=0
> +exit ${status}
> diff --git a/243.out b/243.out
> new file mode 100644
> index 0000000..290a005
> --- /dev/null
> +++ b/243.out
> @@ -0,0 +1,13 @@
> +QA output created by 243
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 4096/4096 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 40960/40960 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 40960/40960 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 4096/4096 bytes at offset 262144
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +wrote 4096/4096 bytes at offset 262144
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/group b/group
> index ff16bb3..e6dab13 100644
> --- a/group
> +++ b/group
> @@ -356,3 +356,4 @@ deprecated
>  240 auto aio quick rw
>  241 auto
>  242 auto quick prealloc
> +243 auto quick prealloc

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
