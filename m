Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33912 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfGaQox (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 12:44:53 -0400
Date: Wed, 31 Jul 2019 09:44:19 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] xfs: test new v5 bulkstat commands
Message-ID: <20190731164419.GU1561054@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
 <156394161882.1850833.4351446431166375360.stgit@magnolia>
 <20190731114306.GC34040@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731114306.GC34040@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jul 31, 2019 at 07:43:07AM -0400, Brian Foster wrote:
> On Tue, Jul 23, 2019 at 09:13:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Check that the new v5 bulkstat commands do everything the old one do,
> > and then make sure the new functionality actually works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/xfs                 |    6 +
> >  src/Makefile               |    2 
> >  src/bulkstat_null_ocount.c |   61 +++++++++
> >  tests/xfs/085              |    2 
> >  tests/xfs/086              |    2 
> >  tests/xfs/087              |    2 
> >  tests/xfs/088              |    2 
> >  tests/xfs/089              |    2 
> >  tests/xfs/091              |    2 
> >  tests/xfs/093              |    2 
> >  tests/xfs/097              |    2 
> >  tests/xfs/130              |    2 
> >  tests/xfs/235              |    2 
> >  tests/xfs/271              |    2 
> >  tests/xfs/744              |  212 +++++++++++++++++++++++++++++++
> >  tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/745              |   44 +++++++
> >  tests/xfs/745.out          |    2 
> >  tests/xfs/group            |    2 
> >  19 files changed, 636 insertions(+), 12 deletions(-)
> >  create mode 100644 src/bulkstat_null_ocount.c
> >  create mode 100755 tests/xfs/744
> >  create mode 100644 tests/xfs/744.out
> >  create mode 100755 tests/xfs/745
> >  create mode 100644 tests/xfs/745.out
> > 
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 2b38e94b..1bce3c18 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -878,3 +878,9 @@ _force_xfsv4_mount_options()
> >  	fi
> >  	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
> >  }
> > +
> > +# Find AG count of mounted filesystem
> > +_xfs_mount_agcount()
> > +{
> > +	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> > +}
> 
> This and the associated changes to existing tests should probably be a
> separate patch.

Done.

> ...
> > diff --git a/tests/xfs/744 b/tests/xfs/744
> > new file mode 100755
> > index 00000000..ef605301
> > --- /dev/null
> > +++ b/tests/xfs/744
> > @@ -0,0 +1,212 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 744
> > +#
> > +# Use the xfs_io bulkstat utility to verify bulkstat finds all inodes in a
> > +# filesystem.  Test under various inode counts, inobt record layouts and
> > +# bulkstat batch sizes.  Test v1 and v5 ioctls explicitly, as well as the
> > +# ioctl version autodetection code in libfrog.
> > +#
> 
> Apparently I don't have xfs_io bulkstat support. Is that posted
> somewhere? At a glance the test looks mostly fine..

Hm... it's been hanging out in my xfsprogs dev branch for a while, maybe
I haven't sent it yet...?

In any case, it's here:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=bulkstat-v5

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
> > +bstat_versions()
> > +{
> > +	echo "default"
> > +	echo "v1 -v1"
> > +	if [ -n "$has_v5" ]; then
> > +		echo "v5 -v5"
> > +	else
> > +		echo "v5"
> > +	fi
> > +}
> > +
> > +# print the number of inodes counted by bulkstat
> > +bstat_count()
> > +{
> > +	local batchsize="$1"
> > +	local tag="$2"
> > +
> > +	bstat_versions | while read v_tag v_flag; do
> > +		echo "$tag($v_tag): passing \"$v_flag\" to bulkstat" >> $seqres.full
> > +		echo -n "bulkstat $tag($v_tag): "
> > +		$XFS_IO_PROG -c "bulkstat -n $batchsize $vflag" $SCRATCH_MNT | grep ino | wc -l
> 
> s/vflag/v_flag/ ?

Good catch!

> > +	done
> > +}
> > +
> > +# print the number of inodes counted by per-ag bulkstat
> > +bstat_perag_count()
> > +{
> > +	local batchsize="$1"
> > +	local tag="$2"
> > +
> > +	local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> > +
> > +	bstat_versions | while read v_tag v_flag; do
> > +		echo -n "bulkstat $tag($v_tag): "
> > +		seq 0 $((agcount - 1)) | while read ag; do
> > +			$XFS_IO_PROG -c "bulkstat -a $ag -n $batchsize $v_flag" $SCRATCH_MNT
> > +		done | grep ino | wc -l
> > +	done
> > +}
> > +
> > +# Sum the number of allocated inodes in each AG in a fs.
> > +inumbers_ag()
> > +{
> > +	local agcount="$1"
> > +	local batchsize="$2"
> > +	local mount="$3"
> > +	local v_flag="$4"
> > +
> > +	seq 0 $((agcount - 1)) | while read ag; do
> > +		$XFS_IO_PROG -c "inumbers -a $ag -n $batchsize $v_flag" $mount
> > +	done | grep alloccount | awk '{x += $3} END { print(x) }'
> > +}
> > +
> > +# Sum the number of allocated inodes in the whole fs all at once.
> > +inumbers_fs()
> > +{
> > +	local dir="$1"
> > +	local v_flag="$2"
> > +
> > +	$XFS_IO_PROG -c "inumbers $v_flag" "$dir" | grep alloccount | \
> > +		awk '{x += $3} END { print(x) }'
> > +}
> > +
> > +# print the number of inodes counted by inumbers
> > +inumbers_count()
> > +{
> > +	local expect="$1"
> > +
> > +	# There probably aren't more than 10 hidden inodes, right?
> > +	local tolerance=10
> > +
> > +	# Force all background inode cleanup
> 
> Comment took me a second to grok. This refers to unlinked inode cleanup,
> right?

Yes.  I think it's only needed to force deferred inode inactivation to
run... which means that we don't necessarily need it now, but it doesn't
hurt to have it.

> > +	_scratch_cycle_mount
> > +
> > +	bstat_versions | while read v_tag v_flag; do
> > +		echo -n "inumbers all($v_tag): "
> > +		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
> > +		_within_tolerance "inumbers" $nr $expect $tolerance -v
> > +
> > +		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> > +		for batchsize in 64 2 1; do
> 
> Perhaps we should stuff a value > than the per-record inode count in
> here as well.

I'm confused about this comment -- inumbers returns (cooked) inobt
records, not inode records themselves.  The 64>2>1 sequence here asks
inumbers to return 64 inobt records per call, then 2 per call, then 1.

Maybe this should be 71 or some other prime number...

> > +			echo -n "inumbers $batchsize($v_tag): "
> > +			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
> > +			_within_tolerance "inumbers" $nr $expect $tolerance -v
> > +		done
> > +	done
> > +}
> > +
> > +# compare the src/bstat output against the xfs_io bstat output
> 
> This compares actual inode numbers, right? If so, I'd point that out in
> the comment.

Ok.

> > +bstat_compare()
> > +{
> > +	bstat_versions | while read v_tag v_flag; do
> > +		diff -u <(./src/bstat $SCRATCH_MNT | grep ino | awk '{print $2}') \
> > +			<($XFS_IO_PROG -c "bulkstat $v_flag" $SCRATCH_MNT | grep ino | awk '{print $3}')
> > +	done
> > +}
> > +
> ...
> > diff --git a/tests/xfs/745 b/tests/xfs/745
> > new file mode 100755
> > index 00000000..6931d46b
> > --- /dev/null
> > +++ b/tests/xfs/745
> > @@ -0,0 +1,44 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 745
> > +#
> > +# Regression test for a long-standing bug in BULKSTAT and INUMBERS where
> > +# the kernel fails to write thew new @lastip value back to userspace if
> > +# @ocount is NULL.
> > +#
> 
> I think it would be helpful to reference the upstream fix here, which
> IIRC is commit f16fe3ecde62 ("xfs: bulkstat should copy lastip whenever
> userspace supplies one"). Otherwise this test looks fine to me.

Ok, will update.

--D

> Brian
> 
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
> > +    cd /
> > +    rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +_require_test_program "bulkstat_null_ocount"
> > +
> > +# real QA test starts here
> > +
> > +_supported_fs xfs
> > +_supported_os Linux
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Silence is golden."
> > +src/bulkstat_null_ocount $TEST_DIR
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/745.out b/tests/xfs/745.out
> > new file mode 100644
> > index 00000000..ce947de2
> > --- /dev/null
> > +++ b/tests/xfs/745.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 745
> > +Silence is golden.
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 270d82ff..ef0cf92c 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -506,3 +506,5 @@
> >  506 auto quick health
> >  507 clone
> >  508 auto quick quota
> > +744 auto ioctl quick
> > +745 auto ioctl quick
> > 
