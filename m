Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF2F47F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 12:55:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B84678F8039
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:55:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nm3s8iFII0B6MYHa for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:55:33 -0700 (PDT)
Message-ID: <52656A92.5030909@redhat.com>
Date: Mon, 21 Oct 2013 12:55:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673 V2
References: <1382377928-4657-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382377928-4657-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 10/21/13 12:52 PM, Josef Bacik wrote:
> There was a problem with send trying to overwrite a file that wasn't actually
> the same.  This is a test to check this particular case where receive fails when
> it should succeed properly.  I tested this to verify it fails without my fix and
> passes with my fix.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> V1->V2: use the directory itself instead of cd'ing around
> 
>  tests/btrfs/015     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/015.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 108 insertions(+)
>  create mode 100755 tests/btrfs/015
>  create mode 100644 tests/btrfs/015.out
> 
> diff --git a/tests/btrfs/015 b/tests/btrfs/015
> new file mode 100755
> index 0000000..be3ed25
> --- /dev/null
> +++ b/tests/btrfs/015
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/015
> +#
> +# btrfs send ENOENT regression test, kernel bugzilla 60673
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
> +tmp_dir=send_temp_$seq
> +
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap2 > /dev/null 2>&1
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send > /dev/null 2>&1
> +	rm -rf $TEST_DIR/$tmp_dir
> +	rm -f $tmp.*
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
> +_require_scratch
> +
> +_scratch_mkfs > /dev/null 2>&1
> +
> +#receive needs to be able to setxattrs, including the selinux context, if we use
> +#the normal nfs context thing it screws up our ability to set the
> +#security.selinux xattrs so we need to disable this for this test
> +export SELINUX_MOUNT_OPTIONS=""
> +
> +_scratch_mount
> +
> +mkdir $TEST_DIR/$tmp_dir
> +$BTRFS_UTIL_PROG subvol create $TEST_DIR/$tmp_dir/send \
> +	> $seqres.full 2>&1 || _fail "failed subvol create"
> +
> +SEND_TEST_DIR=$TEST_DIR/$tmp_dir/send
> +
> +mkdir $SEND_TEST_DIR/test
> +touch $SEND_TEST_DIR/test/baz
> +touch $SEND_TEST_DIR/test/blah
> +mkdir $SEND_TEST_DIR/test/foo
> +touch $SEND_TEST_DIR/test/foo/bar
> +
> +$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
> +	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed snap1"
> +
> +$BTRFS_UTIL_PROG send -f $TEST_DIR/$tmp_dir/send1.dump \
> +	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed send"
> +
> +$BTRFS_UTIL_PROG receive -f $TEST_DIR/$tmp_dir/send1.dump $SCRATCH_MNT \
> +	>> $seqres.full 2>&1 || _fail "failed receive"
> +
> +#recreate everything exactly the way it was exceptn in a different order so we
> +#get different inode numbers
> +rm -rf $SEND_TEST_DIR/test
> +mkdir $SEND_TEST_DIR/test
> +touch $SEND_TEST_DIR/test/baz
> +mkdir $SEND_TEST_DIR/test/foo
> +touch $SEND_TEST_DIR/test/foo/bar
> +touch $SEND_TEST_DIR/test/blah
> +
> +$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
> +	$TEST_DIR/$tmp_dir/snap2 >> $seqres.full 2>&1 || _fail "failed snap2"
> +
> +$BTRFS_UTIL_PROG send -f $TEST_DIR/$tmp_dir/send2.dump \
> +	$TEST_DIR/$tmp_dir/snap2 -p $TEST_DIR/$tmp_dir/snap1 \
> +	>> $seqres.full 2>&1 || _fail "failed second send"
> +
> +$BTRFS_UTIL_PROG receive -f $TEST_DIR/$tmp_dir/send2.dump $SCRATCH_MNT \
> +	>> $seqres.full 2>&1 || _fail "failed second receive"
> +
> +echo "Silence is golden"
> +status=0 ; exit
> diff --git a/tests/btrfs/015.out b/tests/btrfs/015.out
> new file mode 100644
> index 0000000..fee0fcf
> --- /dev/null
> +++ b/tests/btrfs/015.out
> @@ -0,0 +1,2 @@
> +QA output created by 015
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 07df957..a6f1820 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -17,3 +17,4 @@
>  012 auto
>  013 auto quick
>  014 auto
> +015 auto quick
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
