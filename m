Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B462F7F6F
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 19:14:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 89FE3304062
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 17:14:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	frXAH0FXmsH4qPTt for <xfs@oss.sgi.com>;
	Wed, 19 Mar 2014 17:14:32 -0700 (PDT)
Date: Thu, 20 Mar 2014 11:14:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] shared: new test to use up free inodes
Message-ID: <20140320001429.GI7072@dastard>
References: <1395221269-11085-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1395221269-11085-1-git-send-email-eguan@redhat.com>
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
Cc: xfs@oss.sgi.com

On Wed, Mar 19, 2014 at 05:27:49PM +0800, Eryu Guan wrote:
> Stress test fs by using up all inodes and check fs.
> 
> Also a regression test for xfsprogs commit
> d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/shared/006     | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/shared/006.out |  2 ++
>  tests/shared/group   |  1 +
>  3 files changed, 99 insertions(+)
>  create mode 100755 tests/shared/006
>  create mode 100644 tests/shared/006.out
> 
> diff --git a/tests/shared/006 b/tests/shared/006
> new file mode 100755
> index 0000000..a3b13b6
> --- /dev/null
> +++ b/tests/shared/006
> @@ -0,0 +1,96 @@
> +#! /bin/bash
> +# FS QA Test No. shared/006
> +#
> +# Stress test fs by using up all inodes and check fs.
> +#
> +# Also a regression test for xfsprogs commit
> +# d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2014 Red Hat Inc.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +create_file()
> +{
> +	local dir=$1
> +	local nr_file=$2
> +	local prefix=$3
> +	local i=0
> +
> +	while [ $i -lt $nr_file ]; do
> +		touch $dir/${prefix}_${i}

echo -n > $dir/${prefix}_${i}

will create a zero length file without needing to fork/exec and so
will have much lower overhead and create the files significantly
faster.

> +		let i=$i+1
> +	done
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs ext4 ext3 ext2 xfs
> +_supported_os Linux
> +
> +_require_scratch
> +
> +rm -f $seqres.full
> +echo "Silence is golden"
> +
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mount

If this is going to be a stress test, you should add a scale factor
into this.

> +
> +i=0
> +free_inode=`df -iP $SCRATCH_MNT | tail -1 | awk '{print $2}'`

$DF_PROG

> +loop=$((free_inode / 1000 + 1))

And probably a LOAD_FACTOR into this to scale parallelism.

> +mkdir -p $SCRATCH_MNT/testdir
> +
> +echo "Create $((loop * 1000)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> +while [ $i -lt $loop ]; do
> +	create_file $SCRATCH_MNT/testdir 1000 $i >>$seqres.full 2>&1 &
> +	let i=$i+1
> +done
> +wait

On XFS, that will create at least 500 threads creating 1000 inodes each
all in the same directory. This doesn't give you any extra
parallelism at all over just creating $free_inode files in a single
directory with a single thread. Indeed, it will probably be slower
due to the contention on the directory mutex.

If you want to scale this in terms of parallelism to keep the
creation time down, each loop needs to write into a different
directory. i.e. something like:


echo "Create $((loop * 1000)) files in $SCRATCH_MNT/testdir" >>$seqres.full
while [ $i -lt $loop ]; do
	mkdir -p $SCRATCH_MNT/testdir/$i
	create_file $SCRATCH_MNT/testdir/$i 1000 $i >>$seqres.full 2>&1 &
	let i=$i+1
done
wait

And even then I'd suggest that you'd be much better off with 10,000
files to a sub-directory....

> +# log inode status in $seqres.full for debug purpose
> +echo "Inode status after taking all inodes" >>$seqres.full
> +df -i $SCRATCH_MNT >>$seqres.full
> +
> +_check_scratch_fs
> +
> +# Check again after removing all the files
> +rm -rf $SCRATCH_MNT/testdir

That can be parallelised as well when you have multiple subdirs:

for d in $SCRATCH_MNT/testdir/*; do
	rm -rf $d &
done
wait

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
