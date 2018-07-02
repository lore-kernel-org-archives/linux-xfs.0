Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:40577 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752893AbeGBJ1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Jul 2018 05:27:15 -0400
Received: by mail-wr0-f195.google.com with SMTP id t6-v6so2457494wrn.7
        for <linux-xfs@vger.kernel.org>; Mon, 02 Jul 2018 02:27:15 -0700 (PDT)
Date: Mon, 2 Jul 2018 11:27:11 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] generic: test dm-thin running out of data space vs
 concurrent discard
Message-ID: <20180702092711.budxkovx2ncpehhp@odin.usersys.redhat.com>
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

Particularly, I could never reproduce this bug on spindles or SSDs, and I
believe many (if not most) people run xfstests on commodity hardware, not on
very fast disks, and the test doesn't reproduce the bug 100% of the times when
running on slow disks, so, unless the default for the test is to run it using
ramdisks, the test is useless IMHO.

> 
> Ramdisk can help trigger the race. Maybe NVME device can help too. But it's
> hard to reproduce on general disk.
> 

I didn't test it on NVME, so I can't tell =/

> If the XFS bug is fixed, above steps can reproduce dm-thin bug, the test
> will fail.
> 
> Unfortunately, if the dm-thin bug is fixed, then this case can't reproduce
> the XFS bug singly.
> 
> Thanks,
> Zorro
> 
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

The test looks mostly ok, despite the fact I believe this should run on a
ramdisk by default (or not run, if $SCRATCH_DEV is not a ramdisk)

-- 
Carlos
