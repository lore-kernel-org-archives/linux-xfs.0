Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17603 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdJLT57 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 15:57:59 -0400
Date: Thu, 12 Oct 2017 12:57:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] tests/xfs: test for NULL xattr buffer problem during
 unlink
Message-ID: <20171012195754.GG7122@magnolia>
References: <20171012113627.39452-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012113627.39452-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Oct 12, 2017 at 07:36:27AM -0400, Brian Foster wrote:
> XFS had a bug that resulted in an unexpected NULL buffer during
> unlink of an inode with a multi-level attr fork tree. This occurred
> due to a stale reference to content in a released/reclaimed buffer.
> 
> Use the XFS buffer LRU reference count error injection tag to
> recreate the conditions for the bug. Create a file with a
> multi-level attr fork tree and then unlink it with buffer caching
> disabled.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> Note that this test depends on a pending[1] XFS error injection tag.
> 
> Brian
> 
> [1] https://marc.info/?l=linux-xfs&m=150765408521029&w=2
> 
>  tests/xfs/999     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/999.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 90 insertions(+)
>  create mode 100755 tests/xfs/999
>  create mode 100644 tests/xfs/999.out
> 
> diff --git a/tests/xfs/999 b/tests/xfs/999
> new file mode 100755
> index 0000000..261b83f
> --- /dev/null
> +++ b/tests/xfs/999
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# FS QA Test 999
> +#
> +# Regression test for an XFS NULL xattr buffer problem during unlink. XFS had a
> +# bug where the attr fork walk during file removal could go off the rails due to
> +# a stale reference to content of a released buffer. Memory pressure could cause
> +# this reference to point to free or reused memory and cause subsequent
> +# attribute fork lookups to fail, return a NULL buffer and possibly crash.
> +#
> +# This test emulates this behavior using an error injection knob to explicitly
> +# disable buffer LRU caching. This forces the attr walk to execute under
> +# conditions where each buffer is immediately freed on release.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
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
> +. ./common/attr
> +. ./common/inject
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_xfs_io_error_injection buf_lru_ref
> +_require_scratch
> +_require_attrs
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount || _fail "mount failure"
> +
> +file=$SCRATCH_MNT/testfile
> +
> +# create a bunch of xattrs to form a multi-level attr tree
> +touch $file
> +for i in $(seq 0 499); do
> +	$SETFATTR_PROG -n trusted.user.$i -v 0 $file
> +done
> +
> +# cycle the mount to clear any buffer references
> +_scratch_cycle_mount || _fail "cycle mount failure"
> +
> +# disable the lru cache and unlink the file
> +_scratch_inject_error buf_lru_ref 1
> +rm -f $file
> +_scratch_inject_error buf_lru_ref 0
> +
> +echo Silence is golden
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> new file mode 100644
> index 0000000..3b276ca
> --- /dev/null
> +++ b/tests/xfs/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 25bb8b3..f0c15f7 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -430,3 +430,4 @@
>  430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>  431 auto quick dangerous
>  432 auto quick dir metadata
> +999 auto quick attr
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
