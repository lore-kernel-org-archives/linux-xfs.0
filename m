Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0E5C43463
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 17:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40228208B8
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 17:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgISRaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 13:30:46 -0400
Received: from sandeen.net ([63.231.237.45]:33260 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgISRaq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Sep 2020 13:30:46 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6A89115B1A;
        Sat, 19 Sep 2020 12:29:56 -0500 (CDT)
To:     =?UTF-8?Q?Agust=c3=adn_Casasampere_Fernandez?= 
        <nitsuga5124@gmail.com>, xfs <linux-xfs@vger.kernel.org>
References: <2f7bfe5c-13c9-4c12-3c0a-2c1752709749@gmail.com>
 <2aa1b309-8d7f-1b5a-6826-c31419b2488d@sandeen.net>
 <CAFTiD3mSLZ6nBk+kZJX=jaOFA4JzfhJ9FW5c42z5UqoTpiXaKg@mail.gmail.com>
 <3eabe989-ba3c-bf8e-8b45-511d343cd4c7@sandeen.net>
 <CAFTiD3myam_0wHvBRuuYt9xs0Pj0H-QBz=5sptn2=5zgoPnZEQ@mail.gmail.com>
 <6cf327a7-bac0-7297-1b4a-6ce3860fb7fd@sandeen.net>
 <CAFTiD3m2Z-G3=iRMv4hJiXj1fg4fkxzU1z4fdp6GVxp7ckTKgg@mail.gmail.com>
 <4f69f4ce-6533-9480-23b0-4d1b0d5dc646@sandeen.net>
 <CAFTiD3=6huVFn0gqpKGc2r4avTXWEMTuX2UjKCUTAmd1Gxi8OA@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Disk Repair failing with err 117 (Help Recovering Data)
Message-ID: <037e7beb-57f8-2454-30ff-6243ac04d535@sandeen.net>
Date:   Sat, 19 Sep 2020 12:30:45 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAFTiD3=6huVFn0gqpKGc2r4avTXWEMTuX2UjKCUTAmd1Gxi8OA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

(argh and somehow I lost the list cc: again)

To recap:

> Sep 16 21:47:44 ArchPC kernel: ata3.00: exception Emask 0x0 SAct 0x20 SErr 0x0 action 0x0
> Sep 16 21:47:44 ArchPC kernel: ata3.00: irq_stat 0x40000008
> Sep 16 21:47:44 ArchPC kernel: ata3.00: failed command: READ FPDMA QUEUED
> Sep 16 21:47:44 ArchPC kernel: ata3.00: cmd 60/80:28:80:40:9b/00:00:1b:00:00/40 tag 5 ncq dma 65536 in
>                                         res 43/40:80:b0:40:9b/00:00:1b:00:00/00 Emask 0x409 (media error) <F>
> Sep 16 21:47:44 ArchPC kernel: ata3.00: status: { DRDY SENSE ERR }
> Sep 16 21:47:44 ArchPC kernel: ata3.00: error: { UNC }
> Sep 16 21:47:44 ArchPC kernel: audit: type=1130 audit(1600285664.564:3248): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=spdynu comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> Sep 16 21:47:44 ArchPC kernel: ata3.00: configured for UDMA/133
> Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
> Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 Sense Key : Medium Error [current] 
> Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 Add. Sense: Unrecovered read error - auto reallocate failed
> Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 CDB: Read(16) 88 00 00 00 00 00 1b 9b 40 80 00 00 00 80 00 00
> Sep 16 21:47:44 ArchPC kernel: blk_update_request: I/O error, dev sdc, sector 463159472 op 0x0:(READ) flags 0x0 phys_seg 10 prio class 0
> Sep 16 21:47:44 ArchPC kernel: ata3: EH complete

...

>>> From the dmesg, you have errors on sdc.  What is the physical volume behind dm-1?  Is this sdc, or is this a cdrom?
>> /dev/sdc is the only drive with XFS on my system, i don't have a cdrom.
> 
> Then I think your hardware is failing.


On 9/19/20 12:17 PM, Agustín Casasampere Fernandez wrote:
>> Then I think your hardware is failing.
> Is there any way to recover the data?

There are data recovery firms out there, but I can't help you with hardware issues.

> like, clear the inode that can't be mapped, so xfs_repair can at least try to do something, or some utility that will allow me to copy some of the files over from /dev/mapper/storage over to a different hard drive?
> 
> I still think this is not a hardware issue, the drive is way too new, and it's not that heavy on use, it has never been filled, and it's location has been static.

Then perhaps it's a driver error, but the dmesg says "media error" and "Unrecovered read error"

This isn't something XFS can fix or recover from; the problem seems to lie
below the filesystem.

-Eric
