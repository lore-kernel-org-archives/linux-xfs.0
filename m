Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GJGHfS181620 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 14:16:17 -0500
Message-ID: <502D470C.6070506@sgi.com>
Date: Thu, 16 Aug 2012 14:16:28 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] xfstests: loop devices vs umount stupidity
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
	<1343291706-14882-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291706-14882-3-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/26/2012 03:35 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Unmounting a fileystem mounted on a loop device doesn't always tear
> down the loop device. Its racy, and it causes tests to randomly
> fail.
>
> To avoid that, we have to use umount -d to ensure that we destroy
> loop devices under filesystems in case the kernel doesn't tear it
> down automatically to prevent the test from failing.  However, if
> the kernel does tear it down automatically, umount now issues a
> warning that it couldn't tear down the loop device because it
> couldn't find it, and that causes the test to fail. *facepalm*
>
> So, convert all the loop device unmounts to use -d, and direct the
> output of all of them to /dev/null.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>   049 |    8 ++++----
>   073 |    2 +-
>   078 |    4 ++--
>   216 |    2 +-
>   217 |    2 +-
>   250 |    4 ++--
>   6 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/049 b/049
> index c6c4faa..c3065ad 100755
> --- a/049
> +++ b/049
> @@ -30,8 +30,8 @@ echo "QA output created by $seq"
>   _cleanup()
>   {
>       cd /
> -    umount $SCRATCH_MNT/test2 > /dev/null 2>&1
> -    umount $SCRATCH_MNT/test > /dev/null 2>&1
> +    umount -d $SCRATCH_MNT/test2 > /dev/null 2>&1
> +    umount -d $SCRATCH_MNT/test > /dev/null 2>&1
>       rm -f $tmp.*
>
>       if [ -w $seq.full ]
> @@ -124,11 +124,11 @@ rm -rf $SCRATCH_MNT/test/* >> $seq.full 2>&1 \
>       || _fail "!!! clean failed"
>
>   _log "umount ext2 on xfs"
> -umount $SCRATCH_MNT/test2 >> $seq.full 2>&1 \
> +umount -d $SCRATCH_MNT/test2 >> $seq.full 2>&1 \
>       || _fail "!!! umount ext2 failed"
>
>   _log "umount xfs"
> -umount $SCRATCH_MNT/test >> $seq.full 2>&1 \
> +umount -d $SCRATCH_MNT/test >> $seq.full 2>&1 \
>       || _fail "!!! umount xfs failed"
>
>   echo "--- mounts at end (before cleanup)" >> $seq.full
> diff --git a/073 b/073
> index 18257d4..9605662 100755
> --- a/073
> +++ b/073
> @@ -120,7 +120,7 @@ _verify_copy()
>
>   	echo unmounting and removing new image
>   	umount $source_dir
> -	umount -d $target_dir
> +	umount -d $target_dir > /dev/null 2>&1
>   	rm -f $target
>   }
>
> diff --git a/078 b/078
> index 5cb66df..7af552e 100755
> --- a/078
> +++ b/078
> @@ -37,7 +37,7 @@ _cleanup()
>   {
>       cd /
>       rm -f $tmp.*
> -    umount $LOOP_MNT 2>/dev/null
> +    umount -d $LOOP_MNT 2>/dev/null
>       rmdir $LOOP_MNT
>       _cleanup_testdir
>   }
> @@ -98,7 +98,7 @@ _grow_loop()
>   	$XFS_GROWFS_PROG $LOOP_MNT 2>&1 |  _filter_growfs 2>&1
>
>   	echo "*** unmount"
> -	umount $LOOP_MNT
> +	umount -d $LOOP_MNT > /dev/null 2>&1
>
>   	# Large grows takes forever to check..
>   	if [ "$check" -gt "0" ]
> diff --git a/216 b/216
> index 7c046f5..71e6dd7 100755
> --- a/216
> +++ b/216
> @@ -63,7 +63,7 @@ _do_mkfs()
>   			-d name=$LOOP_DEV,size=${i}g |grep log
>   		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
>   		echo "test write" > $LOOP_MNT/test
> -		umount $LOOP_MNT
> +		umount -d $LOOP_MNT > /dev/null 2>&1
>   	done
>   }
>   # make large holey file
> diff --git a/217 b/217
> index 19540ad..ef0761e 100755
> --- a/217
> +++ b/217
> @@ -65,7 +65,7 @@ _do_mkfs()
>   			-d name=$LOOP_DEV,size=${i}g |grep log
>   		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
>   		echo "test write" > $LOOP_MNT/test
> -		umount $LOOP_MNT
> +		umount -d $LOOP_MNT > /dev/null 2>&1
>   	done
>   }
>   # make large holey file
> diff --git a/250 b/250
> index 92e3cc5..9eca2b6 100755
> --- a/250
> +++ b/250
> @@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>   _cleanup()
>   {
>   	cd /
> -	umount $LOOP_MNT 2>/dev/null
> +	umount -d $LOOP_MNT 2>/dev/null
>   	rm -f $LOOP_DEV
>   	rmdir $LOOP_MNT
>   	_cleanup_testdir
> @@ -85,7 +85,7 @@ _test_loop()
>   	xfs_io -f -c "resvsp 0 $fsize" $LOOP_MNT/foo | _filter_io
>
>   	echo "*** unmount loop filesystem"
> -	umount $LOOP_MNT
> +	umount -d $LOOP_MNT > /dev/null 2>&1
>
>   	echo "*** check loop filesystem"
>   	 _check_xfs_filesystem $LOOP_DEV none none
>

Test 250 Fails but a bug is already created for this, PV1026237.
Other than that it looks good and the bug is not related to this patch, 
so ...

Reviewed-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
