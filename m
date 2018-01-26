Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751619AbeAZHNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 02:13:47 -0500
Date: Thu, 25 Jan 2018 23:00:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: regression tests for reflink quota bugs
Message-ID: <20180126070039.GH9359@magnolia>
References: <151683799705.17051.9987269343206294671.stgit@magnolia>
 <151683802784.17051.11994070942067598698.stgit@magnolia>
 <20180126064952.GL18267@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126064952.GL18267@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jan 26, 2018 at 02:49:52PM +0800, Eryu Guan wrote:
> On Wed, Jan 24, 2018 at 03:53:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add three tests to look for quota bugs in xfs reflink.  The first
> > test looks for problems when we have speculative cow reservations
> > in memory, we chown the file, but the reservations don't move to
> > the new owner.  The second test checks that we remembered to
> > dqattach the inodes before performing reflink operations; and the
> > third exercises reflink quota handling near enospc.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/904     |   93 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/904.out |   17 ++++++++
> >  tests/xfs/905     |   88 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/905.out |   13 ++++++
> >  tests/xfs/906     |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/906.out |    6 +++
> >  tests/xfs/group   |    3 +
> >  7 files changed, 331 insertions(+)
> >  create mode 100755 tests/xfs/904
> >  create mode 100644 tests/xfs/904.out
> >  create mode 100755 tests/xfs/905
> >  create mode 100644 tests/xfs/905.out
> >  create mode 100755 tests/xfs/906
> >  create mode 100644 tests/xfs/906.out
> > 
> > 
> > diff --git a/tests/xfs/904 b/tests/xfs/904
> > new file mode 100755
> > index 0000000..ef78f1a
> > --- /dev/null
> > +++ b/tests/xfs/904
> > @@ -0,0 +1,93 @@
> > +#! /bin/bash
> > +# FS QA Test No. 904
> > +#
> > +# Regression test for a quota accounting bug when changing the owner of
> > +# a file that has CoW reservations and no dirty pages.  The reservations
> > +# should shift over to the new owner, but they do not.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
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
> > +. ./common/reflink
> > +. ./common/quota
> > +. ./common/filter
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_quota
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_user
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
> > +
> > +echo "Create files"
> > +$XFS_IO_PROG -c "cowextsize 1m" $SCRATCH_MNT
> 
> Add comments on why we need this?

To make sure there are a bunch of cow block reservations sitting around
when we chown even after the write flushes and remaps.

> > +touch $SCRATCH_MNT/a $SCRATCH_MNT/force_fsgqa
> > +chown $qa_user $SCRATCH_MNT/a $SCRATCH_MNT/force_fsgqa
> > +_pwrite_byte 0x58 0 64k $SCRATCH_MNT/a >> $seqres.full
> > +$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
> > +_report_quota_blocks "-u $SCRATCH_MNT"
> > +
> > +echo "Reflink and CoW"
> > +_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/b
> > +_pwrite_byte 0x59 0 64k $SCRATCH_MNT/a >> $seqres.full
> > +$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
> > +_report_quota_blocks "-u $SCRATCH_MNT"
> > +
> > +echo "Sync"
> > +sync
> > +_report_quota_blocks "-u $SCRATCH_MNT"
> > +
> > +echo "Chown and check quota"
> > +chown root $SCRATCH_MNT/a
> > +$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
> > +_report_quota_blocks "-u $SCRATCH_MNT"
> > +
> > +echo "Remount"
> > +_scratch_unmount
> > +_scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
> > +$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
> > +_report_quota_blocks "-u $SCRATCH_MNT"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/904.out b/tests/xfs/904.out
> > new file mode 100644
> > index 0000000..4c2f508
> > --- /dev/null
> > +++ b/tests/xfs/904.out
> > @@ -0,0 +1,17 @@
> > +QA output created by 904
> > +Format and mount
> > +Create files
> > +root 0 0 0
> > +fsgqa 64 0 0
> > +Reflink and CoW
> > +root 0 0 0
> > +fsgqa 1152 0 0
> > +Sync
> > +root 0 0 0
> > +fsgqa 1088 0 0
> > +Chown and check quota
> > +root 1024 0 0
> > +fsgqa 64 0 0
> > +Remount
> > +root 64 0 0
> > +fsgqa 64 0 0
> > diff --git a/tests/xfs/905 b/tests/xfs/905
> > new file mode 100755
> > index 0000000..a457c84
> > --- /dev/null
> > +++ b/tests/xfs/905
> > @@ -0,0 +1,88 @@
> > +#! /bin/bash
> > +# FS QA Test No. 905
> > +#
> > +# Regression test for a quota accounting bug when reflinking across EOF
> > +# of a file in which we forgot dq_attach.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
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
> > +. ./common/reflink
> > +. ./common/quota
> > +. ./common/filter
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_quota
> > +_require_scratch_reflink
> > +_require_cp_reflink
> > +_require_user
> > +
> > +rm -f $seqres.full
> > +
> > +check_quota() {
> > +	du_total="$(du -ksc $SCRATCH_MNT/a $SCRATCH_MNT/b | tail -n 1 | awk '{print $1}')"
> > +	qu_total="$(_report_quota_blocks "-u $SCRATCH_MNT" | grep $qa_user | awk '{print $2}')"
> > +	echo "du: $du_total; quota: $qu_total"
> > +}
> > +
> > +echo "Format and mount (noquota)"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount "-o noquota" >> $seqres.full 2>&1
> > +
> > +echo "Create files"
> > +_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > +_pwrite_byte 0x58 0 1m $SCRATCH_MNT/b >> $seqres.full
> > +chown $qa_user $SCRATCH_MNT/a $SCRATCH_MNT/b
> > +check_quota 2>&1 | _filter_scratch
> > +
> > +echo "Mount (usrquota) and check quota"
> > +_scratch_unmount
> > +_scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
> > +check_quota
> > +
> > +echo "Reflink and check quota again"
> > +_reflink_range $SCRATCH_MNT/a 256k $SCRATCH_MNT/b 384k 128k >> $seqres.full
> > +_reflink_range $SCRATCH_MNT/a 256k $SCRATCH_MNT/b 960k 128k >> $seqres.full
> > +check_quota
> > +
> > +echo "Force quotacheck"
> > +_check_quota_usage
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/905.out b/tests/xfs/905.out
> > new file mode 100644
> > index 0000000..fa95624
> > --- /dev/null
> > +++ b/tests/xfs/905.out
> > @@ -0,0 +1,13 @@
> > +QA output created by 905
> > +Format and mount (noquota)
> > +Create files
> > +repquota: Mountpoint (or device) SCRATCH_MNT not found or has no quota enabled.
> > +repquota: Not all specified mountpoints are using quota.
> > +du: 2048; quota: 
> > +Mount (usrquota) and check quota
> > +du: 2048; quota: 2048
> > +Reflink and check quota again
> > +du: 2112; quota: 2112
> > +Force quotacheck
> > +Comparing user usage
> > +Comparing group usage
> > diff --git a/tests/xfs/906 b/tests/xfs/906
> > new file mode 100755
> > index 0000000..17dcd2e
> > --- /dev/null
> > +++ b/tests/xfs/906
> > @@ -0,0 +1,111 @@
> > +#! /bin/bash
> > +# FS QA Test No. 906
> > +#
> > +# Force enable all XFS quotas, run fsstress until the fs runs out of
> > +# space, and make sure the quotas are still correct when we're done.
> > +# This is a general regression/stress test for numerous quota bugs with
> > +# reflink and copy on write.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
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
> > +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/quota
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +
> > +_require_scratch_reflink
> > +_require_quota
> > +_require_command "$KILLALL_PROG" "killall"
> > +
> > +rm -f $seqres.full
> > +
> > +report_quota_blocks() {
> > +	$XFS_QUOTA_PROG -x -c "report $1" $SCRATCH_MNT | \
> > +			awk '{x += $2;} END { print(x); }'
> > +}
> > +
> > +compare_quota_to_du() {
> > +	test $1 -eq $2 || echo "$3 quota $2 blocks does not match du $1 blocks?"
> > +}
> > +
> > +# Make sure the user/group/project quota block counts match the du output.
> > +# This ensures that we did the quota accounting correctly and that we're
> > +# accurately reporting cow preallocation blocks in stat.
> > +check_quota_du_blocks() {
> > +	sync
> > +	$XFS_QUOTA_PROG -x -c 'report' $SCRATCH_MNT >> $seqres.full
> > +	du_rep=$(du -ks $SCRATCH_MNT | awk '{print $1}')
> > +	u_rep=$(report_quota_blocks -u)
> > +	g_rep=$(report_quota_blocks -g)
> > +	p_rep=$(report_quota_blocks -p)
> > +
> > +	compare_quota_to_du $du_rep $u_rep "user"
> > +	compare_quota_to_du $du_rep $g_rep "group"
> > +	compare_quota_to_du $du_rep $p_rep "project"
> > +}
> > +
> > +echo "Format and fsstress"
> > +
> > +_qmount_option "usrquota,grpquota,prjquota"
> > +_scratch_mkfs > $seqres.full 2>&1
> 
> Do we need to limit the fs size? If we're running on a large SCRATCH_DEV
> test will run for longer time.

Yeah, we might as well do that.

> > +_scratch_mount >> $seqres.full 2>&1
> 
> I'd check mount status here and _fail if mount failed, otherwise we may
> eat all space on underlying fs (usually rootfs).

ok.

> > +
> > +nr_cpus=$((LOAD_FACTOR * 4))
> > +nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
> > +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
> > +
> > +echo "Check quota before remount"
> > +check_quota_du_blocks
> > +
> > +# Clear out all the preallocations before we quotacheck.
> > +# The count comparison in _check_quota_usage will be unhappy if we don't
> > +# manage to clean out all the cow preallocations before the remount.
> > +_scratch_unmount
> > +_scratch_mount
> > +
> > +# Make sure the usage doesn't change after quotacheck.
> > +echo "Check quota after remount"
> > +_check_quota_usage
> > +
> > +check_quota_du_blocks
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/906.out b/tests/xfs/906.out
> > new file mode 100644
> > index 0000000..201daf3
> > --- /dev/null
> > +++ b/tests/xfs/906.out
> > @@ -0,0 +1,6 @@
> > +QA output created by 906
> > +Format and fsstress
> > +Check quota before remount
> > +Check quota after remount
> > +Comparing user usage
> > +Comparing group usage
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index cf81451..aa8b49f 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -437,3 +437,6 @@
> >  437 auto quick other
> >  438 auto quick quota dangerous
> >  439 auto quick fuzzers log
> > +904 auto quick clone quota
> > +905 auto quick clone quota
> > +906 auto quick clone quota
> 
> I think 906 can be a 'stress' test instead of 'quick'.

I don't think it's quick anymore anyway :)

--D

> Thanks,
> Eryu
