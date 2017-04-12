Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35630 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752383AbdDLQzw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 12:55:52 -0400
Date: Wed, 12 Apr 2017 09:55:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] fstests/xfs: xfs_repair should junk empty attribute
 leaf blocks
Message-ID: <20170412165535.GN8502@birch.djwong.org>
References: <1492011577-13436-1-git-send-email-zlang@redhat.com>
 <20170412161434.GM8502@birch.djwong.org>
 <20170412162706.GC5081@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412162706.GC5081@dhcp12-143.nay.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Apr 13, 2017 at 12:27:07AM +0800, Zorro Lang wrote:
> On Wed, Apr 12, 2017 at 09:14:34AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 12, 2017 at 11:39:37PM +0800, Zorro Lang wrote:
> > > There was a bug during log replay, the attr/attr3 leaf verifier
> > > reported corruption when encountering a leaf attribute with a
> > > count of 0 in the header, as below:
> > > 
> > > Metadata corruption detected at xfs_attr3_leaf block 0x480988/0x1000
> > > 
> > > commit f714016 from xfsprogs has fixed this bug. This test case
> > > will emulate this corruption by xfs_db and use xfs_repair to fix
> > > it.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > ---
> > > 
> > > Hi,
> > > 
> > > V2 did below changes:
> > > 1) remove the requirement for xfs_db's write and addr commands
> > > 2) check if xfs_db support write -d option
> > > 3) turn to get filesystem block size from _filter_mkfs output
> > > 4) add more comments
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > >  tests/xfs/288     | 110 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/288.out |   2 +
> > >  tests/xfs/group   |   1 +
> > >  3 files changed, 113 insertions(+)
> > >  create mode 100755 tests/xfs/288
> > >  create mode 100644 tests/xfs/288.out
> > > 
> > > diff --git a/tests/xfs/288 b/tests/xfs/288
> > > new file mode 100755
> > > index 0000000..81e7b50
> > > --- /dev/null
> > > +++ b/tests/xfs/288
> > > @@ -0,0 +1,110 @@
> > > +#! /bin/bash
> > > +# FS QA Test 288
> > > +#
> > > +# When an attribute leaf block count is 0, xfs_repair should junk
> > > +# that leaf directly (as xfsprogs commit f714016).
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#-----------------------------------------------------------------------
> > > +#
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/attr
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# V4 XFS attr type is 'attr'
> > > +write_cmd="write"
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs xfs
> > > +_supported_os Linux
> > > +_require_scratch
> > > +_require_attrs
> > > +
> > > +_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
> > > +. $tmp.mkfs
> > > +
> > > +# If test on XFS with CRC enabled, after change attr's hdr.count we need
> > > +# to recalculate crc by use write -d option
> > > +if [ $_fs_has_crcs -eq 1 ]; then
> > > +	# check if xfs_db support write -d option
> > > +	_scratch_xfs_db -x -c "sb" -c "write -d" 2>&1 | \
> > > +		grep -q "invalid option"
> > > +	if [ $? -eq 0 ];then
> > > +		_notrun "xfs_db doesn't support write -d option"
> > > +	fi
> > > +	# This's a trick to check if xfs_db support recalculating
> > > +	# CRCs of attr3
> > > +	_scratch_xfs_db -x -c "daddr 0" \
> > > +			   -c "type attr3" \
> > > +			   -c "write -d" 2>/dev/null | \
> > > +		grep -q "Cannot recalculate CRCs on this type of object"
> > > +	if [ $? -eq 0 ];then
> > > +		_notrun "xfs_db can't recalculate CRCs of attr3"
> > > +	fi
> > > +	# V5 XFS attr type is 'attr3'
> > > +	write_cmd="write -d"
> > > +fi
> > > +
> > > +_scratch_mount
> > > +
> > > +touch $SCRATCH_MNT/$seq.attrfile
> > > +inum=$(stat -c '%i' $SCRATCH_MNT/$seq.attrfile)
> > > +
> > > +# To get an attr block leaf, we need to extend attr format to extent
> > > +# format at least, and the max inode size is half of filesystem
> > > +# block size, so write half of block size attr to make sure attr
> > > +# out of local format.
> > > +maxisize=$((dbsize/2))
> > > +$SETFATTR_PROG -n "user.testattr${seq}" \
> > > +	       -v `python -c "print ($maxisize * 'a')"` \
> > 
> > Need to check for the existence of python, or use xfs_io to write
> > $maxisize bytes to a file and backtick-cat it into the command line.
> 
> As you and Eric all don't like this 'python' way, I'll change it :)
> 
> > 
> > > +	       $SCRATCH_MNT/$seq.attrfile
> > > +
> > > +_scratch_unmount
> > > +# manually corrupt the XFS, by set the header count of attr to 0
> > > +_scratch_xfs_db -x -c "inode $inum" \
> > > +		   -c "addr a.bmx[0].startblock" \
> > 
> > "ablock 0" ?
> 
> Anything weird ?

Well... if the attr fork should somehow be in btree format then 'ablock 0'
will handle it just fine, whereas directly reading the extents-format
extent array will break.

--D

> > 
> > > +		   -c "$write_cmd hdr.count 0" >> $seqres.full
> > > +
> > 
> > Uh... we need an xfs_repair -n run here to validate that repair actually
> > finds a broken xattr block.  Only then should we fix the fs.  Remember
> > that xfs_repair only tells us if it thinks the fs is still broken.
> 
> Yes, I'll change it.
> 
> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > +# This repair should junk above leaf attribute and fix this XFS, then
> > > +# SCRATCH_DEV shouldn't be corrupted after this case done.
> > > +_repair_scratch_fs >> $seqres.full
> > > +
> > > +echo "Silence is golden"
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/288.out b/tests/xfs/288.out
> > > new file mode 100644
> > > index 0000000..2958a5c
> > > --- /dev/null
> > > +++ b/tests/xfs/288.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 288
> > > +Silence is golden
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index 75769f9..f27a7b6 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -285,6 +285,7 @@
> > >  285 dangerous_fuzzers dangerous_scrub
> > >  286 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > >  287 auto dump quota quick
> > > +288 auto quick repair fuzzers
> > >  290 auto rw prealloc quick ioctl zero
> > >  291 auto repair
> > >  292 auto mkfs quick
> > > -- 
> > > 2.7.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
