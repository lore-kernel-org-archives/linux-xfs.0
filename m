Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5E787F3F
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 13:27:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C28DE8F8059
	for <xfs@oss.sgi.com>; Tue, 25 Nov 2014 11:27:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yA2pEaMLTPEhw6cM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Nov 2014 11:27:42 -0800 (PST)
Date: Tue, 25 Nov 2014 14:27:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Insight into soft lockup related to XFS?
Message-ID: <20141125192737.GC8132@bfoster.bfoster>
References: <CAPLnt650QrFkkUC7kw4zVtDg6VsFqGoXEKSq_fzVjQ9acpruKg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPLnt650QrFkkUC7kw4zVtDg6VsFqGoXEKSq_fzVjQ9acpruKg@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Galen Charlton <gmc@esilibrary.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 25, 2014 at 09:57:03AM -0800, Galen Charlton wrote:
> Hi,
> 
> Yesterday a Linux PostgreSQL server spontaneously rebooted after a few
> minutes of high I/O wait.  The kernel log reported a number of errors
> related to the XFS filesystem backing the databases.
> 

Do you reproduce this often or is this a one-off occurrence?

> Here is the uname -a: Linux pg01 3.2.0-4-amd64 #1 SMP Debian
> 3.2.46-1+deb7u1 x86_64 GNU/Linux
> 

Fairly old and a distro kernel, though it looks like this could be a
stable variant (I'm not familiar with Debian kernels).

> The filesystem in question is XFS running on top of an LVM2 logical
> volume over SSDs.  There was no indication of a hardware failure.
> 
> Relevant kernel error messages are below. I would appreciate thoughts
> on whether this is a known bug, and whether it would be advisable to
> upgrade to a newer kernel version.
> 

FYI, the output below is line-wrapped and difficult to read. It's best
to try and post log content so your mailer doesn't munge it (or also
attach it unformatted so it's easier to parse).

Anyways, this looks like it could be the lock recursion problem fixed by
the following commits:

5337fe9b xfs: recheck buffer pinned status after push trylock failure
fa5566e4 xfs: remove log force from xfs_buf_trylock()

... which were introduced around v3.9. On a quick search, I don't see
these commits in stable trees before that so the v3.10 stable tree would
be the first where they are available.

Brian

> TIA,
> 
> Galen
> 
> Nov 24 16:16:30 pg01 kernel: [14140257.012068] BUG: soft lockup -
> CPU#8 stuck for 22s! [xfsaild/dm-1:2225]
> Nov 24 16:16:30 pg01 kernel: [14140257.012081] Modules linked in:
> mptctl mptbase nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xfs
> drbd lru_cache loop snd_pcm mperf snd_page_alloc snd_timer snd
> amd64_edac_mod edac_mce_amd sp5100_tco hpwdt joydev evdev crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic soundcore
> cryptd edac_core pcspkr psmouse serio_raw i2c_piix4 fam15h_power
> k10temp i2c_core hpilo container processor thermal_sys
> acpi_power_meter button ext4 crc16 jbd2 mbcache dm_mod usbhid hid
> ata_generic ahci sd_mod sg crc_t10dif libahci uhci_hcd ohci_hcd
> pata_atiixp libata ehci_hcd usbcore tg3 hpsa libphy scsi_mod
> usb_common [last unloaded: scsi_wait_scan]
> Nov 24 16:16:30 pg01 kernel: [14140257.012156] CPU 8
> Nov 24 16:16:30 pg01 kernel: [14140257.012158] Modules linked in:
> mptctl mptbase nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xfs
> drbd lru_cache loop snd_pcm mperf snd_page_alloc snd_timer snd
> amd64_edac_mod edac_mce_amd sp5100_tco hpwdt joydev evdev crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic soundcore
> cryptd edac_core pcspkr psmouse serio_raw i2c_piix4 fam15h_power
> k10temp i2c_core hpilo container processor thermal_sys
> acpi_power_meter button ext4 crc16 jbd2 mbcache dm_mod usbhid hid
> ata_generic ahci sd_mod sg crc_t10dif libahci uhci_hcd ohci_hcd
> pata_atiixp libata ehci_hcd usbcore tg3 hpsa libphy scsi_mod
> usb_common [last unloaded: scsi_wait_scan]
> Nov 24 16:16:30 pg01 kernel: [14140257.012209]
> Nov 24 16:16:30 pg01 kernel: [14140257.012213] Pid: 2225, comm:
> xfsaild/dm-1 Not tainted 3.2.0-4-amd64 #1 Debian 3.2.46-1+deb7u1 HP
> ProLiant DL385p Gen8
> Nov 24 16:16:30 pg01 kernel: [14140257.012219] RIP:
> 0010:[<ffffffff81070e3a>]  [<ffffffff81070e3a>]
> do_raw_spin_lock+0x15/0x1b
> Nov 24 16:16:30 pg01 kernel: [14140257.012230] RSP:
> 0000:ffff880ffbc79d68  EFLAGS: 00000297
> Nov 24 16:16:30 pg01 kernel: [14140257.012233] RAX: 00000000cc7acc79
> RBX: 0000000000000001 RCX: 0000000000051a00
> Nov 24 16:16:30 pg01 kernel: [14140257.012236] RDX: 000000000000cc7a
> RSI: ffff880ffd112ea8 RDI: ffff880fff979ef8
> Nov 24 16:16:30 pg01 kernel: [14140257.012240] RBP: ffff88103839fcc0
> R08: 0000000000000000 R09: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012243] R10: 0000000000000000
> R11: ffff880ffc0e4800 R12: 0000000000000100
> Nov 24 16:16:30 pg01 kernel: [14140257.012246] R13: ffff8810396a7618
> R14: ffff8810396a75d8 R15: 0000000000000058
> Nov 24 16:16:30 pg01 kernel: [14140257.012251] FS:
> 00007f03d4d3b720(0000) GS:ffff88103fd00000(0000)
> knlGS:0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012254] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Nov 24 16:16:30 pg01 kernel: [14140257.012257] CR2: 00007f03d5005240
> CR3: 0000000001605000 CR4: 00000000000406e0
> Nov 24 16:16:30 pg01 kernel: [14140257.012261] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012265] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Nov 24 16:16:30 pg01 kernel: [14140257.012269] Process xfsaild/dm-1
> (pid: 2225, threadinfo ffff880ffbc78000, task ffff880ffc184f20)
> Nov 24 16:16:30 pg01 kernel: [14140257.012272] Stack:
> Nov 24 16:16:30 pg01 kernel: [14140257.012277]  ffffffffa03decb8
> ffff880ffd112e00 ffffffffa03db42c ffff880ffd112e00
> Nov 24 16:16:30 pg01 kernel: [14140257.012303]  ffffffffa03db48f
> ffff88103839fcc0 ffff880ffd112e00 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012315]  ffffffffa03dbf54
> 0000000000000000 ffff880ffc0e4800 ffff8830527b16d8
> Nov 24 16:16:30 pg01 kernel: [14140257.012326] Call Trace:
> Nov 24 16:16:30 pg01 kernel: [14140257.012363]  [<ffffffffa03decb8>] ?
> xfs_ail_min_lsn+0xd/0x2b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012388]  [<ffffffffa03db42c>] ?
> xlog_assign_tail_lsn+0x11/0x26 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012413]  [<ffffffffa03db48f>] ?
> xlog_state_release_iclog+0x4e/0x8f [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012438]  [<ffffffffa03dbf54>] ?
> _xfs_log_force+0xe7/0x1ae [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012463]  [<ffffffffa03dc026>] ?
> xfs_log_force+0xb/0x2c [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012480]  [<ffffffffa03995d1>] ?
> xfs_buf_trylock+0x41/0x80 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012504]  [<ffffffffa03dd715>] ?
> xfs_buf_item_trylock+0x22/0x73 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012528]  [<ffffffffa03def39>] ?
> xfsaild+0x197/0x46b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012552]  [<ffffffffa03deda2>] ?
> xfs_trans_ail_cursor_first+0x79/0x79 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012561]  [<ffffffff8105f48d>] ?
> kthread+0x76/0x7e
> Nov 24 16:16:30 pg01 kernel: [14140257.012569]  [<ffffffff81355cf4>] ?
> kernel_thread_helper+0x4/0x10
> Nov 24 16:16:30 pg01 kernel: [14140257.012575]  [<ffffffff8105f417>] ?
> kthread_worker_fn+0x139/0x139
> Nov 24 16:16:30 pg01 kernel: [14140257.012581]  [<ffffffff81355cf0>] ?
> gs_change+0x13/0x13
> Nov 24 16:16:30 pg01 kernel: [14140257.012584] Code: 05 e8 9b 2c 14 00
> c3 f0 81 2f 00 00 10 00 74 05 e8 6c 2c 14 00 c3 b8 00 00 01 00 f0 0f
> c1 07 89 c2 c1 ea 10 66 39 d0 74 07 f3 90 <66> 8b 07 eb f4 c3 8b 17 31
> c0 89 d1 c1 e9 10 66 39 ca 75 14 8d
> Nov 24 16:16:30 pg01 kernel: [14140257.012784] Call Trace:
> Nov 24 16:16:30 pg01 kernel: [14140257.012808]  [<ffffffffa03decb8>] ?
> xfs_ail_min_lsn+0xd/0x2b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012833]  [<ffffffffa03db42c>] ?
> xlog_assign_tail_lsn+0x11/0x26 [xfs]
> root@pg01:/var/log# less kern.log.1
> Nov 24 16:16:30 pg01 kernel: [14140257.012068] BUG: soft lockup -
> CPU#8 stuck for 22s! [xfsaild/dm-1:2225]
> Nov 24 16:16:30 pg01 kernel: [14140257.012081] Modules linked in:
> mptctl mptbase nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xfs
> drbd lru_cache loop snd_pcm mperf snd_page_alloc snd_timer snd
> amd64_edac_mod edac_mce_amd sp5100_tco hpwdt joydev evdev crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic soundcore
> cryptd edac_core pcspkr psmouse serio_raw i2c_piix4 fam15h_power
> k10temp i2c_core hpilo container processor thermal_sys
> acpi_power_meter button ext4 crc16 jbd2 mbcache dm_mod usbhid hid
> ata_generic ahci sd_mod sg crc_t10dif libahci uhci_hcd ohci_hcd
> pata_atiixp libata ehci_hcd usbcore tg3 hpsa libphy scsi_mod
> usb_common [last unloaded: scsi_wait_scan]
> Nov 24 16:16:30 pg01 kernel: [14140257.012156] CPU 8
> Nov 24 16:16:30 pg01 kernel: [14140257.012158] Modules linked in:
> mptctl mptbase nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xfs
> drbd lru_cache loop snd_pcm mperf snd_page_alloc snd_timer snd
> amd64_edac_mod edac_mce_amd sp5100_tco hpwdt joydev evdev crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic soundcore
> cryptd edac_core pcspkr psmouse serio_raw i2c_piix4 fam15h_power
> k10temp i2c_core hpilo container processor thermal_sys
> acpi_power_meter button ext4 crc16 jbd2 mbcache dm_mod usbhid hid
> ata_generic ahci sd_mod sg crc_t10dif libahci uhci_hcd ohci_hcd
> pata_atiixp libata ehci_hcd usbcore tg3 hpsa libphy scsi_mod
> usb_common [last unloaded: scsi_wait_scan]
> Nov 24 16:16:30 pg01 kernel: [14140257.012209]
> Nov 24 16:16:30 pg01 kernel: [14140257.012213] Pid: 2225, comm:
> xfsaild/dm-1 Not tainted 3.2.0-4-amd64 #1 Debian 3.2.46-1+deb7u1 HP
> ProLiant DL385p Gen8
> Nov 24 16:16:30 pg01 kernel: [14140257.012219] RIP:
> 0010:[<ffffffff81070e3a>]  [<ffffffff81070e3a>]
> do_raw_spin_lock+0x15/0x1b
> Nov 24 16:16:30 pg01 kernel: [14140257.012230] RSP:
> 0000:ffff880ffbc79d68  EFLAGS: 00000297
> Nov 24 16:16:30 pg01 kernel: [14140257.012233] RAX: 00000000cc7acc79
> RBX: 0000000000000001 RCX: 0000000000051a00
> Nov 24 16:16:30 pg01 kernel: [14140257.012236] RDX: 000000000000cc7a
> RSI: ffff880ffd112ea8 RDI: ffff880fff979ef8
> Nov 24 16:16:30 pg01 kernel: [14140257.012240] RBP: ffff88103839fcc0
> R08: 0000000000000000 R09: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012243] R10: 0000000000000000
> R11: ffff880ffc0e4800 R12: 0000000000000100
> Nov 24 16:16:30 pg01 kernel: [14140257.012246] R13: ffff8810396a7618
> R14: ffff8810396a75d8 R15: 0000000000000058
> Nov 24 16:16:30 pg01 kernel: [14140257.012251] FS:
> 00007f03d4d3b720(0000) GS:ffff88103fd00000(0000)
> knlGS:0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012254] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Nov 24 16:16:30 pg01 kernel: [14140257.012257] CR2: 00007f03d5005240
> CR3: 0000000001605000 CR4: 00000000000406e0
> Nov 24 16:16:30 pg01 kernel: [14140257.012261] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012265] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Nov 24 16:16:30 pg01 kernel: [14140257.012269] Process xfsaild/dm-1
> (pid: 2225, threadinfo ffff880ffbc78000, task ffff880ffc184f20)
> Nov 24 16:16:30 pg01 kernel: [14140257.012272] Stack:
> Nov 24 16:16:30 pg01 kernel: [14140257.012277]  ffffffffa03decb8
> ffff880ffd112e00 ffffffffa03db42c ffff880ffd112e00
> Nov 24 16:16:30 pg01 kernel: [14140257.012303]  ffffffffa03db48f
> ffff88103839fcc0 ffff880ffd112e00 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.012315]  ffffffffa03dbf54
> 0000000000000000 ffff880ffc0e4800 ffff8830527b16d8
> Nov 24 16:16:30 pg01 kernel: [14140257.012326] Call Trace:
> Nov 24 16:16:30 pg01 kernel: [14140257.012363]  [<ffffffffa03decb8>] ?
> xfs_ail_min_lsn+0xd/0x2b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012388]  [<ffffffffa03db42c>] ?
> xlog_assign_tail_lsn+0x11/0x26 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012413]  [<ffffffffa03db48f>] ?
> xlog_state_release_iclog+0x4e/0x8f [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012438]  [<ffffffffa03dbf54>] ?
> _xfs_log_force+0xe7/0x1ae [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012463]  [<ffffffffa03dc026>] ?
> xfs_log_force+0xb/0x2c [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012480]  [<ffffffffa03995d1>] ?
> xfs_buf_trylock+0x41/0x80 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012504]  [<ffffffffa03dd715>] ?
> xfs_buf_item_trylock+0x22/0x73 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012528]  [<ffffffffa03def39>] ?
> xfsaild+0x197/0x46b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012552]  [<ffffffffa03deda2>] ?
> xfs_trans_ail_cursor_first+0x79/0x79 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012561]  [<ffffffff8105f48d>] ?
> kthread+0x76/0x7e
> Nov 24 16:16:30 pg01 kernel: [14140257.012569]  [<ffffffff81355cf4>] ?
> kernel_thread_helper+0x4/0x10
> Nov 24 16:16:30 pg01 kernel: [14140257.012575]  [<ffffffff8105f417>] ?
> kthread_worker_fn+0x139/0x139
> Nov 24 16:16:30 pg01 kernel: [14140257.012581]  [<ffffffff81355cf0>] ?
> gs_change+0x13/0x13
> Nov 24 16:16:30 pg01 kernel: [14140257.012584] Code: 05 e8 9b 2c 14 00
> c3 f0 81 2f 00 00 10 00 74 05 e8 6c 2c 14 00 c3 b8 00 00 01 00 f0 0f
> c1 07 89 c2 c1 ea 10 66 39 d0 74 07 f3 90 <66> 8b 07 eb f4 c3 8b 17 31
> c0 89 d1 c1 e9 10 66 39 ca 75 14 8d
> Nov 24 16:16:30 pg01 kernel: [14140257.012784] Call Trace:
> Nov 24 16:16:30 pg01 kernel: [14140257.012808]  [<ffffffffa03decb8>] ?
> xfs_ail_min_lsn+0xd/0x2b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012833]  [<ffffffffa03db42c>] ?
> xlog_assign_tail_lsn+0x11/0x26 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012858]  [<ffffffffa03db48f>] ?
> xlog_state_release_iclog+0x4e/0x8f [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012882]  [<ffffffffa03dbf54>] ?
> _xfs_log_force+0xe7/0x1ae [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012908]  [<ffffffffa03dc026>] ?
> xfs_log_force+0xb/0x2c [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012924]  [<ffffffffa03995d1>] ?
> xfs_buf_trylock+0x41/0x80 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012948]  [<ffffffffa03dd715>] ?
> xfs_buf_item_trylock+0x22/0x73 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012971]  [<ffffffffa03def39>] ?
> xfsaild+0x197/0x46b [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.012996]  [<ffffffffa03deda2>] ?
> xfs_trans_ail_cursor_first+0x79/0x79 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.013002]  [<ffffffff8105f48d>] ?
> kthread+0x76/0x7e
> Nov 24 16:16:30 pg01 kernel: [14140257.013009]  [<ffffffff81355cf4>] ?
> kernel_thread_helper+0x4/0x10
> Nov 24 16:16:30 pg01 kernel: [14140257.013016]  [<ffffffff8105f417>] ?
> kthread_worker_fn+0x139/0x139
> Nov 24 16:16:30 pg01 kernel: [14140257.013022]  [<ffffffff81355cf0>] ?
> gs_change+0x13/0x13
> Nov 24 16:16:30 pg01 kernel: [14140257.772117] BUG: soft lockup -
> CPU#16 stuck for 23s! [kworker/16:0:22897]
> Nov 24 16:16:30 pg01 kernel: [14140257.772135] Modules linked in:
> mptctl mptbase nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xfs
> drbd lru_cache loop snd_pcm mperf snd_page_alloc snd_timer snd
> amd64_edac_mod edac_mce_amd sp5100_tco hpwdt joydev evdev crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic soundcore
> cryptd edac_core pcspkr psmouse serio_raw i2c_piix4 fam15h_power
> k10temp i2c_core hpilo container processor thermal_sys
> acpi_power_meter button ext4 crc16 jbd2 mbcache dm_mod usbhid hid
> ata_generic ahci sd_mod sg crc_t10dif libahci uhci_hcd ohci_hcd
> pata_atiixp libata ehci_hcd usbcore tg3 hpsa libphy scsi_mod
> usb_common [last unloaded: scsi_wait_scan]
> Nov 24 16:16:30 pg01 kernel: [14140257.772221] CPU 16
> Nov 24 16:16:30 pg01 kernel: [14140257.772223] Modules linked in:
> mptctl mptbase nfsd nfs nfs_acl auth_rpcgss fscache lockd sunrpc xfs
> drbd lru_cache loop snd_pcm mperf snd_page_alloc snd_timer snd
> amd64_edac_mod edac_mce_amd sp5100_tco hpwdt joydev evdev crc32c_intel
> ghash_clmulni_intel aesni_intel aes_x86_64 aes_generic soundcore
> cryptd edac_core pcspkr psmouse serio_raw i2c_piix4 fam15h_power
> k10temp i2c_core hpilo container processor thermal_sys
> acpi_power_meter button ext4 crc16 jbd2 mbcache dm_mod usbhid hid
> ata_generic ahci sd_mod sg crc_t10dif libahci uhci_hcd ohci_hcd
> pata_atiixp libata ehci_hcd usbcore tg3 hpsa libphy scsi_mod
> usb_common [last unloaded: scsi_wait_scan]
> Nov 24 16:16:30 pg01 kernel: [14140257.772291]
> Nov 24 16:16:30 pg01 kernel: [14140257.772296] Pid: 22897, comm:
> kworker/16:0 Not tainted 3.2.0-4-amd64 #1 Debian 3.2.46-1+deb7u1 HP
> ProLiant DL385p Gen8
> Nov 24 16:16:30 pg01 kernel: [14140257.772303] RIP:
> 0010:[<ffffffff81070e3a>]  [<ffffffff81070e3a>]
> do_raw_spin_lock+0x15/0x1b
> Nov 24 16:16:30 pg01 kernel: [14140257.772315] RSP:
> 0000:ffff88089c3c5de8  EFLAGS: 00000293
> Nov 24 16:16:30 pg01 kernel: [14140257.772319] RAX: 00000000cc7bcc79
> RBX: 0000000000000000 RCX: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.772322] RDX: 000000000000cc7b
> RSI: 0000000000000000 RDI: ffff880fff979ef8
> Nov 24 16:16:30 pg01 kernel: [14140257.772326] RBP: ffff88089c3c5e40
> R08: 00007daa00040400 R09: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.772330] R10: 0000000000000000
> R11: ffff88106a7ff9f8 R12: ffff88303fdd3780
> Nov 24 16:16:30 pg01 kernel: [14140257.772333] R13: ffffffff81036e18
> R14: 00000001d2b38ed8 R15: ffff882039a5e080
> Nov 24 16:16:30 pg01 kernel: [14140257.772338] FS:
> 00007f03d4d3b720(0000) GS:ffff88203fc00000(0000)
> knlGS:0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.772342] CS:  0010 DS: 0000 ES:
> 0000 CR0: 000000008005003b
> Nov 24 16:16:30 pg01 kernel: [14140257.772345] CR2: 00007efdb86cf057
> CR3: 0000000001605000 CR4: 00000000000406e0
> Nov 24 16:16:30 pg01 kernel: [14140257.772349] DR0: 0000000000000000
> DR1: 0000000000000000 DR2: 0000000000000000
> Nov 24 16:16:30 pg01 kernel: [14140257.772353] DR3: 0000000000000000
> DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Nov 24 16:16:30 pg01 kernel: [14140257.772358] Process kworker/16:0
> (pid: 22897, threadinfo ffff88089c3c4000, task ffff881c1cde90e0)
> Nov 24 16:16:30 pg01 kernel: [14140257.772361] Stack:
> Nov 24 16:16:30 pg01 kernel: [14140257.772368]  ffffffffa03de40d
> ffff881c1cde94a0 000000103fc13780 ffff881c1cde90e0
> Nov 24 16:16:30 pg01 kernel: [14140257.772385]  ffff88203fc13780
> ffff881c1cde90e0 000000002956d538 ffff88208a3afac0
> Nov 24 16:16:30 pg01 kernel: [14140257.772398]  ffffe8e000c00a00
> 0000000000000000 ffffe8e000c00a55 ffff88203fc0e640
> Nov 24 16:16:30 pg01 kernel: [14140257.772411] Call Trace:
> Nov 24 16:16:30 pg01 kernel: [14140257.772446]  [<ffffffffa03de40d>] ?
> xfs_iflush_done+0xc7/0x160 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.772471]  [<ffffffffa03dd40f>] ?
> xfs_buf_do_callbacks+0x22/0x30 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.772496]  [<ffffffffa03dd644>] ?
> xfs_buf_iodone_callbacks+0x172/0x196 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.772505]  [<ffffffff8105b389>] ?
> process_one_work+0x161/0x264
> Nov 24 16:16:30 pg01 kernel: [14140257.772512]  [<ffffffff8105c34d>] ?
> worker_thread+0xc2/0x145
> Nov 24 16:16:30 pg01 kernel: [14140257.772519]  [<ffffffff8105c28b>] ?
> manage_workers.isra.25+0x15b/0x15b
> Nov 24 16:16:30 pg01 kernel: [14140257.772527]  [<ffffffff8105f48d>] ?
> kthread+0x76/0x7e
> Nov 24 16:16:30 pg01 kernel: [14140257.772535]  [<ffffffff81355cf4>] ?
> kernel_thread_helper+0x4/0x10
> Nov 24 16:16:30 pg01 kernel: [14140257.772543]  [<ffffffff8105f417>] ?
> kthread_worker_fn+0x139/0x139
> Nov 24 16:16:30 pg01 kernel: [14140257.772549]  [<ffffffff81355cf0>] ?
> gs_change+0x13/0x13
> Nov 24 16:16:30 pg01 kernel: [14140257.772552] Code: 05 e8 9b 2c 14 00
> c3 f0 81 2f 00 00 10 00 74 05 e8 6c 2c 14 00 c3 b8 00 00 01 00 f0 0f
> c1 07 89 c2 c1 ea 10 66 39 d0 74 07 f3 90 <66> 8b 07 eb f4 c3 8b 17 31
> c0 89 d1 c1 e9 10 66 39 ca 75 14 8d
> Nov 24 16:16:30 pg01 kernel: [14140257.772786] Call Trace:
> Nov 24 16:16:30 pg01 kernel: [14140257.772810]  [<ffffffffa03de40d>] ?
> xfs_iflush_done+0xc7/0x160 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.772835]  [<ffffffffa03dd40f>] ?
> xfs_buf_do_callbacks+0x22/0x30 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.772860]  [<ffffffffa03dd644>] ?
> xfs_buf_iodone_callbacks+0x172/0x196 [xfs]
> Nov 24 16:16:30 pg01 kernel: [14140257.772867]  [<ffffffff8105b389>] ?
> process_one_work+0x161/0x264
> Nov 24 16:16:30 pg01 kernel: [14140257.772873]  [<ffffffff8105c34d>] ?
> worker_thread+0xc2/0x145
> Nov 24 16:16:30 pg01 kernel: [14140257.772880]  [<ffffffff8105c28b>] ?
> manage_workers.isra.25+0x15b/0x15b
> Nov 24 16:16:30 pg01 kernel: [14140257.772887]  [<ffffffff8105f48d>] ?
> kthread+0x76/0x7e
> Nov 24 16:16:30 pg01 kernel: [14140257.772894]  [<ffffffff81355cf4>] ?
> kernel_thread_helper+0x4/0x10
> Nov 24 16:16:30 pg01 kernel: [14140257.772901]  [<ffffffff8105f417>] ?
> kthread_worker_fn+0x139/0x139
> Nov 24 16:16:30 pg01 kernel: [14140257.772907]  [<ffffffff81355cf0>] ?
> gs_change+0x13/0x13
> 
> -- 
> Galen Charlton
> Manager of Implementation
> Equinox Software, Inc. / The Open Source Experts
> email:  gmc@esilibrary.com
> direct: +1 770-709-5581
> cell:   +1 404-984-4366
> skype:  gmcharlt
> web:    http://www.esilibrary.com/
> Supporting Koha and Evergreen: http://koha-community.org &
> http://evergreen-ils.org
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
