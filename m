Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3EFxRXs082098 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 10:59:28 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CD4D1287170
	for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 09:01:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8pROuV9s84ABfQaF for
	<xfs@oss.sgi.com>; Wed, 14 Apr 2010 09:01:22 -0700 (PDT)
Message-ID: <4BC5E6CC.7030709@redhat.com>
Date: Wed, 14 Apr 2010 11:01:16 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: ext34_free_inode's mess
References: <87pr2246y4.fsf@openvz.org>
In-Reply-To: <87pr2246y4.fsf@openvz.org>
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
Cc: ext4 development <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

Dmitry Monakhov wrote:
> I've finally automated my favorite testcase (see attachment), 
> before i've run it by hand.

Thanks!  Feel free to cc: the xfs list since the patch hits
xfstests.  (I added it here)

>  227     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  227.out |    5 +++
>  group   |    1 +
>  3 files changed, 111 insertions(+), 0 deletions(-)
>  create mode 100755 227
>  create mode 100644 227.out
> 
> diff --git a/227 b/227
> new file mode 100755
> index 0000000..d2b0c7d
> --- /dev/null
> +++ b/227
> @@ -0,0 +1,105 @@
> +#! /bin/bash
> +# FS QA Test No. 227
> +#
> +# Perform fsstress test with parallel dd
> +# This proven to be a good stress test
> +# * Continuous dd retult in ENOSPC condition but only for a limited periods
> +#   of time.
> +# * Fsstress test cover many code paths

just little editor nitpicks: 

+# Perform fsstress test with parallel dd
+# This is proven to be a good stress test
+# * Continuous dd results in ENOSPC condition but only for a limited period
+#   of time.
+# * Fsstress test covers many code paths


> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2010 Dmitry Monakhov.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dmonakhov@openvz.org
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +    rm -f $tmp.*
> +}
> +
> +workout()
> +{
> +    # Disable bash job controll, to prevent message about killed task.

s/controll/control/

> +    set +m
> +
> +    #Timing parameters
> +    nr_iterations=5
> +    kill_tries=20
> +    echo Running fsstress. | tee -a $seq.full
> +
> +####################################################

What is all this for?

FWIW other fsstress tests use an $FSSTRESS_AVOID variable,
where you can set the things you want to avoid easily

> +##    -f unresvsp=0 -f allocsp=0 -f freesp=0 \
> +##    -f setxattr=0 -f attr_remove=0 -f attr_set=0 \
> +## 
> +######################################################
> +    mkdir -p $SCRATCH_MNT/fsstress
> +    # It is reasonable to disable sync, otherwise most of tasks will simply
> +    # stuck in that sync() call.
> +    $FSSTRESS_PROG \
> +	-d $SCRATCH_MNT/fsstress \
> +	-p 100 -f sync=0  -n 9999999 > /dev/null 2>&1 &
> +
> +    echo Running ENOSPC hitters. | tee -a $seq.full
> +    for ((i = 0; i < $nr_iterations; i++))
> +    do
> +	#Open with O_TRUNC and then write until error
> +	#hit ENOSPC each time.
> +	dd if=/dev/zero of=$SCRATCH_MNT/BIG_FILE bs=1M 2> /dev/null
> +    done
> +
> +    for ((i = 0; i < $kill_tries; i++))
> +    do
> +	killall -r -q -TERM fsstress 2> /dev/null
> +	sleep 1
> +    done
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +
> +rm -f $seq.full
> +
> +umount $TEST_DEV >/dev/null 2>&1
> +umount $SCRATCH_DEV >/dev/null 2>&1
> +echo "*** MKFS ***"                         >>$seq.full
> +echo ""                                     >>$seq.full
> +_scratch_mkfs    >/dev/null 2>&1 || _fail "mkfs failed"
> +_scratch_mount   >/dev/null 2>&1 || _fail "mount failed"
> +
> +workout
> +umount $SCRATCH_MNT
> +echo 
> +echo Checking filesystem
> +_check_scratch_fs
> +status=$?
> +exit
> diff --git a/227.out b/227.out
> new file mode 100644
> index 0000000..6a7342d
> --- /dev/null
> +++ b/227.out
> @@ -0,0 +1,5 @@
> +QA output created by 227
> +Running fsstress.
> +Running ENOSPC hitters.
> +
> +Checking filesystem
> diff --git a/group b/group
> index 8d4a83a..81a2aa4 100644
> --- a/group
> +++ b/group
> @@ -339,3 +339,4 @@ deprecated
>  223 auto quick
>  224 auto
>  225 auto quick
> +227 rw auto prealloc enospc

Is this prealloc just because fsstress may run resvsp?
FWIW, other fsstress tests aren't in that group, so this is
as little inconsistent.

Thanks for writing an xfstests patch! :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
