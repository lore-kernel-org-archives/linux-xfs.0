Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8B2k1xD259292 for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 21:46:01 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id AcA9W5I9Fzeu09jd for <xfs@oss.sgi.com>;
	Mon, 10 Sep 2012 19:47:03 -0700 (PDT)
Message-ID: <504EA627.2050906@sandeen.net>
Date: Mon, 10 Sep 2012 21:47:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3] Add test case to test xfs projid32bit functionality
	a bit more extensively.
References: <CAFZPdfjKfZP85f8zCLxCOf__ZyBd=tKsvqRGS-_bcaR0P_JuWA@mail.gmail.com>
In-Reply-To: <CAFZPdfjKfZP85f8zCLxCOf__ZyBd=tKsvqRGS-_bcaR0P_JuWA@mail.gmail.com>
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

On 9/6/12 10:23 AM, Boris Ranto wrote:
>    The test covers several areas including enabling projid32bit
> functionality dynamically by xfs_admin, dumping, restoring, quota
> reporting and xfs_db projid values reporting.
>   This test case hits a bug with xfsdump/xfsrestore process on a
> projid32bit enabled filesystem.
> 
> Signed-off-by: Boris Ranto <ranto.boris@gmail.com>

there are just a couple things below, but I think we can get it
checked in unless Dave has further concerns - please see below.

> ---
>  285     |  144 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  285.out |   23 ++++++++++
>  group   |    1 +
>  3 files changed, 168 insertions(+), 0 deletions(-)
>  create mode 100644 285
>  create mode 100644 285.out
> 
> diff --git a/285 b/285
> new file mode 100644
> index 0000000..a1e497d
> --- /dev/null
> +++ b/285
> @@ -0,0 +1,144 @@
> +#! /bin/bash
> +# FS QA Test No. 285
> +#
> +# Test to verify project quota xfs_admin, xfsdump/xfsrestore and
> +# xfs_db functionality
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2012 Red Hat, Inc. All Rights Reserved.
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
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +rm -f $seq.full
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.quota
> +
> +_cleanup()
> +{
> +	cd /
> +	umount $SCRATCH_MNT 2>/dev/null
> +	rm -rf $tmp.*
> +}
> +
> +_print_projid()
> +{
> +	$XFS_DB_PROG -c "inode $1" \
> +		-c "print core.projid_lo" \
> +		-c "print core.projid_hi" \
> +		$SCRATCH_DEV
> +}
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_quota
> +_require_scratch
> +_require_projid32bit
> +
> +# create xfs fs without projid32bit ability, will be gained by xfs_admin
> +_scratch_mkfs_xfs -i projid32bit=0 -d size=200m >> $seq.full \
> +		|| _fail "mkfs failed"
> +_qmount_option "pquota"
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

Although I understand it ok, I might add a comment here saying:

# create files to hold 16 and 32-bit project IDs

In retrospect I might use 16bit and 32bit to make more sense.
Sorry, should have suggested that earlier.

I could just change the names on checkin with a note if that's ok with you.

> +inode16a=$(ls -i $dir/16less|cut -d ' ' -f 1)
> +inode32a=$(ls -i $dir/32less|cut -d ' ' -f 1)
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/16less 1234" $SCRATCH_DEV \
> +		>> $seq.full
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
> +		>> $seq.full 2>&1

It's a little weird to set project quota on a regular file, but I guess it works,
so I guess it's ok.  :)

So with those caveats I can do:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

and unless Dave has further comments I'll check it in in a bit.

Thanks,
-Eric

> +
> +echo "No 32bit project quotas:"
> +$XFS_IO_PROG -r -c "lsproj" $dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32less
> +
> +umount $SCRATCH_MNT
> +
> +# Now, enable projid32bit support by xfs_admin
> +xfs_admin -p $SCRATCH_DEV >> $seq.full 2>&1 || _fail "xfs_admin failed"
> +
> +# Now mount the fs, 32bit project quotas shall be supported, now
> +_qmount_option "pquota"
> +_qmount
> +$XFS_QUOTA_PROG -x -c "project -s -p $dir/32less 2123456789" $SCRATCH_DEV \
> +		>> $seq.full
> +
> +# These will be checked by $seq.out
> +echo "With 32bit project quota support:"
> +$XFS_IO_PROG -r -c "lsproj" $dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $dir/32less
> +
> +# Dump the fs to a temporary file
> +rm -f $tmp.dump.img
> +$XFSDUMP_PROG -f $tmp.dump -L label -M media -l 0 $SCRATCH_MNT >> $seq.full \
> +		|| _fail "dump failed"
> +
> +# Prepare the device to restore the dumped file system
> +restore_dir=$SCRATCH_MNT/restore/pquota
> +
> +# Just make the restore dir, the pquota dir will be created by xfsrestore
> +mkdir -p $SCRATCH_MNT/restore
> +
> +# Restore
> +$XFSRESTORE_PROG -f $tmp.dump $SCRATCH_MNT/restore >> $seq.full 2>&1 \
> +		|| _fail "xfsrestore failed"
> +
> +# Check that they are the same
> +diff -urpN $SCRATCH_MNT/{,restore}/pquota || _fail "diff failed"
> +
> +touch $restore_dir/32lessv2
> +inode16b=$(ls -i $restore_dir/16less|cut -d ' ' -f 1)
> +inode32b=$(ls -i $restore_dir/32less|cut -d ' ' -f 1)
> +inode32v2=$(ls -i $restore_dir/32lessv2|cut -d ' ' -f 1)
> +$XFS_QUOTA_PROG -x -c "project -s -p $restore_dir/32lessv2 2123456789" \
> +		$SCRATCH_MNT >> $seq.full
> +echo "The restored file system + one additional file:"
> +$XFS_IO_PROG -r -c "lsproj" $restore_dir/16less
> +$XFS_IO_PROG -r -c "lsproj" $restore_dir/32less
> +$XFS_IO_PROG -r -c "lsproj" $restore_dir/32lessv2
> +
> +umount $SCRATCH_MNT
> +
> +# Now, we can examine the file systems with xfs_db
> +echo "These two values of 16bit project quota ids shall be the same"
> +_print_projid $inode16a
> +_print_projid $inode16b
> +
> +echo "These three values of 32bit project quota ids shall be the same"
> +_print_projid $inode32b
> +_print_projid $inode32a
> +_print_projid $inode32v2
> +
> +status=0
> +exit
> diff --git a/285.out b/285.out
> new file mode 100644
> index 0000000..e5cc325
> --- /dev/null
> +++ b/285.out
> @@ -0,0 +1,23 @@
> +QA output created by 285
> +No 32bit project quotas:
> +projid = 1234
> +projid = 0
> +With 32bit project quota support:
> +projid = 1234
> +projid = 2123456789
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
