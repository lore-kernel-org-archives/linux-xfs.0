Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 21:02:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G42ASA029772
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:02:10 -0700
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 839CB1275718
	for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:03:41 -0700 (PDT)
Received: from rv-out-0708.google.com (rv-out-0708.google.com [209.85.198.243]) by cuda.sgi.com with ESMTP id KEsgETrAk1fZN2qZ for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:03:41 -0700 (PDT)
Received: by rv-out-0708.google.com with SMTP id f25so2415293rvb.32
        for <xfs@oss.sgi.com>; Mon, 15 Sep 2008 21:03:41 -0700 (PDT)
Message-ID: <e03b90ae0809152103w5653bdbfrc1f060d9e41e7246@mail.gmail.com>
Date: Mon, 15 Sep 2008 21:03:41 -0700
From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: read only remount not so happy
In-Reply-To: <e03b90ae0809141904r47de6883k185174bb13df34b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e03b90ae0809141904r47de6883k185174bb13df34b4@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is starting to go downhill. Everything is still running, but some
processes that interact with the filesystem actions are performing
slowly.

===


[9608310.848311] Assertion failed: atomic_read(&mp->m_active_trans) ==
0, file: /build/buildd/linux-2.6.24/fs/xfs/xfs_vfsops.c, line: 708
[9608310.848342] ------------[ cut here ]------------
[9608310.848370] kernel BUG at
/build/buildd/linux-2.6.24/fs/xfs/support/debug.c:82!
[9608310.848414] invalid opcode: 0000 [1] SMP
[9608310.848441] CPU 6
[9608310.848463] Modules linked in: xfs parport_pc lp parport loop
ipv6 iTCO_wdt igb container button iTCO_vendor_support shpchp
pci_hotplug evdev pcspkr psmouse ext3 jbd mbcache ata_generic usbhid
hid pata_acpi sg sr_mod cdrom sd_mod ata_piix floppy ehci_hcd uhci_hcd
libata usbcore tg3 arcmsr scsi_mod raid10 raid456 async_xor
async_memcpy async_tx xor raid1 raid0 multipath linear md_mod thermal
processor fan fuse
[9608310.848707] Pid: 18600, comm: mount Not tainted 2.6.24-8-server #1
[9608310.848735] RIP: 0010:[<ffffffff88372d7a>]  [<ffffffff88372d7a>]
:xfs:assfail+0x1a/0x20
[9608310.848806] RSP: 0018:ffff810100c0dc08  EFLAGS: 00010296
[9608310.848832] RAX: 000000000000008d RBX: ffff810803bbc000 RCX:
0000000000000001
[9608310.848875] RDX: ffffffff80585c68 RSI: 0000000000000082 RDI:
ffffffff80585c60
[9608310.848918] RBP: ffff810101181000 R08: 0000000000000000 R09:
ffff8106e2d7ba10
[9608310.848962] R10: ffff810001071c60 R11: 0000000000000000 R12:
ffff810803bbc000
[9608310.849005] R13: ffff810100c0dc6c R14: ffff8102bbf6b000 R15:
0000000000000008
[9608310.849048] FS:  00007f24b60746e0(0000) GS:ffff810810066a00(0000)
knlGS:0000000000000000
[9608310.849094] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[9608310.849121] CR2: 00007fd1756cc000 CR3: 0000000628179000 CR4:
00000000000006e0
[9608310.849166] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[9608310.849210] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[9608310.849254] Process mount (pid: 18600, threadinfo
ffff810100c0c000, task ffff810100f77740)
[9608310.849301] Stack:  ffff810101181000 ffffffff8836189e
ffff810803bbc000 ffffffff88361943
[9608310.849358]  0000000000000000 ffffffff88371e56 7fffffffffffffff
ffff8107ffc9f400
[9608310.849411]  00000000fffffff0 0000000000000000 ffff8102bbf6b000
ffffffff802b1445
[9608310.849447] Call Trace:
[9608310.849498]  [<ffffffff8836189e>] :xfs:xfs_attr_quiesce+0x4e/0x70
[9608310.849539]  [<ffffffff88361943>] :xfs:xfs_mntupdate+0x63/0x90
[9608310.849579]  [<ffffffff88371e56>] :xfs:xfs_fs_remount+0x56/0x90
[9608310.849612]  [<ffffffff802b1445>] do_remount_sb+0xd5/0x150
[9608310.849642]  [<ffffffff802c8e76>] do_mount+0x476/0x7e0
[9608310.849672]  [<ffffffff8029100b>] handle_mm_fault+0x3db/0x800
[9608310.849703]  [<ffffffff80282468>] filemap_fault+0x188/0x390
[9608310.849733]  [<ffffffff8034bf21>] __up_read+0x21/0xb0
[9608310.849763]  [<ffffffff8046bcc0>] do_page_fault+0x1d0/0x840
[9608310.849792]  [<ffffffff8028d87d>] zone_statistics+0x7d/0x80
[9608310.849827]  [<ffffffff80285e1b>] __get_free_pages+0x1b/0x40
[9608310.849857]  [<ffffffff802c992b>] sys_mount+0x9b/0x100
[9608310.849887]  [<ffffffff8020c37e>] system_call+0x7e/0x83
[9608310.849916]
[9608310.849936]
[9608310.849936] Code: 0f 0b eb fe 66 90 41 55 41 54 49 89 f4 55 89 fd
48 c7 c7 e8
[9608310.850055] RIP  [<ffffffff88372d7a>] :xfs:assfail+0x1a/0x20
[9608310.850096]  RSP <ffff810100c0dc08>
[9608310.850457] ---[ end trace 709b42dcfdb7d7b2 ]---
[9608310.850527] WARNING: at
/build/buildd/linux-2.6.24/kernel/exit.c:917 do_exit()
[9608310.850614] Pid: 18600, comm: mount Tainted: G      D 2.6.24-8-server #1
[9608310.850686]
[9608310.850687] Call Trace:
[9608310.850814]  [<ffffffff80241b3a>] do_exit+0x7aa/0x940
[9608310.850885]  [<ffffffff8036bc40>] vgacon_blank+0x340/0x620
[9608310.850957]  [<ffffffff803a5a99>] set_palette+0x9/0x60
[9608310.851029]  [<ffffffff8036aeee>] vgacon_set_cursor_size+0x2e/0xf0
[9608310.851103]  [<ffffffff8020dc72>] die+0x52/0x70
[9608310.851173]  [<ffffffff8020e1c6>] do_invalid_op+0x86/0xa0
[9608310.851253]  [<ffffffff88372d7a>] :xfs:assfail+0x1a/0x20
[9608310.851326]  [<ffffffff8023e4fe>] printk+0x4e/0x60
[9608310.851396]  [<ffffffff8046a099>] error_exit+0x0/0x51
[9608310.851478]  [<ffffffff88372d7a>] :xfs:assfail+0x1a/0x20
[9608310.851559]  [<ffffffff88372d7a>] :xfs:assfail+0x1a/0x20
[9608310.851641]  [<ffffffff8836189e>] :xfs:xfs_attr_quiesce+0x4e/0x70
[9608310.851723]  [<ffffffff88361943>] :xfs:xfs_mntupdate+0x63/0x90
[9608310.851805]  [<ffffffff88371e56>] :xfs:xfs_fs_remount+0x56/0x90
[9608310.851878]  [<ffffffff802b1445>] do_remount_sb+0xd5/0x150
[9608310.851949]  [<ffffffff802c8e76>] do_mount+0x476/0x7e0
[9608310.852020]  [<ffffffff8029100b>] handle_mm_fault+0x3db/0x800
[9608310.852092]  [<ffffffff80282468>] filemap_fault+0x188/0x390
[9608310.852164]  [<ffffffff8034bf21>] __up_read+0x21/0xb0
[9608310.852234]  [<ffffffff8046bcc0>] do_page_fault+0x1d0/0x840
[9608310.852308]  [<ffffffff8028d87d>] zone_statistics+0x7d/0x80
[9608310.852384]  [<ffffffff80285e1b>] __get_free_pages+0x1b/0x40
[9608310.852455]  [<ffffffff802c992b>] sys_mount+0x9b/0x100
[9608310.852525]  [<ffffffff8020c37e>] system_call+0x7e/0x83
