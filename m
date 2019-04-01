Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f171.google.com ([209.85.160.171]:35674 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfDAVNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Apr 2019 17:13:19 -0400
Received: by mail-qt1-f171.google.com with SMTP id h39so12768812qte.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Apr 2019 14:13:17 -0700 (PDT)
Received: from lud1.home (177.205.145.158.dynamic.adsl.gvt.net.br. [177.205.145.158])
        by smtp.gmail.com with ESMTPSA id g5sm5941286qke.71.2019.04.01.14.13.15
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Apr 2019 14:13:16 -0700 (PDT)
Date: Mon, 1 Apr 2019 18:13:11 -0300
From: Luciano ES <lucmove@gmail.com>
Subject: Re: File system corruption in two hard disks
Message-ID: <20190401181311.334e96e8@lud1.home>
In-Reply-To: <20190331224918.GO23020@dastard>
References: <20181211183203.7fdbca0f@lud1.home>
        <20190331224918.GO23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, 1 Apr 2019 09:49:18 +1100, Dave Chinner wrote:

> On Sun, Mar 31, 2019 at 04:41:47PM -0300, Luciano ES wrote:
> > I have two hard disks that have been kept in storage for a little
> > more than one year. I can read neither of them.
> > 
> > DISK 1: I tried to open it with cryptsetup. It wasn't recognized 
> > as a LUKS partition, which is weird because I always use LUKS.
> > 
> > But it pops up as a mountable file system on the pcmanfm file
> > manager. Clicking it to mount it as is gives me this error message:
> > 
> > Error mounting /dev/sdc1 at /media/ext/sm640: Command-line 
> > `mount -t "xfs" -o "uhelper=udisks2,nodev,nosuid" "/dev/sdc1"
> > "/media/ext/sm640"' exited with non-zero exit status 32: mount: 
> > mount /dev/sdc1 on /media/ext/sm640 failed: Structure needs
> > cleaning  
> 
> And the errors that XFS emitted in dmesg are... ?
> 
> Cheers,
> 
> Dave.


**************************
Thank you for your reply. Sorry I couldn't get back to you earlier.

Here is the dmesg output. I tried mounting them then running 'xfs_repair -n' 
on each one of them.

DISK 1:
[58267.353026] usb 2-1.2.4: new high-speed USB device number 17 using ehci-pci
[58267.470031] usb 2-1.2.4: New USB device found, idVendor=13fd, idProduct=0840
[58267.470033] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[58267.470033] usb 2-1.2.4: Product: External
[58267.470034] usb 2-1.2.4: Manufacturer: Generic
[58267.470035] usb 2-1.2.4: SerialNumber: [elided]
[58267.470472] usb-storage 2-1.2.4:1.0: USB Mass Storage device detected
[58267.470676] scsi host4: usb-storage 2-1.2.4:1.0
[58268.481677] scsi 4:0:0:0: Direct-Access     Generic  External         1.14 PQ: 0 ANSI: 4
[58268.482369] sd 4:0:0:0: Attached scsi generic sg2 type 0
[58268.482918] sd 4:0:0:0: [sdc] 1250263727 512-byte logical blocks: (640 GB/596 GiB)
[58268.483543] sd 4:0:0:0: [sdc] Write Protect is off
[58268.483544] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
[58268.484183] sd 4:0:0:0: [sdc] No Caching mode page found
[58268.484186] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[58268.515922]  sdc: sdc1
[58268.518417] sd 4:0:0:0: [sdc] Attached SCSI disk
[58268.723169] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
[58268.723171] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
[58268.723173] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
[58268.723175] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[58269.531556] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
[58269.531559] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
[58269.531561] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
[58269.531563] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(12)/Blank a1 06 20 da 00 00 4f c2 00 b0 00 00
[58271.587320] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58271.587323] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58271.587324] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58271.587326] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 00 00 00 f0 00
[58271.587327] blk_update_request: critical medium error, dev sdc, sector 2560
[58273.860713] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58273.860716] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58273.860717] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58273.860719] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 50 00 00 02 00
[58273.860720] blk_update_request: critical medium error, dev sdc, sector 2640
[58273.860724] Buffer I/O error on dev sdc1, logical block 296, async page read
[58276.091606] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58276.091609] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58276.091610] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58276.091612] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 54 00 00 04 00
[58276.091613] blk_update_request: critical medium error, dev sdc, sector 2644
[58276.091616] Buffer I/O error on dev sdc1, logical block 298, async page read
[58276.091618] Buffer I/O error on dev sdc1, logical block 299, async page read
[58278.368375] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58278.368377] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58278.368378] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58278.368380] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 00 00 00 f0 00
[58278.368381] blk_update_request: critical medium error, dev sdc, sector 2560
[58280.608664] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58280.608667] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58280.608669] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58280.608671] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 50 00 00 02 00
[58280.608672] blk_update_request: critical medium error, dev sdc, sector 2640
[58280.608676] Buffer I/O error on dev sdc1, logical block 296, async page read
[58282.839557] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58282.839560] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58282.839561] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58282.839563] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 54 00 00 04 00
[58282.839565] blk_update_request: critical medium error, dev sdc, sector 2644
[58282.839568] Buffer I/O error on dev sdc1, logical block 298, async page read
[58282.839570] Buffer I/O error on dev sdc1, logical block 299, async page read
[58285.094179] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58285.094181] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58285.094183] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58285.094185] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 00 00 00 f0 00
[58285.094186] blk_update_request: critical medium error, dev sdc, sector 2560
[58287.323337] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58287.323340] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58287.323341] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58287.323344] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 50 00 00 02 00
[58287.323345] blk_update_request: critical medium error, dev sdc, sector 2640
[58287.323349] Buffer I/O error on dev sdc1, logical block 296, async page read
[58289.587476] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58289.587479] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58289.587480] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58289.587482] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 54 00 00 04 00
[58289.587483] blk_update_request: critical medium error, dev sdc, sector 2644
[58289.587487] Buffer I/O error on dev sdc1, logical block 298, async page read
[58289.587489] Buffer I/O error on dev sdc1, logical block 299, async page read
[58289.788582] XFS (sdc1): Offline file system operation in progress!
[58289.788614] XFS (sdc1): Metadata corruption detected at xfs_sb_read_verify+0x111/0x140 [xfs], xfs_sb block 0xffffffffffffffff
[58289.788617] XFS (sdc1): Unmount and run xfs_repair
[58289.788618] XFS (sdc1): First 64 bytes of corrupted metadata buffer:
[58289.788620] ffff9b34d9cd3000: 58 46 53 42 00 00 10 00 00 00 00 00 09 50 af 55  XFSB.........P.U
[58289.788621] ffff9b34d9cd3010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[58289.788622] ffff9b34d9cd3020: 53 df 87 aa a0 e0 42 30 ba 5f 36 4c c5 42 be e7  S.....B0._6L.B..
[58289.788623] ffff9b34d9cd3030: 00 00 00 00 08 00 00 05 ff ff ff ff ff ff ff ff  ................
[58289.788628] XFS (sdc1): SB validate failed with error -117.
[58290.764466] XFS (sdc1): Offline file system operation in progress!
[58290.764499] XFS (sdc1): Metadata corruption detected at xfs_sb_read_verify+0x111/0x140 [xfs], xfs_sb block 0xffffffffffffffff
[58290.764502] XFS (sdc1): Unmount and run xfs_repair
[58290.764502] XFS (sdc1): First 64 bytes of corrupted metadata buffer:
[58290.764504] ffff9b348d3fa000: 58 46 53 42 00 00 10 00 00 00 00 00 09 50 af 55  XFSB.........P.U
[58290.764505] ffff9b348d3fa010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[58290.764506] ffff9b348d3fa020: 53 df 87 aa a0 e0 42 30 ba 5f 36 4c c5 42 be e7  S.....B0._6L.B..
[58290.764507] ffff9b348d3fa030: 00 00 00 00 08 00 00 05 ff ff ff ff ff ff ff ff  ................
[58290.764511] XFS (sdc1): SB validate failed with error -117.
[58316.492438] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58316.492440] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58316.492441] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58316.492443] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 00 00 00 f0 00
[58316.492445] blk_update_request: critical medium error, dev sdc, sector 2560
[58318.699428] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58318.699431] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58318.699432] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58318.699434] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 50 00 00 02 00
[58318.699435] blk_update_request: critical medium error, dev sdc, sector 2640
[58318.699438] Buffer I/O error on dev sdc1, logical block 296, async page read
[58320.952446] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58320.952449] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58320.952450] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58320.952452] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 0a 54 00 00 04 00
[58320.952453] blk_update_request: critical medium error, dev sdc, sector 2644
[58320.952457] Buffer I/O error on dev sdc1, logical block 298, async page read
[58320.952459] Buffer I/O error on dev sdc1, logical block 299, async page read
[58321.152815] XFS (sdc1): Offline file system operation in progress!
[58321.152849] XFS (sdc1): Metadata corruption detected at xfs_sb_read_verify+0x111/0x140 [xfs], xfs_sb block 0xffffffffffffffff
[58321.152852] XFS (sdc1): Unmount and run xfs_repair
[58321.152853] XFS (sdc1): First 64 bytes of corrupted metadata buffer:
[58321.152855] ffff9b34acf07000: 58 46 53 42 00 00 10 00 00 00 00 00 09 50 af 55  XFSB.........P.U
[58321.152856] ffff9b34acf07010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[58321.152857] ffff9b34acf07020: 53 df 87 aa a0 e0 42 30 ba 5f 36 4c c5 42 be e7  S.....B0._6L.B..
[58321.152859] ffff9b34acf07030: 00 00 00 00 08 00 00 05 ff ff ff ff ff ff ff ff  ................
[58321.152864] XFS (sdc1): SB validate failed with error -117.
[58332.196671] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[58332.196674] sd 4:0:0:0: [sdc] tag#0 Sense Key : Medium Error [current] 
[58332.196675] sd 4:0:0:0: [sdc] tag#0 Add. Sense: Unrecovered read error
[58332.196677] sd 4:0:0:0: [sdc] tag#0 CDB: Read(10) 28 00 00 00 09 e0 00 00 f0 00
[58332.196678] blk_update_request: critical medium error, dev sdc, sector 2528
[58341.573221] XFS (sdc1): Offline file system operation in progress!
[58341.573252] XFS (sdc1): Metadata corruption detected at xfs_sb_read_verify+0x111/0x140 [xfs], xfs_sb block 0xffffffffffffffff
[58341.573255] XFS (sdc1): Unmount and run xfs_repair
[58341.573256] XFS (sdc1): First 64 bytes of corrupted metadata buffer:
[58341.573257] ffff9b34c7b05000: 58 46 53 42 00 00 10 00 00 00 00 00 09 50 af 55  XFSB.........P.U
[58341.573258] ffff9b34c7b05010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[58341.573259] ffff9b34c7b05020: 53 df 87 aa a0 e0 42 30 ba 5f 36 4c c5 42 be e7  S.....B0._6L.B..
[58341.573260] ffff9b34c7b05030: 00 00 00 00 08 00 00 05 ff ff ff ff ff ff ff ff  ................
[58341.573286] XFS (sdc1): SB validate failed with error -117.
[58345.707124] usb 2-1.2.4: USB disconnect, device number 17


DISK 2:
[57949.398186] usb 2-1.2.4: new high-speed USB device number 16 using ehci-pci
[57949.519158] usb 2-1.2.4: New USB device found, idVendor=13fd, idProduct=0840
[57949.519160] usb 2-1.2.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[57949.519161] usb 2-1.2.4: Product: External
[57949.519161] usb 2-1.2.4: Manufacturer: Generic
[57949.519162] usb 2-1.2.4: SerialNumber: [elided]
[57949.519441] usb-storage 2-1.2.4:1.0: USB Mass Storage device detected
[57949.519883] scsi host4: usb-storage 2-1.2.4:1.0
[57950.522787] scsi 4:0:0:0: Direct-Access     Generic  External         1.14 PQ: 0 ANSI: 4
[57950.523080] sd 4:0:0:0: Attached scsi generic sg2 type 0
[57950.523790] sd 4:0:0:0: [sdc] 234441647 512-byte logical blocks: (120 GB/112 GiB)
[57950.524526] sd 4:0:0:0: [sdc] Write Protect is off
[57950.524528] sd 4:0:0:0: [sdc] Mode Sense: 23 00 00 00
[57950.525248] sd 4:0:0:0: [sdc] No Caching mode page found
[57950.525251] sd 4:0:0:0: [sdc] Assuming drive cache: write through
[57950.573656]  sdc: sdc1
[57950.573659] sdc: p1 size 234439600 extends beyond EOD, enabling native capacity
[57950.578529]  sdc: sdc1
[57950.578530] sdc: p1 size 234439600 extends beyond EOD, truncated
[57950.580963] sd 4:0:0:0: [sdc] Attached SCSI disk
[57950.913655] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
[57950.913658] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
[57950.913659] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
[57950.913661] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(16) 85 06 20 00 00 00 00 00 00 00 00 00 00 00 e5 00
[57951.045034] sd 4:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_ERROR driverbyte=DRIVER_SENSE
[57951.045037] sd 4:0:0:0: [sdc] tag#0 Sense Key : Hardware Error [current] [descriptor] 
[57951.045038] sd 4:0:0:0: [sdc] tag#0 Add. Sense: No additional sense information
[57951.045040] sd 4:0:0:0: [sdc] tag#0 CDB: ATA command pass through(12)/Blank a1 06 20 da 00 00 4f c2 00 b0 00 00
[57997.645037] attempt to access beyond end of device
[57997.645039] dm-4: rw=16, want=234435504, limit=234435503
[57997.645041] XFS (dm-4): last sector read failed
[58040.866246] attempt to access beyond end of device
[58040.866249] dm-4: rw=16, want=234435504, limit=234435503
[58040.866251] XFS (dm-4): last sector read failed
[58046.339021] attempt to access beyond end of device
[58046.339023] dm-4: rw=16, want=234435504, limit=234435503
[58046.339025] XFS (dm-4): last sector read failed
[58190.058091] usb 2-1.2.4: USB disconnect, device number 16


(Note: I ran disk2 before disk 1 and inverted the order of the 
outputs here just to keep it consistent with my initial report. 
It probably doesn't matter.)


-- 
Luciano ES
>>
