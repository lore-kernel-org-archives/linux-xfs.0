Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B60727F51
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 18:24:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88C45304043
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 16:24:50 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Iqjps7bKI8VfBS19 for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 16:24:48 -0800 (PST)
Message-ID: <513BD2CF.5020204@sandeen.net>
Date: Sat, 09 Mar 2013 18:24:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 301: sparse copy between different
	filesystems/mountpoints on btrfs
References: <50F9C331.9000501@oracle.com>
In-Reply-To: <50F9C331.9000501@oracle.com>
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
> 
> ---
> 301     |   95 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   301.out |    7 ++++
>   2 files changed, 102 insertions(+), 0 deletions(-)
>   create mode 100644 301
>   create mode 100644 301.out


> Invalid cross-device link
> +0

Seems like the above lines should be at the end of the patch (?)
 
> diff --git a/301 b/301
> new file mode 100644
> index 0000000..05b9b39
> --- /dev/null
> +++ b/301
> @@ -0,0 +1,95 @@
> +#! /bin/bash
> +# FS QA Test No. 301
> +#
> +# Check if creating a sparse copy ("reflink") of a file on btrfs
> +# expectedly fails when it's done betweeen different filesystems or
> +# different mount points of the same filesystem.
> +#
> +# For both situations, these actions are executed:
> +#    - Copy a file with the reflink=auto option.
> +#      A normal copy should be created.
> +#    - Copy a file with the reflink=always option. Should result in error,
> +#      no file should be created.
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
> +_require_scratch
> +_require_cp_reflink

same deal, need thisdefinition

> +
> +TESTDIR1=$TEST_DIR/test-$seq.$$
> +TESTDIR2=$SCRATCH_MNT/test-$seq.$$
> +TESTDIR3=$SCRATCH_MNT/test-bis-$seq.$$

I might drop the .$$ for reasons stated earlier, etc.

You might also consider not naming something on $SCRATCH_MNT
as $TESTDIR when there's another standard variable named $TEST_DIR -
it's confusing.  Maybe name them as TEST_SOURCEDIR,
SCRATCH_TARGETDIR1, or similar, to make it easier to keep it
straight when reading the test.

> +
> +mkdir $TESTDIR1
> +_scratch_mkfs
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original > /dev/null
> +
> +_filter_testdirs()
> +{
> +    sed -e "s,$TESTDIR1,TESTDIR1,g" \
> +        -e "s,$TESTDIR2,TESTDIR2,g" \
> +        -e "s,$TESTDIR3,TESTDIR3,g"
> +}
> +
> +_create_reflinks_to()
> +{
> +    mkdir $1
> +    cp --reflink=auto $TESTDIR1/original $1/copy
> +    md5sum $1/copy | $AWK_PROG 'END {print $1}'

for more output context:

md5sum $1/copy | _filter_testdirs

> +    rm -rf $1
> +    mkdir $1
> +    cp --reflink=always $TESTDIR1/original $1/copyfail 2>&1 | 
> _filter_testdirs

patch wrapped

> +    ls $1/copyfail | wc -l

Here if you dropped the $$ from the filename and did:

ls $1/copyfail | _filter_testdirs

the output might be more informative on a failure?

> +}
> +
> +_scratch_mount
> +_create_reflinks_to $TESTDIR2
> +_scratch_unmount
> +
> +mount $TEST_DEV $SCRATCH_MNT
> +_create_reflinks_to $TESTDIR3
> +umount $SCRATCH_MNT

TBH this confuses me, not that it's necessarily wrong (?)
You mount TEST_DEV on $SCRATCH_MNT which makes my brain hurt a little.
Then _create_reflinks_to $TESTDIR3 and at that point, um, what's going on,
what's linking what to where?

Some comments about what is being tested & the expected result,
maybe w/ echos like mentioned before, and descriptive var names
would help me, at least.

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/301.out b/301.out
> new file mode 100644
> index 0000000..3b66682
> --- /dev/null
> +++ b/301.out
> @@ -0,0 +1,7 @@
> +QA output created by 301
> +42d69d1a6d333a7ebdf64792a555e392
> +cp: failed to clone `TESTDIR2/copyfail' from `TESTDIR1/original': Invalid cross-device link

Hm, my cp fails like:

+cp: failed to clone `TESTDIR3/copyfail': Invalid cross-device link

so might need a special filter to catch both variants.

> +0
> +42d69d1a6d333a7ebdf64792a555e392
> +cp: failed to clone `TESTDIR3/copyfail' from `TESTDIR1/original': 

malformed patch, supposed to be 7 new lines but only 6.

Thanks,
-Eric
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
