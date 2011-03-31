Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2VEFkXJ149061 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 09:15:46 -0500
Received: from eyas.biff.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 020EA392C63
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 07:18:57 -0700 (PDT)
Received: from eyas.biff.org.uk (eyas.biff.org.uk [80.68.92.121]) by
	cuda.sgi.com with ESMTP id KFGMDvAfGKxcjanW for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 07:18:57 -0700 (PDT)
Received: from cpc1-cmbg12-0-0-cust836.5-4.cable.virginmedia.com
	([86.9.119.69]:1618 helo=thekelleys.org.uk)
	by eyas.biff.org.uk with esmtpa (Exim 4.72)
	(envelope-from <simon@thekelleys.org.uk>) id 1Q5Ii8-0006Vq-32
	for xfs@oss.sgi.com; Thu, 31 Mar 2011 15:18:56 +0100
Received: from spike.thekelleys.org.uk ([192.168.0.193] helo=thekelleys.org.uk)
	by thekelleys.org.uk with asmtp (Exim 3.36 #1 (Debian))
	id 1Q5Ii7-0008Bn-00
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 15:18:55 +0100
Subject: XFS stack overflow?
Date: Thu, 31 Mar 2011 15:18:55 +0100
Message-Id: <1301581135.748149.10230.nullmailer@thekelleys.org.uk>
From: <simon@thekelleys.org.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I have a set of machines which each act solely as an 
NFS server exporting a single 60Tb XFS filesystem. These machines have
suffered from infrequent mysterious crashes since new, but recently a 
new workload has upped the frequency from monthly to less than a day, 
enabling me to chase the problem harder. Below is a log, captured by 
netconsole as the machine was going down hard. I think the crucial line 
is:

[93662.200355] Thread overran stack, or stack corrupted.

Based on that I compiled up a kernel patched to set THREAD_ORDER in  
arch/x86/include/asm/page_64_types.h to 2 (ie 16k kernel stacks.)
A machine running that kernel has been sat at load average 130 
(128 nfsd threads) for 60 hours now and not seen any problems, without 
the patch the same load would bring it down in less than a day.

I'm fairly convinced that I've fixed my problem, but I guess it's 
worth posting here as the call trace might enable the devs to find and 
fix the stack hogs. (And then I won't have to run patched kernels 
in the future.)

More information that might help.

x86_64
Storage is fibrechannel attached and the filesystem is hosted on a 
LVM block device that concatentates four partitions, so the block access
is going via a stack of LVM, multipath and Q-logic drivers.
Network is Intel 10G ethernet (gxbe driver)
Kernel is 2.6.32 with Debian patches. (both kernels)

Any other information needed, just let me know.

Cheers,

Simon.


 [93662.195788] BUG: scheduling while atomic: nfsd/3686/0xffff8800
 [93662.195842] Modules linked in:
 ioatdma
 netconsole
 configfs
 cpufreq_userspace
 cpufreq_stats
 cpufreq_powersave
 cpufreq_conservative
 8021q
 garp
 stp
 nfsd
 nfs
 lockd
 fscache
 nfs_acl
 auth_rpcgss
 sunrpc
 ext3
 jbd
 mbcache
 fuse
 dm_round_robin
 dm_multipath
 scsi_dh
 autofs4
 ohci_hcd
 sd_mod
 crc_t10dif
 usbhid
 hid
 snd_pcm_oss
 snd_mixer_oss
 snd_pcm
 snd_timer
 snd
 ipmi_si
 ixgbe
 soundcore
 psmouse
 ipmi_msghandler
 ehci_hcd
 dca
 snd_page_alloc
 uhci_hcd
 hpilo
 evdev
 serio_raw
 container
 mdio
 bnx2
 usbcore
 pcspkr
 nls_base
 power_meter
 qla2xxx
 scsi_transport_fc
 scsi_tgt
 processor
 button
 xfs
 exportfs
 dm_mirror
 dm_region_hash
 dm_log
 dm_snapshot
 dm_mod
 thermal
 fan
 thermal_sys
 cciss
 scsi_mod
 
 [93662.196418] Pid: 3686, comm: nfsd Not tainted 2.6.32-bpo.5-amd64 #1
 [93662.196758] Call Trace:
 [93662.196799] [<ffffffff812fa0a9>] ? schedule+0xce/0x7da
 [93662.196837] [<ffffffff81176ae4>] ? elv_insert+0xad/0x260
 [93662.196871] [<ffffffff812fabeb>] ? schedule_timeout+0x2e/0xdd
 [93662.196915] [<ffffffffa0058af7>] ? dm_unplug_all+0x3b/0x4c [dm_mod]
 [93662.196953] [<ffffffff812fb4cf>] ? __down_common+0x8d/0xde
 [93662.196992] [<ffffffff81068533>] ? down+0x27/0x38
 [93662.197053] [<ffffffffa00e2f58>] ? _xfs_buf_find+0x162/0x1e0 [xfs]
 [93662.197107] [<ffffffffa00e3030>] ? xfs_buf_get_flags+0x5a/0x13b [xfs]
 [93662.197162] [<ffffffffa00e3123>] ? xfs_buf_read_flags+0x12/0x7a [xfs]
 [93662.197220] [<ffffffffa00da819>] ? xfs_trans_read_buf+0x189/0x27e [xfs]
 [93662.197272] [<ffffffffa00a1c09>] ? xfs_read_agf+0x5a/0x149 [xfs]
 [93662.197322] [<ffffffffa00a1d1a>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
 [93662.197374] [<ffffffffa00a38cf>] ? xfs_alloc_fix_freelist+0x11b/0x3dd [xfs]
 [93662.197427] [<ffffffffa00a3d57>] ? xfs_alloc_vextent+0x10e/0x3e3 [xfs]
 [93662.197479] [<ffffffffa00aea39>] ? xfs_bmap_btalloc+0x54f/0x732 [xfs]
 [93662.197537] [<ffffffffa00b0f4f>] ? xfs_bmapi+0x876/0x104d [xfs]
 [93662.197594] [<ffffffffa00c6e67>] ? xfs_iext_get_ext+0x34/0x5a [xfs]
 [93662.197652] [<ffffffffa00cbf3d>] ? xfs_iomap_write_allocate+0x245/0x387 [xfs]
 [93662.197725] [<ffffffffa00cc9b2>] ? xfs_iomap+0x213/0x285 [xfs]
 [93662.197763] [<ffffffff8119b5e8>] ? swiotlb_map_sg_attrs+0xeb/0x107
 [93662.197817] [<ffffffffa00e012c>] ? xfs_map_blocks+0x25/0x2c [xfs]
 [93662.197855] [<ffffffff81191960>] ? radix_tree_delete+0xbf/0x1ba
 [93662.197908] [<ffffffffa00e0d53>] ? xfs_page_state_convert+0x299/0x565 [xfs]
 [93662.197950] [<ffffffffa005a3bb>] ? dm_table_any_congested+0x66/0xe6 [dm_mod]
 [93662.198010] [<ffffffffa00e10b7>] ? xfs_vm_releasepage+0x98/0xa5 [xfs]
 [93662.198065] [<ffffffffa00e129a>] ? xfs_vm_writepage+0xb0/0xe6 [xfs]
 [93662.198105] [<ffffffff810bdfd5>] ? shrink_page_list+0x375/0x623
 [93662.198140] [<ffffffff810be9b8>] ? shrink_list+0x45c/0x767
 [93662.198192] [<ffffffffa00b5249>] ? xfs_btree_lookup_get_block+0x9d/0xac [xfs]
 [93662.198262] [<ffffffffa00b275f>] ? xfs_bmbt_init_key_from_rec+0xc/0x14 [xfs]
 [93662.198314] [<ffffffffa00b2e1c>] ? xfs_lookup_get_search_key+0x29/0x3c [xfs]
 [93662.198349] [<ffffffff810bef43>] ? shrink_zone+0x280/0x342
 [93662.198381] [<ffffffff810c000a>] ? try_to_free_pages+0x232/0x38e
 [93662.198413] [<ffffffff810bcfff>] ? isolate_pages_global+0x0/0x20f
 [93662.198450] [<ffffffff810ba098>] ? __alloc_pages_nodemask+0x3cd/0x5f5
 [93662.198486] [<ffffffff810e6535>] ? new_slab+0x42/0x1ca
 [93662.198516] [<ffffffff810e68ad>] ? __slab_alloc+0x1f0/0x39b
 [93662.198560] [<ffffffffa00df806>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
 [93662.198605] [<ffffffffa00df806>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
 [93662.198637] [<ffffffff810e6d88>] ? kmem_cache_alloc+0x7f/0xf0
 [93662.198697] [<ffffffffa00df806>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
 [93662.198746] [<ffffffffa00df85a>] ? kmem_zone_zalloc+0xe/0x2e [xfs]
 [93662.198792] [<ffffffffa00d9979>] ? _xfs_trans_alloc+0x29/0x64 [xfs]
 [93662.198842] [<ffffffffa00d9bb4>] ? xfs_trans_alloc+0x95/0xa1 [xfs]
 [93662.198888] [<ffffffffa00d9d57>] ? xfs_trans_unlocked_item+0x20/0x3a [xfs]
 [93662.198931] [<ffffffffa009ab39>] ? xfs_qm_dqattach+0x32/0x3b [xfs]
 [93662.198978] [<ffffffffa00cbdab>] ? xfs_iomap_write_allocate+0xb3/0x387 [xfs]
 [93662.199031] [<ffffffffa00cc9b2>] ? xfs_iomap+0x213/0x285 [xfs]
 [93662.199076] [<ffffffffa00e012c>] ? xfs_map_blocks+0x25/0x2c [xfs]
 [93662.199122] [<ffffffffa00cca0f>] ? xfs_iomap+0x270/0x285 [xfs]
 [93662.199169] [<ffffffffa00e0d53>] ? xfs_page_state_convert+0x299/0x565 [xfs]
 [93662.199218] [<ffffffffa00e129a>] ? xfs_vm_writepage+0xb0/0xe6 [xfs]
 [93662.199251] [<ffffffff810ba2ca>] ? __writepage+0xa/0x25
 [93662.199283] [<ffffffff810ba951>] ? write_cache_pages+0x20b/0x327
 [93662.199314] [<ffffffff810ba2c0>] ? __writepage+0x0/0x25
 [93662.199347] [<ffffffff810b4925>] ? __filemap_fdatawrite_range+0x4b/0x54
 [93662.199381] [<ffffffff810b4954>] ? filemap_write_and_wait_range+0x26/0x52
 [93662.199426] [<ffffffffa00e6d82>] ? xfs_write+0x63b/0x6ea [xfs]
 [93662.199458] [<ffffffff812fb3f5>] ? down_read+0x9/0x19
 [93662.199503] [<ffffffffa00c6c36>] ? xfs_iget+0x401/0x45b [xfs]
 [93662.199550] [<ffffffffa00e36ad>] ? xfs_file_aio_write+0x0/0x5d [xfs]
 [93662.199584] [<ffffffff810ee511>] ? do_sync_readv_writev+0xc0/0x107
 [93662.199630] [<ffffffffa00d9d57>] ? xfs_trans_unlocked_item+0x20/0x3a [xfs]
 [93662.199666] [<ffffffff81064d16>] ? autoremove_wake_function+0x0/0x2e
 [93662.199698] [<ffffffff810ee39d>] ? rw_copy_check_uvector+0x6d/0xe4
 [93662.199733] [<ffffffff810eebad>] ? do_readv_writev+0xb2/0x115
 [93662.199788] [<ffffffffa0387f5c>] ? nfsd_setuser_and_check_port+0x62/0x7c [nfsd]
 [93662.199843] [<ffffffffa038987d>] ? nfsd_vfs_write+0x11a/0x329 [nfsd]
 [93662.199880] [<ffffffffa038a022>] ? nfsd_open+0x137/0x16c [nfsd]
 [93662.199915] [<ffffffffa038a34b>] ? nfsd_write+0xc5/0xe2 [nfsd]
 [93662.199952] [<ffffffffa0390784>] ? nfsd3_proc_write+0xc7/0xe5 [nfsd]
 [93662.199987] [<ffffffffa0385329>] ? nfsd_dispatch+0xdd/0x1b9 [nfsd]
 [93662.200027] [<ffffffffa02c2513>] ? svc_process+0x403/0x627 [sunrpc]
 [93662.200067] [<ffffffffa0385772>] ? nfsd+0x0/0x12e [nfsd]
 [93662.200100] [<ffffffffa0385857>] ? nfsd+0xe5/0x12e [nfsd]
 [93662.200130] [<ffffffff81064a49>] ? kthread+0x79/0x81
 [93662.200162] [<ffffffff81011baa>] ? child_rip+0xa/0x20
 [93662.200191] [<ffffffff810649d0>] ? kthread+0x0/0x81
 [93662.200220] [<ffffffff81011ba0>] ? child_rip+0x0/0x20
 [93662.200256] BUG: unable to handle kernel paging request at 000000006eab11a0
 [93662.200294] IP: [<ffffffff8103fd9b>] update_curr+0xf9/0x147
 [93662.200331] PGD 0 
 
 [93662.200355] Thread overran stack, or stack corrupted
 [93662.200383] Oops: 0000 [#1] SMP
 
 [93662.200414] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/0000:07:00.1/irq
 [93662.200461] CPU 1 
 
 [93662.200486] Modules linked in:
 ioatdma
 netconsole
 configfs
 cpufreq_userspace
 cpufreq_stats
 cpufreq_powersave
 cpufreq_conservative
 8021q
 garp
 stp
 nfsd
 nfs
 lockd
 fscache
 nfs_acl
 auth_rpcgss
 sunrpc
 ext3
 jbd
 mbcache
 fuse
 dm_round_robin
 dm_multipath
 scsi_dh
 autofs4
 ohci_hcd
 sd_mod
 crc_t10dif
 usbhid
 hid
 snd_pcm_oss
 snd_mixer_oss
 snd_pcm
 snd_timer
 snd
 ipmi_si
 ixgbe
 soundcore
 psmouse
 ipmi_msghandler
 ehci_hcd
 dca
 snd_page_alloc
 uhci_hcd
 hpilo
 evdev
 serio_raw
 container
 mdio
 bnx2
 usbcore
 pcspkr
 nls_base
 power_meter
 qla2xxx
 scsi_transport_fc
 scsi_tgt
 processor
 button
 xfs
 exportfs
 dm_mirror
 dm_region_hash
 dm_log
 dm_snapshot
 dm_mod
 [93662.201420] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 [93662.201888] [<ffffffff812fb4cf>] ? __down_common+0x8d/0xde
 [93662.208496] [<ffffffff81068533>] ? down+0x27/0x38
 [93662.208539] [<ffffffffa00e2f58>] ? _xfs_buf_find+0x162/0x1e0 [xfs]
 [93662.208584] [<ffffffffa00e3030>] ? xfs_buf_get_flags+0x5a/0x13b [xfs]
 [93662.208629] [<ffffffffa00e3123>] ? xfs_buf_read_flags+0x12/0x7a [xfs]
 [93662.208675] [<ffffffffa00da819>] ? xfs_trans_read_buf+0x189/0x27e [xfs]
 [93662.208720] [<ffffffffa00a1c09>] ? xfs_read_agf+0x5a/0x149 [xfs]
 [93662.208762] [<ffffffffa00a1d1a>] ? xfs_alloc_read_agf+0x22/0xa4 [xfs]
 [93662.208806] [<ffffffffa00a38cf>] ? xfs_alloc_fix_freelist+0x11b/0x3dd [xfs]
 [93662.208851] [<ffffffffa00a3d57>] ? xfs_alloc_vextent+0x10e/0x3e3 [xfs]
 [93662.208896] [<ffffffffa00aea39>] ? xfs_bmap_btalloc+0x54f/0x732 [xfs]
 [93662.208945] [<ffffffffa00b0f4f>] ? xfs_bmapi+0x876/0x104d [xfs]
 [93662.208995] [<ffffffffa00c6e67>] ? xfs_iext_get_ext+0x34/0x5a [xfs]
 [93662.209042] [<ffffffffa00cbf3d>] ? xfs_iomap_write_allocate+0x245/0x387 [xfs]
 [93662.209108] [<ffffffffa00cc9b2>] ? xfs_iomap+0x213/0x285 [xfs]
 [93662.209424] [<ffffffff810bdfd5>] ? shrink_page_list+0x375/0x623
 [93662.209757] [<ffffffff810ba098>] ? __alloc_pages_nodemask+0x3cd/0x5f5
 [93662.210078] [<ffffffffa00d9979>] ? _xfs_trans_alloc+0x29/0x64 [xfs]
 [93662.210575] [<ffffffff810ba951>] ? write_cache_pages+0x20b/0x327
 [93662.211100] [<ffffffffa038987d>] ? nfsd_vfs_write+0x11a/0x329 [nfsd]
 48
 [93662.211857] CR2: 000000006eab11a0
 [93662.212189] Kernel panic - not syncing: Fatal exception in interrupt
 [93662.212497] [<ffffffff8104e387>] ? release_console_sem+0x17e/0x1af
 [93662.212818] [<ffffffff81011ba0>] ? child_rip+0x0/0x20
 [93662.213328] [<ffffffffa0058af7>] ? dm_unplug_all+0x3b/0x4c [dm_mod]
 [93662.213841] [<ffffffffa00a1c09>] ? xfs_read_agf+0x5a/0x149 [xfs]
 [93662.214384] [<ffffffffa00cbf3d>] ? xfs_iomap_write_allocate+0x245/0x387 [xfs]
 [93662.214831] [<ffffffffa005a3bb>] ? dm_table_any_congested+0x66/0xe6 [dm_mod]
 [93662.215447] [<ffffffff810bef43>] ? shrink_zone+0x280/0x342
 [93662.215703] [<ffffffff810e6535>] ? new_slab+0x42/0x1ca
 [93662.216138] [<ffffffffa00df85a>] ? kmem_zone_zalloc+0xe/0x2e [xfs]
 [93662.216448] [<ffffffffa009ab39>] ? xfs_qm_dqattach+0x32/0x3b [xfs]
 [93662.217403] [<ffffffff812fb3f5>] ? down_read+0x9/0x19
 [93662.217698] [<ffffffffa00d9d57>] ? xfs_trans_unlocked_item+0x20/0x3a [xfs]
 [93662.218208] [<ffffffffa038a34b>] ? nfsd_write+0xc5/0xe2 [nfsd]
 [93662.218482] [<ffffffffa0385772>] ? nfsd+0x0/0x12e [nfsd]
 [93662.218732] [<ffffffff810649d0>] ? kthread+0x0/0x81
 [93662.225424] [<ffffffff81011ba0>] ? child_rip+0x0/0x20

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
