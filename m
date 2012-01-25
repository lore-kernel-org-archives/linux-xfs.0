Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0P5ZDu8169321
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jan 2012 23:35:14 -0600
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id aMY3mm7PO1QYN62X for <linux-xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 21:35:11 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1RpvVk-0001lZ-7P
	for linux-xfs@oss.sgi.com; Wed, 25 Jan 2012 06:35:08 +0100
Received: from wombat.san-francisco.ca.us ([75.101.60.64])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 25 Jan 2012 06:35:08 +0100
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Wed, 25 Jan 2012 06:35:08 +0100
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: help with deciphering kernel dmesg
Date: Tue, 24 Jan 2012 21:24:26 -0800
Message-ID: <a9g4v8xkfp.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

Hello all,

I had a strange issue with my largish XFS filesystem, and was hoping to
get some help figuring out what it could mean.

Background: this is a ~14TB XFS filesystem on top of a linux LVM md
RAID6 of 9 2TB disks.  In the past, I've had no problems working with this,
but I recently added a disk to reshape to 10 disks.  During an
rsnapshot, I got the below messages in dmesg, and when I went to umount
the fs to do an xfs_repair -n, it claimed that the filesystem was busy,
even though lsof didn't show any files open on the filesystem.

The last time I did an mdraid reshape, the kernel did a hard crash on a
small amount of disk activity, and at that time the kernel messages
seemed to point to an issue in the mdraid module.  But I wasn't able to
save the messages, so I'm not sure whether the messages were a trace 
from the mdraid module or the xfs module.

The kernel is the latest from ELrepo (2.6.39-4.el5.elrepo).  I am
currently running xfs_repair -n, which hasn't yet found any errors.
(Since the fs isn't mounted I can't yet give xfs_info output, and
because the RAID6 is still reshaping the xfs_repair is taking a long
time.  I can interrupt it if needed, but I'm hoping to let it finish.)
In the past the RAID6 has passed a check, but I have not done one this
month.  I hope I have munged any identifying information.

Thanks for any suggestions; my dmesg output snippet is below.  A
cursory web search on the keywords in the first line of the dmesg output
didn't turn up anything terribly interesting.  One I found suggested
ACLs or SELinux issues, but my system isn't using those AFAIK (at least
it shouldn't be).

--keith

Jan 23 23:09:37 XXXXX kernel: XFS (dm-5): I/O error occurred: meta-data dev dm-5 block 0x57786050       ("xfs_trans_read_buf") error 5 buf count 4096
Jan 23 23:10:01 XXXXX kernel: XFS (dm-5): I/O error occurred: meta-data dev dm-5 block 0x5778dff8       ("xfs_trans_read_buf") error 5 buf count 4096
Jan 23 23:10:05 XXXXX kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
Jan 23 23:10:05 XXXXX kernel: IP: [<ffffffffa0435ed2>] xfs_da_do_buf+0x43e/0x592 [xfs]
Jan 23 23:10:05 XXXXX kernel: PGD f3b7d067 PUD eaf19067 PMD 0 
Jan 23 23:10:05 XXXXX kernel: Oops: 0000 [#1] PREEMPT SMP 
Jan 23 23:10:05 XXXXX kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:0b.0/0000:01:03.0/local_cpus
Jan 23 23:10:05 XXXXX kernel: CPU 1 
Jan 23 23:10:05 XXXXX kernel: Modules linked in: xfs raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx netconsole autofs4 nfs fscache auth_rp
cgss nfs_acl lockd sunrpc binfmt_misc dm_multipath scsi_dh video sbs sbshc power_meter pci_slot hed battery acpi_memhotplug acpi_ipmi ipmi_msghandler ac lp st osst ch sg sr_
mod cdrom e100 mii tg3 serio_raw button i2c_amd756 parport_pc parport tpm_tis tpm i2c_amd8111 tpm_bios rtc_cmos i2c_core k8temp shpchp floppy amd64_edac_mod pcspkr pci_hotpl
ug hwmon edac_core amd_rng dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod 3w_9xxx aic79xx scsi_transport_spi pata_amd pata_acpi ata_generic libata sd_mod scsi_mo
d ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: netconsole]
Jan 23 23:10:05 XXXXX kernel: 
Jan 23 23:10:05 XXXXX kernel: Pid: 9308, comm: rsync Not tainted 2.6.39-4.el5.elrepo #1 To Be Filled By O.E.M. To Be Filled By O.E.M./TYAN High-End Dual AMD Opteron, S2882
Jan 23 23:10:05 XXXXX kernel: RIP: 0010:[<ffffffffa0435ed2>]  [<ffffffffa0435ed2>] xfs_da_do_buf+0x43e/0x592 [xfs]
Jan 23 23:10:05 XXXXX kernel: RSP: 0018:ffff8800ead4fcb8  EFLAGS: 00010246
Jan 23 23:10:05 XXXXX kernel: RAX: 0000000000000000 RBX: ffff8800ead4fd38 RCX: 0000000000000002
Jan 23 23:10:05 XXXXX kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jan 23 23:10:05 XXXXX kernel: RBP: ffff8800ead4fd88 R08: 0000000000000001 R09: 0000000000000202
Jan 23 23:10:05 XXXXX kernel: R10: ffff8800ead4fc18 R11: ffff8800f39b80f8 R12: 0000000000000000
Jan 23 23:10:05 XXXXX kernel: R13: 0000000000000000 R14: ffff8800f3a8a800 R15: 0000000000000000
Jan 23 23:10:05 XXXXX rsnapshot[9316]: /usr/bin/rsnapshot sync: ERROR: /usr/bin/rsync returned 12 while processing /mnt/YYYYYYYY
Jan 23 23:10:05 XXXXX kernel: FS:  00007f4f1be006e0(0000) GS:ffff8800f7c00000(0000) knlGS:0000000000000000
Jan 23 23:10:05 XXXXX kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 23 23:10:05 XXXXX kernel: CR2: 0000000000000008 CR3: 00000000f2f77000 CR4: 00000000000006e0
Jan 23 23:10:05 XXXXX kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 23 23:10:05 XXXXX kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 23 23:10:05 XXXXX kernel: Process rsync (pid: 9308, threadinfo ffff8800ead4e000, task ffff8800f39b80c0)
Jan 23 23:10:05 XXXXX kernel: Stack:
Jan 23 23:10:05 XXXXX kernel:  ffff8800ead4fd48 ffffffffa0464fd7 ffff8800ead4fcd8 ffffffff8107ec2b
Jan 23 23:10:05 XXXXX kernel:  ffff8800ead4fce8 00000000813c5ae6 ffff8800ead4fe50 ffff8800ead4fdb0
Jan 23 23:10:05 XXXXX kernel:  ffff88002b926400 0000000000000000 ffff8800ead4fd18 0000000100000000
Jan 23 23:10:05 XXXXX kernel: Call Trace:
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa0464fd7>] ? spin_unlock+0xe/0x10 [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff8107ec2b>] ? __raw_spin_unlock+0x29/0x34
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa045d64d>] ? xfs_buf_relse+0x1e/0x22 [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa0436098>] xfs_da_read_buf+0x2a/0x2c [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa043cbf3>] ? xfs_dir2_leaf_getdents+0x372/0x637 [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa043cbf3>] xfs_dir2_leaf_getdents+0x372/0x637 [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff8113a83c>] ? sys_old_readdir+0x63/0x63
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff8113a83c>] ? sys_old_readdir+0x63/0x63
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa0437f0e>] xfs_readdir+0xb5/0xc8 [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff811b0fbf>] ? fsnotify_perm+0x70/0x7c
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff8113a83c>] ? sys_old_readdir+0x63/0x63
Jan 23 23:10:05 XXXXX kernel:  [<ffffffffa0468856>] xfs_file_readdir+0x3f/0x4e [xfs]
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff8113a6e9>] vfs_readdir+0x78/0x9f
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff8113a78f>] sys_getdents+0x7f/0xc9
Jan 23 23:10:05 XXXXX kernel:  [<ffffffff813cb802>] system_call_fastpath+0x16/0x1b
Jan 23 23:10:05 XXXXX kernel: Code: eb 17 45 31 ed 48 83 7d c0 00 74 15 48 8b 55 18 48 8d 75 c0 bf 01 00 00 00 e8 d1 ef ff ff 49 89 c5 83 7d 10 01 0f 85 a3 00 00 00 
Jan 23 23:10:05 XXXXX kernel: <49> 8b 5d 08 0f b7 7b 08 e8 15 ea ff ff 0f b7 c0 8b 13 0f ca 3d 
Jan 23 23:10:05 XXXXX kernel: RIP  [<ffffffffa0435ed2>] xfs_da_do_buf+0x43e/0x592 [xfs]
Jan 23 23:10:05 XXXXX kernel:  RSP <ffff8800ead4fcb8>
Jan 23 23:10:05 XXXXX kernel: CR2: 0000000000000008
Jan 23 23:10:05 XXXXX kernel: ---[ end trace b5fbfad2fe7e2837 ]---



-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
