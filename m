Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39636 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750842AbdLAAot (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Nov 2017 19:44:49 -0500
Date: Fri, 1 Dec 2017 01:44:44 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 00/11] fs: use freeze_fs on suspend/hibernate
Message-ID: <20171201004444.GP729@wotan.suse.de>
References: <20171129232356.28296-1-mcgrof@kernel.org>
 <20171130215157.GB2808@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130215157.GB2808@amd>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, viro@zeniv.linux.org.uk, bart.vanassche@wdc.com, ming.lei@redhat.com, tytso@mit.edu, darrick.wong@oracle.com, jikos@kernel.org, rjw@rjwysocki.net, len.brown@intel.com, linux-fsdevel@vger.kernel.org, boris.ostrovsky@oracle.com, jgross@suse.com, todd.e.brandt@linux.intel.com, nborisov@suse.com, jack@suse.cz, martin.petersen@oracle.com, ONeukum@suse.com, oleksandr@natalenko.name, oleg.b.antonyan@gmail.com, yu.chen.surf@gmail.com, dan.j.williams@intel.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 30, 2017 at 10:51:57PM +0100, Pavel Machek wrote:
> Hi!
> 
> > Proposed solution:
> > 
> > Instead of fixing such semantics and trying to get all filesystems to do it
> > right, we can easily do away with all freezing calls if the filesystem
> > implements a proper freeze_fs() callback. The following 9 filesystems have
> > freeze_fs() implemented as such we can let the kernel issue the callback upon
> > suspend and thaw on resume automatically on our behalf.
> > 
> >   o xfs
> >   o reiserfs
> >   o nilfs2
> >   o jfs
> >   o f2fs
> >   o ext4
> >   o ext2
> >   o btrfs
> > 
> > Of these, the following have freezer helpers, which can then be removed
> > after the kernel automaticaly calls freeze_fs for us on suspend:
> > 
> >   o xfs
> >   o nilfs2
> >   o jfs
> >   o f2fs
> >   o ext4
> > 
> > I've tested this on a system with ext4 and XFS, and have let 0-day go at
> > without issues. I have branches availabe for linux-next [3] and Linus'
> > latest tree [4].
> 
> Was hibernation tested? uswsusp?

I had not done a test before but I just did and it worked, in fact I was able
to keep my ssh connection to my qemu guest after resume from hibernation with
this.

root@piggy:~# echo shutdown > /sys/power/disk; echo disk > /sys/power/state

[   87.930446] PM: hibernation entry
[   87.936294] firmware_class: device_cache_fw_images
[   87.936363] PM: Syncing filesystems ... 
[   87.979960] PM: done.
[   87.980594] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   87.983839] Freezing filesystems ... 
[   87.983844] xfs (sdb1): freezing
[   88.013313] ext4 (sda1): freezing
[   88.057635] done.
[   88.058242] OOM killer disabled.
...
[   88.145364] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   88.221583] Disabling non-boot CPUs ...
[   88.241231] Unregister pv shared memory for cpu 1
[   88.244139] smpboot: CPU 1 is now offline
[   88.273290] Unregister pv shared memory for cpu 2
[   88.276170] smpboot: CPU 2 is now offline
[   88.297296] Unregister pv shared memory for cpu 3
[   88.299991] smpboot: CPU 3 is now offline
[   88.302665] PM: Creating hibernation image:
[   88.305633] PM: Need to copy 107866 pages
[   88.305633] PM: Normal pages needed: 107866 + 1024, available pages: 940488
...

At this point my qemu session ends. I start it up again.

   88.305633] Enabling non-boot CPUs ...
[   88.305633] x86: Booting SMP configuration:
[   88.305633] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   88.244097] kvm-clock: cpu 1, msr 1:3ffef041, secondary cpu clock
[   88.334899] KVM setup async PF for cpu 1
[   88.335174] kvm-stealtime: cpu 1, msr 13fc8d9c0
...
[   88.424852] sd 0:0:0:0: [sda] Starting disk
[   88.424893] sd 0:0:1:0: [sdb] Starting disk
[   88.424928] sd 1:0:0:0: [sdc] Starting disk
[   88.473888] PM: Basic memory bitmaps freed
[   88.473890] OOM killer enabled.
[   88.474876] ext4 (sda1): thawing
[   88.585233] ata2.01: NODEV after polling detection
[   88.587805] ata2.00: configured for MWDMA2
[   88.589436] ata1.00: configured for MWDMA2
[   88.592421] ata1.01: configured for MWDMA2
[   88.601141] xfs (sdb1): thawing
[   88.602430] Restarting tasks ... done.
[   88.611055] PM: hibernation exit
[   90.492926] e1000: ens3 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   98.780159] firmware_class: device_uncache_fw_images

And ssh is working after this, without requiring to initiate another connection.

Let me know if you'd like me to test something else.

  Luis
