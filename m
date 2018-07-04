Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:39195 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752819AbeGDNEh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 09:04:37 -0400
Date: Wed, 4 Jul 2018 21:04:30 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] generic: test dm-thin running out of data space vs
 concurrent discard
Message-ID: <20180704130430.GA2780@desktop>
References: <20180629165738.8106-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180629165738.8106-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sat, Jun 30, 2018 at 12:57:38AM +0800, Zorro Lang wrote:
> If a user constructs a test that loops repeatedly over below steps
> on dm-thin, block allocation can fail due to discards not having
> completed yet (Fixed by a685557 dm thin: handle running out of data
> space vs concurrent discard):
> 1) fill thin device via filesystem file
> 2) remove file
> 3) fstrim
> 
> And this maybe cause a deadlock (fast device likes ramdisk can help
> a lot) when racing a fstrim with a filesystem (XFS) shutdown. (Fixed
> by 8c81dd46ef3c Force log to disk before reading the AGF during a
> fstrim)
> 
> This case can reproduce both two bugs if they're not fixed. If only
> the dm-thin bug is fixed, then the test will pass. If only the fs
> bug is fixed, then the test will fail. If both of bugs aren't fixed,
> the test will hang.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> If both of two bugs aren't fixed, a loop device base on tmpfs can help
> reproduce the XFS deadlock:
> 1) mount -t tmpfs tmpfs /tmp
> 2) dd if=/dev/zero of=/tmp/test.img bs=1M count=100
> 3) losetup /dev/loop0 /tmp/test.img
> 4) use /dev/loop0 to be SCRATCH_DEV, run this case. The test will hang there.
> 
> Ramdisk can help trigger the race. Maybe NVME device can help too. But it's
> hard to reproduce on general disk.
> 
> If the XFS bug is fixed, above steps can reproduce dm-thin bug, the test
> will fail.
> 
> Unfortunately, if the dm-thin bug is fixed, then this case can't reproduce
> the XFS bug singly.
> 
> Thanks,
> Zorro
> 
>  tests/generic/499     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/499.out |  2 ++
>  tests/generic/group   |  1 +
>  3 files changed, 88 insertions(+)
>  create mode 100755 tests/generic/499
>  create mode 100644 tests/generic/499.out
> 
> diff --git a/tests/generic/499 b/tests/generic/499
> new file mode 100755
> index 00000000..24adfc3a
> --- /dev/null
> +++ b/tests/generic/499
> @@ -0,0 +1,85 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> +#
> +# FS QA Test 499
> +#
> +# Race test running out of data space with concurrent discard operation on
> +# dm-thin.
> +#
> +# If a user constructs a test that loops repeatedly over below steps on
> +# dm-thin, block allocation can fail due to discards not having completed
> +# yet (Fixed by a685557 dm thin: handle running out of data space vs
> +# concurrent discard):
> +# 1) fill thin device via filesystem file
> +# 2) remove file
> +# 3) fstrim
> +#
> +# And this maybe cause a deadlock when racing a fstrim with a filesystem
> +# (XFS) shutdown. (Fixed by 8c81dd46ef3c Force log to disk before reading
> +# the AGF during a fstrim)
> +#
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
> +	_dmthin_cleanup
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/dmthin
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_nocheck
> +_require_dm_target thin-pool

Need _require_command "$FSTRIM_PROG" fstrim

> +
> +# Create a thin pool and a *slightly smaller* thin volume, it's helpful
> +# to reproduce the bug
> +BACKING_SIZE=$((50 * 1024 * 1024 / 512))	# 50M
> +VIRTUAL_SIZE=$((BACKING_SIZE + 1024))		# 50M + 1k
> +CLUSTER_SIZE=$((64 * 1024 / 512))		# 64K
> +
> +_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE $CLUSTER_SIZE 0
> +_dmthin_set_fail
> +_mkfs_dev $DMTHIN_VOL_DEV
> +_dmthin_mount
> +
> +# There're two bugs at here, one is dm-thin bug, the other is filesystem
> +# (XFS especially) bug. The dm-thin bug can't handle running out of data
> +# space with concurrent discard well. Then the dm-thin bug cause fs unmount
> +# hang when racing a fstrim with a filesystem shutdown.
> +#
> +# If both of two bugs haven't been fixed, below test maybe cause deadlock.
> +# Else if the fs bug has been fixed, but the dm-thin bug hasn't. below test
> +# will cause the test fail (no deadlock).
> +# Else the test will pass.
> +for ((i=0; i<100; i++)); do
> +	$XFS_IO_PROG -f -c "pwrite -b 64k 0 100M" \
> +		$SCRATCH_MNT/testfile &>/dev/null
> +	rm -f $SCRATCH_MNT/testfile
> +	$FSTRIM_PROG $SCRATCH_MNT
> +done

I think it's fine to run this test on non-ramdisk devices, even though
it's hard to reproduce the bug there, as it's good to have more test
coverage. But is it really need looping for 100 times? Test time could
be reduced if we could run for less loops.

Thanks,
Eryu

> +
> +_dmthin_check_fs
> +_dmthin_cleanup
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/499.out b/tests/generic/499.out
> new file mode 100644
> index 00000000..c363e684
> --- /dev/null
> +++ b/tests/generic/499.out
> @@ -0,0 +1,2 @@
> +QA output created by 499
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 83a6fdab..bbeac4af 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -501,3 +501,4 @@
>  496 auto quick swap
>  497 auto quick swap collapse
>  498 auto quick log
> +499 auto thin trim
> -- 
> 2.14.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
