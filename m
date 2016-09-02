Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CBCA7CA2
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 03:38:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F0A08F8033
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2016 01:38:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id P0wpeJlyHaIDd1hT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Sep 2016 01:38:29 -0700 (PDT)
Date: Fri, 2 Sep 2016 16:38:26 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] xfs/187: fix new sb_features2 stop case running
Message-ID: <20160902083826.GK27776@eguan.usersys.redhat.com>
References: <1472642336-28112-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472642336-28112-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 31, 2016 at 07:18:56PM +0800, Zorro Lang wrote:
> This case is too old, at that time there's no "ftype" feature for
> XFS. Due to this case need to clear features2 bits when mkfs.xfs,
> so ftype bit stop case running for long time.
> 
> New common function _require_old_xfs_format() will help to fix
> this problem. Call it as:
> 
>   _require_old_xfs_format ATTR2 LAZYSBCOUNT
> 
> Then it'll help to clear all features2 bits, besides ATTR2 and
> LAZYSBCOUNT which will be tested in case.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Looks good to me overall, but the commit log and comments seem not so
clear to me :)

Some comments inline.

> ---
> 
> Hi,
> 
> V2 add a new common function _require_old_xfs_format(), which help to
> to make sure no features2 xfs bits will be set.
> 
> But mostly we still want to test some features2 bits, so I make
> this function won't deal with those features which are specified by
> arguments.
> 
> For clear CRC feature, we can set MKFS_OPTIONS="$MKFS_OPTIONS -m crc=0"
> simply. But if the user specify crc=1/0 in local.config file, the test
> can't continue running. So I check if it has been set in the function.

I think this is because newer version of xfsprogs doesn't allow
specifying an option multiple times.

> 
> Please tell me if you have better way to implement this function:)
> 
> By the way, did I miss some features2?
> 
> Thanks,
> Zorro
> 
>  common/rc     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/187 | 36 ++++++++++------------------
>  2 files changed, 87 insertions(+), 24 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 3fb0600..29e2987 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3923,6 +3923,81 @@ _require_xfs_mkfs_without_validation()
>  	fi
>  }
>  
> +# Make sure no features2 bits in XFS, besides those features are

By "besides" I think you mean "except" :)

> +# specified by arguments. All current features2 names as below:
> +#   "CRC FINOBT PROJID32BIT ATTR2 LAZYSBCOUNT FTYPE"
> +_require_old_xfs_format()
> +{
> +	local skiplist="$*"
> +	local ftr2=""
> +	local b

Seems not a good var name

> +	local opts

"opts" is not used.

> +
> +	_scratch_mkfs >/dev/null 2>&1
> +	ftr2=`$XFS_DB_PROG -c version $SCRATCH_DEV | tr 'a-z' 'A-Z' |\
> +		sed -n -e "s/,/ /g" -e "s/.*MOREBITS\(.*\)/\1/p"`
> +
> +	for b in `echo $skiplist | tr 'a-z' 'A-Z'`; do
> +		i=`echo $ftr2 | sed -n -e "s/\(.*\)$b\(.*\)/\1\2/p"`
> +		if [ -n "$b" ]; then
> +			ftr2="$i"
> +		fi
> +	done
> +
> +	for b in $ftr2; do
> +		case $b in
> +		CRC)
> +			if echo $MKFS_OPTIONS | grep -q "crc=1"; then
> +				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
> +					sed -e "s/crc=1/crc=0/g"`
> +			else
> +				MKFS_OPTIONS="$MKFS_OPTIONS -m crc=0"
> +			fi
> +			;;
> +		FINOBT)
> +			if echo $MKFS_OPTIONS | grep -q "finobt=1"; then
> +				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
> +					sed -e "s/finobt=1/finobt=0/g"`
> +			else
> +				MKFS_OPTIONS="$MKFS_OPTIONS -m finobt=0"
> +			fi
> +			;;
> +		PROJID32BIT)
> +			if echo $MKFS_OPTIONS | grep -q "projid32bit=1"; then
> +				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
> +					sed -e "s/projid32bit=1/projid32bit=0/g"`
> +			else
> +				MKFS_OPTIONS="$MKFS_OPTIONS -i projid32bit=0"
> +			fi
> +			;;
> +		ATTR2)
> +			if echo $MKFS_OPTIONS | grep -q "attr="; then
> +				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
> +					sed -e "s/attr=[0-9]/attr=1/g"`
> +			else
> +				MKFS_OPTIONS="$MKFS_OPTIONS -i attr=1"
> +			fi
> +			;;
> +		LAZYSBCOUNT)
> +			if echo $MKFS_OPTIONS | grep -q "lazy-count=1"; then
> +				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
> +					sed -e "s/lazy-count=1/lazy-count=0/g"`
> +			else
> +				MKFS_OPTIONS="$MKFS_OPTIONS -l lazy-count=0"
> +			fi
> +			;;
> +		FTYPE)
> +			if echo $MKFS_OPTIONS | grep -q "ftype=1"; then
> +				MKFS_OPTIONS=`echo $MKFS_OPTIONS | \
> +					sed -e "s/ftype=1/ftype=0/g"`
> +			else
> +				MKFS_OPTIONS="$MKFS_OPTIONS -n ftype=0"
> +			fi
> +			;;
> +		esac
> +	done
> +}
> +
>  init_rc
>  
>  ################################################################################
> diff --git a/tests/xfs/187 b/tests/xfs/187
> index 836b924..ffc851c 100755
> --- a/tests/xfs/187
> +++ b/tests/xfs/187
> @@ -31,7 +31,6 @@ seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
> -here=`pwd`
>  tmp=/tmp/$$
>  status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
> @@ -57,25 +56,16 @@ _supported_fs xfs
>  _supported_os Linux
>  
>  _require_scratch
> +# clear features2 bits which we won't test
> +_require_old_xfs_format ATTR2 LAZYSBCOUNT

Need more comments to state that ATTR2 and LAZYSBCOUNT are features we
want to keep, otherwise this looks like only these two features are
cleared.

>  _require_attrs
> -_require_attr_v1
> -_require_projid16bit

I'd keep above two requires to make sure mkfs supports such features.

>  
>  rm -f $seqres.full
> -
> -# Reset the options so that we can control what is going on here
> -export MKFS_OPTIONS=""
> -export MOUNT_OPTIONS=""
> -
> -# lazysb, attr2 and other feature bits are held in features2 and will require
> -# morebitsbit on So test with lazysb and without it to see if the morebitsbit is
> -# okay etc. If the mkfs defaults change, these need to change as well.
> -export MKFS_NO_LAZY="-m crc=0 -l lazy-count=0 -i projid32bit=0"
> -export MKFS_LAZY="-m crc=0 -l lazy-count=1 -i projid32bit=0"
> +_scratch_mkfs >/dev/null 2>&1

What does this _scratch_mkfs do?

Thanks,
Eryu

>  
>  # Make sure that when we think we are testing with morebits off
>  # that we really are.
> -_scratch_mkfs -i attr=1 $MKFS_NO_LAZY  >/dev/null 2>&1
> +_scratch_mkfs -i attr=1 -l lazy-count=0 >/dev/null 2>&1
>  $XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
>  if grep -i morebits $tmp.db
>  then
> @@ -90,13 +80,13 @@ echo "*** 1. test attr2 mkfs and then noattr2 mount ***"
>  echo ""
>  echo "attr2 fs"
>  echo ""
> -_scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
> +_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
>  $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  echo ""
>  echo "noattr2 fs"
>  echo ""
>  _scratch_mount -o noattr2
> -$UMOUNT_PROG $SCRATCH_MNT
> +_scratch_unmount
>  $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  
>  # adding an EA will ensure the ATTR1 flag is turned on
> @@ -105,7 +95,7 @@ echo "*** 2. test attr2 mkfs and then noattr2 mount with 1 EA ***"
>  echo ""
>  echo "attr2 fs"
>  echo ""
> -_scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
> +_scratch_mkfs -i attr=2 -l lazy-count=0 >/dev/null 2>&1
>  $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  echo ""
>  echo "noattr2 fs"
> @@ -115,8 +105,8 @@ cd $SCRATCH_MNT
>  touch testfile
>  $SETFATTR_PROG -n user.test -v 0xbabe testfile
>  $GETFATTR_PROG testfile
> -cd $here
> -$UMOUNT_PROG $SCRATCH_MNT
> +cd - >/dev/null
> +_scratch_unmount
>  $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  
>  echo ""
> @@ -125,16 +115,14 @@ echo ""
>  echo ""
>  echo "attr2 fs"
>  echo ""
> -_scratch_mkfs -i attr=2 $MKFS_LAZY >/dev/null 2>&1
> +_scratch_mkfs -i attr=2 -l lazy-count=1 >/dev/null 2>&1
>  $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  echo ""
>  echo "noattr2 fs"
>  echo ""
>  _scratch_mount -o noattr2
> -cd $SCRATCH_MNT
> -touch testfile
> -cd $here
> -$UMOUNT_PROG $SCRATCH_MNT
> +touch $SCRATCH_MNT/testfile
> +_scratch_unmount
>  $XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
>  
>  # success, all done
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
