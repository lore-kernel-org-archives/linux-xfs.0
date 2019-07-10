Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:31608 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727552AbfGJP3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jul 2019 11:29:02 -0400
Date: Wed, 10 Jul 2019 18:28:51 +0300
From: Andrey Zhunev <a-j@a-j.ru>
Message-ID: <1373677058.20190710182851@a-j.ru>
Subject: Re: Need help to recover root filesystem after a power supply issue
In-Reply-To: <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
References: <958316946.20190710124710@a-j.ru>
  <CAJCQCtTpdGxB4r04wPNE+PRV5Jx_m95kShwvLJ5zxdmfw2fnEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs list <linux-xfs@vger.kernel.org>

Wednesday, July 10, 2019, 5:30:37 PM, you wrote:

> On Wed, Jul 10, 2019 at 3:52 AM Andrey Zhunev <a-j@a-j.ru> wrote:
>>
>> [root@tftp ~]# xfs_repair /dev/centos/root
>> Phase 1 - find and verify superblock...
>> superblock read failed, offset 53057945600, size 131072, ag 2, rval -1
>>
>> fatal error -- Input/output error
>> [root@tftp ~]#

> # smartctl -l scterc /dev/

> Point it to the physical device. If it's a consumer drive, it might
> support a configurable SCT ERC. Also need to see the kernel messages
> at the time of the i/o error. There's some chance if a deep recover
> read is possible, it'll recover the data. But I don't see how this is
> related to power supply failure.



Well, this machine is always online (24/7, with a UPS backup power).
Yesterday we found it switched OFF, without any signs of life. Trying
to switch it on, the PSU made a humming noise and the machine didn't
even try to start. So we replaced the PSU. After that, the machine
powered on - but refused to boot... Something tells me these two
failures are likely related...



# smartctl -l scterc /dev/sda
smartctl 6.5 2016-05-07 r4318 [x86_64-linux-3.10.0-957.el7.x86_64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

#

This is a WD RED series drive, WD30EFRX.
Here are some more of the error messages from kernel log file:

Jul 10 11:59:03 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x100000 SErr 0x0 action 0x0
Jul 10 11:59:03 mgmt kernel: ata1.00: irq_stat 0x40000008
Jul 10 11:59:03 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
Jul 10 11:59:03 mgmt kernel: ata1.00: cmd 60/08:a0:d8:c3:84/00:00:0a:00:00/40 tag 20 ncq 4096 in#012         res 41/40:00:d8:c3:84/00:00:0a:00:00/40 Emask 0x409 (media error) <F>
Jul 10 11:59:03 mgmt kernel: ata1.00: status: { DRDY ERR }
Jul 10 11:59:03 mgmt kernel: ata1.00: error: { UNC }
Jul 10 11:59:03 mgmt kernel: ata1.00: configured for UDMA/133
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 Sense Key : Medium Error [current] [descriptor]
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 Add. Sense: Unrecovered read error - auto reallocate failed
Jul 10 11:59:03 mgmt kernel: sd 0:0:0:0: [sda] tag#20 CDB: Read(16) 88 00 00 00 00 00 0a 84 c3 d8 00 00 00 08 00 00
Jul 10 11:59:03 mgmt kernel: blk_update_request: I/O error, dev sda, sector 176473048
Jul 10 11:59:03 mgmt kernel: Buffer I/O error on dev sda, logical block 22059131, async page read
Jul 10 11:59:03 mgmt kernel: ata1: EH complete
Jul 10 11:59:05 mgmt kernel: ata1.00: exception Emask 0x0 SAct 0x1000000 SErr 0x0 action 0x0
Jul 10 11:59:05 mgmt kernel: ata1.00: irq_stat 0x40000008
Jul 10 11:59:05 mgmt kernel: ata1.00: failed command: READ FPDMA QUEUED
Jul 10 11:59:05 mgmt kernel: ata1.00: cmd 60/08:c0:d8:c3:84/00:00:0a:00:00/40 tag 24 ncq 4096 in#012         res 41/40:00:d8:c3:84/00:00:0a:00:00/40 Emask 0x409 (media error) <F>
Jul 10 11:59:05 mgmt kernel: ata1.00: status: { DRDY ERR }
Jul 10 11:59:05 mgmt kernel: ata1.00: error: { UNC }
Jul 10 11:59:05 mgmt kernel: ata1.00: configured for UDMA/133
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 Sense Key : Medium Error [current] [descriptor]
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 Add. Sense: Unrecovered read error - auto reallocate failed
Jul 10 11:59:05 mgmt kernel: sd 0:0:0:0: [sda] tag#24 CDB: Read(16) 88 00 00 00 00 00 0a 84 c3 d8 00 00 00 08 00 00
Jul 10 11:59:05 mgmt kernel: blk_update_request: I/O error, dev sda, sector 176473048
Jul 10 11:59:05 mgmt kernel: Buffer I/O error on dev sda, logical block 22059131, async page read
Jul 10 11:59:05 mgmt kernel: ata1: EH complete





---
Best regards,
 Andrey
