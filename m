Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LLgP4s032285 for <xfs@oss.sgi.com>; Fri, 21 May 2010 16:42:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BAB7A07C16
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 14:46:03 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 8QTEc6huo8azU265 for
	<xfs@oss.sgi.com>; Fri, 21 May 2010 14:46:03 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1085D800189
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 23:44:42 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id C453183C804
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 23:44:41 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: kernel crash: scheduling while atomic
Date: Fri, 21 May 2010 23:44:41 +0200
MIME-Version: 1.0
Message-Id: <201005212344.41367@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5708336121002867601=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5708336121002867601==
Content-Type: multipart/signed;
  boundary="nextPart2133492.X4gh1j7eho";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2133492.X4gh1j7eho
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Ist this caused by xfs?

I just rsynced from another server to this one, the filesystem is nearly fu=
ll,
I was in the process of vgextend (done), lvextend (done) and just wanted
to call xfs_growfs but before I could press enter the system was gone.
It's a VM within XenServer, if that matters.
Kernel 2.6.31.12-0.2-xen by openSUSE 11.2

[21877.948005] BUG: scheduling while atomic: rsync/2345/0xffff8800
[21877.948005] Modules linked in: af_packet nfs lockd fscache nfs_acl auth_=
rpcgss sunrpc ipv6 ramzswap xvmalloc lzo_decompress lzo_compress loop dm_mo=
d reiserfs xfs exportfs xennet xenblk cdrom
[21877.948005] Pid: 2345, comm: rsync Not tainted 2.6.31.12-0.2-xen #1
[21877.948005] Call Trace:
[21877.949649]  [<ffffffff800119b9>] try_stack_unwind+0x189/0x1b0
[21877.949659]  [<ffffffff8000f466>] dump_trace+0xa6/0x1e0
[21877.949666]  [<ffffffff800114c4>] show_trace_log_lvl+0x64/0x90
[21877.949676]  [<ffffffff80011513>] show_trace+0x23/0x40
[21877.949684]  [<ffffffff8046b92c>] dump_stack+0x81/0x9e
[21877.949695]  [<ffffffff8003f398>] __schedule_bug+0x78/0x90
[21877.949702]  [<ffffffff8046c97c>] thread_return+0x1d7/0x3fb
[21877.949709]  [<ffffffff8046cf85>] schedule_timeout+0x195/0x200
[21877.949717]  [<ffffffff8046be2b>] wait_for_common+0x10b/0x230
[21877.949726]  [<ffffffff8046c09b>] wait_for_completion+0x2b/0x50
[21877.949768]  [<ffffffffa009e741>] xfs_buf_iowait+0x31/0x80 [xfs]
[21877.949894]  [<ffffffffa009ea30>] _xfs_buf_read+0x70/0x80 [xfs]
[21877.949992]  [<ffffffffa009ef8b>] xfs_buf_read_flags+0x8b/0xd0 [xfs]
[21877.950089]  [<ffffffffa0091ab9>] xfs_trans_read_buf+0x1e9/0x320 [xfs]
[21877.950174]  [<ffffffffa005b278>] xfs_btree_read_buf_block+0x68/0xe0 [xf=
s]
[21877.950232]  [<ffffffffa005b99e>] xfs_btree_lookup_get_block+0x8e/0x110 =
[xfs]
[21877.950281]  [<ffffffffa005c0af>] xfs_btree_lookup+0xdf/0x4d0 [xfs]
[21877.950329]  [<ffffffffa0042b77>] xfs_alloc_lookup_eq+0x27/0x50 [xfs]
[21877.950361]  [<ffffffffa0042f09>] xfs_alloc_fixup_trees+0x249/0x370 [xfs]
[21877.950397]  [<ffffffffa0044c30>] xfs_alloc_ag_vextent_near+0x4e0/0x9a0 =
[xfs]
[21877.950432]  [<ffffffffa00451f5>] xfs_alloc_ag_vextent+0x105/0x160 [xfs]
[21877.950471]  [<ffffffffa0045bb4>] xfs_alloc_vextent+0x3b4/0x4b0 [xfs]
[21877.950504]  [<ffffffffa0058da8>] xfs_bmbt_alloc_block+0xf8/0x210 [xfs]
[21877.950550]  [<ffffffffa005e3b7>] xfs_btree_split+0xc7/0x720 [xfs]
[21877.950597]  [<ffffffffa005ef8c>] xfs_btree_make_block_unfull+0x15c/0x1c=
0 [xfs]
[21877.950643]  [<ffffffffa005f3ff>] xfs_btree_insrec+0x40f/0x5c0 [xfs]
[21877.950689]  [<ffffffffa005f651>] xfs_btree_insert+0xa1/0x1b0 [xfs]
[21877.950748]  [<ffffffffa005325e>] xfs_bmap_add_extent_delay_real+0x82e/0=
x12a0 [xfs]
[21877.950787]  [<ffffffffa00540f4>] xfs_bmap_add_extent+0x424/0x450 [xfs]
[21877.950833]  [<ffffffffa00573f3>] xfs_bmapi+0xda3/0x1320 [xfs]
[21877.950879]  [<ffffffffa007c248>] xfs_iomap_write_allocate+0x1d8/0x3f0 [=
xfs]
[21877.950953]  [<ffffffffa007d089>] xfs_iomap+0x2c9/0x300 [xfs]
[21877.951021]  [<ffffffffa009a1b8>] xfs_map_blocks+0x38/0x60 [xfs]
[21877.951108]  [<ffffffffa009b93a>] xfs_page_state_convert+0x3fa/0x720 [xf=
s]
[21877.951204]  [<ffffffffa009bde4>] xfs_vm_writepage+0x84/0x160 [xfs]
[21877.951301]  [<ffffffff800e3603>] pageout+0x143/0x2b0
[21877.951308]  [<ffffffff800e514e>] shrink_page_list+0x26e/0x650
[21877.951314]  [<ffffffff800e5803>] shrink_inactive_list+0x2d3/0x7c0
[21877.951320]  [<ffffffff800e5d4b>] shrink_list+0x5b/0x110
[21877.951325]  [<ffffffff800e5f71>] shrink_zone+0x171/0x250
[21877.951330]  [<ffffffff800e60d3>] shrink_zones+0x83/0x120
[21877.951336]  [<ffffffff800e620e>] do_try_to_free_pages+0x9e/0x380
[21877.951342]  [<ffffffff800e6607>] try_to_free_pages+0x77/0xa0
[21877.951349]  [<ffffffff800dbfa3>] __alloc_pages_slowpath+0x2d3/0x5c0
[21877.951355]  [<ffffffff800dc3e1>] __alloc_pages_nodemask+0x151/0x160
[21877.951362]  [<ffffffff800d44b7>] __page_cache_alloc+0x27/0x50
[21877.951368]  [<ffffffff800d68ca>] grab_cache_page_write_begin+0x9a/0xe0
[21877.951376]  [<ffffffff8014bdfe>] block_write_begin+0xae/0x120
[21877.951396]  [<ffffffffa009ac24>] xfs_vm_write_begin+0x34/0x50 [xfs]
[21877.951482]  [<ffffffff800d4b31>] generic_perform_write+0xc1/0x1f0
[21877.951489]  [<ffffffff800d5d00>] generic_file_buffered_write+0x90/0x160
[21877.951512]  [<ffffffffa00a4711>] xfs_write+0x521/0xb60 [xfs]
[21877.951624]  [<ffffffffa009fb80>] xfs_file_aio_write+0x70/0xa0 [xfs]
[21877.951711]  [<ffffffff80118c42>] do_sync_write+0x102/0x160
[21877.951718]  [<ffffffff80118fc8>] vfs_write+0xd8/0x1c0
[21877.951723]  [<ffffffff8011995b>] sys_write+0x5b/0xa0
[21877.951729]  [<ffffffff8000c868>] system_call_fastpath+0x16/0x1b
[21877.951736]  [<00007fc41b0fab10>] 0x7fc41b0fab10
[21877.951750] BUG: unable to handle kernel paging request at 0000000108743=
280
[21877.951755] IP: [<ffffffff80034832>] dequeue_task+0x72/0x110
[21877.951766] PGD 31c6f067 PUD 0=20
[21877.951770] Thread overran stack, or stack corrupted
[21877.951773] Oops: 0000 [#1] SMP=20
[21877.951777] last sysfs file: /sys/kernel/uevent_seqnum
[21877.951780] CPU 0=20
[21877.951783] Modules linked in: af_packet nfs lockd fscache nfs_acl auth_=
rpcgss sunrpc ipv6 ramzswap xvmalloc lzo_decompress lzo_compress loop dm_mo=
d reiserfs xfs exportfs xennet xenblk cdrom
[21877.951817] Pid: 2345, comm: rsync Not tainted 2.6.31.12-0.2-xen #1=20
[21877.951821] RIP: e030:[<ffffffff80034832>]  [<ffffffff80034832>] dequeue=
_task+0x72/0x110
[21877.951826] RSP: e02b:ffff880030ff80e8  EFLAGS: 00010012
[21877.951830] RAX: 000000000000a380 RBX: ffff880028d72700 RCX: 0000000030f=
f8028
[21877.951833] RDX: 0000000000000001 RSI: ffff880028d72700 RDI: ffffc900000=
0a380
[21877.951836] RBP: ffff880030ff8108 R08: ffff880030ff8000 R09: 00000000000=
00000
[21877.951839] R10: 00000000000010f3 R11: 0000000000000000 R12: 00000000000=
00000
[21877.951841] R13: ffff88000d864bf0 R14: 0000000000007d00 R15: 00000000000=
00000
[21877.951848] FS:  00007fc41bbc86f0(0000) GS:ffffc90000000000(0000) knlGS:=
000000000000000
[21877.951851] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[21877.951854] CR2: 0000000108743280 CR3: 0000000031c75000 CR4: 00000000000=
00660
[21877.951858] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[21877.951861] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[21877.951864] Process rsync (pid: 2345, threadinfo ffff880030ff8000, task =
ffff880028d72700)
[21877.951867] Stack:
[21877.951869]  ffff880030ff8138 0000000077adb4da 0000000000000000 ffffc900=
0000a380
[21877.951874] <0> ffff880030ff8138 ffffffff80034968 ffffc9000000a380 00000=
00077adb4da
[21877.951880] <0> ffff88000d864bf0 ffffc9000000a380 ffff880030ff8248 fffff=
fff8046c8fc
[21877.951892] Call Trace:
[21877.951898]  [<ffffffff80034968>] deactivate_task+0x38/0x60
[21877.951907]  [<ffffffff8046c8fc>] thread_return+0x157/0x3fb
[21877.951913]  [<ffffffff8046cf85>] schedule_timeout+0x195/0x200
[21877.951922]  [<ffffffff8046be2b>] wait_for_common+0x10b/0x230
[21877.951928]  [<ffffffff8046c09b>] wait_for_completion+0x2b/0x50
[21877.951953]  [<ffffffffa009e741>] xfs_buf_iowait+0x31/0x80 [xfs]
[21877.951991]  [<ffffffffa009ea30>] _xfs_buf_read+0x70/0x80 [xfs]
[21877.951991]  [<ffffffffa009ef8b>] xfs_buf_read_flags+0x8b/0xd0 [xfs]
[21877.951991]  [<ffffffffa0091ab9>] xfs_trans_read_buf+0x1e9/0x320 [xfs]
[21877.951991]  [<ffffffffa005b278>] xfs_btree_read_buf_block+0x68/0xe0 [xf=
s]
[21877.951991]  [<ffffffffa005b99e>] xfs_btree_lookup_get_block+0x8e/0x110 =
[xfs]
[21877.951991]  [<ffffffffa005c0af>] xfs_btree_lookup+0xdf/0x4d0 [xfs]
[21877.951991]  [<ffffffffa0042b77>] xfs_alloc_lookup_eq+0x27/0x50 [xfs]
[21877.951991]  [<ffffffffa0042f09>] xfs_alloc_fixup_trees+0x249/0x370 [xfs]
[21877.951991]  [<ffffffffa0044c30>] xfs_alloc_ag_vextent_near+0x4e0/0x9a0 =
[xfs]
[21877.951991]  [<ffffffffa00451f5>] xfs_alloc_ag_vextent+0x105/0x160 [xfs]
[21877.951991]  [<ffffffffa0045bb4>] xfs_alloc_vextent+0x3b4/0x4b0 [xfs]
[21877.951991]  [<ffffffffa0058da8>] xfs_bmbt_alloc_block+0xf8/0x210 [xfs]
[21877.951991]  [<ffffffffa005e3b7>] xfs_btree_split+0xc7/0x720 [xfs]
[21877.951991]  [<ffffffffa005ef8c>] xfs_btree_make_block_unfull+0x15c/0x1c=
0 [xfs]
[21877.951991]  [<ffffffffa005f3ff>] xfs_btree_insrec+0x40f/0x5c0 [xfs]
[21877.951991]  [<ffffffffa005f651>] xfs_btree_insert+0xa1/0x1b0 [xfs]
[21877.951991]  [<ffffffffa005325e>] xfs_bmap_add_extent_delay_real+0x82e/0=
x12a0 [xfs]
[21877.951991]  [<ffffffffa00540f4>] xfs_bmap_add_extent+0x424/0x450 [xfs]
[21877.951991]  [<ffffffffa00573f3>] xfs_bmapi+0xda3/0x1320 [xfs]
[21877.951991]  [<ffffffffa007c248>] xfs_iomap_write_allocate+0x1d8/0x3f0 [=
xfs]
[21877.951991]  [<ffffffffa007d089>] xfs_iomap+0x2c9/0x300 [xfs]
[21877.951991]  [<ffffffffa009a1b8>] xfs_map_blocks+0x38/0x60 [xfs]
[21877.951991]  [<ffffffffa009b93a>] xfs_page_state_convert+0x3fa/0x720 [xf=
s]
[21877.951991]  [<ffffffffa009bde4>] xfs_vm_writepage+0x84/0x160 [xfs]
[21877.951991]  [<ffffffff800e3603>] pageout+0x143/0x2b0
[21877.951991]  [<ffffffff800e514e>] shrink_page_list+0x26e/0x650
[21877.951991]  [<ffffffff800e5803>] shrink_inactive_list+0x2d3/0x7c0
[21877.951991]  [<ffffffff800e5d4b>] shrink_list+0x5b/0x110
[21877.951991]  [<ffffffff800e5f71>] shrink_zone+0x171/0x250
[21877.951991]  [<ffffffff800e60d3>] shrink_zones+0x83/0x120
[21877.951991]  [<ffffffff800e620e>] do_try_to_free_pages+0x9e/0x380
[21877.951991]  [<ffffffff800e6607>] try_to_free_pages+0x77/0xa0
[21877.951991]  [<ffffffff800dbfa3>] __alloc_pages_slowpath+0x2d3/0x5c0
[21877.951991]  [<ffffffff800dc3e1>] __alloc_pages_nodemask+0x151/0x160
[21877.951991]  [<ffffffff800d44b7>] __page_cache_alloc+0x27/0x50
[21877.951991]  [<ffffffff800d68ca>] grab_cache_page_write_begin+0x9a/0xe0
[21877.951991]  [<ffffffff8014bdfe>] block_write_begin+0xae/0x120
[21877.951991]  [<ffffffffa009ac24>] xfs_vm_write_begin+0x34/0x50 [xfs]
[21877.951991]  [<ffffffff800d4b31>] generic_perform_write+0xc1/0x1f0
[21877.951991]  [<ffffffff800d5d00>] generic_file_buffered_write+0x90/0x160
[21877.951991]  [<ffffffffa00a4711>] xfs_write+0x521/0xb60 [xfs]
[21877.951991]  [<ffffffffa009fb80>] xfs_file_aio_write+0x70/0xa0 [xfs]
[21877.951991]  [<ffffffff80118c42>] do_sync_write+0x102/0x160
[21877.951991]  [<ffffffff80118fc8>] vfs_write+0xd8/0x1c0
[21877.951991]  [<ffffffff8011995b>] sys_write+0x5b/0xa0
[21877.951991]  [<ffffffff8000c868>] system_call_fastpath+0x16/0x1b
[21877.951991]  [<00007fc41b0fab10>] 0x7fc41b0fab10
[21877.951991] Code: 00 48 29 c8 48 29 f0 48 c1 f8 03 48 01 f0 48 89 83 a0 =
00 00 00 4c 8b 43 08 4c 8b 8b 18 02 00 00 48 c7 c0 80 a3 00 00 41 8b 48 18 =
<48> 8b 0c cd 40 31 78 80 48 8b b4 08 40 08 00 00 31 c9 48 c7 83=20
[21877.951991] RIP  [<ffffffff80034832>] dequeue_task+0x72/0x110
[21877.951991]  RSP <ffff880030ff80e8>
[21877.951991] CR2: 0000000108743280
[21877.951991] ---[ end trace 4e4e8115170a7eca ]---


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2133492.X4gh1j7eho
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkv2/skACgkQzhSR9xwSCbSIaQCgwbwLNJkdYrjraiC/89NMvX0W
3moAnRi8xZvFMxGIUbb2E28o1WrG4w6B
=FB3a
-----END PGP SIGNATURE-----

--nextPart2133492.X4gh1j7eho--


--===============5708336121002867601==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5708336121002867601==--
