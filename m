Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1BB1C7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:26:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC0C98F8035
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:26:41 -0700 (PDT)
Received: from mail-pd0-f170.google.com (mail-pd0-f170.google.com
	[209.85.192.170]) by cuda.sgi.com with ESMTP id
	D5OwxmD5YpbEyLW5 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 10:26:40 -0700 (PDT)
Received: by mail-pd0-f170.google.com with SMTP id x10so5082950pdj.29
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:26:40 -0700 (PDT)
Date: Sat, 19 Oct 2013 01:26:35 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH V2] xfstests: Test xfs_fsr / swapext management of
	di_forkoff w/ selinux
Message-ID: <20131018172635.GE11404@dhcp-13-216.nay.redhat.com>
References: <5260B62D.2010507@redhat.com>
 <52616072.6040808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52616072.6040808@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 18, 2013 at 11:23:14AM -0500, Eric Sandeen wrote:
> In some cases selinux's creation of an xattr on the temporary
> fd creates a local xattr, but the file we are trying to 
> defragment has attrs in extent format, and the forkoff mismatch
> will cause xfs_fsr to fail.  This test demonstrates it;  I
> have old patches sent to the list long ago that should fix
> it.  I'll resend them soon.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Address Eryu's review
> 
> diff --git a/tests/xfs/351 b/tests/xfs/351
> new file mode 100755
> index 0000000..13c7629
> --- /dev/null
> +++ b/tests/xfs/351
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# FS QA Test No. 351
> +#
> +# Test xfs_fsr / swapext management of di_forkoff w/ selinux
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
> +_require_scratch
> +
> +# real QA test starts here
> +
> +_supported_fs xfs
> +_supported_os Linux
> +
> +getenforce | grep -q "Enforcing\|Permissive" || _notrun "SELinux not enabled"
> +[ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
> +
> +rm -f $seqres.full
> +
> +_scratch_mkfs_xfs -i size=256 >> $seq.full 2>&1 || _fail "mkfs failed"
> +
> +# Manually mount to avoid fs-wide context set by default in xfstests
> +mount $SCRATCH_DEV $SCRATCH_MNT
> +
> +touch $SCRATCH_MNT/$seq.test
> +
> +# Create an extents-format attribute on a file
> +$XFS_IO_PROG -f -c "pwrite -S 0x63 0 4096" $SCRATCH_MNT/attrvals >> $seqres.full 2>&1
> +cat $SCRATCH_MNT/attrvals | attr -s name $SCRATCH_MNT/$seq.test >> $seqres.full 2>&1
> +
> +# Fragment the file by writing backwards
> +for I in `seq 6 -1 0`; do
> +	dd if=/dev/zero of=$SCRATCH_MNT/$seq.test seek=$I bs=4k \
> +	   oflag=direct count=1 conv=notrunc >> $seqres.full 2>&1
> +done
> +
> +# See if xfs_fsr works.
> +
> +# The target file now has a non-local attribute, but the
> +# fsr temp file gets assigned a local attribute on creation,
> +# due to selinux.
> +    

There's trailing whitespaces issue here, otherwise looks good to me.

I suppose the seq number can be fixed at commit time, as well as the
trailing whitespaces.

Reviewed-by: Eryu Guan <eguan@redhat.com>

Thanks!
Eryu

BTW, test fails on 3.12-rc5 kernel

--- tests/xfs/351.out   2013-10-18 13:23:10.219847555 -0400
+++ /root/xfstests/results//xfs/351.out.bad     2013-10-18 13:24:38.014147342 -0400
@@ -1,3 +1,3 @@
 QA output created by 351
 SCRATCH_MNT/351.test
-extents before:6 after:1 DONE SCRATCH_MNT/351.test
+XFS_IOC_SWAPEXT failed: SCRATCH_MNT/351.test: Invalid argument

> +# In this case, the large-ish selinux attr will create a forkoff
> +# in the temp file smaller than the forkoff in the target file,
> +# because the FMT_EXTENTS attr takes up less space.  If there is
> +# no mechanism to grow the temp forkoff to match, we can end up
> +# failing to swap these 2 inodes if the result is not enough
> +# data space in the temp inode as a result.
> +
> +$XFS_FSR_PROG -v $SCRATCH_MNT/$seq.test | _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/351.out b/tests/xfs/351.out
> new file mode 100644
> index 0000000..86cbe5d
> --- /dev/null
> +++ b/tests/xfs/351.out
> @@ -0,0 +1,3 @@
> +QA output created by 351
> +SCRATCH_MNT/351.test
> +extents before:6 after:1 DONE SCRATCH_MNT/351.test
> diff --git a/tests/xfs/group b/tests/xfs/group
> index acb92ac..da76770 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -180,4 +180,4 @@
>  298 auto attr symlink quick
>  299 auto quota
>  350 auto dump quota
> -
> +351 auto fsr
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
