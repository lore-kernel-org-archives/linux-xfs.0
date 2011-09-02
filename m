Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p828jp5D063100 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 03:45:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D77DD19672B4
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2011 01:45:49 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	llyrv6wwtcSBE32N for <xfs@oss.sgi.com>;
	Fri, 02 Sep 2011 01:45:49 -0700 (PDT)
Date: Fri, 2 Sep 2011 04:45:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] Added test case 257 for btrfs extended snapshot tests
Message-ID: <20110902084545.GA29054@infradead.org>
References: <4E3BA2F7.4080500@oracle.com>
 <4E443504.3070102@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E443504.3070102@oracle.com>
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

Dave, Alex:

any objections to these patches?  I not I'm going to put them in this
weekend.

On Fri, Aug 12, 2011 at 04:01:08AM +0800, Anand Jain wrote:
> This adds the test case 257 to test the snapshot feature in:wq btrfs.
> This also added a new user set variable SCRATCH_DEV_POOL, which should
> be set to dev pool for btrfs.
> 
> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
> ---
>  257       |  192
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  257.out   |    2 +
>  common.rc |   86 +++++++++++++++++++++++++++
>  group     |    1 +
>  4 files changed, 281 insertions(+), 0 deletions(-)
>  create mode 100755 257
>  create mode 100644 257.out
> 
> diff --git a/257 b/257
> new file mode 100755
> index 0000000..9d7c8ff
> --- /dev/null
> +++ b/257
> @@ -0,0 +1,192 @@
> +#!/bin/bash
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
> +_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +_scratch_mount
> +
> +# Create and save sha256sum
> +# arg1 FS to generate sha256
> +# arg2 File name to save the sha256 output
> +_save_checksum()
> +{
> +	local i=0
> +	>$2
> +	cd $1
> +	for i in `find . -type f`; do sha256sum $i >> $2; done
> +	cd $OLDPWD
> +}
> +
> +# Verify the sha256sum for a FS
> +# arg1 FS to be tested
> +# arg2 sha256 file
> +_verify_checksum()
> +{
> +	cd $1
> +	[ -f $2 ] || _fail "checksum file $2 not found"
> +	sha256sum -c $2 | grep "FAILED"
> +	cd $OLDPWD
> +}
> +
> +# Create a snapshot
> +# arg1 dest dir
> +# Return snapshot name in the SNAPNAME
> +_create_snap()
> +{
> +	local x
> +	[ -d $1 ] || _fail "Destination dir $1 not present"
> +	SNAPNAME=`mktemp -u $SCRATCH_MNT/snap.XXXXXX`
> +	btrfs subvolume snapshot $1 $SNAPNAME > /dev/null || _fail
> "snapshot create failed"
> +}
> +
> +# Reads and writes new data but does not allocate new blocks
> +# arg1 FS to be modified
> +_read_modify_write()
> +{
> +	local i
> +	local FSIZE
> +	for i in `find $1 -type f`
> +	do
> +		FSIZE=`stat -t $i | cut -d" " -f2`
> +		dd if=$i of=/dev/null obs=$FSIZE count=1 status=noxfer 2>/dev/null &
> +		dd if=/dev/urandom of=$i obs=$FSIZE count=1 status=noxfer 2>/dev/null &
> +	done
> +	wait $!
> +}
> +
> +# Fills the allocated blocks
> +# arg1 FS in question
> +_fill_blk()
> +{
> +	local FSIZE
> +	local BLKS
> +	local NBLK
> +	local FALLOC
> +	local WS
> +
> +	for i in `find /$1 -type f`
> +	do
> +		FSIZE=`stat -t $i | cut -d" " -f2`
> +		BLKS=`stat -c "%B" $i`
> +		NBLK=`stat -c "%b" $i`
> +		FALLOC=$(($BLKS * $NBLK))
> +		WS=$(($FALLOC - $FSIZE))
> +		dd if=/dev/urandom of=$i oseek=$FSIZE obs=$WS count=1
> status=noxfer 2>/dev/null &
> +	done
> +	wait $!
> +}
> +
> +
> +# Append a random size to the files
> +# arg1 : FS in question
> +_append_file()
> +{
> +	local FSIZE
> +	local X
> +	local N
> +	local i
> +	N=0
> +	for i in `find $1 -type f`
> +	do
> +		if [ $N == 0 ]; then
> +			X=$i
> +			FSIZE=`stat -t $X | cut -d" " -f2`
> +			dd if=$X of=$X seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer
> 2>/dev/null &
> +			N=$(($N+1))
> +			continue
> +		fi
> +		FSIZE=`stat -t $i | cut -d" " -f2`
> +		dd if=$X of=$i seek=1 bs=$FSIZE obs=$FSIZE count=1 status=noxfer
> 2>/dev/null &
> +		X=$i
> +	done
> +	wait $!
> +}
> +
> +##################### real QA test starts
> here###################################
> +# sv1 - is just a name nothing spl
> +firstvol="$SCRATCH_MNT/sv1"
> +btrfs subvolume create $firstvol > /dev/null || _fail "btrfs
> subvolume create $firstvol failed"
> +_fillfs 1 10 100 4096 8192 $firstvol
> +SNAPNAME=0
> +_create_snap $firstvol
> +_save_checksum $firstvol $tmp.sv1.sum
> +_verify_checksum $SNAPNAME $tmp.sv1.sum
> +
> +#Append1 the files
> +_fill_blk $SNAPNAME
> +_verify_checksum $firstvol $tmp.sv1.sum
> +
> +#Append2 the files
> +_append_file $SNAPNAME
> +_verify_checksum $firstvol $tmp.sv1.sum
> +
> +#read modify write
> +_read_modify_write $SNAPNAME
> +_verify_checksum $firstvol $tmp.sv1.sum
> +
> +#nested snapshot test
> +src_vol=$firstvol
> +for i in `seq 1 7`; do
> +	SNAPNAME=0
> +	_create_snap $src_vol
> +	_verify_checksum $SNAPNAME $tmp.sv1.sum
> +	src_vol=$SNAPNAME
> +done
> +
> +# file delete test
> +SNAPNAME=0
> +_create_snap $firstvol
> +tname=`echo $SNAPNAME | rev | cut -d"/" -f1 | rev`
> +_save_checksum $SNAPNAME $tmp.$tname.sum
> +\rm -rf $firstvol/*
> +_verify_checksum $SNAPNAME $tmp.$tname.sum
> +
> +umount $SCRATCH_DEV || _fail "unmount failed"
> +
> +echo "Silence is golden"
> +status=0; exit
> diff --git a/257.out b/257.out
> new file mode 100644
> index 0000000..cc3693f
> --- /dev/null
> +++ b/257.out
> @@ -0,0 +1,2 @@
> +QA output created by 257
> +Silence is golden
> diff --git a/common.rc b/common.rc
> index cb23a02..db7c2dd 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1559,7 +1559,93 @@ _test_inode_extsz()
>      echo $blocks
>  }
> 
> +# Generate Random number in a range
> +# arg1 min, arg2 max
> +_rand_range()
> +{
> +	local X
> +	local Y
> +	if [ $2 == 0 ]; then echo 0; return; fi
> +	RANDOM=1
> +	Y=$RANDOM
> +	((X = $2 - $1 + 1))
> +	((X = $Y % $X))
> +	((X = $X + $1))
> +	echo $X
> +}
> +
> +# Create Dir tree and files in it.
> +# arg1 basedir
> +# arg2 dir depth
> +# arg3 nfile_min
> +# arg4 nfile_max
> +# arg5 fsize_min
> +# arg6 fsize_max
> +_fillfs()
> +{
> +	umask 000
> +	local j
> +	local i
> +	local DIRP
> +	local FCNT
> +	local FILEP
> +	local SCNT
> +	local BCNT
> +	DIRP=$6
> +	for ((j=0; j<$1; j++)); do
> +		DIRP=`mktemp -dq $DIRP/dir.XXXXXX`
> +		FCNT=$(_rand_range $2 $3)
> +		for ((i=0; i<$FCNT; i++)); do
> +			FILEP=`mktemp -q $DIRP/file.XXXXXX`
> +			SCNT=$(_rand_range $4 $5)
> +			dd if=/dev/urandom of=$FILEP bs=$SCNT count=1 status=noxfer
> 2>/dev/null &
> +		done
> +	done
> +	wait $!
> +}
> +
> +# scratch_dev_pool should contain the disks pool for the btrfs raid
> +_require_scratch_dev_pool()
> +{
> +	local i
> +	case "$FSTYP" in
> +	btrfs)
> +		if [ -z "$SCRATCH_DEV_POOL" ]
> +		then
> +			_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
> +		fi
> +		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]
> +		then
> +			_notrun "this test needs 2 or more disks in SCRATCH_DEV_POOL"
> +		fi
> 
> +		for i in $SCRATCH_DEV_POOL
> +		do
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
> +		done
> +	;;
> +	esac
> +}
> 
> ################################################################################
> 
>  if [ "$iam" != new -a "$iam" != bench ]
> diff --git a/group b/group
> index 0c746c8..84c45da 100644
> --- a/group
> +++ b/group
> @@ -370,3 +370,4 @@ deprecated
>  254 auto quick
>  255 auto quick prealloc
>  256 auto quick
> +257 auto quick
> -- 
> 1.7.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
