Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40665 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730238AbfDBQYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 12:24:03 -0400
Received: by mail-qt1-f193.google.com with SMTP id x12so15920665qts.7
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2019 09:24:02 -0700 (PDT)
Received: from lud1.home (177.205.145.158.dynamic.adsl.gvt.net.br. [177.205.145.158])
        by smtp.gmail.com with ESMTPSA id i20sm6995285qkk.70.2019.04.02.09.23.59
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Apr 2019 09:24:01 -0700 (PDT)
Date: Tue, 2 Apr 2019 13:23:57 -0300
From: Luciano ES <lucmove@gmail.com>
Subject: Re: File system corruption in two hard disks
Message-ID: <20190402132357.0f72e3a9@lud1.home>
In-Reply-To: <20190401213226.GR26298@dastard>
References: <20181211183203.7fdbca0f@lud1.home>
        <20190331224918.GO23020@dastard>
        <20190401181311.334e96e8@lud1.home>
        <20190401213226.GR26298@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: XFS mailing list <linux-xfs@vger.kernel.org>

On Tue, 2 Apr 2019 08:32:26 +1100, Dave Chinner wrote:

> On Mon, Apr 01, 2019 at 06:13:11PM -0300, Luciano ES wrote:
> > On Mon, 1 Apr 2019 09:49:18 +1100, Dave Chinner wrote:
> >   
> > > On Sun, Mar 31, 2019 at 04:41:47PM -0300, Luciano ES wrote:  
> > > > I have two hard disks that have been kept in storage for a
> > > > little more than one year. I can read neither of them.
> > > > 
> > > > DISK 1: I tried to open it with cryptsetup. It wasn't
> > > > recognized as a LUKS partition, which is weird because I always
> > > > use LUKS.
> > > > 
> > > > But it pops up as a mountable file system on the pcmanfm file
> > > > manager. Clicking it to mount it as is gives me this error
> > > > message:
> > > > 
> > > > Error mounting /dev/sdc1 at /media/ext/sm640: Command-line 
> > > > `mount -t "xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdc1"
> > > > "/media/ext/sm640"' exited with non-zero exit status 32: mount: 
> > > > mount /dev/sdc1 on /media/ext/sm640 failed: Structure needs
> > > > cleaning    
> > > 
> > > And the errors that XFS emitted in dmesg are... ?
> > > 
> > > Cheers,
> > > 
> > > Dave.  
> > 
> > 
> > **************************
> > Thank you for your reply. Sorry I couldn't get back to you earlier.
> > 
> > Here is the dmesg output. I tried mounting them then running
> > 'xfs_repair -n' on each one of them.
> > 
> > DISK 1:
> > [58267.353026] usb 2-1.2.4: new high-speed USB device number 17
> > using ehci-pci [58267.470031] usb 2-1.2.4: New USB device found,
> > idVendor=13fd, idProduct=0840 [58267.470033] usb 2-1.2.4: New USB
> > device strings: Mfr=1, Product=2, SerialNumber=3 [58267.470033] usb
> > 2-1.2.4: Product: External [58267.470034] usb 2-1.2.4:
> > Manufacturer: Generic [58267.470035] usb 2-1.2.4: SerialNumber:
> > [elided] [58267.470472] usb-storage 2-1.2.4:1.0: USB Mass Storage
> > device detected [58267.470676] scsi host4: usb-storage 2-1.2.4:1.0
> > [58268.481677] scsi 4:0:0:0: Direct-Access     Generic
> > External         1.14 PQ: 0 ANSI: 4 [58268.482369] sd 4:0:0:0:
> > Attached scsi generic sg2 type 0 [58268.482918] sd 4:0:0:0: [sdc]
> > 1250263727 512-byte logical blocks: (640 GB/596 GiB) [58268.483543]
> > sd 4:0:0:0: [sdc] Write Protect is off [58268.483544] sd 4:0:0:0:
> > [sdc] Mode Sense: 23 00 00 00 [58268.484183] sd 4:0:0:0: [sdc] No
> > Caching mode page found [58268.484186] sd 4:0:0:0: [sdc] Assuming
> > drive cache: write through [58268.515922]  sdc: sdc1
> > [58268.518417] sd 4:0:0:0: [sdc] Attached SCSI disk
> > [58268.723169] sd 4:0:0:0: [sdc] tag#0 FAILED Result:
> > hostbyte=DID_ERROR driverbyte=DRIVER_SENSE [58268.723171] sd
> > 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current]
> > [descriptor] [58268.723173] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No
> > additional sense information [58268.723175] sd 4:0:0:0: [sdc] tag#0
> > CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00
> > 00 00 00 e5 00 [58269.531556] sd 4:0:0:0: [sdc] tag#0 FAILED
> > Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE [58269.531559]
> > sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current]
> > [descriptor] [58269.531561] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No
> > additional sense information [58269.531563] sd 4:0:0:0: [sdc] tag#0
> > CDB: ATA command pass through(12)/Blank a1 06 20 da 00 00 4f c2 00
> > b0 00 00 [58271.587320] sd 4:0:0:0: [sdc] tag#0 FAILED Result:
> > hostbyte=DID_OK driverbyte=DRIVER_SENSE [58271.587323] sd 4:0:0:0:
> > [sdc] tag#0 Sense Key : Medium Error [current] [58271.587324] sd
> > 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
> > [58271.587326] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a
> > 00 00 00 f0 00 [58271.587327] blk_update_request: critical medium
> > error, dev sdc, sector 2560  
> 
> You're getting read errors from the disk itself i.e. the data
> on the storage medium has degraded and no longer contains the same
> information that was written to it.
> 
> > [58289.587483] blk_update_request: critical medium error, dev sdc,
> > sector 2644 [58289.587487] Buffer I/O error on dev sdc1, logical
> > block 298, async page read [58289.587489] Buffer I/O error on dev
> > sdc1, logical block 299, async page read [58289.788582] XFS (sdc1):
> > Offline file system operation in progress!  
> 
> Indicative of single bit errors in the superblock i.e. the "in
> progress flag is set, which is only set during mkfs and is zero at
> all other times. You could probably clear that field using xfs_db,
> but it's likely there are lots of other problems with the disk...
> 
> > DISK 2:
> > [57949.398186] usb 2-1.2.4: new high-speed USB device number 16
> > using ehci-pci [57949.519158] usb 2-1.2.4: New USB device found,
> > idVendor=13fd, idProduct=0840 [57949.519160] usb 2-1.2.4: New USB
> > device strings: Mfr=1, Product=2, SerialNumber=3 [57949.519161] usb
> > 2-1.2.4: Product: External [57949.519161] usb 2-1.2.4:
> > Manufacturer: Generic [57949.519162] usb 2-1.2.4: SerialNumber:
> > [elided] [57949.519441] usb-storage 2-1.2.4:1.0: USB Mass Storage
> > device detected [57949.519883] scsi host4: usb-storage 2-1.2.4:1.0
> > [57950.522787] scsi 4:0:0:0: Direct-Access     Generic
> > External         1.14 PQ: 0 ANSI: 4 [57950.523080] sd 4:0:0:0:
> > Attached scsi generic sg2 type 0 [57950.523790] sd 4:0:0:0: [sdc]
> > 234441647 512-byte logical blocks: (120 GB/112 GiB) [57950.524526]
> > sd 4:0:0:0: [sdc] Write Protect is off [57950.524528] sd 4:0:0:0:
> > [sdc] Mode Sense: 23 00 00 00 [57950.525248] sd 4:0:0:0: [sdc] No
> > Caching mode page found [57950.525251] sd 4:0:0:0: [sdc] Assuming
> > drive cache: write through [57950.573656]  sdc: sdc1
> > [57950.573659] sdc: p1 size 234439600 extends beyond EOD, enabling
> > native capacity [57950.578529]  sdc: sdc1
> > [57950.578530] sdc: p1 size 234439600 extends beyond EOD,
> > truncated  
> 
> The partition table indicates that partition 1 extends past the end
> of the disk.
> 
> > [57950.580963] sd 4:0:0:0: [sdc] Attached SCSI disk
> > [57950.913655] sd 4:0:0:0: [sdc] tag#0 FAILED Result:
> > hostbyte=DID_ERROR driverbyte=DRIVER_SENSE [57950.913658] sd
> > 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current]
> > [descriptor] [57950.913659] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No
> > additional sense information [57950.913661] sd 4:0:0:0: [sdc] tag#0
> > CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00
> > 00 00 00 e5 00 [57951.045034] sd 4:0:0:0: [sdc] tag#0 FAILED
> > Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE [57951.045037]
> > sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current]
> > [descriptor] [57951.045038] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No
> > additional sense information [57951.045040] sd 4:0:0:0: [sdc] tag#0
> > CDB: ATA command pass through(12)/Blank a1 06 20 da 00 00 4f c2 00
> > b0 00 00 [57997.645037] attempt to access beyond end of device
> > [57997.645039] dm-4: rw=16, want=234435504, limit=234435503
> > [57997.645041] XFS (dm-4): last sector read failed [58040.866246]
> > attempt to access beyond end of device  
> 
> And XFs is trying to validate that it can read the last block of the
> filesystem, which it can't because the partition is beyond the end
> of the device.
> 
> At this point, I suspect your problems are the USB enclosure your
> are using. Plug the disks directly into a SATA port and see if that
> makes the IO errors go away. This looks like hardware problems, not
> XFS issues...
> 
> Cheers,
> 
> Dave.

**************************

Hi. Thank you for your kind attention again.

I tested the disks directly connected to the SATA ports this time. 
One of them worked flawlessly. 

Damn! It's the third USB enclosure that fails on me in one year!

The other disk failed again. Here is some dmesg:

[    1.243231] sd 1:0:0:0: [sdb] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
[    1.243274] sd 1:0:0:0: [sdb] Write Protect is off
[    1.243276] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.243299] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.270253]  sdb: sdb1
[    1.271133] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.272908]  sda: sda1 sda2 sda3 sda4 sda5 sda6
[    1.273680] sd 0:0:0:0: [sda] Attached SCSI disk
elided: lots of stuff about probing USB ports...
[    3.777831] ata2.00: exception Emask 0x0 SAct 0x1000 SErr 0x0 action 0x0
[    3.777882] ata2.00: irq_stat 0x40000008
[    3.777926] ata2.00: failed command: READ FPDMA QUEUED
[    3.777974] ata2.00: cmd 60/00:60:00:0a:00/01:00:00:00:00/40 tag 12 ncq dma 131072 in
                        res 41/40:00:50:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[    3.778038] ata2.00: status: { DRDY ERR }
[    3.778080] ata2.00: error: { UNC }
[    3.790298] ata2.00: configured for UDMA/133
[    3.790312] sd 1:0:0:0: [sdb] tag#12 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    3.790315] sd 1:0:0:0: [sdb] tag#12 Sense Key : Medium Error [current] 
[    3.790318] sd 1:0:0:0: [sdb] tag#12 Add. Sense: Unrecovered read error - auto reallocate failed
[    3.790321] sd 1:0:0:0: [sdb] tag#12 CDB: Read(10) 28 00 00 00 0a 00 00 01 00 00
[    3.790323] blk_update_request: I/O error, dev sdb, sector 2640
[    3.790401] ata2: EH complete
[    6.033996] ata2.00: exception Emask 0x0 SAct 0x3c000000 SErr 0x0 action 0x0
[    6.034060] ata2.00: irq_stat 0x40000008
[    6.034115] ata2.00: failed command: READ FPDMA QUEUED
[    6.034175] ata2.00: cmd 60/02:d0:50:0a:00/00:00:00:00:00/40 tag 26 ncq dma 1024 in
                        res 41/40:00:50:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[    6.034287] ata2.00: status: { DRDY ERR }
[    6.034341] ata2.00: error: { UNC }
[    6.046572] ata2.00: configured for UDMA/133
[    6.046584] sd 1:0:0:0: [sdb] tag#26 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    6.046586] sd 1:0:0:0: [sdb] tag#26 Sense Key : Medium Error [current] 
[    6.046588] sd 1:0:0:0: [sdb] tag#26 Add. Sense: Unrecovered read error - auto reallocate failed
[    6.046591] sd 1:0:0:0: [sdb] tag#26 CDB: Read(10) 28 00 00 00 0a 50 00 00 02 00
[    6.046593] blk_update_request: I/O error, dev sdb, sector 2640
[    6.046653] Buffer I/O error on dev sdb1, logical block 296, async page read
[    6.046723] ata2: EH complete
[    8.286163] ata2.00: exception Emask 0x0 SAct 0x1c000 SErr 0x0 action 0x0
[    8.286226] ata2.00: irq_stat 0x40000008
[    8.286282] ata2.00: failed command: READ FPDMA QUEUED
[    8.286342] ata2.00: cmd 60/02:70:56:0a:00/00:00:00:00:00/40 tag 14 ncq dma 1024 in
                        res 41/40:00:56:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[    8.286454] ata2.00: status: { DRDY ERR }
[    8.286508] ata2.00: error: { UNC }
[    8.298738] ata2.00: configured for UDMA/133
[    8.298749] sd 1:0:0:0: [sdb] tag#14 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[    8.298752] sd 1:0:0:0: [sdb] tag#14 Sense Key : Medium Error [current] 
[    8.298754] sd 1:0:0:0: [sdb] tag#14 Add. Sense: Unrecovered read error - auto reallocate failed
[    8.298757] sd 1:0:0:0: [sdb] tag#14 CDB: Read(10) 28 00 00 00 0a 56 00 00 02 00
[    8.298758] blk_update_request: I/O error, dev sdb, sector 2646
[    8.298818] Buffer I/O error on dev sdb1, logical block 299, async page read
[    8.298889] ata2: EH complete
elided: lots of initialization/ACPI stuff...
[   15.630752] ata2.00: exception Emask 0x0 SAct 0x8000000 SErr 0x0 action 0x0
[   15.630803] ata2.00: irq_stat 0x40000008
[   15.630830] ata2.00: failed command: READ FPDMA QUEUED
[   15.630865] ata2.00: cmd 60/00:d8:00:0a:00/01:00:00:00:00/40 tag 27 ncq dma 131072 in
                        res 41/40:00:50:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[   15.630951] ata2.00: status: { DRDY ERR }
[   15.630976] ata2.00: error: { UNC }
[   15.643146] ata2.00: configured for UDMA/133
[   15.643162] sd 1:0:0:0: [sdb] tag#27 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   15.643165] sd 1:0:0:0: [sdb] tag#27 Sense Key : Medium Error [current] 
[   15.643167] sd 1:0:0:0: [sdb] tag#27 Add. Sense: Unrecovered read error - auto reallocate failed
[   15.643170] sd 1:0:0:0: [sdb] tag#27 CDB: Read(10) 28 00 00 00 0a 00 00 01 00 00
[   15.643172] blk_update_request: I/O error, dev sdb, sector 2640
[   15.643229] ata2: EH complete
[   17.882935] ata2.00: exception Emask 0x0 SAct 0x3c00 SErr 0x0 action 0x0
[   17.882984] ata2.00: irq_stat 0x40000008
[   17.883011] ata2.00: failed command: READ FPDMA QUEUED
[   17.883045] ata2.00: cmd 60/02:50:50:0a:00/00:00:00:00:00/40 tag 10 ncq dma 1024 in
                        res 41/40:00:50:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[   17.883130] ata2.00: status: { DRDY ERR }
[   17.883155] ata2.00: error: { UNC }
[   17.895264] ata2.00: configured for UDMA/133
[   17.895276] sd 1:0:0:0: [sdb] tag#10 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   17.895279] sd 1:0:0:0: [sdb] tag#10 Sense Key : Medium Error [current] 
[   17.895281] sd 1:0:0:0: [sdb] tag#10 Add. Sense: Unrecovered read error - auto reallocate failed
[   17.895284] sd 1:0:0:0: [sdb] tag#10 CDB: Read(10) 28 00 00 00 0a 50 00 00 02 00
[   17.895286] blk_update_request: I/O error, dev sdb, sector 2640
[   17.895328] Buffer I/O error on dev sdb1, logical block 296, async page read
[   17.895377] ata2: EH complete
[   20.127110] ata2.00: exception Emask 0x0 SAct 0x60000001 SErr 0x0 action 0x0
[   20.127161] ata2.00: irq_stat 0x40000008
[   20.127188] ata2.00: failed command: READ FPDMA QUEUED
[   20.127223] ata2.00: cmd 60/02:e8:56:0a:00/00:00:00:00:00/40 tag 29 ncq dma 1024 in
                        res 41/40:00:56:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[   20.127307] ata2.00: status: { DRDY ERR }
[   20.127332] ata2.00: error: { UNC }
[   20.139450] ata2.00: configured for UDMA/133
[   20.139468] sd 1:0:0:0: [sdb] tag#29 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   20.139470] sd 1:0:0:0: [sdb] tag#29 Sense Key : Medium Error [current] 
[   20.139473] sd 1:0:0:0: [sdb] tag#29 Add. Sense: Unrecovered read error - auto reallocate failed
[   20.139475] sd 1:0:0:0: [sdb] tag#29 CDB: Read(10) 28 00 00 00 0a 56 00 00 02 00
[   20.139477] blk_update_request: I/O error, dev sdb, sector 2646
[   20.139517] Buffer I/O error on dev sdb1, logical block 299, async page read
[   20.139564] ata2: EH complete
elided: more initialization, sound, other partitions being mounted cleanly etc...
[  149.808922] XFS (sdb1): Offline file system operation in progress!
[  149.808973] XFS (sdb1): Metadata corruption detected at xfs_sb_read_verify+0x111/0x140 [xfs], xfs_sb block 0xffffffffffffffff
[  149.808978] XFS (sdb1): Unmount and run xfs_repair
[  149.808980] XFS (sdb1): First 64 bytes of corrupted metadata buffer:
[  149.808983] ffff9b459bf9a000: 58 46 53 42 00 00 10 00 00 00 00 00 09 50 af 55  XFSB.........P.U
[  149.808985] ffff9b459bf9a010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  149.808987] ffff9b459bf9a020: 53 df 87 aa a0 e0 42 30 ba 5f 36 4c c5 42 be e7  S.....B0._6L.B..
[  149.808989] ffff9b459bf9a030: 00 00 00 00 08 00 00 05 ff ff ff ff ff ff ff ff  ................
[  149.809036] XFS (sdb1): SB validate failed with error -117.
[  234.394294] ata2.00: exception Emask 0x0 SAct 0x400 SErr 0x0 action 0x0
[  234.394299] ata2.00: irq_stat 0x40000008
[  234.394303] ata2.00: failed command: READ FPDMA QUEUED
[  234.394308] ata2.00: cmd 60/00:50:00:08:00/04:00:00:00:00/40 tag 10 ncq dma 524288 in
                        res 41/40:00:50:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
[  234.394311] ata2.00: status: { DRDY ERR }
[  234.394313] ata2.00: error: { UNC }
[  234.406484] ata2.00: configured for UDMA/133
[  234.406502] sd 1:0:0:0: [sdb] tag#10 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  234.406505] sd 1:0:0:0: [sdb] tag#10 Sense Key : Medium Error [current] 
[  234.406507] sd 1:0:0:0: [sdb] tag#10 Add. Sense: Unrecovered read error - auto reallocate failed
[  234.406510] sd 1:0:0:0: [sdb] tag#10 CDB: Read(10) 28 00 00 00 08 00 00 04 00 00
[  234.406512] blk_update_request: I/O error, dev sdb, sector 2640
[  234.406538] ata2: EH complete


Also:
# xfs_repair -n /dev/sdb1
Phase 1 - find and verify superblock...
superblock read failed, offset 0, size 524288, ag 0, rval -1
fatal error -- Input/output error


I didn't have time to investigate more so I didn't even try smartctl on it.
But looks like that disk is dead, doesn't it?
:-(


-- 
Luciano ES
>>
