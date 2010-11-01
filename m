Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA1FASba219164 for <xfs@oss.sgi.com>; Mon, 1 Nov 2010 10:10:29 -0500
Received: from mail1.alefnula.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A5B71E8B71A
	for <xfs@oss.sgi.com>; Mon,  1 Nov 2010 08:11:48 -0700 (PDT)
Received: from mail1.alefnula.cz (mail1.alefnula.com [193.239.2.3]) by
	cuda.sgi.com with ESMTP id 5HtqQNY5Sogx7uJv for
	<xfs@oss.sgi.com>; Mon, 01 Nov 2010 08:11:48 -0700 (PDT)
Message-ID: <4CCED8B2.2030604@nangu.tv>
Date: Mon, 1 Nov 2010 16:11:46 +0100
From: Martin Hamrle <martin.hamrle@nangu.tv>
MIME-Version: 1.0
Subject: [2.6.32] scheduling while atomic
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

Hi,

I have box with xfs on sw raid5. There is permanent high read / write
load. After almost month uptime kernel crashed with this traceback.

Note that several minutes before there were problems with memory
allocation (not sure if related to this problem).

I'm seeing similar crashes on several boxes.

Martin

Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217514] BUG: scheduling
while atomic: tscpd/22653/0xffff8802
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217701] Modules linked
in: raid456 async_raid6_recov async_pq raid6_pq async_xor xor
async_memcpy async
_tx bonding xfs exportfs dm_mod loop firewire_sbp2 snd_hda_codec_realtek
snd_hda_intel snd_hda_codec psmouse edac_core edac_mce_amd snd_hwdep
serio_ra
w snd_pcm snd_timer snd soundcore evdev joydev i2c_piix4 snd_page_alloc
i2c_core pcspkr button processor ext3 jbd mbcache raid1 md_mod sd_mod
crc_t10d
if usbhid hid firewire_ohci ohci_hcd ehci_hcd firewire_core crc_itu_t
mpt2sas usbcore nls_base igb scsi_transport_sas dca scsi_mod thermal fan
thermal
_sys [last unloaded: scsi_wait_scan]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217741] Pid: 22653, comm:
tscpd Not tainted 2.6.32-bpo.3-amd64 #1
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217744] Call Trace:
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217754]
[<ffffffff812ed71e>] ? schedule+0xce/0x7da
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217760]
[<ffffffff811787fb>] ? __make_request+0x3a4/0x428
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217766]
[<ffffffff81176f2b>] ? generic_make_request+0x299/0x2f9
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217770]
[<ffffffff812ee253>] ? schedule_timeout+0x2e/0xdd
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217776]
[<ffffffff8105a432>] ? lock_timer_base+0x26/0x4b
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217779]
[<ffffffff812ee118>] ? wait_for_common+0xde/0x14f
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217784]
[<ffffffff8104a188>] ? default_wake_function+0x0/0x9
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217790]
[<ffffffffa036d74a>] ? unplug_slaves+0x7f/0xb4 [raid456]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217810]
[<ffffffffa0306968>] ? xfs_buf_iowait+0x27/0x30 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217823]
[<ffffffffa0307fd5>] ? xfs_buf_read_flags+0x4a/0x7a [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217838]
[<ffffffffa02ff5cd>] ? xfs_trans_read_buf+0x189/0x27e [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217852]
[<ffffffffa02d91b9>] ? xfs_btree_read_buf_block+0x4a/0x8f [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217866]
[<ffffffffa02da1e3>] ? xfs_btree_lookup_get_block+0x87/0xac [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217879]
[<ffffffffa02da7a9>] ? xfs_btree_lookup+0x12a/0x3cc [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217893]
[<ffffffffa030477e>] ? kmem_zone_zalloc+0x1e/0x2e [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217907]
[<ffffffffa02ff506>] ? xfs_trans_read_buf+0xc2/0x27e [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217919]
[<ffffffffa02c66f2>] ? xfs_alloc_fixup_trees+0x39/0x296 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217932]
[<ffffffffa02c8600>] ? xfs_alloc_ag_vextent_near+0x96b/0x9e0 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217945]
[<ffffffffa02c86a0>] ? xfs_alloc_ag_vextent+0x2b/0xef [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217957]
[<ffffffffa02c8d3d>] ? xfs_alloc_vextent+0x144/0x3e3 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217971]
[<ffffffffa02d1983>] ? xfs_bmap_extents_to_btree+0x1df/0x3a6 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217977]
[<ffffffff810e43fd>] ? virt_to_head_page+0x9/0x2b
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.217991]
[<ffffffffa02d2484>] ? xfs_bmap_add_extent_delay_real+0x93a/0x101d [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218003]
[<ffffffffa02c6af5>] ? xfs_alloc_search_busy+0x2d/0x97 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218016]
[<ffffffffa02c8f55>] ? xfs_alloc_vextent+0x35c/0x3e3 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218029]
[<ffffffffa02d2d77>] ? xfs_bmap_add_extent+0x210/0x3a3 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218043]
[<ffffffffa02d60cb>] ? xfs_bmapi+0xa42/0x104d [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218047]
[<ffffffff810e3033>] ? get_partial_node+0x15/0x79
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218062]
[<ffffffffa02fe63f>] ? xfs_trans_reserve+0xc8/0x19d [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218076]
[<ffffffffa02f0d8f>] ? xfs_iomap_write_allocate+0x245/0x387 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218091]
[<ffffffffa02f1804>] ? xfs_iomap+0x213/0x287 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218105]
[<ffffffffa0304fbd>] ? xfs_map_blocks+0x25/0x2c [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218110]
[<ffffffff8118a654>] ? radix_tree_delete+0xbf/0x1ba
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218124]
[<ffffffffa0305be5>] ? xfs_page_state_convert+0x299/0x565 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218137]
[<ffffffffa0305f49>] ? xfs_vm_releasepage+0x98/0xa5 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218151]
[<ffffffffa030612c>] ? xfs_vm_writepage+0xb0/0xe5 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218156]
[<ffffffff810bd12c>] ? shrink_page_list+0x369/0x617
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218160]
[<ffffffff810bdaf1>] ? shrink_list+0x44a/0x725
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218174]
[<ffffffffa02dbc9d>] ? xfs_btree_delrec+0x630/0xe0e [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218178]
[<ffffffff810b4b7c>] ? mempool_alloc+0x55/0x106
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218182]
[<ffffffff810be04c>] ? shrink_zone+0x280/0x342
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218186]
[<ffffffff810bf110>] ? try_to_free_pages+0x232/0x38e
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218189]
[<ffffffff810bc177>] ? isolate_pages_global+0x0/0x20f
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218193]
[<ffffffff810b92c5>] ? __alloc_pages_nodemask+0x3bb/0x5ce
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218198]
[<ffffffff8101184e>] ? reschedule_interrupt+0xe/0x20
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218212]
[<ffffffffa02ec658>] ? xfs_iext_bno_to_ext+0xba/0x140 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218216]
[<ffffffff810e5190>] ? new_slab+0x42/0x1ca
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218220]
[<ffffffff810e5508>] ? __slab_alloc+0x1f0/0x39b
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218233]
[<ffffffffa030471a>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218247]
[<ffffffffa030471a>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218250]
[<ffffffff810e59e5>] ? kmem_cache_alloc+0x7f/0xf0
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218263]
[<ffffffffa030471a>] ? kmem_zone_alloc+0x5e/0xa4 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218277]
[<ffffffffa030476e>] ? kmem_zone_zalloc+0xe/0x2e [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218291]
[<ffffffffa02fe740>] ? _xfs_trans_alloc+0x2c/0x67 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218304]
[<ffffffffa02fe976>] ? xfs_trans_alloc+0x90/0x9a [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218318]
[<ffffffffa02feb0b>] ? xfs_trans_unlocked_item+0x20/0x39 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218331]
[<ffffffffa02bfb1e>] ? xfs_qm_dqattach+0x32/0x3b [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218345]
[<ffffffffa02f0bfd>] ? xfs_iomap_write_allocate+0xb3/0x387 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218352]
[<ffffffffa010eb6b>] ? md_make_request+0xb6/0xf1 [md_mod]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218365]
[<ffffffffa03053c4>] ? xfs_start_page_writeback+0x24/0x37 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218380]
[<ffffffffa02f1804>] ? xfs_iomap+0x213/0x287 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218393]
[<ffffffffa0304fbd>] ? xfs_map_blocks+0x25/0x2c [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218407]
[<ffffffffa0305be5>] ? xfs_page_state_convert+0x299/0x565 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218411]
[<ffffffff81047f25>] ? finish_task_switch+0x3a/0xa7
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218424]
[<ffffffffa030612c>] ? xfs_vm_writepage+0xb0/0xe5 [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218428]
[<ffffffff810b94e2>] ? __writepage+0xa/0x25
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218431]
[<ffffffff810b9b69>] ? write_cache_pages+0x20b/0x327
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218434]
[<ffffffff810b94d8>] ? __writepage+0x0/0x25
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218439]
[<ffffffff8110637e>] ? writeback_single_inode+0xe7/0x2da
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218443]
[<ffffffff81107057>] ? writeback_inodes_wb+0x423/0x4fe
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218447]
[<ffffffff810ba2cf>] ? balance_dirty_pages_ratelimited_nr+0x192/0x332
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218452]
[<ffffffff810b3ea2>] ? generic_file_buffered_write+0x1f5/0x278
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218466]
[<ffffffffa030ba8e>] ? xfs_write+0x4df/0x6ea [xfs]
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218470]
[<ffffffff810cf993>] ? vma_adjust+0x1a3/0x40f
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218475]
[<ffffffff810ed1da>] ? do_sync_write+0xce/0x113
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218479]
[<ffffffff81064a36>] ? autoremove_wake_function+0x0/0x2e
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218483]
[<ffffffff810d0dc4>] ? mmap_region+0x3b5/0x4f3
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218486]
[<ffffffff810edb52>] ? vfs_write+0xa9/0x102
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218489]
[<ffffffff810edc67>] ? sys_write+0x45/0x6e
Oct 31 22:19:43 192.168.5.113 kernel: [2492736.218494]
[<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
