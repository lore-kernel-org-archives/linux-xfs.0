Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A02FA7CA4
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 23:54:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C8F19AC001
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 21:54:40 -0700 (PDT)
Received: from mail.gecius.de (bum4.dynsinn.org [88.198.11.146]) by
	cuda.sgi.com with ESMTP id pDb8W02enlcSmVe8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 21:54:36 -0700 (PDT)
Received: from STab.fritz.box (ip4d16b9de.dynamic.kabel-deutschland.de
	[77.22.185.222])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jens@gecius.de)
	by mail.gecius.de (Postfix) with ESMTPSA id 71496E029A
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 06:54:33 +0200 (CEST)
MIME-Version: 1.0
Subject: Xfs-related oops?
From: Jens <jens@gecius.de>
Date: Tue, 29 Mar 2016 06:53:08 +0200
Message-ID: <33B260EF-3E3A-48D8-A04E-12470B63054E@gecius.de>
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
To: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi folks,

I haven't found any recent hints on xfs-related kernel oops, but I obviously get some, unfortunately.

If any other information is needed, pls let me know (not subscribed to list, pls cc me).

Any help would be appreciated.

Thanks,
 Jens

Mar 29 04:09:49 server kernel: [1572426.666492] BUG: unable to handle kernel NULL pointer dereference at 00000000000001bb
Mar 29 04:09:49 server kernel: [1572426.667356] IP: [<ffffffffa02ccc17>] xfs_inode_set_reclaim_tag+0x27/0x170 [xfs]
Mar 29 04:09:49 server kernel: [1572426.668173] PGD 0
Mar 29 04:09:49 server kernel: [1572426.668984] Oops: 0000 [#1] SMP
Mar 29 04:09:49 server kernel: [1572426.669774] Modules linked in: nls_iso8859_1 nf_conntrack_netlink nfnetlink xt_multiport vhost_net vhost macvtap macvlan ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables dm_crypt snd_usb_audio snd_usbmidi_lib uvcvideo snd_hwdep snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq bnep videobuf2_vmalloc snd_seq_device videobuf2_memops snd_timer videobuf2_core ftdi_sio usbserial videodev snd joydev soundcore stv6110x rfcomm bluetooth lnbp21 stv090x ddbridge x86_pkg_temp_thermal intel_powerclamp coretemp cxd2099(C) kvm_intel kvm dvb_core crct10dif_pclmul crc32_pclmul aesni_intel dm_multipath scsi_dh aes_x86_64 ipmi_si lrw gf128mul shpchp lpc_ich glue_helper ablk_helper mac_hid cryptd nfsd parport_pc ppdev auth_rpcgss binfmt_
 misc
nfs
 _acl hwmon_vid ipmi_devintf ipmi_watchdog nfs lockd sunrpc lp parport fscache xfs btrfs xor raid6_pq libcrc32c dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage ast syscopyarea sysfillrect sysimgblt ttm drm_kms_helper igb drm e1000e dca ahci libahci ptp i2c_algo_bit arcmsr pps_core video
Mar 29 04:09:49 server kernel: [1572426.675311] CPU: 7 PID: 77 Comm: kswapd0 Tainted: G         C    3.13.0-79-generic #123-Ubuntu
Mar 29 04:09:49 server kernel: [1572426.676293] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 3.0 04/24/2015
Mar 29 04:09:49 server kernel: [1572426.677363] task: ffff8807ee199800 ti: ffff8807ee1a8000 task.ti: ffff8807ee1a8000
Mar 29 04:09:49 server kernel: [1572426.678396] RIP: 0010:[<ffffffffa02ccc17>]  [<ffffffffa02ccc17>] xfs_inode_set_reclaim_tag+0x27/0x170 [xfs]
Mar 29 04:09:49 server kernel: [1572426.679495] RSP: 0018:ffff8807ee1a9b58  EFLAGS: 00010292
Mar 29 04:09:49 server kernel: [1572426.680541] RAX: 0000000000020002 RBX: ffff880004000000 RCX: 0000000000000034
Mar 29 04:09:49 server kernel: [1572426.681596] RDX: 0000000000000002 RSI: 0000000000000000 RDI: 0000000000000000
Mar 29 04:09:49 server kernel: [1572426.682567] RBP: ffff8807ee1a9b98 R08: 7018000000000000 R09: 00040002380c0000
Mar 29 04:09:49 server kernel: [1572426.683534] R10: ffddfffec7f48e03 R11: 00000000ffffffff R12: ffff880004000000
Mar 29 04:09:49 server kernel: [1572426.684549] R13: 0000000000000000 R14: ffff8800040000d4 R15: 0000000000000560
Mar 29 04:09:49 server kernel: [1572426.685564] FS:  0000000000000000(0000) GS:ffff88081fdc0000(0000) knlGS:0000000000000000
Mar 29 04:09:49 server kernel: [1572426.686577] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Mar 29 04:09:49 server kernel: [1572426.687544] CR2: 00000000000001bb CR3: 0000000001c0e000 CR4: 00000000001427e0
Mar 29 04:09:49 server kernel: [1572426.688547] Stack:
Mar 29 04:09:49 server kernel: [1572426.689531]  ffff8807ee1a9ba0 ffffffff81201534 ffff8807ee1a9b68 ffff8800040000d4
Mar 29 04:09:49 server kernel: [1572426.690561]  ffff880004000000 0000000000000000 0000000000000000 0000000000000560
Mar 29 04:09:49 server kernel: [1572426.691580]  ffff8807ee1a9bc8 ffffffffa02d7a6f ffff880004000198 ffff880004000220
Mar 29 04:09:49 server kernel: [1572426.692593] Call Trace:
Mar 29 04:09:49 server kernel: [1572426.693892]  [<ffffffff81201534>] ? fsnotify_clear_marks_by_inode+0xa4/0x130
Mar 29 04:09:49 server kernel: [1572426.695346]  [<ffffffffa02d7a6f>] xfs_fs_destroy_inode+0xbf/0x100 [xfs]
Mar 29 04:09:49 server kernel: [1572426.696346]  [<ffffffff811d9998>] destroy_inode+0x38/0x60
Mar 29 04:09:49 server kernel: [1572426.697415]  [<ffffffff811d9adb>] evict+0x11b/0x1b0
Mar 29 04:09:49 server kernel: [1572426.698450]  [<ffffffff811d9ba9>] dispose_list+0x39/0x50
Mar 29 04:09:49 server kernel: [1572426.700428]  [<ffffffff811daad7>] prune_icache_sb+0x47/0x60
Mar 29 04:09:49 server kernel: [1572426.702333]  [<ffffffff811c1dd5>] super_cache_scan+0x105/0x170
Mar 29 04:09:49 server kernel: [1572426.704129]  [<ffffffff811618f7>] shrink_slab+0x1c7/0x370
Mar 29 04:09:49 server kernel: [1572426.705213]  [<ffffffff81165468>] balance_pgdat+0x3e8/0x610
Mar 29 04:09:49 server kernel: [1572426.706226]  [<ffffffff811657eb>] kswapd+0x15b/0x3f0
Mar 29 04:09:49 server kernel: [1572426.707237]  [<ffffffff810ab4e0>] ? prepare_to_wait_event+0x100/0x100
Mar 29 04:09:49 server kernel: [1572426.708298]  [<ffffffff81165690>] ? balance_pgdat+0x610/0x610
Mar 29 04:09:49 server kernel: [1572426.709385]  [<ffffffff8108b8a2>] kthread+0xd2/0xf0
Mar 29 04:09:49 server kernel: [1572426.710494]  [<ffffffff8108b7d0>] ? kthread_create_on_node+0x1c0/0x1c0
Mar 29 04:09:49 server kernel: [1572426.711540]  [<ffffffff81736328>] ret_from_fork+0x58/0x90
Mar 29 04:09:49 server kernel: [1572426.712649]  [<ffffffff8108b7d0>] ? kthread_create_on_node+0x1c0/0x1c0
Mar 29 04:09:49 server kernel: [1572426.713688] Code: 0f 1f 40 00 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 89 fb 4c 8d b3 d4 00 00 00 48 83 ec 18 48 8b 3f 48 8b 73 20 <0f> b6 8f bb 01 00 00 48 d3 ee e8 fa d1 04 00 4c 8d 68 4c 49 89
Mar 29 04:09:49 server kernel: [1572426.714816] RIP  [<ffffffffa02ccc17>] xfs_inode_set_reclaim_tag+0x27/0x170 [xfs]
Mar 29 04:09:49 server kernel: [1572426.715941]  RSP <ffff8807ee1a9b58>
Mar 29 04:09:49 server kernel: [1572426.717013] CR2: 00000000000001bb
Mar 29 04:09:49 server kernel: [1572426.724720] ---[ end trace ea84784f70a01498 ]---
-----BEGIN PGP SIGNATURE-----
Version: APG v1.1.1

iGQEAREKACQFAlb6CjQdHEplbnMgR2VjaXVzIDxqZW5zQGdlY2l1cy5kZT4ACgkQ
GNSomyjQ8JfazACeOcfyqsiHrx1EeHtioJ3aQvYSluAAn0BZOM7xycIRd7caL44B
JyN4dOBk
=u2ZC
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
