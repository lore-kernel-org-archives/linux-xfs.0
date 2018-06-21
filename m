Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45722 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754168AbeFUB6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 21:58:48 -0400
Date: Thu, 21 Jun 2018 09:58:43 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v2 3/3] xfstests: dedupe with random io race test
Message-ID: <20180621015843.GJ2780@desktop>
References: <20180620084114.25648-1-zlang@redhat.com>
 <20180620084114.25648-3-zlang@redhat.com>
 <20180620163001.GC4841@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620163001.GC4841@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 20, 2018 at 09:30:01AM -0700, Darrick J. Wong wrote:
> On Wed, Jun 20, 2018 at 04:41:14PM +0800, Zorro Lang wrote:
> > Run several duperemove processes with fsstress on same directory at
> > same time. Make sure the race won't break the fs or kernel.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > V2 did below changes:
> > 1) do sleep 1 after kill processes
> > 2) change SLEEP_TIME to sleep_time
> > 3) add the case to stress group
> > 
> > Thanks,
> > Zorro
> > 
> >  tests/shared/010     | 111 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/shared/010.out |   2 +
> >  tests/shared/group   |   1 +
> >  3 files changed, 114 insertions(+)
> >  create mode 100755 tests/shared/010
> >  create mode 100644 tests/shared/010.out
> > 
> > diff --git a/tests/shared/010 b/tests/shared/010
> > new file mode 100755
> > index 00000000..c449c247
> > --- /dev/null
> > +++ b/tests/shared/010
> > @@ -0,0 +1,111 @@
> > +#! /bin/bash
> > +# FS QA Test 010
> > +#
> > +# Dedup & random I/O race test, do multi-threads fsstress and dedupe on
> > +# same directory/files
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
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
> > +	kill_all_stress
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# duperemove only supports btrfs and xfs (with reflink feature).
> > +# Add other filesystems if it supports more later.
> > +_supported_fs xfs btrfs
> > +_supported_os Linux
> > +_require_scratch_dedupe
> > +_require_command "$DUPEREMOVE_PROG" duperemove
> > +_require_command "$KILLALL_PROG" killall
> > +
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> > +
> > +function kill_all_stress()
> > +{
> > +	local f=1
> > +	local d=1
> > +
> > +	# kill the bash process which loop run duperemove
> > +	if [ -n "$loop_dedup_pid" ]; then
> > +		kill $loop_dedup_pid > /dev/null 2>&1
> > +		wait $loop_dedup_pid > /dev/null 2>&1
> > +		loop_dedup_pid=""
> > +	fi
> > +
> > +	# Make sure all fsstress and duperemove processes get killed
> > +	while [ $((f + d)) -ne 0 ]; do
> > +		$KILLALL_PROG -q $FSSTRESS_PROG > /dev/null 2>&1
> > +		$KILLALL_PROG -q $DUPEREMOVE_PROG > /dev/null 2>&1
> > +		sleep 1
> > +		f=`ps -eLf | grep $FSSTRESS_PROG | grep -v "grep" | wc -l`
> > +		d=`ps -eLf | grep $DUPEREMOVE_PROG | grep -v "grep" | wc -l`
> > +	done
> > +}
> > +
> > +sleep_time=$((50 * TIME_FACTOR))
> > +
> > +# Start fsstress
> > +fsstress_opts="-r -n 1000 -p $((5 * LOAD_FACTOR))"
> > +$FSSTRESS_PROG $fsstress_opts -d $SCRATCH_MNT -l 0 >> $seqres.full 2>&1 &
> > +loop_dedup_pid=""
> > +# Start several dedupe processes on same directory
> > +for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
> > +	while true; do
> > +		$DUPEREMOVE_PROG -dr --dedupe-options=same $SCRATCH_MNT/ \
> > +			>>$seqres.full 2>&1
> 
> /me wonders why not just touch $TEST_DIR/run, have this loop do:
> 
> while test -e $TEST_DIR/run; do
> 	duperemove...
> done
> 
> and then rm -f $TEST_DIR/run to end the loop?  Then you don't need the
> complex machinery to shut down the bash loop and kill the fsstress and
> duperemove processes.

Yeah, this looks cleaner to me.

Zorro, could you please take a look and update the test as Darrick
suggested? Also, you could update the fstests repo and use new 'new'
script to generate new test template which has correct SPDX tag :)

> 
> Otherwise looks decent,

Thanks for reviewing!

Eryu

> 
> --D
> 
> > +	done &
> > +	loop_dedup_pid="$! $loop_dedup_pid"
> > +done
> > +
> > +# End the test after $sleep_time seconds
> > +sleep $sleep_time
> > +kill_all_stress
> > +
> > +# umount and mount again, verify pagecache contents don't mutate and a fresh
> > +# read from the disk also doesn't show mutations.
> > +find $testdir -type f -exec md5sum {} \; > $TEST_DIR/${seq}md5.sum
> > +_scratch_cycle_mount
> > +md5sum -c --quiet $TEST_DIR/${seq}md5.sum
> > +
> > +echo "Silence is golden"
> > +status=0
> > +exit
> > diff --git a/tests/shared/010.out b/tests/shared/010.out
> > new file mode 100644
> > index 00000000..1d83a8d6
> > --- /dev/null
> > +++ b/tests/shared/010.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 010
> > +Silence is golden
> > diff --git a/tests/shared/group b/tests/shared/group
> > index 9c484794..094da27d 100644
> > --- a/tests/shared/group
> > +++ b/tests/shared/group
> > @@ -12,6 +12,7 @@
> >  007 dangerous_fuzzers
> >  008 auto stress dedupe
> >  009 auto stress dedupe
> > +010 auto stress dedupe
> >  032 mkfs auto quick
> >  272 auto enospc rw
> >  289 auto quick
> > -- 
> > 2.14.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
