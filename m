Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5688F7F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 22:04:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A77B8F804C
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:04:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x7MrbJmAttL4noSI for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 20:04:10 -0800 (PST)
Date: Tue, 11 Feb 2014 23:03:58 -0500
From: Dave Jones <davej@redhat.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212040358.GA25327@redhat.com>
References: <20140211172707.GA1749@redhat.com> <20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net> <20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Feb 11, 2014 at 06:52:19PM -0800, Linus Torvalds wrote:
 > On Tue, Feb 11, 2014 at 5:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
 > >
 > > Slap the check in vfs_create(), see if interrupts had been disabled by it or
 > > by something in ->create().  Since it's reproducible...
 > 
 > path_openat() starts off with a get_empty_filp(), which allocates a
 > file pointer with GFP_KERNEL. So that should have triggered the
 > might_sleep warning if irq's were already disabled at that point.
 > 
 > So it's not before that - in particular, it's not in the signal
 > handling or do_coredump() paths.
 > 
 > Also, at least xfs_buf_lock() - which is much deeper in that chain -
 > does a down(&bp->b_sema). I'm disguested that that doesn't have a
 > might_sleep() in it.
 > 
 > Dave, mind adding a "might_sleep()" to the top of
 > "down[_interruptible]()". It's silly to not have coverage of semaphore
 > use in bad contexts.

Added those, didn't trigger. Neither did Al's suggestion.

Slightly different trace, but still from the coredump path.

	Dave

[ 3111.403822] BUG: sleeping function called from invalid context at mm/mempool.c:203
[ 3111.404414] in_atomic(): 0, irqs_disabled(): 1, pid: 19213, name: trinity-c46
[ 3111.404884] 5 locks held by trinity-c46/19213:
[ 3111.405354]  #0:  (sb_writers#9){......}, at: [<ffffffff8d2220c5>] do_coredump+0xe05/0xf60
[ 3111.405862]  #1:  (shrinker_rwsem){......}, at: [<ffffffff8d1644af>] shrink_slab+0x3f/0x180
[ 3111.406374]  #2:  (&type->s_umount_key#30){......}, at: [<ffffffff8d1c0db4>] grab_super_passive+0x44/0x90
[ 3111.406905]  #3:  (&pag->pag_ici_reclaim_lock){......}, at: [<ffffffffc031eb1a>] xfs_reclaim_inodes_ag+0x31a/0x430 [xfs]
[ 3111.407466]  #4:  (&(&ip->i_lock)->mr_lock){......}, at: [<ffffffffc037047f>] xfs_ilock+0x16f/0x1b0 [xfs]
[ 3111.408039] CPU: 0 PID: 19213 Comm: trinity-c46 Not tainted 3.14.0-rc2+ #113 
[ 3111.409779]  ffffffff8da3fde6 000000004f998871 ffff88023715cce0 ffffffff8d72b091
[ 3111.410396]  0000000000000000 ffff88023715cd08 ffffffff8d09ddb5 0000000000000010
[ 3111.411021]  ffff880243566288 0000000000000008 ffff88023715cd88 ffffffff8d1534f3
[ 3111.411656] Call Trace:
[ 3111.412283]  [<ffffffff8d72b091>] dump_stack+0x4e/0x7a
[ 3111.412922]  [<ffffffff8d09ddb5>] __might_sleep+0x105/0x150
[ 3111.413562]  [<ffffffff8d1534f3>] mempool_alloc+0xa3/0x170
[ 3111.414202]  [<ffffffff8d1f9036>] bio_alloc_bioset+0x156/0x210
[ 3111.414855]  [<ffffffffc0314231>] _xfs_buf_ioapply+0x1c1/0x3c0 [xfs]
[ 3111.415517]  [<ffffffffc03858f2>] ? xlog_bdstrat+0x22/0x60 [xfs]
[ 3111.416175]  [<ffffffffc031449b>] xfs_buf_iorequest+0x6b/0xf0 [xfs]
[ 3111.416843]  [<ffffffffc03858f2>] xlog_bdstrat+0x22/0x60 [xfs]
[ 3111.417509]  [<ffffffffc0387a87>] xlog_sync+0x3a7/0x5b0 [xfs]
[ 3111.418175]  [<ffffffffc0387d9f>] xlog_state_release_iclog+0x10f/0x120 [xfs]
[ 3111.418846]  [<ffffffffc0388840>] xlog_write+0x6f0/0x800 [xfs]
[ 3111.419518]  [<ffffffffc038a061>] xlog_cil_push+0x2f1/0x410 [xfs]
[ 3111.420195]  [<ffffffffc038a948>] xlog_cil_force_lsn+0x1d8/0x210 [xfs]
[ 3111.420865]  [<ffffffff8d1a6cd9>] ? __bit_spin_unlock.constprop.66+0x19/0x40
[ 3111.421551]  [<ffffffffc0389413>] _xfs_log_force_lsn+0x93/0x340 [xfs]
[ 3111.422239]  [<ffffffffc03896ee>] xfs_log_force_lsn+0x2e/0xb0 [xfs]
[ 3111.422932]  [<ffffffffc0374209>] ? xfs_iunpin_wait+0x19/0x20 [xfs]
[ 3111.423625]  [<ffffffffc0370b50>] __xfs_iunpin_wait+0xd0/0x1a0 [xfs]
[ 3111.424310]  [<ffffffff8d0b9dc0>] ? autoremove_wake_function+0x40/0x40
[ 3111.425008]  [<ffffffffc0374209>] xfs_iunpin_wait+0x19/0x20 [xfs]
[ 3111.425705]  [<ffffffffc031e50c>] xfs_reclaim_inode+0x8c/0x380 [xfs]
[ 3111.426405]  [<ffffffffc031ea7b>] xfs_reclaim_inodes_ag+0x27b/0x430 [xfs]
[ 3111.427104]  [<ffffffffc031e900>] ? xfs_reclaim_inodes_ag+0x100/0x430 [xfs]
[ 3111.427797]  [<ffffffffc031ed13>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[ 3111.428481]  [<ffffffffc032afa5>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
[ 3111.429150]  [<ffffffff8d1c107c>] super_cache_scan+0x16c/0x180
[ 3111.429824]  [<ffffffff8d16225b>] shrink_slab_node+0x14b/0x2e0
[ 3111.430489]  [<ffffffff8d1644af>] ? shrink_slab+0x3f/0x180
[ 3111.431146]  [<ffffffff8d1644fe>] shrink_slab+0x8e/0x180
[ 3111.431796]  [<ffffffff8d1677c6>] try_to_free_pages+0x516/0x970
[ 3111.432436]  [<ffffffff8d1f2c57>] ? __set_page_dirty+0x27/0xc0
[ 3111.433065]  [<ffffffff8d15af19>] __alloc_pages_nodemask+0x7a9/0xb00
[ 3111.433689]  [<ffffffff8d19e806>] alloc_pages_current+0x106/0x1f0
[ 3111.434304]  [<ffffffff8d040cb7>] ? pte_alloc_one+0x17/0x80
[ 3111.434911]  [<ffffffff8d040cb7>] pte_alloc_one+0x17/0x80
[ 3111.435510]  [<ffffffff8d17b4a7>] __pte_alloc+0x27/0x130
[ 3111.436098]  [<ffffffff8d17effc>] handle_mm_fault+0xafc/0xbb0
[ 3111.436681]  [<ffffffff8d17f27e>] __get_user_pages+0x1ce/0x620
[ 3111.437254]  [<ffffffff8d17f984>] get_dump_page+0x54/0x80
[ 3111.437810]  [<ffffffff8d219da9>] elf_core_dump+0x12d9/0x1420
[ 3111.438356]  [<ffffffff8d219330>] ? elf_core_dump+0x860/0x1420
[ 3111.438884]  [<ffffffff8d221ec2>] do_coredump+0xc02/0xf60
[ 3111.439398]  [<ffffffff8d081358>] get_signal_to_deliver+0x2b8/0x6b0
[ 3111.439898]  [<ffffffff8d0024d7>] do_signal+0x57/0x9d0
[ 3111.440386]  [<ffffffff8d11117e>] ? __acct_update_integrals+0x8e/0x120
[ 3111.440873]  [<ffffffff8d73a29b>] ? preempt_count_sub+0x6b/0xf0
[ 3111.441357]  [<ffffffff8d735ae1>] ? _raw_spin_unlock+0x31/0x50
[ 3111.441833]  [<ffffffff8d0ab671>] ? vtime_account_user+0x91/0xa0
[ 3111.442307]  [<ffffffff8d14f59b>] ? context_tracking_user_exit+0x9b/0x100
[ 3111.442783]  [<ffffffff8d002eac>] do_notify_resume+0x5c/0xa0
[ 3111.443260]  [<ffffffff8d736806>] retint_signal+0x46/0x90
[ 3111.443773] ------------[ cut here ]------------
[ 3111.444248] WARNING: CPU: 0 PID: 19213 at block/blk.h:227 generic_make_request_checks+0x33f/0x460()
[ 3111.444742] Modules linked in: fuse can_bcm can_raw scsi_transport_iscsi ipt_ULOG nfnetlink nfc caif_socket caif af_802154 phonet af_rxrpc can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 xfs libcrc32c coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr btusb bluetooth 6lowpan_iphc rfkill usb_debug snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e ptp pps_core shpchp snd_timer snd soundcore
[ 3111.447600] CPU: 0 PID: 19213 Comm: trinity-c46 Not tainted 3.14.0-rc2+ #113 
[ 3111.449427]  0000000000000009 000000004f998871 ffff88023715cc90 ffffffff8d72b091
[ 3111.450062]  0000000000000000 ffff88023715ccc8 ffffffff8d06d0cd ffff8801ef3a1440
[ 3111.450697]  00000000ffffffff 00000000197e5088 0000000000800005 ffff88024091b740
[ 3111.451339] Call Trace:
[ 3111.451968]  [<ffffffff8d72b091>] dump_stack+0x4e/0x7a
[ 3111.452608]  [<ffffffff8d06d0cd>] warn_slowpath_common+0x7d/0xa0
[ 3111.453247]  [<ffffffff8d06d1fa>] warn_slowpath_null+0x1a/0x20
[ 3111.453882]  [<ffffffff8d2e821f>] generic_make_request_checks+0x33f/0x460
[ 3111.454523]  [<ffffffff8d2e8367>] generic_make_request+0x27/0x130
[ 3111.455159]  [<ffffffff8d2e84e8>] submit_bio+0x78/0x160
[ 3111.455790]  [<ffffffff8d1f9060>] ? bio_alloc_bioset+0x180/0x210
[ 3111.456432]  [<ffffffffc031432b>] _xfs_buf_ioapply+0x2bb/0x3c0 [xfs]
[ 3111.457179]  [<ffffffffc03858f2>] ? xlog_bdstrat+0x22/0x60 [xfs]
[ 3111.457825]  [<ffffffffc031449b>] xfs_buf_iorequest+0x6b/0xf0 [xfs]
[ 3111.458472]  [<ffffffffc03858f2>] xlog_bdstrat+0x22/0x60 [xfs]
[ 3111.459120]  [<ffffffffc0387a87>] xlog_sync+0x3a7/0x5b0 [xfs]
[ 3111.459768]  [<ffffffffc0387d9f>] xlog_state_release_iclog+0x10f/0x120 [xfs]
[ 3111.460422]  [<ffffffffc0388840>] xlog_write+0x6f0/0x800 [xfs]
[ 3111.461069]  [<ffffffffc038a061>] xlog_cil_push+0x2f1/0x410 [xfs]
[ 3111.461714]  [<ffffffffc038a948>] xlog_cil_force_lsn+0x1d8/0x210 [xfs]
[ 3111.462349]  [<ffffffff8d1a6cd9>] ? __bit_spin_unlock.constprop.66+0x19/0x40
[ 3111.463001]  [<ffffffffc0389413>] _xfs_log_force_lsn+0x93/0x340 [xfs]
[ 3111.463654]  [<ffffffffc03896ee>] xfs_log_force_lsn+0x2e/0xb0 [xfs]
[ 3111.464311]  [<ffffffffc0374209>] ? xfs_iunpin_wait+0x19/0x20 [xfs]
[ 3111.464966]  [<ffffffffc0370b50>] __xfs_iunpin_wait+0xd0/0x1a0 [xfs]
[ 3111.465609]  [<ffffffff8d0b9dc0>] ? autoremove_wake_function+0x40/0x40
[ 3111.466266]  [<ffffffffc0374209>] xfs_iunpin_wait+0x19/0x20 [xfs]
[ 3111.466920]  [<ffffffffc031e50c>] xfs_reclaim_inode+0x8c/0x380 [xfs]
[ 3111.467573]  [<ffffffffc031ea7b>] xfs_reclaim_inodes_ag+0x27b/0x430 [xfs]
[ 3111.468226]  [<ffffffffc031e900>] ? xfs_reclaim_inodes_ag+0x100/0x430 [xfs]
[ 3111.468881]  [<ffffffffc031ed13>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
[ 3111.469535]  [<ffffffffc032afa5>] xfs_fs_free_cached_objects+0x15/0x20 [xfs]
[ 3111.470182]  [<ffffffff8d1c107c>] super_cache_scan+0x16c/0x180
[ 3111.470831]  [<ffffffff8d16225b>] shrink_slab_node+0x14b/0x2e0
[ 3111.471478]  [<ffffffff8d1644af>] ? shrink_slab+0x3f/0x180
[ 3111.472121]  [<ffffffff8d1644fe>] shrink_slab+0x8e/0x180
[ 3111.472761]  [<ffffffff8d1677c6>] try_to_free_pages+0x516/0x970
[ 3111.473401]  [<ffffffff8d1f2c57>] ? __set_page_dirty+0x27/0xc0
[ 3111.474040]  [<ffffffff8d15af19>] __alloc_pages_nodemask+0x7a9/0xb00
[ 3111.474670]  [<ffffffff8d19e806>] alloc_pages_current+0x106/0x1f0
[ 3111.475285]  [<ffffffff8d040cb7>] ? pte_alloc_one+0x17/0x80
[ 3111.475879]  [<ffffffff8d040cb7>] pte_alloc_one+0x17/0x80
[ 3111.476455]  [<ffffffff8d17b4a7>] __pte_alloc+0x27/0x130
[ 3111.477012]  [<ffffffff8d17effc>] handle_mm_fault+0xafc/0xbb0
[ 3111.477549]  [<ffffffff8d17f27e>] __get_user_pages+0x1ce/0x620
[ 3111.478072]  [<ffffffff8d17f984>] get_dump_page+0x54/0x80
[ 3111.478576]  [<ffffffff8d219da9>] elf_core_dump+0x12d9/0x1420
[ 3111.479065]  [<ffffffff8d219330>] ? elf_core_dump+0x860/0x1420
[ 3111.479546]  [<ffffffff8d221ec2>] do_coredump+0xc02/0xf60
[ 3111.480021]  [<ffffffff8d081358>] get_signal_to_deliver+0x2b8/0x6b0
[ 3111.480498]  [<ffffffff8d0024d7>] do_signal+0x57/0x9d0
[ 3111.480964]  [<ffffffff8d11117e>] ? __acct_update_integrals+0x8e/0x120
[ 3111.481435]  [<ffffffff8d73a29b>] ? preempt_count_sub+0x6b/0xf0
[ 3111.481906]  [<ffffffff8d735ae1>] ? _raw_spin_unlock+0x31/0x50
[ 3111.482377]  [<ffffffff8d0ab671>] ? vtime_account_user+0x91/0xa0
[ 3111.482847]  [<ffffffff8d14f59b>] ? context_tracking_user_exit+0x9b/0x100
[ 3111.483324]  [<ffffffff8d002eac>] do_notify_resume+0x5c/0xa0
[ 3111.483800]  [<ffffffff8d736806>] retint_signal+0x46/0x90
[ 3111.484274] ---[ end trace 8cc272739908f779 ]---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
