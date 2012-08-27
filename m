Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RNoVgY004468 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 18:50:31 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id pmTy9aFkwS2A7WfG for <xfs@oss.sgi.com>;
	Mon, 27 Aug 2012 16:51:21 -0700 (PDT)
Message-ID: <503C07F4.2080706@sandeen.net>
Date: Mon, 27 Aug 2012 18:51:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Add test case to test xfs projid32bit
	functionality a bit more extensively.
References: <CAFZPdfjeDGXfhAP4hnnrdA6Fpr18pEq6vH726HpfduPp6vw3-A@mail.gmail.com>
In-Reply-To: <CAFZPdfjeDGXfhAP4hnnrdA6Fpr18pEq6vH726HpfduPp6vw3-A@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Boris Ranto <ranto.boris@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 8/27/12 5:04 AM, Boris Ranto wrote:
>  The test covers several areas including enabling projid32bit functionality dynamically by xfs_admin, dumping, restoring, quota reporting and xfs_db projid values reporting.
>  At the time of creation, the test hit two bugs: one for broken xfsdump/xfsrestore functionality and one for enabling projid32bit functionality with xfs_admin on a LVM device (SCRATCH_DEV must be an LVM device to hit this).

FWIW, with a bit of investigation I think the lvm behavior may be an lvm bug.  IOW this should never happen;
somehow buffered IO to the LVM device seems to be getting lost:

# xfs_db -r -c version  /dev/mapper/vg-01-xfscratch 
versionnum [0xb4a4+0x8a] = V4,NLINK,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT

# echo 3 > /proc/sys/vm/drop_caches 

# xfs_db -r -c version  /dev/mapper/vg-01-xfscratch 
versionnum [0xb4e4+0xa] = V4,NLINK,QUOTA,ALIGN,DIRV2,LOGV2,EXTFLG,MOREBITS,ATTR2,LAZYSBCOUNT

But I guess the test itself doesn't explicitly require lvm, so no big deal there.

What is the point of using loopback during dump & restore?  Why not just dump to $tmp
and restore to $SCRATCH_DEV, either after a fresh mkfs, or to a subdir of the existing
filesystem?

I get nervous about the loopback handling complexity....

-Eric

> Signed-off-by: Boris Ranto <ranto.boris@gmail.com <mailto:ranto.boris@gmail.com>>
> ---
>  285     |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  285.out |   27 +++++++++++
>  group   |    1 +
>  3 files changed, 179 insertions(+), 0 deletions(-)
>  create mode 100644 285
>  create mode 100644 285.out
> 
> diff --git a/285 b/285
> new file mode 100644
> index 0000000..c700bdf
> --- /dev/null
> +++ b/285
> @@ -0,0 +1,151 @@
> +#! /bin/bash
> +# FS QA Test No. 285
> +#
> +# Test to verify project quota xfs_admin, xfsdump/xfsrestore and
> +# xfs_db functionality
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2012 Boris Ranto.  All Rights Reserved.
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
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=borix60@gnamil.com <mailto:borix60@gnamil.com>
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +tmp=/tmp/$$
> +here=`pwd`
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.quota
> +
> +_cleanup()
> +{
> +    cd /
> +    umount $SCRATCH_MNT 2>/dev/null
> +    losetup -d $lo_dev >/dev/null 2>&1
> +    rm -rf $tmp.*
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_quota
> +_require_scratch
> +_require_projid32bit
> +
> +export MOUNT_OPTIONS="-opquota"
> +
> +# create xfs fs without projid32bit ability, will be gained by xfs_admin
> +_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seq.full || _fail "mkfs failed"
> +_qmount
> +# require project quotas
> +_require_prjquota $SCRATCH_DEV
> +
> +dir=$SCRATCH_MNT/pquota
> +
> +status=1
> +
> +mkdir -p $dir
> +touch $dir/{16,32}less
> +inode16a=$(ls -i $dir/16less|cut -d ' ' -f 1)
> +inode32a=$(ls -i $dir/32less|cut -d ' ' -f 1)
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/16less 1234" $SCRATCH_DEV \
> +        >> $seq.full
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
> +        >> $seq.full 2>&1
> +# These will be checked by $seq.out
> +echo "No 32bit project quotas:"
> +$XFS_IO_PROG -r -c "lsproj" $dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32less
> +
> +umount $SCRATCH_MNT
> +
> +# Now, enable projid32bit support by xfs_admin
> +xfs_admin -p $SCRATCH_DEV > /dev/null 2>&1
> +echo "xfs_admin returned $?"
> +
> +# Now mount the fs, 32bit project quotas shall be supported, now
> +_qmount
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
> +        >> $seq.full
> +
> +# These will be checked by $seq.out
> +echo "With 32bit project quota support:"
> +$XFS_IO_PROG -r -c "lsproj" $dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32less
> +
> +# Dump the fs to a temporary file
> +rm -f $tmp.dump.img
> +$XFSDUMP_PROG -f $tmp.dump -L label -M media -l 0 $SCRATCH_MNT >> $seq.full  || _fail "dump failed"
> +echo "xfsdump returned $?"
> +
> +# Prepare the device to restore the dumped file system
> +lo_dev=$(losetup -f)
> +lo_img=$tmp.img
> +lo_mnt=$tmp.dir
> +lo_dir=$lo_mnt/pquota
> +
> +rm -f $lo_img
> +mkdir -p $lo_mnt
> +
> +# Now, create the filesystem with projid32bit feature
> +$XFS_IO_PROG -f -c 'truncate 1g' $lo_img
> +losetup $lo_dev $lo_img
> +$MKFS_XFS_PROG $lo_dev -i projid32bit=1 >> $seq.full
> +mount $lo_dev $lo_mnt -opquota
> +
> +# Restore
> +$XFSRESTORE_PROG -f $tmp.dump $lo_mnt > /dev/null 2>&1
> +echo "xfsrestore returned $?"
> +
> +# Check that they are the same
> +diff -urpN $SCRATCH_MNT $lo_mnt
> +echo "diff returned $?"
> +touch $lo_dir/32lessv2
> +inode16b=$(ls -i $lo_dir/16less|cut -d ' ' -f 1)
> +inode32b=$(ls -i $lo_dir/32less|cut -d ' ' -f 1)
> +inode32v2=$(ls -i $lo_dir/32lessv2|cut -d ' ' -f 1)
> +$XFS_QUOTA_PROG -x -c "project -s -p $lo_dir/32lessv2 2123456789" $lo_mnt \
> +        >> $seq.full
> +echo "The restored file system + one additional file:"
> +$XFS_IO_PROG -r -c "lsproj" $lo_dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $lo_dir/32less
> +$XFS_IO_PROG -r -c "lsproj" $lo_dir/32lessv2
> +
> +umount $SCRATCH_MNT
> +umount $lo_mnt
> +
> +# Now, we can examine the file systems with xfs_db
> +# These two should report the same values
> +echo "These two values of 16bit project quota ids shall be the same"
> +$XFS_DB_PROG -c "inode $inode16a" -c "print core.projid_lo" -c "print core.projid_hi" $SCRATCH_DEV
> +$XFS_DB_PROG -c "inode $inode16b" -c "print core.projid_lo" -c "print core.projid_hi" $lo_dev
> +
> +# These three should report the same values
> +echo "These three values of 32bit project quota ids shall be the same"
> +$XFS_DB_PROG -c "inode $inode32a" -c "print core.projid_lo" -c "print core.projid_hi" $SCRATCH_DEV
> +$XFS_DB_PROG -c "inode $inode32b" -c "print core.projid_lo" -c "print core.projid_hi" $lo_dev
> +$XFS_DB_PROG -c "inode $inode32v2" -c "print core.projid_lo" -c "print core.projid_hi" $lo_dev
> +
> +losetup -d $lo_dev
> +rm -f $lo_img
> +
> +status=0
> +exit
> diff --git a/285.out b/285.out
> new file mode 100644
> index 0000000..a601452
> --- /dev/null
> +++ b/285.out
> @@ -0,0 +1,27 @@
> +QA output created by 285
> +No 32bit project quotas:
> +projid = 1234
> +projid = 0
> +xfs_admin returned 0
> +With 32bit project quota support:
> +projid = 1234
> +projid = 2123456789
> +xfsdump returned 0
> +xfsrestore returned 0
> +diff returned 0
> +The restored file system + one additional file:
> +projid = 1234
> +projid = 2123456789
> +projid = 2123456789
> +These two values of 16bit project quota ids shall be the same
> +core.projid_lo = 1234
> +core.projid_hi = 0
> +core.projid_lo = 1234
> +core.projid_hi = 0
> +These three values of 32bit project quota ids shall be the same
> +core.projid_lo = 24853
> +core.projid_hi = 32401
> +core.projid_lo = 24853
> +core.projid_hi = 32401
> +core.projid_lo = 24853
> +core.projid_hi = 32401
> diff --git a/group b/group
> index 104ed35..bbc74fe 100644
> --- a/group
> +++ b/group
> @@ -403,3 +403,4 @@ deprecated
>  282 dump ioctl auto quick
>  283 dump ioctl auto quick
>  284 auto
> +285 auto dump quota
> -- 
> 1.7.1
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
