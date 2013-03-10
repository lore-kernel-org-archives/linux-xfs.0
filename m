Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 104567F55
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 18:25:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83653AC001
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 16:24:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id m5OI35nEmvAB6Mx0 for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 16:24:56 -0800 (PST)
Message-ID: <513BD2D8.2030404@sandeen.net>
Date: Sat, 09 Mar 2013 18:24:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests: 303: send/receive functionality of btrfs
References: <50F9C340.5050309@oracle.com>
In-Reply-To: <50F9C340.5050309@oracle.com>
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
> 303     |  127 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   303.out |   72 +++++++++++++++++++++++++++++++++++
>   group   |    7 +++
>   3 files changed, 206 insertions(+), 0 deletions(-)
>   create mode 100644 303
>   create mode 100644 303.out
> 
> diff --git a/303 b/303
> new file mode 100644
> index 0000000..6a5628d
> --- /dev/null
> +++ b/303
> @@ -0,0 +1,127 @@
> +#! /bin/bash
> +# FS QA Test No. 303
> +#
> +# Tests btrfs send/receive functionality
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
> +    rm -f $tmp.*
> +    btrfs subvolume delete $MAINPATH | _filter_test_dir
> +    btrfs subvolume delete $TEST_DIR/snap1 | _filter_test_dir
> +    btrfs subvolume delete $TEST_DIR/snap2 | _filter_test_dir
> +    btrfs subvolume delete $TEST_DIR/snap3 | _filter_test_dir
> +    btrfs subvolume delete $TEST_DIR/snap4 | _filter_test_dir
> +}
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +_supported_os Linux
> +
> +_compare_to_main() {
> +    # Compare file contents
> +    diff -r $MAINPATH $1
> +        # Compare file attributes

nitpick but can you get consistent indentation here?

> +        ls -lR $MAINPATH | _filter_test_dir > $TEST_DIR/main-files
> +        ls -lR $1 | _filter_scratch > $TEST_DIR/compare-files
> +        diff $TEST_DIR/main-files $TEST_DIR/compare-files
> +}
> +
> +# Setup main subvolume
> +MAINPATH=$TEST_DIR/main
> +btrfs subvolume create $MAINPATH
> +
> +# Create btrfs filesystem on scratch disk
> +_scratch_mkfs
> +
> +# Create a directory and three files in the main subvolume.

Changing these comments to echos adds context to output

> +xfs_io -f -c 'pwrite -S 0x61 0 9000' $MAINPATH/file1 > /dev/null
> +xfs_io -f -c 'pwrite -S 0x62 0 11000' $MAINPATH/file2 > /dev/null
> +mkdir $MAINPATH/dir1
> +xfs_io -f -c 'pwrite -S 0x63 0 13000' $MAINPATH/dir1/file3 > /dev/null
> +xfs_io -f -c 'pwrite -S 0x64 0 15000' $MAINPATH/dir1/file4 > /dev/null
> +mkdir $MAINPATH/dir2
> +xfs_io -f -c 'pwrite -S 0x65 0 17000' $MAINPATH/dir1/file5 > /dev/null
> +
> +# Create a snapshot of main and replay on the scratch disk.
> +btrfs subvolume snapshot -r $MAINPATH $TEST_DIR/snap1 | _filter_test_dir
> +btrfs send $TEST_DIR/snap1 > $TEST_DIR/snap1.send | _filter_test_dir
> +btrfs receive -f $TEST_DIR/snap1.send $SCRATCH_MNT
> +_compare_to_main $SCRATCH_MNT/snap1
> +
> +# Change, add and delete files in the main subvolume.
> +xfs_io -c 'pwrite -S 0x66 5000 19000' $MAINPATH/dir1/file3 > /dev/null
> +rm $MAINPATH/file2
> +mkdir $MAINPATH/dir1/dir3
> +xfs_io -f -c 'pwrite -S 0x67 0 21000' $MAINPATH/dir1/dir3/file6 > /dev/null
> +chmod +x $MAINPATH/dir1/file4
> +
> +# Create a snapshot of main, the first snapshot being the parent.
> +btrfs subvolume snapshot -r $MAINPATH $TEST_DIR/snap2 | _filter_test_dir
> +btrfs send -p $TEST_DIR/snap1 $TEST_DIR/snap2 \
> + > $TEST_DIR/snap2.send | _filter_test_dir
> +btrfs receive -f $TEST_DIR/snap2.send $SCRATCH_MNT
> +_compare_to_main $SCRATCH_MNT/snap2
> +
> +# Reflink a new file and a file existing on another subvolume
> +cp --reflink $TEST_DIR/snap1/file2 $MAINPATH/dir1/dir3
> +xfs_io -f -c 'pwrite -S 0x68 0 23000' $TEST_DIR/file7 > /dev/null
> +cp --reflink $TEST_DIR/file7 $MAINPATH/dir2
> +
> +# Create a snapshot with a parent and clone source.
> +btrfs subvolume snapshot -r $MAINPATH $TEST_DIR/snap3 | _filter_test_dir
> +btrfs send -p $TEST_DIR/snap2 -i $TEST_DIR/snap1 $TEST_DIR/snap3 \
> + > $TEST_DIR/snap3.send | _filter_test_dir
> +btrfs receive -f $TEST_DIR/snap3.send $SCRATCH_MNT
> +_compare_to_main $SCRATCH_MNT/snap3
> +
> +# Error scenario: clone source does not exist on target disk
> +btrfs subvolume delete $SCRATCH_MNT/snap1 | _filter_scratch
> +btrfs subvolume delete $SCRATCH_MNT/snap3 | _filter_scratch
> +btrfs receive -f $TEST_DIR/snap3.send $SCRATCH_MNT 2>&1 | _filter_scratch
> +
> +# Error scenario: parent source does not exist on target disk
> +btrfs subvolume delete $SCRATCH_MNT/snap2 | _filter_scratch
> +btrfs receive -f $TEST_DIR/snap2.send $SCRATCH_MNT 2>&1 | _filter_scratch
> +
> +# Error scenario: snapshotting a writable subvolume
> +btrfs subvolume snapshot $MAINPATH $TEST_DIR/snap4 | _filter_test_dir
> +btrfs send $TEST_DIR/snap4 2>&1 | _filter_test_dir
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/303.out b/303.out
> new file mode 100644
> index 0000000..da4bec8
> --- /dev/null
> +++ b/303.out
> @@ -0,0 +1,72 @@
> +QA output created by 303
> +Create subvolume '/mnt/diskb/main'
> +/dev/sdf1 is mounted

Not sure what generated that devicename, but if it's expected output it needs
to be filtered.

> +Create a readonly snapshot of 'TEST_DIR/main' in 'TEST_DIR/snap1'
> +At subvol /mnt/diskb/snap1
> +At subvol snap1
> +1c1
> +< TEST_DIR/main:
> +---
> +> SCRATCH_MNT/snap1:
> +8c8
> +< TEST_DIR/main/dir1:
> +---
> +> SCRATCH_MNT/snap1/dir1:
> +14c14
> +< TEST_DIR/main/dir2:
> +---
> +> SCRATCH_MNT/snap1/dir2:
> +Create a readonly snapshot of 'TEST_DIR/main' in 'TEST_DIR/snap2'
> +At subvol /mnt/diskb/snap2
> +At snapshot snap2
> +1c1
> +< TEST_DIR/main:
> +---
> +> SCRATCH_MNT/snap2:
> +7,8c7,8
> +< TEST_DIR/main/dir1:
> +< total 60
> +---
> +> SCRATCH_MNT/snap2/dir1:
> +> total 72
> +14c14
> +< TEST_DIR/main/dir1/dir3:
> +---
> +> SCRATCH_MNT/snap2/dir1/dir3:
> +18c18
> +< TEST_DIR/main/dir2:
> +---
> +> SCRATCH_MNT/snap2/dir2:
> +Create a readonly snapshot of 'TEST_DIR/main' in 'TEST_DIR/snap3'
> +At subvol /mnt/diskb/snap3
> +At snapshot snap3
> +1c1
> +< TEST_DIR/main:
> +---
> +> SCRATCH_MNT/snap3:
> +7c7
> +< TEST_DIR/main/dir1:
> +---
> +> SCRATCH_MNT/snap3/dir1:
> +14c14
> +< TEST_DIR/main/dir1/dir3:
> +---
> +> SCRATCH_MNT/snap3/dir1/dir3:
> +19c19
> +< TEST_DIR/main/dir2:
> +---
> +> SCRATCH_MNT/snap3/dir2:
> +Delete subvolume 'SCRATCH_MNT/snap1'
> +Delete subvolume 'SCRATCH_MNT/snap3'
> +ERROR: Failed to lookup path for root 0 - No such file or directory
> +ERROR: unable to resolve path for root 257
> +Delete subvolume 'SCRATCH_MNT/snap2'
> +At snapshot snap2
> +ERROR: could not find parent subvolume
> +Create a snapshot of 'TEST_DIR/main' in 'TEST_DIR/snap4'
> +ERROR: TEST_DIR/snap4 is not read-only.
> +Delete subvolume 'TEST_DIR/main'
> +Delete subvolume 'TEST_DIR/snap1'
> +Delete subvolume 'TEST_DIR/snap2'
> +Delete subvolume 'TEST_DIR/snap3'
> +Delete subvolume 'TEST_DIR/snap4'
> diff --git a/group b/group
> index 1fdae31..af5356d 100644
> --- a/group
> +++ b/group
> @@ -412,3 +412,10 @@ deprecated
>   291 repair
>   292 auto mkfs quick
>   293 auto quick
> +297 auto rw
> +298 auto rw
> +299 auto rw
> +300 auto rw
> +301 auto rw
> +302 auto rw
> +303 auto
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
