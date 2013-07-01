Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F2667F55
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 15:38:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 491F98F8037
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 13:38:23 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id KjYG45oMeEGfWrCz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jul 2013 13:38:21 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4BEE07C0427
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 14:38:21 -0600 (MDT)
Date: Mon, 1 Jul 2013 16:38:18 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v2] xfstests: btrfs/316: cross-subvolume sparse copy
Message-ID: <20130701203818.GH4288@localhost.localdomain>
References: <51D19DF9.2080007@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51D19DF9.2080007@oracle.com>
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
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 01, 2013 at 05:19:21PM +0200, Koen De Wit wrote:
> This testscript creates reflinks to files on different subvolumes,
> overwrites the original files and reflinks, and moves reflinked files
> between subvolumes.
> 
> Originally submitted as testcase 302, changes are made based on comments
> from Eric: http://oss.sgi.com/archives/xfs/2013-03/msg00231.html
> Two new common/rc functions used in this script (_require_cp_reflink and
> _verify_reflink) have been submitted recently:
> http://oss.sgi.com/archives/xfs/2013-05/msg00745.html
> Thanks to Eric Sandeen and Dave Chinner for the reviews.
> 
> Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
> ---
>  tests/btrfs/316     |  130
> +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/316.out |   39 +++++++++++++++
>  tests/btrfs/group   |    1 +
>  3 files changed, 170 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/316
>  create mode 100644 tests/btrfs/316.out
> 
> diff --git a/tests/btrfs/316 b/tests/btrfs/316
> new file mode 100755
> index 0000000..7c9c368
> --- /dev/null
> +++ b/tests/btrfs/316
> @@ -0,0 +1,130 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/316
> +#
> +# Testing cross-subvolume sparse copy on btrfs
> +#    - Create two subvolumes, mount one of them
> +#    - Create a file on each (sub/root)volume,
> +#      reflink them on the other volumes
> +#    - Change one original and two reflinked files
> +#    - Move reflinked files between subvolumes
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
> +    umount $SCRATCH_MNT
> +    rm -rf $TESTDIR1
> +    rm -rf $TESTDIR2
> +    btrfs subvolume delete $SUBVOL1 >> $seqres.full
> +    btrfs subvolume delete $SUBVOL2 >> $seqres.full
> +    cd /
> +    rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +_require_scratch
> +_require_cp_reflink
> +
> +_checksum_files() {
> +    for F in file1 file2 file3
> +    do
> +        for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
> +        do
> +            md5sum $D/$F | _filter_test_dir | _filter_scratch
> +        done
> +    done
> +}
> +
> +TESTDIR1=$TEST_DIR/test-$seq-1
> +TESTDIR2=$TEST_DIR/test-$seq-2
> +SUBVOL1=$TEST_DIR/subvol-$seq-1
> +SUBVOL2=$TEST_DIR/subvol-$seq-2
> +
> +_scratch_unmount 2>/dev/null
> +rm -rf $seqres.full
> +rm -rf $TESTDIR1 $TESTDIR2
> +btrfs subvol delete $SUBVOL1 >/dev/null 2>&1
> +btrfs subvol delete $SUBVOL2 >/dev/null 2>&1
> +
> +mkdir $TESTDIR1
> +mkdir $TESTDIR2
> +btrfs subvolume create $SUBVOL1 >> $seqres.full
> +btrfs subvolume create $SUBVOL2 >> $seqres.full
> +_mount -t btrfs -o subvol=subvol-$seq-1 $TEST_DEV $SCRATCH_MNT
> +
> +echo "Create initial files"
> +# TESTDIR1/file1 is very small and will be inlined
> +$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 10' $TESTDIR1/file1 >> $seqres.full
> +$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 13000' $SCRATCH_MNT/file2 >>
> $seqres.full
> +$XFS_IO_PROG -f -c 'pwrite -S 0x63 0 17000' $SUBVOL2/file3 >> $seqres.full
> +
> +echo "Create reflinks to the initial files on other subvolumes"
> +cp --reflink $TESTDIR1/file1 $SUBVOL1
> +cp --reflink $TESTDIR1/file1 $SUBVOL2
> +cp --reflink $SUBVOL1/file2 $TESTDIR1/
> +cp --reflink $SUBVOL1/file2 $SUBVOL2
> +cp --reflink $SUBVOL2/file3 $TESTDIR1/
> +cp --reflink $SUBVOL2/file3 $SUBVOL1
> +
> +echo "Verify the reflinks"
> +_verify_reflink $SCRATCH_MNT/file2 $TESTDIR1/file2
> +_verify_reflink $SCRATCH_MNT/file2 $SUBVOL2/file2
> +_verify_reflink $SUBVOL2/file3 $TESTDIR1/file3
> +_verify_reflink $SUBVOL2/file3 $SCRATCH_MNT/file3
> +echo "Verify the file contents:"
> +_checksum_files
> +
> +echo -e "---\nOverwrite some files with new content"
> +$XFS_IO_PROG -c 'pwrite -S 0x64 0 20' $TESTDIR1/file1 >> $seqres.full
> +$XFS_IO_PROG -c 'pwrite -S 0x66 0 21000' $SUBVOL2/file2 >> $seqres.full
> +$XFS_IO_PROG -c 'pwrite -S 0x65 5000 5000' $SCRATCH_MNT/file3 >>
> $seqres.full


Line wrapped here ^^, patch won't apply cleanly.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
