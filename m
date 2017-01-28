Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57700 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751720AbdA1SLD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 28 Jan 2017 13:11:03 -0500
Subject: Re: [PATCH 1/3] xfs/263: don't hardcode inode numbers in output
References: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7df1dabe-3832-ffa7-cb80-07ee602bd455@sandeen.net>
Date: Sat, 28 Jan 2017 12:10:56 -0600
MIME-Version: 1.0
In-Reply-To: <148562509264.30594.7506967863745489318.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On 1/28/17 11:38 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Since we can't control the inode number assignments when creating files,
> don't hardcode them in the golden output.

what numbers are you seeing?

The inode numbers aren't important for the test, but I don't want to
gloss over something unexpected.

# Control size to control inode numbers
$MKFS_XFS_PROG -f -m crc=0 -n ftype=0 -d size=512m $SCRATCH_DEV >>$seqres.full

-Eric

 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/263     |    6 +++++-
>  tests/xfs/263.out |   52 ++++++++++++++++++++++++++--------------------------
>  2 files changed, 31 insertions(+), 27 deletions(-)
> 
> 
> diff --git a/tests/xfs/263 b/tests/xfs/263
> index 1dc47ae..7aebf90 100755
> --- a/tests/xfs/263
> +++ b/tests/xfs/263
> @@ -71,6 +71,10 @@ function option_string()
>  	echo $OPT
>  }
>  
> +filter_quota_state() {
> +	sed -e 's/Inode: #[0-9]\+/Inode #XXX/g' | _filter_scratch
> +}
> +
>  function test_all_state()
>  {
>  	for I in `seq 0 7`; do
> @@ -79,7 +83,7 @@ function test_all_state()
>  		# Some combinations won't mount on V4 supers (grp + prj)
>  		_qmount_option "$OPTIONS"
>  		_scratch_mount &>> $seqres.full || continue
> -		$XFS_QUOTA_PROG -x -c "state" $SCRATCH_MNT | _filter_scratch
> +		$XFS_QUOTA_PROG -x -c "state" $SCRATCH_MNT | filter_quota_state
>  		_scratch_unmount
>  	done
>  }
> diff --git a/tests/xfs/263.out b/tests/xfs/263.out
> index 70454dd..531d45d 100644
> --- a/tests/xfs/263.out
> +++ b/tests/xfs/263.out
> @@ -5,7 +5,7 @@ QA output created by 263
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #131 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -21,11 +21,11 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #131 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #132 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -37,11 +37,11 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #131 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #132 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -53,7 +53,7 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #131 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -61,7 +61,7 @@ Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #132 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Blocks grace time: [7 days]
>  Inodes grace time: [7 days]
>  Realtime Blocks grace time: [7 days]
> @@ -69,7 +69,7 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #131 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -77,7 +77,7 @@ Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #132 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Blocks grace time: [7 days]
>  Inodes grace time: [7 days]
>  Realtime Blocks grace time: [7 days]
> @@ -89,7 +89,7 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -105,11 +105,11 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #100 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -121,11 +121,11 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #100 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> @@ -137,15 +137,15 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #100 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #101 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Blocks grace time: [7 days]
>  Inodes grace time: [7 days]
>  Realtime Blocks grace time: [7 days]
> @@ -153,15 +153,15 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #100 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #101 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Blocks grace time: [7 days]
>  Inodes grace time: [7 days]
>  Realtime Blocks grace time: [7 days]
> @@ -169,15 +169,15 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: OFF
>    Enforcement: OFF
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #100 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #101 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Blocks grace time: [7 days]
>  Inodes grace time: [7 days]
>  Realtime Blocks grace time: [7 days]
> @@ -185,15 +185,15 @@ Realtime Blocks grace time: [7 days]
>  User quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #99 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Group quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #100 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Project quota state on SCRATCH_MNT (SCRATCH_DEV)
>    Accounting: ON
>    Enforcement: ON
> -  Inode: #101 (1 blocks, 1 extents)
> +  Inode #XXX (1 blocks, 1 extents)
>  Blocks grace time: [7 days]
>  Inodes grace time: [7 days]
>  Realtime Blocks grace time: [7 days]
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
