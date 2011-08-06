Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76E6o3S167841 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 09:06:51 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 280114C91B8
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 07:06:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wJjDoghKNBOCCFDs for <xfs@oss.sgi.com>;
	Sat, 06 Aug 2011 07:06:45 -0700 (PDT)
Date: Sun, 7 Aug 2011 00:06:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] snapshot, defragment and raid test cases for btrfs
Message-ID: <20110806140641.GE3162@dastard>
References: <4E3BA2F7.4080500@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 05, 2011 at 03:59:51PM +0800, Anand Jain wrote:
> 
> Hi,
> 
>  Attached is the patch for the xfstests, which adds snapshot,
>  defragment and volume management test cases for the btrfs
>  (257, 258 and 259 respectively).

A patch per test is the preferred form for review.

>  This introduces a new user variable 'DISK_POOL' which should
>  be set to disks for the raid tests.

It's used as part of the scratch device, so it'd probaby be better
to call it "SCRATCH_DEV_POOL". Indeed, if you do that, you could
then leave SCRATCH_DEV empty and fill it out with the first device
of the pool by default when setting up the scratch device in the
first place. That woul dthen get around all the mess you have where
you have to do "$SCRATCH_DEV $DISK_POOL" concatenations in all the
tests using the disk pool....

> 
>  An example of usage of these tests is as below.
> ------------
> [root@localhost xfstests]# cat local.config
> TEST_DEV="/dev/sdd"
> TEST_DIR=/btrfs
> SCRATCH_DEV="/dev/sde"
> SCRATCH_MNT=/btrfs1
> DISK_POOL="/dev/sdf /dev/sdg"
> [root@localhost xfstests]#
> 
> [root@localhost xfstests]# ./check 257 258 259
> FSTYP -- btrfs
> PLATFORM -- Linux/i686 localhost 3.0.0-rc6+
> MKFS_OPTIONS -- /dev/sde
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sde /btrfs1
> 
> 257 8s
> 258 3s
> 259 33s
> Ran: 257 258 259
> Passed all 3 tests
> ----------------
> 
>  Thank you.
> 
> Anand

> From 62d90cd24afc192e091d9b81fb78d7c666237e97 Mon Sep 17 00:00:00 2001
> From: Anand Jain <Anand.Jain@oracle.com>
> Date: Fri, 5 Aug 2011 15:36:25 +0800
> Subject: [PATCH] Adding 257, 258, 259 to test snapshot, defragment and raid in btrfs
> 
> Adding test case number 257, 258 and 259 to test snapshot, defragment
> and raid support in btrfs. This also adds a user input variable
> 'DISK_POOL'.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  257               |  198 ++++++++++++++++++++++++++++++++++++++++++
>  257.out           |    8 ++
>  258               |   75 ++++++++++++++++
>  258.out           |    2 +
>  259               |  220 +++++++++++++++++++++++++++++++++++++++++++++++
>  259.out           |    9 ++
>  common.rc         |   58 +++++++++++++
>  group             |    3 +
>  src/checksum_misc |   28 ++++++
>  src/devmgt        |   25 ++++++
>  src/fsmisc        |  247 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  src/randmisc      |   70 +++++++++++++++
>  src/snapmisc      |   73 ++++++++++++++++

Put all of these "misc" stuff in a common.snapshot file
or something similar. The src directory is for source code to
binaries that need to be built for other tests...

> diff --git a/257 b/257
> new file mode 100755
> index 0000000..2a75944
> --- /dev/null
> +++ b/257
> @@ -0,0 +1,198 @@
> +#! /bin/bash
> +# FS QA Test No. 257
> +#
> +# Extented btrfs snapshot test cases
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2011 Oracle  All Rights Reserved.
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
> +owner=anand.jain@oracle.com
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
> +_need_to_be_root
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +. ./src/checksum_misc
> +. ./src/randmisc
> +. ./src/fsmisc
> +. ./src/snapmisc
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +#FS fill size
> +#name="DirDepth MinFiles MaxFiles MinFileSz MaxFileSz"
> +QUICK="1 4 4 4096 4096"
> +SMALL="1 10 100 4096 8192"
> +MEDIUM="10 30 1000 4096 8192"
> +LARGE="1000 1 1000 4096 1048576"
> +FDPROF=$QUICK
> +dolog=1
> +
> +# compare check sum of $1 with $2
> +_testa_snap_check()
> +{
> +	local volname
> +	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
> +	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
> +	save_checksum $1 $tmp.$volname.sum

Please remove dead code (from eveywhere).

> +	#$here/src/checksum_misc verify_checksum $2 $tmp.$volname.sum
> +	verify_checksum $2 $tmp.$volname.sum
> +	[ $dolog = 1 ] && echo "testa_snap_check ok"

Please remove all the dolog stuff - the test requires the output to
pass, so it isn't conditional.

As it is, i don't think this is the best way to verify checksums.
See below as I get to the fsfill code....

> +_testb_file_append_check()
> +{
> +	local volname
> +
> +	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
> +	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
> +	save_checksum $1 $tmp.$volname.sum
> +
> +	# modify the snap
> +	# $here/src/fsmisc modifyfs_fillblk ${2}
> +	modifyfs_fillblk ${2}

modify_fs_fillblk is only used here. It doesn't need to be a generic
function. just open code it here and not force people to look in a
different place to find out what the test does.

> +	#$here/src/fsmisc check_sum $1 $tmp.$volname.sum
> +	verify_checksum $1 $tmp.$volname.sum
> +	echo "testb_file_append_check ok"
> +}
> +
> +
> +# arg1: Original subvolume
> +# arg2 : its snapshot
> +_testc_file_append2_check()
> +{
> +	local volname
> +
> +	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
> +	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
> +	save_checksum $1 $tmp.$volname.sum
> +
> +	#$here/src/fsmisc modifyfs_append $2
> +	modifyfs_append $2

Ditto for modifyfs_append.

> +
> +	#$here/src/checksum_misc verify_checksum $1 $tmp.$volname.sum
> +	verify_checksum $1 $tmp.$volname.sum
> +	echo "testc_file_append2_check ok"
> +}
> +
> +# arg1: Original subvolume
> +# arg2 : its snapshot
> +_testd_read_modify_check()
> +{
> +	local volname
> +
> +	volname=`echo $1 | rev | cut -d"/" -f1 | rev`
> +	#$here/src/checksum_misc save_checksum $1 $tmp.$volname.sum
> +	save_checksum $1 $tmp.$volname.sum
> +	#$here/src/fsmisc modifyfs_readmodifywrite ${2}
> +	modifyfs_readmodifywrite ${2}

Ditto for modifyfs_readmodifywrite.

> +
> +	#$here/src/checksum_misc verify_checksum $1 $tmp.$volname.sum
> +	verify_checksum $1 $tmp.$volname.sum
> +	echo "testd_read_modify_check ok"
> +}
> +
> +# arg 1: depth
> +# arg 2: base vol
> +_teste_nested_snap_check()
> +{
> +	local n
> +	local x
> +
> +	# we need two additional snapshot to compare
> +	#$here/src/snapmisc create_nestedclones $(($1+2)) $2
> +	create_nestedclones $(($1+2)) $2
> +	#$here/src/snapmisc update_clonelist
> +	update_clonelist
> +
> +	n=${#CLONE_LIST[*]}
> +	if [ $n -lt $1 ]; then echo Clone List Error; status=1; exit; fi
> +
> +	dolog=0
> +	for i in `seq 1 $1`
> +	do
> +		n=$(($n-1))
> +		_testa_snap_check ${CLONE_LIST[$(($n-1))]} ${CLONE_LIST[$n]}
> +	done
> +	dolog=1
> +	echo "teste_nested_snap_check ok"
> +}
> +
> +_testf_delete_file_check()
> +{
> +	local org=$1
> +	local org_n=`echo $org | rev | cut -d"/" -f1 | rev`
> +	local afile
> +
> +	#$here/src/checksum_misc save_checksum $org $tmp.${org_n}.sum
> +	save_checksum $org $tmp.${org_n}.sum
> +
> +	#afile=`$here/src/randmisc picka rfile ${2}`
> +	afile=`picka rfile ${2}`
> +	#$here/src/fsmisc modifyfs_delete $afile
> +	modifyfs_delete $afile

Same for modifyfs_delete - all it does is run 'rm -f <file>'!

> +
> +	#$here/src/checksum_misc verify_checksum $org $tmp.${org_n}.sum
> +	verify_checksum $org $tmp.${org_n}.sum
> +
> +	echo "testf_delete_file_check ok"
> +}
> +
> +# real QA test starts here
> +
> +firstvol="$SCRATCH_MNT/sv1"
> +btrfs subvolume create $firstvol | _filter_scratch
> +#$here/src/fsmisc fillfs $firstvol $FDPROF
> +fillfs $firstvol $FDPROF

If you are using the QUICK config, then you aren't using any of the
randomness that fillfs actually provides, so why don't you use
_populate_fs? From common.rc:

# Populate a filesystem with inodes for performance experiments
#
# usage: populate [-v] [-n ndirs] [-f nfiles] [-d depth] [-r root] [-s size]

(yeah, I know, the function is called _populate_fs, not populate)

One of the reasons I suggest for usingthis is that I don't think
randomness is a good property for a regression test - you cannot
repeat the same test twice in a row, which defeats the purpose of
having a regression test. See comments on the fillfs function below.

> +SNAPNAME=0
> +#$here/src/snapmisc create_snap $firstvol $SCRATCH_MNT
> +create_snap $firstvol $SCRATCH_MNT
> +# Single clone test
> +_testa_snap_check $firstvol $SNAPNAME
> +_testb_file_append_check $firstvol $SNAPNAME
> +_testc_file_append2_check $firstvol $SNAPNAME
> +_testd_read_modify_check $firstvol $SNAPNAME
> +# nested clone test
> +_teste_nested_snap_check  7 $firstvol  # as of now don't do beyond 7 - btrfs bug
> +SNAPNAME=0
> +create_snap $firstvol $SCRATCH_MNT
> +_testf_delete_file_check $firstvol $SNAPNAME

Please separate the different tests by a line of whitespace. i.e.
everywhere you've got a comment, put a line of whitespce before it.


....

[defrag test]

> +#FS fill size
> +#name="DirDepth MinFiles MaxFiles MinFileSz MaxFileSz"
> +QUICK="1 4 4 4096 4096"
> +SMALL="1 10 100 4096 8192"
> +MEDIUM="10 30 1000 4096 8192"
> +LARGE="1000 1 1000 4096 1048576"
> +FDPROF=$QUICK

You only use one of these test setups, so  why even have two levels
of indirection and a bunch of unused configurations?

> +
> +_testa_defrag()
> +{
> +        btrfs filesystem defragment $1
> +        if [ ! $? ]; then echo "Error: Defrag failed"; exit; fi

The normal thing to do here is:

        btrfs filesystem defragment $1 || _fail "Defrag failed with $?"

> +        echo "testa_defrag.... ok"
> +}
> +
> +fillfs $SCRATCH_MNT $FDPROF
> +_testa_defrag $SCRATCH_MNT

You don't need a function here. The test is effectively:

echo "silence is golden"

# fillfs DirDepth MinFiles MaxFiles MinFileSz MaxFileSz
fillfs 1 4 4 4096 4096
btrfs filesystem defragment $1 || _fail "Defrag failed with $?"

That's 2 lines of code for the test, and zero indirection.

> diff --git a/258.out b/258.out
> new file mode 100644
> index 0000000..6ccf5cf
> --- /dev/null
> +++ b/258.out
> @@ -0,0 +1,2 @@
> +QA output created by 258
+silence is golden

.....
> +# btrfs vol tests
.....
> +#FS fill size
> +#name="DirDepth MinFiles MaxFiles MinFileSz MaxFileSz"
> +QUICK="1 4 4 4096 4096"
> +SMALL="1 10 100 4096 8192"
> +MEDIUM="10 30 1000 4096 8192"
> +LARGE="1000 1 1000 4096 1048576"
> +FDPROF=$QUICK
> +
> +FSDEV="$SCRATCH_DEV $DISK_POOL"

Why?

> +if_error()
> +{
> +        if [[ $? -ne 0 ]]; then
> +                echo "$1"
> +                exit
> +        fi
> +}

Seriously?

> +fun_error()
> +{
> +        echo $1
> +        exit
> +}

dead code

> +test1_default()
> +{
> +	local i

dead.

> +	mk_fs $1 "$2"

Oh, no, you didn't implement your own mkfs function as well?

Please have a look at common.rc and the scratch_mkfs functions and
how that supports different filesystems. Add your multiple device
mkfs operations to the btrfs part of that code.

Oh, and to mount it, use 'scratch_mount' and you don't need to pass
the mountpoint to every function...


[....]

> +test6_add()
> +{
> +	local i
> +	local devs[]="( $2 )"
> +	local n=${#devs[@]}

ugh.

> +
> +	n=$(($n-1))
> +
> +	_trace_wipe "$2"

What the does this do? it appears to dd zeros over the first
400k of the devices passed to it. Why? And if it's needed for
mkfs.btrfs to work successfully, then why wasn't this done in your
mk_fs function? What bug in btrfs is this working around?

> +	mk_fs $1 "${devs[0]}"
> +	fillfs $1 $FDPROF
> +	for i in `seq 1 $n`
> +	do
> +		# echo i=$i ${devs[$i]} $1
> +		btrfs device add ${devs[$i]} $1 2>&1 > /dev/null
> +	done

You do all that nasty array stuff, when all you need to is this:

	while [ $# -gt 0 ]; do
		btrfs device add $1 $SCRATCH_MNT 2>&1 > /dev/null
		shift;
	done

(assuming you aren't passing the mount point as $1 anymore)

> +	btrfs filesystem balance $1
> +	btrfs filesystem show 2>&1 | egrep devid |awk '{
> +		if ( $6 == "0.00" ) {
> +			print "Error: Device "$8" balance failed"
> +			exit
> +		}
> +	}'
> +	if_error "Error: test6_add... failed"

	[ $? -eq 0 ] || _fail "test6_add failed with $?"

> +	echo "test6_add ok"
> +}
> +
> +test7_replace()
> +{
> +	local i
> +	local x
> +	local devs=( $2 )
> +	local n=${#devs[@]}
> +	local ds
> +	local DEVHTL=""
> +
> +	if [ $n -lt 3 ]; then echo "Error: Need atleast 3 physical disks for the vol:test7_replace"; exit; fi

This test should not be here - it should in the main test setup
section and use '_not_run "Requires at least 3 scratch devices"'.
That is, not having 3 devices is not a failure, it's a reason not to
run the test.

Indeed, because none of the other tests have this requirement, you
shoul dput this into it's own test so that the other tests here can
still be run even if this is not met.


> +	n=$(($n-1))
> +	ds=${devs[@]:0:$n}

Ah, what?

I can't work out what this....

> +	_trace_wipe "$2"
> +	mk_fs $1 "$ds"
> +	fillfs $1 $FDPROF
> +
> +	#fail a disk
> +	ds=${devs[@]:$(($n-1)):1}

... and this are doing even after spending 5 minutes reading the
bash man page.

Seriously, if you're going to write code that looks like line noise,
comment it so people who aren't bash experts can understand what
your intent is here. I'll have to refer to the bash man page every
time i look at this code, so I really can't tell if it's doing what
you meant or whether it's broken.

Write dumb code - it's far easier to review and maintain....

> +	devmgt remove ${ds}
> +
> +	btrfs fi show | egrep "Some devices missing" > /dev/null 2>&1
> +	if_error "Error: btrfs did not report device missing"
> +	# if [ ! $? ]; then echo "Error: btrfs did not report device missing"; exit; fi
> +
> +	# add a new disk to btrfs
> +	ds=${devs[@]:$(($n)):1}
> +	btrfs device add ${ds} ${1}
> +	btrfs fi balance $1
> +	btrfs filesystem show 2>&1 | egrep devid |awk '{
> +		if ( $6 == "0.00" ) {
> +			print "Error: Device "$8" balance failed"
> +			exit
> +		}
> +	}'
> +	if_error "Error: test7_repalce... failed"
> +	echo "test7_replace ok"
> +
> +	# cleaup. add the removed disk
> +	umount $1 > /dev/null 2>&1
> +	devmgt add "${DEVHTL}"
> +}
> +
> +function test8_remove
> +{
> +	local res="ok"
> +	_trace_wipe "$2"
> +	mk_fs $1 "$2"
> +	fillfs $1 $FDPROF
> +
> +	dev_del=`echo ${2} | awk '{print $NF}'`

Why use a different method for calulating the number of devices to
test 7? This version is far easier to understand, though I still
don't know if it is correct because there's nothing that describes
what the test is supposed tobe doing....

> +	btrfs device delete $dev_del $1 || if_error "Error: delete failed"
> +
> +	btrfs fi balance $1
> +	btrfs filesystem show 2>&1 | egrep devid |awk '{
> +		if ( $6 == "0.00" ) {
> +			print "Error: Device "$8" balance failed"
> +			exit
> +		}
> +	} '

	btrfs filesystem show 2>&1 | awk '/devid/ {

> +	if_error "test8_remove... failed"
> +	echo "test8_remove ok"
> +	umount $1 > /dev/null 2>&1

scratch_umount

> +	_trace_wipe "$2"

why?

> +}
> +
> +test1_default $SCRATCH_MNT "$FSDEV"
> +test2_raid0 $SCRATCH_MNT "$FSDEV"
> +test3_raid1 $SCRATCH_MNT "$FSDEV"
> +test4_raid10 $SCRATCH_MNT "$FSDEV"
> +test5_single $SCRATCH_MNT "$FSDEV"
> +test6_add $SCRATCH_MNT "$FSDEV"
> +test7_replace $SCRATCH_MNT "$FSDEV"
> +test8_remove $SCRATCH_MNT "$FSDEV"
> +
> +status=0
> +exit
> diff --git a/259.out b/259.out
> new file mode 100644
> index 0000000..b3bd62a
> --- /dev/null
> +++ b/259.out
> @@ -0,0 +1,9 @@
> +QA output created by 259
> +test1_default ok
> +test2_raid0 ok
> +test3_raid1 ok
> +test4_raid10 ok
> +test5_single ok
> +test6_add ok
> +test7_replace ok
> +test8_remove ok
> diff --git a/common.rc b/common.rc
> index cb23a02..a354f69 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1559,7 +1559,65 @@ _test_inode_extsz()
>      echo $blocks
>  }
>  
> +_require_disk_pool()
> +{
> +	local i
> +	case "$FSTYP" in
> +	btrfs)
> +		if [ -z "$DISK_POOL" ]
> +		then
> +			_notrun "this test requires a valid \$DISK_POOL"
> +		fi

The usual format is:

		if [ -z "$DISK_POOL" ]; then
			.....
		fi

> +		if [ "`echo $DISK_POOL|wc -w`" -lt 2 ]
> +		then
> +			_notrun "this test needs more than 1 disk in DISK_POOL"
> +		fi
> +
> +		for i in $DISK_POOL
> +		do

Same:		for i in $DISK_POOL; do

> +			if [ "`_is_block_dev $i`" = "" ]
> +			then
> +				_notrun "this test requires valid block disk $i"
> +			fi
> +			if [ "`_is_block_dev $i`" = "`_is_block_dev $TEST_DEV`" ]
> +			then
> +				_notrun "$i is part of TEST_DEV, this test requires unique disks"
> +			fi
> +			if [ "`_is_block_dev $i`" = "`_is_block_dev $SCRATCH_DEV`" ]
> +			then
> +				_notrun "$i is part of SCRATCH_DEV, this test requires unique disks"
> +			fi
> +			if _mount | grep -q $i
> +			then
> +				if ! $UMOUNT_PROG $i
> +			        then
> +			            echo "failed to unmount $i - aborting"
> +			            exit 1
> +			        fi
> +			fi
> +			dd if=/dev/zero of=$i bs=4096 count=100 > /dev/null 2>&1

Umm, why is this zeroing here? Once again, if this is necessary then
it should be done only when necessary by the code that needs to do
it (i.e. the mkfs or device add/remove commands).

> +		done
> +	;;
> +	esac
> +}

Needs to _notrun for all FSTYPs other than btrfs.

> +_trace_wipe()
> +{
> +	local i
> +	case "$FSTYP" in
> +	btrfs)
> +		for i in $1
> +		do
> +			dd if=/dev/zero of=$i bs=4096 count=100 > /dev/null 2>&1
> +			if [ $? != 0 ]
> +			then
> +				echo "disk $i access failed"
> +				exit 1
> +			fi
> +		done
> +	;;
> +	esac
> +}

This needs to be folded into whatever btrfs mkfs code that needs it.

>  ################################################################################
>  
>  if [ "$iam" != new -a "$iam" != bench ]
> diff --git a/group b/group
> index 0c746c8..62eebfb 100644
> --- a/group
> +++ b/group
> @@ -370,3 +370,6 @@ deprecated
>  254 auto quick
>  255 auto quick prealloc
>  256 auto quick
> +257 auto quick
> +258 auto quick
> +259 auto quick
> diff --git a/src/checksum_misc b/src/checksum_misc
> new file mode 100644
> index 0000000..42488cb
> --- /dev/null
> +++ b/src/checksum_misc
> @@ -0,0 +1,28 @@
> +#! /bin/bash
> +# To Create the sha256 sum for the arg1
> +# arg1 FS to generate sha256
> +# arg2 File name to save the sha256 output
> +function save_checksum()
> +{
> +	local i=0
> +	>$2
> +	cd $1
> +	#echo "$1"
> +	for i in `find . -type f`; do sha256sum $i >> $2; done
> +	cd $OLDPWD
> +}
> +
> +
> +
> +# To check the sha256 for the TESTFS
> +# arg1 FS to be tested
> +# arg2 sha256 file
> +function verify_checksum()
> +{
> +	cd $1
> +	if [ ! -f $2 ]; then echo "$2 file not found"; status=1;exit; fi
> +	#$SHA256SUM --status -c $2 | $GREP "FAILED"
> +	sha256sum -c $2 | grep "FAILED"
> +	if [ $? == 0 ]; then status=1;exit; fi
> +	cd $OLDPWD
> +}

This checksum stuff only appears to be used by a single
test, so put it in that test.

Further, it you use files of a known contents (rather that reading
from /dev/urandom), you only need to dump the checksum into the
golden output and you don't need a verify step at all as the golden
image check at the end of the test will do it for you. (i.e. if the
checksum is different to that in the golden output, the test will
fail.) See 242 and 252 for examples of this style of checksum
verification.

> diff --git a/src/devmgt b/src/devmgt
> new file mode 100644
> index 0000000..d86b5c9
> --- /dev/null
> +++ b/src/devmgt
> @@ -0,0 +1,25 @@
> +#! /bin/bash
> +# arg 1 remove/add
> +# arg 2 /dev/sdx or return of devmgt resply
> +function devmgt
> +{
> +	local x
> +	local d
> +
> +	if [ ${1} == "remove" ]; then
> +		d=`echo $2|cut -d"/" -f3`
> +		x=`ls -l /sys/class/block/${d} | cut -d "/" -f12 | sed 's/:/ /g'`
> +		#log_event log "Removing the disk ${d} ${x} ..."
> +		echo "scsi remove-single-device ${x}" > /proc/scsi/scsi

I don't have a /proc/scsi on any of my machines, even those with SAS
disks. So tests that use this are going to need a test for having
support for this API and _not_run if it doesn't exist.

> +		if [ ! $? ]; then echo "Error: Remove a disk failed"; exit 1; fi
> +		DEVHTL=${x}
> +		#log_event done
> +		return
> +	else
> +		#log_event log "cleaning.. adding back the removed disk ${2} .. "
> +		echo "scsi add-single-device ${2}" > /proc/scsi/scsi
> +		if [ ! $? ]; then echo "Error: Remove a disk failed"; exit 1; fi
> +		#log_event done
> +		return

I was going to ask what device this operated on, but I see that the
global DEVHTL is passed back into the add function. needs
documentation that the device needs to be stored by the caller....

> +	fi
> +}

As it is, this function is only by a single test - you should move
it into that test given the _notrun check requirement. And it
probably shoul dbe two functions - one for remove and one for add...

> diff --git a/src/fsmisc b/src/fsmisc
> new file mode 100644
> index 0000000..2ee942d
> --- /dev/null
> +++ b/src/fsmisc
> @@ -0,0 +1,247 @@
> +#! /bin/bash
> +# Create Dir tree and files in it.
> +# arg1 basedir
> +# arg2 dir depth
> +# arg3 nfile_min
> +# arg4 nfile_max
> +# arg5 fsize_min
> +# arg6 fsize_max
> +
> +function fillfs()
> +{
> +	umask 000
> +	local j
> +	local i
> +	local DIRP
> +	local FCNT
> +	local FILEP
> +	local SCNT
> +	local BCNT
> +	#log_event log "filling $1 with dir=$2 files=$3 to $4 of size=$5 to $6....."
> +	DIRP=$1
> +	for ((j=0; j<$2; j++))
> +	do
> +		DIRP=`mktemp -dq $DIRP/dir.XXXXXX`
> +		FCNT=$(r_ranged $3 $4)
> +		for ((i=0; i<$FCNT; i++))
> +		do
> +			FILEP=`mktemp -q $DIRP/file.XXXXXX`
> +			SCNT=$(r_ranged $5 $6)
> +			dd if=/dev/urandom of=$FILEP bs=$SCNT count=1 status=noxfer 2>/dev/null &
> +			# if some kernel may not support non aligned blocks well
> +			#BCNT=$(($SCNT/4096))
> +			#dd if=/dev/urandom of=$FILEP bs=4096 count=$BCNT status=noxfer 2>/dev/null &
> +		done
> +	done
> +	wait $!
> +	#log_event done
> +}

As mentioned previously, this give unrepeatable fill patterns
because it is random.  While that might be good for testing some
corner cases, it's bad for reproducing problems when they occur.
This is the reason when se a known seed for things that generate
random operations (like fsx) so when a problem is found we can
reproduce the workload -exactly-.

But given the small test set sizes (even for large), the randomness
is not really buying you anything that a fixed configuration or two
would not test. Hence I'd drop the randomness altogether and use
known patterns and filenames instead to make the test code simpler
and allows you to put the checksums directly into the golden output
for simple verification.

Remember, once a test is integrated into xfstests it is no longer a
standalone test, so having lots of different configurations that are
never used just makes it harder to understand and maintain. Indeed,
if all the randomness goes away, all you need to do is make sure
_populate_fs writes patterned files rather than zeroes. e.g. uses
something like:

	$XFS_IO_PROG -f -c "pwrite -S 0xa55ac33c 0 $fsize" $outfile

instead of dd if=/dev/zero....

FWIW, that also gets around the performance problem of read lots of
data from /dev/urandom - I get about 10MB/s throughput from
/dev/urandom, which means writing large files will take quite some
time - far slower than disk performance....


> +function modifyfs_fillblk()
> +{
> +	local FSIZE
> +	local BLKS
> +	local NBLK
> +	local FALLOC
> +	local WS
> +
> +	#log_event log "filling the allocated blocks....."
> +	for i in `find /$1 -type f`
> +	do
> +		FSIZE=`stat -t $i | cut -d" " -f2`
> +		BLKS=`stat -c "%B" $i`
> +		NBLK=`stat -c "%b" $i`
> +		FALLOC=$(($BLKS * $NBLK))
> +		WS=$(($FALLOC - $FSIZE))

WS is unused, and given that you know the files aren't sparse, why
wouldn't you simple overwrite from offset 0 to $FSIZE?

> +		#echo $FSIZE $BLKS $NBLK $FALLOC $WS
> +		dd if=/dev/urandom of=$i obs=$FALLOC count=1 status=noxfer 2>/dev/null &

		xfs_io -f -c "pwrite -S 0xbeefbabe 0 $FSIZE" $f

> +	done
> +	wait $!
> +	#log_event done
> +}
> +
> +
> +# Append a random size to the files
> +# arg1 : FS in question
> +
> +function modifyfs_append()
> +{
> +	local FSIZE
> +	local X
> +	local N
> +	local i
> +	#log_event log "appending the files......"
> +	N=0
> +	for i in `find $1 -type f`
> +	do
> +		if [ $N == 0 ]; then
> +			N=$(($N+1))

You do this just to execute this on the first loop? Just put it
outside the loop and drop N altogether

> +			X=$i
> +			FSIZE=`stat -t $X | cut -d" " -f2`
> +			dd if=$X of=$X seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer 2>/dev/null &

so it doubles the size of the file.

	xfs_io -a -f "pwrite -S 0xa55ac33c" $FSIZE $FSIZE" $i

> +			continue
> +		fi
> +		FSIZE=`stat -t $i | cut -d" " -f2`
> +		dd if=$X of=$i seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer 2>/dev/null &

and that copies from the start of the previous file to the end of
the current file. IOWs, if we are using a fixed pattern, it's the
same operation as the N=0 case, without the risk that the source
file is too short and we end up with a short read. It also means
this ends up as:

	for f in `find $1 -type f`; do
		FSIZE=`stat -t $i | cut -d" " -f2`
		xfs_io -a -f "pwrite -S 0xa55ac33c" $FSIZE $FSIZE" $i
	done;

.....

> +# To have a clean FS to test
> +# arg 1: mount point
> +# arg 2: metadata Raid Type/devs
> +# arg 3: data Raid Type/none
> +# arg 4: devices/none
> +#or
> +# arg 1: mount point
> +# arg 2: devices
> +function mk_fs()
> +{
> +	local ndev
> +
> +	umount $1 > /dev/null 2>&1
> +
> +	if [ $# == 2 ]; then
> +		# use default options to create the FS.
> +		ndev=( $2 )
> +		#echo ${ndev[@]}
> +		mkfs.btrfs ${ndev[@]} > /dev/null 2>&1
> +		#mkfs.btrfs ${ndev[@]} 2>&1 | _filter_scratch
> +		if [ $? != 0 ]; then echo mkfs failed ; exit; fi
> +	else if [ $# == 4 ]; then
> +		ndev=( $4 )
> +		mkfs.btrfs -m $2 -d $3 ${ndev[@]} > /dev/null 2>&1
> +		#mkfs.btrfs -m $2 -d $3 ${ndev[@]} 2>&1 | _filter_scratch
> +		if [ $? != 0 ]; then echo mkfs failed; exit; fi
> +	else
> +		echo "Coding Error 234: xfstests alias would like to hear about it"
> +	fi
> +	fi
> +
> +	mount -t btrfs ${ndev[0]} $1
> +}

See my comments about folding this into btrfs specific branches of
scratch_mkfs.

> +# arg1: mntpoint
> +# arg2: Number of devs to use
> +# arg3: devs in array
> +function mk_fs_loopdev()
> +{
> +	local ndev
> +
> +	#log_event log "creating a new btrfs fs on $3...."
> +	umount $1 > /dev/null 2>&1
> +
> +	ndev=( $3 )
> +	#mkfs.btrfs -m $2 -d $3 ${ndev[@]} > ./tmp/out
> +	#if [ $? != 0 ]; then echo mkfs failed ; cat ./tmp/out; exit 1; fi
> +	#mount -t btrfs ${ndev[0]} $1
> +
> +#	echo
> +#	echo $# ndev=${ndev[@]}
> +	#log_event done
> +}

Unused, does nothing. Please remove.

> +
> +
> +function leaned_fs
> +{
> +	echo $1 $2
> +}

Unused, please remove.

> +#arg 1: mntpt
> +#arg 2: phy disks
> +#arg 3: Number of total loop devs
> +#arg 4: initial mkfs devs
> +
> +function fs_on_loopdev()
> +{
> +	local sz
> +	local n=0
> +	local devname
> +	local devs
> +
> +	mk_fs $1 "$2"
> +
> +	sz=$((`df -k $1 | egrep "$1" | awk '{print $4}'`/$(($3+1))))
> +	sz=$(($sz*1024))
> +	if [ $sz -lt 2671771648 ]; then echo "Error: Need at least 2G space for this test"; exit 1; fi
> +
> +	for n in $(seq 1 $3)
> +	do
> +		devname=`mktemp -q $1/dev.XXXXXX`
> +		dd if=/dev/zero of=$devname bs=8192 count=64000 status=noxfer 2>/dev/null
> +		losetup -f $devname
> +		if [ $? != 0 ]; then echo "Error losetup failed";exit 1;fi
> +		LOOPDEV[$(($n-1))]=`losetup -a | grep $devname|cut -d":" -f1`
> +		LOOPFILE[$(($n-1))]=$devname
> +	done
> +
> +	mkdir -p $1/mnt
> +	devs=${LOOPDEV[@]:0:$4}
> +	mk_fs $1/mnt "$devs"
> +}

Unused, please remove.

> +
> +#arg 1: mntpt
> +function clean_loopdev()
> +{
> +	local i
> +
> +	#log_event log "Cleaning loop devices....."
> +
> +	local n=${#LOOPDEV[@]}
> +	if [ ! $n ]; then return; fi
> +
> +	n=$(($n-1))
> +
> +	umount ${LOOPDEV[0]}
> +	if [ $? != 0 ]; then echo "Error: umount loopdev failed"; exit 1;fi
> +
> +	for i in `seq 0 $n`
> +	do
> +		losetup -d ${LOOPDEV[$i]}
> +		unlink ${LOOPFILE[$i]}
> +		#echo ${LOOPDEVS[$i]}
> +		#ls -l $MNTPT/fd$i
> +	done
> +
> +	#log_event done
> +}

Also unused.

IOWs, this file can pretty much go away.

> diff --git a/src/randmisc b/src/randmisc
> new file mode 100644
> index 0000000..a0a065b
> --- /dev/null
> +++ b/src/randmisc
> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +
> +# Generate Random number in a range
> +# arg1 min
> +# arg2 max
> +
> +function r_ranged()
> +{
> +	local X
> +	local Y
> +	local S
> +	if [ $2 == 0 ]; then echo 0; return; fi
> +	Y=$RANDOM
> +	((X = $2 - $1 + 1))
> +	((X = $Y % $X))
> +	((X = $X + $1))
> +	echo $X
> +}

only used by the fillfs function and the picka function below.
Given that fillfs isn't actually random with the proposed
configuration (and is better off without the randomness), and picka
is used only once, this can move to whereever the picka function
goes...

> +
> +# Picks a rand(r)/first(f)/last(l) file or subvol
> +# arg1: what
> +# arg2: FS
> +function picka()
> +{
> +	local MAX
> +	local X
> +	local R
> +	local i
> +
> +	case $1 in
> +	rfile)
> +		MAX=`find $2 -type f | wc -l`
> +		X=`r_ranged 1 $MAX`
> +		R=0
> +		for i in `find $2 -type f`; do
> +			if [ "$X" == "$R" ]; then echo $i; return; fi
> +			R=$(($R+1))
> +		done
> +	;;
> +	rsnap)
> +		MAX=`$BTRFS subvolume list $2 | wc -l`
> +		X=`r_ranged 1 $MAX`
> +		R=0
> +		for i in `$BTRFS subvolume list $2`; do
> +			if [ $X == $R ]; then echo $i; return; fi
> +			R=$(($R+1))
> +		done
> +	;;
> +	ffile)
> +		for i in `find $2 -type f`; do
> +			echo $i
> +			break
> +		done
> +	;;
> +	fsnap)
> +		for i in `$BTRFS subvolume list $2`; do
> +			echo $i;
> +			break
> +		done
> +	;;
> +	lfile)
> +		for i in `find $2 -type f`; do
> +			sleep 1
> +		done
> +		echo $i
> +	;;
> +	lsnap)
> +	;;
> +	esac
> +}

picka is used only once, for the rfile case. Move the function into
that test, remove all the unused code. can probably even just be
open coded in that test...

> diff --git a/src/snapmisc b/src/snapmisc
> new file mode 100644
> index 0000000..7bd059f
> --- /dev/null
> +++ b/src/snapmisc
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# Create a snapshot
> +# arg1 source
> +# arg2 dest dir
> +
> +# Return snapshot name in the SNAPNAME
> +function create_snap()
> +{
> +	local x
> +	if [ ! -d $2 ]; then echo Destination dir $2 not present; fi
> +	SNAPNAME=`mktemp -u $2/snap.XXXXXX`
> +	btrfs subvolume snapshot $1 $SNAPNAME > /dev/null
> +	if [ $? != 0 ]; then echo Error snapshot create failed; status=1;exit; fi
> +	return
> +}

I'm not sure this really needs a wrapper, especially as $2 is always
$SCRATCHMNT and will be present. i.e, it only needs to be:

	btrfs subvolume snapshot $1 `mktemp -u $2/snap.XXXXXX` \
		> /dev/null || _fail "snapshot create failed with $?"

> +
> +# Destroy a snapshot
> +# arg 1: snapshot to be deleted
> +
> +function destroy_snap()
> +{
> +	#log_event log "deleting snapshot $1....."
> +	btrfs subvolume delete $1
> +	#log_event done done
> +}

That certainly doesn't need a wrapper.

> +
> +# Creates n clones
> +# arg 1: number of clones required
> +# arg 2: soruce of which clone has to be taken
> +
> +function create_nclones()
> +{
> +	local i
> +
> +	for i in `seq 1 $1`
> +	do
> +		create_snap $2 $SCRATCH_MNT
> +	done
> +}

unused, please remove.

> +
> +function update_clonelist()
> +{
> +	local i
> +	# Is there a way btrfs can distinguish sv and ss ?
> +	local n=0
> +	for i in `btrfs subvolume list $SCRATCH_MNT | rev|cut -d" " -f1|rev`

Why do you reverse the stream, cut it and then reverse it again?


> +	do
> +		#echo i=$i n=$n
> +		CLONE_LIST[$n]="${SCRATCH_MNT}/${i}"
> +                n=$((n+1))
> +        done
> +	#echo n=$n
> +	#for i in `seq 0 $((n-1))`; do echo i=$i ${CLONE_LIST[$i]}; done

kill all the debug.

> +}
> +
> +# arg1: number of clones required
> +# arg2: base subvol
> +function create_nestedclones()
> +{
> +	local i
> +	local x
> +	local w
> +	local SNAPNAME=0
> +
> +	x=$2
> +	for i in `seq 1 $1`
> +	do
> +		create_snap $x $SCRATCH_MNT
> +		x=$SNAPNAME

If you open code creat_snap, this global variable abuse goes away.

> +		#w=`btrfs subvolume list $SCRATCH_MNT|wc -l`
> +		#echo i=$i x=$x w=$w
> +	done
> +}

Both create_nestedclones() and  update_clonelist() are use donly
once, and one is called directly after the other. Just open code it
in the test - much simpler and easier to understand...

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
