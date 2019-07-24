Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43576 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389035AbfGXUVz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jul 2019 16:21:55 -0400
Subject: Re: Sanity check - need a second pair of eyes ;-)
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
Date: Wed, 24 Jul 2019 15:21:52 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Carlos E. R." <robin.listas@telefonica.net>, Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc
Content-Type: multipart/mixed; boundary="QVt4k46B3sAbU71396fCJeaCFLqBrMVXG";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: "Carlos E. R." <robin.listas@telefonica.net>,
 Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
Subject: Re: Sanity check - need a second pair of eyes ;-)
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
In-Reply-To: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>

--QVt4k46B3sAbU71396fCJeaCFLqBrMVXG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> Hi,
>=20
> I'm trying to create an XFS image to be written on a Blue Ray disk, enc=
rypted. I'm told that DVDs have a sector size of 2 KiB, thus it is beter =
to tell the formatting utility of that, because when creating the image f=
ile it is on a hard disk where sector size is 512B.
>=20
> Basic procedure:
>=20
> truncate -s 50050629632 image_1_50.img
> losetup -f image_1_50.img
> cryptsetup luksFormat --type luks2 --label blueray50img /dev/loop0
> cryptsetup luksOpen /dev/loop0 cr_nombre
>=20
>=20
> So now I have the image file loop mounted on /dev/mapper/cr_nombre, and=
 I do (this is the step I ask about):
>=20
> Telcontar:/home_aux/BLUERAY_OPS # mkfs.xfs -L ANameUnseen -b size=3D204=
8 /dev/mapper/cr_nombre
                                                             ^^^ block si=
ze

> meta-data=3D/dev/mapper/cr_nombre  isize=3D512    agcount=3D4, agsize=3D=
6109184 blks
>          =3D                       sectsz=3D512   attr=3D2, projid32bit=
=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D=
0, rmapbt=3D0
>          =3D                       reflink=3D0
> data     =3D                       bsize=3D2048   blocks=3D24436736, im=
axpct=3D25
                                   ^^^ block size
>          =3D                       sunit=3D0      swidth=3D0 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D=
1
> log      =3Dinternal log           bsize=3D2048   blocks=3D11932, versi=
on=3D2
>          =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=
count=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> Telcontar:/home_aux/BLUERAY_OPS #
>=20
>=20
> Is that the correct command line to achieve written sectors of 2 KiB?

If you want to set the sector size, the instructions are in the man page =
for
mkfs.xfs ;)

       -s sector_size
              This  option  specifies  the  fundamental  sector  size  of=
  the
              filesystem.  The sector_size is specified either as a  valu=
e  in
              bytes  with  size=3Dvalue  or  as  a base two logarithm val=
ue with
              log=3Dvalue.  The default sector_size is 512  bytes.  The  =
minimum
              value for sector size is 512; the maximum is 32768 (32 KiB)=
=2E The
              sector_size must be a power of 2 size and cannot be made  l=
arger
              than the filesystem block size.

-Eric

> I ask because I see isize=3D512 and sectsz=3D512 and I wonder.
>=20
>=20
> -- Cheers,
>        Carlos E. R.
>        (from openSUSE 15.0 x86_64 at Telcontar)
>=20


--QVt4k46B3sAbU71396fCJeaCFLqBrMVXG--

--TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAl04veAACgkQIK4WkuE9
3uB+XxAAk2YrFN9/mx8zQHyrQwWdJtVHGjjUPX+MRHSFO3eRlX8FSVdw7cTx2GOe
QFfwDe2o7tHUGhXx+z1r2gq+JbxBri577VyAsRXil5DJxXNj77pYluKEpF8v+HFZ
QQ2mGgX+aCvzmff338DCVpuzgm9YbWZX0c+A52DrpoAqEyZn+NvF/8hfAJUbq1mL
c0XLFC0k/2+UB/1M4dU8UIyCaifKjXWO+bNEANOkdCzrYxddrO3eEgBslPIR08ux
I7Xlqy0YhlivrXwd73AmOvpXLtHEAxbwUJvJBJ762cCDomrDTpP9gz+QC0FNewyk
lcnhR8DPxZv3OhCPG7r+97yhgznA0YmkRkDShh+B01ocDELnvn293cCvKivckk3F
y7+a2JACdwrD6tE7U1PElCsb5Po3t+NXvwxeO+k4dWMu/GeLcezEz1Uro6fYFVEu
tX/jO2sFY7oPHVVAHbzfIEYvdQwUIN1El2osJFpm772lxk0AfeYKa1EjRKf3BSNr
VGrQqmqPQ0JDkIRbz4+rDwiIduu7kQgFFWe/qB6vR7zYlh2yrdFlFBMR0YhYRX9Z
gayHO84+SrFbWC4aF4jFmfYWJUyWJ4ZBE0B28zT/n0DI9bhbic4kc7lIKbt9badO
ZxeQ3ijo8ZX3w9+RntDzyj+H8vvmJNFJxs2H1m+yE45smV/znKY=
=HJWD
-----END PGP SIGNATURE-----

--TrjTLOPH2oBLcBUNHZc3SfzY0o5JPCsnc--
