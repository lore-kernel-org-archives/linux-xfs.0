Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15F4C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:27:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5920120863
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 20:27:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="tAatEw3X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfKZU1T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:27:19 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:36616 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfKZU1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 15:27:19 -0500
Received: by mail-pf1-f173.google.com with SMTP id b19so9744443pfd.3
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 12:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=0qDzX4R06LOUaeRh0c0S4ZmX0B7ssAFdrmyizIzqlFE=;
        b=tAatEw3XVlOHRN/hOuvJwfvly/nv+k06O1ogAavDh7SK5GyhKbNKVK2jA184Tg7rk9
         WbtRq5aX2fLoenUFl0gbMyL+7bDFw+2SSfFPT8TYyyKxMlIWpiAHrG3kMctY5StvuMyV
         6nzMPR39iAR4Z6+Ed/3XsiRi4SwXJYSD6vQ2J8lGpghI1El2YZRpovsoo2WaNtNvU7hF
         LXW3ezFnFoFEIYdQiZQ+okT/xB0GWbI26J28nHUISKCgZvXfFU4cUm2Ya1ouewiVClyU
         QEnpVfhjBfD6cImGYwpQLC17b1UCBHjDNjw7UPGKVlOw8lBlDq8DLvW/dgPhilI3eFn6
         w0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=0qDzX4R06LOUaeRh0c0S4ZmX0B7ssAFdrmyizIzqlFE=;
        b=NVKKZr3//+sSWaT2D/62hABnmiDZ1ZpJbPLi5KNfV27VmLGe91Otb4wZADxmKpy42N
         SMgPgfCd7TTgzRz1Z4dAFA6IHdOSU2GDzFzOSBoQR65+xOgxMc+xHykaPCZv3jEi61yE
         b12Za9IAySxhUVqTgtf9eLvzAEsWnlbFc6DHAffclW2XqmPV7kYYoiRQEF44ev/VJLGp
         SKN/yK1TTmrZJm+0dEUNsfcPBS4OE3exA75GDelcFmsYGiVY82GljtsVjubErbYAGXyL
         rQ1wiGryKPmTpkezTu4NlHHWOylL4wOH0EAUSabFRpClG+De136PRv8QQmeFuSShvrBy
         7K1A==
X-Gm-Message-State: APjAAAUZ1pzxYukniVk1Ee0HHTe8E1dRz94bGaXwMpk3uEGVcXIezQiP
        hMW0tNi1jOMGBZRygkHqV3vcnniWmp9kHw==
X-Google-Smtp-Source: APXvYqxHJZE4XJy32++th8dHxpnAWW+2OzDYAJbrd8n9f8I4bGHwtCwaja86gMKP+Gz3sTGPu5k7iA==
X-Received: by 2002:a63:c849:: with SMTP id l9mr444552pgi.330.1574800036010;
        Tue, 26 Nov 2019 12:27:16 -0800 (PST)
Received: from vader ([2620:10d:c090:180::30de])
        by smtp.gmail.com with ESMTPSA id t1sm13860853pfq.156.2019.11.26.12.27.14
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:27:15 -0800 (PST)
Date:   Tue, 26 Nov 2019 12:27:14 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Subject: Transaction log reservation overrun when fallocating realtime file
Message-ID: <20191126202714.GA667580@vader>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

The following reproducer results in a transaction log overrun warning
for me:

  mkfs.xfs -f -r rtdev=/dev/vdc -d rtinherit=1 -m reflink=0 /dev/vdb
  mount -o rtdev=/dev/vdc /dev/vdb /mnt
  fallocate -l 4G /mnt/foo

I've attached the full dmesg output. My guess at the problem is that the
tr_write reservation used by xfs_alloc_file_space is not taking the realtime
bitmap and realtime summary inodes into account (inode numbers 129 and 130 on
this filesystem, which I do see in some of the log items). However, I'm not
familiar enough with the XFS transaction guts to confidently fix this. Can
someone please help me out?

Thanks!

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[   82.661688] ------------[ cut here ]------------
[   82.661787] WARNING: CPU: 11 PID: 473 at fs/xfs/xfs_log_cil.c:450 xfs_log_commit_cil.cold+0x20/0x90 [xfs]
[   82.661788] Modules linked in: xfs libcrc32c joydev mousedev psmouse input_leds intel_agp serio_raw evdev intel_gtt agpgart i6300esb atkbd i2c_piix4 mac_hid libps2 pcspkr qemu_fw_cfg ip_tables x_tables ext4 crc32c_generic crc16 mbcache jbd2 virtio_net net_failover virtio_rng rng_core failover virtio_blk ata_generic pata_acpi ata_piix libata virtio_pci i8042 scsi_mod floppy virtio_ring virtio serio
[   82.661806] CPU: 11 PID: 473 Comm: fallocate Not tainted 5.3.13-arch1-1 #1
[   82.661807] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.el7.centos 04/01/2014
[   82.661833] RIP: 0010:xfs_log_commit_cil.cold+0x20/0x90 [xfs]
[   82.661834] Code: ca 0f c8 0f 0b e9 ce 91 fc ff 48 c7 c7 d8 de 80 c0 44 89 5c 24 3c 44 89 44 24 38 44 89 54 24 30 4c 89 4c 24 28 e8 60 ca 0f c8 <0f> 0b 49 8b 7d 00 48 c7 c6 00 df 80 c0 e8 eb fa ff ff 44 8b 5c 24
[   82.661835] RSP: 0018:ffffa2a740747cc0 EFLAGS: 00010246
[   82.661836] RAX: 0000000000000024 RBX: ffffa082285189c0 RCX: 0000000000000000
[   82.661837] RDX: 0000000000000000 RSI: ffffa0823fcd7708 RDI: 00000000ffffffff
[   82.661838] RBP: ffffa08228518910 R08: 000000000000021f R09: 0000000000000004
[   82.661838] R10: 0000000000000000 R11: 0000000000000001 R12: ffffa08231bc8600
[   82.661839] R13: ffffa08231bc6000 R14: ffffa0823cadcb40 R15: 0000000000000430
[   82.661844] FS:  00007feac9cc55c0(0000) GS:ffffa0823fcc0000(0000) knlGS:0000000000000000
[   82.661845] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   82.661845] CR2: 00007feac9c907e0 CR3: 00000002284fa000 CR4: 00000000000006e0
[   82.661875] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.661876] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   82.661877] Call Trace:
[   82.661907]  __xfs_trans_commit+0xa1/0x360 [xfs]
[   82.661930]  xfs_alloc_file_space+0x1c6/0x390 [xfs]
[   82.661953]  xfs_file_fallocate+0x1f5/0x3a0 [xfs]
[   82.661962]  vfs_fallocate+0x14a/0x290
[   82.661976]  ksys_fallocate+0x3a/0x70
[   82.661977]  __x64_sys_fallocate+0x1a/0x20
[   82.661982]  do_syscall_64+0x4e/0x110
[   82.661988]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   82.661990] RIP: 0033:0x7feac9bf22da
[   82.661992] Code: ff ff ff eb c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 1d 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 5e c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
[   82.661992] RSP: 002b:00007ffd1a423828 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
[   82.661993] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007feac9bf22da
[   82.661994] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
[   82.661995] RBP: 000055cb6e1aa5e0 R08: 0000000000000000 R09: 0000000000000000
[   82.661995] R10: 0000000100000000 R11: 0000000000000246 R12: 00007ffd1a423a58
[   82.661996] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
[   82.661998] ---[ end trace 019d1402342f5767 ]---
[   82.662000] XFS (vdb): Transaction log reservation overrun:
[   82.662002] XFS (vdb):   log items: 133384 bytes (iov hdrs: 864 bytes)
[   82.662002] XFS (vdb):   split region headers: 2620 bytes
[   82.662003] XFS (vdb):   ctx ticket: 0 bytes
[   82.662004] XFS (vdb): transaction summary:
[   82.662004] XFS (vdb):   log res   = 109048
[   82.662005] XFS (vdb):   log count = 2
[   82.662005] XFS (vdb):   flags     = 0x7
[   82.662006] XFS (vdb): ticket reservation summary:
[   82.662007] XFS (vdb):   unit res    = 112720 bytes
[   82.662007] XFS (vdb):   current res = -23284 bytes
[   82.662008] XFS (vdb):   total reg   = 0 bytes (o/flow = 0 bytes)
[   82.662008] XFS (vdb):   ophdrs      = 0 (ophdr space = 0 bytes)
[   82.662009] XFS (vdb):   ophdr + reg = 0 bytes
[   82.662009] XFS (vdb):   num regions = 0
[   82.662010] XFS (vdb): log item: 
[   82.662010] XFS (vdb):   type	= 0x123b
[   82.662011] XFS (vdb):   flags	= 0x8
[   82.662011] XFS (vdb):   niovecs	= 3
[   82.662012] XFS (vdb):   size	= 696
[   82.662012] XFS (vdb):   bytes	= 248
[   82.662013] XFS (vdb):   buf len	= 248
[   82.662013] XFS (vdb):   iovec[0]
[   82.662014] XFS (vdb):     type	= 0x5
[   82.662014] XFS (vdb):     len	= 56
[   82.662015] XFS (vdb):     first 32 bytes of iovec[0]:
[   82.662017] 00000000: 3b 12 03 00 05 00 00 00 00 00 10 00 00 00 00 00  ;...............
[   82.669239] 00000010: 83 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.676262] XFS (vdb):   iovec[1]
[   82.676264] XFS (vdb):     type	= 0x6
[   82.676264] XFS (vdb):     len	= 176
[   82.676265] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.676266] 00000000: 4e 49 a4 81 03 02 00 00 00 00 00 00 00 00 00 00  NI..............
[   82.683226] 00000010: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.690285] XFS (vdb):   iovec[2]
[   82.690286] XFS (vdb):     type	= 0x7
[   82.690287] XFS (vdb):     len	= 16
[   82.690288] XFS (vdb):     first 16 bytes of iovec[2]:
[   82.690289] 00000000: 80 00 00 00 00 00 00 00 00 00 00 00 00 10 00 00  ................
[   82.697198] XFS (vdb): log item: 
[   82.697199] XFS (vdb):   type	= 0x123b
[   82.697199] XFS (vdb):   flags	= 0x8
[   82.697200] XFS (vdb):   niovecs	= 2
[   82.697201] XFS (vdb):   size	= 336
[   82.697201] XFS (vdb):   bytes	= 232
[   82.697202] XFS (vdb):   buf len	= 232
[   82.697202] XFS (vdb):   iovec[0]
[   82.697203] XFS (vdb):     type	= 0x5
[   82.697203] XFS (vdb):     len	= 56
[   82.697204] XFS (vdb):     first 32 bytes of iovec[0]:
[   82.697205] 00000000: 3b 12 02 00 01 00 00 00 00 00 00 00 00 00 00 00  ;...............
[   82.704078] 00000010: 81 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.711072] XFS (vdb):   iovec[1]
[   82.711073] XFS (vdb):     type	= 0x6
[   82.711074] XFS (vdb):     len	= 176
[   82.711075] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.711076] 00000000: 4e 49 00 80 03 02 00 00 00 00 00 00 00 00 00 00  NI..............
[   82.717987] 00000010: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.724973] XFS (vdb): log item: 
[   82.724975] XFS (vdb):   type	= 0x123b
[   82.724976] XFS (vdb):   flags	= 0x0
[   82.724976] XFS (vdb): log item: 
[   82.724977] XFS (vdb):   type	= 0x123c
[   82.724977] XFS (vdb):   flags	= 0x8
[   82.724978] XFS (vdb):   niovecs	= 3
[   82.724979] XFS (vdb):   size	= 408
[   82.724979] XFS (vdb):   bytes	= 280
[   82.724980] XFS (vdb):   buf len	= 280
[   82.724980] XFS (vdb):   iovec[0]
[   82.724981] XFS (vdb):     type	= 0x1
[   82.724982] XFS (vdb):     len	= 24
[   82.724982] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.724983] 00000000: 3c 12 03 00 00 a0 08 00 70 00 00 00 00 00 00 00  <.......p.......
[   82.731906] 00000010: 01 00 00 00 00 00 02 01                          ........
[   82.738064] XFS (vdb):   iovec[1]
[   82.738065] XFS (vdb):     type	= 0x2
[   82.738066] XFS (vdb):     len	= 128
[   82.738066] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.738067] 00000000: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.745010] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.751943] XFS (vdb):   iovec[2]
[   82.751945] XFS (vdb):     type	= 0x2
[   82.751945] XFS (vdb):     len	= 128
[   82.751946] XFS (vdb):     first 32 bytes of iovec[2]:
[   82.751947] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.758845] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.765881] XFS (vdb): log item: 
[   82.765882] XFS (vdb):   type	= 0x123c
[   82.765883] XFS (vdb):   flags	= 0x8
[   82.765884] XFS (vdb):   niovecs	= 2
[   82.765885] XFS (vdb):   size	= 4224
[   82.765885] XFS (vdb):   bytes	= 4120
[   82.765886] XFS (vdb):   buf len	= 4120
[   82.765887] XFS (vdb):   iovec[0]
[   82.765887] XFS (vdb):     type	= 0x1
[   82.765888] XFS (vdb):     len	= 24
[   82.765888] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.765889] 00000000: 3c 12 02 00 00 98 08 00 c0 00 00 00 00 00 00 00  <...............
[   82.772786] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.779369] XFS (vdb):   iovec[1]
[   82.779370] XFS (vdb):     type	= 0x2
[   82.779371] XFS (vdb):     len	= 4096
[   82.779371] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.779372] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.786529] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.793420] XFS (vdb): log item: 
[   82.793421] XFS (vdb):   type	= 0x123c
[   82.793422] XFS (vdb):   flags	= 0x8
[   82.793422] XFS (vdb):   niovecs	= 2
[   82.793423] XFS (vdb):   size	= 4224
[   82.793424] XFS (vdb):   bytes	= 4120
[   82.793424] XFS (vdb):   buf len	= 4120
[   82.793425] XFS (vdb):   iovec[0]
[   82.793426] XFS (vdb):     type	= 0x1
[   82.793426] XFS (vdb):     len	= 24
[   82.793427] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.793428] 00000000: 3c 12 02 00 00 98 08 00 c8 00 00 00 00 00 00 00  <...............
[   82.801796] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.809042] XFS (vdb):   iovec[1]
[   82.809043] XFS (vdb):     type	= 0x2
[   82.809043] XFS (vdb):     len	= 4096
[   82.809044] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.809045] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.817197] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.824982] XFS (vdb): log item: 
[   82.824984] XFS (vdb):   type	= 0x123c
[   82.824985] XFS (vdb):   flags	= 0x8
[   82.824986] XFS (vdb):   niovecs	= 2
[   82.824987] XFS (vdb):   size	= 4224
[   82.824988] XFS (vdb):   bytes	= 4120
[   82.824989] XFS (vdb):   buf len	= 4120
[   82.824990] XFS (vdb):   iovec[0]
[   82.824991] XFS (vdb):     type	= 0x1
[   82.824992] XFS (vdb):     len	= 24
[   82.824993] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.824994] 00000000: 3c 12 02 00 00 98 08 00 d0 00 00 00 00 00 00 00  <...............
[   82.833428] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.841352] XFS (vdb):   iovec[1]
[   82.841353] XFS (vdb):     type	= 0x2
[   82.841354] XFS (vdb):     len	= 4096
[   82.841355] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.841357] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.849908] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.857016] XFS (vdb): log item: 
[   82.857017] XFS (vdb):   type	= 0x123c
[   82.857018] XFS (vdb):   flags	= 0x8
[   82.857018] XFS (vdb):   niovecs	= 2
[   82.857019] XFS (vdb):   size	= 4224
[   82.857020] XFS (vdb):   bytes	= 4120
[   82.857020] XFS (vdb):   buf len	= 4120
[   82.857021] XFS (vdb):   iovec[0]
[   82.857021] XFS (vdb):     type	= 0x1
[   82.857022] XFS (vdb):     len	= 24
[   82.857023] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.857024] 00000000: 3c 12 02 00 00 98 08 00 d8 00 00 00 00 00 00 00  <...............
[   82.865490] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.872273] XFS (vdb):   iovec[1]
[   82.872274] XFS (vdb):     type	= 0x2
[   82.872274] XFS (vdb):     len	= 4096
[   82.872275] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.872276] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.879792] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.886850] XFS (vdb): log item: 
[   82.886851] XFS (vdb):   type	= 0x123c
[   82.886851] XFS (vdb):   flags	= 0x8
[   82.886852] XFS (vdb):   niovecs	= 2
[   82.886853] XFS (vdb):   size	= 4224
[   82.886853] XFS (vdb):   bytes	= 4120
[   82.886853] XFS (vdb):   buf len	= 4120
[   82.886854] XFS (vdb):   iovec[0]
[   82.886855] XFS (vdb):     type	= 0x1
[   82.886855] XFS (vdb):     len	= 24
[   82.886879] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.886881] 00000000: 3c 12 02 00 00 98 08 00 e0 00 00 00 00 00 00 00  <...............
[   82.893660] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.899881] XFS (vdb):   iovec[1]
[   82.899882] XFS (vdb):     type	= 0x2
[   82.899882] XFS (vdb):     len	= 4096
[   82.899883] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.899884] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.907257] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.914785] XFS (vdb): log item: 
[   82.914786] XFS (vdb):   type	= 0x123c
[   82.914787] XFS (vdb):   flags	= 0x8
[   82.914787] XFS (vdb):   niovecs	= 2
[   82.914788] XFS (vdb):   size	= 4224
[   82.914789] XFS (vdb):   bytes	= 4120
[   82.914789] XFS (vdb):   buf len	= 4120
[   82.914790] XFS (vdb):   iovec[0]
[   82.914790] XFS (vdb):     type	= 0x1
[   82.914791] XFS (vdb):     len	= 24
[   82.914792] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.914793] 00000000: 3c 12 02 00 00 98 08 00 e8 00 00 00 00 00 00 00  <...............
[   82.921982] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.928199] XFS (vdb):   iovec[1]
[   82.928200] XFS (vdb):     type	= 0x2
[   82.928201] XFS (vdb):     len	= 4096
[   82.928202] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.928203] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.935001] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.941751] XFS (vdb): log item: 
[   82.941752] XFS (vdb):   type	= 0x123c
[   82.941753] XFS (vdb):   flags	= 0x8
[   82.941754] XFS (vdb):   niovecs	= 2
[   82.941754] XFS (vdb):   size	= 4224
[   82.941755] XFS (vdb):   bytes	= 4120
[   82.941755] XFS (vdb):   buf len	= 4120
[   82.941756] XFS (vdb):   iovec[0]
[   82.941757] XFS (vdb):     type	= 0x1
[   82.941757] XFS (vdb):     len	= 24
[   82.941758] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.941759] 00000000: 3c 12 02 00 00 98 08 00 f0 00 00 00 00 00 00 00  <...............
[   82.948544] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.954697] XFS (vdb):   iovec[1]
[   82.954698] XFS (vdb):     type	= 0x2
[   82.954698] XFS (vdb):     len	= 4096
[   82.954699] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.954700] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.961543] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.969056] XFS (vdb): log item: 
[   82.969057] XFS (vdb):   type	= 0x123c
[   82.969057] XFS (vdb):   flags	= 0x8
[   82.969058] XFS (vdb):   niovecs	= 2
[   82.969059] XFS (vdb):   size	= 4224
[   82.969059] XFS (vdb):   bytes	= 4120
[   82.969060] XFS (vdb):   buf len	= 4120
[   82.969060] XFS (vdb):   iovec[0]
[   82.969061] XFS (vdb):     type	= 0x1
[   82.969061] XFS (vdb):     len	= 24
[   82.969062] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.969063] 00000000: 3c 12 02 00 00 98 08 00 f8 00 00 00 00 00 00 00  <...............
[   82.975835] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   82.982103] XFS (vdb):   iovec[1]
[   82.982104] XFS (vdb):     type	= 0x2
[   82.982105] XFS (vdb):     len	= 4096
[   82.982105] XFS (vdb):     first 32 bytes of iovec[1]:
[   82.982106] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.988881] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   82.995712] XFS (vdb): log item: 
[   82.995713] XFS (vdb):   type	= 0x123c
[   82.995714] XFS (vdb):   flags	= 0x8
[   82.995715] XFS (vdb):   niovecs	= 2
[   82.995715] XFS (vdb):   size	= 4224
[   82.995716] XFS (vdb):   bytes	= 4120
[   82.995716] XFS (vdb):   buf len	= 4120
[   82.995717] XFS (vdb):   iovec[0]
[   82.995718] XFS (vdb):     type	= 0x1
[   82.995718] XFS (vdb):     len	= 24
[   82.995719] XFS (vdb):     first 24 bytes of iovec[0]:
[   82.995720] 00000000: 3c 12 02 00 00 98 08 00 00 01 00 00 00 00 00 00  <...............
[   83.002469] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.008658] XFS (vdb):   iovec[1]
[   83.008659] XFS (vdb):     type	= 0x2
[   83.008660] XFS (vdb):     len	= 4096
[   83.008660] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.008661] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.015845] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.022456] XFS (vdb): log item: 
[   83.022458] XFS (vdb):   type	= 0x123c
[   83.022458] XFS (vdb):   flags	= 0x8
[   83.022459] XFS (vdb):   niovecs	= 2
[   83.022460] XFS (vdb):   size	= 4224
[   83.022460] XFS (vdb):   bytes	= 4120
[   83.022461] XFS (vdb):   buf len	= 4120
[   83.022461] XFS (vdb):   iovec[0]
[   83.022462] XFS (vdb):     type	= 0x1
[   83.022462] XFS (vdb):     len	= 24
[   83.022463] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.022464] 00000000: 3c 12 02 00 00 98 08 00 08 01 00 00 00 00 00 00  <...............
[   83.029069] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.035121] XFS (vdb):   iovec[1]
[   83.035121] XFS (vdb):     type	= 0x2
[   83.035122] XFS (vdb):     len	= 4096
[   83.035123] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.035124] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.041816] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.048382] XFS (vdb): log item: 
[   83.048383] XFS (vdb):   type	= 0x123c
[   83.048384] XFS (vdb):   flags	= 0x8
[   83.048384] XFS (vdb):   niovecs	= 2
[   83.048385] XFS (vdb):   size	= 4224
[   83.048385] XFS (vdb):   bytes	= 4120
[   83.048386] XFS (vdb):   buf len	= 4120
[   83.048386] XFS (vdb):   iovec[0]
[   83.048387] XFS (vdb):     type	= 0x1
[   83.048387] XFS (vdb):     len	= 24
[   83.048388] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.048389] 00000000: 3c 12 02 00 00 98 08 00 10 01 00 00 00 00 00 00  <...............
[   83.055004] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.061804] XFS (vdb):   iovec[1]
[   83.061805] XFS (vdb):     type	= 0x2
[   83.061805] XFS (vdb):     len	= 4096
[   83.061806] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.061807] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.068439] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.074969] XFS (vdb): log item: 
[   83.074970] XFS (vdb):   type	= 0x123c
[   83.074971] XFS (vdb):   flags	= 0x8
[   83.074971] XFS (vdb):   niovecs	= 2
[   83.074972] XFS (vdb):   size	= 4224
[   83.074972] XFS (vdb):   bytes	= 4120
[   83.074973] XFS (vdb):   buf len	= 4120
[   83.074973] XFS (vdb):   iovec[0]
[   83.074974] XFS (vdb):     type	= 0x1
[   83.074974] XFS (vdb):     len	= 24
[   83.074975] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.074976] 00000000: 3c 12 02 00 00 98 08 00 18 01 00 00 00 00 00 00  <...............
[   83.081507] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.087516] XFS (vdb):   iovec[1]
[   83.087516] XFS (vdb):     type	= 0x2
[   83.087517] XFS (vdb):     len	= 4096
[   83.087518] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.087519] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.094142] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.100591] XFS (vdb): log item: 
[   83.100592] XFS (vdb):   type	= 0x123c
[   83.100593] XFS (vdb):   flags	= 0x8
[   83.100593] XFS (vdb):   niovecs	= 2
[   83.100594] XFS (vdb):   size	= 4224
[   83.100595] XFS (vdb):   bytes	= 4120
[   83.100595] XFS (vdb):   buf len	= 4120
[   83.100596] XFS (vdb):   iovec[0]
[   83.100596] XFS (vdb):     type	= 0x1
[   83.100597] XFS (vdb):     len	= 24
[   83.100597] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.100598] 00000000: 3c 12 02 00 00 98 08 00 20 01 00 00 00 00 00 00  <....... .......
[   83.107841] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.113968] XFS (vdb):   iovec[1]
[   83.113969] XFS (vdb):     type	= 0x2
[   83.113970] XFS (vdb):     len	= 4096
[   83.113970] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.113971] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.120606] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.127198] XFS (vdb): log item: 
[   83.127199] XFS (vdb):   type	= 0x123c
[   83.127200] XFS (vdb):   flags	= 0x8
[   83.127200] XFS (vdb):   niovecs	= 2
[   83.127201] XFS (vdb):   size	= 4224
[   83.127202] XFS (vdb):   bytes	= 4120
[   83.127202] XFS (vdb):   buf len	= 4120
[   83.127203] XFS (vdb):   iovec[0]
[   83.127203] XFS (vdb):     type	= 0x1
[   83.127204] XFS (vdb):     len	= 24
[   83.127205] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.127206] 00000000: 3c 12 02 00 00 98 08 00 28 01 00 00 00 00 00 00  <.......(.......
[   83.133803] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.139757] XFS (vdb):   iovec[1]
[   83.139758] XFS (vdb):     type	= 0x2
[   83.139759] XFS (vdb):     len	= 4096
[   83.139759] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.139760] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.146366] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.153396] XFS (vdb): log item: 
[   83.153398] XFS (vdb):   type	= 0x123c
[   83.153398] XFS (vdb):   flags	= 0x8
[   83.153399] XFS (vdb):   niovecs	= 2
[   83.153399] XFS (vdb):   size	= 4224
[   83.153400] XFS (vdb):   bytes	= 4120
[   83.153400] XFS (vdb):   buf len	= 4120
[   83.153401] XFS (vdb):   iovec[0]
[   83.153402] XFS (vdb):     type	= 0x1
[   83.153402] XFS (vdb):     len	= 24
[   83.153403] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.153404] 00000000: 3c 12 02 00 00 98 08 00 30 01 00 00 00 00 00 00  <.......0.......
[   83.159950] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.165934] XFS (vdb):   iovec[1]
[   83.165935] XFS (vdb):     type	= 0x2
[   83.165936] XFS (vdb):     len	= 4096
[   83.165936] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.165937] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.172537] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.181475] XFS (vdb): log item: 
[   83.181476] XFS (vdb):   type	= 0x123c
[   83.181477] XFS (vdb):   flags	= 0x8
[   83.181478] XFS (vdb):   niovecs	= 2
[   83.181479] XFS (vdb):   size	= 4224
[   83.181480] XFS (vdb):   bytes	= 4120
[   83.181481] XFS (vdb):   buf len	= 4120
[   83.181482] XFS (vdb):   iovec[0]
[   83.181482] XFS (vdb):     type	= 0x1
[   83.181483] XFS (vdb):     len	= 24
[   83.181484] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.181486] 00000000: 3c 12 02 00 00 98 08 00 38 01 00 00 00 00 00 00  <.......8.......
[   83.190113] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.196584] XFS (vdb):   iovec[1]
[   83.196585] XFS (vdb):     type	= 0x2
[   83.196586] XFS (vdb):     len	= 4096
[   83.196587] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.196588] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.203921] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.210494] XFS (vdb): log item: 
[   83.210495] XFS (vdb):   type	= 0x123c
[   83.210496] XFS (vdb):   flags	= 0x8
[   83.210496] XFS (vdb):   niovecs	= 2
[   83.210497] XFS (vdb):   size	= 4224
[   83.210498] XFS (vdb):   bytes	= 4120
[   83.210498] XFS (vdb):   buf len	= 4120
[   83.210499] XFS (vdb):   iovec[0]
[   83.210499] XFS (vdb):     type	= 0x1
[   83.210500] XFS (vdb):     len	= 24
[   83.210501] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.210502] 00000000: 3c 12 02 00 00 98 08 00 40 01 00 00 00 00 00 00  <.......@.......
[   83.217178] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.223219] XFS (vdb):   iovec[1]
[   83.223220] XFS (vdb):     type	= 0x2
[   83.223220] XFS (vdb):     len	= 4096
[   83.223221] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.223222] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.229744] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.236426] XFS (vdb): log item: 
[   83.236427] XFS (vdb):   type	= 0x123c
[   83.236427] XFS (vdb):   flags	= 0x8
[   83.236428] XFS (vdb):   niovecs	= 2
[   83.236428] XFS (vdb):   size	= 4224
[   83.236429] XFS (vdb):   bytes	= 4120
[   83.236430] XFS (vdb):   buf len	= 4120
[   83.236430] XFS (vdb):   iovec[0]
[   83.236431] XFS (vdb):     type	= 0x1
[   83.236431] XFS (vdb):     len	= 24
[   83.236432] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.236433] 00000000: 3c 12 02 00 00 98 08 00 48 01 00 00 00 00 00 00  <.......H.......
[   83.242938] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.248912] XFS (vdb):   iovec[1]
[   83.248912] XFS (vdb):     type	= 0x2
[   83.248913] XFS (vdb):     len	= 4096
[   83.248914] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.248915] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.256151] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.262936] XFS (vdb): log item: 
[   83.262938] XFS (vdb):   type	= 0x123c
[   83.262938] XFS (vdb):   flags	= 0x8
[   83.262939] XFS (vdb):   niovecs	= 2
[   83.262939] XFS (vdb):   size	= 4224
[   83.262940] XFS (vdb):   bytes	= 4120
[   83.262941] XFS (vdb):   buf len	= 4120
[   83.262941] XFS (vdb):   iovec[0]
[   83.262942] XFS (vdb):     type	= 0x1
[   83.262942] XFS (vdb):     len	= 24
[   83.262943] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.262944] 00000000: 3c 12 02 00 00 98 08 00 50 01 00 00 00 00 00 00  <.......P.......
[   83.269615] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.275729] XFS (vdb):   iovec[1]
[   83.275730] XFS (vdb):     type	= 0x2
[   83.275730] XFS (vdb):     len	= 4096
[   83.275731] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.275732] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.282358] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.288899] XFS (vdb): log item: 
[   83.288900] XFS (vdb):   type	= 0x123c
[   83.288900] XFS (vdb):   flags	= 0x8
[   83.288901] XFS (vdb):   niovecs	= 2
[   83.288901] XFS (vdb):   size	= 4224
[   83.288902] XFS (vdb):   bytes	= 4120
[   83.288902] XFS (vdb):   buf len	= 4120
[   83.288903] XFS (vdb):   iovec[0]
[   83.288903] XFS (vdb):     type	= 0x1
[   83.288904] XFS (vdb):     len	= 24
[   83.288905] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.288906] 00000000: 3c 12 02 00 00 98 08 00 58 01 00 00 00 00 00 00  <.......X.......
[   83.295485] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.301497] XFS (vdb):   iovec[1]
[   83.301498] XFS (vdb):     type	= 0x2
[   83.301498] XFS (vdb):     len	= 4096
[   83.301499] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.301500] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.308919] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.315543] XFS (vdb): log item: 
[   83.315544] XFS (vdb):   type	= 0x123c
[   83.315544] XFS (vdb):   flags	= 0x8
[   83.315545] XFS (vdb):   niovecs	= 2
[   83.315546] XFS (vdb):   size	= 4224
[   83.315546] XFS (vdb):   bytes	= 4120
[   83.315547] XFS (vdb):   buf len	= 4120
[   83.315547] XFS (vdb):   iovec[0]
[   83.315548] XFS (vdb):     type	= 0x1
[   83.315548] XFS (vdb):     len	= 24
[   83.315549] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.315550] 00000000: 3c 12 02 00 00 98 08 00 60 01 00 00 00 00 00 00  <.......`.......
[   83.322409] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.328502] XFS (vdb):   iovec[1]
[   83.328503] XFS (vdb):     type	= 0x2
[   83.328504] XFS (vdb):     len	= 4096
[   83.328504] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.328505] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.335141] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.341703] XFS (vdb): log item: 
[   83.341704] XFS (vdb):   type	= 0x123c
[   83.341704] XFS (vdb):   flags	= 0x8
[   83.341705] XFS (vdb):   niovecs	= 2
[   83.341706] XFS (vdb):   size	= 4224
[   83.341706] XFS (vdb):   bytes	= 4120
[   83.341707] XFS (vdb):   buf len	= 4120
[   83.341707] XFS (vdb):   iovec[0]
[   83.341708] XFS (vdb):     type	= 0x1
[   83.341708] XFS (vdb):     len	= 24
[   83.341709] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.341710] 00000000: 3c 12 02 00 00 98 08 00 68 01 00 00 00 00 00 00  <.......h.......
[   83.348424] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.355163] XFS (vdb):   iovec[1]
[   83.355164] XFS (vdb):     type	= 0x2
[   83.355165] XFS (vdb):     len	= 4096
[   83.355165] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.355166] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.361847] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.368416] XFS (vdb): log item: 
[   83.368418] XFS (vdb):   type	= 0x123c
[   83.368418] XFS (vdb):   flags	= 0x8
[   83.368419] XFS (vdb):   niovecs	= 2
[   83.368420] XFS (vdb):   size	= 4224
[   83.368420] XFS (vdb):   bytes	= 4120
[   83.368421] XFS (vdb):   buf len	= 4120
[   83.368421] XFS (vdb):   iovec[0]
[   83.368422] XFS (vdb):     type	= 0x1
[   83.368422] XFS (vdb):     len	= 24
[   83.368423] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.368424] 00000000: 3c 12 02 00 00 98 08 00 70 01 00 00 00 00 00 00  <.......p.......
[   83.374980] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.381264] XFS (vdb):   iovec[1]
[   83.381265] XFS (vdb):     type	= 0x2
[   83.381266] XFS (vdb):     len	= 4096
[   83.381266] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.381267] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.387906] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.394588] XFS (vdb): log item: 
[   83.394589] XFS (vdb):   type	= 0x123c
[   83.394589] XFS (vdb):   flags	= 0x8
[   83.394590] XFS (vdb):   niovecs	= 2
[   83.394590] XFS (vdb):   size	= 4224
[   83.394591] XFS (vdb):   bytes	= 4120
[   83.394591] XFS (vdb):   buf len	= 4120
[   83.394592] XFS (vdb):   iovec[0]
[   83.394592] XFS (vdb):     type	= 0x1
[   83.394593] XFS (vdb):     len	= 24
[   83.394594] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.394595] 00000000: 3c 12 02 00 00 98 08 00 78 01 00 00 00 00 00 00  <.......x.......
[   83.401891] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.407948] XFS (vdb):   iovec[1]
[   83.407949] XFS (vdb):     type	= 0x2
[   83.407950] XFS (vdb):     len	= 4096
[   83.407951] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.407951] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.414609] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.421180] XFS (vdb): log item: 
[   83.421181] XFS (vdb):   type	= 0x123c
[   83.421182] XFS (vdb):   flags	= 0x8
[   83.421182] XFS (vdb):   niovecs	= 2
[   83.421183] XFS (vdb):   size	= 4224
[   83.421184] XFS (vdb):   bytes	= 4120
[   83.421184] XFS (vdb):   buf len	= 4120
[   83.421185] XFS (vdb):   iovec[0]
[   83.421185] XFS (vdb):     type	= 0x1
[   83.421186] XFS (vdb):     len	= 24
[   83.421187] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.421188] 00000000: 3c 12 02 00 00 98 08 00 80 01 00 00 00 00 00 00  <...............
[   83.427839] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.433969] XFS (vdb):   iovec[1]
[   83.433969] XFS (vdb):     type	= 0x2
[   83.433970] XFS (vdb):     len	= 4096
[   83.433971] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.433972] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.440509] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.447538] XFS (vdb): log item: 
[   83.447539] XFS (vdb):   type	= 0x123c
[   83.447540] XFS (vdb):   flags	= 0x8
[   83.447540] XFS (vdb):   niovecs	= 2
[   83.447541] XFS (vdb):   size	= 4224
[   83.447541] XFS (vdb):   bytes	= 4120
[   83.447542] XFS (vdb):   buf len	= 4120
[   83.447542] XFS (vdb):   iovec[0]
[   83.447543] XFS (vdb):     type	= 0x1
[   83.447543] XFS (vdb):     len	= 24
[   83.447544] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.447545] 00000000: 3c 12 02 00 00 98 08 00 88 01 00 00 00 00 00 00  <...............
[   83.454288] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.460425] XFS (vdb):   iovec[1]
[   83.460426] XFS (vdb):     type	= 0x2
[   83.460427] XFS (vdb):     len	= 4096
[   83.460428] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.460430] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.467208] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.473782] XFS (vdb): log item: 
[   83.473783] XFS (vdb):   type	= 0x123c
[   83.473784] XFS (vdb):   flags	= 0x8
[   83.473785] XFS (vdb):   niovecs	= 2
[   83.473786] XFS (vdb):   size	= 4224
[   83.473786] XFS (vdb):   bytes	= 4120
[   83.473787] XFS (vdb):   buf len	= 4120
[   83.473788] XFS (vdb):   iovec[0]
[   83.473789] XFS (vdb):     type	= 0x1
[   83.473790] XFS (vdb):     len	= 24
[   83.473791] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.473792] 00000000: 3c 12 02 00 00 98 08 00 90 01 00 00 00 00 00 00  <...............
[   83.480389] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.486512] XFS (vdb):   iovec[1]
[   83.486514] XFS (vdb):     type	= 0x2
[   83.486515] XFS (vdb):     len	= 4096
[   83.486516] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.486517] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.493638] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.500207] XFS (vdb): log item: 
[   83.500208] XFS (vdb):   type	= 0x123c
[   83.500209] XFS (vdb):   flags	= 0x8
[   83.500210] XFS (vdb):   niovecs	= 2
[   83.500211] XFS (vdb):   size	= 4224
[   83.500212] XFS (vdb):   bytes	= 4120
[   83.500213] XFS (vdb):   buf len	= 4120
[   83.500214] XFS (vdb):   iovec[0]
[   83.500214] XFS (vdb):     type	= 0x1
[   83.500215] XFS (vdb):     len	= 24
[   83.500216] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.500218] 00000000: 3c 12 02 00 00 98 08 00 98 01 00 00 00 00 00 00  <...............
[   83.506777] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.512886] XFS (vdb):   iovec[1]
[   83.512887] XFS (vdb):     type	= 0x2
[   83.512888] XFS (vdb):     len	= 4096
[   83.512889] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.512890] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.519454] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.526155] XFS (vdb): log item: 
[   83.526157] XFS (vdb):   type	= 0x123c
[   83.526158] XFS (vdb):   flags	= 0x8
[   83.526159] XFS (vdb):   niovecs	= 2
[   83.526160] XFS (vdb):   size	= 4224
[   83.526160] XFS (vdb):   bytes	= 4120
[   83.526161] XFS (vdb):   buf len	= 4120
[   83.526162] XFS (vdb):   iovec[0]
[   83.526163] XFS (vdb):     type	= 0x1
[   83.526164] XFS (vdb):     len	= 24
[   83.526165] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.526166] 00000000: 3c 12 02 00 00 98 08 00 a0 01 00 00 00 00 00 00  <...............
[   83.532795] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.539574] XFS (vdb):   iovec[1]
[   83.539575] XFS (vdb):     type	= 0x2
[   83.539576] XFS (vdb):     len	= 4096
[   83.539577] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.539579] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.546268] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.553048] XFS (vdb): log item: 
[   83.553050] XFS (vdb):   type	= 0x123c
[   83.553051] XFS (vdb):   flags	= 0x8
[   83.553052] XFS (vdb):   niovecs	= 2
[   83.553053] XFS (vdb):   size	= 4224
[   83.553053] XFS (vdb):   bytes	= 4120
[   83.553054] XFS (vdb):   buf len	= 4120
[   83.553055] XFS (vdb):   iovec[0]
[   83.553056] XFS (vdb):     type	= 0x1
[   83.553057] XFS (vdb):     len	= 24
[   83.553058] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.553059] 00000000: 3c 12 02 00 00 98 08 00 a8 01 00 00 00 00 00 00  <...............
[   83.559902] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.566062] XFS (vdb):   iovec[1]
[   83.566063] XFS (vdb):     type	= 0x2
[   83.566064] XFS (vdb):     len	= 4096
[   83.566065] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.566067] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.572695] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.579308] XFS (vdb): log item: 
[   83.579310] XFS (vdb):   type	= 0x123c
[   83.579311] XFS (vdb):   flags	= 0x8
[   83.579311] XFS (vdb):   niovecs	= 2
[   83.579312] XFS (vdb):   size	= 4224
[   83.579313] XFS (vdb):   bytes	= 4120
[   83.579314] XFS (vdb):   buf len	= 4120
[   83.579315] XFS (vdb):   iovec[0]
[   83.579316] XFS (vdb):     type	= 0x1
[   83.579316] XFS (vdb):     len	= 24
[   83.579317] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.579319] 00000000: 3c 12 02 00 00 98 08 00 b0 01 00 00 00 00 00 00  <...............
[   83.586602] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.592682] XFS (vdb):   iovec[1]
[   83.592684] XFS (vdb):     type	= 0x2
[   83.592685] XFS (vdb):     len	= 4096
[   83.592686] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.592687] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.599170] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.605842] XFS (vdb): log item: 
[   83.605844] XFS (vdb):   type	= 0x123c
[   83.605845] XFS (vdb):   flags	= 0x8
[   83.605846] XFS (vdb):   niovecs	= 2
[   83.605847] XFS (vdb):   size	= 4224
[   83.605848] XFS (vdb):   bytes	= 4120
[   83.605848] XFS (vdb):   buf len	= 4120
[   83.605849] XFS (vdb):   iovec[0]
[   83.605850] XFS (vdb):     type	= 0x1
[   83.605851] XFS (vdb):     len	= 24
[   83.605852] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.605853] 00000000: 3c 12 02 00 00 98 08 00 b8 01 00 00 00 00 00 00  <...............
[   83.612352] 00000010: 01 00 00 00 ff ff ff ff                          ........
[   83.618364] XFS (vdb):   iovec[1]
[   83.618366] XFS (vdb):     type	= 0x2
[   83.618367] XFS (vdb):     len	= 4096
[   83.618367] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.618369] 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.624908] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[   83.631587] XFS (vdb): log item: 
[   83.631588] XFS (vdb):   type	= 0x123c
[   83.631589] XFS (vdb):   flags	= 0x8
[   83.631590] XFS (vdb):   niovecs	= 2
[   83.631591] XFS (vdb):   size	= 256
[   83.631592] XFS (vdb):   bytes	= 152
[   83.631593] XFS (vdb):   buf len	= 152
[   83.631594] XFS (vdb):   iovec[0]
[   83.631594] XFS (vdb):     type	= 0x1
[   83.631595] XFS (vdb):     len	= 24
[   83.631596] XFS (vdb):     first 24 bytes of iovec[0]:
[   83.631598] 00000000: 3c 12 02 00 00 90 01 00 00 00 00 00 00 00 00 00  <...............
[   83.638780] 00000010: 01 00 00 00 02 00 00 00                          ........
[   83.644896] XFS (vdb):   iovec[1]
[   83.644898] XFS (vdb):     type	= 0x2
[   83.644899] XFS (vdb):     len	= 128
[   83.644900] XFS (vdb):     first 32 bytes of iovec[1]:
[   83.644901] 00000000: 00 00 00 00 00 00 00 40 00 00 00 00 00 00 00 3d  .......@.......=
[   83.651821] 00000010: 00 00 00 00 00 7f ee de 00 00 00 00 00 70 00 00  .............p..
[   83.659045] XFS (vdb): xfs_do_force_shutdown(0x2) called from line 484 of file fs/xfs/xfs_log_cil.c. Return address = 0000000090960c02
[   83.659047] XFS (vdb): Log I/O Error Detected. Shutting down filesystem
[   83.664758] XFS (vdb): Please unmount the filesystem and rectify the problem(s)

--/9DWx/yDrRhgMJTb--
