Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2MHY3Tu005163 for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 12:34:03 -0500
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	A2vGrQ4hcZfraSmS (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Mar 2012 10:34:02 -0700 (PDT)
Received: by vcge1 with SMTP id e1so2593759vcg.26
	for <xfs@oss.sgi.com>; Thu, 22 Mar 2012 10:34:01 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Mar 2012 13:34:00 -0400
Message-ID: <CALJQnoyM3V1Wntn5sHfxW2WwuCQuy6Qj9ukmb4WNLN5OV0ORqQ@mail.gmail.com>
Subject: bug #917 - deadlock on log recovery
From: Kirill Malkin <kirill.malkin@starboardstorage.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, xfs-masters@oss.sgi.com

Hi,

I am wondering if someone had a chance to look at the bug #917. I
filed it a couple of weeks ago, but haven=92t seen any action. We are
running into it quite a lot, and the only way out of it is to reboot
the OS and drop the log. Below is another stack trace that is slightly
different from the one I filed, but apparently it is the same bug.

Please let me know if you need any other input.

Thanks!
Kirill

[1185916.684850] mount=A0=A0=A0=A0=A0=A0=A0=A0 D ffff8808edc989c0=A0=A0=A0=
=A0 0=A0 6978=A0=A0=A0=A0=A0 1 0x00000000
[1185916.684853]=A0 ffff8802433632f8 0000000000000086 0000000000000000
0000000000000000
[1185916.684856]=A0 000000000000e488 ffff880243363fd8 ffff880443636280
ffff880c3cdd8180
[1185916.684860]=A0 ffff880443636608 000000063b49a400 0000000111a61ff6
ffff88065848e488
[1185916.684863] Call Trace:
[1185916.684866]=A0 [<ffffffff8150d44b>] ? dm_any_congested+0x6b/0x90
[1185916.684869]=A0 [<ffffffff816766ed>] schedule_timeout+0x1dd/0x260
[1185916.684871]=A0 [<ffffffff8150bfea>] ? dm_get_live_table+0x4a/0x60
[1185916.684874]=A0 [<ffffffff8167759e>] __down+0x6e/0xb0
[1185916.684877]=A0 [<ffffffff8135aad5>] ? _xfs_buf_find+0x145/0x280
[1185916.684879]=A0 [<ffffffff8108318c>] down+0x4c/0x50
[1185916.684882]=A0 [<ffffffff813599d0>] xfs_buf_lock+0x60/0xd0
[1185916.684884]=A0 [<ffffffff8135aad5>] _xfs_buf_find+0x145/0x280
[1185916.684887]=A0 [<ffffffff8135ac71>] xfs_buf_get+0x61/0x1c0
[1185916.684890]=A0 [<ffffffff8134fe6b>] xfs_trans_get_buf+0x13b/0x1c0
[1185916.684895]=A0 [<ffffffff8131cf94>] xfs_btree_get_buf_block+0x54/0x80
[1185916.684898]=A0 [<ffffffff813206a4>] xfs_btree_split+0x114/0x6a0
[1185916.684900]=A0 [<ffffffff8131e995>] ? xfs_btree_rshift+0x75/0x530
[1185916.684903]=A0 [<ffffffff8131d89d>] ? xfs_btree_lshift+0x7d/0x5f0
[1185916.684906]=A0 [<ffffffff81321151>] xfs_btree_make_block_unfull+0x151/=
0x190
[1185916.684909]=A0 [<ffffffff8132152c>] xfs_btree_insrec+0x39c/0x5b0
[1185916.684911]=A0 [<ffffffff8131dec7>] ? xfs_btree_lookup_get_block+0xb7/=
0xf0
[1185916.684915]=A0 [<ffffffff8131be72>] ? xfs_btree_rec_addr+0x12/0x20
[1185916.684917]=A0 [<ffffffff8131c0d8>] ? xfs_lookup_get_search_key+0x58/0=
x60
[1185916.684920]=A0 [<ffffffff813217c6>] xfs_btree_insert+0x86/0x180
[1185916.684925]=A0 [<ffffffff81306d01>] xfs_free_ag_extent+0x4f1/0x7a0
[1185916.684928]=A0 [<ffffffff81308850>] xfs_alloc_fix_freelist+0x120/0x490
[1185916.684931]=A0 [<ffffffff81342306>] ?
xlog_regrant_write_log_space+0x1e6/0x590
[1185916.684934]=A0 [<ffffffff81308c3c>] xfs_free_extent+0x7c/0xc0
[1185916.684938]=A0 [<ffffffff81312aa5>] xfs_bmap_finish+0x165/0x1b0
[1185916.684942]=A0 [<ffffffff81339065>] xfs_itruncate_finish+0x195/0x370
[1185916.684945]=A0 [<ffffffff8135526e>] xfs_inactive+0x3be/0x4e0
[1185916.684948]=A0 [<ffffffff8134f9f7>] ? xfs_trans_read_buf+0x217/0x410
[1185916.684951]=A0 [<ffffffff813616bd>] xfs_fs_clear_inode+0x9d/0xe0
[1185916.684954]=A0 [<ffffffff8114553e>] clear_inode+0x7e/0x100
[1185916.684957]=A0 [<ffffffff81145cc6>] generic_delete_inode+0x186/0x1c0
[1185916.684959]=A0 [<ffffffff81145d65>] generic_drop_inode+0x65/0x90
[1185916.684961]=A0 [<ffffffff81144892>] iput+0x62/0x70
[1185916.684964]=A0 [<ffffffff813471c9>]
xlog_recover_process_one_iunlink+0x169/0x180
[1185916.684967]=A0 [<ffffffff810830ca>] ? up+0x3a/0x50
[1185916.684969]=A0 [<ffffffff81347287>] xlog_recover_process_iunlinks+0xa7=
/0x130
[1185916.684972]=A0 [<ffffffff81347354>] xlog_recover_finish+0x44/0xd0
[1185916.684975]=A0 [<ffffffff813403fc>] xfs_log_mount_finish+0x2c/0x40
[1185916.684978]=A0 [<ffffffff8134b03a>] xfs_mountfs+0x48a/0x6f0
[1185916.684981]=A0 [<ffffffff81356003>] ? kmem_zalloc+0x33/0x50
[1185916.684984]=A0 [<ffffffff8134badb>] ? xfs_mru_cache_create+0x13b/0x170
[1185916.684987]=A0 [<ffffffff813631b5>] xfs_fs_fill_super+0x245/0x3a0
[1185916.684990]=A0 [<ffffffff8112e31c>] get_sb_bdev+0x17c/0x1e0
[1185916.684992]=A0 [<ffffffff810f9a61>] ? kstrdup+0x41/0x70
[1185916.684995]=A0 [<ffffffff81362f70>] ? xfs_fs_fill_super+0x0/0x3a0
[1185916.684998]=A0 [<ffffffff813612f8>] xfs_fs_get_sb+0x18/0x20
[1185916.685000]=A0 [<ffffffff8112cc9c>] vfs_kern_mount+0x5c/0xf0
[1185916.685002]=A0 [<ffffffff8112cda3>] do_kern_mount+0x53/0x120
[1185916.685005]=A0 [<ffffffff8114b80a>] do_mount+0x26a/0x8c0
[1185916.685008]=A0 [<ffffffff8114bf1b>] sys_mount+0xbb/0xf0
[1185916.685011]=A0 [<ffffffff8100c15b>] system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
