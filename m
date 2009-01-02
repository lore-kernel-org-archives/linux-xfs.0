Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n022kSuH017974 for <xfs@oss.sgi.com>; Thu, 1 Jan 2009 20:46:29 -0600
Received: from ti-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B844158C5C
	for <xfs@oss.sgi.com>; Thu,  1 Jan 2009 18:46:26 -0800 (PST)
Received: from ti-out-0910.google.com (ti-out-0910.google.com
	[209.85.142.189]) by cuda.sgi.com with ESMTP id
	sAK6aEeJKxZD2oEj for <xfs@oss.sgi.com>;
	Thu, 01 Jan 2009 18:46:26 -0800 (PST)
Received: by ti-out-0910.google.com with SMTP id y6so5391609tia.18
	for <xfs@oss.sgi.com>; Thu, 01 Jan 2009 18:46:24 -0800 (PST)
Message-ID: <169670ec0901011846q1d370e6cu31514519afc8295d@mail.gmail.com>
Date: Fri, 2 Jan 2009 11:46:23 +0900
From: "Thomas Gutzler" <thomas.gutzler@gmail.com>
Subject: Corruption of in-memory data detected
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Hi,

I've been running an 8x500G hardware SATA RAID5 on an adaptec 31605
controller for a while. The operating system is ubuntu feisty with the
2.6.22-16-server kernel. Recently, I added a disk. After the array
rebuild was completed, I kept getting errors from the xfs module such
as this one:
Dec 30 22:55:39 io kernel: [21844.939832] Filesystem "sda":
xfs_iflush: Bad inode 1610669723 magic number 0xec9d, ptr 0xe523eb00
Dec 30 22:55:39 io kernel: [21844.939879] xfs_force_shutdown(sda,0x8)
called from line 3277 of file
/build/buildd/linux-source-2.6.22-2.6.22/fs/xfs/xfs_inode.c.  Return
address = 0xf8af263c
Dec 30 22:55:39 io kernel: [21844.939885] Filesystem "sda": Corruption
of in-memory data detected.  Shutting down filesystem: sda

My first thought was to run memcheck on the machine, which completed
several passes without error; the raid controller doesn't report any
SMART failures either.

After an xfs_repair, which fixed a few things, I mounted the file
system but the error kept reappearing after a few hours unless I
mounted read-only. Since xfs_ncheck -i always exited with 'Out of
memory' I decided to reduce the max amount of inodes to 1% (156237488)
by running xfs_growfs -m 1 - the total amount of inodes used is still
less than 1%. Unfortunately, both xfs_check and xfs_ncheck still say
'out of memory' with 2GB installed.
.
After the modification, the file system survived for a day until the
following happened:
Jan  2 09:33:29 io kernel: [232751.699812] BUG: unable to handle
kernel paging request at virtual address 0003fffb
Jan  2 09:33:29 io kernel: [232751.699848]  printing eip:
Jan  2 09:33:29 io kernel: [232751.699863] c017d872
Jan  2 09:33:29 io kernel: [232751.699865] *pdpt = 000000003711e001
Jan  2 09:33:29 io kernel: [232751.699881] *pde = 0000000000000000
Jan  2 09:33:29 io kernel: [232751.699898] Oops: 0002 [#1]
Jan  2 09:33:29 io kernel: [232751.699913] SMP
Jan  2 09:33:29 io kernel: [232751.699931] Modules linked in: nfs nfsd
exportfs lockd sunrpc xt_tcpudp nf_conntrack_ipv4 xt_state
nf_conntrack nfnetlink iptable_filter ip_tables x_tables ipv6 ext2
mbcache coretemp w83627ehf i2c_isa i2c_core acpi_cpufreq
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand
freq_table cpufreq_conservative psmouse serio_raw pcspkr shpchp
pci_hotplug evdev intel_agp agpgart xfs sr_mod cdrom pata_jmicron
ata_piix sg sd_mod ata_generic ohci1394 ieee1394 ahci libata e1000
aacraid scsi_mod uhci_hcd ehci_hcd usbcore thermal processor fan fuse
apparmor commoncap
Jan  2 09:33:29 io kernel: [232751.700180] CPU:    1
Jan  2 09:33:29 io kernel: [232751.700181] EIP:
0060:[__slab_free+50/672]    Not tainted VLI
Jan  2 09:33:29 io kernel: [232751.700182] EFLAGS: 00010046
(2.6.22-16-server #1)
Jan  2 09:33:29 io kernel: [232751.700234] EIP is at __slab_free+0x32/0x2a0
Jan  2 09:33:29 io kernel: [232751.700252] eax: 0000ffff   ebx:
ffffffff   ecx: ffffffff   edx: 000014aa
Jan  2 09:33:29 io kernel: [232751.700273] esi: c17fffe0   edi:
e6b8e0c0   ebp: f8ac2c8c   esp: c21dfe44
Jan  2 09:33:29 io kernel: [232751.700293] ds: 007b   es: 007b   fs:
00d8  gs: 0000  ss: 0068
Jan  2 09:33:29 io kernel: [232751.700313] Process kswapd0 (pid: 198,
ti=c21de000 task=c21f39f0 task.ti=c21de000)
Jan  2 09:33:29 io kernel: [232751.700334] Stack: 00000000 00000065
00000000 fffffffe ffffffff c17fffe0 00000287 e6b8e0c0
Jan  2 09:33:29 io kernel: [232751.700378]        00000001 c017e3fe
f8ac2c8c cecb7d20 00000001 df2e2600 f8ac2c8c df2e2600
Jan  2 09:33:29 io kernel: [232751.700422]        f8d7559c e8247900
f8ac5224 df2e2600 f8d7559c e8247900 f8ae1606 00000001
Jan  2 09:33:29 io kernel: [232751.700466] Call Trace:
Jan  2 09:33:29 io kernel: [232751.700499]  [kfree+126/192] kfree+0x7e/0xc0
Jan  2 09:33:29 io kernel: [232751.700519]  [<f8ac2c8c>]
xfs_idestroy_fork+0x2c/0xf0 [xfs]
Jan  2 09:33:29 io kernel: [232751.700561]  [<f8ac2c8c>]
xfs_idestroy_fork+0x2c/0xf0 [xfs]
Jan  2 09:33:29 io kernel: [232751.700601]  [<f8ac5224>]
xfs_idestroy+0x44/0xb0 [xfs]
Jan  2 09:33:29 io kernel: [232751.700640]  [<f8ae1606>]
xfs_finish_reclaim+0x36/0x160 [xfs]
Jan  2 09:33:29 io kernel: [232751.700681]  [<f8af1c47>]
xfs_fs_clear_inode+0x97/0xc0 [xfs]
Jan  2 09:33:29 io kernel: [232751.700721]  [clear_inode+143/320]
clear_inode+0x8f/0x140
Jan  2 09:33:29 io kernel: [232751.700743]  [dispose_list+26/224]
dispose_list+0x1a/0xe0
Jan  2 09:33:29 io kernel: [232751.700765]
[shrink_icache_memory+379/592] shrink_icache_memory+0x17b/0x250
Jan  2 09:33:29 io kernel: [232751.700789]  [shrink_slab+279/368]
shrink_slab+0x117/0x170
Jan  2 09:33:29 io kernel: [232751.700815]  [kswapd+859/1136] kswapd+0x35b/0x470
Jan  2 09:33:29 io kernel: [232751.700842]
[autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Jan  2 09:33:29 io kernel: [232751.700867]  [kswapd+0/1136] kswapd+0x0/0x470
Jan  2 09:33:29 io kernel: [232751.700886]  [kthread+66/112] kthread+0x42/0x70
Jan  2 09:33:29 io kernel: [232751.700904]  [kthread+0/112] kthread+0x0/0x70
Jan  2 09:33:29 io kernel: [232751.700923]
[kernel_thread_helper+7/28] kernel_thread_helper+0x7/0x1c
Jan  2 09:33:29 io kernel: [232751.700946]  =======================
Jan  2 09:33:29 io kernel: [232751.700962] Code: 53 89 cb 83 ec 14 8b
6c 24 28 f0 0f ba 2e 00 19 c0 85 c0 74 0a 8b 06 a8 01 74 ef f3 90 eb
f6 f6 06 02 75 48 0f b7 46 0a 8b 56 14 <89> 14 83 0f b7 46 08 89 5e 14
83 e8 01 f6 06 40 66 89 46 08 75
Jan  2 09:33:29 io kernel: [232751.701128] EIP: [__slab_free+50/672]
__slab_free+0x32/0x2a0 SS:ESP 0068:c21dfe44

Any thoughts what this could be or what could be done to fix it?

Cheers,
  Tom

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
