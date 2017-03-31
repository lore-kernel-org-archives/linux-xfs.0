Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932896AbdCaKTp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Mar 2017 06:19:45 -0400
Date: Fri, 31 Mar 2017 18:19:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests: Add first statx test
Message-ID: <20170331101941.GL22845@eguan.usersys.redhat.com>
References: <15267.1490891560@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15267.1490891560@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, fstests@vger.kernel.org

On Thu, Mar 30, 2017 at 05:32:40PM +0100, David Howells wrote:
> Add a statx test that does the following:
> 
>  (1) Creates one each of the various types of file object and creates a
>      hard link to the regular file.
> 
>      Note that the creation of an AF_UNIX socket is done with netcat in a
>      bash coprocessing thread.  This might be best done with another
>      in-house helper to avoid a dependency on nc.
> 
>  (2) Notes the clock time before creating the file.
> 
>  (3) Invokes the C test program included in this patch after the creation,
>      handing it the clock time from (2) and providing a selection of
>      invariants to check.
> 
> The patch also creates a C[*] test program to do the actual stat checking.
> The test program then does the following:
> 
>  (1) Compares the output of statx() to that of fstatat().
> 
>  (2) Optionally compares the timestamps to see that they're sensibly
>      ordered with respect to the saved clock time[**] and each other.
> 
>  (3) Optionally compares selected stats to values specified on the command
>      line.
> 
>  (4) Optionally compares the stats to those of another file, requiring them
>      to be the same (hard link checking).
> 
> For example:
> 
>         ./src/stat_test /dev/null \
>                0.0 \
>                stx_type=char \
>                stx_rdev_major=3 \
>                stx_rdev_minor=8 \
>                stx_nlink=1
> 
> 
> [*] Note that it proved much easier to do this in C than trying to do it in
>     shell script and trying parsing the output of xfs_io.  Using xfs_io has
>     other pitfalls also: it wants to *open* the file, even if the file is
>     not an appropriate type for this or does not grant permission to do so.
>     I can get around this by opening O_PATH, but then xfs_io fails to
>     handle XFS files because it wants to issue ioctls on every fd it opens.
> 
> [**] It turns out they may be *before* the clock time.  This would seem to
>      indicate a bug in the kernel's time-tracking system.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

I haven't looked into the statx(2) tests deeply, I'll just comment from
xfstests' perspective of view for now.

> ---
>  src/Makefile          |    2 
>  src/stat_test.c       |  666 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  src/statx.h           |  166 ++++++++++++
>  tests/generic/420     |  221 ++++++++++++++++
>  tests/generic/420.out |   12 
>  tests/generic/group   |    1 
>  6 files changed, 1067 insertions(+), 1 deletion(-)

Need an entry in .gitignore for the new stat_test binary.

...

> diff --git a/tests/generic/420 b/tests/generic/420
> new file mode 100755
> index 0000000..e9a6dda
> --- /dev/null
> +++ b/tests/generic/420
> @@ -0,0 +1,221 @@
> +#! /bin/bash
> +# FS QA Test 420
> +#
> +# Test the statx system call
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
> +# Written by David Howells (dhowells@redhat.com)
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_test

_require_scratch is not called, but in the test $SCRATCH_MNT is used. So
you need to either call "_require_scratch" here or use $TEST_DIR in the
test. For this statx(2) test, I think test in $TEST_DIR would be
sufficient.

TEST_DEV and TEST_DIR are mandatory in xfstests, while SCRATCH_DEV and
SCRATCH_MNT are optional, so need to _require_scratch before using them.

> +_require_test_program "stat_test"

Also, we need to detect if the filesystem in test supports statx(2) or
not, and call _notrun to exit immediately and skip the test, so test
doesn't fail when running on older kernels where don't have statx
support. e.g. a new _require rule like

_require_statx

Perhaps you can update src/stat_test so that it could perform statx(2)
call on a give file and report the support status of statx syscall of
the filesystem. e.g. common/rc::_require_seek_data_hole(), it runs
"src/seek_sanity_test -t $testfile" to check statx support status.

> +
> +function check_stat () {
> +    $here/src/stat_test $*
> +}
> +
> +###############################################################################
> +#
> +# Check statx'ing of various types of object
> +#
> +###############################################################################
> +failed=0

This is not needed, "status" is sufficient.

> +
> +echo "Test statx on a fifo"
> +origin=`date +%s.%N`
> +if mkfifo -m 0600 $SCRATCH_MNT/fifo
> +then
> +    check_stat $SCRATCH_MNT/fifo \
> +	       $origin\
> +	       ts_order \
> +	       stx_type=fifo \
> +	       stx_mode=0600 \
> +	       stx_rdev_major=0 \
> +	       stx_rdev_minor=0 \
> +	       stx_nlink=1 \
> +	|| failed=1
> +else
> +    echo "- mkfifo failed"
> +    failed=1
> +fi

No need to check if mkfifo's status (and all later similar commands like
mkmod, mkdir, ln etc.). The test harness compares the test output with
the predefined golden output file (420.out in this case) and fails the
test if the output doesn't match. So any error message from mkfifo,
mknod, mkdir commands will break golden image and fails the test.

And prefix or suffix the test file name with current test sequence
number would be good, to avoid file name conflicts with test files from
other tests.

So this could be simplified to:

echo "Test statx on a fifo"
origin=`date +%s.%N`
mkfifo -m 0600 $TEST_DIR/$seq-fifo
check_stat $TEST_DIR/$seq-fifo $origin ....

> +
> +echo "Test statx on a chardev"
> +origin=`date +%s.%N`
> +if mknod -m 0600 $SCRATCH_MNT/null c 1 3
> +then
> +    check_stat $SCRATCH_MNT/null \
> +	       $origin \
> +	       ts_order \
> +	       stx_type=char \
> +	       stx_mode=0600 \
> +	       stx_rdev_major=1 \
> +	       stx_rdev_minor=3 \
> +	       stx_nlink=1 \
> +	|| failed=1
> +else
> +    echo "- mknod failed"
> +    failed=1
> +fi
> +
> +echo "Test statx on a directory"
> +origin=`date +%s.%N`
> +if mkdir $SCRATCH_MNT/dir
> +then
> +    check_stat $SCRATCH_MNT/dir \
> +	       $origin \
> +	       ts_order \
> +	       stx_type=dir \
> +	       stx_mode=0755 \
> +	       stx_rdev_major=0 \
> +	       stx_rdev_minor=0 \
> +	       stx_nlink=2 \
> +	|| failed=1
> +else
> +    echo "- mkdir failed"
> +    failed=1
> +fi
> +
> +echo "Test statx on a blockdev"
> +origin=`date +%s.%N`
> +if mknod -m 0600 $SCRATCH_MNT/loopy b 7 123
> +then
> +    check_stat $SCRATCH_MNT/loopy \
> +	       $origin \
> +	       ts_order \
> +	       stx_type=block \
> +	       stx_mode=0600 \
> +	       stx_rdev_major=7 \
> +	       stx_rdev_minor=123 \
> +	       stx_nlink=1 \
> +	|| failed=1
> +else
> +    echo "- mknod failed"
> +    failed=1
> +fi
> +
> +echo "Test statx on a file"
> +origin=`date +%s.%N`
> +if dd if=/dev/zero of=$SCRATCH_MNT/file bs=1024 count=20
> +then
> +    check_stat $SCRATCH_MNT/file \
> +	       $origin \
> +	       ts_order \
> +	       stx_type=file \
> +	       stx_size=20480 \
> +	       stx_rdev_major=0 \
> +	       stx_rdev_minor=0 \
> +	       stx_nlink=1 \
> +	|| failed=1
> +else
> +    echo "- dd failed"
> +    failed=1
> +fi
> +
> +echo "Test statx on a symlink"
> +origin=`date +%s.%N`
> +if ln -s $SCRATCH_MNT/nowhere $SCRATCH_MNT/symlink
> +then
> +    check_stat $SCRATCH_MNT/symlink \
> +	       $origin \
> +	       ts_order \
> +	       stx_type=sym \
> +	       stx_rdev_major=0 \
> +	       stx_rdev_minor=0 \
> +	       stx_nlink=1 \
> +	|| failed=1
> +else
> +    echo "- ln -s failed"
> +    failed=1
> +fi
> +
> +echo "Test statx on an AF_UNIX socket"
> +origin=`date +%s.%N`
> +if (coproc SERVER { nc -U -l $SCRATCH_MNT/sock </dev/null; };
> +    nc -U $SCRATCH_MNT/sock </dev/null;
> +    wait)
> +then
> +    check_stat $SCRATCH_MNT/sock \
> +	       $origin \
> +	       ts_order \
> +	       stx_type=sock \
> +	       stx_rdev_major=0 \
> +	       stx_rdev_minor=0 \
> +	       stx_nlink=1 \
> +	|| failed=1
> +else
> +    echo "- nc failed"
> +    failed=1
> +fi

If nc is really needed, we should check the existence of it before
starting the actual test, so test won't fail because of lack of nc
command. i.e. define NC_PROG in common/config and call _require_command
to check the existence of it. e.g.

common/config:
export NC_PROG="`set_prog_path nc`"

In this test, along with other _require rules:
_require_command "$NC_PROG" "nc"

> +
> +echo "Test a hard link to a file"
> +origin=`date +%s.%N`
> +if ln $SCRATCH_MNT/file $SCRATCH_MNT/link
> +then
> +    check_stat $SCRATCH_MNT/link \
> +	       $origin \
> +	       ts=O,c \
> +	       cmp=$SCRATCH_MNT/file \
> +	       stx_nlink=2 \
> +	|| failed=1
> +else
> +    echo "- ln failed"
> +    failed=1
> +fi
> +
> +if [ $failed = 1 ]
> +then
> +    echo "Test script failed"
> +    exit
> +fi

This is not needed either.

> +
> +echo "Success"
> +
> +# optional stuff if your test has verbose output to help resolve problems
> +#echo
> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/420.out b/tests/generic/420.out
> new file mode 100644
> index 0000000..e2956a6
> --- /dev/null
> +++ b/tests/generic/420.out
> @@ -0,0 +1,12 @@
> +QA output created by 420
> +Test statx on a fifo
> +Test statx on a chardev
> +Test statx on a directory
> +Test statx on a blockdev
> +Test statx on a file
> +20+0 records in
> +20+0 records out
> +Test statx on a symlink
> +Test statx on an AF_UNIX socket
> +Test a hard link to a file
> +Success
> diff --git a/tests/generic/group b/tests/generic/group
> index 0781f35..c420998 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -422,3 +422,4 @@
>  417 auto quick shutdown log
>  418 auto rw
>  419 auto quick encrypt
> +420 other

I noticed you've already updated group to 'auto quick' :)

Thanks,
Eryu
