Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D2F67F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:03:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BE10304066
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:03:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x9Pi6nvHGbfyPaF5 for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:03:14 -0700 (PDT)
Message-ID: <5265422E.8000101@redhat.com>
Date: Mon, 21 Oct 2013 10:03:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/8] xfstests: add regression test for kernel bz 60673
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
	<1382120790-31060-2-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-2-git-send-email-jbacik@fusionio.com>
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

On 10/18/13 1:26 PM, Josef Bacik wrote:
> There was a problem with send trying to overwrite a file that wasn't actually
> the same.  This is a test to check this particular case where receive fails when
> it should succeed properly.  I tested this to verify it fails without my fix and
> passes with my fix.  Thanks,

2 things - 

Why does the selinux context break things?  That seems like a problem w/ send
if it can't work on a context-mounted fs?  (disabling it for now doesn't bother
me, but I'm surprised that it's required).

((I also wonder if I should get rid of that context in general and use it only
for tests which fail without it))

Rather than all the cd'ing around (to /) what if you just do something like:

SEND_TEST_DIR=$TEST_DIR/$tmp_dir/send

mkdir $SEND_TEST_DIR
touch $SEND_TEST_DIR/baz
touch $SEND_TEST_DIR/blah
mkdir $SEND_TEST_DIR/foo
touch $SEND_TEST_DIR/foo/bar

that seems a bit cleaner to me vs. the cd back and forth.

-Eric


> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  tests/btrfs/015     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/015.out |   2 +
>  tests/btrfs/group   |   1 +
>  3 files changed, 113 insertions(+)
>  create mode 100644 tests/btrfs/015
>  create mode 100644 tests/btrfs/015.out
> 
> diff --git a/tests/btrfs/015 b/tests/btrfs/015
> new file mode 100644
> index 0000000..f35600f
> --- /dev/null
> +++ b/tests/btrfs/015
> @@ -0,0 +1,110 @@
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
> +cd $TEST_DIR/$tmp_dir/send
> +
> +mkdir test
> +touch test/baz
> +touch test/blah
> +mkdir test/foo
> +touch test/foo/bar
> +
> +# cd out in case any of this fails
> +cd /
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
> +cd $TEST_DIR/$tmp_dir/send
> +rm -rf test
> +mkdir test
> +touch test/baz
> +mkdir test/foo
> +touch test/foo/bar
> +touch test/blah
> +cd /
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
