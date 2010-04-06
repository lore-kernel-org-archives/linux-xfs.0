Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o36FRpJs111979 for <xfs@oss.sgi.com>; Tue, 6 Apr 2010 10:27:51 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C63291DCDD01
	for <xfs@oss.sgi.com>; Tue,  6 Apr 2010 08:29:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tC2OKjifalqI6RR6 for
	<xfs@oss.sgi.com>; Tue, 06 Apr 2010 08:29:40 -0700 (PDT)
Message-ID: <4BBB535B.90209@sandeen.net>
Date: Tue, 06 Apr 2010 10:29:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsqa: new fsr defragmentation test
References: <1270543927-17129-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1270543927-17129-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/06/2010 03:52 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This test aims to recreate the conditions that caused xfs_fsr to
> corrupt inode forks. The problem was that the data forks between the
> two inodes were in different formats due to different inode fork
> offsets, so when they swapped the data forks the formats were
> invalid.
> 
> This test generates a filesystem with a known fragmented freespace pattern and
> then abuses known "behaviours" of the allocator to generate files
> with a known number of extents. It creates attributes to generate a
> known inode fork offset, then uses a debug feature of xfs_fsr to
> attempt to defrag the inode to a known number of extents.
> 
> By using these features, we can pretty much cover the entire matrix of inode
> fork configurations, hence reproducing the conditions that lead to corruptions.
> This test has already uncovered one bug in the current kernel code, and the
> current fsr (with it's naive attribute fork handling) is aborted on a couple of
> hundred of the files created by this test.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  226     |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  226.out |    2 +
>  group   |    3 +-
>  3 files changed, 196 insertions(+), 1 deletions(-)
>  create mode 100644 226
>  create mode 100644 226.out
> 
> diff --git a/226 b/226
> new file mode 100644
> index 0000000..b92292a
> --- /dev/null
> +++ b/226
> @@ -0,0 +1,192 @@
> +#! /bin/bash
> +# FS QA Test No. 222

s/b 226

Looks like a good test but how fragile will it be in the face of changes
to the known allocator behaviors?  :)

-Eric

> +# xfs_fsr QA tests
> +# run xfs_fsr over the test filesystem to give it a wide and varied set of
> +# inodes to try to defragment. This is effectively a crash/assert failure
> +# test looking for corruption induced by the kernel inadequately checking
> +# the indoes to be swapped. It also is good for validating fsr's attribute fork
> +# generation code.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Dave Chinner.  All Rights Reserved.
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
> +# creator
> +owner=david@fromorbit.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +[ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
> +
> +# create freespace holes of 1-3 blocks in length
> +#
> +# This is done to ensure that defragmented files have roughly 1/3 the
> +# number of extents they started with. This will ensure we get
> +# transistions from btree format (say 15 extents) to extent format
> +# (say 5 extents) and lots of variations around that dependent on the
> +# number of attributes in the files being defragmented.
> +#
> +fragment_freespace()
> +{
> +	_file="$SCRATCH_MNT/not_free"
> +
> +	for i in `seq 0 1 10000`; do
> +		echo foo > $_file.$i
> +	done
> +	sync
> +
> +	for i in `seq 0 2 10000`; do
> +		rm -f $_file.$i
> +	done
> +	for i in `seq 0 7 10000`; do
> +		rm -f $_file.$i
> +	done
> +	sync
> +
> +	# and now use up all the remaining extents larger than 3 blocks
> +	dd if=/dev/zero of=$_file.large bs=4k count=1024 > /dev/null 2>&1
> +	sync
> +}
> +
> +create_attrs()
> +{
> +	for foo in `seq 0 1 $1`; do
> +		setfattr -n user.$foo -v 0xbabe $2
> +	done
> +}
> +
> +create_data()
> +{
> +	for foo in `seq $1 -1 0`; do
> +		let offset=$foo*4096
> +		$XFS_IO_PROG -f -c "pwrite $offset 4096" -c "fsync" $2 > /dev/null 2>&1
> +	done
> +	xfs_bmap -vp $2
> +}
> +
> +# create the designated file with a certain number of attributes and a certain
> +# number of data extents. Reverse order synchronous data writes are used to
> +# create fragmented files, though with the way the filesystem freespace is
> +# fragmented, this is probably not necessary. Create the attributes first so
> +# that they cause the initial fork offset pressure to move it about.
> +#
> +create_target_attr_first()
> +{
> +	nattrs=$1
> +	file_blocks=$2
> +	target=$3
> +
> +	rm -f $target
> +	echo > $target
> +	create_attrs $nattrs $target
> +	create_data $file_blocks $target
> +}
> +
> +# Same as create_target_attr_first, but this time put the attributes on after
> +# the data extents have been created. This puts different pressure on the
> +# inode fork offset, so should exercise the kernel code differently and give us
> +# a different pattern of fork offsets to work with compared to creating the
> +# attrs first.
> +#
> +create_target_attr_last()
> +{
> +	nattrs=$1
> +	file_blocks=$2
> +	target=$3
> +
> +	rm -f $target
> +	echo > $target
> +	create_data $file_blocks $target
> +	create_attrs $nattrs $target
> +}
> +
> +rm -f $seq.full
> +umount $SCRATCH_MNT
> +
> +# use a small filesystem so we can control freespace easily
> +_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seq.full 2>&1
> +_scratch_mount
> +fragment_freespace
> +
> +# unmount and remount to reset all allocator indexes
> +umount $SCRATCH_MNT
> +_scratch_mount
> +
> +# create a range of source files, then fsr them to a known size
> +#
> +# This assumes 256 byte inodes.
> +#
> +# n = number of target fragments for xfs_fsr
> +#	- only a guideline, but forces multiple fragments via sync writes
> +#	- start at 4 as that typically covers all extent format situations
> +#	- end at 12 as that is beyond the maximum that canbe fit in extent
> +#	  format
> +# i = number of 2 byte attributes on the file
> +#	- it takes 6 attributes to change the fork offset from the start value
> +#	  of 120 bytes to 112 bytes, so we start at 5.
> +#	- 15 is enough to push to btree format, so we stop there.
> +# j = number of data extents on the file
> +#	- start in extent format, but we also want btree format as well, so
> +#	  start at 5 so that the number of attributes determines the starting
> +#	  format.
> +#	- need enough extents that if they are all 3 blocks in length the final
> +#	  format will be dependent on the number of attributes on the inode. 20
> +#	  initial single block extents gives us 6-8 extents after defrag which
> +#	  puts us right on the threshold of what the extent format can hold.
> +
> +targ=$SCRATCH_MNT/fsr_test_file.$$
> +for n in `seq 4 1 12`; do
> +	echo "*** n == $n ***" >> $seq.full
> +	for i in `seq 5 1 15`; do
> +		for j in `seq 5 1 20`; do
> +			create_target_attr_first $i $j $targ.$i.$j >> $seq.full 2>&1
> +		done
> +		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seq.full 2>&1
> +		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
> +		for j in `seq 5 1 20`; do
> +			create_target_attr_last $i $j $targ.$i.$j >> $seq.full 2>&1
> +		done
> +		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seq.full 2>&1
> +		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
> +	done
> +done
> +
> +umount $SCRATCH_MNT
> +_check_scratch_fs
> +echo "--- silence is golden ---"
> +status=0 ; exit
> diff --git a/226.out b/226.out
> new file mode 100644
> index 0000000..52c0c1f
> --- /dev/null
> +++ b/226.out
> @@ -0,0 +1,2 @@
> +QA output created by 226
> +--- silence is golden ---
> diff --git a/group b/group
> index 3164c37..2386c41 100644
> --- a/group
> +++ b/group
> @@ -339,4 +339,5 @@ deprecated
>  223 auto quick
>  224 auto
>  225 auto quick
> -500 auto quota
> \ No newline at end of file
> +226 auto fsr
> +500 auto quota
> -- 1.6.5 _______________________________________________ xfs mailing
> list xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
