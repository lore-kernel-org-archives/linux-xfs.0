Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 591787F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:25:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 415158F8059
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:25:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ElBwin5QkuDtFdYC for
	<xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:25:53 -0700 (PDT)
Message-ID: <5267F88E.1010607@redhat.com>
Date: Wed, 23 Oct 2013 11:25:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests btrfs/020: test device replace on RO btrfs
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1382527446-16053-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

On 10/23/13 6:24 AM, Eryu Guan wrote:
> btrfs replace on readonly fs should not be allowed.
> 
> Regression test case for commit:
> bbb651e Btrfs: don't allow the replace procedure on read only filesystems
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Could you speed this up by just truncating the loop files to 256m, rather
than writing 256m to each (for a total of 768m IO?)

Also: thanks for including the commit it's testing, that kind of thing
will be super helpful down the line.

-Eric

> ---
>  tests/btrfs/020     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/020.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 87 insertions(+)
>  create mode 100755 tests/btrfs/020
>  create mode 100644 tests/btrfs/020.out
> 
> diff --git a/tests/btrfs/020 b/tests/btrfs/020
> new file mode 100755
> index 0000000..cd16dc0
> --- /dev/null
> +++ b/tests/btrfs/020
> @@ -0,0 +1,84 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/020
> +#
> +# btrfs device replace test on RO fs
> +#
> +# Regression test for commit:
> +# bbb651e Btrfs: don't allow the replace procedure on read only filesystems
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$UMOUNT_PROG $loop_mnt
> +	_destroy_loop_device $loop_dev1
> +	losetup -d $loop_dev2 >/dev/null 2>&1
> +	_destroy_loop_device $loop_dev3
> +	rm -rf $loop_mnt
> +	rm -f $fs_img1 $fs_img2 $fs_img3
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +rm -f $seqres.full
> +echo "Silence is golden"
> +
> +loop_mnt=$TEST_DIR/$seq.$$.mnt
> +fs_img1=$TEST_DIR/$seq.$$.img1
> +fs_img2=$TEST_DIR/$seq.$$.img2
> +fs_img3=$TEST_DIR/$seq.$$.img3
> +mkdir $loop_mnt
> +$XFS_IO_PROG -f -c "pwrite 0 256m" $fs_img1 >>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite 0 256m" $fs_img2 >>$seqres.full 2>&1
> +$XFS_IO_PROG -f -c "pwrite 0 256m" $fs_img3 >>$seqres.full 2>&1
> +
> +loop_dev1=`_create_loop_device $fs_img1`
> +loop_dev2=`_create_loop_device $fs_img2`
> +loop_dev3=`_create_loop_device $fs_img3`
> +
> +$MKFS_BTRFS_PROG -m raid1 -d raid1 $loop_dev1 $loop_dev2 >>$seqres.full 2>&1
> +$MOUNT_PROG -o ro $loop_dev1 $loop_mnt
> +
> +# Fail the second device and replace with the third
> +_destroy_loop_device $loop_dev2
> +$BTRFS_UTIL_PROG replace start -B 2 $loop_dev3 $loop_mnt >>$seqres.full 2>&1 && \
> +_fail "FAIL: Device replaced on RO btrfs"
> +
> +status=0
> +exit
> diff --git a/tests/btrfs/020.out b/tests/btrfs/020.out
> new file mode 100644
> index 0000000..20d7944
> --- /dev/null
> +++ b/tests/btrfs/020.out
> @@ -0,0 +1,2 @@
> +QA output created by 020
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 2f74139..1159499 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -22,3 +22,4 @@
>  017 auto quick
>  018 auto quick
>  019 auto quick
> +020 auto quick
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
