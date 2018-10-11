Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18069 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbeJKOlh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 10:41:37 -0400
Date: Thu, 11 Oct 2018 18:15:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_bmap stuck at ~/.steam/steam.pipe file
Message-ID: <20181011071536.GQ6311@dastard>
References: <CABXGCsPMXLbPJdAFq79Fmby3y89s=o7F-tf_+zSo_RsJXjaRaA@mail.gmail.com>
 <20181011060027.GP6311@dastard>
 <CABXGCsNzZKE6-7LB9_KQi=YuhWcd=GRZPG-FeicZiz8bEwb23g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXGCsNzZKE6-7LB9_KQi=YuhWcd=GRZPG-FeicZiz8bEwb23g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, g@dastard
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 11, 2018 at 11:20:43AM +0500, Mikhail Gavrilov wrote:
> On Thu, 11 Oct 2018 at 11:00, Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Thu, Oct 11, 2018 at 10:47:31AM +0500, Mikhail Gavrilov wrote:
> > > When I researched the most fragmented files, I found that xfs_bmap
> > > stuck at the file /home/mikhail/.steam/steam.pipe.
> >
> > Stuck, or just taking a long time?
> 
> I was waiting for seven hours when process ended. I think it's enough
> for think than this process stuck.

*nod*

> $ ps aux | grep xfs_bmap
> mikhail  16226  0.0  0.0 213216   840 pts/21   S+   11:07   0:00 grep
> --color=auto xfs_bmap
> mikhail  21021  0.0  0.0 213804  1224 pts/12   S+   04:32   0:00
> /usr/bin/sh -f /usr/sbin/xfs_bmap /home/mikhail/.steam/steam.pipe
> mikhail  21024  0.0  0.0 217424     8 pts/12   S+   04:32   0:00
> /usr/sbin/xfs_io -r -p xfs_bmap -c bmap
> /home/mikhail/.steam/steam.pipe
> [mikhail@localhost ~]$ date
> Thu Oct 11 11:07:55 +05 2018
> 
> >
> > It's in the kernel open() syscall opening the file. userspace
> > tracing won't tell you what is going on at this point. Is there
> > anything in dmesg?
> 
> Nothing since the time when process xfs_io was started.
> 
> $ dmesg -e
> ...
> [Oct10 23:37] perf: interrupt took too long (2512 > 2500), lowering
> kernel.perf_event_max_sample_rate to 79000
> [Oct11 09:53] tun: Universal TUN/TAP device driver, 1.6
> [Oct11 10:21] usb 3-2.4: USB disconnect, device number 6
> [  +0.953248] usb 3-2.4: new high-speed USB device number 10 using xhci_hcd
> [  +0.090606] usb 3-2.4: New USB device found, idVendor=2109,
> idProduct=2813, bcdDevice=90.11
> [  +0.000003] usb 3-2.4: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [  +0.000002] usb 3-2.4: Product: USB2.0 Hub
> [  +0.000002] usb 3-2.4: Manufacturer: VIA Labs, Inc.
> [  +0.043404] hub 3-2.4:1.0: USB hub found
> [  +0.000869] hub 3-2.4:1.0: 4 ports detected
> 
> 
> > what is the output of `cat /proc/<pid>/stack` for the xfs_io process
> > that is running the bmap command?
> 
> # cat /proc/21024/stack
> [<0>] pipe_wait+0x6c/0xb0
> [<0>] wait_for_partner+0x19/0x50
> [<0>] fifo_open+0x266/0x2c0
> [<0>] do_dentry_open+0x132/0x340
> [<0>] path_openat+0x334/0x1610
> [<0>] do_filp_open+0x93/0x100
> [<0>] do_sys_open+0x186/0x210
> [<0>] do_syscall_64+0x5b/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [<0>] 0xffffffffffffffff

Hmmm. That's waiting for pipe to connect, not waiting for
an XFS file to open.

*ding*

You ran xfs_bmap on a *named pipe*, not a regular file. Yeah,
xfs_bmap is waiting for the other end of the pipe to be
connected to something, which never happens. Only regular files and
directories have extents, so running xfs_bmap on a pipe is not a
useful thing to do.

Ok, so there's an element of user error here, but xfs_io doesn't
check that it's getting anything other than regular files,
directories or block devices so I'm guessing we'll have to add a
check to error this case out before opening the pipe.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
