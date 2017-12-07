Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752662AbdLGKg7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Dec 2017 05:36:59 -0500
Date: Thu, 7 Dec 2017 18:36:57 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [fstests PATCH v5 2/2] generic: add test for DAX MAP_SYNC support
Message-ID: <20171207103657.GF2749@eguan.usersys.redhat.com>
References: <20171206003744.28587-1-ross.zwisler@linux.intel.com>
 <20171206003744.28587-3-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171206003744.28587-3-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>, Amir Goldstein <amir73il@gmail.com>

On Tue, Dec 05, 2017 at 05:37:44PM -0700, Ross Zwisler wrote:
> This test creates a file and writes to it via an mmap(), but never syncs
> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
> 
> If MAP_SYNC is working the dm-log-writes replay will show the test file
> with 1 MiB of on-media block allocations.  This is because each allocating
> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> (which you can test by removing the "-S" flag to xfs_io mmap) the file
> will be smaller or missing entirely.
> 
> Note that dm-log-writes doesn't track the data that we write via the
> mmap(), so we can't do any data integrity checking.  We can only verify
> that the metadata writes for the page faults happened.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  common/dmlogwrites    | 20 +++++++++++++
>  tests/generic/999     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  3 ++
>  tests/generic/group   |  1 +
>  4 files changed, 106 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
> 
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 05829dbc..2b697bec 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -28,6 +28,26 @@ _require_log_writes()
>  	_require_test_program "log-writes/replay-log"
>  }
>  
> +_require_log_writes_dax()
> +{
> +	[ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
> +		_notrun "This test requires a valid \$LOGWRITES_DEV"
> +
> +	_require_dm_target log-writes
> +	_require_test_program "log-writes/replay-log"
> +
> +	_scratch_unmount
> +	_log_writes_init
> +	_log_writes_mkfs > /dev/null 2>&1
> +	_log_writes_mount -o dax
> +	# Check options to be sure. XFS ignores dax option
> +	# and goes on if dev underneath does not support dax.
> +	_fs_options $LOGWRITES_DMDEV | grep -qw "dax" || \
> +		_notrun "$LOGWRITES_DMDEV $FSTYP does not support -o dax"
> +	_log_writes_unmount
> +	_log_writes_remove
> +}

Now we have two _require rules to test log_writes dm target:
_require_log_writes 	# _notrun explicitly when MOUNT_OPTIONS contains dax
_require_log_writes_dax	# _notrun if log-writes target doesn't support dax

I think we can merge the two into one, i.e. extend _require_log_writes
to check dax support status only when
- MOUNT_OPTIONS contains dax, or
- dax is given as a param explicitly, e.g. _require_log_writes dax

So old kernels that don't support dax log-writes still _notrun, and new
kernels that have dax log-writes support could run all log-writes tests,
like generic/455 and generic/457, in dax environment.

(I did a quick test with generic/45[57] on v4.15-rc2 kernel, 455 always
fails due to md5sum mismatch, not sure where the problem is yet; 457 is
_notrun, perhaps due to there's no dax support on reflink XFS.)

> +
>  _log_writes_init()
>  {
>  	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..ca5772da
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test No. 999
> +#
> +# Use dm-log-writes to verify that MAP_SYNC actually syncs metadata during
> +# page faults.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Intel Corporation.  All Rights Reserved.
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	_log_writes_cleanup
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmlogwrites
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux

Need _require_scratch before _require_log_writes

> +_require_log_writes_dax
> +_require_xfs_io_command "log_writes"

Also need to check "-S" option of mmap xfs_io command.

> +
> +_log_writes_init
> +_log_writes_mkfs >> $seqres.full 2>&1
> +_log_writes_mount -o dax
> +
> +LEN=$((1024 * 1024)) # 1 MiB
> +
> +xfs_io -t -c "truncate $LEN" -c "mmap -S 0 $LEN" -c "mwrite 0 $LEN" \
> +	-c "log_writes -d $LOGWRITES_NAME -m preunmap" \
> +	-f $SCRATCH_MNT/test

$XFS_IO_PROG

> +
> +# Unmount the scratch dir and tear down the log writes target
> +_log_writes_unmount
> +_log_writes_remove
> +_check_scratch_fs
> +
> +# destroy previous filesystem so we can be sure our rebuild works
> +_scratch_mkfs >> $seqres.full 2>&1
> +
> +# check pre-unmap state
> +_log_writes_replay_log preunmap
> +_scratch_mount
> +
> +# We should see $SCRATCH_MNT/test as having 1 MiB in block allocations
> +du -sh $SCRATCH_MNT/test | _filter_scratch | _filter_spaces
> +
> +_scratch_unmount
> +_check_scratch_fs

No need to umount & check scratch fs, 'check' will do it after test, as
long as we called _require_scratch

> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..c7b8f8a2
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,3 @@
> +QA output created by 999
> +1.0M SCRATCH_MNT/test
> +Silence is golden

Yeah, as Amir mentioned, test is not silence :)

Thanks,
Eryu

> diff --git a/tests/generic/group b/tests/generic/group
> index 6c3bb03a..ae88aa03 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -472,3 +472,4 @@
>  467 auto quick exportfs
>  468 shutdown auto quick metadata
>  469 auto quick
> +999 auto quick dax
> -- 
> 2.14.3
> 
