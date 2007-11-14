Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 Nov 2007 07:00:03 -0800 (PST)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.244])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAEExpa7029544
	for <xfs@oss.sgi.com>; Wed, 14 Nov 2007 06:59:54 -0800
Received: by an-out-0708.google.com with SMTP id d11so74181and
        for <xfs@oss.sgi.com>; Wed, 14 Nov 2007 06:59:57 -0800 (PST)
Message-ID: <e4eb41060711140635l4c96795cq18841150d2f7287f@mail.gmail.com>
Date: Wed, 14 Nov 2007 15:35:53 +0100
From: "=?ISO-8859-2?Q?Rafa=B3_Rzepecki?=" <divided.mind@gmail.com>
Subject: Possible bug in XFS causing scheduling while atomic BUG in Linux 2.6.23
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

Please forgive me if it's not the right place to report that (and do
point me to the right place in that case); I also apologize if this
report is missing any important information: this is my first time
reporting a kernel bug.

Anyway, I've run into a kernel bug, and from the trace I assume it's
xfs's fault.
Relevant messages:
Nov 14 14:47:18 [kernel] BUG: scheduling while atomic: mlnet/0x00000002/11031
Nov 14 14:47:18 [kernel]  [<c04841ce>] __sched_text_start+0x2be/0x397
Nov 14 14:47:18 [kernel]  [<c04859d4>] __down+0x7e/0x112
Nov 14 14:47:18 [kernel]  [<c0118a69>] default_wake_function+0x0/0xc
Nov 14 14:47:18 [kernel]  [<c0485903>] __down_failed+0x7/0xc
Nov 14 14:47:18 [kernel]  [<c0283cb5>] xfs_buf_lock+0x2d/0x35
Nov 14 14:47:18 [kernel]  [<c0270d40>] xfs_getsb+0x25/0x32
Nov 14 14:47:18 [kernel]  [<c027556f>] xfs_trans_getsb+0x2d/0x8f
Nov 14 14:47:18 [kernel]  [<c0273cb8>] xfs_trans_apply_sb_deltas+0x15/0x5cd
Nov 14 14:47:18 [kernel]  [<c022a6e1>] xfs_alloc_mark_busy+0xa3/0xb1
Nov 14 14:47:18 [kernel]  [<c02745f0>] _xfs_trans_commit+0x90/0x32c
Nov 14 14:47:18 [kernel]  [<c022a628>] xfs_free_extent+0xcd/0xe3
Nov 14 14:47:18 [kernel]  [<c028111a>] kmem_zone_alloc+0x45/0xbc
Nov 14 14:47:18 [kernel]  [<c023bd69>] xfs_bmap_finish+0x11e/0x169
Nov 14 14:47:18 [kernel]  [<c02811b7>] kmem_zone_zalloc+0x26/0x4f
Nov 14 14:47:18 [kernel]  [<c025d799>] xfs_itruncate_finish+0x168/0x3f8
Nov 14 14:47:18 [kernel]  [<c0275ff2>] xfs_trans_ijoin+0x2b/0x86
Nov 14 14:47:18 [kernel]  [<c027b3ba>] xfs_free_eofblocks+0x2a4/0x2db
Nov 14 14:47:18 [kernel]  [<c027bb15>] xfs_release+0x1b1/0x21b
Nov 14 14:47:18 [kernel]  [<c0172403>] d_kill+0x40/0x52
Nov 14 14:47:18 [kernel]  [<c0285411>] xfs_file_release+0x13/0x1a
Nov 14 14:47:18 [kernel]  [<c0162f72>] __fput+0x14d/0x17d
Nov 14 14:47:18 [kernel]  [<c01616eb>] filp_close+0x3c/0x7b
Nov 14 14:47:18 [kernel]  [<c011e0bd>] close_files+0x71/0x93
Nov 14 14:47:18 [kernel]  [<c011e13e>] put_files_struct+0x27/0x6b
Nov 14 14:47:18 [kernel]  [<c011eb4e>] do_exit+0x14d/0x43f
Nov 14 14:47:18 [kernel]  [<c0103cb9>] do_trap+0x0/0x10c
Nov 14 14:47:18 [kernel]  [<c0113329>] do_page_fault+0x2c5/0x62c
Nov 14 14:47:18 [kernel]  [<c0113064>] do_page_fault+0x0/0x62c
Nov 14 14:47:18 [kernel]  [<c0485cda>] error_code+0x6a/0x70
Nov 14 14:47:18 [kernel]  [<c0118a88>] __wake_up_common+0x13/0x56
Nov 14 14:47:18 [kernel]  [<c01028b2>] need_resched+0x1f/0x21
Nov 14 14:47:18 [kernel]  [<c0118afc>] __wake_up+0x31/0x63
Nov 14 14:47:18 [kernel]  [<c0283d1d>] xfs_buf_unpin+0x29/0x2d
Nov 14 14:47:18 [kernel]  [<c0245a2f>] xfs_buf_item_unpin+0x34/0xc2
Nov 14 14:47:18 [kernel]  [<c0274d38>] xfs_trans_chunk_committed+0x11a/0x156
Nov 14 14:47:18 [kernel]  [<c0274c0f>] xfs_trans_committed+0xdb/0xea
Nov 14 14:47:18 [kernel]  [<c0267d78>] xlog_state_do_callback+0x148/0x2e3
Nov 14 14:47:18 [kernel]  [<c0283e0e>] xfs_buf_iodone_work+0x24/0x2f
Nov 14 14:47:18 [kernel]  [<c028431c>] xfs_buf_iorequest+0x63/0x65
Nov 14 14:47:18 [kernel]  [<c0266865>] xlog_bdstrat_cb+0x16/0x3d
Nov 14 14:47:18 [kernel]  [<c0267155>] xlog_sync+0x206/0x483
Nov 14 14:47:18 [kernel]  [<c0274d8a>] xfs_trans_tail_ail+0x16/0x44
Nov 14 14:47:18 [kernel]  [<c0268c70>] xlog_state_sync_all+0x1b0/0x269
Nov 14 14:47:18 [kernel]  [<c027569c>] xfs_trans_read_buf+0xcb/0x34e
Nov 14 14:47:18 [kernel]  [<c0265cd3>] _xfs_log_force+0x58/0x5e
Nov 14 14:47:18 [kernel]  [<c025a9f7>] xfs_iget_core+0x4ca/0x74f
Nov 14 14:47:18 [kernel]  [<c028a39c>] xfs_fs_alloc_inode+0xf/0x1c
Nov 14 14:47:18 [kernel]  [<c025ad3c>] xfs_iget+0xc0/0x11e
Nov 14 14:47:18 [kernel]  [<c0275f1e>] xfs_trans_iget+0xc2/0x16b
Nov 14 14:47:18 [kernel]  [<c025cf1e>] xfs_ialloc+0xcf/0x5d7
Nov 14 14:47:18 [kernel]  [<c0276919>] xfs_dir_ialloc+0x85/0x2aa
Nov 14 14:47:18 [kernel]  [<c0273961>] xfs_trans_reserve+0x80/0x1e6
Nov 14 14:47:18 [kernel]  [<c027c38d>] xfs_create+0x248/0x684
Nov 14 14:47:18 [kernel]  [<c02263ca>] xfs_acl_vhasacl_default+0x3a/0x4b
Nov 14 14:47:18 [kernel]  [<c0287b08>] xfs_vn_mknod+0x246/0x370
Nov 14 14:47:18 [kernel]  [<c028811f>] xfs_vn_permission+0xf/0x13
Nov 14 14:47:18 [kernel]  [<c0288110>] xfs_vn_permission+0x0/0x13
Nov 14 14:47:18 [kernel]  [<c0168cfa>] permission+0xd6/0xe9
Nov 14 14:47:18 [kernel]  [<c016aad1>] vfs_create+0x8a/0xd8
Nov 14 14:47:18 [kernel]  [<c016ad57>] open_namei_create+0x53/0xae
Nov 14 14:47:18 [kernel]  [<c016b328>] open_namei+0x576/0x589
Nov 14 14:47:18 [kernel]  [<c016129e>] do_filp_open+0x2e/0x5b
Nov 14 14:47:18 [kernel]  [<c0161424>] get_unused_fd_flags+0x31/0xde
Nov 14 14:47:18 [kernel]  [<c01615be>] do_sys_open+0x50/0xdd
Nov 14 14:47:18 [kernel]  [<c0161667>] sys_open+0x1c/0x20
Nov 14 14:47:18 [kernel]  [<c010291a>] sysenter_past_esp+0x5f/0x85
Nov 14 14:47:18 [kernel]  =======================

I haven't been doing anything in particular when that showed up, so I
can't say what could have caused it. Anything more I can tell is that
the system has been spinning with that bug for at least an hour: I
have relatively short logs, so the earliest saved message is from
13:50 and it's exactly the same trace.

Output from ver_linux:
Linux divide 2.6.23-gentoo #5 PREEMPT Thu Nov 1 03:29:13 CET 2007 i686
Intel(R) Celeron(R) CPU 2.26GHz GenuineIntel GNU/Linux

Gnu C                  3.4.3-20050110
Gnu make               3.81
binutils               2.17
util-linux             2.13
mount                  2.13
module-init-tools      3.1
e2fsprogs              1.36
reiserfsprogs          3.6.12
xfsprogs               2.6.25
PPP                    2.4.1
Linux C Library        2.6
Dynamic linker (ldd)   2.6
Procps                 3.1.11
Net-tools              1.60
Kbd                    1.08
oprofile               0.9.3
Sh-utils               6.9
udev                   103
wireless-tools         29
Modules Loaded         lp irtty_sir sir_dev ns558 gameport rtc_cmos
nvidia r8180 ieee80211_rtl ieee80211_crypt_rtl

If I can provide any more information, please don't hesitate to ask.
Note that I'm using the gentoo flavour of kernel, so if I should
report this first to Gentoo, do tell me that.

ps. I'm not subscribed to the list, so I'd appreciate if any
follow-ups were CCed to me.
-- 
Kind regards
- Rafa³ Rzepecki
