Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp08.acens.net ([86.109.99.132]:19583 "EHLO smtp.movistar.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751726AbdBCCZA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 21:25:00 -0500
Received: from minas-tirith.valinor (88.17.75.124) by smtp.movistar.es (8.6.122.03) (authenticated as robin.listas2)
        id 58733CC201FAC054 for linux-xfs@vger.kernel.org; Fri, 3 Feb 2017 02:18:51 +0000
Received: from minas-tirith.valinor (localhost [127.0.0.1])
        by minas-tirith.valinor (Postfix) with ESMTP id 8202618813D
        for <linux-xfs@vger.kernel.org>; Fri,  3 Feb 2017 03:18:41 +0100 (CET)
Subject: Re: Suspend fails when xfs is involved?
References: <20170203010401.GR9134@birch.djwong.org>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <2724fe21-4924-536b-352e-0abfb4d033a0@telefonica.net>
Date: Fri, 3 Feb 2017 03:18:34 +0100
MIME-Version: 1.0
In-Reply-To: <20170203010401.GR9134@birch.djwong.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r9R7AjHWOmBIe91qmNx6h194DH6cJRGu3"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r9R7AjHWOmBIe91qmNx6h194DH6cJRGu3
Content-Type: multipart/mixed; boundary="isxPmo6VxNhqdWOEFwC7Mqul4TNBJnowu";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: xfs <linux-xfs@vger.kernel.org>
Message-ID: <2724fe21-4924-536b-352e-0abfb4d033a0@telefonica.net>
Subject: Re: Suspend fails when xfs is involved?
References: <20170203010401.GR9134@birch.djwong.org>
In-Reply-To: <20170203010401.GR9134@birch.djwong.org>

--isxPmo6VxNhqdWOEFwC7Mqul4TNBJnowu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2017-02-03 02:04, Darrick J. Wong wrote:
> Hi list,
>=20
> So I've noticed that my laptop consistently fails to suspend with:
>=20

> [1183646.459310] Freezing of tasks failed after 20.006 seconds (1 tasks=
 refusing to freeze, wq_busy=3D0):
> [1183646.459348] xfsaild/dm-1    D    0  1767      2 0x00000000

I see what to me seem similar events on my desktop machine, occasionally,=
 but a second attempt succeeds; it is a different function, but xfs is in=
volved:

<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748246.597459] PM: Sync=
ing filesystems ... done.
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748247.261177] Freezing=
 user space processes ... (elapsed 0.002 seconds) done.
<0.7> 2017-01-14 19:50:38 Telcontar kernel - - - [748247.263791] PM: Mark=
ing nosave pages: [mem 0x00000000-0x00000fff]
<0.7> 2017-01-14 19:50:38 Telcontar kernel - - - [748247.263797] PM: Mark=
ing nosave pages: [mem 0x0009f000-0x000fffff]
<0.7> 2017-01-14 19:50:38 Telcontar kernel - - - [748247.263800] PM: Mark=
ing nosave pages: [mem 0xbff90000-0xffffffff]
<0.7> 2017-01-14 19:50:38 Telcontar kernel - - - [748247.264421] PM: Basi=
c memory bitmaps created
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748247.264453] PM: Prea=
llocating image memory... done (allocated 822838 pages)
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748249.186840] PM: Allo=
cated 3291352 kbytes in 1.92 seconds (1714.24 MB/s)
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748249.186841] Freezing=
 remaining freezable tasks ...=20
<0.3> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189941] Freezing=
 of tasks failed after 20.003 seconds (1 tasks refusing to freeze, wq_bus=
y=3D0):
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189944] kswapd0 =
        D ffff88023fd95c40     0    44      2 0x00000000
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189948]  ffff880=
235ed3848 ffff88017ee58340 ffff880235eccbc0 ffff880235ed4000
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189952]  ffff880=
235eccbc0 ffff8801fa1a2498 ffff8800ba8c5340 ffff8801fa1a23c0
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189956]  ffff880=
235ed3860 ffffffff8160680c 7fffffffffffffff ffff880235ed3908
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189959] Call Tra=
ce:
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189970]  [<fffff=
fff8160680c>] schedule+0x3c/0x90
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189975]  [<fffff=
fff816095fa>] schedule_timeout+0x25a/0x2f0
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.189978]  [<fffff=
fff816071f6>] wait_for_completion+0xc6/0x140
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190019]  [<fffff=
fffa0edef9c>] xfs_buf_submit_wait+0x7c/0x250 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190051]  [<fffff=
fffa0edf2b1>] xfs_buf_read_map+0x111/0x1a0 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190075]  [<fffff=
fffa0f0c6ed>] xfs_trans_read_buf_map+0xfd/0x330 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190097]  [<fffff=
fffa0ed1aae>] xfs_imap_to_bp+0x5e/0xd0 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190120]  [<fffff=
fffa0ef3e0d>] xfs_iflush+0xcd/0x230 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190142]  [<fffff=
fffa0ee7653>] xfs_reclaim_inode+0x53/0x370 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190164]  [<fffff=
fffa0ee7b69>] xfs_reclaim_inodes_ag+0x1f9/0x2f0 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190186]  [<fffff=
fffa0ee8871>] xfs_reclaim_inodes_nr+0x31/0x40 [xfs]
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190191]  [<fffff=
fff81208a36>] super_cache_scan+0x176/0x180
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190195]  [<fffff=
fff8119cb35>] shrink_slab.part.40+0x205/0x3e0
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190199]  [<fffff=
fff811a1368>] shrink_zone+0x268/0x280
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190202]  [<fffff=
fff811a2433>] kswapd+0x4a3/0x960
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190206]  [<fffff=
fff8109d308>] kthread+0xc8/0xe0
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.190209]  [<fffff=
fff8160ac8f>] ret_from_fork+0x3f/0x70
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.191726] DWARF2 u=
nwinder stuck at ret_from_fork+0x3f/0x70
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.191727]=20
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.191728] Leftover=
 inexact backtrace:
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.191728]=20
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.191730]  [<fffff=
fff8109d240>] ? kthread_park+0x50/0x50
<0.4> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.191774]=20
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.192073] Restarti=
ng kernel threads ... done.
<0.7> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.298537] PM: Basi=
c memory bitmaps freed
<0.6> 2017-01-14 19:50:38 Telcontar kernel - - - [748269.300160] Restarti=
ng tasks ... done.


The kernel was 4.4.36-8-default #1 SMP Fri Dec 9
Distribution is openSUSE Leap 42.2

I have not reported this yet in Bugzilla, but seeing this post I thought =
I might as well tell.
You will know better than me what to make of it.

--=20
Cheers / Saludos,
              =20
		Carlos E. R.

  (from 42.2 x86_64 "Malachite" (Minas Tirith))


--isxPmo6VxNhqdWOEFwC7Mqul4TNBJnowu--

--r9R7AjHWOmBIe91qmNx6h194DH6cJRGu3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAliT6IEACgkQja8UbcUWM1ycdgD+LHQYcCM9LFpzpasmRx/H9hV8
NznmKlxN7DFrO8+or1cA/A1rJtfmHKGXvO6h25EPCyGVIunCNBKHdjjtMMboXvqC
=1CtJ
-----END PGP SIGNATURE-----

--r9R7AjHWOmBIe91qmNx6h194DH6cJRGu3--
