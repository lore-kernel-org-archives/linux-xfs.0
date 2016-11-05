Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752921AbcKEJkx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 5 Nov 2016 05:40:53 -0400
Date: Sat, 5 Nov 2016 17:40:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: testcase for kernelspace xfs_fsr extent handling
 flaw
Message-ID: <20161105094050.GC27776@eguan.usersys.redhat.com>
References: <bf5d8f48-76d6-9859-cd15-bd49d5dcf62e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf5d8f48-76d6-9859-cd15-bd49d5dcf62e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs@vger.kernel.org

[fixed linux-xfs list address on reply]

On Fri, Nov 04, 2016 at 09:00:09PM -0500, Eric Sandeen wrote:
> This is a testcase for a bug which goes way back; googling
> "xfs_trans_log_inode NULL pointer dereference" yields sporadic
> reports over several years.
> 
> The test sets up several two-extent files with speculative
> preallocation on them, and then runs xfs_fsr.  The kernelside
> code ignores the preallocation, and therefore sets up the
> temporary inode incorrectly after the inode fork swap.
> 
> It is a "dangerous" test because the extent mishandling on
> the temporary inode causes a null pointer dereference and
> oops when the inode's i_itemp pointer gets overwritten
> and we blow up in logging code that tries to use it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Tested with 4.9-rc3 kernel and saw NULL pointer dereference as expected.
And test passed without problem after applying "xfs: fix up
xfs_swap_extent_forks inline extent handling".

Just some tiny issues inline:

> ---
> 
> diff --git a/tests/xfs/118 b/tests/xfs/118
> new file mode 100755
> index 0000000..d2c9080
> --- /dev/null
> +++ b/tests/xfs/118
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FS QA Test 118
> +#
> +# Test xfs_fsr's handling of 2-extent files with preallocation
> +#
> +# An error in xfs_swap_extent_forks() incorrectly set up the
> +# temporary inode's if_extents pointer to inline, leading to
> +# in-memory corruption when the temporary inode was released 

Trailing whitespace here

> +# and torn down; i_itemp and d_ops got overwritten with zeros,
> +# which led to an oops in xfs_trans_log_inode down the fput path.
> +#
> +# Fixed upstream by proper nextents counting using 

And here :)

> +# ip->i_df.if_bytes not ip->i_d.di_nextents in xfs_swap_extent_forks
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat, inc.  All Rights Reserved.
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
> +_supported_fs xfs
> +_supported_os IRIX Linux
> +
> +_require_scratch
> +_require_command "$XFS_FSR_PROG" "xfs_fsr"
> +
> +# 50M
> +_scratch_mkfs_sized $((50 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mount
> +
> +echo "Silence is golden"
> +
> +# Fragment freespace
> +# The aim is to create a fragmented two-extent file *with* prealloc
> +# so make the free holes big enough that a 2-extent file will have
> +# preallocation added.  Let's say... 64k free chunks.
> +
> +$XFS_IO_PROG -fs -c "falloc 0 40000k" $SCRATCH_MNT/fill >> $seqres.full 2>&1
> +sync
> +
> +dd if=/dev/zero of=$SCRATCH_MNT/remainder oflag=direct > /dev/null 2>&1
> +
> +# Free up a bunch of 64k chunks
> +for i in `seq 0 68 40000`; do
> +	$XFS_IO_PROG -fs -c "unresvsp ${i}k 64k" $SCRATCH_MNT/fill
> +done
> +
> +# Create 2-extent files w/ preallocation (via extending writes)
> +for I in `seq 1 64`; do
> +	$XFS_IO_PROG -f -c "pwrite 0 64k" $SCRATCH_MNT/newfile-$I \
> +						 >> $seqres.full 2>&1
> +	$XFS_IO_PROG -f -c "pwrite 64k 64k" $SCRATCH_MNT/newfile-$I \
> +						>> $seqres.full 2>&1
> +done
> +# sync to get extents on disk so fsr sees them
> +sync
> +
> +# Free up some space for defragmentation temp file
> +rm -f $SCRATCH_MNT/fill
> +
> +$XFS_FSR_PROG -vd $SCRATCH_MNT/newfile* >> $seqres.full 2>&1
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/118.out b/tests/xfs/118.out
> new file mode 100644
> index 0000000..3daed86
> --- /dev/null
> +++ b/tests/xfs/118.out
> @@ -0,0 +1,2 @@
> +QA output created by 118
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 3296eb9..0a7a0a8 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -115,6 +115,7 @@
>  115 parent attr
>  116 quota auto quick
>  117 fuzzers
> +118 growfs dangerous
       ^^^^^^ should be "fsr" I think.

As this test crashes current upstream kernel, I'm going to let the
kenrel fixes go upstream first, then merge this patch, so it won't break
normal upstream kernel tests by crashing the test hosts.

Then 118 could be in 'auto' and 'quick' group. I can fix all the minor
issues at commit time.

Thanks,
Eryu

>  119 log v2log auto freeze dangerous
>  120 fuzzers
>  121 log auto quick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
