Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41478 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbfGJPXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jul 2019 11:23:21 -0400
Subject: Re: Need help to recover root filesystem after a power supply issue
References: <871210488.20190710125617@a-j.ru>
 <fcbcd66e-0c78-f13b-e7aa-1487090d1dfd@sandeen.net>
 <433120592.20190710165841@a-j.ru>
 <8bef8d1e-2f5f-a8bd-08d3-fff0dce1256e@sandeen.net>
 <15810023599.20190710180230@a-j.ru>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2c813b5e-5930-0e3d-db98-d7cab1bcf562@sandeen.net>
Date: Wed, 10 Jul 2019 10:23:18 -0500
MIME-Version: 1.0
In-Reply-To: <15810023599.20190710180230@a-j.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrey Zhunev <a-j@a-j.ru>, linux-xfs@vger.kernel.org


On 7/10/19 10:02 AM, Andrey Zhunev wrote:
> Wednesday, July 10, 2019, 5:23:41 PM, you wrote:
...

 
>> As I said, look at dmesg to see what failed on the original drive read
>> attempt.
> 
>> ddrescue will fill unreadable sectors with 0, and then of course that
>> can be read from the image file.
> 
> 
> Ooops, I forgot to paste the error message from dmesg.
> Here it is:
> 
> Jul 10 11:48:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x180000 SErr 0x0 action 0x0
> Jul 10 11:48:05 mgmt kernel: ata1.00: irq_stat 0x40000008
> Jul 10 11:48:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
> Jul 10 11:48:05 mgmt kernel: ata1.00: cmd 60/00:98:28:ac:3e/01:00:03:00:00/40 tag 19 ncq 131072 in#012         res 41/40:00:08:ad:3e/00:00:03:00:00/40 Emask 0x409 (media error) <F>
> Jul 10 11:48:05 mgmt kernel: ata1.00: status: { DRDY ERR }
> Jul 10 11:48:05 mgmt kernel: ata1.00: error: { UNC }
> Jul 10 11:48:05 mgmt kernel: ata1.00: configured for UDMA/133
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Sense Key : Medium Error [current] [descriptor]
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 Add. Sense: Unrecovered read error - auto reallocate failed
> Jul 10 11:48:05 mgmt kernel: sd 0:0:0:0: [sda] tag#19 CDB: Read(16) 88 00 00 00 00 00 03 3e ac 28 00 00 01 00 00 00
> Jul 10 11:48:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 54439176
> Jul 10 11:48:05 mgmt kernel: ata1: EH complete
> 
> There are several of these.
> At the moment ddrescue reports 22 read errors (with 35% of the data
> copied to a new storage). If I remember correctly, the LVM with my
> root partition is at the end of the drive. This means more errors will
> likely come... :( 
> 
> The way I interpret the dmesg message, that's just a read error. I'm
> not sure, but maybe a complete wipe of the drive will even overwrite /
> clear these unreadable sectors.
> Well, that's something to be checked after the copy process finishes.

Yep so hardware error, ddrescue will fill unreadable sectors with zeros, then you
can see whether or not xfs_repair can cope with what is left.

overwriting the sectors may "fix" them but I would never trust that drive
after this, personally.  ;)

-Eric
