Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3S22gHb063256 for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 21:02:42 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E01E243AB0
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 19:02:38 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id YrtwbClG9Pumgboq for
	<xfs@oss.sgi.com>; Mon, 27 Apr 2009 19:02:38 -0700 (PDT)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.69)
	(envelope-from <root@schmorp.de>) id 1Lycea-0005Ht-KR
	for xfs@oss.sgi.com; Tue, 28 Apr 2009 02:02:36 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.69)
	(envelope-from <root@schmorp.de>) id 1Lycea-0000rh-Eg
	for xfs@oss.sgi.com; Tue, 28 Apr 2009 02:02:36 +0000
Received: from root by cerebro.laendle with local (Exim 4.69)
	(envelope-from <root@schmorp.de>) id 1Lycea-0003Zv-E6
	for xfs@oss.sgi.com; Tue, 28 Apr 2009 04:02:36 +0200
Date: Tue, 28 Apr 2009 04:02:36 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: crashes with xfs_fsr in 2.6.25-2-amd64 and 2.6.26-1-amd64 (debian)
Message-ID: <20090428020236.GA13721@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

(I am not on the list)

I just had a crash on one of my machines involving xfs_fsr and xfs, with both
kernels in the subject.

The backtrace (also below) looks very similar to the one in
http://archives.free.net.ph/message/20090402.024744.fd43d33b.en.html

In addition, in both crashes, I had this line logged after restart:

[   87.556507] Filesystem "loop7": Access to block zero in inode 593140302 start_block: 0 start_off: 0 blkcnt: 0 extent-state: 0 lastx: 2

I run xfs_fsr regularly once a day, and ran it many times with 2.5.25-2
before without (apparently) any problems, but I recently upgraded from
some older debian testing to lenny (which probably also upgraded xfs_fsr).

[16417.013540] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[16417.013540] IP: [<ffffffffa02d50cc>] :xfs:xfs_trans_find_item+0x0/0x5
[16417.013540] PGD 11d1f2067 PUD 11d026067 PMD 0 
[16417.013540] Oops: 0000 [1] SMP 
[16417.013540] CPU 1 
[16417.019603] Modules linked in: cpufreq_ondemand freq_table nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc nf_conntrack_ipv6 xt_state ip6table_filter ip6_tables ipt_MASQUERADE ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables xfs loop tun autofs4 w83627ehf hwmon_vid eeprom ipv6 snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_usb_lib snd_rawmidi snd_seq_device snd_hwdep snd parport_pc pcspkr soundcore parport k8temp psmouse serio_raw shpchp pci_hotplug button i2c_nforce2 i2c_core evdev reiserfs dm_mirror dm_log dm_snapshot dm_mod sd_mod ide_disk ide_pci_generic amd74xx ide_core sata_nv megaraid ata_generic forcedeth ehci_hcd ohci_hcd thermal processor fan thermal_sys sata_via libata scsi_mod dock
[16417.019603] Pid: 8767, comm: xfs_fsr Not tainted 2.6.26-1-amd64 #1
[16417.019603] RIP: 0010:[<ffffffffa02d50cc>]  [<ffffffffa02d50cc>] :xfs:xfs_trans_find_item+0x0/0x5
[16417.019603] RSP: 0018:ffff81011e351c70  EFLAGS: 00010206
[16417.019603] RAX: 0000000000000008 RBX: ffff8100687e9cc8 RCX: ffff81011e351e04
[16417.019603] RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff8100687e9cc8
[16417.019603] RBP: ffffffffffffffff R08: 0000000000000000 R09: ffff81011e351d28
[16417.019603] R10: ffff8100bf88d6c0 R11: ffff8100bf88d6c0 R12: ffff81011f404b00
[16417.019603] R13: 0000000000000005 R14: 0000000000000000 R15: ffff8100d991a000
[16417.019603] FS:  00007f8be8dee6e0(0000) GS:ffff810123a7b8c0(0000) knlGS:00000000f7c7a6c0
[16417.019603] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[16417.019603] CR2: 0000000000000018 CR3: 000000010fafa000 CR4: 00000000000006e0
[16417.019603] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16417.019603] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[16417.019603] Process xfs_fsr (pid: 8767, threadinfo ffff81011e350000, task ffff810097184d60)
[16417.019603] Stack:  ffffffffa02d4f1f 0000000000000000 ffff81011f404b00 ffff81011f404b60
[16417.019603]  ffffffffa02a8471 ffff81011e351d58 0000000000000000 0000000000000000
[16417.019603]  0000000000000000 0000000000000296 0000000200000001 0000000000000000
[16417.019603] Call Trace:
[16417.019603]  [<ffffffffa02d4f1f>] ? :xfs:xfs_trans_log_inode+0x1a/0x42
[16417.019603]  [<ffffffffa02a8471>] ? :xfs:xfs_bunmapi+0xa5b/0xad7
[16417.031595]  [<ffffffffa02c251a>] ? :xfs:xfs_itruncate_finish+0x174/0x2ba
[16417.031595]  [<ffffffffa02db5aa>] ? :xfs:xfs_inactive+0x1df/0x412
[16417.031595]  [<ffffffff8022adc9>] ? __wake_up+0x38/0x4f
[16417.031595]  [<ffffffffa02e3f08>] ? :xfs:xfs_fs_clear_inode+0xa4/0xe8
[16417.031595]  [<ffffffff802accd6>] ? clear_inode+0xad/0x104
[16417.031595]  [<ffffffff802ace37>] ? generic_delete_inode+0xc3/0x11f
[16417.031595]  [<ffffffff802aa5f6>] ? d_kill+0x38/0x59
[16417.031595]  [<ffffffff802aa93f>] ? dput+0xd3/0xdd
[16417.031595]  [<ffffffff8029bd1c>] ? __fput+0x142/0x16b
[16417.031595]  [<ffffffff8029942f>] ? filp_close+0x5d/0x65
[16417.031595]  [<ffffffff8029a64e>] ? sys_close+0x7e/0xb7
[16417.031595]  [<ffffffff8020beca>] ? system_call_after_swapgs+0x8a/0x8f
[16417.031595] 
[16417.031595] 
[16417.031595] Code: 4b 64 04 48 8b 44 24 10 48 89 a8 a0 00 00 00 48 8b 44 24 10 49 89 06 48 83 c4 18 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 90 <48> 8b 46 18 c3 41 57 45 31 ff 41 56 45 31 f6 41 55 41 54 4c 8d 
[16417.031595] RIP  [<ffffffffa02d50cc>] :xfs:xfs_trans_find_item+0x0/0x5
[16417.031595]  RSP <ffff81011e351c70>
[16417.031595] CR2: 0000000000000018
[16417.051239] ---[ end trace e573b4588b7924cb ]---


-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      pcg@goof.com
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
