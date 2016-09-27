Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750840AbcI0NMx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Sep 2016 09:12:53 -0400
Date: Tue, 27 Sep 2016 09:12:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3] tests/generic: test xfs log recovery metadata LSN
 ordering
Message-ID: <20160927131249.GA38187@bfoster.bfoster>
References: <1471265786-24970-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471265786-24970-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org

On Mon, Aug 15, 2016 at 08:56:26AM -0400, Brian Foster wrote:
> XFS had a bug that lead to a possible out-of-order log recovery
> situation (e.g., replay a stale modification from the log over more
> recent metadata in destination buffer). This resulted in false
> corruption reports during log recovery and thus mount failure.
> 
> This condition is caused by system crash or filesystem shutdown shortly
> after a successful log recovery. Add a test to run a combined workload,
> fs shutdown and log recovery loop known to reproduce the problem on
> affected kernels.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 

ping

> v3:
> - More generic test fixups.
> v2: http://marc.info/?l=linux-xfs&m=147126275528704&w=2
> - Use $KILLALL_PROG for killall command.
> - Convert to generic test.
> v1: http://marc.info/?l=linux-xfs&m=147100402211629&w=2
> 
>  tests/generic/999     | 89 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 92 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 0000000..57bb39c
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,89 @@
> +#! /bin/bash
> +# FS QA Test No. 999
> +#
> +# Test XFS log recovery ordering on v5 superblock filesystems. XFS had a problem
> +# where it would incorrectly replay older modifications from the log over more
> +# recent versions of metadata due to failure to update metadata LSNs during log
> +# recovery. This could result in false positive reports of corruption during log
> +# recovery and permanent mount failure.
> +#
> +# To test this situation, run frequent shutdowns immediately after log recovery.
> +# Ensure that log recovery does not recover stale modifications and cause
> +# spurious corruption reports and/or mount failures.
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
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +	_scratch_unmount > /dev/null 2>&1
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +
> +_require_scratch
> +_require_scratch_shutdown
> +_require_command "$KILLALL_PROG"
> +
> +rm -f $seqres.full
> +
> +echo "Silence is golden."
> +
> +_scratch_mkfs >> $seqres.full 2>&1
> +_scratch_mount || _fail "mount failed"
> +
> +for i in $(seq 1 50); do
> +	($FSSTRESS_PROG -d $SCRATCH_MNT -n 999999 -p 4 >> $seqres.full &) \
> +		> /dev/null 2>&1
> +
> +	# purposely include 0 second sleeps to test shutdown immediately after
> +	# recovery
> +	sleep $((RANDOM % 3))
> +	$XFS_IO_PROG -xc shutdown $SCRATCH_MNT
> +
> +	ps -e | grep fsstress > /dev/null 2>&1
> +	while [ $? -eq 0 ]; do
> +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +		wait > /dev/null 2>&1
> +		ps -e | grep fsstress > /dev/null 2>&1
> +	done
> +
> +	# quit if mount fails so we don't shutdown the host fs
> +	_scratch_cycle_mount || _fail "cycle mount failed"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 0000000..d254382
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden.
> diff --git a/tests/generic/group b/tests/generic/group
> index 4acae99..605a244 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -375,3 +375,4 @@
>  370 auto quick richacl
>  371 auto quick enospc prealloc
>  372 auto quick clone
> +999 auto log metadata
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
