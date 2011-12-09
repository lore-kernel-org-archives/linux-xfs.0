Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB9JL9Nr231256 for <xfs@oss.sgi.com>; Fri, 9 Dec 2011 13:21:09 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E704B2AFFB0
	for <xfs@oss.sgi.com>; Fri,  9 Dec 2011 11:21:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dvHKJRVpW4w8HXfr for
	<xfs@oss.sgi.com>; Fri, 09 Dec 2011 11:21:08 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pB9JL70G027595
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 9 Dec 2011 14:21:07 -0500
Message-ID: <4EE25FA2.4000102@sandeen.net>
Date: Fri, 09 Dec 2011 13:21:06 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 276: Ensure lost+found is not created with wrong
	link count
References: <1323449801-29183-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1323449801-29183-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 12/09/2011 10:56 AM, Carlos Maiolino wrote:
> xfs_repair was leaving lost+found directory with a wrong link count when a
> cleaned inode was re-used to create lost+found. This test case confirm that,
> after xfs_repair is executed, the lost+found inode is left in a consistent
> state.
> See commit: 198b747f255346bca64408875763b6ca0ed3d57d from xfsprogs tree
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  276     |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  276.out |    2 +
>  group   |    1 +
>  3 files changed, 89 insertions(+), 0 deletions(-)
>  create mode 100755 276
>  create mode 100644 276.out
> 
> diff --git a/276 b/276
> new file mode 100755
> index 0000000..970169d
> --- /dev/null
> +++ b/276
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# FS QA Test No. 276
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
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV > /dev/null 2>&1
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >/dev/null 2>&1
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >/dev/null 2>&1
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >/dev/null 2>&1
> +xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >/dev/null 2>&1
> +xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >/dev/null 2>&1
> +
> +# Corrupt SUBDIR
> +xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >/dev/null 2>&1
> +xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >/dev/null 2>&1

You might want to capture the xfs_db output to hte output file,
if it's not expected to change; that way if something fails, the test
will fail properly

> +xfs_check $SCRATCH_DEV >/dev/null 2>&1

this has no effect...

> +xfs_repair $SCRATCH_DEV >/dev/null 2>&1

capturing xfs_repair output to $seq.full might be useful

> +RESULT=`xfs_check $SCRATCH_DEV`
> +
> +if [ "$RESULT" == "" ]; then
> +	status=0
> +else
> +	echo "$RESULT"
> +fi
> +# if error

this is stray?

> +exit
> diff --git a/276.out b/276.out
> new file mode 100644
> index 0000000..8b8888b
> --- /dev/null
> +++ b/276.out
> @@ -0,0 +1,2 @@
> +QA output created by 276
> +Silence is goodness...
> diff --git a/group b/group
> index 08d999a..16e9f10 100644
> --- a/group
> +++ b/group
> @@ -389,3 +389,4 @@ deprecated
>  273 auto rw
>  274 auto rw
>  275 auto rw
> +276 repair

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
