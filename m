Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 430A57F6D
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 19:22:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE6D3AC007
	for <xfs@oss.sgi.com>; Wed, 19 Mar 2014 17:22:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id W7T84UlNXF6Frn1r for <xfs@oss.sgi.com>;
	Wed, 19 Mar 2014 17:22:43 -0700 (PDT)
Message-ID: <532A34D3.8060805@sandeen.net>
Date: Wed, 19 Mar 2014 19:22:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] shared: new test to use up free inodes
References: <1395221269-11085-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

On 3/19/14, 4:27 AM, Eryu Guan wrote:
> Stress test fs by using up all inodes and check fs.
> 
> Also a regression test for xfsprogs commit
> d586858 xfs_repair: fix sibling pointer tests in verify_dir2_path()

Thanks Eryu.  I had started to write this test but ran into another bug
(where xfs blows past the maximum inode space %) so got distracted.

I see Dave's already picked apart the patch so I won't comment specifically
on it, but you might be aware of the possibility that xfs won't stop when
we hit the default imaxpct, and may actually fill the entire fs.  That's
not necessarily a problem but it may take longer than you expect.

I also wonder what's necessary to actually test the sibling pointer problem;
on xfs, it's probably just a sufficiently large directory, not necessarily
a full fs?

-Eric


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
> +
> +i=0
> +free_inode=`df -iP $SCRATCH_MNT | tail -1 | awk '{print $2}'`
> +loop=$((free_inode / 1000 + 1))
> +mkdir -p $SCRATCH_MNT/testdir
> +
> +echo "Create $((loop * 1000)) files in $SCRATCH_MNT/testdir" >>$seqres.full
> +while [ $i -lt $loop ]; do
> +	create_file $SCRATCH_MNT/testdir 1000 $i >>$seqres.full 2>&1 &
> +	let i=$i+1
> +done
> +wait
> +
> +# log inode status in $seqres.full for debug purpose
> +echo "Inode status after taking all inodes" >>$seqres.full
> +df -i $SCRATCH_MNT >>$seqres.full
> +
> +_check_scratch_fs
> +
> +# Check again after removing all the files
> +rm -rf $SCRATCH_MNT/testdir
> +echo "Inode status after deleting all test files" >>$seqres.full
> +df -i $SCRATCH_MNT >>$seqres.full
> +_check_scratch_fs
> +
> +status=0
> +exit
> diff --git a/tests/shared/006.out b/tests/shared/006.out
> new file mode 100644
> index 0000000..675c1b7
> --- /dev/null
> +++ b/tests/shared/006.out
> @@ -0,0 +1,2 @@
> +QA output created by 006
> +Silence is golden
> diff --git a/tests/shared/group b/tests/shared/group
> index 29f17b0..230e560 100644
> --- a/tests/shared/group
> +++ b/tests/shared/group
> @@ -8,6 +8,7 @@
>  003 auto quick prealloc
>  004 auto quick prealloc
>  005 auto prealloc
> +006 auto stress enospc
>  032 mkfs auto quick
>  051 acl udf auto quick
>  218 auto fsr quick
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
