Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46071 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfHAKsK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Aug 2019 06:48:10 -0400
Date: Thu, 1 Aug 2019 06:48:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] common/xfs: refactor agcount calculation for mounted
 filesystems
Message-ID: <20190801104806.GB59093@bfoster>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
 <156462378413.2945299.7028294865508807696.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156462378413.2945299.7028294865508807696.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jul 31, 2019 at 06:43:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a helper function to return the number of AGs of a mounted
> filesystem so that we can get rid of the open-coded versions in various
> tests.  The new helper will be used in a subsequent patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Thanks for splitting this out:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs    |    6 ++++++
>  tests/xfs/085 |    2 +-
>  tests/xfs/086 |    2 +-
>  tests/xfs/087 |    2 +-
>  tests/xfs/088 |    2 +-
>  tests/xfs/089 |    2 +-
>  tests/xfs/091 |    2 +-
>  tests/xfs/093 |    2 +-
>  tests/xfs/097 |    2 +-
>  tests/xfs/130 |    2 +-
>  tests/xfs/235 |    2 +-
>  tests/xfs/271 |    2 +-
>  12 files changed, 17 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 2b38e94b..1bce3c18 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -878,3 +878,9 @@ _force_xfsv4_mount_options()
>  	fi
>  	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
>  }
> +
> +# Find AG count of mounted filesystem
> +_xfs_mount_agcount()
> +{
> +	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> +}
> diff --git a/tests/xfs/085 b/tests/xfs/085
> index 23095413..18ddeff8 100755
> --- a/tests/xfs/085
> +++ b/tests/xfs/085
> @@ -63,7 +63,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/086 b/tests/xfs/086
> index 8602a565..7429d39d 100755
> --- a/tests/xfs/086
> +++ b/tests/xfs/086
> @@ -64,7 +64,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  test "${agcount}" -gt 1 || _notrun "Single-AG XFS not supported"
>  umount "${SCRATCH_MNT}"
>  
> diff --git a/tests/xfs/087 b/tests/xfs/087
> index ede8e447..b3d3bca9 100755
> --- a/tests/xfs/087
> +++ b/tests/xfs/087
> @@ -64,7 +64,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/088 b/tests/xfs/088
> index 6f36efab..74b45163 100755
> --- a/tests/xfs/088
> +++ b/tests/xfs/088
> @@ -64,7 +64,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/089 b/tests/xfs/089
> index 5c398299..bcbc6363 100755
> --- a/tests/xfs/089
> +++ b/tests/xfs/089
> @@ -64,7 +64,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/091 b/tests/xfs/091
> index 5d6cd363..be56d8ae 100755
> --- a/tests/xfs/091
> +++ b/tests/xfs/091
> @@ -64,7 +64,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/093 b/tests/xfs/093
> index e09e8499..4c4fbdc4 100755
> --- a/tests/xfs/093
> +++ b/tests/xfs/093
> @@ -64,7 +64,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/097 b/tests/xfs/097
> index db355de6..68eae1d4 100755
> --- a/tests/xfs/097
> +++ b/tests/xfs/097
> @@ -67,7 +67,7 @@ for x in `seq 2 64`; do
>  	touch "${TESTFILE}.${x}"
>  done
>  inode="$(stat -c '%i' "${TESTFILE}.1")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  umount "${SCRATCH_MNT}"
>  
>  echo "+ check fs"
> diff --git a/tests/xfs/130 b/tests/xfs/130
> index 71c1181f..f15366a6 100755
> --- a/tests/xfs/130
> +++ b/tests/xfs/130
> @@ -43,7 +43,7 @@ _scratch_mkfs_xfs > /dev/null
>  echo "+ mount fs image"
>  _scratch_mount
>  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> -agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
> +agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
>  
>  echo "+ make some files"
>  _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
> diff --git a/tests/xfs/235 b/tests/xfs/235
> index 669f58b0..64b0a0b5 100755
> --- a/tests/xfs/235
> +++ b/tests/xfs/235
> @@ -41,7 +41,7 @@ _scratch_mkfs_xfs > /dev/null
>  echo "+ mount fs image"
>  _scratch_mount
>  blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
> -agcount=$($XFS_INFO_PROG ${SCRATCH_MNT} | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
> +agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
>  
>  echo "+ make some files"
>  _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
> diff --git a/tests/xfs/271 b/tests/xfs/271
> index db14bfec..38844246 100755
> --- a/tests/xfs/271
> +++ b/tests/xfs/271
> @@ -37,7 +37,7 @@ echo "Format and mount"
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
>  
> -agcount=$($XFS_INFO_PROG $SCRATCH_MNT | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
> +agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
>  
>  echo "Get fsmap" | tee -a $seqres.full
>  $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap
> 
