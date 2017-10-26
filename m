Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdJZQkU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 12:40:20 -0400
Date: Fri, 27 Oct 2017 00:40:17 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] tests/generic: test writepage cached mapping validity
Message-ID: <20171026164017.GR3235@eguan.usersys.redhat.com>
References: <20171026144816.9259-1-bfoster@redhat.com>
 <20171026153402.GQ3235@eguan.usersys.redhat.com>
 <20171026161247.GA6259@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026161247.GA6259@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 12:12:47PM -0400, Brian Foster wrote:
> On Thu, Oct 26, 2017 at 11:34:02PM +0800, Eryu Guan wrote:
> > On Thu, Oct 26, 2017 at 10:48:16AM -0400, Brian Foster wrote:
> > > XFS has a bug where page writeback can end up sending data to the
> > > wrong location due to a stale, cached file mapping. Add a test to
> > > trigger this problem by racing background writeback with a
> > > truncate/rewrite of the final page of the file.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Thanks a lot for the new test!
> > 
> > > ---
> > > 
> > > Here's a new version of the writepages test I previously posted as RFC.
> > > This variant does not require an artificial delay to reproduce, so I've
> > > dropped the need for the error injection tag.
> > > 
> > > I have been playing a bit with the file size and iteration count of the
> > > test. I started with something that ran a decent bit longer (~2m) as was
> > > necessary to reproduce on my dev/debug vm, but recently trimmed the file
> > > size and iteration count to something that runs much quicker (~10s) and
> > > reproduces nearly 100% of the time on my actual test hardware. The
> > > tradeoff is the reproducibility is much lower on my debug vm (~20-25%
> > > perhaps). The test still does reproduce when run over 10-15 iters, so I
> > > opted for the quicker test.
> > > 
> > > In all, I am a bit curious about whether this reproduces reliably on
> > > others' test setups. If not, does tweaking the size/iterations improve
> > > the reproducibility?
> > 
> > On my test vm, with the default size/iteration numbers, the
> > reproducibility is around 40%, run time is 3s. Then I doubled the
> > ineration number, and it's 100% reproduced, run time is 7s.
> > 
> > On my real hardware, I have to double both file size and iteration
> > numbers to reproduce, reproducibility is ~20%, run time 35s.
> > 
> > Note that the vm is running v4.14-rc5 based 'xfs-4.14-fixes-7' tag from
> > Darric's tree and the real hardware is running v4.14-rc6.
> > 
> 
> Thanks for testing this... It's interesting that you don't seem to
> reproduce at all on the real hardware with the current values. What do
> you have for storage on both of these setups? My VM is a slow, single
> spindle while the hardware is also spinning rust but on a hardware raid.

My vm is a kvm guest with 4 vcpus and 8G mem running on RHEL6 host, the
underlying storage hosting the OS image is hardware raid (HP smart
array). The real hardware is an IBM box with 8 logical cpus and 8G mem,
and 4 sata disks connected to MegaRAID, but configured as JBOD, I used
two partitions of one of the four disks.

Thanks,
Eryu

> 
> If I run with 64MB, 32 iters, I'm at ~48 seconds on the VM. I can check
> on bare metal as soon as the test run I have currently running
> completes.
> 
> Brian
> 
> > Thanks,
> > Eryu
> > 
> > > 
> > > Brian
> > > 
> > > v1:
> > > - New test algorithm that does not require artificial delay.
> > > - Created as generic test.
> > > rfc: https://marc.info/?l=linux-xfs&m=150886719725497&w=2
> > > 
> > >  tests/generic/999     | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/999.out |  2 ++
> > >  tests/generic/group   |  1 +
> > >  3 files changed, 97 insertions(+)
> > >  create mode 100755 tests/generic/999
> > >  create mode 100644 tests/generic/999.out
> > > 
> > > diff --git a/tests/generic/999 b/tests/generic/999
> > > new file mode 100755
> > > index 0000000..9e56a1e
> > > --- /dev/null
> > > +++ b/tests/generic/999
> > > @@ -0,0 +1,94 @@
> > > +#! /bin/bash
> > > +# FS QA Test 999
> > > +#
> > > +# Test XFS page writeback code for races with the cached file mapping. XFS
> > > +# caches the file -> block mapping for a full extent once it is initially looked
> > > +# up. The cached mapping is used for all subsequent pages in the same writeback
> > > +# cycle that cover the associated extent. Under certain conditions, it is
> > > +# possible for concurrent operations on the file to invalidate the cached
> > > +# mapping without the knowledge of writeback. Writeback ends up sending I/O to a
> > > +# partly stale mapping and potentially leaving delalloc blocks in the current
> > > +# mapping unconverted.
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
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
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_scratch
> > > +_require_test_program "feature"
> > > +
> > > +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
> > > +_scratch_mount || _fail "mount failed"
> > > +
> > > +file=$SCRATCH_MNT/file
> > > +filesize=$((1024 * 1024 * 32))
> > > +pagesize=`src/feature -s`
> > > +truncsize=$((filesize - pagesize))
> > > +
> > > +for i in $(seq 0 15); do
> > > +	# Truncate the file and fsync to persist the final size on-disk. This is
> > > +	# required so the subsequent truncate will not wait on writeback.
> > > +	$XFS_IO_PROG -fc "truncate 0" $file
> > > +	$XFS_IO_PROG -c "truncate $filesize" -c fsync $file
> > > +
> > > +	# create a small enough delalloc extent to likely be contiguous
> > > +	$XFS_IO_PROG -c "pwrite 0 $filesize" $file >> $seqres.full 2>&1
> > > +
> > > +	# Start writeback and a racing truncate and rewrite of the final page.
> > > +	$XFS_IO_PROG -c "sync_range -w 0 0" $file &
> > > +	sync_pid=$!
> > > +	$XFS_IO_PROG -c "truncate $truncsize" \
> > > +		     -c "pwrite $truncsize $pagesize" $file >> $seqres.full 2>&1
> > > +
> > > +	# If the test fails, the most likely outcome is an sb_fdblocks mismatch
> > > +	# and/or an associated delalloc assert failure on inode reclaim. Cycle
> > > +	# the mount to trigger detection.
> > > +	wait $sync_pid
> > > +	_scratch_cycle_mount || _fail "mount failed"
> > > +done
> > > +
> > > +echo Silence is golden
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > > new file mode 100644
> > > index 0000000..3b276ca
> > > --- /dev/null
> > > +++ b/tests/generic/999.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 999
> > > +Silence is golden
> > > diff --git a/tests/generic/group b/tests/generic/group
> > > index fbe0a7f..89342da 100644
> > > --- a/tests/generic/group
> > > +++ b/tests/generic/group
> > > @@ -468,3 +468,4 @@
> > >  463 auto quick clone dangerous
> > >  464 auto rw
> > >  465 auto rw quick aio
> > > +999 auto quick
> > > -- 
> > > 2.9.5
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
