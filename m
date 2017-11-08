Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26882 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752256AbdKHQt1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 11:49:27 -0500
Date: Wed, 8 Nov 2017 08:49:08 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/4] common/rc: factor out
 _get|set_xfs_scratch_sb_field()
Message-ID: <20171108164908.GA6299@magnolia>
References: <20171108080250.5662-1-houtao1@huawei.com>
 <20171108080250.5662-5-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108080250.5662-5-houtao1@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org, cmaiolino@redhat.com

On Wed, Nov 08, 2017 at 04:02:50PM +0800, Hou Tao wrote:
> It's common to get and set the values of fields in XFS super block,
> so factor them out as _get|set_xfs_scratch_sb_field() and update the
> related test cases accordingly.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  common/xfs    | 20 ++++++++++++++++++++
>  tests/xfs/007 |  6 ++----
>  tests/xfs/098 |  4 ++--
>  tests/xfs/186 |  3 +--
>  tests/xfs/199 | 13 ++++---------
>  tests/xfs/307 | 11 ++---------
>  tests/xfs/308 | 11 ++---------
>  tests/xfs/339 |  6 +++---
>  tests/xfs/340 |  2 +-
>  tests/xfs/999 |  8 --------
>  10 files changed, 37 insertions(+), 47 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index d4fef94..82ddc24 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -599,3 +599,23 @@ _require_no_xfs_debug()
>  		_notrun "Require XFS built without CONFIG_XFS_DEBUG"
>  	fi
>  }
> +
> +_get_xfs_scratch_sb_field()
> +{
> +	local field=$1
> +
> +	shift
> +
> +	_scratch_xfs_db -r -c 'sb 0' "$@" -c "print $field" | \
> +	awk -v field=$field '$0 ~ field {print $3}'
> +}
> +
> +_set_xfs_scratch_sb_field()
> +{
> +	local field=$1
> +	local value=$2
> +
> +	shift 2
> +
> +	_scratch_xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value"
> +}

FWIW we already have _scratch_xfs_[gs]et_metadata_field in common/fuzzy.

--D

> diff --git a/tests/xfs/007 b/tests/xfs/007
> index d80d380..c477db7 100755
> --- a/tests/xfs/007
> +++ b/tests/xfs/007
> @@ -62,10 +62,8 @@ do_test()
>  	echo "*** umount"
>  	_scratch_unmount
>  
> -	QINO_1=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | \
> -			grep $qino_1 | awk '{print $NF}'`
> -	QINO_2=`xfs_db -c "sb 0" -c "p" $SCRATCH_DEV | \
> -			grep $qino_2 | awk '{print $NF}'`
> +	QINO_1=`_get_xfs_scratch_sb_field $qino_1`
> +	QINO_2=`_get_xfs_scratch_sb_field $qino_2`
>  
>  	echo "*** Usage before quotarm ***"
>  	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks"
> diff --git a/tests/xfs/098 b/tests/xfs/098
> index 7873f32..6edac63 100755
> --- a/tests/xfs/098
> +++ b/tests/xfs/098
> @@ -96,9 +96,9 @@ echo "+ check fs"
>  _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
>  
>  echo "+ corrupt image"
> -logstart="$(_scratch_xfs_db -c 'sb 0' -c 'p' | grep '^logstart =' | cut -d ' ' -f 3)"
> +logstart="$(_get_xfs_scratch_sb_field logstart)"
>  logstart="$(_scratch_xfs_db -c "convert fsblock ${logstart} byte" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
> -logblocks="$(xfs_db -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logblocks =' | cut -d ' ' -f 3)"
> +logblocks="$(_get_xfs_scratch_sb_field logblocks)"
>  $XFS_IO_PROG -f -c "pwrite -S 0x62 ${logstart} $((logblocks * blksz))" "${SCRATCH_DEV}" >> $seqres.full
>  
>  echo "+ mount image"
> diff --git a/tests/xfs/186 b/tests/xfs/186
> index 4b36ae6..aaae202 100755
> --- a/tests/xfs/186
> +++ b/tests/xfs/186
> @@ -173,8 +173,7 @@ fi
>  
>  # set inum to root dir ino
>  # we'll add in dirents and EAs into the root directory
> -eval `_scratch_xfs_db -r -c 'sb 0' -c 'p rootino' | $SED_PROG 's/ //g'`
> -inum=$rootino
> +inum=`_get_xfs_scratch_sb_field rootino`
>  fork_dir=$SCRATCH_MNT
>  _print_inode
>  
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index ee26439..8f79cbf 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -49,11 +49,6 @@ _supported_os Linux
>  
>  _require_scratch
>  
> -get_features()
> -{
> -	_scratch_xfs_db -x  -c "sb" -c "print $1" | awk '// {print $3}'
> -}
> -
>  # clear any mkfs options so that we can directly specify the options we need to
>  # be able to test the features bitmask behaviour correctly.
>  MKFS_OPTIONS=
> @@ -63,8 +58,8 @@ _scratch_mkfs_xfs -m crc=0 -l lazy-count=1 >/dev/null 2>&1
>  # gives us the values the resultant tests should be the same as for testing at
>  # the end of the test. We don't hard code feature values, because that makes the
>  # test break every time we change mkfs feature defaults.
> -f2=`get_features features2`
> -bf2=`get_features bad_features2`
> +f2=`_get_xfs_scratch_sb_field features2`
> +bf2=`_get_xfs_scratch_sb_field bad_features2`
>  
>  #
>  # Now clear the normal flags
> @@ -74,7 +69,7 @@ _scratch_xfs_db -x  -c 'sb' -c 'write features2 0'
>  
>  _scratch_mount
>  _scratch_unmount
> -rwf2=`get_features features2`
> +rwf2=`_get_xfs_scratch_sb_field features2`
>  
>  #
>  # Clear the normal flags again for the second rount.
> @@ -88,7 +83,7 @@ _scratch_xfs_db -x  -c 'sb' -c 'write features2 0'
>  _scratch_mount -o ro
>  _scratch_mount -o remount,rw
>  _scratch_unmount
> -rof2=`get_features features2`
> +rof2=`_get_xfs_scratch_sb_field features2`
>  
>  [ "$f2" != "$bf2" ] && echo "mkfs: features2 $f2 != bad_features2 $bf2"
>  [ "$f2" != "$rwf2" ] && echo "mount rw: old features2 $f2 != new features2 $rwf2"
> diff --git a/tests/xfs/307 b/tests/xfs/307
> index 4ce3e66..1e6cd80 100755
> --- a/tests/xfs/307
> +++ b/tests/xfs/307
> @@ -71,18 +71,11 @@ _set_agf_data() {
>  }
>  
>  _get_sb_data() {
> -	field="$1"
> -	shift
> -
> -	_scratch_xfs_db -c 'sb 0' "$@" -c "p $field"  | awk '{print $3}'
> +	_get_xfs_scratch_sb_field "$@"
>  }
>  
>  _set_sb_data() {
> -	field="$1"
> -	value="$2"
> -	shift; shift
> -
> -	_scratch_xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value"  >> $seqres.full
> +	_set_xfs_scratch_sb_field "$@" >> $seqres.full
>  }
>  
>  _filter_leftover() {
> diff --git a/tests/xfs/308 b/tests/xfs/308
> index e9d7f76..21bde02 100755
> --- a/tests/xfs/308
> +++ b/tests/xfs/308
> @@ -71,18 +71,11 @@ _set_agf_data() {
>  }
>  
>  _get_sb_data() {
> -	field="$1"
> -	shift
> -
> -	_scratch_xfs_db -c 'sb 0' "$@" -c "p $field"  | awk '{print $3}'
> +	_get_xfs_scratch_sb_field "$@"
>  }
>  
>  _set_sb_data() {
> -	field="$1"
> -	value="$2"
> -	shift; shift
> -
> -	_scratch_xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value"  >> $seqres.full
> +	_set_xfs_scratch_sb_field "$@" >> $seqres.full
>  }
>  
>  _filter_leftover() {
> diff --git a/tests/xfs/339 b/tests/xfs/339
> index 734d47b..2acd63f 100755
> --- a/tests/xfs/339
> +++ b/tests/xfs/339
> @@ -59,9 +59,9 @@ ln $SCRATCH_MNT/f3 $SCRATCH_MNT/f4
>  _scratch_unmount
>  
>  echo "Corrupt fs"
> -rrmapino=$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' | awk '{print $3}')
> -_scratch_xfs_db -x -c 'sb 0' -c 'addr rootino' \
> -	-c "write u3.sfdir3.list[3].inumber.i4 $rrmapino" >> $seqres.full
> +rrmapino=`_get_xfs_scratch_sb_field rrmapino`
> +_set_xfs_scratch_sb_field "u3.sfdir3.list[3].inumber.i4" $rrmapino \
> +	-c 'addr rootino' >> $seqres.full
>  _scratch_mount
>  
>  echo "Check files"
> diff --git a/tests/xfs/340 b/tests/xfs/340
> index 8cc50a2..2df8819 100755
> --- a/tests/xfs/340
> +++ b/tests/xfs/340
> @@ -59,7 +59,7 @@ ino=$(stat -c '%i' $SCRATCH_MNT/f3)
>  _scratch_unmount
>  
>  echo "Corrupt fs"
> -rrmapino=$(_scratch_xfs_db -c 'sb 0' -c 'p rrmapino' | awk '{print $3}')
> +rrmapino=$(_get_xfs_scratch_sb_field rrmapino)
>  _scratch_xfs_db -x -c "inode $rrmapino" \
>  	-c 'write core.format 2' -c 'write core.size 0' \
>  	-c 'write core.nblocks 0' -c 'sb 0' -c 'addr rootino' \
> diff --git a/tests/xfs/999 b/tests/xfs/999
> index cea2f85..73be58a 100755
> --- a/tests/xfs/999
> +++ b/tests/xfs/999
> @@ -51,14 +51,6 @@ _cleanup()
>  	_cleanup_flakey > /dev/null 2>&1
>  }
>  
> -_get_xfs_scratch_sb_field()
> -{
> -	local field=$1
> -
> -	_scratch_xfs_db -r -c "sb 0" -c "print $field" | \
> -	awk -v field=$field '$0 ~ field {print $3}'
> -}
> -
>  # inject IO write error for the XFS filesystem except its log section
>  make_xfs_scratch_flakey_table()
>  {
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
