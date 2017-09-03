Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38328 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753061AbdICRpX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 13:45:23 -0400
Date: Sun, 3 Sep 2017 10:45:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH] fstests: regression test for xfs leftover CoW
 extent error
Message-ID: <20170903174513.GI4073@magnolia>
References: <1504451271-29202-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504451271-29202-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 06:07:51PM +0300, Amir Goldstein wrote:
> The following error are reported after the test:
> 
> *** xfs_check output ***
> leftover CoW extent (0/2147483736) len 1
> block 0/2147483736 out of range
> blocks 0/2147483736..2147483736 claimed by block 0/6
> leftover CoW extent (0/2147483738) len 2
> blocks 0/2147483738..2147483739 out of range
> blocks 0/2147483738..2147483739 claimed by block 0/6
> leftover CoW extent (0/2147483741) len 3
> blocks 0/2147483741..2147483743 out of range
> blocks 0/2147483741..2147483743 claimed by block 0/6
> block 0/88 type unknown not expected
> block 0/90 type unknown not expected
> block 0/91 type unknown not expected
> block 0/93 type unknown not expected
> block 0/94 type unknown not expected
> block 0/95 type unknown not expected
> 
> *** xfs_repair -n output ***
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> leftover CoW extent (0/88) len 1
> leftover CoW extent (0/90) len 2
> leftover CoW extent (0/93) len 3
>         - found root inode chunk
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Christoph,
> 
> I started playing with crash tests for xfs reflink
> and created a variant of the crash test which clones
> files and runs fsx on the clones.
> 
> I quickly stumbled on an fsck error that is reproduced
> without any crash at all.
> 
> The sequence of operations (zero,collapse,insert,truncate)
> was recorded by fsx, I only bisected the minimal sequence
> to reproduce the error.
> 
> When you understand what went on, it would be better to
> provide less arbitrary values of offset;length and add
> commentary to this test before merging it.
> 
> Amir.
> 
> 
>  tests/generic/503     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/503.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 72 insertions(+)
>  create mode 100755 tests/generic/503
>  create mode 100644 tests/generic/503.out
> 
> diff --git a/tests/generic/503 b/tests/generic/503
> new file mode 100755
> index 0000000..ebda756
> --- /dev/null
> +++ b/tests/generic/503
> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# FS QA Test No. 503
> +#
> +# Regression test for xfs leftover CoW extents error
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (C) 2017 CTERA Networks. All Rights Reserved.
> +# Author: Amir Goldstein <amir73il@gmail.com>
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
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_reflink
> +_require_cp_reflink
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +$XFS_IO_PROG -f -c "pwrite 0 0x40000" \
> +	$SCRATCH_MNT/foo > /dev/null 2>&1
> +
> +cp --reflink $SCRATCH_MNT/foo $SCRATCH_MNT/bar

Write foo; reflink foo to bar...

> +$XFS_IO_PROG -f -c "fzero -k 0x169f 0x387c" \

...then buffered cow write zeroes to 2401 bytes at offset 5791;
buffered cow write zeroes to 3867 bytes at offset 16384;
unmap 2 blocks at offset 8192...

> +		-c "fcollapse 0x29000 0xd000" \

...collapse range (high enough offset that it shouldn't affect the cow)...

> +		-c "finsert 0 0x8000" \

...insert range at zero (which ought to shift up the cow fork extents
but I bet it doesn't)...

> +		-c "truncate 0x8000" \

...truncate all the stuff we wrote/reflinked/zeroed/collapsed.  This
kills off anything above 0x8000 in the cow fork, leaving an extent of 3
real blocks in the cow fork.  umount needs to free that real extent in
the cow fork but it doesn't do that (according to ftrace data it doesn't
seem to call xfs_reflink_cancel_cow_blocks at all?), so there are still
CoW staging extents sitting around in the refcount btree and that's why
repair gets mad.

Oh, right, because xfs_itruncate_extents clears the reflink flag if
di_nblocks == 0, which is not the right test because it's entirely
possible that there's still extents in the cow fork.  Granted in this
case there shouldn't have been extents in the cow fork but due to an
finsert bug, but the test in itruncate is incorrect nonetheless.

So basically there are two bugs here -- the fcollapse/finsert code needs
to shift the CoW fork extents down and up; and truncate cannot remove
the reflink flag from an inode unless the cow fork is empty.

The stupidest fix for the corruption I can come up with (time is very
limited here, this is totally untested) is:

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9207d61..ae3b18f 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1625,7 +1625,7 @@ xfs_itruncate_extents(
        /*
         * Clear the reflink flag if we truncated everything.
         */
-       if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
+       if (ip->i_d.di_nblocks == 0 && ip->i_cnextents == 0 && xfs_is_reflink_inode(ip)) {
                ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
                xfs_inode_clear_cowblocks_tag(ip);
        }

--D

> +	$SCRATCH_MNT/foo > /dev/null 2>&1
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/503.out b/tests/generic/503.out
> new file mode 100644
> index 0000000..6c1400a
> --- /dev/null
> +++ b/tests/generic/503.out
> @@ -0,0 +1,2 @@
> +QA output created by 503
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 4324775..7a9cd78 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -460,3 +460,4 @@
>  500 auto log replay
>  501 auto quick metadata
>  502 auto log replay clone
> +503 auto quick clone
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
