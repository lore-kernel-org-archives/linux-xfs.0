Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CEjgGP261982 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 08:45:42 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qGzW8fQxrOunc2iC for
	<xfs@oss.sgi.com>; Thu, 12 Jan 2012 06:45:40 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0CEjda9012784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:45:39 -0500
Received: from andromeda.usersys.redhat.com (ovpn-113-80.phx2.redhat.com
	[10.3.113.80])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q0CEjZPl012074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:45:38 -0500
Date: Thu, 12 Jan 2012 12:45:35 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfstests 278: Ensure lost+found is not created with
	wrong link count (V4)
Message-ID: <20120112144534.GB1798@andromeda.usersys.redhat.com>
References: <1326377187-27344-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326377187-27344-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

Mark, can you test it and see if the statement I used to send repair
output to $seq.full will work on bash3? I haven't any system here using
bash 3.

Thanks
On Thu, Jan 12, 2012 at 12:06:27PM -0200, Carlos Maiolino wrote:
> xfs_repair was leaving lost+found directory with a wrong link count when a
> cleaned inode was re-used to create lost+found. This test case confirm that,
> after xfs_repair is executed, the lost+found inode is left in a consistent
> state.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  278     |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  278.out |    2 +
>  group   |    1 +
>  3 files changed, 90 insertions(+), 0 deletions(-)
>  create mode 100755 278
>  create mode 100644 278.out
> 
> diff --git a/278 b/278
> new file mode 100755
> index 0000000..89cae35
> --- /dev/null
> +++ b/278
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# FS QA Test No. 278
> +#
> +# Test xfs_repair to ensure it fixes the lost+found link count
> +# at the first run. See also commit 198b747f255346bca64408875763b6ca0ed3d57d
> +# from xfsprogs tree.
> +#
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
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
> +owner=cmaiolino@redhat.com
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
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
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_scratch_mkfs >/dev/null 2>&1
> +_scratch_mount
> +
> +mkdir -p $SCRATCH_MNT/dir/subdir
> +
> +#get inodes to be changed
> +DIR_INO=`ls -i $SCRATCH_MNT |awk '{print $1}'`
> +SUBDIR_INO=`ls -i $SCRATCH_MNT/dir |awk '{print $1}'`
> +
> +_scratch_unmount
> +
> +echo "Silence is goodness..."
> +
> +# Corrupt DIR
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seq.full
> +
> +# Corrupt SUBDIR
> +xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seq.full
> +xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seq.full
> +
> +echo "===== BEGIN of xfs_repair =====" >> $seq.full
> +echo "" >>$seq.full
> +
> +xfs_repair  $SCRATCH_DEV >> $seq.full 2>&1
> +echo "===== END of xfs_repair =====" >> $seq.full
> +
> +if _check_scratch_fs; then
> +	status=0
> +else
> +	status=1
> +fi
> +exit
> diff --git a/278.out b/278.out
> new file mode 100644
> index 0000000..2acd770
> --- /dev/null
> +++ b/278.out
> @@ -0,0 +1,2 @@
> +QA output created by 278
> +Silence is goodness...
> diff --git a/group b/group
> index 99592d3..6f2d748 100644
> --- a/group
> +++ b/group
> @@ -391,3 +391,4 @@ deprecated
>  275 auto rw
>  276 auto rw metadata
>  277 auto ioctl quick metadata
> +278 repair auto
> -- 
> 1.7.6.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
