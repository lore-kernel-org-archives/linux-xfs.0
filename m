Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752848AbeBGEHV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Feb 2018 23:07:21 -0500
Date: Wed, 7 Feb 2018 12:07:18 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] tests/xfs: rmapbt swapext block reservation overrun test
Message-ID: <20180207040718.GW18267@eguan.usersys.redhat.com>
References: <20180205174601.51574-1-bfoster@redhat.com>
 <20180206131032.62271-1-bfoster@redhat.com>
 <20180206173023.GL4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180206173023.GL4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Feb 06, 2018 at 09:30:23AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 06, 2018 at 08:10:32AM -0500, Brian Foster wrote:
> > The XFS rmapbt extent swap mechanism performs an extent by extent
> > swap to ensure the rmapbt is rectified with the appropriate extent
> > owner information after the operation. This implementation suffers
> > from a corner case that requires extra reservation if the swap
> > operation results in bouncing one of the associated inodes between
> > extent and btree formats. When this corner case occurs, it results
> > in a transaction block reservation overrun and possible corruption
> > of the free space accounting.
> > 
> > This regression test provides coverage for this corner case. It
> > creates two files with a large enough extent count to require btree
> > format, regardless of inode size, and performs a sequence of extent
> > swaps between them with a decreasing extent count until all extents
> > are removed from the file(s). This ensures that one of the swaps
> > covers the btree <-> extent fork format boundary case.
> > 
> > This test reproduces fs corruption on rmapbt enabled filesystems
> > running on kernels without the associated extent swap fix.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > This test reproduces one of the problems targeted to be fixed by the
> > following patch series:
> > 
> >   https://marc.info/?l=linux-xfs&m=151785278525201&w=2
> > 
> > Also note that this test depends on currently unmerged xfs_io
> > functionality. The associated functionality is posted for review here:
> > 
> >   https://marc.info/?l=linux-xfs&m=151792224511355&w=2
> > 
> > ... and so this test should not be merged until/unless that
> > functionality is reviewed. Thanks.
> > 
> > Brian
> > 
> >  tests/xfs/440     | 97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/440.out |  2 ++
> >  tests/xfs/group   |  1 +
> >  3 files changed, 100 insertions(+)
> >  create mode 100755 tests/xfs/440
> >  create mode 100644 tests/xfs/440.out
> > 
> > diff --git a/tests/xfs/440 b/tests/xfs/440
> > new file mode 100755
> > index 00000000..c7667e08
> > --- /dev/null
> > +++ b/tests/xfs/440
> > @@ -0,0 +1,97 @@
> > +#! /bin/bash
> > +# FS QA Test 440
> > +#
> > +# Regression test for the XFS rmapbt based extent swap algorithm. The extent
> > +# swap algorithm for rmapbt=1 filesystems unmaps/remaps individual extents to
> > +# rectify the rmapbt for each extent swapped between inodes. If one of the
> > +# inodes happens to straddle the extent <-> btree format boundary (which can
> > +# vary depending on inode size), the unmap/remap sequence can bounce the inodes
> > +# back and forth between formats many times during the swap. Since extent ->
> > +# btree format conversion requires a block allocation, this can consume more
> > +# blocks than expected, lead to block reservation overrun and free space
> > +# accounting inconsistency.
> 
> Yikes. :)
> 
> <slightly ot here>
> 
> TBH, I've long wondered a couple of things about the swapext code --
> since the rmap version of it can swap extents between any kind of file,
> does it still make sense to return -EINVAL if the donor file has more
> extents than the source file?  And do we have a use case for allowing
> extent swaps of parts of files?
> 
> <ok, back to the test>
> 
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
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "fpunch"
> > +_require_xfs_io_command "swapext"
> > +
> > +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> > +_scratch_mount || _fail "mount failed"
> 
> Before we encode too many _scratch_mount || _fail, can we get a decision
> from the maintainer about whether or not _scratch_mount should just
> _fail if the mount doesn't work, instead of each test having to
> open-code this on its own?
> 
> I see that 53 of the 1221 mentions of _scratch_mount already do _fail...

Sorry for not responding to the check _scratch_mount status issue early.
I'm fine with it overall, as more people are running into this problem
and get annoyed by the implicit failures. I just wanted to think more
about it and see what would be the better way to do this.

And Ted complained about not checking return status _scratch_mkfs and
similar functions a month ago, I think we can fix them all together.

Thanks,
Eryu
