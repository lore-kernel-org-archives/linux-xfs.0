Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:64796 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753246AbeCTNMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 09:12:22 -0400
Date: Wed, 21 Mar 2018 00:12:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add mount delay debug option
Message-ID: <20180320131219.GR18129@dastard>
References: <20180320050021.982-1-david@fromorbit.com>
 <20180320050021.982-2-david@fromorbit.com>
 <20180320120024.GA6107@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320120024.GA6107@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Mar 20, 2018 at 08:00:24AM -0400, Brian Foster wrote:
> On Tue, Mar 20, 2018 at 04:00:20PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Similar to log_recovery_delay, this delay occurs between the VFS
> > superblock being initialised and the xfs_mount being fully
> > initialised. It also poisons the per-ag radix tree node so that it
> > can be used for triggering shrinker races during mount
> > such as the following:
> > 
> > <run memory pressure workload in background>
> > 
> > $ cat dirty-mount.sh
> > #! /bin/bash
> > 
> > umount -f /dev/pmem0
> > mkfs.xfs -f /dev/pmem0
> > mount /dev/pmem0 /mnt/test
> > rm -f /mnt/test/foo
> > xfs_io -fxc "pwrite 0 4k" -c fsync -c "shutdown" /mnt/test/foo
> > umount /dev/pmem0
> > 
> > # let's crash it now!
> > echo 30 > /sys/fs/xfs/debug/mount_delay
> > mount /dev/pmem0 /mnt/test
> > echo 0 > /sys/fs/xfs/debug/mount_delay
> > umount /dev/pmem0
> > $ sudo ./dirty-mount.sh
> > .....
> 
> Planning to post a test for this?

Haven't written one yet, only really had time to diagnose and write
the fix so far.

> 
> > [   60.378118] CPU: 3 PID: 3577 Comm: fs_mark Tainted: G      D W        4.16.0-rc5-dgc #440
> > [   60.378120] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
> > [   60.378124] RIP: 0010:radix_tree_next_chunk+0x76/0x320
> > [   60.378127] RSP: 0018:ffffc9000276f4f8 EFLAGS: 00010282
> > [   60.383670] RAX: a5a5a5a5a5a5a5a4 RBX: 0000000000000010 RCX: 000000000000001a
> > [   60.385277] RDX: 0000000000000000 RSI: ffffc9000276f540 RDI: 0000000000000000
> > [   60.386554] RBP: 0000000000000000 R08: 0000000000000000 R09: a5a5a5a5a5a5a5a5
> > [   60.388194] R10: 0000000000000006 R11: 0000000000000001 R12: ffffc9000276f598
> > [   60.389288] R13: 0000000000000040 R14: 0000000000000228 R15: ffff880816cd6458
> > [   60.390827] FS:  00007f5c124b9740(0000) GS:ffff88083fc00000(0000) knlGS:0000000000000000
> > [   60.392253] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   60.393423] CR2: 00007f5c11bba0b8 CR3: 000000035580e001 CR4: 00000000000606e0
> 
> Was the beginning of this error splat snipped out? It might be useful to
> include that and perhaps instead snip out some of the specific register
> context above. Otherwise looks fine:

It was one of about 100 threads that smashed into the shrinker at
the same time. It was the most intact trace I could cut and
paste, and the actual oops lines were nowhere to be seen on the
console output....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
