Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7285E7F55
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 03:18:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63CD8304032
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 01:18:33 -0700 (PDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id XvUyT668PbSqRQ6Q
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Jun 2015 01:18:24 -0700 (PDT)
Received: by wgqq4 with SMTP id q4so2584771wgq.1
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 01:18:23 -0700 (PDT)
Message-ID: <358C712AD1904865BE275A629A9AAECE@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Date: Tue, 23 Jun 2015 10:18:21 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9031551461419202112=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, hch@lst.de

This is a multi-part message in MIME format.

--===============9031551461419202112==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0012_01D0AD9D.EE83A520"

This is a multi-part message in MIME format.

------=_NextPart_000_0012_01D0AD9D.EE83A520
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Greetings,

We are hitting an issue with XFS printing messages like
=E2=80=9CXFS: possible memory allocation deadlock in kmem_alloc =
(mode:0x250)=E2=80=9D
and stack trace like in [1]. Eventually, hung-task panic kicks in with =
stack traces like [2].

We are running kernel 3.8.13. I see that in =
http://oss.sgi.com/archives/xfs/2012-01/msg00341.html a similar issue =
has been discussed, but no code changes followed comparing to what we =
have in 3.8.13.

Any suggestion on how to move forward with this problem? For example, =
does this memory has to be really allocated with kmalloc (i.e., =
physically continuous) or vmalloc can be used?

Thanks,
Alex.

[1]
[109626.075483] nfsd            D 0000000000000002     0 20042      2 =
0x00000000
[109626.075483]  ffff88026ac3ef58 0000000000000046 ffff88031fffbd80 =
ffff88026ac40000
[109626.075483]  ffff88026ac3ffd8 ffff88026ac3ffd8 ffff88026ac3ffd8 =
0000000000013f40
[109626.075483]  ffff88030e542e80 ffff88026ac40000 ffff88030e58c000 =
ffff88026ac3ef90
[109626.075483] Call Trace:
[109626.075483]  [<ffffffff816ec509>] schedule+0x29/0x70
[109626.075483]  [<ffffffff816eabd0>] schedule_timeout+0x130/0x250
[109626.075483]  [<ffffffff8106a340>] ? cascade+0xa0/0xa0
[109626.075483]  [<ffffffff816ec8a2>] io_schedule_timeout+0xa2/0x100
[109626.075483]  [<ffffffff81185311>] ? __kmalloc+0x181/0x190
[109626.075483]  [<ffffffff81153bc0>] congestion_wait+0x80/0x120
[109626.075483]  [<ffffffff81185311>] ? __kmalloc+0x181/0x190
[109626.075483]  [<ffffffff8107fc10>] ? add_wait_queue+0x60/0x60
[109626.075483]  [<ffffffff81185260>] ? __kmalloc+0xd0/0x190
[109626.075483]  [<ffffffffa07631fc>] ? kmem_alloc+0x5c/0xe0 [xfs]
[109626.075483]  [<ffffffffa0763330>] ? kmem_realloc+0x30/0x70 [xfs]
[109626.075483]  [<ffffffffa0795f0d>] ? =
xfs_iext_realloc_indirect+0x3d/0x60 [xfs]
[109626.075483]  [<ffffffffa0795f6f>] ? xfs_iext_irec_new+0x3f/0x180 =
[xfs]
[109626.075483]  [<ffffffffa0796229>] ? =
xfs_iext_add_indirect_multi+0x179/0x2b0 [xfs]
[109626.075483]  [<ffffffffa079662e>] ? xfs_iext_add+0xce/0x290 [xfs]
[109626.075483]  [<ffffffff81097c33>] ? update_curr+0x143/0x1f0
[109626.075483]  [<ffffffffa0796842>] ? xfs_iext_insert+0x52/0x100 [xfs]
[109626.075483]  [<ffffffffa0771b43>] ? =
xfs_bmap_add_extent_hole_delay+0xd3/0x6a0 [xfs]
[109626.075483]  [<ffffffffa0771b43>] ? =
xfs_bmap_add_extent_hole_delay+0xd3/0x6a0 [xfs]
[109626.075483]  [<ffffffffa07950d7>] ? xfs_iext_bno_to_ext+0xf7/0x160 =
[xfs]
[109626.075483]  [<ffffffffa0772389>] ? =
xfs_bmapi_reserve_delalloc+0x279/0x2a0 [xfs]
[109626.075483]  [<ffffffffa07793b2>] ? xfs_bmapi_delay+0x122/0x270 =
[xfs]
[109626.075483]  [<ffffffffa0758703>] ? =
xfs_iomap_write_delay+0x173/0x320 [xfs]
[109626.075483]  [<ffffffffa077909c>] ? xfs_bmapi_read+0xfc/0x2f0 [xfs]
[109626.075483]  [<ffffffff8135d8f3>] ? =
call_rwsem_down_write_failed+0x13/0x20
[109626.075483]  [<ffffffffa0745b40>] ? __xfs_get_blocks+0x280/0x550 =
[xfs]
[109626.075483]  [<ffffffffa0745e41>] ? xfs_get_blocks+0x11/0x20 [xfs]
[109626.075483]  [<ffffffff811cf77e>] ? __block_write_begin+0x1ae/0x4e0
[109626.075483]  [<ffffffffa0745e30>] ? xfs_get_blocks_direct+0x20/0x20 =
[xfs]
[109626.075483]  [<ffffffff81135fff>] ? =
grab_cache_page_write_begin+0x8f/0xf0
[109626.075483]  [<ffffffffa074509f>] ? xfs_vm_write_begin+0x5f/0xe0 =
[xfs]
[109626.075483]  [<ffffffff8113552a>] ? generic_perform_write+0xca/0x210
[109626.075483]  [<ffffffff811356cd>] ? =
generic_file_buffered_write+0x5d/0x90
[109626.075483]  [<ffffffffa07502d5>] ? =
xfs_file_buffered_aio_write+0x115/0x1c0 [xfs]
[109626.075483]  [<ffffffff816159f4>] ? ip_finish_output+0x224/0x3b0
[109626.075483]  [<ffffffffa075047c>] ? xfs_file_aio_write+0xfc/0x1b0 =
[xfs]
[109626.075483]  [<ffffffffa0750380>] ? =
xfs_file_buffered_aio_write+0x1c0/0x1c0 [xfs]
[109626.075483]  [<ffffffff8119b8c3>] ? do_sync_readv_writev+0xa3/0xe0
[109626.075483]  [<ffffffff8119bb8d>] ? do_readv_writev+0xcd/0x1d0
[109626.075483]  [<ffffffff810877e0>] ? set_groups+0x40/0x60
[109626.075483]  [<ffffffffa01be6b0>] ? nfsd_setuser+0x120/0x2b0 [nfsd]
[109626.075483]  [<ffffffff8119bccc>] ? vfs_writev+0x3c/0x50
[109626.075483]  [<ffffffffa01b7dd2>] ? =
nfsd_vfs_write.isra.12+0x92/0x350 [nfsd]
[109626.075483]  [<ffffffff8119a6cb>] ? dentry_open+0x6b/0xd0
[109626.075483]  [<ffffffffa01ba679>] ? nfsd_write+0xf9/0x110 [nfsd]
[109626.075483]  [<ffffffffa01c4dd1>] ? nfsd3_proc_write+0xb1/0x140 =
[nfsd]
[109626.075483]  [<ffffffffa01b3d62>] ? nfsd_dispatch+0x102/0x270 [nfsd]
[109626.075483]  [<ffffffffa012bb48>] ? svc_process_common+0x328/0x5e0 =
[sunrpc]
[109626.075483]  [<ffffffffa012c153>] ? svc_process+0x103/0x160 [sunrpc]
[109626.075483]  [<ffffffffa01b372f>] ? nfsd+0xbf/0x130 [nfsd]
[109626.075483]  [<ffffffffa01b3670>] ? nfsd_destroy+0x80/0x80 [nfsd]
[109626.075483]  [<ffffffff8107f050>] ? kthread+0xc0/0xd0
[109626.075483]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
[109626.075483]  [<ffffffff816f61ec>] ? ret_from_fork+0x7c/0xb0
[109626.075483]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0

[2]
[87303.976119] INFO: task nfsd:5684 blocked for more than 180 seconds.
[87303.976976] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" =
disables this message.
[87303.978012] nfsd            D 0000000000000003     0  5684      2 =
0x00000000
[87303.978017]  ffff8802506d37e8 0000000000000046 ffff880200000000 =
ffff880307ce3c9c
[87303.978020]  ffff8802506d3fd8 ffff8802506d3fd8 ffff8802506d3fd8 =
0000000000013f40
[87303.978023]  ffff88030e5445c0 ffff8802ca9945c0 ffff8802506d37c8 =
ffff88009dd8fd60
[87303.978026] Call Trace:
[87303.978036]  [<ffffffff816ec509>] schedule+0x29/0x70
[87303.978039]  [<ffffffff816ec7be>] schedule_preempt_disabled+0xe/0x10
[87303.978042]  [<ffffffff816eb437>] __mutex_lock_slowpath+0xd7/0x150
[87303.978045]  [<ffffffff816eb04a>] mutex_lock+0x2a/0x50
[87303.978076]  [<ffffffffa075a227>] =
xfs_file_buffered_aio_write+0x67/0x1c0 [xfs]
[87303.978089]  [<ffffffffa075a47c>] xfs_file_aio_write+0xfc/0x1b0 [xfs]
[87303.978101]  [<ffffffffa075a380>] ? =
xfs_file_buffered_aio_write+0x1c0/0x1c0 [xfs]
[87303.978105]  [<ffffffff8119b8c3>] do_sync_readv_writev+0xa3/0xe0
[87303.978109]  [<ffffffff8119bb8d>] do_readv_writev+0xcd/0x1d0
[87303.978112]  [<ffffffff811afe51>] ? prepend_path+0xf1/0x1e0
[87303.978115]  [<ffffffff811856fc>] ? =
kmem_cache_alloc_trace+0x11c/0x140
[87303.978119]  [<ffffffff8130c425>] ? aa_alloc_task_context+0x35/0x50
[87303.978122]  [<ffffffff8119bccc>] vfs_writev+0x3c/0x50
[87303.978145]  [<ffffffffa0266dd2>] nfsd_vfs_write.isra.12+0x92/0x350 =
[nfsd]
[87303.978149]  [<ffffffff816ed43e>] ? _raw_spin_lock+0xe/0x20
[87303.978159]  [<ffffffffa0284ba4>] ? =
find_confirmed_client.isra.58+0x144/0x1a0 [nfsd]
[87303.978167]  [<ffffffffa0284d48>] ? nfsd4_lookup_stateid+0xc8/0x120 =
[nfsd]
[87303.978174]  [<ffffffffa0269623>] nfsd_write+0xa3/0x110 [nfsd]
[87303.978182]  [<ffffffffa027794c>] nfsd4_write+0x1cc/0x250 [nfsd]
[87303.978189]  [<ffffffffa027746c>] nfsd4_proc_compound+0x5ac/0x7a0 =
[nfsd]
[87303.978197]  [<ffffffffa0262d62>] nfsd_dispatch+0x102/0x270 [nfsd]
[87303.978214]  [<ffffffffa01f3b48>] svc_process_common+0x328/0x5e0 =
[sunrpc]
[87303.978225]  [<ffffffffa01f4153>] svc_process+0x103/0x160 [sunrpc]
[87303.978232]  [<ffffffffa026272f>] nfsd+0xbf/0x130 [nfsd]
[87303.978238]  [<ffffffffa0262670>] ? nfsd_destroy+0x80/0x80 [nfsd]
[87303.978243]  [<ffffffff8107f050>] kthread+0xc0/0xd0
[87303.978246]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
[87303.978250]  [<ffffffff816f61ec>] ret_from_fork+0x7c/0xb0
[87303.978253]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
------=_NextPart_000_0012_01D0AD9D.EE83A520
Content-Type: text/html;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<HTML><HEAD></HEAD>
<BODY dir=3Dltr>
<DIV dir=3Dltr>
<DIV style=3D"FONT-FAMILY: 'Verdana'; COLOR: #000000; FONT-SIZE: 10pt">
<DIV>Greetings,</DIV>
<DIV>&nbsp;</DIV>
<DIV>We are hitting an issue with XFS printing messages like</DIV>
<DIV>=E2=80=9CXFS: possible memory allocation deadlock in kmem_alloc =
(mode:0x250)=E2=80=9D</DIV>
<DIV>and stack trace like in [1]. Eventually, hung-task panic kicks in =
with=20
stack traces like [2].</DIV>
<DIV>&nbsp;</DIV>
<DIV>We are running kernel 3.8.13. I see that in <A=20
title=3Dhttp://oss.sgi.com/archives/xfs/2012-01/msg00341.html=20
href=3D"http://oss.sgi.com/archives/xfs/2012-01/msg00341.html">http://oss=
.sgi.com/archives/xfs/2012-01/msg00341.html</A>=20
a similar issue has been discussed, but no code changes followed =
comparing to=20
what we have in 3.8.13.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Any suggestion on how to move forward with this problem? For =
example, does=20
this memory has to be really allocated with kmalloc (i.e., physically=20
continuous) or vmalloc can be used?</DIV>
<DIV>&nbsp;</DIV>
<DIV>Thanks,</DIV>
<DIV>Alex.</DIV>
<DIV>&nbsp;</DIV>
<DIV>[1]</DIV>
<DIV>[109626.075483]=20
nfsd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D =

0000000000000002&nbsp;&nbsp;&nbsp;&nbsp; 0 =
20042&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2=20
0x00000000</DIV>
<DIV>[109626.075483]&nbsp; ffff88026ac3ef58 0000000000000046 =
ffff88031fffbd80=20
ffff88026ac40000</DIV>
<DIV>[109626.075483]&nbsp; ffff88026ac3ffd8 ffff88026ac3ffd8 =
ffff88026ac3ffd8=20
0000000000013f40</DIV>
<DIV>[109626.075483]&nbsp; ffff88030e542e80 ffff88026ac40000 =
ffff88030e58c000=20
ffff88026ac3ef90</DIV>
<DIV>[109626.075483] Call Trace:</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff816ec509&gt;] =
schedule+0x29/0x70</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff816eabd0&gt;]=20
schedule_timeout+0x130/0x250</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8106a340&gt;] ? =
cascade+0xa0/0xa0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff816ec8a2&gt;]=20
io_schedule_timeout+0xa2/0x100</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff81185311&gt;] ?=20
__kmalloc+0x181/0x190</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff81153bc0&gt;]=20
congestion_wait+0x80/0x120</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff81185311&gt;] ?=20
__kmalloc+0x181/0x190</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8107fc10&gt;] ?=20
add_wait_queue+0x60/0x60</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff81185260&gt;] ?=20
__kmalloc+0xd0/0x190</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa07631fc&gt;] ? =
kmem_alloc+0x5c/0xe0=20
[xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0763330&gt;] ? =
kmem_realloc+0x30/0x70=20
[xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0795f0d&gt;] ?=20
xfs_iext_realloc_indirect+0x3d/0x60 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0795f6f&gt;] ?=20
xfs_iext_irec_new+0x3f/0x180 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0796229&gt;] ?=20
xfs_iext_add_indirect_multi+0x179/0x2b0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa079662e&gt;] ? =
xfs_iext_add+0xce/0x290=20
[xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff81097c33&gt;] ?=20
update_curr+0x143/0x1f0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0796842&gt;] ?=20
xfs_iext_insert+0x52/0x100 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0771b43&gt;] ?=20
xfs_bmap_add_extent_hole_delay+0xd3/0x6a0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0771b43&gt;] ?=20
xfs_bmap_add_extent_hole_delay+0xd3/0x6a0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa07950d7&gt;] ?=20
xfs_iext_bno_to_ext+0xf7/0x160 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0772389&gt;] ?=20
xfs_bmapi_reserve_delalloc+0x279/0x2a0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa07793b2&gt;] ?=20
xfs_bmapi_delay+0x122/0x270 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0758703&gt;] ?=20
xfs_iomap_write_delay+0x173/0x320 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa077909c&gt;] ?=20
xfs_bmapi_read+0xfc/0x2f0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8135d8f3&gt;] ?=20
call_rwsem_down_write_failed+0x13/0x20</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0745b40&gt;] ?=20
__xfs_get_blocks+0x280/0x550 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0745e41&gt;] ? =
xfs_get_blocks+0x11/0x20=20
[xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff811cf77e&gt;] ?=20
__block_write_begin+0x1ae/0x4e0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0745e30&gt;] ?=20
xfs_get_blocks_direct+0x20/0x20 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff81135fff&gt;] ?=20
grab_cache_page_write_begin+0x8f/0xf0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa074509f&gt;] ?=20
xfs_vm_write_begin+0x5f/0xe0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8113552a&gt;] ?=20
generic_perform_write+0xca/0x210</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff811356cd&gt;] ?=20
generic_file_buffered_write+0x5d/0x90</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa07502d5&gt;] ?=20
xfs_file_buffered_aio_write+0x115/0x1c0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff816159f4&gt;] ?=20
ip_finish_output+0x224/0x3b0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa075047c&gt;] ?=20
xfs_file_aio_write+0xfc/0x1b0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa0750380&gt;] ?=20
xfs_file_buffered_aio_write+0x1c0/0x1c0 [xfs]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8119b8c3&gt;] ?=20
do_sync_readv_writev+0xa3/0xe0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8119bb8d&gt;] ?=20
do_readv_writev+0xcd/0x1d0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff810877e0&gt;] ?=20
set_groups+0x40/0x60</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01be6b0&gt;] ? =
nfsd_setuser+0x120/0x2b0=20
[nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8119bccc&gt;] ?=20
vfs_writev+0x3c/0x50</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01b7dd2&gt;] ?=20
nfsd_vfs_write.isra.12+0x92/0x350 [nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8119a6cb&gt;] ?=20
dentry_open+0x6b/0xd0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01ba679&gt;] ? =
nfsd_write+0xf9/0x110=20
[nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01c4dd1&gt;] ?=20
nfsd3_proc_write+0xb1/0x140 [nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01b3d62&gt;] ?=20
nfsd_dispatch+0x102/0x270 [nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa012bb48&gt;] ?=20
svc_process_common+0x328/0x5e0 [sunrpc]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa012c153&gt;] ? =
svc_process+0x103/0x160=20
[sunrpc]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01b372f&gt;] ? nfsd+0xbf/0x130=20
[nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffffa01b3670&gt;] ? =
nfsd_destroy+0x80/0x80=20
[nfsd]</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8107f050&gt;] ? =
kthread+0xc0/0xd0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8107ef90&gt;] ?=20
flush_kthread_worker+0xb0/0xb0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff816f61ec&gt;] ?=20
ret_from_fork+0x7c/0xb0</DIV>
<DIV>[109626.075483]&nbsp; [&lt;ffffffff8107ef90&gt;] ?=20
flush_kthread_worker+0xb0/0xb0</DIV>
<DIV>&nbsp;</DIV>
<DIV>[2]</DIV>
<DIV>[87303.976119] INFO: task nfsd:5684 blocked for more than 180=20
seconds.</DIV>
<DIV>[87303.976976] "echo 0 &gt; =
/proc/sys/kernel/hung_task_timeout_secs"=20
disables this message.</DIV>
<DIV>[87303.978012]=20
nfsd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D =

0000000000000003&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;=20
5684&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 0x00000000</DIV>
<DIV>[87303.978017]&nbsp; ffff8802506d37e8 0000000000000046 =
ffff880200000000=20
ffff880307ce3c9c</DIV>
<DIV>[87303.978020]&nbsp; ffff8802506d3fd8 ffff8802506d3fd8 =
ffff8802506d3fd8=20
0000000000013f40</DIV>
<DIV>[87303.978023]&nbsp; ffff88030e5445c0 ffff8802ca9945c0 =
ffff8802506d37c8=20
ffff88009dd8fd60</DIV>
<DIV>[87303.978026] Call Trace:</DIV>
<DIV>[87303.978036]&nbsp; [&lt;ffffffff816ec509&gt;] =
schedule+0x29/0x70</DIV>
<DIV>[87303.978039]&nbsp; [&lt;ffffffff816ec7be&gt;]=20
schedule_preempt_disabled+0xe/0x10</DIV>
<DIV>[87303.978042]&nbsp; [&lt;ffffffff816eb437&gt;]=20
__mutex_lock_slowpath+0xd7/0x150</DIV>
<DIV>[87303.978045]&nbsp; [&lt;ffffffff816eb04a&gt;] =
mutex_lock+0x2a/0x50</DIV>
<DIV>[87303.978076]&nbsp; [&lt;ffffffffa075a227&gt;]=20
xfs_file_buffered_aio_write+0x67/0x1c0 [xfs]</DIV>
<DIV>[87303.978089]&nbsp; [&lt;ffffffffa075a47c&gt;]=20
xfs_file_aio_write+0xfc/0x1b0 [xfs]</DIV>
<DIV>[87303.978101]&nbsp; [&lt;ffffffffa075a380&gt;] ?=20
xfs_file_buffered_aio_write+0x1c0/0x1c0 [xfs]</DIV>
<DIV>[87303.978105]&nbsp; [&lt;ffffffff8119b8c3&gt;]=20
do_sync_readv_writev+0xa3/0xe0</DIV>
<DIV>[87303.978109]&nbsp; [&lt;ffffffff8119bb8d&gt;]=20
do_readv_writev+0xcd/0x1d0</DIV>
<DIV>[87303.978112]&nbsp; [&lt;ffffffff811afe51&gt;] ?=20
prepend_path+0xf1/0x1e0</DIV>
<DIV>[87303.978115]&nbsp; [&lt;ffffffff811856fc&gt;] ?=20
kmem_cache_alloc_trace+0x11c/0x140</DIV>
<DIV>[87303.978119]&nbsp; [&lt;ffffffff8130c425&gt;] ?=20
aa_alloc_task_context+0x35/0x50</DIV>
<DIV>[87303.978122]&nbsp; [&lt;ffffffff8119bccc&gt;] =
vfs_writev+0x3c/0x50</DIV>
<DIV>[87303.978145]&nbsp; [&lt;ffffffffa0266dd2&gt;]=20
nfsd_vfs_write.isra.12+0x92/0x350 [nfsd]</DIV>
<DIV>[87303.978149]&nbsp; [&lt;ffffffff816ed43e&gt;] ?=20
_raw_spin_lock+0xe/0x20</DIV>
<DIV>[87303.978159]&nbsp; [&lt;ffffffffa0284ba4&gt;] ?=20
find_confirmed_client.isra.58+0x144/0x1a0 [nfsd]</DIV>
<DIV>[87303.978167]&nbsp; [&lt;ffffffffa0284d48&gt;] ?=20
nfsd4_lookup_stateid+0xc8/0x120 [nfsd]</DIV>
<DIV>[87303.978174]&nbsp; [&lt;ffffffffa0269623&gt;] =
nfsd_write+0xa3/0x110=20
[nfsd]</DIV>
<DIV>[87303.978182]&nbsp; [&lt;ffffffffa027794c&gt;] =
nfsd4_write+0x1cc/0x250=20
[nfsd]</DIV>
<DIV>[87303.978189]&nbsp; [&lt;ffffffffa027746c&gt;]=20
nfsd4_proc_compound+0x5ac/0x7a0 [nfsd]</DIV>
<DIV>[87303.978197]&nbsp; [&lt;ffffffffa0262d62&gt;] =
nfsd_dispatch+0x102/0x270=20
[nfsd]</DIV>
<DIV>[87303.978214]&nbsp; [&lt;ffffffffa01f3b48&gt;]=20
svc_process_common+0x328/0x5e0 [sunrpc]</DIV>
<DIV>[87303.978225]&nbsp; [&lt;ffffffffa01f4153&gt;] =
svc_process+0x103/0x160=20
[sunrpc]</DIV>
<DIV>[87303.978232]&nbsp; [&lt;ffffffffa026272f&gt;] nfsd+0xbf/0x130=20
[nfsd]</DIV>
<DIV>[87303.978238]&nbsp; [&lt;ffffffffa0262670&gt;] ? =
nfsd_destroy+0x80/0x80=20
[nfsd]</DIV>
<DIV>[87303.978243]&nbsp; [&lt;ffffffff8107f050&gt;] =
kthread+0xc0/0xd0</DIV>
<DIV>[87303.978246]&nbsp; [&lt;ffffffff8107ef90&gt;] ?=20
flush_kthread_worker+0xb0/0xb0</DIV>
<DIV>[87303.978250]&nbsp; [&lt;ffffffff816f61ec&gt;]=20
ret_from_fork+0x7c/0xb0</DIV>
<DIV>[87303.978253]&nbsp; [&lt;ffffffff8107ef90&gt;] ?=20
flush_kthread_worker+0xb0/0xb0</DIV></DIV></DIV></BODY></HTML>

------=_NextPart_000_0012_01D0AD9D.EE83A520--


--===============9031551461419202112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9031551461419202112==--
