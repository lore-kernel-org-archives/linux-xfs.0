Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EFE647F6A
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 11:22:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B210630405F
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 09:22:24 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZgNAaVkmJQshnPFB for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 09:22:23 -0800 (PST)
Message-ID: <513B6FCD.5080103@sandeen.net>
Date: Sat, 09 Mar 2013 11:22:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 297: simple sparse copy testcase for btrfs
References: <50F9C313.1000903@oracle.com>
In-Reply-To: <50F9C313.1000903@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Koen De Wit <koen.de.wit@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 1/18/13 3:48 PM, Koen De Wit wrote:
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>

Sorry for the late review.  Better late than never?

cc'ing linux-btrfs - in general a good idea so btrfs experts
can evaluate the test as well.

> ---
> 297     |   75 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   297.out |   10 ++++++++
>   2 files changed, 85 insertions(+), 0 deletions(-)
>   create mode 100644 297
>   create mode 100644 297.out
> 
> diff --git a/297 b/297
> new file mode 100644
> index 0000000..0851b57
> --- /dev/null
> +++ b/297
> @@ -0,0 +1,75 @@
> +#! /bin/bash
> +# FS QA Test No. 297
> +#
> +# Tests file clone functionality of btrfs ("reflinks"):
> +#   - Reflink a file
> +#   - Reflink the reflinked file
> +#   - Modify the original file
> +#   - Modify the reflinked file
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013, Oracle and/or its affiliates.  All Rights Reserved.
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
> +# creator
> +owner=koen.de.wit@oracle.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +_supported_fs btrfs

I wonder if it'd be nice to make the test generic, but test whether
the filesystem supports reflinks, and bail if not.

> +_supported_os Linux
> +
> +_require_cp_reflink

where does _require_cp_reflink come from?

Also, as for missing bits, need to add new tests to the group
with each patch (I see you added them all in the last patch you sent).

> +
> +TESTDIR1=$TEST_DIR/test-$seq.$$
> +mkdir $TESTDIR1

This has some remote possibility of failure, right, if we happen
to run across the same pid.

How about:

+TESTDIR1=$TEST_DIR/test-$seq
+rm -rf TESTDIR1=$TEST_DIR/test-$seq
+mkdir $TESTDIR1

> +
> +_catfiles() {
> +    for F in original copy1 copy2
> +    do
> +        md5sum $TESTDIR1/$F | $AWK_PROG 'END {print $1}'
> +    done
> +}

Just a nitpick I guess but maybe _checksum_files would be more accurate.
It'd also be nicer to provide more context in the output - what file
is the checksum for?  What are we testing?

So maybe:

+_checksum_files() {
+    for F in original copy1 copy2
+    do
+        md5sum $TESTDIR1/$F | _filter_test_dir
+    done
+}

so then we'll have the filenames in the output.

And then, putting echos in make both the test and the output more self-documenting:

+echo "Create the original file filled with 0x61"
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original > /dev/null
+echo "And make 2 reflink copies to it"
> +cp --reflink $TESTDIR1/original $TESTDIR1/copy1
> +cp --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
+# Ensure that they all have the same md5sums at this point
+echo "Original md5sums:"
> +_catfiles
+echo "Overwrite original file with 0x62"
> +$XFS_IO_PROG -c 'pwrite -S 0x62 0 9000' $TESTDIR1/original > /dev/null
+echo "md5sums after overwriting original"
> +_catfiles
+echo "Overwrite copy1 with 0x63"
> +$XFS_IO_PROG -c 'pwrite -S 0x63 0 9000' $TESTDIR1/copy1 > /dev/null
+echo "md5sums after overwriting copy1:"
> +_catfiles
> +
> +# success, all done
> +status=0
> +exit

Then the test output looks like:

Create the original file filled with 0x61
And make 2 reflink copies to it
Original md5sums:
42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-307/original
42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-307/copy1
42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-307/copy2
Overwrite original file with 0x62
md5sums after overwriting original:
4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-307/original
42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-307/copy1
42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-307/copy2
Overwrite copy1 with 0x63
md5sums after overwriting copy1:
4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-307/original
e271cd47d9f62ebc96cb4e67ae4d16db  TEST_DIR/test-307/copy1
42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-307/copy2

so if anything goes wrong, we'll have more context in the output.

What do you think?

Thanks,
-Eric

> diff --git a/297.out b/297.out
> new file mode 100644
> index 0000000..39c498b
> --- /dev/null
> +++ b/297.out
> @@ -0,0 +1,10 @@
> +QA output created by 297
> +42d69d1a6d333a7ebdf64792a555e392
> +42d69d1a6d333a7ebdf64792a555e392
> +42d69d1a6d333a7ebdf64792a555e392
> +4a847a25439532bf48b68c9e9536ed5b
> +42d69d1a6d333a7ebdf64792a555e392
> +42d69d1a6d333a7ebdf64792a555e392
> +4a847a25439532bf48b68c9e9536ed5b
> +e271cd47d9f62ebc96cb4e67ae4d16db
> +42d69d1a6d333a7ebdf64792a555e392
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
