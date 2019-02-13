Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35090 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729502AbfBMQVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 11:21:06 -0500
Date: Wed, 13 Feb 2019 08:20:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] generic: check the behavior of programs opening a
 lot of O_TMPFILE files
Message-ID: <20190213162056.GD32253@magnolia>
References: <154993786231.2062.8490515215533507881.stgit@magnolia>
 <154993787478.2062.17047634303195751186.stgit@magnolia>
 <20190212140436.GE35803@bfoster>
 <20190213045119.GB32253@magnolia>
 <20190213154403.GC42812@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213154403.GC42812@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Feb 13, 2019 at 10:44:04AM -0500, Brian Foster wrote:
> On Tue, Feb 12, 2019 at 08:51:19PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 12, 2019 at 09:04:36AM -0500, Brian Foster wrote:
> > > On Mon, Feb 11, 2019 at 06:17:54PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Create a test (+ helper program) that opens as many unlinked files as it
> > > > possibly can on the scratch filesystem, then closes all the files at
> > > > once to stress-test unlinked file cleanup.  Add an xfs-specific test to
> > > > make sure that the fallback code doesn't bitrot.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  src/Makefile          |    2 -
> > > >  src/tmpfile.c         |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/generic/710     |   65 +++++++++++++++++++++++++
> > > >  tests/generic/710.out |    2 +
> > > >  tests/generic/711     |   73 ++++++++++++++++++++++++++++
> > > >  tests/generic/711.out |    2 +
> > > >  tests/generic/group   |    2 +
> > > >  tests/xfs/736         |   71 +++++++++++++++++++++++++++
> > > >  tests/xfs/736.out     |    2 +
> > > >  tests/xfs/737         |   79 ++++++++++++++++++++++++++++++
> > > >  tests/xfs/737.out     |    2 +
> > > >  tests/xfs/group       |    2 +
> > > >  12 files changed, 428 insertions(+), 1 deletion(-)
> > > >  create mode 100644 src/tmpfile.c
> > > >  create mode 100755 tests/generic/710
> > > >  create mode 100644 tests/generic/710.out
> > > >  create mode 100755 tests/generic/711
> > > >  create mode 100644 tests/generic/711.out
> > > >  create mode 100755 tests/xfs/736
> > > >  create mode 100644 tests/xfs/736.out
> > > >  create mode 100755 tests/xfs/737
> > > >  create mode 100644 tests/xfs/737.out
> > > > 
> > > > 
> ...
> > > > diff --git a/tests/generic/710 b/tests/generic/710
> > > > new file mode 100755
> > > > index 00000000..18aa9d34
> > > > --- /dev/null
> > > > +++ b/tests/generic/710
> > > > @@ -0,0 +1,65 @@
> ...
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs generic
> > > > +_supported_os Linux
> > > > +_require_scratch
> > > > +
> > > > +rm -f $seqres.full
> > > > +_scratch_mkfs >> $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
> > > > +# so that this test doesn't take forever or OOM the box
> > > > +max_files=$((50000 * LOAD_FACTOR))
> > > > +max_allowable_files=$(cat /proc/sys/fs/file-max)
> > > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > 
> > > I see the following from the above line when I run this test:
> > > 
> > > +./tests/generic/710: line 46: test: 18446744073709551615: integer expression expected
> > 
> > Weird... it's supposed to be set based on the amount of RAM you have.
> > 
> 
> Strange indeed. I added some tracepoints that show it's initialized to
> something reasonable on boot. I added another to determine what might be
> changing it to -1:
> 
>           <idle>-0     [000] ...1     0.630877: files_maxfiles_init: 386: nr_pages 996312 nr_free_pages 994058 memreserve 3381
>           <idle>-0     [000] ...1     0.630879: files_maxfiles_init: 392: memreserve 3381 n 397172 NR_FILE 8192 max_files 397172
>          systemd-1     [002] ....     2.732128: proc_filemax: 2879: max_files 18446744073709551615
>          systemd-1     [000] ....     9.303595: proc_filemax: 2879: max_files 18446744073709551615
> 
> So systemd is changing it for some reason. *shrug* not sure it really
> matters that much, but it might be worth massaging the input to handle
> the max value somehow or another.

Yeah, I'll change it to be more robust.  Do you have a setting in
/etc/sysctl* or is this some weird new systemd thing?

(FWIW systemd 237 on Ubuntu 18.04 doesn't seem to touch file-max)

--D

> Brian
> 
> > > > +ulimit -n $max_files
> > > > +
> > > > +# Open a lot of unlinked files
> > > > +echo create >> $seqres.full
> > > > +program=$PWD/src/tmpfile
> > > > +(cd $SCRATCH_MNT ; $program >> $seqres.full)
> > > > +
> > > > +# Unmount to prove that we can clean it all
> > > > +echo umount >> $seqres.full
> > > > +before=$(date +%s)
> > > > +_scratch_unmount
> > > > +after=$(date +%s)
> > > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > > +
> > > > +# Mount so that we can run the usual checks
> > > > +echo silence is golden
> > > > +_scratch_mount
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/generic/710.out b/tests/generic/710.out
> > > > new file mode 100644
> > > > index 00000000..e0a55170
> > > > --- /dev/null
> > > > +++ b/tests/generic/710.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 710
> > > > +silence is golden
> > > > diff --git a/tests/generic/711 b/tests/generic/711
> > > > new file mode 100755
> > > > index 00000000..11d76218
> > > > --- /dev/null
> > > > +++ b/tests/generic/711
> > > > @@ -0,0 +1,73 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0+
> > > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 711
> > > > +#
> > > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > > +# applies to most other filesystems.
> > > > +#
> > > > +# Use every CPU possible to stress the filesystem.
> > > > +#
> > > > +seq=`basename $0`
> > > > +seqres=$RESULT_DIR/$seq
> > > > +echo "QA output created by $seq"
> > > > +tmp=/tmp/$$
> > > > +status=1	# failure is the default!
> > > > +testfile=$TEST_DIR/$seq.txt
> > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -f $tmp.*
> > > > +}
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/attr
> > > > +. ./common/filter
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs generic
> > > > +_supported_os Linux
> > > > +_require_scratch
> > > > +
> > > > +rm -f $seqres.full
> > > > +_scratch_mkfs >> $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Try to load up all the CPUs, two threads per CPU.
> > > > +nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
> > > > +
> > > > +# Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
> > > > +# so that this test doesn't take forever or OOM the box
> > > > +max_files=$((50000 * LOAD_FACTOR))
> > > > +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / nr_cpus ))
> > > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > > +ulimit -n $max_files
> > > > +
> > > > +# Open a lot of unlinked files
> > > > +echo create >> $seqres.full
> > > > +program=$PWD/src/tmpfile
> > > > +for i in $(seq 1 $nr_cpus); do
> > > > +	(mkdir $SCRATCH_MNT/$i ; cd $SCRATCH_MNT/$i ; $program >> $seqres.full) &
> > > > +done
> > > 
> > > Doesn't this make the first test kind of a subset of this one (where
> > > nr_cpus == 1)? If so, could we just do a couple iterations with
> > > different nr_cpus values?
> > 
> > I think it's fine only to have the multithreaded version, that should
> > stress the AGs well enough.
> > 
> > > I'm wondering if we should have a log recovery test as well, btw.
> > 
> > Yes.  I'll turn g/710 and x/736 into the log recovery tests.
> > 
> > (Oh wow flood of asserts this is going to take a while to straighten
> > out)
> > 
> > > > +for i in $(seq 1 $nr_cpus); do
> > > > +	wait
> > > > +done
> > > 
> > > Can't we just pass the pids forked by the loop above? Though the manpage
> > > says wait should wait for all child pids as it is, so perhaps the loop
> > > is unnecessary?
> > 
> > Oh, I did not know that.  Thanks for the review!
> > 
> > > Brian
> > > 
> > > > +
> > > > +# Unmount to prove that we can clean it all
> > > > +echo umount >> $seqres.full
> > > > +before=$(date +%s)
> > > > +_scratch_unmount
> > > > +after=$(date +%s)
> > > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > > +
> > > > +# Mount so that we can run the usual checks
> > > > +echo silence is golden
> > > > +_scratch_mount
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/generic/711.out b/tests/generic/711.out
> > > > new file mode 100644
> > > > index 00000000..cbbe36e9
> > > > --- /dev/null
> > > > +++ b/tests/generic/711.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 711
> > > > +silence is golden
> > > > diff --git a/tests/generic/group b/tests/generic/group
> > > > index f56eb475..26999ca1 100644
> > > > --- a/tests/generic/group
> > > > +++ b/tests/generic/group
> > > > @@ -529,3 +529,5 @@
> > > >  524 auto quick
> > > >  525 auto quick rw
> > > >  709 auto quick
> > > > +710 auto quick unlink
> > > > +711 auto quick unlink
> > > > diff --git a/tests/xfs/736 b/tests/xfs/736
> > > > new file mode 100755
> > > > index 00000000..e33de0ae
> > > > --- /dev/null
> > > > +++ b/tests/xfs/736
> > > > @@ -0,0 +1,71 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0+
> > > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 736
> > > > +#
> > > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > > +# applies to most other filesystems.
> > > > +#
> > > > +# Here we force the use of the slow iunlink bucket walk code in a single
> > > > +# threaded situation.
> > > > +#
> > > > +seq=`basename $0`
> > > > +seqres=$RESULT_DIR/$seq
> > > > +echo "QA output created by $seq"
> > > > +tmp=/tmp/$$
> > > > +status=1	# failure is the default!
> > > > +testfile=$TEST_DIR/$seq.txt
> > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -f $tmp.*
> > > > +}
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/attr
> > > > +. ./common/filter
> > > > +. ./common/inject
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs generic
> > > > +_supported_os Linux
> > > > +_require_xfs_io_error_injection "iunlink_fallback"
> > > > +_require_scratch
> > > > +
> > > > +rm -f $seqres.full
> > > > +_scratch_mkfs >> $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Set ULIMIT_NOFILE to min(file-max, 30000 files per LOAD_FACTOR)
> > > > +# so that this test doesn't take forever or OOM the box
> > > > +max_files=$((30000 * LOAD_FACTOR))
> > > > +max_allowable_files=$(cat /proc/sys/fs/file-max)
> > > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > > +ulimit -n $max_files
> > > > +
> > > > +# Force xfs to use the iunlinked fallback 50% of the time
> > > > +_scratch_inject_error "iunlink_fallback" "2"
> > > > +
> > > > +# Open a lot of unlinked files
> > > > +echo create >> $seqres.full
> > > > +program=$PWD/src/tmpfile
> > > > +(cd $SCRATCH_MNT ; $program >> $seqres.full)
> > > > +
> > > > +# Unmount to prove that we can clean it all
> > > > +echo umount >> $seqres.full
> > > > +before=$(date +%s)
> > > > +_scratch_unmount
> > > > +after=$(date +%s)
> > > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > > +
> > > > +# Mount so that we can run the usual checks
> > > > +echo silence is golden
> > > > +_scratch_mount
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/736.out b/tests/xfs/736.out
> > > > new file mode 100644
> > > > index 00000000..0258a248
> > > > --- /dev/null
> > > > +++ b/tests/xfs/736.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 736
> > > > +silence is golden
> > > > diff --git a/tests/xfs/737 b/tests/xfs/737
> > > > new file mode 100755
> > > > index 00000000..47e65607
> > > > --- /dev/null
> > > > +++ b/tests/xfs/737
> > > > @@ -0,0 +1,79 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0+
> > > > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 737
> > > > +#
> > > > +# Stress test creating a lot of unlinked O_TMPFILE files and closing them
> > > > +# all at once, checking that we don't blow up the filesystem.  This is sort
> > > > +# of a performance test for the xfs unlinked inode backref patchset, but it
> > > > +# applies to most other filesystems.
> > > > +#
> > > > +# Here we force the use of the slow iunlink bucket walk code, using every
> > > > +# CPU possible.
> > > > +#
> > > > +seq=`basename $0`
> > > > +seqres=$RESULT_DIR/$seq
> > > > +echo "QA output created by $seq"
> > > > +tmp=/tmp/$$
> > > > +status=1	# failure is the default!
> > > > +testfile=$TEST_DIR/$seq.txt
> > > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -f $tmp.*
> > > > +}
> > > > +
> > > > +# get standard environment, filters and checks
> > > > +. ./common/rc
> > > > +. ./common/attr
> > > > +. ./common/filter
> > > > +. ./common/inject
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs generic
> > > > +_supported_os Linux
> > > > +_require_xfs_io_error_injection "iunlink_fallback"
> > > > +_require_scratch
> > > > +
> > > > +rm -f $seqres.full
> > > > +_scratch_mkfs >> $seqres.full 2>&1
> > > > +_scratch_mount
> > > > +
> > > > +# Load up all the CPUs, two threads per CPU.
> > > > +nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
> > > > +
> > > > +# Set ULIMIT_NOFILE to min(file-max, 30000 files per cpu per LOAD_FACTOR)
> > > > +# so that this test doesn't take forever or OOM the box
> > > > +max_files=$((30000 * LOAD_FACTOR))
> > > > +max_allowable_files=$(( $(cat /proc/sys/fs/file-max) / nr_cpus ))
> > > > +test $max_files -gt $max_allowable_files && max_files=$max_allowable_files
> > > > +ulimit -n $max_files
> > > > +
> > > > +# Force xfs to use the iunlinked fallback 50% of the time
> > > > +_scratch_inject_error "iunlink_fallback" "2"
> > > > +
> > > > +# Open a lot of unlinked files
> > > > +echo create >> $seqres.full
> > > > +program=$PWD/src/tmpfile
> > > > +for i in $(seq 1 $nr_cpus); do
> > > > +	(mkdir $SCRATCH_MNT/$i ; cd $SCRATCH_MNT/$i ; $program >> $seqres.full) &
> > > > +done
> > > > +for i in $(seq 1 $nr_cpus); do
> > > > +	wait
> > > > +done
> > > > +
> > > > +# Unmount to prove that we can clean it all
> > > > +echo umount >> $seqres.full
> > > > +before=$(date +%s)
> > > > +_scratch_unmount
> > > > +after=$(date +%s)
> > > > +echo "Unmount took $((after - before))s." >> $seqres.full
> > > > +
> > > > +# Mount so that we can run the usual checks
> > > > +echo silence is golden
> > > > +_scratch_mount
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/737.out b/tests/xfs/737.out
> > > > new file mode 100644
> > > > index 00000000..bdc4966d
> > > > --- /dev/null
> > > > +++ b/tests/xfs/737.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 737
> > > > +silence is golden
> > > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > > index 7b7d69f1..d3189cd5 100644
> > > > --- a/tests/xfs/group
> > > > +++ b/tests/xfs/group
> > > > @@ -497,3 +497,5 @@
> > > >  497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
> > > >  498 dangerous_fuzzers dangerous_norepair
> > > >  499 auto quick
> > > > +736 auto quick unlink
> > > > +737 auto quick unlink
> > > > 
