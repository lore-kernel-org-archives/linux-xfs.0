Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DK0J4V039319 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 14:00:20 -0600
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	U7MxIeb7RayOaZ5z for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 12:00:17 -0800 (PST)
Message-ID: <4F396BCF.8070008@fangornsrealm.eu>
Date: Mon, 13 Feb 2012 21:00:15 +0100
From: Alexander Schwarzkopf <alexander.schwarzkopf@fangornsrealm.eu>
MIME-Version: 1.0
Subject: BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:5:29244] /
	xfs_trans_committed_bulk
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I have found some hangs with XFS filesystem, but not with this problem.

Our File, NIS- and Webserver runs fine for some months. But then it 
starts hanging.

Feb 10 11:48:17 lin71 kernel: [8794161.252204] BUG: soft lockup - CPU#0 
stuck for 67s! [kworker/0:5:29244]
Feb 10 11:48:17 lin71 kernel: [8794161.252240] Modules linked in: md4 
hmac nls_utf8 cifs btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus 
hfs minix ntfs vfat msdos fat jfs reiserfs ext4 jbd2 crc16 parport_pc 
ppdev lp parport nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc xfs 
ext2 loop snd_pcm snd_timer i2c_i801 sg sr_mod tpm_tis ghes cdrom 
ioatdma i2c_core i7core_edac snd tpm soundcore snd_page_alloc edac_core 
processor tpm_bios dca hed evdev joydev pcspkr psmouse thermal_sys 
serio_raw button ext3 jbd mbcache sd_mod crc_t10dif usbhid hid dm_mod 
usb_storage uas ata_generic uhci_hcd ata_piix libata ehci_hcd e1000e 
3w_sas scsi_mod usbcore [last unloaded: i2c_dev]
Feb 10 11:48:17 lin71 kernel: [8794161.252288] CPU 0
Feb 10 11:48:17 lin71 kernel: [8794161.252289] Modules linked in: md4 
hmac nls_utf8 cifs btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus 
hfs minix ntfs vfat msdos fat jfs reiserfs ext4 jbd2 crc16 parport_pc 
ppdev lp parport nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc xfs 
ext2 loop snd_pcm snd_timer i2c_i801 sg sr_mod tpm_tis ghes cdrom 
ioatdma i2c_core i7core_edac snd tpm soundcore snd_page_alloc edac_core 
processor tpm_bios dca hed evdev joydev pcspkr psmouse thermal_sys 
serio_raw button ext3 jbd mbcache sd_mod crc_t10dif usbhid hid dm_mod 
usb_storage uas ata_generic uhci_hcd ata_piix libata ehci_hcd e1000e 
3w_sas scsi_mod usbcore [last unloaded: i2c_dev]
Feb 10 11:48:17 lin71 kernel: [8794161.252327]
Feb 10 11:48:17 lin71 kernel: [8794161.252329] Pid: 29244, comm: 
kworker/0:5 Not tainted 2.6.39-bpo.2-amd64 #1 Supermicro X8DT6/X8DT6
Feb 10 11:48:17 lin71 kernel: [8794161.252333] RIP: 
0010:[<ffffffffa03573c3>]  [<ffffffffa03573c3>] 
xfs_trans_ail_update_bulk+0x1cc/0x1e0 [xfs]
Feb 10 11:48:17 lin71 kernel: [8794161.252354] RSP: 
0018:ffff88014d553bc0  EFLAGS: 00000202
Feb 10 11:48:17 lin71 kernel: [8794161.252356] RAX: ffff88020faf9df8 
RBX: 0000000000000001 RCX: 00000013001024b4
Feb 10 11:48:17 lin71 kernel: [8794161.252359] RDX: ffff88020faf9d20 
RSI: 0000000000000013 RDI: ffff8801129589c0
Feb 10 11:48:17 lin71 kernel: [8794161.252361] RBP: ffff88011541ac48 
R08: 0000000000000002 R09: dead000000200200
Feb 10 11:48:17 lin71 kernel: [8794161.252363] R10: dead000000100100 
R11: ffff8801bbc58840 R12: ffffffff81339d4e
Feb 10 11:48:17 lin71 kernel: [8794161.252365] R13: ffff88023479d000 
R14: dead000000100100 R15: ffffffff810ec5eb
Feb 10 11:48:17 lin71 kernel: [8794161.252368] FS:  
0000000000000000(0000) GS:ffff88023f200000(0000) knlGS:0000000000000000
Feb 10 11:48:17 lin71 kernel: [8794161.252370] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Feb 10 11:48:17 lin71 kernel: [8794161.252373] CR2: 00007fae00364260 
CR3: 0000000001603000 CR4: 00000000000006f0
Feb 10 11:48:17 lin71 kernel: [8794161.252375] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Feb 10 11:48:17 lin71 kernel: [8794161.252377] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Feb 10 11:48:17 lin71 kernel: [8794161.252380] Process kworker/0:5 (pid: 
29244, threadinfo ffff88014d552000, task ffff8802333ad7e0)
Feb 10 11:48:17 lin71 kernel: [8794161.252382] Stack:
Feb 10 11:48:17 lin71 kernel: [8794161.252405]  ffff8801129589c0 
ffff8801129589f0 0000000000000000 ffffffff8103a4d2
Feb 10 11:48:17 lin71 kernel: [8794161.252409]  0000000000000013 
ffff8801e66c8698 0000000000000283 001024b300000001
Feb 10 11:48:17 lin71 kernel: [8794161.252412]  ffff88011541ac48 
ffff88011541ac48 0000000000000000 ffff88011541ac48
Feb 10 11:48:17 lin71 kernel: [8794161.252416] Call Trace:
Feb 10 11:48:17 lin71 kernel: [8794161.252444]  [<ffffffff8103a4d2>] ? 
__wake_up+0x35/0x46
Feb 10 11:48:17 lin71 kernel: [8794161.252457]  [<ffffffffa03560bf>] ? 
xfs_trans_committed_bulk+0xc5/0x13f [xfs]
Feb 10 11:48:17 lin71 kernel: [8794161.252471]  [<ffffffffa034d2fc>] ? 
xlog_cil_committed+0x24/0xc2 [xfs]
Feb 10 11:48:17 lin71 kernel: [8794161.252484]  [<ffffffffa034a232>] ? 
xlog_state_do_callback+0x13a/0x228 [xfs]
Feb 10 11:48:17 lin71 kernel: [8794161.252496]  [<ffffffffa035f66e>] ? 
xfs_buf_relse+0x12/0x12 [xfs]
Feb 10 11:48:17 lin71 kernel: [8794161.252501]  [<ffffffff81059f67>] ? 
process_one_work+0x1d1/0x2ee
Feb 10 11:48:17 lin71 kernel: [8794161.252504]  [<ffffffff8105bec7>] ? 
worker_thread+0x12d/0x247
Feb 10 11:48:17 lin71 kernel: [8794161.252507]  [<ffffffff8105bd9a>] ? 
manage_workers+0x177/0x177
Feb 10 11:48:17 lin71 kernel: [8794161.252509]  [<ffffffff8105bd9a>] ? 
manage_workers+0x177/0x177
Feb 10 11:48:17 lin71 kernel: [8794161.252513]  [<ffffffff8105ef65>] ? 
kthread+0x7a/0x82
Feb 10 11:48:17 lin71 kernel: [8794161.252518]  [<ffffffff8133a4a4>] ? 
kernel_thread_helper+0x4/0x10
Feb 10 11:48:17 lin71 kernel: [8794161.252521]  [<ffffffff8105eeeb>] ? 
kthread_worker_fn+0x147/0x147
Feb 10 11:48:17 lin71 kernel: [8794161.252524]  [<ffffffff8133a4a0>] ? 
gs_change+0x13/0x13
...

The full error message is in here: http://dump.fangornsrealm.eu/error.txt

The scenario I have identified is as this:
- The fileserver is synched against it's mirror server with rscync to 
rsync daemon.
- The memory fills up with caches (inode cache, xfs cache)
- after the sync the memory manager frees the slab memory.
- this is when the hang happens.

At least this is what I have made out of the evidence that I have. Some 
sync scripts
also do delete whole trees of directories with hundreds of thousands of 
hard links.
I have found messages that this workload can produce problems.
But the hangs happen also during the day, when none of these scripts are 
running.


Here is the significant part of the atop log: 
http://dump.fangornsrealm.eu/atop.txt

The machine is a server under Debian Squeeze. The problem is the same 
under the
debian standard kernels.
squeeze:           linux-image-2.6.32-5-amd64
squeeze-backports: linux-image-2.6.39-bpo.2-amd64

Some system information:
http://dump.fangornsrealm.eu/system_info.txt
http://dump.fangornsrealm.eu/modules_lin71.txt
http://dump.fangornsrealm.eu/psaux_lin71.txt


As already written, the sync process works flawless for many days, even 
weeks.
The problem is, that I cannot just reboot this machine whenever I want. 
The whole
department worldwide is dependent on this machine. I know the memory is 
a little
small for filesystems this big. But I don't think that more memory would 
solve
this degradation over time.

Alexander Schwarzkopf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
