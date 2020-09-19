Return-Path: <SRS0=s1/4=C4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C92C43464
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 16:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 492582100A
	for <linux-xfs@archiver.kernel.org>; Sat, 19 Sep 2020 16:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgISQ6n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 19 Sep 2020 12:58:43 -0400
Received: from sandeen.net ([63.231.237.45]:59848 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgISQ6n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 19 Sep 2020 12:58:43 -0400
Received: from liberator.sandeen.net (usg [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2C3FE15B1A;
        Sat, 19 Sep 2020 11:57:53 -0500 (CDT)
To:     =?UTF-8?Q?Agust=c3=adn_Casasampere_Fernandez?= 
        <nitsuga5124@gmail.com>, linux-xfs@vger.kernel.org
References: <2f7bfe5c-13c9-4c12-3c0a-2c1752709749@gmail.com>
 <2aa1b309-8d7f-1b5a-6826-c31419b2488d@sandeen.net>
 <CAFTiD3mSLZ6nBk+kZJX=jaOFA4JzfhJ9FW5c42z5UqoTpiXaKg@mail.gmail.com>
 <3eabe989-ba3c-bf8e-8b45-511d343cd4c7@sandeen.net>
 <CAFTiD3myam_0wHvBRuuYt9xs0Pj0H-QBz=5sptn2=5zgoPnZEQ@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: XFS Disk Repair failing with err 117 (Help Recovering Data)
Message-ID: <6cf327a7-bac0-7297-1b4a-6ce3860fb7fd@sandeen.net>
Date:   Sat, 19 Sep 2020 11:58:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAFTiD3myam_0wHvBRuuYt9xs0Pj0H-QBz=5sptn2=5zgoPnZEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 9/19/20 10:53 AM, Agustín Casasampere Fernandez wrote:
> 
>> What kernel version
> 
> The computer is running Arch Linux, using the zen kernel:
> `uname -a` : Linux ArchPC 5.8.8-zen1-1-zen #1 ZEN SMP PREEMPT Wed, 09 Sep 2020 19:01:48 +0000 x86_64 GNU/Linux
> 
>> What xfsprogs version
> 
> Using the latest from arch linux core/xfsprogs with version 5.8.0-1
> 
>> What were the prior kernel messages
> 
> `sudo dmesg` new output after running xfs_repair:
> ```
> [189493.940996] audit: type=1106 audit(1600527058.983:1136): pid=101786 uid=0 auid=1000 ses=2 msg='op=PAM:session_close grantors=pam_limits,pam_unix,pam_permit acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
> [189493.941178] audit: type=1104 audit(1600527058.983:1137): pid=101786 uid=0 auid=1000 ses=2 msg='op=PAM:setcred grantors=pam_faillock,pam_permit,pam_env,pam_faillock acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
> [189501.583038] audit: type=1101 audit(1600527066.626:1138): pid=101795 uid=1000 auid=1000 ses=2 msg='op=PAM:accounting grantors=pam_permit,pam_time acct="nitsuga" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/1 res=success'
> [189501.583166] audit: type=1110 audit(1600527066.626:1139): pid=101795 uid=0 auid=1000 ses=2 msg='op=PAM:setcred grantors=pam_faillock,pam_permit,pam_env,pam_faillock acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/1 res=success'
> [189501.584727] audit: type=1105 audit(1600527066.628:1140): pid=101795 uid=0 auid=1000 ses=2 msg='op=PAM:session_open grantors=pam_limits,pam_unix,pam_permit acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/1 res=success'
> [189501.727237] audit: type=1106 audit(1600527066.770:1141): pid=101795 uid=0 auid=1000 ses=2 msg='op=PAM:session_close grantors=pam_limits,pam_unix,pam_permit acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/1 res=success'
> [189501.727288] audit: type=1104 audit(1600527066.770:1142): pid=101795 uid=0 auid=1000 ses=2 msg='op=PAM:setcred grantors=pam_faillock,pam_permit,pam_env,pam_faillock acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/1 res=success'
> [189503.255383] audit: type=1101 audit(1600527068.298:1143): pid=101955 uid=1000 auid=1000 ses=2 msg='op=PAM:accounting grantors=pam_permit,pam_time acct="nitsuga" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
> [189503.255567] audit: type=1110 audit(1600527068.299:1144): pid=101955 uid=0 auid=1000 ses=2 msg='op=PAM:setcred grantors=pam_faillock,pam_permit,pam_env,pam_faillock acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
> [189503.257034] audit: type=1105 audit(1600527068.300:1145): pid=101955 uid=0 auid=1000 ses=2 msg='op=PAM:session_open grantors=pam_limits,pam_unix,pam_permit acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/4 res=success'
> ```
> I have also attached the dmesg_logs part from the moment the drive became unreadable until just after the command `sudo badblocks -v /dev/sdc > badsectors.txt` finished running.
> before badblocks was ran, `sudo xfs_repair /dev/mapper/storage` was ran too, and followed with `sudo xfs_repair -L /dev/mapper/storage`, as it failed without -L saying that -L was "required".


Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): Corruption warning: Metadata has LSN (-1868060818:-756175860) ahead of current LSN (925218271:1124568). Please unmount and run xfs_repair (>= v4.3) to resolve.
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): Metadata CRC error detected at xfs_allocbt_read_verify+0x15/0xd0 [xfs], xfs_cntbt block 0x1b8d1230 
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): Unmount and run xfs_repair
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): First 128 bytes of corrupted metadata buffer:
Sep 16 21:02:33 ArchPC kernel: 00000000: 1c 96 2b 47 25 5e 7a 80 ed c2 7c 85 78 0e b2 35  ..+G%^z...|.x..5
Sep 16 21:02:33 ArchPC kernel: 00000010: ca 7a 5e 3b 69 ca 8b 79 90 a7 a7 6e d2 ed ac 0c  .z^;i..y...n....
Sep 16 21:02:33 ArchPC kernel: 00000020: 71 c3 35 e5 95 ff 5c 68 75 19 75 9e 75 7d bb d5  q.5...\hu.u.u}..
Sep 16 21:02:33 ArchPC kernel: 00000030: b1 b6 0a a4 e7 79 60 6c 51 b4 98 59 8a 09 19 72  .....y`lQ..Y...r
Sep 16 21:02:33 ArchPC kernel: 00000040: cf d6 c5 9c cc 6c 8d a9 b7 6a 88 0f 8d c2 ca b9  .....l...j......
Sep 16 21:02:33 ArchPC kernel: 00000050: 8f 2d 3f 5f 1c a0 8c 5e 3f a7 57 ea dd d8 83 6f  .-?_...^?.W....o
Sep 16 21:02:33 ArchPC kernel: 00000060: 60 51 ca 74 72 5c 9b 61 f6 f2 e3 1c 2e 77 79 e6  `Q.tr\.a.....wy.
Sep 16 21:02:33 ArchPC kernel: 00000070: e4 52 3a 90 cd 10 01 cd 48 b1 35 3f a9 33 8b 54  .R:.....H.5?.3.T
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): metadata I/O error in "xfs_btree_read_buf_block.constprop.0+0xbc/0x100 [xfs]" at daddr 0x1b8d1230 len 8 error 74
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): xfs_do_force_shutdown(0x1) called from line 312 of file fs/xfs/xfs_trans_buf.c. Return address = 00000000ac9ecd5c
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): I/O Error Detected. Shutting down filesystem
Sep 16 21:02:33 ArchPC kernel: XFS (dm-1): Please unmount the filesystem and rectify the problem(s)

That looks like a real mess; it's pure garbage data.  Maybe encrypted data?

From the dmesg, you have errors on sdc.  What is the physical volume behind dm-1?  Is this sdc, or is this a cdrom?

Sep 16 21:47:44 ArchPC kernel: ata3.00: exception Emask 0x0 SAct 0x20 SErr 0x0 action 0x0
Sep 16 21:47:44 ArchPC kernel: ata3.00: irq_stat 0x40000008
Sep 16 21:47:44 ArchPC kernel: ata3.00: failed command: READ FPDMA QUEUED
Sep 16 21:47:44 ArchPC kernel: ata3.00: cmd 60/80:28:80:40:9b/00:00:1b:00:00/40 tag 5 ncq dma 65536 in
                                        res 43/40:80:b0:40:9b/00:00:1b:00:00/00 Emask 0x409 (media error) <F>
Sep 16 21:47:44 ArchPC kernel: ata3.00: status: { DRDY SENSE ERR }
Sep 16 21:47:44 ArchPC kernel: ata3.00: error: { UNC }
Sep 16 21:47:44 ArchPC kernel: audit: type=1130 audit(1600285664.564:3248): pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=spdynu comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
Sep 16 21:47:44 ArchPC kernel: ata3.00: configured for UDMA/133
Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE cmd_age=0s
Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 Sense Key : Medium Error [current] 
Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 Add. Sense: Unrecovered read error - auto reallocate failed
Sep 16 21:47:44 ArchPC kernel: sd 2:0:0:0: [sdc] tag#5 CDB: Read(16) 88 00 00 00 00 00 1b 9b 40 80 00 00 00 80 00 00
Sep 16 21:47:44 ArchPC kernel: blk_update_request: I/O error, dev sdc, sector 463159472 op 0x0:(READ) flags 0x0 phys_seg 10 prio class 0
Sep 16 21:47:44 ArchPC kernel: ata3: EH complete


