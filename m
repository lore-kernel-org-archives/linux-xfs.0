Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D3B77F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 16:24:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D79FB304062
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 14:24:16 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id S5o3Mp3MQAi3GDTT for <xfs@oss.sgi.com>;
	Thu, 17 Oct 2013 14:24:15 -0700 (PDT)
Message-ID: <5260557D.8050404@sandeen.net>
Date: Thu, 17 Oct 2013 16:24:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfstests: New _require_* tests for CRC enabled
	filesystems
References: <1370610398-14630-1-git-send-email-david@fromorbit.com>
	<1370610398-14630-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1370610398-14630-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 6/7/13 8:06 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CRCs always enabled 32 bit project inodes and attr2 formats, hence
> they cannot be turned off. Add new require rules for the tests that
> require attr and 16 bit project IDs so these tests are avoided on
> CRC enabled filesystems.
> 
> Also, add a xfs_db write check so that we can avoid tests that are
> dependent on xfs_db modifying filesystem structures as they will
> fail on CRC enabled filessystems right now. This is just temporary
> until full write xfs_db support is available.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

small optimization question below

> ---
>  common/attr      |    6 ++++++
>  common/rc        |   26 +++++++++++++++++++++++---
>  tests/shared/298 |    2 +-
>  tests/xfs/044    |    1 +
>  tests/xfs/045    |    1 +
>  tests/xfs/186    |    2 ++
>  tests/xfs/187    |   13 +++++++------
>  tests/xfs/199    |    1 +
>  tests/xfs/244    |    1 +
>  tests/xfs/278    |    2 ++
>  tests/xfs/287    |    4 +++-
>  tests/xfs/291    |    2 +-
>  12 files changed, 49 insertions(+), 12 deletions(-)
> 
> diff --git a/common/attr b/common/attr
> index e5070bf..1ab5014 100644
> --- a/common/attr
> +++ b/common/attr
> @@ -176,6 +176,12 @@ _require_attrs()
>      rm -f $TEST_DIR/syscalltest.out
>  }
>  
> +_require_attr_v1()
> +{
> +	scratch_mkfs_xfs -f -i attr=1 > /dev/null 2>&1 \

How about adding an "-N" to speed it up if the fs is large?

> +		|| _notrun "attr v1 not supported"
> +}
> +
>  # getfattr -R returns info in readdir order which varies from fs to fs.
>  # This sorts the output by filename
>  _sort_getfattr_output()
> diff --git a/common/rc b/common/rc
> index 88d38ef..b2ad2a0 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1074,14 +1074,34 @@ _require_dm_flakey()
>  }
>  
>  # this test requires the projid32bit feature to be available in
> -# mkfs.xfs
> -#
> +# mkfs.xfs. We need to open code the mkfs test because _scratch_mkfs_xfs
> +# will drop command line mkfs options to ensure that it succeeds, hence
> +# not actually testing the configuration we desire to be tested for support.
>  _require_projid32bit()
>  {
> -        _scratch_mkfs_xfs -f -i projid32bit=0 >/dev/null 2>&1 \
> +    _scratch_options mkfs
> +
> +    $MKFS_XFS_PROG $SCRATCH_OPTIONS $MKFS_OPTIONS \
> +		-f -i projid32bit=1 $SCRATCH_DEV >/dev/null 2>&1 \
>  	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
>  }

Same here?

> +_require_projid16bit()
> +{
> +    _scratch_options mkfs
> +
> +    $MKFS_XFS_PROG $SCRATCH_OPTIONS $MKFS_OPTIONS \
> +		-f -i projid32bit=0 $SCRATCH_DEV >/dev/null 2>&1 \
> +	   || _notrun "16 bit project IDs not supported on $SCRATCH_DEV"
> +}

and here?  Do we want the mkfs as a side effect?  (that would seem odd...)

> +
> +# This test requires xfs_db write support
> +_require_xfs_db_write()
> +{
> +	$XFS_DB_PROG $TEST_DEV > /dev/null 2>&1 \
> +		|| _notrun "xfs_db write support required."
> +}
> +
>  # this test requires that external log/realtime devices are not in use
>  #
>  _require_nonexternal()
> diff --git a/tests/shared/298 b/tests/shared/298
> index 4541798..6b5402c 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -70,7 +70,7 @@ get_free_sectors()
>  	agsize=`xfs_info $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
>  	# Convert free space (agno, block, length) to (start sector, end sector)
>  	$UMOUNT_PROG $loop_mnt
> -	$XFS_DB_PROG -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
> +	$XFS_DB_PROG -r -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
>  		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
>  		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
>  	;;
> diff --git a/tests/xfs/044 b/tests/xfs/044
> index a84af22..cf575f8 100755
> --- a/tests/xfs/044
> +++ b/tests/xfs/044
> @@ -44,6 +44,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_logdev
> +_require_xfs_db_write
>  
>  _filter_logprint()
>  {
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index 84ca802..17d2391 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -45,6 +45,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
> +_require_xfs_db_write
>  
>  echo "*** get uuid"
>  uuid=`_get_existing_uuid`
> diff --git a/tests/xfs/186 b/tests/xfs/186
> index 960aed1..71f2a31 100755
> --- a/tests/xfs/186
> +++ b/tests/xfs/186
> @@ -147,6 +147,8 @@ _supported_os Linux
>  
>  _require_scratch
>  _require_attrs
> +_require_attr_v1
> +_require_xfs_db_write
>  
>  rm -f $seqres.full
>  
> diff --git a/tests/xfs/187 b/tests/xfs/187
> index 9cf1305..415ab11 100755
> --- a/tests/xfs/187
> +++ b/tests/xfs/187
> @@ -58,6 +58,7 @@ _supported_os Linux
>  
>  _require_scratch
>  _require_attrs
> +_require_attr_v1
>  
>  rm -f $seqres.full
>  
> @@ -87,13 +88,13 @@ echo ""
>  echo "attr2 fs"
>  echo ""
>  _scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
> -$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
> +$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  echo ""
>  echo "noattr2 fs"
>  echo ""
>  _scratch_mount -o noattr2
>  $UMOUNT_PROG $SCRATCH_MNT
> -$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
> +$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  
>  # adding an EA will ensure the ATTR1 flag is turned on
>  echo ""
> @@ -102,7 +103,7 @@ echo ""
>  echo "attr2 fs"
>  echo ""
>  _scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
> -$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
> +$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  echo ""
>  echo "noattr2 fs"
>  echo ""
> @@ -113,7 +114,7 @@ $SETFATTR_PROG -n user.test -v 0xbabe testfile
>  $GETFATTR_PROG testfile
>  cd $here
>  $UMOUNT_PROG $SCRATCH_MNT
> -$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
> +$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  
>  echo ""
>  echo "*** 3. test noattr2 mount and lazy sb ***"
> @@ -122,7 +123,7 @@ echo ""
>  echo "attr2 fs"
>  echo ""
>  _scratch_mkfs -i attr=2 -l lazy-count=1 >/dev/null 2>&1
> -$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
> +$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  echo ""
>  echo "noattr2 fs"
>  echo ""
> @@ -131,7 +132,7 @@ cd $SCRATCH_MNT
>  touch testfile
>  cd $here
>  $UMOUNT_PROG $SCRATCH_MNT
> -$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 | _filter_version
> +$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index 1d64e02..0ab0dba 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -48,6 +48,7 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
> +_require_xfs_db_write
>  
>  _scratch_mkfs_xfs -l lazy-count=1 >/dev/null 2>&1
>  
> diff --git a/tests/xfs/244 b/tests/xfs/244
> index 7d2a2d3..90291fb 100755
> --- a/tests/xfs/244
> +++ b/tests/xfs/244
> @@ -48,6 +48,7 @@ _supported_fs xfs
>  _require_xfs_quota
>  _require_scratch
>  _require_projid32bit
> +_require_projid16bit
>  
>  export MOUNT_OPTIONS="-opquota"
>  
> diff --git a/tests/xfs/278 b/tests/xfs/278
> index 938717d..e6f9289 100755
> --- a/tests/xfs/278
> +++ b/tests/xfs/278
> @@ -46,6 +46,8 @@ _cleanup()
>  _supported_fs xfs
>  _supported_os Linux
>  _require_scratch
> +_require_xfs_db_write
> +
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
>  
> diff --git a/tests/xfs/287 b/tests/xfs/287
> index 9de0b3d..febc3af 100755
> --- a/tests/xfs/287
> +++ b/tests/xfs/287
> @@ -45,7 +45,7 @@ _cleanup()
>  
>  _print_projid()
>  {
> -	$XFS_DB_PROG -c "inode $1" \
> +	$XFS_DB_PROG -r -c "inode $1" \
>  		-c "print core.projid_lo" \
>  		-c "print core.projid_hi" \
>  		$SCRATCH_DEV
> @@ -56,6 +56,8 @@ _supported_fs xfs
>  _require_xfs_quota
>  _require_scratch
>  _require_projid32bit
> +_require_projid16bit
> +_require_xfs_db_write	# for xfs_admin
>  
>  # create xfs fs without projid32bit ability, will be gained by xfs_admin
>  _scratch_mkfs_xfs -i projid32bit=0 -d size=200m 2> /dev/null >> $seqres.full \
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 7723b9e..03c4de9 100755
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -70,7 +70,7 @@ xfs_io -f -c "pwrite 0 16m" -c "fsync" $SCRATCH_MNT/space_file.large >> $seqres.
>  
>  # Take a look at freespace for any post-mortem on the test
>  _scratch_unmount
> -xfs_db -c freesp $SCRATCH_DEV >> $seqres.full 2>&1
> +xfs_db -r -c freesp $SCRATCH_DEV >> $seqres.full 2>&1
>  _scratch_mount
>  
>  # Step 2: Make a bunch of (hopefully fragmented) multiblock
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
