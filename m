Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 660847F58
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 18:25:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 560F5304048
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 16:25:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id f41tO59dG7X1BoDU for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 16:25:02 -0800 (PST)
Message-ID: <513BD2DD.6050609@sandeen.net>
Date: Sat, 09 Mar 2013 18:25:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 302: cross-subvolume sparse copies on btrfs
References: <50F9C339.6010000@oracle.com>
In-Reply-To: <50F9C339.6010000@oracle.com>
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
> 302     |  108 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   302.out |   28 ++++++++++++++++
>   2 files changed, 136 insertions(+), 0 deletions(-)
>   create mode 100644 302
>   create mode 100644 302.out
> 
> diff --git a/302 b/302
> new file mode 100644
> index 0000000..b7f7507
> --- /dev/null
> +++ b/302
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# FS QA Test No. 302
> +#
> +# Testing cross-subvolume sparse copy on btrfs
> +#    - Create two subvolumes, mount one of them
> +#    - Create a file on each (sub/root)volume,
> +#      reflink them on the other volumes
> +#    - Change one original and two reflinked files
> +#    - Move and delete files
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

should cleanup delete created subvols?

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

same basic stuff, need the above deifined somewehre,
add to groups, add some context to output & comments if
you would, to make it easier for future testers.

> +
> +_catfiles() {

_checksum_files

> +    for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
> +    do
> +        for F in file1 file2 file3
> +        do
> +            md5sum $D/$F | $AWK_PROG 'END {print $1}'

md5sum $D/$F | _filter_testdirs to get filenames?

> +        done
> +    done
> +}
> +
> +_scratch_unmount 2>/dev/null
> +TESTDIR1=$TEST_DIR/test-$seq.$$-1
> +TESTDIR2=$TEST_DIR/test-$seq.$$-2
> +SUBVOL1=$TEST_DIR/subvol-$seq.$$-1
> +SUBVOL2=$TEST_DIR/subvol-$seq.$$-2

same mild concern w/ using pids.

> +
> +mkdir $TESTDIR1
> +mkdir $TESTDIR2
> +btrfs subvolume create $SUBVOL1 > /dev/null
> +btrfs subvolume create $SUBVOL2 > /dev/null
> +mount -t btrfs -o subvol=subvol-$seq.$$-1 $TEST_DEV $SCRATCH_MNT

eek, $TEST_DEV on $SCRATCH_MNT again ;)  I guess we need some
more btrfs-aware basic infrastructure.

> +
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/file1 > /dev/null
> +$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 13000' $SCRATCH_MNT/file2 > /dev/null
> +$XFS_IO_PROG -f -c 'pwrite -S 0x63 0 17000' $SUBVOL2/file3 > /dev/null

echos & things to add context to the output file would help.

> +cp --reflink $TESTDIR1/file1 $SUBVOL1
> +cp --reflink $TESTDIR1/file1 $SUBVOL2
> +cp --reflink $SUBVOL1/file2 $TESTDIR1/
> +cp --reflink $SUBVOL1/file2 $SUBVOL2
> +cp --reflink $SUBVOL2/file3 $TESTDIR1/
> +cp --reflink $SUBVOL2/file3 $SUBVOL1



> +_catfiles
> +
> +$XFS_IO_PROG -c 'pwrite -S 0x64 0 9000' $TESTDIR1/file1 > /dev/null
> +$XFS_IO_PROG -c 'pwrite -S 0x66 7000 21000' $SUBVOL2/file2 > /dev/null
> +$XFS_IO_PROG -c 'pwrite -S 0x65 5000 5000' $SCRATCH_MNT/file3 > /dev/null
> +_catfiles
> +
> +mv $TESTDIR1/file* $TESTDIR2
> +mv $SCRATCH_MNT/file* $TESTDIR1/
> +mv $SUBVOL2/file* $SCRATCH_MNT/
> +mv $TESTDIR2/file* $SUBVOL2/
> +_catfiles
> +
> +rm -rf $TESTDIR1
> +rm -rf $TESTDIR2
> +umount $SCRATCH_MNT
> +btrfs subvolume delete $SUBVOL1 > /dev/null
> +btrfs subvolume delete $SUBVOL2 > /dev/null
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/302.out b/302.out
> new file mode 100644
> index 0000000..a4bc12e
> --- /dev/null
> +++ b/302.out
> @@ -0,0 +1,28 @@
> +QA output created by 302

you can imagine the problem here if, say, the 12th md5sum is wrong
in the output.  What's a tester to think? ;)

> +42d69d1a6d333a7ebdf64792a555e392
> +d7402b46310fbbfbc5e466b1dccb043b
> +5a95800e4c04b11117aa4e4de057721f
> +42d69d1a6d333a7ebdf64792a555e392
> +d7402b46310fbbfbc5e466b1dccb043b
> +5a95800e4c04b11117aa4e4de057721f
> +42d69d1a6d333a7ebdf64792a555e392
> +d7402b46310fbbfbc5e466b1dccb043b
> +5a95800e4c04b11117aa4e4de057721f
> +2e26ad0e8b8e123d18c2d20c81cab0a8
> +d7402b46310fbbfbc5e466b1dccb043b
> +5a95800e4c04b11117aa4e4de057721f
> +42d69d1a6d333a7ebdf64792a555e392
> +d7402b46310fbbfbc5e466b1dccb043b
> +b9f275cd638cb784c9e61def94c622a8
> +42d69d1a6d333a7ebdf64792a555e392
> +a229d0159dad76eecec390d9b1db16d3
> +5a95800e4c04b11117aa4e4de057721f
> +42d69d1a6d333a7ebdf64792a555e392
> +d7402b46310fbbfbc5e466b1dccb043b
> +b9f275cd638cb784c9e61def94c622a8
> +42d69d1a6d333a7ebdf64792a555e392
> +a229d0159dad76eecec390d9b1db16d3
> +5a95800e4c04b11117aa4e4de057721f
> +2e26ad0e8b8e123d18c2d20c81cab0a8
> +d7402b46310fbbfbc5e466b1dccb043b
> +5a95800e4c04b11117aa4e4de057721f
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
