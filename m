Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q860UtKK170782 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 19:30:56 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FLHJnT1YX1HDLpIj for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 17:31:53 -0700 (PDT)
Date: Thu, 6 Sep 2012 10:31:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests: Add test case to test xfs projid32bit
	functionality a bit more extensively.
Message-ID: <20120906003150.GM15292@dastard>
References: <CAFZPdfg+5kRfUuVOtRk1pqKrRai6CZBxisvXnuPUr-_SNAmGTg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFZPdfg+5kRfUuVOtRk1pqKrRai6CZBxisvXnuPUr-_SNAmGTg@mail.gmail.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Tue, Aug 28, 2012 at 02:59:42PM +0200, Boris Ranto wrote:
>  The test covers several areas including enabling projid32bit
> functionality dynamically by xfs_admin, dumping, restoring, quota
> reporting and xfs_db projid values reporting.
>  This test case hits two bugs: one for broken xfsdump/xfsrestore
> functionality and one for enabling projid32bit functionality with
> xfs_admin on a LVM device (SCRATCH_DEV must be an LVM device to hit
> this).

The LVM problem is incidental - if there's a problem with LVM
devices then xfs_db should show the same problem, as should all
other xfs_admin commands that use xfs_db. Hence I don't think that
there is any point in mentioning it here.

>  This version does not create/handle any loop devices.
> 
> Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
> ---
>  285     |  138 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  285.out |   27 ++++++++++++
>  group   |    1 +
>  3 files changed, 166 insertions(+), 0 deletions(-)
>  create mode 100644 285
>  create mode 100644 285.out
> 
> diff --git a/285 b/285
> new file mode 100644
> index 0000000..ad96aa6
> --- /dev/null
> +++ b/285
> @@ -0,0 +1,138 @@
> +#! /bin/bash
> +# FS QA Test No. 285
> +#
> +# Test to verify project quota xfs_admin, xfsdump/xfsrestore and
> +# xfs_db functionality
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2012 Boris Ranto.  All Rights Reserved.

Shouldn't this be Red Hat?

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
> +owner=ranto.boris@gmail.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +tmp=/tmp/$$
> +here=`pwd`
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +rm -f $seq.full
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.quota
> +
> +_cleanup()
> +{
> +    cd /
> +    umount $SCRATCH_MNT 2>/dev/null
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

Kill that - '_qmount_option "pquota"' is the preferred way to do
specific project quota configuration mounts.

> +
> +# create xfs fs without projid32bit ability, will be gained by xfs_admin
> +_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seq.full || _fail
> "mkfs failed"

You need to turn off line wrapping when you post patches.

> +_qmount

_qmount_option "pquota"

> +# require project quotas
> +_require_prjquota $SCRATCH_DEV
> +
> +dir=$SCRATCH_MNT/pquota
> +
> +status=1
> +
> +mkdir -p $dir
> +touch $dir/{16,32}less

"less" is a weird filename suffix. What's it mean? Why not just
something standard like "test"?

> +inode16a=$(ls -i $dir/16less|cut -d ' ' -f 1)
> +inode32a=$(ls -i $dir/32less|cut -d ' ' -f 1)
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/16less 1234" $SCRATCH_DEV \
> +        >> $seq.full
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
> +        >> $seq.full 2>&1
> +# These will be checked by $seq.out

No need for comments like this

> +echo "No 32bit project quotas:"
> +$XFS_IO_PROG -r -c "lsproj" $dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32less
> +
> +umount $SCRATCH_MNT
> +
> +# Now, enable projid32bit support by xfs_admin
> +xfs_admin -p $SCRATCH_DEV > /dev/null 2>&1

Output to $seq.full, and use the _fail script if xfs-admin returned
an error.

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
> +$XFSDUMP_PROG -f $tmp.dump -L label -M media -l 0 $SCRATCH_MNT >>
> $seq.full  || _fail "dump failed"
> +echo "xfsdump returned $?"

If xfsdump failed, this won't be run. If it succeeded, the output
will always be zero. So this sort of output is not needed.

> +# Prepare the device to restore the dumped file system
> +dir=$SCRATCH_MNT/restore/pquota

This is just confusing - the same variable points to different
directories in different parts of the test. A good reason for
separating the tests.

> +# Just make the restore dir, the pquota dir will be created by xfsrestore
> +mkdir -p $SCRATCH_MNT/restore
> +
> +# Restore
> +$XFSRESTORE_PROG -f $tmp.dump $SCRATCH_MNT/restore > /dev/null 2>&1
> +echo "xfsrestore returned $?"
> +
> +# Check that they are the same
> +diff -urpN $SCRATCH_MNT/{,restore}/pquota
> +echo "diff returned $?"

_fail if diff returned somethign non-zero.

> +touch $dir/32lessv2
> +inode16b=$(ls -i $dir/16less|cut -d ' ' -f 1)
> +inode32b=$(ls -i $dir/32less|cut -d ' ' -f 1)
> +inode32v2=$(ls -i $dir/32lessv2|cut -d ' ' -f 1)
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/32lessv2 2123456789" $SCRATCH_MNT \
> +        >> $seq.full

Why do you shorten some long lines, and not others...

> +echo "The restored file system + one additional file:"
> +$XFS_IO_PROG -r -c "lsproj" $dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32lessv2
> +
> +umount $SCRATCH_MNT
> +
> +# Now, we can examine the file systems with xfs_db
> +# These two should report the same values
> +echo "These two values of 16bit project quota ids shall be the same"

No need to output this into the out file. The comment says it all,
and we don't need the text in the output file to test for test
failure.

> +$XFS_DB_PROG -c "inode $inode16a" -c "print core.projid_lo" -c "print
> core.projid_hi" $SCRATCH_DEV

$XFS_DB_PROG -c "inode $inode16a" \
	-c "print core.projid_lo" \
	-c "print core.projid_hi" \
	$SCRATCH_DEV

	or, because it's called 5 times:

_print_projid()
{

	$XFS_DB_PROG -c "inode $1" \
		-c "print core.projid_lo" \
		-c "print core.projid_hi" \
		$SCRATCH_DEV
}

_print_projid $inode16a
_print_projid $inode16b
_print_projid $inode32a
_print_projid $inode32b
_print_projid $inode32v2

> +$XFS_DB_PROG -c "inode $inode16b" -c "print core.projid_lo" -c "print
> core.projid_hi" $SCRATCH_DEV
> +
> +# These three should report the same values
> +echo "These three values of 32bit project quota ids shall be the same"
> +$XFS_DB_PROG -c "inode $inode32a" -c "print core.projid_lo" -c "print
> core.projid_hi" $SCRATCH_DEV
> +$XFS_DB_PROG -c "inode $inode32b" -c "print core.projid_lo" -c "print
> core.projid_hi" $SCRATCH_DEV
> +$XFS_DB_PROG -c "inode $inode32v2" -c "print core.projid_lo" -c
> "print core.projid_hi" $SCRATCH_DEV
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

And quick.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
