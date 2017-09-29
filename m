Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18583 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbdI2FSy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Sep 2017 01:18:54 -0400
Date: Thu, 28 Sep 2017 22:18:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: test increased overlong directory extent discard
 threshold
Message-ID: <20170929051848.GV5020@magnolia>
References: <20170927010348.GK5020@magnolia>
 <20170928085538.GU8034@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170928085538.GU8034@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Thu, Sep 28, 2017 at 04:55:38PM +0800, Eryu Guan wrote:
> On Tue, Sep 26, 2017 at 06:03:48PM -0700, Darrick J. Wong wrote:
> > As of 2007, metadump has an interesting "feature" where it discards
> > directory extents that are longer than 1000 (originally 20) blocks.
> > This ostensibly was to protect metadump from corrupt bmbt records, but
> > it also has the effect of omitting from the metadump valid long extents.
> > The end result is that we create incomplete metadumps, which is
> > exacerbated by the lack of warning unless -w is passed.
> > 
> > So now that we've fixed the default threshold to MAXEXTLEN, check that
> > the installed metadump no longer exhibits this behavior.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/707     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/707.out |    6 +++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 108 insertions(+)
> >  create mode 100755 tests/xfs/707
> >  create mode 100644 tests/xfs/707.out
> > 
> > diff --git a/tests/xfs/707 b/tests/xfs/707
> > new file mode 100755
> > index 0000000..f97d029
> > --- /dev/null
> > +++ b/tests/xfs/707
> > @@ -0,0 +1,101 @@
> > +#! /bin/bash
> > +# FS QA Test No. 707
> > +#
> > +# Ensure that metadump copies large directory extents
> > +#
> > +# Metadump helpfully discards directory (and xattr) extents that are
> > +# longer than 1000 blocks.  This is a little silly since a hardlink farm
> > +# can easily create such a monster.
> > +#
> > +# Now that we've upped metadump's default too-long-extent discard
> > +# threshold to 2^21 blocks, make sure we never do that again.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf "$tmp".* $metadump_file $metadump_img
> 
> 'rm -f' to be safe :)

Ok.

> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +_require_scratch
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs -b size=1k -n size=64k > "$seqres.full" 2>&1
> 
> Add some comments about the non-default mkfs options?

Will do.  The goal here is to try to trick the directory code into
allocating a huge extent by making directory blocks as large as
possible.

> > +_scratch_mount >> "$seqres.full" 2>&1
> > +
> > +metadump_file="$TEST_DIR/meta-$seq"
> > +metadump_img="$TEST_DIR/img-$seq"
> > +rm -rf $metadump_file $metadump_img
> 
> Same here, 'rm -f'
> 
> > +testdir="$SCRATCH_MNT/test-$seq"
> > +max_fname_len=255
> > +blksz=$(_get_block_size $SCRATCH_MNT)
> > +
> > +# Try to create a directory w/ extents
> > +blocks=1050
> > +names=$((blocks * (blksz / max_fname_len)))
> > +echo "Create huge dir"
> > +mkdir -p $testdir
> > +touch $SCRATCH_MNT/a
> > +seq 0 $names | while read f; do
> > +	name="$testdir/$(printf "%0${max_fname_len}d" $f)"
> > +	ln $SCRATCH_MNT/a $name
> > +done
> > +dir_inum=$(stat -c %i $testdir)
> > +
> > +echo "Check for > 1000 block extent?"
> > +_scratch_unmount
> > +check_for_long_extent() {
> > +	inum=$1
> > +
> > +	_scratch_xfs_db -x -c "inode $dir_inum" -c bmap | \
> > +		sed -e 's/^.*count \([0-9]*\) flag.*$/\1/g' | \
> > +		awk '{if ($1 > 1000) { printf("yes, %d\n", $1); } }'
> > +}
> > +extlen="$(check_for_long_extent $dir_inum)"
> > +echo "qualifying extent: $extlen blocks" >> $seqres.full
> > +test -n "$extlen" || _fail "could not create dir extent > 1000 blocks"
> 
> Is this really a failure? IMHO, _notrun makes more sense here.

We failed to set up the preconditions for the test, and therefore did
not run it. :)

(Will change it to notrun.)

--D

> 
> Thanks,
> Eryu
> 
> > +
> > +echo "Try to metadump"
> > +_scratch_metadump $metadump_file -w
> > +xfs_mdrestore $metadump_file $metadump_img
> > +
> > +echo "Check restored metadump image"
> > +$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/707.out b/tests/xfs/707.out
> > new file mode 100644
> > index 0000000..0d2a222
> > --- /dev/null
> > +++ b/tests/xfs/707.out
> > @@ -0,0 +1,6 @@
> > +QA output created by 707
> > +Format and mount
> > +Create huge dir
> > +Check for > 1000 block extent?
> > +Try to metadump
> > +Check restored metadump image
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 7353b9c..a70c884 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -432,3 +432,4 @@
> >  703 auto quick clone fsr
> >  704 auto quick clone
> >  705 auto quick clone fsr
> > +707 auto quick dir metadata
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
