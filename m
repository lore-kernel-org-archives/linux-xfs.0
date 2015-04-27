Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1B88F7F54
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 11:43:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E29088F8081
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2015 09:43:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zxQQkPo7ic0JKSOB for <xfs@oss.sgi.com>;
	Mon, 27 Apr 2015 09:43:17 -0700 (PDT)
Message-ID: <553E6723.8090909@sandeen.net>
Date: Mon, 27 Apr 2015 11:43:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: log record crc mismatch test
References: <553E5505.4070804@oracle.com>
In-Reply-To: <553E5505.4070804@oracle.com>
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
To: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>, xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

On 4/27/15 10:25 AM, Alexander Tsvetkov wrote:
> Added new test case for simulation of V5 filesystem
> log crc record corruption using of external log.
> 
> Signed-off-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
> ---
>  tests/xfs/005     | 28 ++++++++++++++++++++++++++--
>  tests/xfs/005.out |  3 +++
>  2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/xfs/005 b/tests/xfs/005
> index fade4bb..ba0dcbb 100755
> --- a/tests/xfs/005
> +++ b/tests/xfs/005
> @@ -1,7 +1,7 @@
>  #! /bin/bash
>  # FS QA Test No. 005
>  #
> -# Test that a bad crc on a primary V5 superblock will fail the mount
> +# Test that a bad crc on a V5 filesystem will fail the mount

bad crc on what?

>  #
>  # 10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
>  # inadvertently caused primary SB CRC failures to not error out, this
> @@ -55,10 +55,12 @@ _supported_os Linux
> 
>  _require_scratch_nocheck
>  _require_xfs_mkfs_crc
> +_require_logdev
> +logsize=2560

No, this means that xfs/05 will no longer work without an external logdev,
right?  So you've stopped testing the internal case, and we've lost that
coverage.

And, we generally don't want to add new testcases to old tests because then
it gets harder to investigate regressions.  It'd probably be best to
create a new test which specifically tests log crc corruption, and make
it handle both internal and external logs automatically.

Thanks,
-Eric

>  rm -f $seqres.full
> 
> -_scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs_xfs -m crc=1 -lsize=${logsize}b >> $seqres.full 2>&1 || _fail "mkfs failed"
> 
>  # Zap the crc.  xfs_db updates the CRC post-write, so poke it directly
>  $XFS_IO_PROG -c "pwrite 224 4" -c fsync $SCRATCH_DEV | _filter_xfs_io
> @@ -66,6 +68,28 @@ $XFS_IO_PROG -c "pwrite 224 4" -c fsync $SCRATCH_DEV | _filter_xfs_io
>  # should FAIL, the crc is bad; golden output contains mount failure
>  _scratch_mount 2>&1 | filter_mount
> 
> +_scratch_unmount &> /dev/null
> +_scratch_mkfs_xfs -m crc=1 -lsize=${logsize}b  >> $seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed"
> +
> +# Run filesytem exercising for some time
> +_param="-f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10"
> +$FSSTRESS_PROG $_param -s 1 $FSSTRESS_AVOID -n 1000 -d $SCRATCH_MNT &> /dev/null
> +sleep 3
> +
> +# Shutdown filesystem and unmount
> +src/godown -v $SCRATCH_MNT >> $seqres.full
> +killall -q fsstress
> +wait
> +sleep 3
> +_scratch_unmount
> +
> +# Zap log record crc.
> +$XFS_IO_PROG -c "pwrite 5000 5" $SCRATCH_LOGDEV | _filter_xfs_io
> +
> +# should FAIL, log record crc is bad; golden output contains mount failure
> +_scratch_mount 2>&1 | filter_mount
> +
>  # success, all done
>  status=0
>  exit
> diff --git a/tests/xfs/005.out b/tests/xfs/005.out
> index 13d0125..8907301 100644
> --- a/tests/xfs/005.out
> +++ b/tests/xfs/005.out
> @@ -2,3 +2,6 @@ QA output created by 005
>  wrote 4/4 bytes at offset 224
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  mount: Structure needs cleaning
> +wrote 5/5 bytes at offset 5000
> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +mount: Structure needs cleaning

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
