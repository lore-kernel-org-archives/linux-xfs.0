Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36446 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbeGNMAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jul 2018 08:00:22 -0400
Date: Sat, 14 Jul 2018 19:41:28 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 4/7] xfs: filter out mount options that don't work on v4
 filesystems
Message-ID: <20180714114128.GD2830@desktop>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
 <153067987261.28393.13229691209356951536.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153067987261.28393.13229691209356951536.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 03, 2018 at 09:51:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A few tests require v4 filesystems and enforce this by disabling crc's
> in the _scratch_mkfs call.  However, if the user specified MOUNT_OPTIONS
> that only work with v5 filesystems, these tests fail.  Filter out
> incompatible mount options that don't work on v4, such as simultaneous
> group/project quota.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/xfs    |   23 +++++++++++++++++++++++
>  tests/xfs/002 |    2 ++
>  tests/xfs/194 |    2 ++
>  tests/xfs/199 |    2 ++
>  4 files changed, 29 insertions(+)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 5b632df1..33d819d7 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -780,3 +780,26 @@ _scratch_get_bmx_prefix() {
>  	_scratch_xfs_db -c "inode ${ino}" -c 'p' >> $seqres.full
>  	return 1
>  }
> +
> +#
> +# Ensures that we don't pass any mount options incompatible with XFS v4
> +#
> +_filter_xfsv4_mount_options()

"_filter" usually indicates a filter function that gets input from a
pipe, e.g. <some cmd> | _filter_scratch, but this helper doesn't follow
the convention. It'd better to rename it to ... I don't know, just
_xfsv4_mount_options?

> +{
> +	local gquota=0
> +	local pquota=0
> +
> +	# Can't have group and project quotas in XFS v4
> +	echo "$MOUNT_OPTIONS" | egrep -q "(gquota|grpquota|grpjquota=|gqnoenforce)" && gquota=1
> +	echo "$MOUNT_OPTIONS" | egrep -q "(\bpquota|prjquota|pqnoenforce)" && pquota=1
> +
> +	if [ $gquota -gt 0 ] && [ $pquota -gt 0 ]; then
> +		export MOUNT_OPTIONS=$(echo $MOUNT_OPTIONS \
> +			| sed   -e 's/gquota/QUOTA/g'      \
> +				-e 's/grpquota/QUOTA/g'    \
> +				-e 's/grpjquota=[^, ]/QUOTA/g' \
> +				-e 's/gqnoenforce/QUOTA/g' \
> +				-e "s/QUOTA/defaults/g")
> +	fi
> +	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
> +}
> diff --git a/tests/xfs/002 b/tests/xfs/002
> index bd1c0a7a..f987575c 100755
> --- a/tests/xfs/002
> +++ b/tests/xfs/002
> @@ -45,6 +45,8 @@ rm -f $seqres.full
>  
>  _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
>  
> +_filter_xfsv4_mount_options

Hmm, this way future test writers have to remember to add a
_filter_xfsv4_mount_options call everytime after making a v4 xfs. It's
so easy to get lost and hard to maintain.

How about make _scratch_mkfs_xfs do the work automatically if it finds
the newly created fs is a v4 xfs?


And I went through all tests that have explicit "-m crc=0" mkfs option,
and I found that there're some other tests need fix too.

xfs/045, it doesn't fail, but the test expects a mount failure anyway,
just that it's caused by quota options now.

xfs/132, it fails to mount xfs and needs the fix. But it still fails
even after the fix, but that's a different issue.

xfs/300, the test itself passes, it just causes subsequent
_scratch_mount to fail in _check_xfs_filesystem(). I think we could just
umount $SCRATCH_DEV explicitly after test, so _check_xfs_filesystem()
won't try to mount it again.

Thanks,
Eryu

> +
>  # Scribble past a couple V4 secondary superblocks to populate sb_crc
>  # (We can't write to the structure member because it doesn't exist
>  # on a v4 superblock, so we use the data type & "write fill")
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 6c1eddba..09a3840d 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -74,6 +74,8 @@ _require_scratch
>  unset MKFS_OPTIONS
>  unset XFS_MKFS_OPTIONS
>  
> +_filter_xfsv4_mount_options
> +
>  # we need 512 byte block size, so crc's are turned off
>  _scratch_mkfs_xfs -m crc=0 -b size=$blksize >/dev/null 2>&1
>  _scratch_mount
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index dd909b09..54fe54fe 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -34,6 +34,8 @@ _supported_os Linux
>  
>  _require_scratch
>  
> +_filter_xfsv4_mount_options
> +
>  # clear any mkfs options so that we can directly specify the options we need to
>  # be able to test the features bitmask behaviour correctly.
>  MKFS_OPTIONS=
> 
