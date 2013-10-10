Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 430977F54
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:19:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FDB78F8039
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:19:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id J6IA6gTy9Ei4PHXV for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 20:19:22 -0700 (PDT)
Message-ID: <52561CB5.7090209@sandeen.net>
Date: Wed, 09 Oct 2013 22:19:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests ext4/306: regression test for ext4 resize with
	non-extent files
References: <1377860767-13304-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1377860767-13304-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On 8/30/13 6:06 AM, Eryu Guan wrote:
> From: Eric Sandeen <esandeen@redhat.com>
> 
> Regression test for:
> 
> c5c72d8 ext4: fix online resizing for ext3-compat file systems
> 
> Signed-off-by: Eric Sandeen <esandeen@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---

Ping, needs 3rd party review still I guess (from the ext4 list, please)

-Eric

> This test is originally written by Eric and doesn't get merged. I did
> minor update and resent.
> 
> V2: s/dangerous/auto/
> V3: remove "Silence is golden" output since it's not silent
> 
>  tests/ext4/306     | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/ext4/306.out | 13 +++++++++
>  tests/ext4/group   |  1 +
>  3 files changed, 96 insertions(+)
>  create mode 100755 tests/ext4/306
>  create mode 100644 tests/ext4/306.out
> 
> diff --git a/tests/ext4/306 b/tests/ext4/306
> new file mode 100755
> index 0000000..398c4c0
> --- /dev/null
> +++ b/tests/ext4/306
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test No. ext4/306
> +#
> +# Test that blocks are available to non-extent files after a resize2fs
> +# Regression test for commit:
> +# c5c72d8 ext4: fix online resizing for ext3-compat file systems
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +PIDS=""
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    _scratch_unmount
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs ext4
> +_supported_os Linux
> +
> +_require_scratch
> +
> +# This needs to mount ext3; might require ext3 driver, or ext4
> +# might handle it itself.  Find out if we have it one way or another.
> +modprobe ext3 > /dev/null 2>&1
> +grep -q ext3 /proc/filesystems || _notrun "This test requires ext3 support"
> +
> +rm -f $seqres.full
> +
> +# Make a small ext3 fs, (extents disabled) & mount it
> +yes | mkfs.ext3 $SCRATCH_DEV 512m >> $seqres.full 2>&1
> +_scratch_mount -t ext3 || _fail "couldn't mount fs as ext3"
> +# Create a small non-extent-based file
> +echo "Create 1m testfile1"
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 0 1m" | _filter_xfs_io
> +echo "Create testfile2 to fill the fs"
> +# A large non-extent-based file filling the fs; this will run out & fail
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile2 -c "pwrite 0 512m" | _filter_xfs_io
> +
> +# Remount as ext4
> +_scratch_unmount
> +_scratch_mount -t ext4 || _fail "couldn't remount fs as ext4"
> +df -h $SCRATCH_MNT >> $seqres.full
> +
> +# Grow it by 512m
> +echo "Resize to 1g"
> +resize2fs $SCRATCH_DEV 1g >> $seqres.full 2>&1 || _fail "Could not resize to 1g"
> +df -h $SCRATCH_MNT >> $seqres.full
> +
> +# See if we can add more blocks to the files
> +echo "append 2m to testfile1"
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 1m 2m" | _filter_xfs_io
> +echo "append 2m to testfile2"
> +$XFS_IO_PROG -f $SCRATCH_MNT/testfile1 -c "pwrite 512m 2m" | _filter_xfs_io
> +
> +status=0
> +exit
> diff --git a/tests/ext4/306.out b/tests/ext4/306.out
> new file mode 100644
> index 0000000..ee6c90c
> --- /dev/null
> +++ b/tests/ext4/306.out
> @@ -0,0 +1,13 @@
> +QA output created by 306
> +Create 1m testfile1
> +wrote 1048576/1048576 bytes at offset 0
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +Create testfile2 to fill the fs
> +pwrite64: No space left on device
> +Resize to 1g
> +append 2m to testfile1
> +wrote 2097152/2097152 bytes at offset 1048576
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +append 2m to testfile2
> +wrote 2097152/2097152 bytes at offset 536870912
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/ext4/group b/tests/ext4/group
> index 53af708..7e1a68b 100644
> --- a/tests/ext4/group
> +++ b/tests/ext4/group
> @@ -9,3 +9,4 @@
>  303 aio dangerous ioctl rw stress
>  304 aio dangerous ioctl rw stress
>  305 auto
> +306 auto rw resize quick
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
