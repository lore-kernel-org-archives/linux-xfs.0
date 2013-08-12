Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 993DC7F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 14:40:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 816D5304043
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 12:40:05 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pXW6objR5WXOj46H for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 12:40:04 -0700 (PDT)
Message-ID: <52093A11.40807@sandeen.net>
Date: Mon, 12 Aug 2013 14:40:01 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/002, another send regression test
References: <1376334802-18960-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376334802-18960-1-git-send-email-jbacik@fusionio.com>
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

On 8/12/13 2:13 PM, Josef Bacik wrote:
> This is a regression test for a problem we had where we'd assume we had created
> a directory if it only had subvols inside of it.  This was happening because
> subvols would have lower inode numbers than our current send progress because
> their inode numbers are based off of a different counter.  Thanks,

The problem itself isn't totally clear to me, but the test itself looks
fine.  ;)

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/btrfs/002     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/002.out |    2 +
>  tests/btrfs/group   |    1 +
>  3 files changed, 88 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/002
>  create mode 100644 tests/btrfs/002.out
> 
> diff --git a/tests/btrfs/002 b/tests/btrfs/002
> new file mode 100755
> index 0000000..d671688
> --- /dev/null
> +++ b/tests/btrfs/002
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/002
> +#
> +# btrfs send ENOENT regression test, from a user report on linux-btrfs
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
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send/snapshots/backup2 > /dev/null 2>&1
> +	$BTRFS_UTIL_PROG subvol del $TEST_DIR/$tmp_dir/send/snapshots/backup3 > /dev/null 2>&1
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
> +work_dir="$TEST_DIR/$tmp_dir/send"
> +mkdir $work_dir/testdir
> +mkdir $work_dir/testdir/1/
> +mkdir $work_dir/testdir/2/
> +dd if=/dev/urandom  of=$work_dir/testdir/aa count=16 > /dev/null 2>&1
> +dd if=/dev/urandom  of=$work_dir/testdir/bb count=16 > /dev/null 2>&1
> +
> +mkdir $work_dir/snapshots
> +$BTRFS_UTIL_PROG sub snap -r $work_dir $work_dir/snapshots/backup2 \
> +	>> $seqres.full 2>&1 || _fail "failed backup2"
> +$BTRFS_UTIL_PROG sub snap -r $work_dir $work_dir/snapshots/backup3 \
> +	>> $seqres.full 2>&1 || _fail "failed backup3"
> +$BTRFS_UTIL_PROG send $work_dir/snapshots/backup3/ -f $TEST_DIR/$tmp_dir/blah \
> +	>> $seqres.full 2>&1 || _fail "send failed"
> +$BTRFS_UTIL_PROG receive $SCRATCH_MNT -vvvv -f $TEST_DIR/$tmp_dir/blah \
> +	>> $seqres.full 2>&1 || _fail "receive failed"
> +
> +echo "Silence is golden"
> +status=0 ; exit
> diff --git a/tests/btrfs/002.out b/tests/btrfs/002.out
> new file mode 100644
> index 0000000..61705c7
> --- /dev/null
> +++ b/tests/btrfs/002.out
> @@ -0,0 +1,2 @@
> +QA output created by 002
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index 3afa04f..0733a1d 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -4,6 +4,7 @@
>  # - comment line before each group is "new" description
>  #
>  001 auto quick
> +002 auto quick
>  254 auto quick
>  264 auto
>  265 auto
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
