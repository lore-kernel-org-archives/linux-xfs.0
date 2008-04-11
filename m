Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 03:12:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BACK1b031115
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 03:12:21 -0700
Received: from py-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 14E8C77EADA
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 03:12:56 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.176]) by cuda.sgi.com with ESMTP id SSH4CeEIUAKK35tp for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 03:12:56 -0700 (PDT)
Received: by py-out-1112.google.com with SMTP id j37so440061pyc.4
        for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 03:12:56 -0700 (PDT)
Subject: xfslogd Page Allocation Failure
From: Federico Sevilla III <jijo@fs3.ph>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T/HTTSfTh3F8ZKWkN8vK"
Date: Fri, 11 Apr 2008 18:06:37 +0800
Message-Id: <1207908397.4745.9.camel@humanitas.fs3.ph>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-T/HTTSfTh3F8ZKWkN8vK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I noticed the below logs in my dmesg. The machine continues to be
useable, and I'm not aware of which process wasn't able to perform
correctly. Is this a cause for concern? Hope you can advise.

Thank you very much.

xfslogd/1: page allocation failure. order:0, mode:0x0
Pid: 261, comm: xfslogd/1 Not tainted 2.6.24.2 #1

Call Trace:
 [<ffffffff8025a9b2>] __alloc_pages+0x223/0x381
 [<ffffffff802753be>] __slab_alloc+0x178/0x53b
 [<ffffffff80321c39>] free_address+0x17/0x66
 [<ffffffff802759ac>] kmem_cache_alloc+0x76/0x7c
 [<ffffffff80321c39>] free_address+0x17/0x66
 [<ffffffff80321d03>] xfs_buf_free+0x7b/0x7d
 [<ffffffff802eb4fc>] xfs_buf_iodone_callbacks+0x107/0x17b
 [<ffffffff80322ba0>] xfs_buf_iodone_work+0x0/0x72
 [<ffffffff8023ca2b>] run_workqueue+0x7f/0x108
 [<ffffffff8023d2ce>] worker_thread+0x0/0xc8
 [<ffffffff8023d35f>] worker_thread+0x91/0xc8
 [<ffffffff802405af>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023d2ce>] worker_thread+0x0/0xc8
 [<ffffffff8023d2ce>] worker_thread+0x0/0xc8
 [<ffffffff80240244>] kthread+0x3d/0x61
 [<ffffffff8020c638>] child_rip+0xa/0x12
 [<ffffffff80240207>] kthread+0x0/0x61
 [<ffffffff8020c62e>] child_rip+0x0/0x12

Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd=
:   0
DMA32 per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd: 137   Cold: hi:   62, btch:  15 usd=
:  47
CPU    1: Hot: hi:  186, btch:  31 usd: 135   Cold: hi:   62, btch:  15 usd=
:  48
Active:385341 inactive:88628 dirty:29329 writeback:5822 unstable:0
 free:3056 slab:17672 mapped:15772 pagetables:11363 bounce:0
DMA free:8016kB min:28kB low:32kB high:40kB active:2180kB inactive:976kB pr=
esent:11424kB pages_scanned:32 all_unreclaimable? no
lowmem_reserve[]: 0 2004 2004 2004
DMA32 free:4208kB min:5712kB low:7140kB high:8568kB active:1539184kB inacti=
ve:353536kB present:2052196kB pages_scanned:795 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 18*4kB 31*8kB 29*16kB 32*32kB 23*64kB 3*128kB 1*256kB 0*512kB 0*1024kB=
 0*2048kB 1*4096kB =3D 8016kB
DMA32: 31*4kB 1*8kB 1*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0=
*2048kB 1*4096kB =3D 4244kB
Swap cache: add 3597048, delete 3537164, find 170970595/171758094, race 0+9=
658
Free swap  =3D 535892kB
Total swap =3D 1048568kB
Free swap:       535892kB
524256 pages of RAM
9091 reserved pages
357974 pages shared
59885 pages swap cached


--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-T/HTTSfTh3F8ZKWkN8vK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH/zgt5rCBSJO3Rr4RAjJpAJ9BPfzGlURkLtsXYhErfxoDLyNaHQCfdgy7
teV0Z99ySScT/bzm1p/TRSs=
=/AUi
-----END PGP SIGNATURE-----

--=-T/HTTSfTh3F8ZKWkN8vK--
