Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:41354 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965046AbeEIPtg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 11:49:36 -0400
Date: Wed, 9 May 2018 23:49:31 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] test online label ioctl
Message-ID: <20180509154931.GJ8373@desktop>
References: <fd1e2651-099f-8acd-da4d-a67c1e45cd07@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd1e2651-099f-8acd-da4d-a67c1e45cd07@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Apr 30, 2018 at 04:43:18PM -0500, Eric Sandeen wrote:
> This tests the online label ioctl that btrfs has, which has been
> recently proposed for XFS.
> 
> To run, it requires an updated xfs_io with the label command and a
> filesystem that supports it
> 
> A slight change here to _require_xfs_io_command as well, so that tests
> which simply fail with "Inappropriate ioctl" can be caught in the
> common case.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> this passes on btrfs, _notruns on xfs/ext4 of yore, and passes
> on xfs w/ my online label patchset (as long as xfs_io has the new
> capability)
> 
> diff --git a/common/rc b/common/rc
> index 9ffab7f..c53a721 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2158,6 +2158,9 @@ _require_xfs_io_command()
>  		echo $testio | grep -q "Inappropriate ioctl" && \
>  			_notrun "xfs_io $command support is missing"
>  		;;
> +	"label")
> +		testio=`$XFS_IO_PROG -c "label" $TEST_DIR 2>&1`
> +		;;
>  	"open")
>  		# -c "open $f" is broken in xfs_io <= 4.8. Along with the fix,
>  		# a new -C flag was introduced to execute one shot commands.
> @@ -2196,7 +2199,7 @@ _require_xfs_io_command()
>  	rm -f $testfile 2>&1 > /dev/null
>  	echo $testio | grep -q "not found" && \
>  		_notrun "xfs_io $command support is missing"
> -	echo $testio | grep -q "Operation not supported" && \
> +	echo $testio | grep -q "Operation not supported\|Inappropriate ioctl" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
>  	echo $testio | grep -q "Invalid" && \
>  		_notrun "xfs_io $command failed (old kernel/wrong fs/bad args?)"
> diff --git a/tests/generic/485 b/tests/generic/485
> new file mode 100755
> index 0000000..79902c2
> --- /dev/null
> +++ b/tests/generic/485
> @@ -0,0 +1,99 @@
> +#! /bin/bash
> +# FS QA Test 485
> +#
> +# Test the online filesystem label set/get ioctls
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
> +# Author: Eric Sandeen <sandeen@redhat.com>
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
> +
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_xfs_io_command "label"
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount
> +
> +# Make sure we can set & clear the label
> +$XFS_IO_PROG -c "label label.$seq" $SCRATCH_MNT
> +$XFS_IO_PROG -c "label" $SCRATCH_MNT
> +
> +# And that userspace can see it now, while mounted
> +blkid -s LABEL $SCRATCH_DEV | _filter_scratch
> +
> +# And that the it is still there when it's unmounted
> +_scratch_unmount
> +blkid -s LABEL $SCRATCH_DEV | _filter_scratch
> +
> +# And that it persists after a remount
> +_scratch_mount
> +$XFS_IO_PROG -c "label" $SCRATCH_MNT
> +
> +# And that a too-long label is rejected, beyond the interface max:
> +LABEL=$(perl -e "print 'l' x 257;")
> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT
> +
> +# And that it succeeds right at the filesystem max:
> +case $FSTYP in
> +xfs)
> +	MAXLEN=12;
> +	;;
> +btrfs)
> +	MAXLEN=256

Seems this should be 255, otherwise I got failure like:

-label = "MAXLABEL"
+label: Invalid argument

and MAXLEN=255 makes the test pass with btrfs.

> +	;;
> +*)
> +	MAXLEN=256
> +	echo "Your filesystem supports online label, please add max length"

Perhaps we can introduce a new helper similar to _require_acl_get_max()
and _notrun the test if current $FSTYP doesn't define a maxlen on
filesystem label?

> +	;;
> +esac
> +LABEL=$(perl -e "print 'o' x $MAXLEN;")
> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT | sed -e 's/o\+/MAXLABEL/'
> +
> +# And that it fails just past the filesystem max:
> +let TOOLONG=MAXLEN+1
> +LABEL=$(perl -e "print 'o' x $TOOLONG;")
> +$XFS_IO_PROG -c "label $LABEL" $SCRATCH_MNT
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/485.out b/tests/generic/485.out
> new file mode 100644
> index 0000000..bc54684
> --- /dev/null
> +++ b/tests/generic/485.out
> @@ -0,0 +1,9 @@
> +QA output created by 485
> +label = "label.485"
> +label = "label.485"
> +SCRATCH_DEV: LABEL="label.485" 
> +SCRATCH_DEV: LABEL="label.485" 

There're trailing whitespaces in above two lines, I thought they're the
output from xfs_io label command at first, but actually I have to remove
the spaces to make test pass.

Thanks,
Eryu

> +label = "label.485"
> +label: Invalid argument
> +label = "MAXLABEL"
> +label: Invalid argument
> diff --git a/tests/generic/group b/tests/generic/group
> index 19be926..cf6ac49 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -487,3 +487,4 @@
>  482 auto metadata replay
>  483 auto quick log metadata
>  484 auto quick
> +485 auto quick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
