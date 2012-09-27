Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8R14FdW020295 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 20:04:15 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	a7fDAPC8nzyjnBWM for <xfs@oss.sgi.com>;
	Wed, 26 Sep 2012 18:05:32 -0700 (PDT)
Date: Thu, 27 Sep 2012 11:05:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] add  fallocate/truncate vs AIO/DIO stress test
Message-ID: <20120927010512.GF15236@dastard>
References: <1348496601-32637-1-git-send-email-dmonakhov@openvz.org>
	<1348496601-32637-4-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1348496601-32637-4-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, hch@lst.de, xfs@oss.sgi.com

On Mon, Sep 24, 2012 at 06:23:19PM +0400, Dmitry Monakhov wrote:
> Run  DIO, fallocate and truncate threads on a common file in parallel.
> If race exist old dio request may rewrite blocks after it was allocated
> to another file, we will catch that by verifying blocks content.
> 
> this patch known to catch deadlock for ext4
> http://lists.openwall.net/linux-ext4/2012/09/06/3
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  286     |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  286.out |    5 ++
>  group   |    1 +
>  3 files changed, 160 insertions(+), 0 deletions(-)
>  create mode 100755 286
>  create mode 100644 286.out
> 
> diff --git a/286 b/286
> new file mode 100755
> index 0000000..8802c56
> --- /dev/null
> +++ b/286
> @@ -0,0 +1,154 @@
> +#! /bin/bash
> +# FSQA Test No. 286
> +#
> +# Test various aio dio vs truncate

Can you add a better description of what the test is supposed to do
here? The commit message above would be a good start.

....
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +run_check()
> +{
> +	echo "# $@" >> $seq.full 2>&1
> +	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
> +}

run-check is being copied from test to test. Can you move it to
common.rc?

> +
> +
> +NUM_JOBS=$((4*LOAD_FACTOR))
> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +FILE_SIZE=$((BLK_DEV_SIZE * 512))
> +
> +cat >$tmp-$seq.fio <<EOF

Before this, please move all the other test setup stuff like the
_require directives before this. That way I don't have to scroll
past a hundred lines of test specific setup to find out what the
test constraints are. i.e. these:

> +_supported_fs generic
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch

.....
> +## Perform direct aio, to files which may be truncated
> +## by external task
> +[direct_aio]
> +direct=1
> +buffered=0
> +numjobs=${NUM_JOBS}
> +rw=randwrite
> +runtime=100*${TIME_FACTOR}
> +time_based
.....
> +_workout()
> +{
> +	echo ""
> +	echo "Run fio with random aio-dio pattern"
> +	echo ""
> +	cat $tmp-$seq.fio >>  $seq.full
> +	run_check $FIO_PROG $tmp-$seq.fio >>  $seq.full &
> +	pid=$!
> +	echo "Start fallocate/truncate loop"
> +	for ((i=0; ; i++))
> +	do
> +	    for ((k=1; k <= NUM_JOBS; k++))
> +	    do
> +		fallocate -l $FILE_SIZE $SCRATCH_MNT/direct_aio.$k.0 \
> +		    	>> $seq.full 2>&1
> +	    done

It's not clear to me where the file names come from. I think it's
because the FIO job takes the name of the file if it's not specified
from the job name (i.e. [direct_aio]).  If so, can you make that a
variable and comment to the effect that the filenames are derived from
the FIO job definition?

> +	    for ((k=1; k <= NUM_JOBS; k++))
> +	    do
> +		truncate -s 0 $SCRATCH_MNT/direct_aio.$k.0
> +	    done
> +	    # One fio exit we can stop fallocate/truncate loop

	      Once?

> +	    kill -0 $pid > /dev/null 2>&1 || break

/me has to look up what kill -0 does, as 0 is not a valid signal
number.

The kill(1) man page doesn't document it, kill -l doesn't list 0
as a valid signal, and signal(7) doesn't document it either.
Wonderful!

Oh, there it is - in the syscall documentation (i.e. kill(2)):

"this can be used to check for the existence of a process ID"

Right, OK, now I understand the loop. :)

....
> +_scratch_mkfs >> $seq.full 2>&1
> +_scratch_mount
> +
> +if ! _workout; then
> +	umount $SCRATCH_DEV 2>/dev/null
> +	exit
> +fi

No need to unmount the SCRATCH_DEV on exit - that will happen if
necessary next time _require_scratch is called by a test....

> +
> +if ! _scratch_unmount; then
> +	echo "failed to umount"
> +	status=1
> +	exit
> +fi

No need to unmount before checking, the _check_scratch_fs function
does that for you and will leave unmount errors in the log if it
fails. i.e. the test will fail the check and the reason will be
obvious from the output...

> +_check_scratch_fs
> +status=$?
> +exit
> diff --git a/286.out b/286.out
> new file mode 100644
> index 0000000..d721996
> --- /dev/null
> +++ b/286.out
> @@ -0,0 +1,5 @@
> +QA output created by 286
> +
> +Run fio with random aio-dio pattern
> +
> +Start fallocate/truncate loop
> diff --git a/group b/group
> index 697269b..2469f80 100644
> --- a/group
> +++ b/group
> @@ -404,3 +404,4 @@ deprecated
>  283 dump ioctl auto quick
>  284 auto
>  285 auto dump quota quick
> +286 auto rw enospc aio

Why the ENOSPC group? I don't see anything that exercises ENOSPC
behaviour in the test, and none of the comments indicate that it 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
