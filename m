Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C48A47F6A
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 11:46:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 458CBAC001
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 09:46:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KkaOnjT3TtnovNHS for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 09:46:39 -0800 (PST)
Message-ID: <513B757E.9070803@sandeen.net>
Date: Sat, 09 Mar 2013 11:46:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 298: sparse copy of a directory tree on btrfs
References: <50F9C31B.20203@oracle.com>
In-Reply-To: <50F9C31B.20203@oracle.com>
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

same basic comments as for the previous test:

need definition of _require_cp_reflink somewhere
need to add test to groups file
remove & recreate testdir to avoid collisions (or mktemp maybe?)
use _filter_test_dir in md5sum output to get more context
add test context to output file

also, the patch wrapped when sending, FWIW.

Oh, and thanks for writing these!

-Eric

> ---
> 298     |   82 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   298.out |   19 ++++++++++++++
>   2 files changed, 101 insertions(+), 0 deletions(-)
>   create mode 100644 298
>   create mode 100644 298.out
> 
> diff --git a/298 b/298
> new file mode 100644
> index 0000000..47ac55d
> --- /dev/null
> +++ b/298
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test No. 298
> +#
> +# Tests file clone functionality of btrfs ("reflinks") on directory trees.
> +#   - Create directory and subdirectory, each having one file
> +#   - Create 2 reflinked copies of the tree
> +#   - Modify the original files
> +#   - Modify one of the copies

adding these as echos at the appropriate places adds context to the output file.

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
> +_supported_os Linux
> +
> +_require_cp_reflink
> +
> +TESTDIR1=$TEST_DIR/test-$seq.$$
> +mkdir $TESTDIR1
> +
> +_catfiles() {
> +    for F in original/file1 original/subdir/file2 \
> +                 copy1/file1 copy1/subdir/file2 \
> +                 copy2/file1 copy2/subdir/file2
> +        do
> +        md5sum $TESTDIR1/$F | $AWK_PROG 'END {print $1}'
> +        done
> +}
> +
> +mkdir $TESTDIR1/original
> +mkdir $TESTDIR1/original/subdir
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original/file1 > /dev/null
> +$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 11000' $TESTDIR1/original/subdir/file2 > /dev/null
> +cp --recursive --reflink $TESTDIR1/original $TESTDIR1/copy1
> +cp --recursive --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
> +_catfiles
> +$XFS_IO_PROG -c 'pwrite -S 0x63 0 13000' $TESTDIR1/original/file1 > /dev/null
> +$XFS_IO_PROG -c 'pwrite -S 0x64 5000 1000' 
> $TESTDIR1/original/subdir/file2 > /dev/null
> +_catfiles
> +$XFS_IO_PROG -c 'pwrite -S 0x65 0 9000' $TESTDIR1/copy1/file1 > /dev/null
> +$XFS_IO_PROG -c 'pwrite -S 0x66 5000 25000' $TESTDIR1/copy1/subdir/file2 > /dev/null
> +_catfiles
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/298.out b/298.out
> new file mode 100644
> index 0000000..f8b6b70
> --- /dev/null
> +++ b/298.out
> @@ -0,0 +1,19 @@
> +QA output created by 298
> +42d69d1a6d333a7ebdf64792a555e392
> +ca390545f0aedb54b808d6128c56a7dd
> +42d69d1a6d333a7ebdf64792a555e392
> +ca390545f0aedb54b808d6128c56a7dd
> +42d69d1a6d333a7ebdf64792a555e392
> +ca390545f0aedb54b808d6128c56a7dd
> +260f6785c0537fd12582dcae28a3c1a9
> +b8d91fb600f6f2191f2ba66665374860
> +42d69d1a6d333a7ebdf64792a555e392
> +ca390545f0aedb54b808d6128c56a7dd
> +42d69d1a6d333a7ebdf64792a555e392
> +ca390545f0aedb54b808d6128c56a7dd
> +260f6785c0537fd12582dcae28a3c1a9
> +b8d91fb600f6f2191f2ba66665374860
> +b20229a003e3985c4b0e6806abcd6642
> +b815b24069db14e0a3a07169fd563e93
> +42d69d1a6d333a7ebdf64792a555e392
> +ca390545f0aedb54b808d6128c56a7dd
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
