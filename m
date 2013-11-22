Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F248E7F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 02:50:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D4D1AC007
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 00:50:07 -0800 (PST)
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id gPJBneBg9ynk0w3N
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Nov 2013 00:50:06 -0800 (PST)
Received: by mail-pa0-f53.google.com with SMTP id hz1so1013604pad.26
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 00:50:05 -0800 (PST)
Date: Fri, 22 Nov 2013 16:50:00 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] xfstests: xfs/322, verify xfs_quota administrator
	commands against invalid mount path
Message-ID: <20131122085000.GD10132@dhcp-13-216.nay.redhat.com>
References: <528F0D82.7010607@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <528F0D82.7010607@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 22, 2013 at 03:53:38PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Introduce xfs/322 to verify xfs_quota administrator commands can
> deal with invalid XFS mount path properly without NULL pointer
> dereference issue.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  tests/xfs/322     | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/322.out |  2 ++
>  tests/xfs/group   |  1 +
>  3 files changed, 71 insertions(+)
>  create mode 100755 tests/xfs/322
>  create mode 100644 tests/xfs/322.out
> 
> diff --git a/tests/xfs/322 b/tests/xfs/322
> new file mode 100755
> index 0000000..9c749a1
> --- /dev/null
> +++ b/tests/xfs/322
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# FS QA Test No. 322
> +#
> +# Test to verify xfs_quota(8) administrator commands can deal with invalid
> +# storage mount point without NULL pointer dereference problem.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Oracle Inc.  All Rights Reserved.
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
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
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
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.

This comment is not needed.

> +_supported_fs generic

Should be "_supported_fs xfs" ?

Thanks,
Eryu Guan
> +_supported_os IRIX Linux
> +
> +echo "Silence is golden"
> +
> +# To run this sanity check we don't need to enable quota function
> +# nor need a scratch device as quota tool will get the mount path
> +# at first.
> +# An non-existent xfs mount point
> +INVALID_PATH="/INVALID_XFS_MOUNT_POINT"
> +
> +xfs_quota -x -c 'report -a' $INVALID_PATH	2>/dev/null
> +xfs_quota -x -c 'state -a' $INVALID_PATH	2>/dev/null
> +xfs_quota -x -c 'free -h' $INVALID_PATH		2>/dev/null
> +xfs_quota -x -c 'quot -v' $INVALID_PATH		2>/dev/null
> +xfs_quota -x -c 'remove' $INALID_PATH		2>/dev/null
> +xfs_quota -x -c 'disable' $INVALID_PATH		2>/dev/null
> +xfs_quota -x -c 'enable' $INVALID_PATH		2>/dev/null
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/322.out b/tests/xfs/322.out
> new file mode 100644
> index 0000000..8bcca16
> --- /dev/null
> +++ b/tests/xfs/322.out
> @@ -0,0 +1,2 @@
> +QA output created by 322
> +Silence is golden
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 26ea9b6..92db1c2 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -182,3 +182,4 @@
>  300 auto fsr
>  301 auto dump
>  302 auto dump
> +322 auto quick
> -- 
> 1.8.3.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
