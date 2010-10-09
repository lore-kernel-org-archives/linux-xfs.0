Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o99LsEJO165932 for <xfs@oss.sgi.com>; Sat, 9 Oct 2010 16:54:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB17A1E7988A
	for <xfs@oss.sgi.com>; Sat,  9 Oct 2010 14:55:19 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id OeUmkfHckJ0wzsnL for
	<xfs@oss.sgi.com>; Sat, 09 Oct 2010 14:55:19 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 77775400
	for <xfs@oss.sgi.com>; Sat,  9 Oct 2010 23:55:18 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id DC13F401C2F
	for <xfs@oss.sgi.com>; Sat,  9 Oct 2010 23:55:17 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: kernel crash 2.6.31.14-0.1-xen from openSUSE 11.2
Date: Sat, 9 Oct 2010 23:55:16 +0200
MIME-Version: 1.0
Message-Id: <201010092355.17240@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5862661726165763429=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5862661726165763429==
Content-Type: multipart/signed;
  boundary="nextPart3923438.DXBt1aLF62";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3923438.DXBt1aLF62
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I just had a bug in one VM, and don't know if this is XFS related, but it s=
eems so.

[1172140.926859] BUG: unable to handle kernel paging request at 00000003d03=
dd178
[1172140.926877] IP: [<ffffffff80034872>] dequeue_task+0x72/0x110
[1172140.926897] PGD 1b54b067 PUD 0=20
[1172140.926897] Thread overran stack, or stack corrupted
[1172140.926897] Oops: 0000 [#1] SMP=20
[1172140.926897] last sysfs file: /sys/devices/xen/vbd-51744/block/xvdc/stat
[1172140.926897] CPU 0=20
[1172140.926897] Modules linked in: bluetooth rfkill af_packet ipt_REJECT i=
pt_LOG xt_multiport xt_tcpudp ipt_ECN iptable_mangle xt_state iptable_filte=
r ip_tables nf_conntrack_slp nf_conntrack_sip nf_conntrack_netbios_ns nf_co=
nntrack_proto_udplite nf_conntrack_proto_dccp nf_conntrack_irc nf_conntrack=
_ftp=20
nf_conntrack_tftp nf_conntrack_netlink nfnetlink nf_conntrack_sane ts_kmp n=
f_conntrack_amanda nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_h3=
23 xt_conntrack x_tables nf_conntrack_proto_sctp nf_conntrack_ipv6 nf_connt=
rack_ipv4 nf_conntrack nf_defr
ag_ipv4 nfs lockd fscache nfs_acl ipv6 auth_rpcgss sunrpc ramzswap xvmalloc=
 lzo_decompress lzo_compress fuse loop dm_mod xenblk cdrom xennet ext4 jbd2=
 crc16 xfs exportfs reiserfs
[1172140.926897] Pid: 28690, comm: pdflush Not tainted 2.6.31.14-0.1-xen #1=
=20
[1172140.926897] RIP: e030:[<ffffffff80034872>]  [<ffffffff80034872>] deque=
ue_task+0x72/0x110
[1172140.926897] RSP: e02b:ffff880001230380  EFLAGS: 00010016
[1172140.926897] RAX: 000000000000a380 RBX: ffff880004f84180 RCX: 000000008=
9f8b3ff
[1172140.926897] RDX: 0000000000000001 RSI: ffff880004f84180 RDI: ffffc9000=
000a380
[1172140.926897] RBP: ffff8800012303a0 R08: ffff880001230000 R09: 000000000=
0000000
[1172140.926897] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
0000000
[1172140.926897] R13: ffff8800012304f0 R14: 000002a400003000 R15: ffff88002=
85fa600
[1172140.926897] FS:  00007f6c27bb06f0(0000) GS:ffffc90000000000(0000) knlG=
S:0000000000000000
[1172140.926897] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[1172140.926897] CR2: 00000003d03dd178 CR3: 000000001b4cd000 CR4: 000000000=
0000660
[1172140.926897] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[1172140.926897] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[1172140.926897] Process pdflush (pid: 28690, threadinfo ffff880001230000, =
task ffff880004f84180)
[1172140.926897] Stack:
[1172140.926897]  ffff8800012303d0 0000000089f8b3ff 0000000000001000 ffffc9=
000000a380
[1172140.926897] <0> ffff8800012303d0 ffffffff800349a8 ffffc9000000a380 000=
0000089f8b3ff
[1172140.926897] <0> ffff8800012304f0 ffffc9000000a380 ffff8800012304e0 fff=
fffff8046ca5c
[1172140.926897] Call Trace:
[1172140.926897]  [<ffffffff800349a8>] deactivate_task+0x38/0x60
[1172140.926897]  [<ffffffff8046ca5c>] thread_return+0x157/0x3fb
[1172140.926897]  [<ffffffffa009b5ef>] _sv_wait+0x8f/0xc0 [xfs]
[1172140.926897]  [<ffffffffa009ec69>] xlog_state_sync+0x2b9/0x2e0 [xfs]
[1172140.926897]  [<ffffffffa009ecf5>] _xfs_log_force+0x65/0xa0 [xfs]
[1172140.926897]  [<ffffffffa009ed52>] xfs_log_force+0x22/0x60 [xfs]
[1172140.926897]  [<ffffffffa005f2fa>] xfs_alloc_search_busy+0xea/0x110 [xf=
s]
[1172140.926897]  [<ffffffffa0061244>] xfs_alloc_ag_vextent+0x154/0x160 [xf=
s]
[1172140.926897]  [<ffffffffa0061a04>] xfs_alloc_vextent+0x204/0x4b0 [xfs]
[1172140.926897]  [<ffffffffa0071c8b>] xfs_bmap_btalloc+0x18b/0xae0 [xfs]
[1172140.926897]  [<ffffffffa007260f>] xfs_bmap_alloc+0x2f/0x70 [xfs]
[1172140.926897]  [<ffffffffa0073272>] xfs_bmapi+0xc22/0x1320 [xfs]
[1172140.926897]  [<ffffffffa0098248>] xfs_iomap_write_allocate+0x1d8/0x3f0=
 [xfs]
[1172140.926897]  [<ffffffffa0099089>] xfs_iomap+0x2c9/0x300 [xfs]
[1172140.926897]  [<ffffffffa00b61b8>] xfs_map_blocks+0x38/0x60 [xfs]
[1172140.926897]  [<ffffffffa00b793a>] xfs_page_state_convert+0x3fa/0x720 [=
xfs]
[1172140.926897]  [<ffffffffa00b7de4>] xfs_vm_writepage+0x84/0x160 [xfs]
[1172140.926897]  [<ffffffff800e36b3>] pageout+0x143/0x2b0
[1172140.926897]  [<ffffffff800e51fe>] shrink_page_list+0x26e/0x650
[1172140.926897]  [<ffffffff800e58b3>] shrink_inactive_list+0x2d3/0x7c0
[1172140.926897]  [<ffffffff800e5dfb>] shrink_list+0x5b/0x110
[1172140.926897]  [<ffffffff800e6021>] shrink_zone+0x171/0x250
[1172140.926897]  [<ffffffff800e6183>] shrink_zones+0x83/0x120
[1172140.926897]  [<ffffffff800e62be>] do_try_to_free_pages+0x9e/0x380
[1172140.926897]  [<ffffffff800e66b7>] try_to_free_pages+0x77/0xa0
[1172140.926897]  [<ffffffff800dc053>] __alloc_pages_slowpath+0x2d3/0x5c0
[1172140.926897]  [<ffffffff800dc491>] __alloc_pages_nodemask+0x151/0x160
[1172140.926897]  [<ffffffff8010efdc>] T.583+0x4c/0x150
[1172140.926897]  [<ffffffff8010f1d7>] T.581+0xf7/0x380
[1172140.926897]  [<ffffffff8010f6c0>] cache_alloc_refill+0x260/0x2a0
[1172140.926897]  [<ffffffff8010f86c>] kmem_cache_alloc+0x16c/0x180
[1172140.926897]  [<ffffffffa00b53e2>] kmem_zone_alloc+0xa2/0x110 [xfs]
[1172140.926897]  [<ffffffffa00b5472>] kmem_zone_zalloc+0x22/0x60 [xfs]
[1172140.926897]  [<ffffffffa00abadd>] _xfs_trans_alloc+0x3d/0x90 [xfs]
[1172140.926897]  [<ffffffffa00abcd2>] xfs_trans_alloc+0xa2/0xd0 [xfs]
[1172140.926897]  [<ffffffffa00982b1>] xfs_iomap_write_allocate+0x241/0x3f0=
 [xfs]
[1172140.926897]  [<ffffffffa0099089>] xfs_iomap+0x2c9/0x300 [xfs]
[1172140.926897]  [<ffffffffa00b61b8>] xfs_map_blocks+0x38/0x60 [xfs]
[1172140.926897]  [<ffffffffa00b793a>] xfs_page_state_convert+0x3fa/0x720 [=
xfs]
[1172140.926897]  [<ffffffffa00b7de4>] xfs_vm_writepage+0x84/0x160 [xfs]
[1172140.926897]  [<ffffffff800dd9e1>] __writepage+0x21/0x60
[1172140.926897]  [<ffffffff800dec35>] write_cache_pages+0x215/0x520
[1172140.926897]  [<ffffffff800def70>] generic_writepages+0x30/0x50
[1172140.926897]  [<ffffffffa00b6d0c>] xfs_vm_writepages+0x7c/0xb0 [xfs]
[1172140.926897]  [<ffffffff800defc5>] do_writepages+0x35/0x70
[1172140.926897]  [<ffffffff80140c2b>] writeback_single_inode+0x10b/0x3f0
[1172140.926897]  [<ffffffff801413e8>] generic_sync_sb_inodes+0x1a8/0x5f0
[1172140.926897]  [<ffffffff80141875>] sync_sb_inodes+0x45/0x60
[1172140.926897]  [<ffffffff801419a4>] writeback_inodes+0x54/0x150
[1172140.926897]  [<ffffffff800de3ae>] background_writeout+0xbe/0x110
[1172140.926897]  [<ffffffff800dffb0>] __pdflush+0x1b0/0x3b0
[1172140.926897]  [<ffffffff800e0207>] pdflush+0x57/0x80
[1172140.926897]  [<ffffffff8006fb06>] kthread+0xb6/0xc0
[1172140.926897]  [<ffffffff8000d3ea>] child_rip+0xa/0x20
[1172140.926897] Code: 00 48 29 c8 48 29 f0 48 c1 f8 03 48 01 f0 48 89 83 a=
0 00 00 00 4c 8b 43 08 4c 8b 8b 18 02 00 00 48 c7 c0 80 a3 00 00 41 8b 48 1=
8 <48> 8b 0c cd 80 31 78 80 48 8b b4 08 40 08 00 00 31 c9 48 c7 83=20
[1172140.926897] RIP  [<ffffffff80034872>] dequeue_task+0x72/0x110
[1172140.926897]  RSP <ffff880001230380>
[1172140.926897] CR2: 00000003d03dd178
[1172140.927989] ---[ end trace 3d59bc6e1b53fd3a ]---


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3923438.DXBt1aLF62
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyw5MUACgkQzhSR9xwSCbTSLQCgqhTZiSPVJ3jDhD1WpSF0T3kw
DZ0AoL72Dmlx9tQnaQcJ4lw9X+aLXDeE
=8XxS
-----END PGP SIGNATURE-----

--nextPart3923438.DXBt1aLF62--


--===============5862661726165763429==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5862661726165763429==--
