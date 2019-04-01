Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45795 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbfDAVc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 17:32:58 -0400
Date: Tue, 2 Apr 2019 08:32:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: File system corruption in two hard disks
Message-ID: <20190401213226.GR26298@dastard>
References: <20181211183203.7fdbca0f@lud1.home>
 <20190331224918.GO23020@dastard>
 <20190401181311.334e96e8@lud1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401181311.334e96e8@lud1.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Apr 01, 2019 at 06:13:11PM -0300, Luciano ES wrote:
> On Mon, 1 Apr 2019 09:49:18 +1100, Dave Chinner wrote:
> 
> > On Sun, Mar 31, 2019 at 04:41:47PM -0300, Luciano ES wrote:
> > > I have two hard disks that have been kept in storage for a little
> > > more than one year. I can read neither of them.
> > > 
> > > DISK 1: I tried to open it with cryptsetup. It wasn't recognized 
> > > as a LUKS partition, which is weird because I always use LUKS.
> > > 
> > > But it pops up as a mountable file system on the pcmanfm file
> > > manager. Clicking it to mount it as is gives me this error message:
> > > 
> > > Error mounting /dev/sdc1 at /media/ext/sm640: Command-line 
> > > `mount -t "xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdc1"
> > > "/media/ext/sm640"' exited with non-zero exit status 32: mount: 
> > > mount /dev/sdc1 on /media/ext/sm640 failed: Structure needs
> > > cleaning  
> > 
> > And the errors that XFS emitted in dmesg are... ?
> > 
> > Cheers,
> > 
> > Dave.
> 
> 
> **************************
> Thank you for your reply. Sorry I couldn't get back to you earlier.
> 
> Here is the dmesg output. I tried mounting them then running 'xfs_repair -n' 
> on each one of them.
> 
> DISK 1:
> [58267.353026] usb 2-1.2.4: new high-speed USB device number 17 using ehci-pci
> [58267.470031] usb 2-1.2.4: New USB device found, idVendor=13fd, idProduct=0840
> [58267.470033] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [58267.470033] usb 2-1.2.4: Product: External
> [58267.470034] usb 2-1.2.4: Manufacturer: Generic
> [58267.470035] usb 2-1.2.4: SerialNumber: [elided]
> [58267.470472] usb-storage 2-1.2.4:1.0: USB Mass Storage device detected
> [58267.470676] scsi host4: usb-storage 2-1.2.4:1.0
> [58268.481677] scsi 4:0:0:0: Direct-Access     Generic  External         1.14 PQ: 0 ANSI: 4
> [58268.482369] sd 4:0:0:0: Attached scsi generic sg2 type 0
> [58268.482918] sd 4:0:0:0: [sdc] 1250263727 512-byte logical blocks: (640 GB/596 GiB)
> [58268.483543] sd 4:0:0:0: [sdc] Write Protect is off
> [58268.483544] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
> [58268.484183] sd 4:0:0:0: [sdc] No Caching mode page found
> [58268.484186] sd 4:0:0:0: [sdc] Assuming drive cache: write through
> [58268.515922]  sdc: sdc1
> [58268.518417] sd 4:0:0:0: [sdc] Attached SCSI disk
> [58268.723169] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
> [58268.723171] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
> [58268.723173] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
> [58268.723175] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [58269.531556] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
> [58269.531559] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
> [58269.531561] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
> [58269.531563] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(12)/Blank a1 06 20 da 00 00 4f c2 00 b0 00 00
> [58271.587320] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [58271.587323] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
> [58271.587324] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
> [58271.587326] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 00 00 00 f0 00
> [58271.587327] blk_update_request: critical medium error, dev sdc, sector 2560

You're getting read errors from the disk itself i.e. the data
on the storage medium has degraded and no longer contains the same
information that was written to it.

> [58289.587483] blk_update_request: critical medium error, dev sdc, sector 2644
> [58289.587487] Buffer I/O error on dev sdc1, logical block 298, async page read
> [58289.587489] Buffer I/O error on dev sdc1, logical block 299, async page read
> [58289.788582] XFS (sdc1): Offline file system operation in progress!

Indicative of single bit errors in the superblock i.e. the "in
progress flag is set, which is only set during mkfs and is zero at
all other times. You could probably clear that field using xfs_db,
but it's likely there are lots of other problems with the disk...

> DISK 2:
> [57949.398186] usb 2-1.2.4: new high-speed USB device number 16 using ehci-pci
> [57949.519158] usb 2-1.2.4: New USB device found, idVendor=13fd, idProduct=0840
> [57949.519160] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [57949.519161] usb 2-1.2.4: Product: External
> [57949.519161] usb 2-1.2.4: Manufacturer: Generic
> [57949.519162] usb 2-1.2.4: SerialNumber: [elided]
> [57949.519441] usb-storage 2-1.2.4:1.0: USB Mass Storage device detected
> [57949.519883] scsi host4: usb-storage 2-1.2.4:1.0
> [57950.522787] scsi 4:0:0:0: Direct-Access     Generic  External         1.14 PQ: 0 ANSI: 4
> [57950.523080] sd 4:0:0:0: Attached scsi generic sg2 type 0
> [57950.523790] sd 4:0:0:0: [sdc] 234441647 512-byte logical blocks: (120 GB/112 GiB)
> [57950.524526] sd 4:0:0:0: [sdc] Write Protect is off
> [57950.524528] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
> [57950.525248] sd 4:0:0:0: [sdc] No Caching mode page found
> [57950.525251] sd 4:0:0:0: [sdc] Assuming drive cache: write through
> [57950.573656]  sdc: sdc1
> [57950.573659] sdc: p1 size 234439600 extends beyond EOD, enabling native capacity
> [57950.578529]  sdc: sdc1
> [57950.578530] sdc: p1 size 234439600 extends beyond EOD, truncated

The partition table indicates that partition 1 extends past the end
of the disk.

> [57950.580963] sd 4:0:0:0: [sdc] Attached SCSI disk
> [57950.913655] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
> [57950.913658] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
> [57950.913659] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
> [57950.913661] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
> [57951.045034] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
> [57951.045037] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
> [57951.045038] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
> [57951.045040] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(12)/Blank a1 06 20 da 00 00 4f c2 00 b0 00 00
> [57997.645037] attempt to access beyond end of device
> [57997.645039] dm-4: rw=16, want=234435504, limit=234435503
> [57997.645041] XFS (dm-4): last sector read failed
> [58040.866246] attempt to access beyond end of device

And XFs is trying to validate that it can read the last block of the
filesystem, which it can't because the partition is beyond the end
of the device.

At this point, I suspect your problems are the USB enclosure your
are using. Plug the disks directly into a SATA port and see if that
makes the IO errors go away. This looks like hardware problems, not
XFS issues...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
