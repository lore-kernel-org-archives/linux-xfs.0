Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9F1F7F50
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 17:30:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F86F8F8039
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 15:30:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ocApgWErPVe9L3zD for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 15:29:57 -0700 (PDT)
Date: Tue, 22 Oct 2013 09:29:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests generic/320: heavy rm workload test
Message-ID: <20131021222955.GD16161@dastard>
References: <1382360484-6570-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382360484-6570-1-git-send-email-eguan@redhat.com>
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

On Mon, Oct 21, 2013 at 09:01:24PM +0800, Eryu Guan wrote:
> This test is based on generic/273, a regression test for commit
> 
> 9a3a5da xfs: check for stale inode before acquiring iflock on push
> 
> On unpatched kernel, rm processes would hang.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/generic/320     | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/320.out |   2 +
>  tests/generic/group   |   2 +-
>  3 files changed, 142 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/320
>  create mode 100644 tests/generic/320.out
> 
> diff --git a/tests/generic/320 b/tests/generic/320
> new file mode 100755
> index 0000000..afe35a3
> --- /dev/null
> +++ b/tests/generic/320
> @@ -0,0 +1,139 @@
> +#! /bin/bash
> +# FS QA Test No. generic/320
> +#
> +# heavy rm workload
> +#
> +# Regression test for commit:
> +# 9a3a5da xfs: check for stale inode before acquiring iflock on push
> +#
> +# Based on generic/273
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +. ./common/rc
> +. ./common/filter
> +
> +threads=50
> +count=2
> +
> +_threads_set()
> +{
> +	_cpu_num=`grep -c processor /proc/cpuinfo`
> +	threads=$(($_cpu_num * 50))
> +	if [ $threads -gt 200 ]
> +	then
> +		threads=200
> +	fi
> +}
> +
> +_file_create()
> +{
> +	_i=0
> +
> +	if ! mkdir $SCRATCH_MNT/origin
> +	then
> +		echo "mkdir origin err"
> +		status=1
> +		exit
> +	fi

mkdir on a scratch device you just created shouldn't ever fail. We
don't ibother adding noise to tests for such basic functionality
unless we are specifically testing basic functionality.

> +	cd $SCRATCH_MNT/origin

ORIGIN=$SCRATCH_MNT/origin

> +
> +	_disksize=`df --block-size=1 $SCRATCH_DEV | $AWK_PROG -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`

What's all that about?

	df --block-size=1 $SCRATCH_DEV | awk '/^\// {print $4}'

gives the same result.

But given that you do a scratch_mkfs_sized call belowi and then you
reduce the "disksize" by a factor of 3, why are you even probing to
calculate the size of the filesystem?

> +	_disksize=$(($_disksize / 3))
> +	_num=$(($_disksize / $count / $threads / 4096))
> +	_count=$count
> +	while [ $_i -lt $_num ]
> +	do
> +		dd if=/dev/zero of=file_$_i bs=4096 count=$_count >/dev/null 2>&1
> +		_i=$(($_i + 1))
> +	done

Use XFS_IO_PROG, not dd. and use $ORIGIN/file.$_i so you don't need
to change directories.

> +
> +	cd $here
> +}
> +
> +_worker()
> +{
> +	_suffix=$1
> +
> +	if ! mkdir $SCRATCH_MNT/sub_$_suffix
> +	then
> +		echo "mkdir sub_xxx err"
> +		status=1
> +		exit
> +	fi

Again, no need to test this.
> +
> +	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seqres.full 2>&1
> +	rm -rf $SCRATCH_MNT/sub_$_suffix
> +}
> +
> +_do_workload()
> +{
> +	_pids=""
> +	_pid=1
> +
> +	_threads_set
> +	_file_create
> +
> +	_threads=$threads
> +
> +	while [ $_pid -lt $_threads ]
> +	do
> +		_worker $_pid &
> +		_pids="$_pids $!"
> +		_pid=$(($_pid + 1))
> +	done
> +
> +	wait $_pids
> +}

Can we get rid of all these leading "_" from the variables? That is
supposed to be used for library functions, not for variables local
to the test itself.

> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os IRIX Linux
> +_require_scratch

these should be called before any local test functions.

> +echo "Silence is golden"
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
> +_scratch_mount >>$seqres.full 2>&1
> +
> +_do_workload
> +
> +_check_scratch_fs
> +status=$?

_check_scratch_fs will exit if it fails, so status=0 is all you need
there.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
