Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40961 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933124AbcKWT1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 14:27:17 -0500
Date: Wed, 23 Nov 2016 11:27:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] ocfs2: test reflinking to inline data files
Message-ID: <20161123192710.GG23680@birch.djwong.org>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
 <147986706651.27133.4210661621329152871.stgit@birch.djwong.org>
 <20161123163448.GH12442@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161123163448.GH12442@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 24, 2016 at 12:34:48AM +0800, Eryu Guan wrote:
> On Tue, Nov 22, 2016 at 06:11:06PM -0800, Darrick J. Wong wrote:
> > Make sure that we can handle reflinking from and to inline-data files.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/ocfs2/001     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/ocfs2/001.out |   14 ++++++++
> >  tests/ocfs2/group   |    1 +
> >  3 files changed, 103 insertions(+)
> >  create mode 100755 tests/ocfs2/001
> >  create mode 100644 tests/ocfs2/001.out
> >  create mode 100644 tests/ocfs2/group
> > 
> > 
> > diff --git a/tests/ocfs2/001 b/tests/ocfs2/001
> > new file mode 100755
> > index 0000000..973682d
> > --- /dev/null
> > +++ b/tests/ocfs2/001
> > @@ -0,0 +1,88 @@
> > +#! /bin/bash
> > +# FS QA Test No. 001
> > +#
> > +# Ensure that reflink works correctly with inline-data files.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs ocfs2
> > +_require_scratch_reflink
> 
> I'm a bit confused on this. I noticed that xfs_io reflink uses
> clone_range ioctl to do the actual work, but seems that ocfs2 doesn't
> have that method defined. So I got _notrun when running ocfs2/001

Yes, you need the patch series I sent to fsdevel/ocfs2-devel connecting
ocfs2 to the new vfs interfaces.  This isn't intended to test the old
(~2009 era) reflink ioctl at all.

> bootp-73-5-234:~/xfstests # ./check -s ocfs2_reflink ocfs2/001
> SECTION       -- ocfs2_reflink
> RECREATING    -- ocfs2 on /dev/sda3
> FSTYP         -- ocfs2
> PLATFORM      -- Linux/x86_64 bootp-73-5-234 4.8.9-1-default
> MKFS_OPTIONS  -- --fs-features=local,refcount /dev/sda5
> MOUNT_OPTIONS -- /dev/sda5 /mnt/testarea/scratch
> 
> ocfs2/001        [not run] Reflink not supported by scratch filesystem type: ocfs2
> 
> I also tried the djwong-devel branch of your xfsprogs tree and got the
> same result. Did I miss anything?

Here's the ocfs2 patches as a branch:
https://github.com/djwong/linux/tree/ocfs2-vfs-reflink-3

No changes to xfsprogs are necessary for ocfs2 support.

> > +_require_cp_reflink
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > $seqres.full 2>&1
> > +tunefs.ocfs2 --query '%H' $SCRATCH_DEV | grep -q 'inline-data' || \
> > +	_notrun "Inline data is not supported."
> 
> Test still passes even if ocfs2 has no inline-data feature enabled,
> right? Then I think we can skip this check, just let the user specify
> the test configuration and decide what features are tested.

I should've mentioned, this test exercises some bugs I found in ocfs2
w.r.t.  reflinking into and out of inline-data files.  In the ideal
world mkfs.ocfs2 would support multiple --fs-features= arguments so I
could just do:

_scratch_mkfs --fs-features=inline-data

but it doesn't, so I don't have a good way to forcibly enable
inline-data.  IIRC reflinking into and out of small files is already
tested by one of the generic tests; this one is designed specifically to
pound on a corner case that I missed in the first spin of the patch.

Though now that I think about it, mkfs.ocfs2 sets the feature flags
based on the last instance of --fs-features, so I actually /can/ use
what I proposed above so long as I turn on all the features I need.
That seems appropriate for a test of a specific regression, so I'll do
that.

> And further, if we skip this check, then this test has nothing ocfs2
> specific, it could be a generic test.
> 
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +testdir=$SCRATCH_MNT/test-$seq
> > +mkdir $testdir
> > +
> > +sz=65536
> > +echo "Create the original files"
> > +$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
> > +echo x > $testdir/file2
> > +echo x > $testdir/file3
> > +echo y > $testdir/file4
> > +$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file5 >> $seqres.full
> > +echo a > $testdir/file6
> > +_scratch_cycle_mount
> > +
> > +echo "reflink into the start of file2"
> > +_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
> > +
> > +echo "reflink past the stuff in file3"
> > +_reflink_range $testdir/file1 0 $testdir/file3 $sz $sz >> $seqres.full
> > +
> > +echo "reflink an inline-data file to a regular one"
> > +_cp_reflink $testdir/file4 $testdir/file5 >> $seqres.full
> > +
> > +echo "reflink an inline-data file to another inline-data file"
> > +_cp_reflink $testdir/file4 $testdir/file6 >> $seqres.full
> > +
> > +echo "Verify the whole mess"
> > +_scratch_cycle_mount
> > +md5sum $testdir/file* | _filter_scratch
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/ocfs2/001.out b/tests/ocfs2/001.out
> > new file mode 100644
> > index 0000000..99fa43a
> > --- /dev/null
> > +++ b/tests/ocfs2/001.out
> > @@ -0,0 +1,14 @@
> > +QA output created by 001
> > +Format and mount
> > +Create the original files
> > +reflink into the start of file2
> > +reflink past the stuff in file3
> > +reflink an inline-data file to a regular one
> > +reflink an inline-data file to another inline-data file
> > +Verify the whole mess
> > +2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-001/file1
> > +2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-001/file2
> > +4e68a2e24b6b0f386ab39d01d902293d  SCRATCH_MNT/test-001/file3
> > +009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file4
> > +009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file5
> > +009520053b00386d1173f3988c55d192  SCRATCH_MNT/test-001/file6
> > diff --git a/tests/ocfs2/group b/tests/ocfs2/group
> > new file mode 100644
> > index 0000000..28e6807
> > --- /dev/null
> > +++ b/tests/ocfs2/group
> > @@ -0,0 +1 @@
> > +001 auto quick clone
> 
> A tests/ocfs2/Makefile is needed to do the tests installation work, if
> we decide to add new ocfs2 specific tests.

Ok.

--D
> 
> Thanks,
> Eryu
