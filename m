Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750797AbdDAHfw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Apr 2017 03:35:52 -0400
Date: Sat, 1 Apr 2017 15:35:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] xfstests: Add first statx test
Message-ID: <20170401073549.GP22845@eguan.usersys.redhat.com>
References: <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149097291264.20089.7010494679305716312.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Mar 31, 2017 at 04:08:32PM +0100, David Howells wrote:
> Add a statx test script that does the following:
> 
>  (1) Creates one each of the various types of file object and creates a
>      hard link to the regular file.
> 
>      Note that the creation of an AF_UNIX socket is done with netcat in a
>      bash coprocessing thread.  This might be best done with another
>      in-house helper to avoid a dependency on nc.
> 
>  (2) Invokes the C test program included in this patch after the creation
>      and hands it a list of things to check appropriate to each object.
> 
>  (3) Asks the test program to check the creation time of each object
>      against that of the preceding object.
> 
>  (4) Makes various tests on the timestamps of the hardlinked file.
> 
> The patch also creates a C[*] test program to do the actual stat checking.
> The test program then does the following:
> 
>  (1) Compares the output of statx() to that of fstatat().
> 
>  (2) Optionally compares the timestamps to see that they're sensibly
>      ordered with respect to each other.
> 
>  (3) Optionally compares the timestamps to those of a reference file.
> 
>  (4) Optionally compares the timestamps to a specified time.
> 
>  (5) Optionally compares selected stats to values specified on the command
>      line.
> 
>  (6) Optionally compares all the stats to those of a reference file,
>      requiring them to be the same (hard link checking).
> 
> For example:
> 
> 	./src/stat_test /dev/null \
> 	       stx_type=char \
> 	       stx_rdev_major=3 \
> 	       stx_rdev_minor=8 \
> 	       stx_nlink=1 \
> 	       ref=/dev/zero \
> 	       ts=B,b
> 
> The test program can also be given a --check-statx parameter to give a
> quick exit code-based answer on whether statx() exists within the kernel.
> 
> [*] Note that it proved much easier to do this in C than trying to do it in
>     shell script and trying parsing the output of xfs_io.  Using xfs_io has
>     other pitfalls also: it wants to *open* the file, even if the file is
>     not an appropriate type for this or does not grant permission to do so.
>     I can get around this by opening O_PATH, but then xfs_io fails to
>     handle XFS files because it wants to issue ioctls on every fd it opens.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---

...

> diff --git a/src/stat_test.c b/src/stat_test.c
> new file mode 100644
> index 0000000..f1f1756
> --- /dev/null
> +++ b/src/stat_test.c

I saw the same "may be used uninitialized" warning compiling this, gcc
4.8.5 shipped by RHEL7.3

...

> diff --git a/tests/generic/420 b/tests/generic/420
> new file mode 100755
> index 0000000..d772815
> --- /dev/null
> +++ b/tests/generic/420
> @@ -0,0 +1,181 @@
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
> +status=0
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
> +_require_test_program "stat_test"
> +_require_statx
> +_require_command "$NC_PROG" nc
> +
> +function check_stat () {
> +    $here/src/stat_test $*
> +}
> +
> +###############################################################################
> +#
> +# Check statx'ing of various types of object
> +#
> +# After each object is created, barring the first, we check that the creation
> +# time and the change time of the new object as same as or later than the
> +# corresponding timestamps on the previous object created.
> +#
> +###############################################################################
> +echo "Test statx on a fifo"
> +mkfifo -m 0600 $TEST_DIR/$seq-fifo

Because TEST_DEV is not re-created by default, these test files should
be removed either before creating them or in _cleanup, otherwise test
fails as:

     Test statx on a fifo
    +mkfifo: cannot create fifo '/mnt/testarea/test/420-fifo': File exists
     Test statx on a chardev
    +mknod: '/mnt/testarea/test/420-null': File exists
     Test statx on a directory
    +mkdir: cannot create directory '/mnt/testarea/test/420-dir': File exists
    ...

I think adding "rm -rf $TEST_DIR/$seq*" in _cleanup would make it work.

...

> +echo "Test statx on an AF_UNIX socket"
> +coproc SERVER { $NC_PROG -U -l $TEST_DIR/$seq-sock </dev/null; };
> +nc -U $TEST_DIR/$seq-sock </dev/null;
> +wait
> +check_stat $TEST_DIR/$seq-sock \
> +	   ts_order \
> +	   ref=$TEST_DIR/$seq-symlink \
> +	   ts=B,b \
> +	   ts=M,m \
> +	   stx_type=sock \
> +	   stx_rdev_major=0 \
> +	   stx_rdev_minor=0 \
> +	   stx_nlink=1

Along with the "-U option not being recognized" issue on Debian, I also
noticed nc hanging there and waiting for input thus hung the whole test,
but it's rare and hard to reproduce. Just FYI.

> +
> +#
> +# Test hard link creation.  Make sure that the file's ctime is now same as or
> +# later than the creation time of the socket, but that the file's creation time
> +# still lies somewhere between those of the directory and the socket.
> +#
> +echo "Test a hard link to a file"
> +ln $TEST_DIR/$seq-file $TEST_DIR/$seq-link
> +check_stat $TEST_DIR/$seq-link \
> +	   ref=$TEST_DIR/$seq-dir \
> +	   ts=B,b \
> +	   ref=$TEST_DIR/$seq-sock \
> +	   ts=b,B \
> +	   ts=B,c \
> +	   ts=C,c \
> +	   ref=$TEST_DIR/$seq-file \
> +	   cmp_ref \
> +	   stx_nlink=2
> +
> +# optional stuff if your test has verbose output to help resolve problems
> +#echo
> +#echo "If failure, check $seqres.full (this) and $seqres.full.ok (reference)"

Above comments can be removed, they're in template for document purpose.

Thanks,
Eryu
