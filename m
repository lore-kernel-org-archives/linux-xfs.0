Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934935AbcIUPDp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:03:45 -0400
Date: Wed, 21 Sep 2016 23:03:42 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: test xfs_copy V5 XFS without -d option
Message-ID: <20160921150342.GN27776@eguan.usersys.redhat.com>
References: <1474455620-25982-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1474455620-25982-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Sep 21, 2016 at 07:00:20PM +0800, Zorro Lang wrote:
> From linux v4.3 and xfsprogs v4.2, xfs_copy support to copy a V5 XFS.
> Before that, copy a V5 XFS will cause target fs corruption, and only
> use "-d" option can resolve that problem.
> 
> For this old reason, xfstests use below patch to add '-d' option to
> xfs_copy, make sure xfs_copy always use that option if it try to copy
> a V5 XFS:
> 
>   8346e53 common: append -d option to XFS_COPY_PROG when testing v5 xfs
> 
> But xfs_copy full support v5 xfs now. So xfstest miss the coverage of
> copy a V5 XFS without '-d'. For test this feature I did below things:
> 
>   1. Revert commit 8346e53
>   2. Add a new common function _require_xfs_copy(), if a test try to
>      use old xfsprogs to copy a V5 xfs, it'll skip that test.
>   3. Add above common function into all xfs_copy related cases.
>   4. xfs/073 test V4 xfs forcibly by specify "-m crc=0" in case. I
>      think it's useless now, so remove it.
> 
> There's a xfs_copy related case I didn't add _require_xfs_copy()
> to it -- xfs/032, due to it tests "xfs_copy -d" directly.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
>  common/rc     | 27 ++++++++++++++++++++++-----
>  tests/xfs/073 |  9 +++------
>  tests/xfs/077 |  1 +
>  3 files changed, 26 insertions(+), 11 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 13afc6a..9ba073b 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3789,11 +3789,6 @@ init_rc()
>  	# Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
>  	xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
>  	export XFS_IO_PROG="$XFS_IO_PROG -F"
> -
> -	# xfs_copy doesn't work on v5 xfs yet without -d option
> -	if [ "$FSTYP" == "xfs" ] && [[ $MKFS_OPTIONS =~ crc=1 ]]; then
> -		export XFS_COPY_PROG="$XFS_COPY_PROG -d"
> -	fi
>  }
>  
>  # get real device path name by following link
> @@ -3994,6 +3989,28 @@ _require_xfs_mkfs_without_validation()
>  	fi
>  }
>  
> +# Make sure xfs_copy full support to copy V5 XFS, due to old xfs_copy can't
> +# yet copy V5 xfs without '-d'. But if xfs_copy can't copy V4 XFS, that's a
> +# bug.
> +_require_xfs_copy()

I'd suggest name it as _require_xfs_copy_crc, which indicates we need
xfs_copy crc support, like _require_xfs_mkfs_crc.

> +{
> +	_scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null

Assuming we have $SCRATCH_DEV defined in a common helper doesn't seem
right to me. Actually you don't have to use $SCRATCH_DEV in this test

	touch $tmp.img
	$MKFS_XFS_PROG -d file,name=$tmp.img,size=32m

then test copy on this image

	$XFS_COPY_PROG $tmp.img $tmp.copy

> +	. $tmp.mkfs
> +
> +	${XFS_COPY_PROG} $SCRATCH_DEV $tmp.copy >/dev/null 2>&1
> +	local rc=$?
> +
> +	rm -f $tmp.mkfs
> +	rm -f $tmp.copy 2>/dev/null
> +	if [ $rc -ne 0 ]; then
> +		if [ $_fs_has_crcs -eq 1 ]; then
> +			_notrun "This test requires xfs_copy support to copy V5 xfs without -d"
> +		else
> +			_fail "xfs_copy can't copy a V4 xfs"

I don't think this kind of "_fail" belongs to a "_require" helper, it
should be done in tests.

> +		fi
> +	fi
> +}
> +

After going through this function, I find that it's not always checking
if xfs_copy has crc support, it checks the crc support only when
_scratch_mkfs creates a crc enabled fs. This information is "hidden" in
the helper, and this behavior doesn't match the function name and the
comments.

So I'd suggest the following, what do you think?

Create a new helper _require_xfs_copy_crc() as I suggested above, which
always checks if xfs_copy has crc support. Then call this helper from
xfs/073 and xfs/077 only when we're testing v5 XFS. i.e.

_scratch_mkfs_xfs -dsize=41m,agcount=2 | _filter_mkfs 2>$tmp.mkfs >>$seqres.full
. $tmp.mkfs
# we need xfs_copy CRC support if we're testing CRC enabled fs
if [ $_fs_has_crcs -eq 1 ]; then
	_require_xfs_copy_crc
fi
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"

So it's clear why we need xfs_copy crc support, this information is not
"buried" in the original _require_xfs_copy_crc.

Thanks,
Eryu

>  init_rc
>  
>  ################################################################################
> diff --git a/tests/xfs/073 b/tests/xfs/073
> index 9e29223..02e45d5 100755
> --- a/tests/xfs/073
> +++ b/tests/xfs/073
> @@ -134,11 +134,12 @@ _require_attrs
>  [ -n "$XFS_COPY_PROG" ] || _notrun "xfs_copy binary not yet installed"
>  
>  _require_scratch
> +_require_xfs_copy
>  _require_loop
>  
>  rm -f $seqres.full
>  
> -_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 >>$seqres.full 2>&1
> +_scratch_mkfs_xfs -dsize=41m,agcount=2 >>$seqres.full 2>&1
>  _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
>  
>  echo
> @@ -158,11 +159,7 @@ _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
>  
>  echo 
>  echo === copying scratch device to single target, large ro device
> -mkfs_crc_opts="-m crc=0"
> -if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
> -	mkfs_crc_opts=""
> -fi
> -${MKFS_XFS_PROG} $mkfs_crc_opts -dfile,name=$imgs.source,size=100g \
> +${MKFS_XFS_PROG} -dfile,name=$imgs.source,size=100g \
>  	| _filter_mkfs 2>/dev/null
>  rmdir $imgs.source_dir 2>/dev/null
>  mkdir $imgs.source_dir
> diff --git a/tests/xfs/077 b/tests/xfs/077
> index 007d05d..7bcbfb5 100755
> --- a/tests/xfs/077
> +++ b/tests/xfs/077
> @@ -51,6 +51,7 @@ _cleanup()
>  _supported_fs xfs
>  _supported_os Linux
>  _require_scratch
> +_require_xfs_copy
>  _require_xfs_crc
>  _require_meta_uuid
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
