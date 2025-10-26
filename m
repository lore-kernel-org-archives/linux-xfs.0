Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4827B20B81B
	for <linux-xfs@vger.kernel.org>; Sun, 26 Oct 2025 17:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761501406; cv=none; b=TFgU06NDdTzOQTlb1t1kRAW6a9WD60LBtm8ilwogPHPJ5FA1plKHyNV6l5x0Wn98LrRn2s3X6hZrnh03rDg6sigWgTZ0gwvMhtKqYr7s0ON/0Co6lBHFC+FPxFpsdpv8HnKMy+1uImS/fJtbIJZBNyK9hwXt/hQOX/7KhSTWuPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761501406; c=relaxed/simple;
	bh=sEOJc5wQTBxwYnDdYIyOX86HTBegbWpVjZ7/OvRPdvM=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=TB/skZxvYPvShM8yvsh/gSnb+5rvkao8sf9nLgN9S6xYaUeaIL+j7xPlUl1Mh947LCc//R5AMDBtgS+lrAh9MaT33sFW4cf7TcWYTydlC55WWxNapRYe691KvUh81eGye7Myc4BLV93fSSzsqANrL4sGYcQ/IcY5EfRX+CiUwDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 6E71D180F2C0;
	Sun, 26 Oct 2025 18:49:17 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id TtMvER1f/mhPISAAKEJqOA
	(envelope-from <lukas@herbolt.com>); Sun, 26 Oct 2025 18:49:17 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 26 Oct 2025 18:49:17 +0100
From: lukas@herbolt.com
To: Dave Chinner <david@fromorbit.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Remove WARN_ONCE if xfs_uuid_table grows over 2x
 PAGE_SIZE.
In-Reply-To: <aPgDAAfq8opIeSWp@dread.disaster.area>
References: <20251021141744.1375627-1-lukas@herbolt.com>
 <20251021141744.1375627-4-lukas@herbolt.com>
 <aPgDAAfq8opIeSWp@dread.disaster.area>
Message-ID: <69d616701a245caed926a8b8093749b2@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-10-22 00:02, Dave Chinner wrote:
> On Tue, Oct 21, 2025 at 04:17:45PM +0200, Lukas Herbolt wrote:
>> The krealloc prints out warning if allocation is bigger than 2x 
>> PAGE_SIZE,
>> lets use kvrealloc for the memory allocation.
> 
> What warning is that?  i.e. it helps to quote the error in the
> commit message so that, in future, we know exactly what the warning
> we fixed here.

My bad, it was old RHEL kernel and I did not check if the upstream still
behaves the same. I just saw the xfs_uuid_table still uses the 
krealloc()
and expected the same issue without double checking it.

The bellow patch actually removed the warning, and it landed in 6.12.
Still do we need to use the krealloc for the xfs_uuid_table?

903edea6c53

[  124.615797] XFS (loop509): Mounting V5 Filesystem 
e21c5391-f7d0-4ca3-9d91-7cfce8ec3cdd
[  124.620767] XFS (loop509): Ending clean mount
[  124.687216] loop510: detected capacity change from 0 to 614400
[  124.713986] ------------[ cut here ]------------
[  124.715034] WARNING: CPU: 32 PID: 11848 at mm/page_alloc.c:3040 
rmqueue+0x44/0x10d0
[  124.722884] Modules linked in: rfkill vfat fat intel_rapl_msr 
intel_rapl_common intel_uncore_frequency_common skx_edac_common nfit 
libnvdimm snd_hda_codec_generic kvm_intel snd_hda_intel iTCO_wdt 
snd_intel_dspcfg iTCO_vendor_support snd_intel_sdw_acpi kvm 
snd_hda_codec snd_hda_core rapl snd_hwdep snd_pcm snd_timer snd i2c_i801 
pcspkr lpc_ich soundcore virtio_gpu i2c_smbus virtio_balloon 
virtio_dma_buf sg loop nfnetlink vsock_loopback 
vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vsock 
vmw_vmci xfs sd_mod ahci libahci crct10dif_pclmul crc32_pclmul 
crc32c_intel virtio_net libata ghash_clmulni_intel virtio_scsi 
virtio_console net_failover virtio_blk failover serio_raw sunrpc 
dm_mirror dm_region_hash dm_log dm_mod fuse
[  124.741904] CPU: 32 UID: 0 PID: 11848 Comm: mount Kdump: loaded Not 
tainted 6.11.0-0.test.f42.x86_64 #1
[  124.744967] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
edk2-20241117-5.fc40 11/17/2024
[  124.747429] RIP: 0010:rmqueue+0x44/0x10d0
[  124.748647] Code: 89 44 24 60 44 89 4c 24 44 65 48 8b 04 25 28 00 00 
00 48 89 84 24 90 00 00 00 31 c0 80 e5 80 74 0b 83 fa 01 0f 86 52 0c 00 
00 <0f> 0b 83 fd 03 0f 96 c2 83 fd 09 0f 94 c0 08 c2 88 54 24 73 0f 85
[  124.753035] RSP: 0018:ffffaa1621a67a38 EFLAGS: 00010202
[  124.754617] RAX: 0000000000000000 RBX: ffff8e25bffd5d80 RCX: 
00000000000480c0
[  124.756251] RDX: 0000000000000002 RSI: ffff8e25bffd5d80 RDI: 
ffff8e25bffd5d80
[  124.758018] RBP: 0000000000000002 R08: 0000000000000901 R09: 
0000000000000000
[  124.759910] R10: 0000000000000000 R11: ffffe76b8b367d08 R12: 
0000000000000002
[  124.761545] R13: ffff8e25bffd5d80 R14: ffff8e25bffd71c0 R15: 
0000000000000901
[  124.763508] FS:  00007fd8c7427800(0000) GS:ffff8e242fa00000(0000) 
knlGS:0000000000000000
[  124.765484] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  124.767042] CR2: 00007fd8c72d8000 CR3: 0000000234bf8002 CR4: 
0000000000770ef0
[  124.769197] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  124.770916] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  124.772989] PKRU: 55555554
[  124.773899] Call Trace:
[  124.774762]  <TASK>
[  124.775628]  ? show_trace_log_lvl+0x1b0/0x2f0
[  124.776969]  ? show_trace_log_lvl+0x1b0/0x2f0
[  124.778131]  ? get_page_from_freelist+0x129/0x770
[  124.779342]  ? rmqueue+0x44/0x10d0
[  124.780331]  ? __warn.cold+0x93/0xed
[  124.781391]  ? rmqueue+0x44/0x10d0
[  124.782383]  ? report_bug+0xff/0x140
[  124.783641]  ? handle_bug+0x3a/0x70
[  124.784953]  ? exc_invalid_op+0x17/0x70
[  124.786128]  ? asm_exc_invalid_op+0x1a/0x20
[  124.787235]  ? rmqueue+0x44/0x10d0
[  124.788335]  ? selinux_kernfs_init_security+0x79/0x230
[  124.789601]  ? down_write+0x12/0x60
[  124.790584]  ? kernfs_activate+0x82/0xd0
[  124.791651]  ? kernfs_add_one+0x141/0x150
[  124.793876]  get_page_from_freelist+0x129/0x770
[  124.795441]  __alloc_pages_noprof+0x188/0x350
[  124.796967]  ___kmalloc_large_node+0x69/0x100
[  124.798569]  __kmalloc_large_node_noprof+0x1d/0xa0
[  124.800220]  __kmalloc_node_track_caller_noprof+0x34c/0x440
[  124.801981]  ? xfs_uuid_mount+0x155/0x180 [xfs]
[  124.803883]  ? krealloc_noprof+0x68/0xe0
[  124.805241]  krealloc_noprof+0x68/0xe0
[  124.806562]  xfs_uuid_mount+0x155/0x180 [xfs]
[  124.808648]  xfs_mountfs+0x2ce/0x950 [xfs]
[  124.810332]  xfs_fs_fill_super+0x53e/0x910 [xfs]
[  124.812119]  ? __pfx_xfs_fs_fill_super+0x10/0x10 [xfs]
[  124.814002]  get_tree_bdev+0x124/0x1c0
[  124.815272]  vfs_get_tree+0x26/0xd0
[  124.816457]  vfs_cmd_create+0x59/0xe0
[  124.817700]  __do_sys_fsconfig+0x4e9/0x6b0
[  124.819000]  do_syscall_64+0x7d/0x160
[  124.820196]  ? syscall_exit_work+0xf3/0x120
[  124.821455]  ? syscall_exit_to_user_mode+0x10/0x1f0
[  124.822909]  ? do_syscall_64+0x89/0x160
[  124.823907]  ? clear_bhb_loop+0x25/0x80
[  124.824895]  ? clear_bhb_loop+0x25/0x80
[  124.826085]  ? clear_bhb_loop+0x25/0x80
[  124.826980]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  124.828167] RIP: 0033:0x7fd8c760edbe
[  124.829061] Code: 73 01 c3 48 8b 0d 52 80 0c 00 f7 d8 64 89 01 48 83 
c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa 49 89 ca b8 af 01 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 22 80 0c 00 f7 d8 64 89 01 48
[  124.833439] RSP: 002b:00007ffca3bfd0b8 EFLAGS: 00000246 ORIG_RAX: 
00000000000001af
[  124.834983] RAX: ffffffffffffffda RBX: 000056408060ec90 RCX: 
00007fd8c760edbe
[  124.836809] RDX: 0000000000000000 RSI: 0000000000000006 RDI: 
0000000000000003
[  124.838281] RBP: 0000000000000000 R08: 0000000000000000 R09: 
0000000000000040
[  124.839768] R10: 0000000000000000 R11: 0000000000000246 R12: 
00007fd8c7760b00
[  124.841234] R13: 000056408065ed00 R14: 00007fd8c7754561 R15: 
000056408060edd8
[  124.842725]  </TASK>
[  124.843566] ---[ end trace 0000000000000000 ]---
