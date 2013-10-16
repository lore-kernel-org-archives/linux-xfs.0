Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E56A57F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 11:30:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D37C3304032
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 09:30:28 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id JZTbKyAvMOTkXBmM for <xfs@oss.sgi.com>;
	Wed, 16 Oct 2013 09:30:27 -0700 (PDT)
Message-ID: <525EBF21.1000608@sandeen.net>
Date: Wed, 16 Oct 2013 11:30:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
	<1381940718-778-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1381940718-778-1-git-send-email-fdmanana@gmail.com>
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
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: dsterba@suse.cz, jbacik@fusionio.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 10/16/13 11:25 AM, Filipe David Borba Manana wrote:
> This test is motivated by an issue found by a btrfs user, addressed
> and described by the following Linux kernel patch:
> 
> https://patchwork.kernel.org/patch/3046931/
> 
> The steps to reproduce the issue on btrfs are the following:

Thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> $ mkfs.btrfs -f /dev/loop0
> $ mount /dev/loop0 /mnt
> $ mkdir /mnt/acl
> $ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
> $ getfacl /mnt/acl
> user::rwx
> group::rwx
> other::r-x
> default:user::rwx
> default:group::rwx
> default:other::---
> 
> $ mkdir /mnt/acl/dir1
> $ getfacl /mnt/acl/dir1
> user::rwx
> group::rwx
> other::---
> 
> After unmounting and mounting again the filesystem, getfacl returned the
> expected default ACL for the subdirectory:
> 
> $ umount /mnt/acl
> $ mount /dev/loop0 /mnt
> $ getfacl /mnt/acl/dir1
> user::rwx
> group::rwx
> other::---
> default:user::rwx
> default:group::rwx
> default:other::---
> 
> This means that the underlying ACL xattr was persisted correctly but
> the in memory representation of the inode had (incorrectly) a NULL ACL.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Moved the regression test into a dedicated and new file, as suggested
>     by Eric Sandeen.
> V3: Moved the test to the generic group and added "_supported_fs generic",
>     as suggested by Eric Sandeen. Also replaced GNU/Linux with Linux (hope
>     rms doesn't get mad at me).
> 
>  tests/generic/106     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/106.out |   21 +++++++++++++++
>  tests/generic/group   |    1 +
>  3 files changed, 93 insertions(+)
>  create mode 100755 tests/generic/106
>  create mode 100644 tests/generic/106.out
> 
> diff --git a/tests/generic/106 b/tests/generic/106
> new file mode 100755
> index 0000000..76cea80
> --- /dev/null
> +++ b/tests/generic/106
> @@ -0,0 +1,71 @@
> +#! /bin/bash
> +# FS QA Test No. generic/106
> +#
> +# Regression test to make sure a directory inherits the default ACL from
> +# its parent directory. This test was motivated by an issue reported by
> +# a btrfs user. That issue is fixed and described by the following btrfs
> +# kernel patch:
> +#
> +#     https://patchwork.kernel.org/patch/3046931/
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Filipe Manana.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# FAILure is the default!
> +
> +_cleanup()
> +{
> +       rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs generic
> +_require_acls
> +_require_scratch
> +_need_to_be_root
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount
> +
> +mkdir $SCRATCH_MNT/testdir
> +setfacl -d --set u::rwx,g::rwx,o::- $SCRATCH_MNT/testdir
> +getfacl --absolute-names $SCRATCH_MNT/testdir | _filter_scratch
> +
> +mkdir $SCRATCH_MNT/testdir/testsubdir
> +getfacl --absolute-names $SCRATCH_MNT/testdir/testsubdir | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/106.out b/tests/generic/106.out
> new file mode 100644
> index 0000000..5755cf9
> --- /dev/null
> +++ b/tests/generic/106.out
> @@ -0,0 +1,21 @@
> +QA output created by 106
> +# file: SCRATCH_MNT/testdir
> +# owner: root
> +# group: root
> +user::rwx
> +group::r-x
> +other::r-x
> +default:user::rwx
> +default:group::rwx
> +default:other::---
> +
> +# file: SCRATCH_MNT/testdir/testsubdir
> +# owner: root
> +# group: root
> +user::rwx
> +group::rwx
> +other::---
> +default:user::rwx
> +default:group::rwx
> +default:other::---
> +
> diff --git a/tests/generic/group b/tests/generic/group
> index 1aee03c..e93233a 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -33,6 +33,7 @@
>  099 udf auto
>  100 udf auto
>  105 acl auto quick
> +106 acl auto quick
>  112 rw aio auto quick
>  113 rw aio auto quick
>  117 attr auto quick
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
