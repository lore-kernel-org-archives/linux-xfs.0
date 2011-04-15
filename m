Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3F4SKB3037816 for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 23:28:20 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E62E53E29C1
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 21:31:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with SMTP id auJaU6p4LuHqy2S6 for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2011 21:31:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 6A253634
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 06:31:39 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 5EC9547EA03
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 06:31:38 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs stack overrun, unable to handle kernel paging request
Date: Fri, 15 Apr 2011 06:31:29 +0200
MIME-Version: 1.0
Message-Id: <201104150631.38169@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6525627112350292346=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6525627112350292346==
Content-Type: multipart/signed;
  boundary="nextPart2883514.3IY68XHezR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2883514.3IY68XHezR
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Not sure if I didn't already post a similar crash once. This ist kernel
2.6.31.14-0.6-xen from openSUSE 11.2
Machine was still running, but not anymore responding (except ping)

[8080121.921527] BUG: unable to handle kernel paging request at 00000000f1b=
a5f80
[8080121.921555] IP: [<ffffffff80042334>] update_curr+0x134/0x1e0
[8080121.921565] PGD 2423b067 PUD 0=20
[8080121.921571] Thread overran stack, or stack corrupted
[8080121.921574] Oops: 0000 [#1] SMP=20
[8080121.921579] last sysfs file: /sys/devices/xen/vbd-51744/block/xvdc/stat
[8080121.921584] CPU 3=20
[8080121.921586] Modules linked in: ipt_REJECT ipt_LOG xt_multiport xt_tcpu=
dp ipt_ECN iptable_mangle xt_state iptable_filter ip_tables nf_conntrack_sl=
p nf_conntrack_sip nf_conntrack_netbios_ns nf_conntrack_proto_udplite nf_co=
nntrack_proto_dccp nf_conntrack_irc nf_conntrack_ftp nf_conntrack_tftp=20
nf_conntrack_netlink nfnetlink nf_conntrack_sane ts_kmp nf_conntrack_amanda=
 nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_h323 xt_conntrack x_=
tables nfs nf_conntrack_proto_sctp lockd bluetooth fscache nf_conntrack_ipv=
4 nfs_acl rfkill nf_conntrack auth_rpcgss nf_defrag_ipv4 sunrpc ipv6 af_pac=
ket ramzswap=20
xvmalloc lzo_decompress lzo_compress fuse loop dm_mod xenblk cdrom xennet e=
xt4 jbd2 crc16 xfs exportfs reiserfs
[8080121.921586] Pid: 26557, comm: pdflush Not tainted 2.6.31.14-0.6-xen #1=
=20
[8080121.921586] RIP: e030:[<ffffffff80042334>]  [<ffffffff80042334>] updat=
e_curr+0x134/0x1e0
[8080121.921666] RSP: e02b:ffff88002e2845e0  EFLAGS: 00010086
[8080121.921670] RAX: 000000000000ccf8 RBX: ffff88000f5ac4b8 RCX: 000000002=
e2841c0
[8080121.921674] RDX: ffff88005702f0c0 RSI: ffff88000f5ac480 RDI: ffffc9000=
003a3e0
[8080121.921677] RBP: ffff88002e284610 R08: 00000000ffffffff R09: ffffffff8=
000d3ea
[8080121.921681] R10: ffff88002e284488 R11: ffff88002e2841d0 R12: ffffc9000=
003a3e0
[8080121.921684] R13: 00000000001782e6 R14: 001cb4d3fcdfdf5e R15: 000000000=
0000001
[8080121.921691] FS:  00007fc3d51196f0(0000) GS:ffffc90000030000(0000) knlG=
S:0000000000000000
[8080121.921695] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[8080121.921699] CR2: 00000000f1ba5f80 CR3: 00000000086e0000 CR4: 000000000=
0000660
[8080121.921704] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[8080121.921708] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[8080121.921712] Process pdflush (pid: 26557, threadinfo ffff88002e284000, =
task
ffff88000f5ac480)
[8080121.921716] Stack:
[8080121.921719]  ffffffff8073d627 00000000757f13c8 ffff88000f5ac4b8 ffffc9=
000003a3e0
[8080121.921725] <0> ffff88002e284c10 ffff88002e284950 ffff88002e284640 fff=
fffff8004256c
[8080121.921733] <0> ffffc9000003a380 00000000757f13c8 ffffc9000003a380 000=
0000000000003
[8080121.921742] Call Trace:
[8080121.921742]  [<ffffffff8004256c>] put_prev_task_fair+0x8c/0xd0
[8080121.921742]  [<ffffffff8046d447>] schedule+0x217/0x5f5
[8080121.921742]  [<ffffffff8004bc7f>] __cond_resched+0x2f/0x80
[8080121.921742]  [<ffffffff8046ddbd>] _cond_resched+0x4d/0x60
[8080121.921742]  [<ffffffff800e50f8>] shrink_page_list+0xc8/0x650
[8080121.921742]  [<ffffffff800e5953>] shrink_inactive_list+0x2d3/0x7c0
[8080121.921742]  [<ffffffff800e5e9b>] shrink_list+0x5b/0x110
[8080121.921742]  [<ffffffff800e60c1>] shrink_zone+0x171/0x250
[8080121.921742]  [<ffffffff800e6223>] shrink_zones+0x83/0x120
[8080121.921742]  [<ffffffff800e635e>] do_try_to_free_pages+0x9e/0x380
[8080121.921742]  [<ffffffff800e6757>] try_to_free_pages+0x77/0xa0
[8080121.921742]  [<ffffffff800dc0f3>] __alloc_pages_slowpath+0x2d3/0x5c0
[8080121.921742]  [<ffffffff800dc531>] __alloc_pages_nodemask+0x151/0x160
[8080121.921742]  [<ffffffff800d6ac3>] find_or_create_page+0x63/0xd0
[8080121.921742]  [<ffffffffa00b9af0>] _xfs_buf_lookup_pages+0x150/0x390 [x=
fs]
[8080121.921742]  [<ffffffffa00bade1>] xfs_buf_get_flags+0x81/0x1a0 [xfs]
[8080121.921742]  [<ffffffffa00baf26>] xfs_buf_read_flags+0x26/0xd0 [xfs]
[8080121.921742]  [<ffffffffa00adab9>] xfs_trans_read_buf+0x1e9/0x320 [xfs]
[8080121.921742]  [<ffffffffa0077278>] xfs_btree_read_buf_block+0x68/0xe0 [=
xfs]
[8080121.921742]  [<ffffffffa00773a8>] xfs_btree_lshift+0xb8/0x620 [xfs]

mit freundlichen Gr=C3=BC=C3=9Fen
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Haus zu verkaufen:
// http://zmi.at/langegg/



=2D------------------------------------------------------

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2883514.3IY68XHezR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk2nyioACgkQzhSR9xwSCbRsTQCg8mZTFR11P9mkOJXMkQ1SbWVD
vroAoMbFb4IWoSJ7ymYWg/QUnYTW3cV6
=Hecl
-----END PGP SIGNATURE-----

--nextPart2883514.3IY68XHezR--


--===============6525627112350292346==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6525627112350292346==--
