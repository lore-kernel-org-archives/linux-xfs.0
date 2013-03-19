Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62AA47F56
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 12:09:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D7BCDAC007
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 10:09:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cMpw2xDlJVpLrEMp for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 10:09:43 -0700 (PDT)
Message-ID: <51489BD6.6030504@sandeen.net>
Date: Tue, 19 Mar 2013 12:09:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add background noise to test 276 (btrfs backref
	resolving)
References: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1363710260-10225-1-git-send-email-list.btrfs@jan-o-sch.net>
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
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, alex.btrfs@zadarastorage.com, xfs@oss.sgi.com

On 3/19/13 11:24 AM, Jan Schmidt wrote:
> The backref resolver test for btrfs was run on a static file system so far.
> Resolving backrefs on a busy file system is what happens in reality and that
> is what should be checked by this test.
> 
> I added a parameter such that the script can easily be changed to the former
> behavior for development purposes.

In practice I'm not sure anyone will ever tune it, but that's ok I think.

> Furthermore, this increases two constants which make the test simply cycle a
> few seconds longer, increasing the chance to hit on something suspicious in
> case we broke something.

Normally we don't change existing tests lest new failures look like regressions
when they aren't, but hey, "btrfs is an experimental filesystem" so maybe it's
ok in this case.  ;)  At some point when things are settled down, we wouldn't
want to make a change like this.  But for now it doesn't bother me.

Looks ok to me:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  276 |   29 ++++++++++++++++++++++++++---
>  1 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/276 b/276
> index 65da464..40b30cf 100755
> --- a/276
> +++ b/276
> @@ -33,9 +33,16 @@ echo "QA output created by $seq"
>  here=`pwd`
>  tmp=/tmp/$$
>  status=1
> +noise_pid=0
>  
>  _cleanup()
>  {
> +	if [ $noise_pid -ne 0 ]; then
> +		echo "background noise kill $noise_pid" >>$seq.full
> +		kill $noise_pid
> +		noise_pid=0
> +		wait
> +	fi
>  	echo "*** unmount"
>  	umount $SCRATCH_MNT 2>/dev/null
>  	rm -f $tmp.*
> @@ -171,6 +178,7 @@ workout()
>  	nfiles=$2
>  	procs=$3
>  	snap_name=$4
> +	do_bg_noise=$5
>  
>  	umount $SCRATCH_DEV >/dev/null 2>&1
>  	echo "*** mkfs -dsize=$fsz"    >>$seq.full
> @@ -179,7 +187,7 @@ workout()
>  		|| _fail "size=$fsz mkfs failed"
>  	run_check _scratch_mount
>  	# -w ensures that the only ops are ones which cause write I/O
> -	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 1000 \
> +	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n 2000 \
>  		$FSSTRESS_AVOID
>  
>  	run_check $BTRFS_UTIL_PROG subvol snap $SCRATCH_MNT \
> @@ -190,9 +198,10 @@ workout()
>  
>  	# make some noise but ensure we're not touching existing data
>  	# extents.
> -	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n 2000 \
> +	run_check $FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n 4000 \
>  		-z -f chown=3 -f link=1 -f mkdir=2 -f mknod=2 \
>  		-f rename=2 -f setxattr=1 -f symlink=2
> +
>  	clean_dir="$SCRATCH_MNT/next"
>  	mkdir $clean_dir
>  	# now make more files to get a higher tree
> @@ -201,6 +210,18 @@ workout()
>  	run_check umount $SCRATCH_DEV >/dev/null 2>&1
>  	run_check _scratch_mount "-o atime"
>  
> +	if [ $do_bg_noise -ne 0 ]; then
> +		# make background noise while backrefs are being walked
> +		while /bin/true; do
> +			echo background fsstress >>$seq.full
> +			run_check $FSSTRESS_PROG -d $SCRATCH_MNT/bgnoise -n 999
> +			echo background rm >>$seq.full
> +			rm -rf $SCRATCH_MNT/bgnoise/
> +		done &
> +		noise_pid=`jobs -p %1`
> +		echo "background noise by $noise_pid" >>$seq.full
> +	fi
> +
>  	cnt=0
>  	errcnt=0
>  	dir="$SCRATCH_MNT/$snap_name/"
> @@ -230,6 +251,7 @@ workout()
>  			break
>  		fi
>  	done
> +
>  	if [ $errcnt -gt 0 ]; then
>  		_fail "test failed: $errcnt error(s)"
>  	fi
> @@ -241,8 +263,9 @@ snap_name="snap1"
>  filesize=`expr 2000 \* 1024 \* 1024`
>  nfiles=4
>  numprocs=1
> +do_bg_noise=1
>  
> -workout $filesize $nfiles $numprocs $snap_name
> +workout $filesize $nfiles $numprocs $snap_name $do_bg_noise
>  
>  echo "*** done"
>  status=0
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
