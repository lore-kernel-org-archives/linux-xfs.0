Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6QA9e7T113200 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 05:09:41 -0500
Received: from piggy.rz.tu-ilmenau.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C438162A53E
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 03:12:43 -0700 (PDT)
Received: from piggy.rz.tu-ilmenau.de (piggy.rz.tu-ilmenau.de [141.24.4.8]) by
	cuda.sgi.com with ESMTP id xuoMX7GlqminHLPr for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 03:12:43 -0700 (PDT)
Received: from p4FD557E8.dip.t-dialin.net (vpn4.rz.tu-ilmenau.de
	[141.24.172.4])
	by piggy.rz.tu-ilmenau.de (8.13.7/8.13.7/Debian-2) with ESMTP id
	o6QACdxe013493 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 12:12:40 +0200
Received: from darkside.kls.lan (root@darkside.kls.lan
	[IPv6:2001:6f8:90c:12:21e:8cff:fecf:cfad])
	by p4FD557E8.dip.t-dialin.net (8.14.3/8.14.3) with ESMTP id
	o6QACd2d026884 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 12:12:40 +0200
Received: from darkside.kls.lan (holbe@localhost [IPv6:::1])
	by darkside.kls.lan (8.14.3/8.14.3) with ESMTP id o6QACd4Q007738
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 12:12:39 +0200
Received: (from holbe@localhost)
	by darkside.kls.lan (8.14.3/8.14.3) id o6QACdjR007736
	for xfs@oss.sgi.com; Mon, 26 Jul 2010 12:12:39 +0200
Date: Mon, 26 Jul 2010 12:12:39 +0200
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: mkfs.xfs: cannot (re)set log sunit=0
Message-ID: <20100726101238.GA7725@darkside.kls.lan>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3608643855679432494=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3608643855679432494==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I intend to set up a XFS filesystem on a RAID0 (Linux md) with 512k
Chunk Size. Since I cannot align the log section sunit to 512k, and
since the filesystem will have not much write activity anyways (in fact,
it'll be mounted read-only most of the time), I tried not to align the
log section sunit at all via -l sunit=3D0, but this does not appear to
work:

# truncate -s 1G /tmp/foo{0,1}
# losetup /dev/loop0 /tmp/foo0; losetup /dev/loop1 /tmp/foo1
# mdadm -C -l raid0 -n 2 /dev/md9 /dev/loop[01]
# mkfs.xfs -l sunit=3D0 /dev/md9
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=3D/dev/md9               isize=3D256    agcount=3D8, agsize=3D654=
08 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D523264, imaxpct=
=3D25
         =3D                       sunit=3D128    swidth=3D256 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D2
         =3D                       sectsz=3D512   sunit=3D8 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

Is this a bug or a feature?

The minimum I was able to limit the log sunit to was -l sunit=3D8, i.e. 1
block. Is there a difference between sunit=3D0 and sunit=3D1 in practice or
are single log entries aligned to blocks anyways?


Btw...
Since the filesystem is mostly read-only, I was also thinking about
reducing the size of the log section. The planned filesystem will be
5.5T or bigger, which results in 2G log section per default. I thought
about limiting it to 128M or 64M. There will be no concurrent write
activity on the fs. Together with the zero-alignment, what do you think
about that?


PS: I'm not on this list, please CC: me in replies. My Mail-Followup-To:
header should take care of that.


Thanks for your help & regards
   Mario
--=20
File names are infinite in length where infinity is set to 255 characters.
                                -- Peter Collinson, "The Unix File System"

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTE1flhS+e2HeSPbpAQIcywgAjfMGyL36H2lv0Cp67exQHGtjkq1J2zGV
Jk+2ZzXCyoZc2tnTSu+1LQ7cKRxr8LNgfSqBzWCRaGHGAgmhfeLRYjcDWx2vtu3D
ilRTFydb8cRJlf96LmMyHZQi7Iz/TVWYK5gctkX74JM/KRI5VeyEZcIDW8DyN+wf
2BN+kt2qXLO2helMYrZo9vQ0Bc3Oxr+V3NJeRzdZ0OhwrB5/Cwn2zqHghP+FdMd9
nLj7PDYyNo2dGdHIb55EJz45J+NwIM1NIciN5kMYeKPwE4jEE0SmMD+UINvYnNAu
918J1SlYmpkrqtdXk8yg5k2IxMg5ZfzSyT+sPgZlx16T3rube1+h/Q==
=FFAD
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--


--===============3608643855679432494==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3608643855679432494==--
