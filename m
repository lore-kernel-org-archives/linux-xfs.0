Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2B4Uu58248825 for <xfs@oss.sgi.com>; Tue, 10 Mar 2009 23:31:17 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F4B01C320C3
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2009 21:30:11 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id pFmBQb4rpv5AelPx for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2009 21:30:11 -0700 (PDT)
Message-ID: <49B73E50.5080906@sandeen.net>
Date: Tue, 10 Mar 2009 23:30:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corruption of in-memory data detected
References: <169670ec0901011846q1d370e6cu31514519afc8295d@mail.gmail.com>	
	<495D88EE.2040406@sandeen.net>
	<169670ec0903101944i2ea05432q7bf9776a347a11a5@mail.gmail.com>
In-Reply-To: <169670ec0903101944i2ea05432q7bf9776a347a11a5@mail.gmail.com>
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
To: Thomas Gutzler <thomas.gutzler@gmail.com>
Cc: xfs@oss.sgi.com

Thomas Gutzler wrote:
> Hi,
> 
> a while ago I was having problems with the xfs module on ubuntu
> feisty. I have then upgraded to 8.10 intrepid and am still getting the
> occasional bug. 

although from the looks of it, a different one.  I'm curious, if you log
these bug with Ubuntu, do they look into it?  It'd be nice to at least
have initial triage to know for example where in the function it blew up.

> Good thing is that now the system keeps running after
> the bug occurs with load slowly increasing as random processes are
> affected by this turn into zombies.

...

>>> Jan  2 09:33:29 io kernel: [232751.701128] EIP: [__slab_free+50/672]
>>> __slab_free+0x32/0x2a0 SS:ESP 0068:c21dfe44

... last error was slab corruption perhaps

>>> Any thoughts what this could be or what could be done to fix it?
>> seems like maybe something went wrong w/ the raid rebuild, if that's
>> when things started going south.  Do you get any storage error related
>> messages at all?
> 
> I couldn't find any errors other than the dump in dmesg (see below).
> I also called adaptec and they said they never had memory failure in
> they raid cards.
> 
>> Ubuntu knows best what's in this oldish distro kernel, I guess; I don't
>> know offhand what might be going wrong.  If they have a debug kernel
>> variant, you could run that to see if you get earlier indications of
>> problems.
>>
>> If you can reproduce on a more recent upstream kernel, that would be
>> interesting.
> 
> Here's the dmesg output:
> [1369713.678092] BUG: unable to handle kernel paging request at ffff87f947da5088
> [1369713.682882] IP: [<ffffffffa01db24f>]
> xfs_dir2_block_lookup_int+0xcf/0x210 [xfs]

Ok, so this looks like a different problem; at least a different oops.

> [1369713.687802] PGD 0
> [1369713.688055] Oops: 0000 [1] SMP
> [1369713.688055] CPU 1
> [1369713.688055] Modules linked in: nls_cp437 cifs nfsd auth_rpcgss
> exportfs wmi video output sbs sbshc pci
> _slot container battery ac xt_tcpudp nf_conntrack_ipv4 xt_state
> nf_conntrack nfs lockd nfs_acl sunrpc ipv6
> iptable_filter ip_tables x_tables ext3 jbd mbcache cpufreq_userspace
> cpufreq_stats cpufreq_powersave cpufre
> q_ondemand cpufreq_conservative acpi_cpufreq freq_table sbp2
> parport_pc lp parport loop evdev pcspkr iTCO_w
> dt iTCO_vendor_support button shpchp pci_hotplug intel_agp xfs
> pata_jmicron sd_mod crc_t10dif sg pata_acpi
> ata_piix ohci1394 ieee1394 aacraid ata_generic ahci libata scsi_mod
> e1000e dock uhci_hcd ehci_hcd usbcore t
> hermal processor fan fuse vesafb fbcon tileblit font bitblit softcursor
> [1369713.688055] Pid: 5278, comm: smbd Not tainted 2.6.27-11-server #1
> [1369713.688055] RIP: 0010:[<ffffffffa01db24f>]  [<ffffffffa01db24f>]
> xfs_dir2_block_lookup_int+0xcf/0x210
> [xfs]
> [1369713.688055] RSP: 0018:ffff88007120ba28  EFLAGS: 00010286
> [1369713.688055] RAX: 00000005a072ded8 RBX: 00000000da072ded RCX:
> 0000000000000000
> [1369713.688055] RDX: 00000000b40e5bda RSI: ffff88007a474c48 RDI:
> ffffffffda072ded
> [1369713.688055] RBP: ffff88007120ba98 R08: ffff87fa77a0e120 R09:
> 00000000ffffffff
> [1369713.688055] R10: 00000000db5b0eb4 R11: ffff88001813bff8 R12:
> ffff88007120bae8
> [1369713.688055] R13: 000000000000002a R14: 0000000000000000 R15:
> ffff88007120bb74
> [1369713.688055] FS:  00007f79bf44e700(0000) GS:ffff88007f802880(0000)
> knlGS:0000000000000000
> [1369713.688055] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [1369713.688055] CR2: ffff87f947da5088 CR3: 0000000053e88000 CR4:
> 00000000000006e0
> [1369713.688055] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [1369713.688055] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [1369713.688055] Process smbd (pid: 5278, threadinfo ffff88007120a000,
> task ffff88000350ace0)
> [1369713.688055] Stack:  ffff88007120bd68 ffffffff802fa04c
> ffff88007120bab4 ffff88007120baa8
> [1369713.688055]  ffff88001813b000 ffff88007acb3000 0000000000000000
> ffffffffa01d0289
> [1369713.688055]  ffff88007a474c48 ffff880035a2c8c0 ffff88007120bae8
> ffff88007120bae8
> [1369713.688055] Call Trace:
> [1369713.688055]  [<ffffffff802fa04c>] ? do_select+0x5bc/0x610
> [1369713.688055]  [<ffffffffa01d0289>] ? xfs_bmbt_get_blockcount+0x9/0x20 [xfs]
> [1369713.688055]  [<ffffffffa01db470>] xfs_dir2_block_lookup+0x20/0xc0 [xfs]
> [1369713.688055]  [<ffffffffa01da7e5>] xfs_dir_lookup+0x195/0x1c0 [xfs]
> [1369713.688055]  [<ffffffffa020a6cb>] xfs_lookup+0x7b/0xe0 [xfs]
> [1369713.688055]  [<ffffffff802ff9f6>] ? __d_lookup+0x16/0x150
> [1369713.688055]  [<ffffffffa02159a1>] xfs_vn_lookup+0x51/0x90 [xfs]
> [1369713.688055]  [<ffffffff802f495e>] real_lookup+0xee/0x170
> [1369713.688055]  [<ffffffff802f4a90>] do_lookup+0xb0/0x110
> [1369713.688055]  [<ffffffff802f50fd>] __link_path_walk+0x60d/0xc20
> [1369713.688055]  [<ffffffff80305ef6>] ? mntput_no_expire+0x36/0x160
> [1369713.688055]  [<ffffffff802f5c4e>] path_walk+0x6e/0xe0
> [1369713.688055]  [<ffffffff802f5e63>] do_path_lookup+0xe3/0x200
> [1369713.688055]  [<ffffffff802f386a>] ? getname+0x4a/0xb0
> [1369713.688055]  [<ffffffff802f6cbb>] user_path_at+0x7b/0xb0
> [1369713.688055]  [<ffffffff802eda68>] ? cp_new_stat+0xe8/0x100
> [1369713.688055]  [<ffffffff802ede7d>] vfs_stat_fd+0x2d/0x60
> [1369713.688055]  [<ffffffff802edf5c>] sys_newstat+0x2c/0x50
> [1369713.688055]  [<ffffffff8021285a>] system_call_fastpath+0x16/0x1b
> [1369713.688055]
> [1369713.688055]
> [1369713.688055] Code: f8 31 c9 45 8b 13 4d 89 d8 44 89 d2 0f ca 89 d0
> 83 ea 01 48 c1 e0 03 49 29 c0 eb 07 8d 4b 01 39 ca 7c 1c 8d 1c 11 d1
> fb 48 63 fb <41> 8b 04 f8 0f c8 41 39 c5 74 26 77 e4 8d 53 ff 39 ca 7d
> e4 48
> [1369713.688055] RIP  [<ffffffffa01db24f>]
> xfs_dir2_block_lookup_int+0xcf/0x210 [xfs]
> [1369713.688055]  RSP <ffff88007120ba28>
> [1369713.688055] CR2: ffff87f947da5088
> [1369714.057232] ---[ end trace 0735c8702d5e7899 ]---
> 
> What can I do to help getting this fixed?
> 
> Tom

can you make an xfs_metadump of the filesystem in question, and then try
an xfs_repair?  Capture/save the repair output.  If repair finds errors,
then perhaps the bug is triggered by bad error checking on a corrupted
image, and we might reproduce it w/ the metadump image.

It'd be nice if ubuntu had debug kernel variants (Fedora does this, I
dunno about ubuntu) - if you are hitting any kind of memory corruption
then a kernel with debug checks enabled might catch it sooner.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
