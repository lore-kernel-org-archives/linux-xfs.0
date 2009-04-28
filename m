Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3S3OAkp066809 for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 22:24:10 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D92301CEF546
	for <xfs@oss.sgi.com>; Mon, 27 Apr 2009 20:24:07 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id gISqnF4XwX2ENNXM for
	<xfs@oss.sgi.com>; Mon, 27 Apr 2009 20:24:07 -0700 (PDT)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.69)
	(envelope-from <root@schmorp.de>) id 1LydvT-0006BA-2g
	for xfs@oss.sgi.com; Tue, 28 Apr 2009 03:24:07 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.69)
	(envelope-from <root@schmorp.de>) id 1LydvS-0005BF-Lz
	for xfs@oss.sgi.com; Tue, 28 Apr 2009 03:24:06 +0000
Received: from root by cerebro.laendle with local (Exim 4.69)
	(envelope-from <root@schmorp.de>) id 1LydvS-0003iZ-Cj
	for xfs@oss.sgi.com; Tue, 28 Apr 2009 05:24:06 +0200
Date: Tue, 28 Apr 2009 05:24:06 +0200
From: Marc Lehmann <schmorp@schmorp.de>
Subject: crashes with xfs_fsr in 2.6.25-2-amd64 and 2.6.26-1-amd64 (debian)
	(f'up)
Message-ID: <20090428032406.GA14234@schmorp.de>
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

As a followup, it seems I can "reproduce" the crash after a few hours of
heavy I/O and running xfs_fsr in a loop (during which xfs_fsr does not
actually defragment a file, i.e.):

It also happens to the same filesystem each time (maybe because
it does the heavy I/O),a and it is also the same filesystem where
xfs_repair hangs in an endless loop often (but not always). (see
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=525880)

The filesystem was created a month or so ago using blocksize of 512 and
lazy-count=1, but I have many of those xfs filesystems.

Since this is a production system and I have no backup abilities, I have
to no choice but to reformat the disk now.

[ 2492.159052] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
[ 2492.159299] IP: [<ffffffffa02d50cc>] :xfs:xfs_trans_find_item+0x0/0x5
[ 2492.159484] PGD 10b0cc067 PUD 10b140067 PMD 0 
[ 2492.159682] Oops: 0000 [1] SMP 
[ 2492.159841] CPU 1 
[ 2492.159964] Modules linked in: cpufreq_ondemand freq_table nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc nf_conntrack_ipv6 xt_state ip6table_filter ip6_tables ipt_MASQUERADE ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables xfs loop tun autofs4 w83627ehf hwmon_vid eeprom ipv6 snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm psmouse snd_timer parport_pc shpchp snd_usb_lib serio_raw parport snd_page_alloc k8temp pci_hotplug snd_rawmidi pcspkr snd_seq_device snd_hwdep snd soundcore i2c_nforce2 i2c_core button evdev reiserfs dm_mirror dm_log dm_snapshot dm_mod ide_disk sd_mod ide_pci_generic amd74xx ide_core megaraid sata_nv ata_generic forcedeth ehci_hcd ohci_hcd thermal processor fan thermal_sys sata_via libata scsi_mod dock
[ 2492.163516] Pid: 5852, comm: xfs_fsr Not tainted 2.6.26-1-amd64 #1
[ 2492.163516] RIP: 0010:[<ffffffffa02d50cc>]  [<ffffffffa02d50cc>] :xfs:xfs_trans_find_item+0x0/0x5
[ 2492.163516] RSP: 0018:ffff81010b2e3c70  EFLAGS: 00010206
[ 2492.163516] RAX: 0000000000000008 RBX: ffff81003a5ca688 RCX: ffff81010b2e3e04
[ 2492.163516] RDX: 0000000000000005 RSI: 0000000000000000 RDI: ffff81003a5ca688
[ 2492.167955] RBP: ffffffffffffffff R08: 0000000000000000 R09: ffff81010b2e3d28
[ 2492.167955] R10: ffff810054eb6b40 R11: ffff810054eb6b40 R12: ffff810113caa240
[ 2492.167955] R13: 0000000000000005 R14: 0000000000000000 R15: ffff81012182c000
[ 2492.167955] FS:  00007fd76f4d86e0(0000) GS:ffff810123a7b8c0(0000) knlGS:00000000f7ce66c0
[ 2492.167955] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2492.167955] CR2: 0000000000000018 CR3: 00000001071dc000 CR4: 00000000000006e0
[ 2492.167955] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2492.167955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2492.167955] Process xfs_fsr (pid: 5852, threadinfo ffff81010b2e2000, task ffff810073692890)
[ 2492.167955] Stack:  ffffffffa02d4f1f 0000000000000000 ffff810113caa240 ffff810113caa2a0
[ 2492.167955]  ffffffffa02a8471 ffff81010b2e3d58 0000000000000000 0000000000000000
[ 2492.167955]  0000000000000000 0000000000000296 0000000200000001 0000000000000000
[ 2492.167955] Call Trace:
[ 2492.167955]  [<ffffffffa02d4f1f>] ? :xfs:xfs_trans_log_inode+0x1a/0x42
[ 2492.167955]  [<ffffffffa02a8471>] ? :xfs:xfs_bunmapi+0xa5b/0xad7
[ 2492.167955]  [<ffffffffa02c251a>] ? :xfs:xfs_itruncate_finish+0x174/0x2ba
[ 2492.167955]  [<ffffffffa02db5aa>] ? :xfs:xfs_inactive+0x1df/0x412
[ 2492.167955]  [<ffffffff8022adc9>] ? __wake_up+0x38/0x4f
[ 2492.167955]  [<ffffffffa02e3f08>] ? :xfs:xfs_fs_clear_inode+0xa4/0xe8
[ 2492.167955]  [<ffffffff802accd6>] ? clear_inode+0xad/0x104
[ 2492.167955]  [<ffffffff802ace37>] ? generic_delete_inode+0xc3/0x11f
[ 2492.167955]  [<ffffffff802aa5f6>] ? d_kill+0x38/0x59
[ 2492.167955]  [<ffffffff802aa93f>] ? dput+0xd3/0xdd
[ 2492.167955]  [<ffffffff8029bd1c>] ? __fput+0x142/0x16b
[ 2492.167955]  [<ffffffff8029942f>] ? filp_close+0x5d/0x65
[ 2492.167955]  [<ffffffff8029a64e>] ? sys_close+0x7e/0xb7
[ 2492.167955]  [<ffffffff8020beca>] ? system_call_after_swapgs+0x8a/0x8f
[ 2492.167955] 
[ 2492.167955] 
[ 2492.167955] Code: 4b 64 04 48 8b 44 24 10 48 89 a8 a0 00 00 00 48 8b 44 24 10 49 89 06 48 83 c4 18 44 89 e0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 90 90 <48> 8b 46 18 c3 41 57 45 31 ff 41 56 45 31 f6 41 55 41 54 4c 8d 
[ 2492.167955] RIP  [<ffffffffa02d50cc>] :xfs:xfs_trans_find_item+0x0/0x5
[ 2492.167955]  RSP <ffff81010b2e3c70>
[ 2492.167955] CR2: 0000000000000018
[ 2492.182149] ---[ end trace 3101a51508d9f1e4 ]---



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
