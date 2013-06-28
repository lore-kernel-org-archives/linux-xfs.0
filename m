Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75F197F50
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 05:11:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06641AC001
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 03:11:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id DAlGpAe8QKuAXO7l (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 03:11:08 -0700 (PDT)
Message-ID: <51CD6241.6090909@oracle.com>
Date: Fri, 28 Jun 2013 18:15:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix btrfs/265 so it actually works V2
References: <1372355352-28272-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372355352-28272-1-git-send-email-jbacik@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com




  Looks good. But. Since there is repeated calls to mkfs,
  -f option might be mandatory. and 265 is indeed working before.
  You need to re-phrase the title to the fixes you are bringing in.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>


On 06/28/2013 01:49 AM, Josef Bacik wrote:
> There are a few problems with btrfs/265.  First we don't redirect the output of
> btrfs fi ba somwhere else, so we fail this test outright.  Secondly if you have
> less than 4 devices in your scratch dev pool it won't work because you can't
> mkfs raid10 without 4 devices.  This is all impossible to figure out at first
> glance because the test redirects all output to /dev/null.  So do a few things
>
> 1) Redirect all output to $seqres.full to help the next poor sap who finds a
> problem.
 >
> 2) Add an optional option for _require_scratch_dev_pool to specify the minimum
> number of devices required to run the test, so you get a nice helpful error
> instead of "mkfs failed" in $seqres.full if you don't specify enough devices in
> your scratch dev pool.
>
> 3) Redirect the output from btrfs fi ba to $seqres.full instead of letting its
> output go to stdout and making the test fail anyways.
>
> With these changes this test now passes for me.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2:
> -when testing this I had actually had 5 devices in my dev pool so it still
>   worked, but when I had 4 devices it failed because we strip out the first
>   device for $SCRATCH_DEV, so fix the math to take this into account and now it
>   works properly
>
>   common/rc       |   16 +++++++++++++---
>   tests/btrfs/265 |   30 ++++++++++++++++--------------
>   2 files changed, 29 insertions(+), 17 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index fe6bbfc..2a1b494 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1964,10 +1964,15 @@ _test_inode_extsz()
>       echo $blocks
>   }
>
> -# scratch_dev_pool should contain the disks pool for the btrfs raid
> +# scratch_dev_pool should contain the disks pool for the btrfs raid, optionally
> +# you can provide the minimum number of devices required for this test
>   _require_scratch_dev_pool()
>   {
>   	local i
> +	local _count=2
> +
> +	[ $# -eq 1 ] && _count=$1
> +
>   	if [ -z "$SCRATCH_DEV_POOL" ]; then
>   		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
>   	fi
> @@ -1976,8 +1981,13 @@ _require_scratch_dev_pool()
>   	# so fail it
>   	case $FSTYP in
>   	btrfs)
> -		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
> -			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
> +		# SCRATCH_DEV_POOL by the time it gets here has had SCRATCH_DEV
> +		# peeled off of it, so we need to add the scratch dev to the
> +		# count.
> +		local _disk_count=$(echo $SCRATCH_DEV_POOL | wc -w)
> +		_disk_count=$(expr $_disk_count + 1)
> +		if [ $_disk_count -lt $_count ]; then
> +			_notrun "btrfs and this test needs $_count or more disks in SCRATCH_DEV_POOL"
>   		fi
>   	;;
>   	*)
> diff --git a/tests/btrfs/265 b/tests/btrfs/265
> index 79a9ddf..fcf5730 100755
> --- a/tests/btrfs/265
> +++ b/tests/btrfs/265
> @@ -49,14 +49,16 @@ _need_to_be_root
>   _supported_fs btrfs
>   _supported_os Linux
>   _require_scratch
> -_require_scratch_dev_pool
> +_require_scratch_dev_pool 4
>   _require_deletable_scratch_dev_pool
>
> +rm -f $seqres.full
> +
>   # Test cases related to raid in btrfs
>   _test_raid0()
>   {
>   	export MKFS_OPTIONS="-m raid0 -d raid0"
> -	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
> @@ -66,7 +68,7 @@ _test_raid0()
>   _test_raid1()
>   {
>   	export MKFS_OPTIONS="-m raid1 -d raid1"
> -	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
> @@ -76,7 +78,7 @@ _test_raid1()
>   _test_raid10()
>   {
>   	export MKFS_OPTIONS="-m raid10 -d raid10"
> -	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
> @@ -86,7 +88,7 @@ _test_raid10()
>   _test_single()
>   {
>   	export MKFS_OPTIONS="-m single -d single"
> -	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs $SCRATCH_DEV_POOL >> $seqres.full 2>&1 || _fail "mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
> @@ -102,14 +104,14 @@ _test_add()
>   	n=$(($n-1))
>
>   	export MKFS_OPTIONS=""
> -	_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
>   	for i in `seq 1 $n`; do
> -		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
> +		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "device add failed"
>   	done
> -	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
> +	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full || _fail "balance failed"
>   	umount $SCRATCH_MNT
>   }
>
> @@ -127,7 +129,7 @@ _test_replace()
>   	ds=${devs[@]:0:$n}
>
>   	export MKFS_OPTIONS="-m raid1 -d raid1"
> -	_scratch_mkfs "$ds" > /dev/null 2>&1 || _fail "tr: mkfs failed"
> +	_scratch_mkfs "$ds" >> $seqres.full 2>&1 || _fail "tr: mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
> @@ -143,16 +145,16 @@ _test_replace()
>   	_devmgt_remove ${DEVHTL}
>   	dev_removed=1
>
> -	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null || _fail \
> +	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
>   							"btrfs did not report device missing"
>
>   	# add a new disk to btrfs
>   	ds=${devs[@]:$(($n)):1}
> -	$BTRFS_UTIL_PROG device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add failed"
> +	$BTRFS_UTIL_PROG device add ${ds} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "dev add failed"
>   	# in some system balance fails if there is no delay (a bug)
>   	# putting sleep 10 to work around as of now
>   	# sleep 10
> -	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
> +	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "dev balance failed"
>
>   	# cleaup. add the removed disk
>   	umount $SCRATCH_MNT
> @@ -162,7 +164,7 @@ _test_replace()
>
>   _test_remove()
>   {
> -	_scratch_mkfs "$SCRATCH_DEV_POOL" > /dev/null 2>&1 || _fail "mkfs failed"
> +	_scratch_mkfs "$SCRATCH_DEV_POOL" >> $seqres.full 2>&1 || _fail "mkfs failed"
>   	_scratch_mount
>   	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
>   	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
> @@ -170,7 +172,7 @@ _test_remove()
>   	# pick last dev in the list
>   	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
>   	$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
> -	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del > /dev/null && _fail "btrfs still shows the deleted dev"
> +	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del >> $seqres.full && _fail "btrfs still shows the deleted dev"
>   	umount $SCRATCH_MNT
>   }
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
