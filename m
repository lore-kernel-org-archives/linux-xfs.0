Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751156AbdJJEgv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 00:36:51 -0400
Date: Tue, 10 Oct 2017 12:36:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] generic: test race between block map change and writeback
Message-ID: <20171010043649.GI10593@eguan.usersys.redhat.com>
References: <20170831040237.16022-1-eguan@redhat.com>
 <20171009161255.GA19847@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009161255.GA19847@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Mon, Oct 09, 2017 at 12:12:55PM -0400, Brian Foster wrote:
> On Thu, Aug 31, 2017 at 12:02:37PM +0800, Eryu Guan wrote:
> > Run delalloc writes & append writes & non-data-integrity syncs
> > concurrently to test the race between block map change vs writeback.
> > 
> > This is to cover an XFS bug that data could be written to wrong
> > block and delay allocated blocks are leaked because the block map
> > was changed due to the removal of speculative allocated eofblocks
> > when writeback is in progress.
> > 
> > And this test partially mimics what lustre-racer[1] test does, using
> > which this bug was first found.
> > 
> > [1] https://git.hpdd.intel.com/?p=fs/lustre-release.git;a=tree;f=lustre/tests/racer;hb=HEAD
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> > 
> > This may not reproduce the bug on all hosts, but it does reproduce the XFS
> > corruption issue reliably on my different test hosts.
> > 
> 
> Was this problem fixed already or are we still waiting on a fix?

It's still an unfixed problem. Dave provided a test patch (which did fix
the bug for me) then Christoph suggested a fix based on seqlock, and
things stalled there. (I'm happy to pick up the work, but I'm not that
familiar with all the allocation paths that could change the extent map,
so I may need some guidance and time to play with it.)

> 
> >  tests/generic/451     | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/451.out |   2 +
> >  tests/generic/group   |   1 +
> >  3 files changed, 133 insertions(+)
> >  create mode 100755 tests/generic/451
> >  create mode 100644 tests/generic/451.out
> > 
> > diff --git a/tests/generic/451 b/tests/generic/451
> > new file mode 100755
> > index 000000000000..72cdd1c01de2
> > --- /dev/null
> > +++ b/tests/generic/451
> > @@ -0,0 +1,130 @@
> > +#! /bin/bash
> > +# FS QA Test 451
> > +#
> > +# Run delalloc writes & append writes & non-data-integrity syncs concurrently
> > +# to test the race between block map change vs writeback.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Red Hat Inc. All Rights Reserved.
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
> > +MAXFILES=200
> > +BLOCK_SZ=65536
> > +
> > +LOOP_CNT=12
> 
> If I skip the failure detection below, the test runs for 100s on my vm.
> Otherwise it fails consistently within ~45s (worst case in 5 or 6
> tries). Do you observe differently? If not, I'm wondering if we could
> speed up the common case and reduce the number of iterations.

On my test vm, around 60% runs failed for me, and the run time of failed
runs can vary from 6s to 65s. A successful run needs around 70s. I think
I can reduce the LOOP_CNT to 10, then more than 50% runs failed for me
and a successful run needs around 60s on my test vm.

> 
> > +LOOP_TIME=5
> > +PROC_CNT=16
> > +
> > +stop=$tmp.stop
> > +
> > +# get a random file to work on
> > +getfile()
> > +{
> > +	echo $SCRATCH_MNT/$((RANDOM % MAXFILES))
> > +}
> > +
> > +# delalloc write a relative big file to get enough dirty pages to be written
> > +# back, and XFS needs big enough file to trigger speculative preallocations, so
> > +# freeing these eofblocks could change the extent record
> > +do_write()
> > +{
> > +	local blockcount=$((RANDOM % 100))
> > +	local filesize=$((blockcount * BLOCK_SZ))
> > +	$XFS_IO_PROG -ftc "pwrite -b $BLOCK_SZ 0 $filesize" `getfile` >/dev/null 2>&1
> 
> Long line here. Otherwise the rest of the test looks good.

Sure, will fix that. Thanks a lot for the review!

Eryu
> 
> Brian
> 
> > +}
> > +
> > +# append another dirty page to the file, the writeback might pick it up too if
> > +# the file is already under writeback
> > +do_append()
> > +{
> > +	echo "test string" >> `getfile`
> > +}
> > +
> > +# issue WB_SYNC_NONE writeback with the '-w' option of sync_range xfs_io
> > +# command, so that the last dirty page from append write can be picked up in
> > +# this writeback cycle. This is not mandatory but could help reproduce XFS
> > +# corruption more easily.
> > +do_writeback()
> > +{
> > +	$XFS_IO_PROG -c "sync_range -w 0 0" `getfile` >/dev/null 2>&1
> > +}
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +# do fsck after each iteration in test
> > +_require_scratch_nocheck
> > +_require_xfs_io_command "sync_range"
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +# loop for $LOOP_CNT iterations, and each iteration starts $PROC_CNT processes
> > +# for each operation and runs for $LOOP_TIME seconds, and check filesystem
> > +# consistency after each iteration
> > +for i in `seq 1 $LOOP_CNT`; do
> > +	rm -f $stop
> > +	for j in `seq 1 $PROC_CNT`; do
> > +		while [ ! -e $stop ]; do
> > +			do_write
> > +		done &
> > +
> > +		while [ ! -e $stop ]; do
> > +			do_append
> > +		done &
> > +
> > +		while [ ! -e $stop ]; do
> > +			do_writeback
> > +		done &
> > +	done
> > +	sleep $LOOP_TIME
> > +	touch $stop
> > +	wait
> > +
> > +	_scratch_unmount
> > +	# test exits here if fs is inconsistent
> > +	_check_scratch_fs
> > +	_scratch_mount
> > +done
> > +
> > +echo "Silence is golden"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/451.out b/tests/generic/451.out
> > new file mode 100644
> > index 000000000000..db924411b72f
> > --- /dev/null
> > +++ b/tests/generic/451.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 451
> > +Silence is golden
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 044ec3f355ed..b4bd66bc65a9 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -453,3 +453,4 @@
> >  448 auto quick rw
> >  449 auto quick acl enospc
> >  450 auto quick rw
> > +451 auto rw
> > -- 
> > 2.13.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
