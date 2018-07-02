Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49022 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965350AbeGBK2W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Jul 2018 06:28:22 -0400
Date: Mon, 2 Jul 2018 18:28:17 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] generic: test dm-thin running out of data space vs
 concurrent discard
Message-ID: <20180702102817.GW4893@hp-dl360g9-06.rhts.eng.pek2.redhat.com>
References: <20180629165738.8106-1-zlang@redhat.com>
 <20180702092711.budxkovx2ncpehhp@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180702092711.budxkovx2ncpehhp@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: cem@redhat.com

On Mon, Jul 02, 2018 at 11:27:11AM +0200, Carlos Maiolino wrote:
> On Sat, Jun 30, 2018 at 12:57:38AM +0800, Zorro Lang wrote:
> > If a user constructs a test that loops repeatedly over below steps
> > on dm-thin, block allocation can fail due to discards not having
> > completed yet (Fixed by a685557 dm thin: handle running out of data
> > space vs concurrent discard):
> > 1) fill thin device via filesystem file
> > 2) remove file
> > 3) fstrim
> > 
> > And this maybe cause a deadlock (fast device likes ramdisk can help
> > a lot) when racing a fstrim with a filesystem (XFS) shutdown. (Fixed
> > by 8c81dd46ef3c Force log to disk before reading the AGF during a
> > fstrim)
> > 
> > This case can reproduce both two bugs if they're not fixed. If only
> > the dm-thin bug is fixed, then the test will pass. If only the fs
> > bug is fixed, then the test will fail. If both of bugs aren't fixed,
> > the test will hang.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > If both of two bugs aren't fixed, a loop device base on tmpfs can help
> > reproduce the XFS deadlock:
> > 1) mount -t tmpfs tmpfs /tmp
> > 2) dd if=/dev/zero of=/tmp/test.img bs=1M count=100
> > 3) losetup /dev/loop0 /tmp/test.img
> > 4) use /dev/loop0 to be SCRATCH_DEV, run this case. The test will hang there.
> 
> Particularly, I could never reproduce this bug on spindles or SSDs, and I
> believe many (if not most) people run xfstests on commodity hardware, not on
> very fast disks, and the test doesn't reproduce the bug 100% of the times when
> running on slow disks, so, unless the default for the test is to run it using
> ramdisks, the test is useless IMHO.

As a racing test, I think there's not 100% reproducible case. This case
already can cover this issue in some conditions.

> 
> > 
> > Ramdisk can help trigger the race. Maybe NVME device can help too. But it's
> > hard to reproduce on general disk.
> > 
> 
> I didn't test it on NVME, so I can't tell =/

I didn't try NVME and SSD. From my test, if the underlying SCRATCH_DEV support
fstrim, the case can reproduce this bug.

For example:

If I create a device by:
# modprobe scsi_debug dev_size_mb=100
Then I can't reproduce this bug.

If I create a device by
# modprobe scsi_debug lbpu=1 lbpws=1 dev_size_mb=100
Then the bug is reproducible:
# ./check generic/499
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 xxxx 3.10.0-915.el7.x86_64
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sde
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sde /mnt/scratch

generic/499 2s ... [failed, exit status 1]- output mismatch (see /root/git/xfstests-zlang/results//generic/499.out.bad)
    --- tests/generic/499.out   2018-06-29 10:38:58.965827495 -0400
    +++ /root/git/xfstests-zlang/results//generic/499.out.bad   2018-07-02 06:20:34.841313041 -0400
    @@ -1,2 +1,106 @@
     QA output created by 499
    -Silence is golden
    +fstrim: /mnt/scratch: FITRIM ioctl failed: Input/output error
    +fstrim: cannot open /mnt/scratch: Input/output error
    +fstrim: cannot open /mnt/scratch: Input/output error
    +fstrim: cannot open /mnt/scratch: Input/output error
    +fstrim: cannot open /mnt/scratch: Input/output error
    ...
    (Run 'diff -u tests/generic/499.out /root/git/xfstests-zlang/results//generic/499.out.bad'  to see the entire diff)
Ran: generic/499
Failures: generic/499
Failed 1 of 1 tests

Thanks,
Zorro

> 
> > If the XFS bug is fixed, above steps can reproduce dm-thin bug, the test
> > will fail.
> > 
> > Unfortunately, if the dm-thin bug is fixed, then this case can't reproduce
> > the XFS bug singly.
> > 
> > Thanks,
> > Zorro
> > 
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Red Hat Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 499
> > +#
> > +# Race test running out of data space with concurrent discard operation on
> > +# dm-thin.
> > +#
> > +# If a user constructs a test that loops repeatedly over below steps on
> > +# dm-thin, block allocation can fail due to discards not having completed
> > +# yet (Fixed by a685557 dm thin: handle running out of data space vs
> > +# concurrent discard):
> > +# 1) fill thin device via filesystem file
> > +# 2) remove file
> > +# 3) fstrim
> > +#
> > +# And this maybe cause a deadlock when racing a fstrim with a filesystem
> > +# (XFS) shutdown. (Fixed by 8c81dd46ef3c Force log to disk before reading
> > +# the AGF during a fstrim)
> > +
> 
> 
> > +# There're two bugs at here, one is dm-thin bug, the other is filesystem
> > +# (XFS especially) bug. The dm-thin bug can't handle running out of data
> > +# space with concurrent discard well. Then the dm-thin bug cause fs unmount
> > +# hang when racing a fstrim with a filesystem shutdown.
> > +#
> > +# If both of two bugs haven't been fixed, below test maybe cause deadlock.
> > +# Else if the fs bug has been fixed, but the dm-thin bug hasn't. below test
> > +# will cause the test fail (no deadlock).
> > +# Else the test will pass.
> 
> The test looks mostly ok, despite the fact I believe this should run on a
> ramdisk by default (or not run, if $SCRATCH_DEV is not a ramdisk)
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
