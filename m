Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbcKGDe0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Nov 2016 22:34:26 -0500
Date: Mon, 7 Nov 2016 11:34:08 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: multi-threads freeze/unfreeze test under
 fsstress stress
Message-ID: <20161107033408.GG27776@eguan.usersys.redhat.com>
References: <1478454359-27154-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478454359-27154-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Nov 07, 2016 at 01:45:59AM +0800, Zorro Lang wrote:
> Multi-threads freeze/unfreeze maybe trigger some bugs, e.g: panic,
> hang or data corruption etc. It does't check the return value of
> freeze/unfreeze, but it trys to make sure fsstress won't run fails,
> and no any other bugs happen.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> I can trigger some different hang or panic bugs on different
> linux versions. But it test passed on linux v4.9-rc2 at least.
> 
> Thanks,
> Zorro
> 
>  tests/generic/999     | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  2 ++
>  tests/generic/group   |  3 +-
>  3 files changed, 99 insertions(+), 1 deletion(-)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 0000000..a759927
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,95 @@
> +#! /bin/bash
> +# FS QA Test 999
> +#
> +# Multi-threads freeze/unfreeze testing. This's a stress test case,
> +# it won't do functional check.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
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
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +echo "Silence is golden"
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_freeze
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount >>$seqres.full 2>&1

I don't think we can ignore _scratch_mount status here, we need to make
sure SCRATCH_DEV is really mounted, and _fail if not. Otherwise the test
would freeze/unfreeze root fs.

> +
> +num_cpus=`$here/src/feature -o`

Need '_require_test_program "feature"' first.

> +
> +# Start fsstress in background
> +procs=$num_cpus
> +if [ $procs -gt 20 ]; then
> +	procs=20
> +elif [ $procs -le 1 ]; then
> +	procs=2
> +fi
> +nops=600
> +STRESS_DIR="$SCRATCH_MNT/fsstress_test_dir"

Better to use lower case for local variables, e.g. stress_dir and
fsstress_args.

> +mkdir "$STRESS_DIR"
> +FSSTRESS_ARGS=`_scale_fsstress_args -d $STRESS_DIR -p $procs -n $nops $FSSTRESS_AVOID`
> +$FSSTRESS_PROG $FSSTRESS_ARGS >>$seqres.full 2>&1 &
> +fsstress_pid=$!
> +
> +# Start multi-threads freeze/unfreeze
> +for ((i=0; i<$procs; i++))
> +do

"for ...; do" and "while ...; do"

> +	while [ $(ps -ef | grep "fsstress" | grep -v -c grep) -gt 0 ]

How about "while kill -s 0 $fsstress_pid >/dev/null 2>&1", seems a bit
simpler.

> +	do
> +		xfs_freeze -f $SCRATCH_MNT 2>/dev/null
> +		xfs_freeze -u $SCRATCH_MNT 2>/dev/null
> +	done &
> +	freeze_pids="$! $freeze_pids"
> +done
> +
> +wait $fsstress_pid
> +result=$?
> +wait $freeze_pids
> +
> +# Make sure $SCRATCH_MNT is unfreezed
> +xfs_freeze -u $SCRATCH_MNT 2>/dev/null

I think this belongs to _cleanup().

> +
> +# Exit with fsstress return value
> +status=$result
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 0000000..3b276ca
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 08007d7..39e1876 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -1,4 +1,4 @@
> -# QA groups control file
> +G# QA groups control file

Extra "G" :)

Thanks,
Eryu

>  # Defines test groups and nominal group owners
>  # - do not start group names with a digit
>  # - comment line before each group is "new" description
> @@ -392,3 +392,4 @@
>  387 auto clone
>  388 auto log metadata
>  389 auto quick acl
> +999 auto freeze stress dangerous
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
