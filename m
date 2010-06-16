Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5G682rZ118237 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 01:08:02 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A15C912AF215
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 23:14:13 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id D2BAeXkXEXrOvZHR for
	<xfs@oss.sgi.com>; Tue, 15 Jun 2010 23:14:13 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 5C8AF17A
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 08:10:34 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 60CB283C829
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 08:10:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: XFS stack corruption: BUG: unable to handle kernel paging request
Date: Wed, 16 Jun 2010 08:10:23 +0200
MIME-Version: 1.0
Message-Id: <201006160810.33045@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3452910573112588702=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3452910573112588702==
Content-Type: multipart/signed;
  boundary="nextPart6619890.oC9upicNQC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6619890.oC9upicNQC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This happened while I did an "rsync" to that server, and it was searching t=
he files to sync.
Messages grabbed from the console:

[2188628.147321] BUG: unable to handle kernel paging request at 00000005231=
1ba18
[2188628.147339] IP: [<ffffffff80034832>] dequeue_task+0x72/0x110
[2188628.147357] PGD 126a3067 PUD 0=20
[2188628.147362] Thread overran stack, or stack corrupted
[2188628.147366] Oops: 0000 [#1] SMP=20
[2188628.147372] last sysfs file: /sys/devices/xen/vif-1/modalias
[2188628.147376] CPU 0=20
[2188628.147380] Modules linked in: nls_utf8 nfs lockd fscache nfs_acl auth=
_rpcgss sunrpc ipv6 ramzswap xvmalloc lzo_decompress lzo_compress loop dm_m=
od reiserfs xfs exportfs xennet xenblk cdrom
[2188628.147412] Pid: 30719, comm: pdflush Not tainted 2.6.31.12-0.2-xen #1=
=20
[2188628.147416] RIP: e030:[<ffffffff80034832>]  [<ffffffff80034832>] deque=
ue_task+0x72/0x110
[2188628.147425] RSP: e02b:ffff88002719df20  EFLAGS: 00010006
[2188628.147428] RAX: 000000000000a380 RBX: ffff880022338340 RCX: 00000000b=
453311b
[2188628.147432] RDX: 0000000000000001 RSI: ffff880022338340 RDI: ffffc9000=
000a380
[2188628.147436] RBP: ffff88002719df40 R08: ffff88002719e000 R09: 000000000=
0000000
[2188628.147439] R10: 0000000001c9c356 R11: 0000000000000000 R12: 000000000=
0000000
[2188628.147443] R13: 00000001209bcf34 R14: ffffffff80841c00 R15: ffffffff8=
0841c00
[2188628.147450] FS:  00007fd59f9116f0(0000) GS:ffffc90000000000(0000) knlG=
S:0000000000000000
sk+0x72/0x110
[2188628.147425] RSP: e02b:ffff88002719df20  EFLAGS: 00010006
[2188628.147428] RAX: 000000000000a380 RBX: ffff880022338340 RCX: 00000000b=
453311b
[2188628.147432] RDX: 0000000000000001 RSI: ffff880022338340 RDI: ffffc9000=
000a380
[2188628.147436] RBP: ffff88002719df40 R08: ffff88002719e000 R09: 000000000=
0000000
[2188628.147439] R10: 0000000001c9c356 R11: 0000000000000000 R12: 000000000=
0000000
[2188628.147443] R13: 00000001209bcf34 R14: ffffffff80841c00 R15: ffffffff8=
0841c00
[2188628.147450] FS:  00007fd59f9116f0(0000) GS:ffffc90000000000(0000) knlG=
S:0000000000000000
[2188628.147454] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[2188628.147458] CR2: 000000052311ba18 CR3: 0000000025a3f000 CR4: 000000000=
0000660
[2188628.147462] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[2188628.147466] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[2188628.147471] Process pdflush (pid: 30719, threadinfo ffff88002719e000, =
task ffff880022338340)
[2188628.147474] Stack:
[2188628.147477]  ffff88002719df70 00000000b453311b 62a8a813361341f2 ffffc9=
000000a380
[2188628.147484] <0> ffff88002719df70 ffffffff80034968 ffffc9000000a380 000=
00000b453311b
[2188628.147492] <0> 00000001209bcf34 ffffc9000000a380 ffff88002719e080 fff=
fffff8046c8fc
[2188628.147501] Call Trace:
[2188628.147516]  [<ffffffff80034968>] deactivate_task+0x38/0x60
[2188628.147526]  [<ffffffff8046c8fc>] thread_return+0x157/0x3fb
[2188628.147534]  [<ffffffff8046cf3d>] schedule_timeout+0x14d/0x200
[2188628.147541]  [<ffffffff8046c140>] io_schedule_timeout+0x80/0xf0
[2188628.147549]  [<ffffffff800f01ea>] congestion_wait+0x7a/0xb0
[2188628.147589]  [<ffffffffa009dcc6>] _xfs_buf_lookup_pages+0x326/0x390 [x=
fs]
[2188628.147692]  [<ffffffffa009ede1>] xfs_buf_get_flags+0x81/0x1a0 [xfs]
[2188628.147785]  [<ffffffffa009ef26>] xfs_buf_read_flags+0x26/0xd0 [xfs]
[2188628.147877]  [<ffffffffa0091ab9>] xfs_trans_read_buf+0x1e9/0x320 [xfs]
[2188628.147957]  [<ffffffffa005b278>] xfs_btree_read_buf_block+0x68/0xe0 [=
xfs]
[2188628.148005]  [<ffffffffa005b99e>] xfs_btree_lookup_get_block+0x8e/0x11=
0 [xfs]
[2188628.148021]  [<ffffffffa005c0af>] xfs_btree_lookup+0xdf/0x4d0 [xfs]
[2188628.148021]  [<ffffffffa0042b77>] xfs_alloc_lookup_eq+0x27/0x50 [xfs]
[2188628.148021]  [<ffffffffa0042d86>] xfs_alloc_fixup_trees+0xc6/0x370 [xf=
s]
[2188628.148021]  [<ffffffffa0044c30>] xfs_alloc_ag_vextent_near+0x4e0/0x9a=
0 [xfs]
[2188628.148021]  [<ffffffffa00451f5>] xfs_alloc_ag_vextent+0x105/0x160 [xf=
s]
[2188628.148021]  [<ffffffffa0045a04>] xfs_alloc_vextent+0x204/0x4b0 [xfs]
[2188628.148021]  [<ffffffffa0055c8b>] xfs_bmap_btalloc+0x18b/0xae0 [xfs]
[2188628.148021]  [<ffffffffa005660f>] xfs_bmap_alloc+0x2f/0x70 [xfs]
[2188628.148021]  [<ffffffffa0057272>] xfs_bmapi+0xc22/0x1320 [xfs]
[2188628.148021]  [<ffffffffa007c248>] xfs_iomap_write_allocate+0x1d8/0x3f0=
 [xfs]
[2188628.148021]  [<ffffffffa007d089>] xfs_iomap+0x2c9/0x300 [xfs]
[2188628.148021]  [<ffffffffa009a1b8>] xfs_map_blocks+0x38/0x60 [xfs]


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart6619890.oC9upicNQC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwYatgACgkQzhSR9xwSCbQBsgCbBdekYdTv9f++tyj+2FyujDYm
jlIAn0KhwNI/A9+S+hSwr+UTk1OJe4ko
=Y8qE
-----END PGP SIGNATURE-----

--nextPart6619890.oC9upicNQC--


--===============3452910573112588702==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3452910573112588702==--
