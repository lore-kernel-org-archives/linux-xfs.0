Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58624 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbfDBQmW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Apr 2019 12:42:22 -0400
Subject: Re: File system corruption in two hard disks
References: <20181211183203.7fdbca0f@lud1.home>
 <20190331224918.GO23020@dastard> <20190401181311.334e96e8@lud1.home>
 <20190401213226.GR26298@dastard> <20190402132357.0f72e3a9@lud1.home>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a99be49d-30f9-6be7-05a0-8abd2114c6d0@sandeen.net>
Date: Tue, 2 Apr 2019 11:42:21 -0500
MIME-Version: 1.0
In-Reply-To: <20190402132357.0f72e3a9@lud1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luciano ES <lucmove@gmail.com>, XFS mailing list <linux-xfs@vger.kernel.org>

On 4/2/19 11:23 AM, Luciano ES wrote:

> The other disk failed again. Here is some dmesg:
> 
> [    1.243231] sd 1:0:0:0: [sdb] 1250263728 512-byte logical blocks: (640 GB/596 GiB)
> [    1.243274] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.243276] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.243299] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    1.270253]  sdb: sdb1
> [    1.271133] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.272908]  sda: sda1 sda2 sda3 sda4 sda5 sda6
> [    1.273680] sd 0:0:0:0: [sda] Attached SCSI disk
> elided: lots of stuff about probing USB ports...
> [    3.777831] ata2.00: exception Emask 0x0 SAct 0x1000 SErr 0x0 action 0x0
> [    3.777882] ata2.00: irq_stat 0x40000008
> [    3.777926] ata2.00: failed command: READ FPDMA QUEUED
> [    3.777974] ata2.00: cmd 60/00:60:00:0a:00/01:00:00:00:00/40 tag 12 ncq dma 131072 in
>                         res 41/40:00:50:0a:00/00:00:00:00:00/40 Emask 0x409 (media error) <F>
> [    3.778038] ata2.00: status: { DRDY ERR }
> [    3.778080] ata2.00: error: { UNC }
> [    3.790298] ata2.00: configured for UDMA/133
> [    3.790312] sd 1:0:0:0: [sdb] tag#12 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE

This continues to look like a hardware/drive failure, not an xfs problem.

...

> Also:
> # xfs_repair -n /dev/sdb1
> Phase 1 - find and verify superblock...
> superblock read failed, offset 0, size 524288, ag 0, rval -1
> fatal error -- Input/output error

as does this.

> 
> I didn't have time to investigate more so I didn't even try smartctl on it.
> But looks like that disk is dead, doesn't it?

yep!

> :-(
> 
> 
