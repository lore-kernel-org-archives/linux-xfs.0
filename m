Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJPCoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 22:44:11 -0400
Date: Mon, 15 Oct 2018 11:57:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] generic: test reflink side effects
Message-ID: <20181015185737.GC6703@magnolia>
References: <153869874763.26648.516233620615833277.stgit@magnolia>
 <153869878588.26648.667247878682671113.stgit@magnolia>
 <20181014154039.GQ17817@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014154039.GQ17817@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org

On Sun, Oct 14, 2018 at 11:40:39PM +0800, Eryu Guan wrote:
> On Thu, Oct 04, 2018 at 05:19:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Test that ctime gets updated and suid is cleared when we reflink.
> > Ensure we can't reflink about RLIMIT_FSIZE.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/934     |   63 ++++++++++++++++++++++++++++++++++++++
> >  tests/generic/934.out |    2 +
> >  tests/generic/935     |   48 +++++++++++++++++++++++++++++
> >  tests/generic/935.out |    2 +
> >  tests/generic/936     |   70 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/936.out |    5 +++
> >  tests/generic/937     |   81 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/937.out |   12 +++++++
> >  tests/generic/group   |    4 ++
> >  9 files changed, 287 insertions(+)
> >  create mode 100755 tests/generic/934
> >  create mode 100644 tests/generic/934.out
> >  create mode 100755 tests/generic/935
> >  create mode 100644 tests/generic/935.out
> >  create mode 100755 tests/generic/936
> >  create mode 100644 tests/generic/936.out
> >  create mode 100755 tests/generic/937
> >  create mode 100644 tests/generic/937.out
> > 
> > 
> > diff --git a/tests/generic/934 b/tests/generic/934
> > new file mode 100755
> > index 00000000..ec7ad092
> > --- /dev/null
> > +++ b/tests/generic/934
> > @@ -0,0 +1,63 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 934
> > +#
> > +# Ensure that ctime is updated and capabilities are cleared when reflinking.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
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
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch_reflink
> > +_require_command "$GETCAP_PROG" getcap
> > +_require_command "$SETCAP_PROG" setcap
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +$XFS_IO_PROG -f -c "pwrite -S 0x18 0 1m" $SCRATCH_MNT/foo >>$seqres.full
> > +$XFS_IO_PROG -f -c "pwrite -S 0x20 0 1m" $SCRATCH_MNT/bar >>$seqres.full
> > +
> > +$SETCAP_PROG cap_setgid,cap_setuid+ep $SCRATCH_MNT/bar
> > +
> > +before_cap="$($GETCAP_PROG -v $SCRATCH_MNT/bar)"
> > +before_ctime="$(stat -c '%z' $SCRATCH_MNT/bar)"
> > +
> > +sleep 1
> > +
> > +$XFS_IO_PROG -c "reflink $SCRATCH_MNT/foo" $SCRATCH_MNT/bar >> $seqres.full 2>&1
> > +#trace-cmd record -p function_graph -l 'file_remove_privs' -g 'file_remove_privs' $XFS_IO_PROG -c "reflink $SCRATCH_MNT/foo" $SCRATCH_MNT/bar >> $seqres.full 2>&1
> 
> Debug trace-cmd command?

Oops, I'll remove that.

> > +
> > +after_cap="$($GETCAP_PROG -v $SCRATCH_MNT/bar)"
> > +after_ctime="$(stat -c '%z' $SCRATCH_MNT/bar)"
> > +
> > +echo "$before_cap $before_ctime" >> $seqres.full
> > +echo "$after_cap $after_ctime" >> $seqres.full
> > +
> > +test "$before_cap" != "$after_cap" || echo "Expected capabilities to drop."
> > +test "$before_ctime" != "$after_ctime" || echo "Expected ctime to change."
> > +
> > +echo Silence is golden.
> > +status=0
> > +exit
> > diff --git a/tests/generic/934.out b/tests/generic/934.out
> > new file mode 100644
> > index 00000000..98f0bb3f
> > --- /dev/null
> > +++ b/tests/generic/934.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 934
> > +Silence is golden.
> > diff --git a/tests/generic/935 b/tests/generic/935
> > new file mode 100755
> > index 00000000..3b0eaa95
> > --- /dev/null
> > +++ b/tests/generic/935
> > @@ -0,0 +1,48 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 935
> > +#
> > +# Ensure that file size resource limits are respected when reflinking.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
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
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch_reflink
> 
> _require_user
> 
> > +
> > +rm -f $seqres.full
> > +
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +chmod a+rwx $SCRATCH_MNT
> > +$XFS_IO_PROG -f -c "pwrite -S 0x18 0 1m" $SCRATCH_MNT/foo >>$seqres.full
> > +su -s/bin/bash - $qa_user -c "ulimit -f 64 ; $XFS_IO_PROG -f -c \"reflink $SCRATCH_MNT/foo\" $SCRATCH_MNT/bar" >> $seqres.full 2>&1
> > +
> > +sz="$(stat -c '%s' $SCRATCH_MNT/bar)"
> > +if [ "$sz" -ne 0 ] && [ "$sz" -ne 65536 ]; then
> > +	echo "Oddball file size $sz??"
> > +fi
> > +
> > +echo Silence is golden.
> > +status=0
> > +exit
> > diff --git a/tests/generic/935.out b/tests/generic/935.out
> > new file mode 100644
> > index 00000000..adb5e92a
> > --- /dev/null
> > +++ b/tests/generic/935.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 935
> > +Silence is golden.
> > diff --git a/tests/generic/936 b/tests/generic/936
> > new file mode 100755
> > index 00000000..eacf9b5e
> > --- /dev/null
> > +++ b/tests/generic/936
> > @@ -0,0 +1,70 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 936
> > +#
> > +# Ensure that reflinking into a file well beyond EOF zeroes everything between
> > +# the old EOF and the start of the newly linked chunk.  This is an adaptation
> > +# of a reproducer script that Eric Sandeen formulated from a stale data
> > +# exposure bug uncovered by shared/010.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
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
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch_reflink
> > +
> > +rm -f $seqres.full
> > +
> > +# Fill disk with a well known pattern so that stale data exposure becomes much
> > +# more obvious.
> > +$XFS_IO_PROG -c "pwrite -S 0x58 -b 1m 0 300m" $SCRATCH_DEV >> $seqres.full
> > +_scratch_mkfs_sized $((300 * 1048576)) >>$seqres.full 2>&1
> > +_scratch_mount
> > +
> > +DONOR1=$SCRATCH_MNT/a
> > +TARGET=$SCRATCH_MNT/b
> > +blksz=65536
> > +
> > +$XFS_IO_PROG -f -c "pwrite -S 0x72 0 $blksz" $DONOR1 >> $seqres.full
> > +
> > +$XFS_IO_PROG -f \
> > +	-c "falloc -k $((blksz*2)) $blksz"        \
> > +	-c "pwrite -S 0x57 $((blksz*16)) 8192" \
> > +        -c "fdatasync" \
> 
> Looks like an indention issue here.
> 
> > +	-c 'stat' \
> > +	-c "reflink $DONOR1 0 $((blksz*17)) $blksz" \
> > +                $TARGET >> $seqres.full
> > +
> > +od -tx1 -Ad -c $TARGET >> $seqres.full
> > +${FILEFRAG_PROG} -v $TARGET >> $seqres.full
> 
> Seems like this filefrag is only here for debug purpose, and we could
> through away the stderr output if filefrag is not installed, so we don't
> have to _require_command for filefrag.
> 
> > +md5sum $DONOR1 | _filter_scratch
> > +md5sum $TARGET | _filter_scratch
> > +
> > +_scratch_cycle_mount
> > +
> > +od -tx1 -Ad -c $TARGET >> $seqres.full
> > +${FILEFRAG_PROG} -v $TARGET >> $seqres.full
> > +md5sum $DONOR1 | _filter_scratch
> > +md5sum $TARGET | _filter_scratch
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/936.out b/tests/generic/936.out
> > new file mode 100644
> > index 00000000..73685490
> > --- /dev/null
> > +++ b/tests/generic/936.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 936
> > +34a4daf52c562253a2f6108c5123605a  SCRATCH_MNT/a
> > +4fe4dfe3d2244bd380adcefdc5006e37  SCRATCH_MNT/b
> > +34a4daf52c562253a2f6108c5123605a  SCRATCH_MNT/a
> > +4fe4dfe3d2244bd380adcefdc5006e37  SCRATCH_MNT/b
> > diff --git a/tests/generic/937 b/tests/generic/937
> > new file mode 100755
> > index 00000000..e3a94dbb
> > --- /dev/null
> > +++ b/tests/generic/937
> > @@ -0,0 +1,81 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 937
> > +#
> > +# Ensuring that we cannot dedupe non-matching parts of files:
> > +#   - Fail to dedupe non-identical parts of two different files
> > +#   - Check that nothing changes in either file
> > +#
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
> > +    rm -rf $tmp.* $testdir
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/reflink
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_require_test_dedupe
> > +
> > +rm -f $seqres.full
> > +
> > +testdir=$TEST_DIR/test-$seq
> > +rm -rf $testdir
> > +mkdir $testdir
> > +
> > +echo "Create the original files"
> > +blksz=65536
> > +_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file1 >> $seqres.full
> > +_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) $testdir/file2 >> $seqres.full
> > +_pwrite_byte 0x62 $(((blksz * 6) - 33)) 1 $testdir/file2 >> $seqres.full
> > +_test_cycle_mount
> > +
> > +md5sum $testdir/file1 | _filter_test_dir
> > +md5sum $testdir/file2 | _filter_test_dir
> > +
> > +_compare_range $testdir/file1 0 $testdir/file2 0 "$((blksz * 8))" \
> > +       || echo "Files 1-2 do not match (intentional)"
> > +
> > +echo "(partial) dedupe the middle blocks together"
> > +free_before=$(stat -f -c '%a' $testdir)
> > +_dedupe_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
> > +		$((blksz * 4)) $((blksz * 2)) 2>&1 | _filter_xfs_io_numbers | _filter_dedupe_error
> > +_test_cycle_mount
> > +${FILEFRAG_PROG} -v $testdir/file1 >> $seqres.full
> > +${FILEFRAG_PROG} -v $testdir/file2 >> $seqres.full
> > +free_after=$(stat -f -c '%a' $testdir)
> > +echo "freesp changed by $free_before -> $free_after" >> $seqres.full
> > +
> > +echo "Compare sections"
> > +md5sum $testdir/file1 | _filter_test_dir
> > +md5sum $testdir/file2 | _filter_test_dir
> > +
> > +_compare_range $testdir/file1 0 $testdir/file2 0 $((blksz * 4)) \
> > +       || echo "Start sections do not match (error)"
> > +
> > +_compare_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
> > +		$((blksz * 4)) $((blksz * 2)) \
> > +       || echo "Middle sections do not match (intentional)"
> > +
> > +_compare_range $testdir/file1 $((blksz * 6)) $testdir/file2 \
> > +		$((blksz * 6)) $((blksz * 2)) \
> > +       || echo "End sections do not match (error)"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/937.out b/tests/generic/937.out
> > new file mode 100644
> > index 00000000..496975d6
> > --- /dev/null
> > +++ b/tests/generic/937.out
> > @@ -0,0 +1,12 @@
> > +QA output created by 937
> > +Create the original files
> > +35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-937/file1
> > +39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-937/file2
> > +Files 1-2 do not match (intentional)
> > +(partial) dedupe the middle blocks together
> > +deduped XXXX/XXXX bytes at offset XXXX
> > +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> 
> I hit failure like:
> 
> -deduped XXXX/XXXX bytes at offset XXXX
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
> 
> I suspected "Extents did not match." is what we actually expected?

Yeah.  I mistakenly thought that the dedupe ioctl could return
bytes_deduped < len, but the existing clients go berserk in shared/010
so ... I fixed the code and the test to follow the btrfs precedent.

--D

> Thanks,
> Eryu
> 
> P.S.
> Patch 1-5 look fine to me, but drop this patch for now.
> 
> > +Compare sections
> > +35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-937/file1
> > +39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-937/file2
> > +Middle sections do not match (intentional)
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 06b062e1..ef08c0de 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -509,3 +509,7 @@
> >  504 auto quick locks
> >  505 shutdown auto quick metadata
> >  707 auto quick rw collapse zero
> > +934 auto quick clone
> > +935 auto quick clone
> > +936 auto quick clone
> > +937 auto quick dedupe clone
> > 
