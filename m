Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01D7B7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 11:27:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C8F828F8035
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 09:27:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LJYfW37Oz4WAbP3Q for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 09:27:15 -0800 (PST)
Date: Tue, 11 Feb 2014 12:27:07 -0500
From: Dave Jones <davej@redhat.com>
Subject: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140211172707.GA1749@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com

BUG: sleeping function called from invalid context at mm/mempool.c:203
in_atomic(): 0, irqs_disabled(): 1, pid: 27511, name: trinity-c3
5 locks held by trinity-c3/27511:
 #0:  (sb_writers#9){......}, at: [<ffffffff831df3b4>] mnt_want_write+0x24/0x50
 #1:  (&type->i_mutex_dir_key#3){......}, at: [<ffffffff831cced4>] do_last.isra.51+0x294/0x11f0
 #2:  (sb_internal#2){......}, at: [<ffffffffc03225c4>] xfs_trans_alloc+0x24/0x40 [xfs]
 #3:  (&(&ip->i_lock)->mr_lock/1){......}, at: [<ffffffffc036447f>] xfs_ilock+0x16f/0x1b0 [xfs]
 #4:  (&(&ip->i_lock)->mr_lock){......}, at: [<ffffffffc03646d4>] xfs_ilock_nowait+0x184/0x200 [xfs]
CPU: 3 PID: 27511 Comm: trinity-c3 Not tainted 3.14.0-rc2+ #111 
 ffffffff83a3fd56 0000000045a3849a ffff88009f368f60 ffffffff8372afea
 0000000000000000 ffff88009f368f88 ffffffff8309ddb5 0000000000000010
 ffff880243566288 0000000000000008 ffff88009f369008 ffffffff831534d3
Call Trace:
 [<ffffffff8372afea>] dump_stack+0x4e/0x7a
 [<ffffffff8309ddb5>] __might_sleep+0x105/0x150
 [<ffffffff831534d3>] mempool_alloc+0xa3/0x170
 [<ffffffff831a955a>] ? deactivate_slab+0x51a/0x590
 [<ffffffff831f8fd6>] bio_alloc_bioset+0x156/0x210
 [<ffffffffc0308231>] _xfs_buf_ioapply+0x1c1/0x3c0 [xfs]
 [<ffffffffc03798f2>] ? xlog_bdstrat+0x22/0x60 [xfs]
 [<ffffffffc030849b>] xfs_buf_iorequest+0x6b/0xf0 [xfs]
 [<ffffffffc03798f2>] xlog_bdstrat+0x22/0x60 [xfs]
 [<ffffffffc037ba87>] xlog_sync+0x3a7/0x5b0 [xfs]
 [<ffffffffc037bd9f>] xlog_state_release_iclog+0x10f/0x120 [xfs]
 [<ffffffffc037c840>] xlog_write+0x6f0/0x800 [xfs]
 [<ffffffffc037e061>] xlog_cil_push+0x2f1/0x410 [xfs]
 [<ffffffffc037e948>] xlog_cil_force_lsn+0x1d8/0x210 [xfs]
 [<ffffffffc03428a8>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
 [<ffffffffc037cc40>] _xfs_log_force+0x70/0x290 [xfs]
 [<ffffffff830a4edd>] ? get_parent_ip+0xd/0x50
 [<ffffffffc037ce86>] xfs_log_force+0x26/0xb0 [xfs]
 [<ffffffffc03076e6>] ? _xfs_buf_find+0x1f6/0x3c0 [xfs]
 [<ffffffffc03074e3>] xfs_buf_lock+0x133/0x140 [xfs]
 [<ffffffffc03076e6>] _xfs_buf_find+0x1f6/0x3c0 [xfs]
 [<ffffffffc030796a>] xfs_buf_get_map+0x2a/0x1b0 [xfs]
 [<ffffffffc0383c61>] xfs_trans_get_buf_map+0x1a1/0x240 [xfs]
 [<ffffffffc034e03d>] xfs_da_get_buf+0xbd/0x100 [xfs]
 [<ffffffffc0356869>] xfs_dir3_data_init+0x59/0x1d0 [xfs]
 [<ffffffffc03526db>] ? xfs_dir2_grow_inode+0x13b/0x150 [xfs]
 [<ffffffffc0354ede>] xfs_dir2_sf_to_block+0x17e/0x7b0 [xfs]
 [<ffffffffc0351f5a>] ? xfs_dir2_sfe_get_ino+0x1a/0x20 [xfs]
 [<ffffffffc035e9b4>] ? xfs_dir2_sf_check.isra.7+0x114/0x1b0 [xfs]
 [<ffffffffc034c24f>] ? xfs_da_compname+0x1f/0x30 [xfs]
 [<ffffffffc035f503>] ? xfs_dir2_sf_lookup+0x303/0x310 [xfs]
 [<ffffffffc035f858>] xfs_dir2_sf_addname+0x348/0x6d0 [xfs]
 [<ffffffffc031970d>] ? xfs_setup_inode+0x1cd/0x320 [xfs]
 [<ffffffffc03529a4>] xfs_dir_createname+0x184/0x1e0 [xfs]
 [<ffffffffc03663d9>] xfs_create+0x469/0x580 [xfs]
 [<ffffffffc0318864>] xfs_vn_mknod+0xc4/0x1e0 [xfs]
 [<ffffffffc0318993>] xfs_vn_create+0x13/0x20 [xfs]
 [<ffffffff831ccc15>] vfs_create+0x95/0xc0
 [<ffffffff831cd638>] do_last.isra.51+0x9f8/0x11f0
 [<ffffffff831c9e11>] ? link_path_walk+0x81/0x870
 [<ffffffff831cdef9>] path_openat+0xc9/0x620
 [<ffffffff8331cc02>] ? put_dec+0x72/0x90
 [<ffffffff831ceb6d>] do_filp_open+0x4d/0xb0
 [<ffffffff831bc4ae>] file_open_name+0xfe/0x160
 [<ffffffff831bc554>] filp_open+0x44/0x60
 [<ffffffff83221862>] do_coredump+0x602/0xf60
 [<ffffffff83081358>] get_signal_to_deliver+0x2b8/0x6b0
 [<ffffffff830024d7>] do_signal+0x57/0x9d0
 [<ffffffff8311115e>] ? __acct_update_integrals+0x8e/0x120
 [<ffffffff83730000>] ? __schedule+0x60/0x850
 [<ffffffff8373a1db>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffff83735a31>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff830ab671>] ? vtime_account_user+0x91/0xa0
 [<ffffffff8314f57b>] ? context_tracking_user_exit+0x9b/0x100
 [<ffffffff83002eac>] do_notify_resume+0x5c/0xa0
 [<ffffffff83736746>] retint_signal+0x46/0x90
------------[ cut here ]------------
WARNING: CPU: 3 PID: 27511 at block/blk.h:227 generic_make_request_checks+0x33f/0x460()
Modules linked in: bridge stp tun snd_seq_dummy fuse hidp bnep rfcomm nf_conntrack_netlink nf_conntrack scsi_transport_iscsi nfnetlink can_raw nfc pn_pep caif_socket caif af_802154 phonet af_rxrpc can_bcm can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds ipt_ULOG af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 xfs libcrc32c coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic serio_raw microcode pcspkr snd_hda_intel snd_hda_codec usb_debug btusb snd_hwdep snd_seq snd_seq_device bluetooth 6lowpan_iphc rfkill snd_pcm snd_timer snd soundcore e1000e ptp shpchp pps_core
CPU: 3 PID: 27511 Comm: trinity-c3 Not tainted 3.14.0-rc2+ #111 
 0000000000000009 0000000045a3849a ffff88009f368f10 ffffffff8372afea
 0000000000000000 ffff88009f368f48 ffffffff8306d0cd ffff88023933ed00
 00000000ffffffff 00000000197f7510 0000000000800005 ffff880240913740
Call Trace:
 [<ffffffff8372afea>] dump_stack+0x4e/0x7a
 [<ffffffff8306d0cd>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8306d1fa>] warn_slowpath_null+0x1a/0x20
 [<ffffffff832e81bf>] generic_make_request_checks+0x33f/0x460
 [<ffffffff832e8307>] generic_make_request+0x27/0x130
 [<ffffffff832e8488>] submit_bio+0x78/0x160
 [<ffffffff831f9000>] ? bio_alloc_bioset+0x180/0x210
 [<ffffffffc030832b>] _xfs_buf_ioapply+0x2bb/0x3c0 [xfs]
 [<ffffffffc03798f2>] ? xlog_bdstrat+0x22/0x60 [xfs]
 [<ffffffffc030849b>] xfs_buf_iorequest+0x6b/0xf0 [xfs]
 [<ffffffffc03798f2>] xlog_bdstrat+0x22/0x60 [xfs]
 [<ffffffffc037ba87>] xlog_sync+0x3a7/0x5b0 [xfs]
 [<ffffffffc037bd9f>] xlog_state_release_iclog+0x10f/0x120 [xfs]
 [<ffffffffc037c840>] xlog_write+0x6f0/0x800 [xfs]
 [<ffffffffc037e061>] xlog_cil_push+0x2f1/0x410 [xfs]
 [<ffffffffc037e948>] xlog_cil_force_lsn+0x1d8/0x210 [xfs]
 [<ffffffffc03428a8>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
 [<ffffffffc037cc40>] _xfs_log_force+0x70/0x290 [xfs]
 [<ffffffff830a4edd>] ? get_parent_ip+0xd/0x50
 [<ffffffffc037ce86>] xfs_log_force+0x26/0xb0 [xfs]
 [<ffffffffc03076e6>] ? _xfs_buf_find+0x1f6/0x3c0 [xfs]
 [<ffffffffc03074e3>] xfs_buf_lock+0x133/0x140 [xfs]
 [<ffffffffc03076e6>] _xfs_buf_find+0x1f6/0x3c0 [xfs]
 [<ffffffffc030796a>] xfs_buf_get_map+0x2a/0x1b0 [xfs]
 [<ffffffffc0383c61>] xfs_trans_get_buf_map+0x1a1/0x240 [xfs]
 [<ffffffffc034e03d>] xfs_da_get_buf+0xbd/0x100 [xfs]
 [<ffffffffc0356869>] xfs_dir3_data_init+0x59/0x1d0 [xfs]
 [<ffffffffc03526db>] ? xfs_dir2_grow_inode+0x13b/0x150 [xfs]
 [<ffffffffc0354ede>] xfs_dir2_sf_to_block+0x17e/0x7b0 [xfs]
 [<ffffffffc0351f5a>] ? xfs_dir2_sfe_get_ino+0x1a/0x20 [xfs]
 [<ffffffffc035e9b4>] ? xfs_dir2_sf_check.isra.7+0x114/0x1b0 [xfs]
 [<ffffffffc034c24f>] ? xfs_da_compname+0x1f/0x30 [xfs]
 [<ffffffffc035f503>] ? xfs_dir2_sf_lookup+0x303/0x310 [xfs]
 [<ffffffffc035f858>] xfs_dir2_sf_addname+0x348/0x6d0 [xfs]
 [<ffffffffc031970d>] ? xfs_setup_inode+0x1cd/0x320 [xfs]
 [<ffffffffc03529a4>] xfs_dir_createname+0x184/0x1e0 [xfs]
 [<ffffffffc03663d9>] xfs_create+0x469/0x580 [xfs]
 [<ffffffffc0318864>] xfs_vn_mknod+0xc4/0x1e0 [xfs]
 [<ffffffffc0318993>] xfs_vn_create+0x13/0x20 [xfs]
 [<ffffffff831ccc15>] vfs_create+0x95/0xc0
 [<ffffffff831cd638>] do_last.isra.51+0x9f8/0x11f0
 [<ffffffff831c9e11>] ? link_path_walk+0x81/0x870
 [<ffffffff831cdef9>] path_openat+0xc9/0x620
 [<ffffffff8331cc02>] ? put_dec+0x72/0x90
 [<ffffffff831ceb6d>] do_filp_open+0x4d/0xb0
 [<ffffffff831bc4ae>] file_open_name+0xfe/0x160
 [<ffffffff831bc554>] filp_open+0x44/0x60
 [<ffffffff83221862>] do_coredump+0x602/0xf60
 [<ffffffff83081358>] get_signal_to_deliver+0x2b8/0x6b0
 [<ffffffff830024d7>] do_signal+0x57/0x9d0
 [<ffffffff8311115e>] ? __acct_update_integrals+0x8e/0x120
 [<ffffffff83730000>] ? __schedule+0x60/0x850
 [<ffffffff8373a1db>] ? preempt_count_sub+0x6b/0xf0
 [<ffffffff83735a31>] ? _raw_spin_unlock+0x31/0x50
 [<ffffffff830ab671>] ? vtime_account_user+0x91/0xa0
 [<ffffffff8314f57b>] ? context_tracking_user_exit+0x9b/0x100
 [<ffffffff83002eac>] do_notify_resume+0x5c/0xa0
 [<ffffffff83736746>] retint_signal+0x46/0x90
---[ end trace e6e48f6461c98e81 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
