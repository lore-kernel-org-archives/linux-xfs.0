Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D13ED7F52
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:22:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51C42AC007
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:22:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pwBUJWG57Ktm9t2A for
	<xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:22:27 -0700 (PDT)
Message-ID: <526546B1.3080909@redhat.com>
Date: Mon, 21 Oct 2013 10:22:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/8] xfstests: btrfs/016: a hole punching send test
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
	<1382120790-31060-4-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-4-git-send-email-jbacik@fusionio.com>
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
> I recently added a patch to avoid sending holes with btrfs send, but I screwed
> it up by not sending a hole when we did a hole punch.  This is an xfstest
> version of the test I wrote to show that I had a bug and to verify I was fixing
> it properly.  This test properly fails with my old patch and passes with my good
> patch.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/btrfs/016     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/016.out |   2 ++
>  tests/btrfs/group   |   1 +
>  3 files changed, 103 insertions(+)
>  create mode 100644 tests/btrfs/016
>  create mode 100644 tests/btrfs/016.out
> 
> diff --git a/tests/btrfs/016 b/tests/btrfs/016
> new file mode 100644
> index 0000000..d711ecb
> --- /dev/null
> +++ b/tests/btrfs/016
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/016
> +#
> +# btrfs send hole punch test
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
> +tmp=`mktemp -d`
> +tmp_dir=send_temp_$seq
> +
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap > /dev/null 2>&1
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/snap1 > /dev/null 2>&1
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
> +FSSUM_PROG=$here/src/fssum
> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"
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
> +dd if=/dev/urandom of=$TEST_DIR/$tmp_dir/send/foo bs=1M count=10 >> $seqres.full \
> +	2>&1 || _fail "dd failed"
> +$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
> +	$TEST_DIR/$tmp_dir/snap >> $seqres.full 2>&1 || _fail "failed snap"
> +$XFS_IO_PROG -c "fpunch 1m 1m" $TEST_DIR/$tmp_dir/send/foo
> +$BTRFS_UTIL_PROG subvol snap -r $TEST_DIR/$tmp_dir/send \
> +	$TEST_DIR/$tmp_dir/snap1 >> $seqres.full 2>&1 || _fail "failed snap"
> +
> +$FSSUM_PROG -A -f -w $tmp/fssum.snap $TEST_DIR/$tmp_dir/snap >> $seqres.full \
> +	2>&1 || _fail "fssum gen failed"
> +$FSSUM_PROG -A -f -w $tmp/fssum.snap1 $TEST_DIR/$tmp_dir/snap1 >> $seqres.full \
> +	2>&1 || _fail "fssum gen failed"
> +
> +$BTRFS_UTIL_PROG send $TEST_DIR/$tmp_dir/snap -f $tmp/send.snap >> \
> +	$seqres.full 2>&1 || _fail "failed send"
> +$BTRFS_UTIL_PROG send $TEST_DIR/$tmp_dir/snap1 -p $TEST_DIR/$tmp_dir/snap \
> +	-f $tmp/send.snap1 >> $seqres.full 2>&1 || _fail "failed send"
> +
> +$BTRFS_UTIL_PROG receive -f $tmp/send.snap $SCRATCH_MNT >> $seqres.full 2>&1 \
> +	|| _fail "failed recv"
> +$BTRFS_UTIL_PROG receive -f $tmp/send.snap1 $SCRATCH_MNT >> $seqres.full 2>&1 \
> +	|| _fail "failed recv"
> +
> +$FSSUM_PROG -r $tmp/fssum.snap $SCRATCH_MNT/snap >> $seqres.full 2>&1 \
> +	|| _fail "fssum failed"
> +$FSSUM_PROG -r $tmp/fssum.snap1 $SCRATCH_MNT/snap1 >> $seqres.full 2>&1 \
> +	|| _fail "fssum failed"
> +
> +echo "Silence is golden"
> +status=0 ; exit
> diff --git a/tests/btrfs/016.out b/tests/btrfs/016.out
> new file mode 100644
> index 0000000..aa2526b
> --- /dev/null
> +++ b/tests/btrfs/016.out
> @@ -0,0 +1,2 @@
> +QA output created by 016
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index a6f1820..082fd67 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -18,3 +18,4 @@
>  013 auto quick
>  014 auto
>  015 auto quick
> +016 auto quick
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
