Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48896 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbeEUPzt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 May 2018 11:55:49 -0400
Date: Mon, 21 May 2018 08:55:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: test inode allocation state missmatch corruption
Message-ID: <20180521155530.GH4910@magnolia>
References: <20180521015857.7339-1-zlang@redhat.com>
 <20180521090411.GM29080@desktop.hz.ali.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521090411.GM29080@desktop.hz.ali.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, May 21, 2018 at 05:04:11PM +0800, Eryu Guan wrote:
> On Mon, May 21, 2018 at 09:58:57AM +0800, Zorro Lang wrote:
> > There's a situation where the directory structure and the inobt
> > thinks the inode is free, but the inode on disk thinks it is still
> > in use. XFS should detect it and prevent the kernel from oopsing
> > on lookup.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> 
> Looks fine to me overall, reviews from xfs list would be good.
> 
> (Add linux-xfs to cc list, and please add fs-specific list to cc when
> submitting fs-specific patches in future.)
> 
> > ---
> > 
> > Hi,
> > 
> > Re-send this case due to we can use it to test different code
> > paths, refer to:
> > https://marc.info/?l=fstests&m=152662117205960&w=2
> 
> Would be good to include some information on this, e.g. it's testing the
> same problem as in xfs/132, but by different code path.
> 
> And the fix is already in upstream, it'd be good to mention the fix in
> commit log and/or test description too.
> 
> > 
> > V2 did below changes:
> > 1) Fix Copyright
> > 2) Use 'convert' command of xfs_db to get agino from inode number.
> > 
> > V1 and related reply as below:
> > https://marc.info/?l=fstests&m=152229518811044&w=2
> > 
> > Thanks,
> > Zorro
> > 
> >  tests/xfs/999     | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out |   2 +
> >  tests/xfs/group   |   1 +
> >  3 files changed, 117 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> > 
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 00000000..be26420a
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,114 @@
> > +#! /bin/bash
> > +# FS QA Test No. 999
> > +#
> > +# Test a corruption when the directory structure and the inobt thinks the inode
> > +# is free, but the inode on disk thinks it is still in use.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_supported_os Linux
> > +_require_scratch_nocheck
> > +_require_no_xfs_bug_on_assert
> > +
> > +_filter_dmesg()
> 
> No need name local functions with leading underscore.
> 
> > +{
> > +	local warn1="Internal error xfs_trans_cancel.*fs/xfs/xfs_trans\.c.*"
> > +	local warn2="WARNING:.*fs/xfs/xfs_message\.c:.*assfail.*"
> > +
> > +	sed -e "s#$warn1#Intentional error in xfs_trans_cancel#" \
> > +	    -e "s#$warn2#Intentional warnings in assfail#"
> > +}
> > +
> > +# Use crc=0, due to this crash is only possible on v4 XFS or v5 XFS mounted
> > +# with the ikeep mount option. For all other V5 XFS, this problem cannot
> > +# occur because we don't read inodes we are allocating from disk - we simply
> > +# overwrite them with the new inode information.
> > +_scratch_mkfs_xfs -m crc=0 >> $seqres.full 2>&1
> 
> This depends on a recent fix from me for _scratch_mkfs_xfs_opts(),
> otherwise older mkfs.xfs that doesn't support metadata would fail the
> mkfs (or use _require_xfs_mkfs_crc as in xfs/132). I'll ping that patch
> for review.
> 
> Thanks,
> Eryu
> 
> > +blksz=$(_scratch_xfs_get_sb_field blocksize)
> > +agcount=$(_scratch_xfs_get_sb_field agcount)
> > +
> > +_scratch_mount
> > +# Create a directory for later allocation in same AG (AG 0, due to this's an
> > +# empty XFS for now)
> > +mkdir $SCRATCH_MNT/dir
> > +
> > +# Allocate 1 block for testfile
> > +$XFS_IO_PROG -fc 'pwrite 0 $blksz' -c fsync $SCRATCH_MNT/dir/testfile >> $seqres.full
> > +inum=`stat -c %i $SCRATCH_MNT/dir/testfile`
> > +_scratch_unmount
> > +
> > +# Find the AG which contains testfile
> > +agi=`_scratch_xfs_db -c "convert inode $inum agno" | sed -e 's/^.*(\([0-9]*\).*$/\1/g'`
> > +
> > +# Due to we only allocate 1 block for testfile, and this's the only one data
> > +# block we use. So we use single level inobt, So the ${agi}->root->recs[1]
> > +# should be the only one record points the chunk which contains testfile's
> > +# inode.
> > +# An exmaple of inode record is as below:
> > +#   recs[1] = [startino,freecount,free] 1:[1024,59,0xffffffffffffffe0]
> > +freecount=$(_scratch_xfs_get_metadata_field "recs[1].freecount" \
> > +					    "agi $agi" "addr root")
> > +fmask=$(_scratch_xfs_get_metadata_field "recs[1].free" "agi $agi" "addr root")
> > +
> > +# fmask shift right 1 bit, and freecount++, to mark testfile inode as free in
> > +# inobt. (But the inode itself isn't freed, it still has allocated block)
> > +freecount="$((freecount + 1))"
> > +fmask="$((fmask / 2))"
> > +_scratch_xfs_set_metadata_field "recs[1].freecount" "$freecount" \
> > +				"agi $agi" "addr root" >/dev/null
> > +_scratch_xfs_set_metadata_field "recs[1].free" "$fmask" \
> > +				"agi $agi" "addr root" >/dev/null
> > +
> > +# Mount again and create a new inode cover that inode we just 'freed' from inobt
> > +_scratch_mount
> > +$XFS_IO_PROG -fc 'pwrite 0 $blksz' -c fsync $SCRATCH_MNT/dir/newfile 2>&1 | \
> > +	grep -i "Structure needs cleaning" | _filter_scratch
> > +
> > +# filter a intentional internal errors
> > +_check_dmesg _filter_dmesg
> > +
> > +# success, all done
> > +status=0

Does this test leave the scratch fs mounted but shut down if the kernel
hasn't been patched?  The _require_scratch_nocheck means that the broken
fs doesn't get scraped off the system and subsequent tests can go all
wacky when operations on $SCRATCH_MNT error out...

--D

> > +exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > new file mode 100644
> > index 00000000..cb8d9e34
> > --- /dev/null
> > +++ b/tests/xfs/999.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 999
> > +SCRATCH_MNT/dir/newfile: Structure needs cleaning
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 32bf4f71..ec3cca62 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -442,3 +442,4 @@
> >  443 auto quick ioctl fsr
> >  444 auto quick
> >  445 auto quick filestreams
> > +999 auto quick
> > -- 
> > 2.14.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
