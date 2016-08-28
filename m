Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 426367CA0
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 02:35:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1408E8F8033
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2016 00:35:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ClYDG1BlfJBMXw0s (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 28 Aug 2016 00:35:08 -0700 (PDT)
Date: Sun, 28 Aug 2016 15:35:05 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] fstests: test xfs rw remount with unknown ro-compat
	features
Message-ID: <20160828073505.GD27776@eguan.usersys.redhat.com>
References: <1472311713-12992-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1472311713-12992-1-git-send-email-zlang@redhat.com>
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
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Sat, Aug 27, 2016 at 11:28:33PM +0800, Zorro Lang wrote:
> Although ro-compat features cannot be mounted rw, a bug allows
> an ro->rw remount transition, and this will corrupt the filesystem
> if it contains ro-compat features unknown to the running kernel.
> 
> This bug has been fix on linux kernel (d0a58e8 xfs: disallow rw
> remount on fs with unknown ro-compat features), this case is
> the regression testcase of that bug.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> V2 fix some mistakes of golden image(.out) file.
> 
> Thanks,
> Zorro
> 
>  tests/xfs/263     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/263.out |  6 ++++
>  tests/xfs/group   |  1 +
>  3 files changed, 106 insertions(+)
>  create mode 100755 tests/xfs/263
>  create mode 100644 tests/xfs/263.out
> 
> diff --git a/tests/xfs/263 b/tests/xfs/263
> new file mode 100755
> index 0000000..a46e250
> --- /dev/null
> +++ b/tests/xfs/263
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FS QA Test 263
> +#
> +# Test upstream d0a58e8:
> +#   xfs: disallow rw remount on fs with unknown ro-compat features

Need detailed test description here too.

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
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
> +	cd /
> +	rm -f $tmp.*
> +	# Due to we've broken the superblock of SCRATCH_DEV by
> +	# xfs_db, so clean bad superblock at the end
> +	_scratch_unmount
> +	_scratch_mkfs >/dev/null 2>&1

This can be done by calling _require_scratch_nocheck in the test
instead of _require_scratch, so there's no fsck run after test.

> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_crc

_require_scratch_xfs_crc and ..

> +
> +# Only V5 XFS disallow rw mount/remount with unknown ro-compat
> +# features
> +MKFS_OPTIONS="-m crc=1"

you don't have to overwrite MKFS_OPTIONS, let the user specify test
config, and just skip the test if scratch_dev has no crc support.

> +_scratch_mkfs_xfs >>$seqres.full 2>&1
> +
> +# set the highest bit of features_ro_compat, use it as an unknown
> +# feature bit. If one day this bit become known feature, please
> +# change this case.
> +$XFS_DB_PROG -x -c "sb 0" \
> +                -c "write features_ro_compat $((2**31))" \
> +		$SCRATCH_DEV
> +
> +echo "rw mount test"
> +# Maybe this mount will fail by bad superblock
> +# But keep testing this anyway
> +MOUNT_OPTIONS="-o rw"

rw mount is the default, I don't think overwriting MOUNT_OPTIONS is
necessary.

> +_scratch_mount 2>>$seqres.full
> +if [ $? -eq 0 ]; then
> +	_fail "rw mount test failed"
> +fi
> +
> +echo "ro mount test"
> +MOUNT_OPTIONS="-o ro"
> +_scratch_mount

_scratch_mount -o ro

No need to overwrite MOUNT_OPTIONS either.

> +if [ $? -ne 0 ]; then
> +	_fail "ro mount test failed"
> +else
> +	# no hang/panic is fine
> +	$FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 400 >>$seqres.full 2>&1

I don't think this is necessary, because the fs is ro-mounted, but it's
fine by me, just make sure there's no hang/panic on unknown ro_compat
feature ro-mount.

> +fi
> +
> +dmesg -c >/dev/null
> +echo "rw remount test"
> +MOUNT_OPTIONS="-o rw,remount"
> +_scratch_mount 2>>$seqres.full

_scratch_remount rw

> +if [ $? -eq 0 ]; then
> +	_fail "rw,remount test failed"
> +fi
> +dmesg -c | sed -n -e "s/.*XFS.*: \(ro->rw transition prohibited.*\)/\1/p"

We probably don't want to clear dmesg buffer if possible, and I think
making sure remount,rw failed is good enough. Or we can write a new
helper to look for specific dmesg by following how _check_dmesg does? 

Thanks,
Eryu

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/263.out b/tests/xfs/263.out
> new file mode 100644
> index 0000000..440ed32
> --- /dev/null
> +++ b/tests/xfs/263.out
> @@ -0,0 +1,6 @@
> +QA output created by 263
> +features_ro_compat = 0x80000000
> +rw mount test
> +ro mount test
> +rw remount test
> +ro->rw transition prohibited on unknown (0x80000000) ro-compat filesystem
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 6905a62..ec3c022 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -260,6 +260,7 @@
>  260 auto quick quota
>  261 auto quick quota
>  262 auto quick quota
> +263 auto quick mount
>  265 auto clone
>  266 dump ioctl auto quick
>  267 dump ioctl tape
> -- 
> 2.7.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
