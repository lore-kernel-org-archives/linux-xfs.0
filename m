Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout01-q02.e.movistar.es ([86.109.101.142]:55383 "EHLO
        relayout01-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726195AbfGYGEz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 02:04:55 -0400
Received: from relayout01-redir.e.movistar.es (relayout01-redir.e.movistar.es [86.109.101.201])
        by relayout01-out.e.movistar.es (Postfix) with ESMTP id 45vMBF0yRlzjbws
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:53 +0200 (CEST)
Received: from Telcontar.valinor (70.red-88-9-30.dynamicip.rima-tde.net [88.9.30.70])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout01.e.movistar.es (Postfix) with ESMTPSA id 45vMBD65sJzfZ2T
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 51CE7320B40
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:52 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id SBPnwbA7S9Py for <linux-xfs@vger.kernel.org>;
        Thu, 25 Jul 2019 08:04:51 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 326163206C6
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jul 2019 08:04:51 +0200 (CEST)
Subject: Re: Sanity check - need a second pair of eyes ;-)
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
Date: Thu, 25 Jul 2019 08:04:40 +0200
MIME-Version: 1.0
In-Reply-To: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d
Content-Type: multipart/mixed; boundary="ndUJxwgkGmbBxKzv7gEgFLgFS5pVnKAig";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <900147aa-12a9-bb30-6af3-1cc63cd9f05a@telefonica.net>
Subject: Re: Sanity check - need a second pair of eyes ;-)
References: <alpine.LSU.2.21.1907241443520.12992@Telcontar.valinor>
 <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>
In-Reply-To: <4a352054-9a04-433f-979c-d28584e13b4c@sandeen.net>

--ndUJxwgkGmbBxKzv7gEgFLgFS5pVnKAig
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 24/07/2019 22.21, Eric Sandeen wrote:

=2E..

>> Is that the correct command line to achieve written sectors of 2 KiB?
>=20
> If you want to set the sector size, the instructions are in the man pag=
e for
> mkfs.xfs ;)
>=20
>        -s sector_size
>               This  option  specifies  the  fundamental  sector  size  =
of  the
>               filesystem.  The sector_size is specified either as a  va=
lue  in
>               bytes  with  size=3Dvalue  or  as  a base two logarithm v=
alue with
>               log=3Dvalue.  The default sector_size is 512  bytes.  The=
  minimum
>               value for sector size is 512; the maximum is 32768 (32 Ki=
B). The
>               sector_size must be a power of 2 size and cannot be made =
 larger
>               than the filesystem block size.

Thanks.=20

(Yes, I looked at the manual but did not /see/ aka understand what I real=
ly needed).

My page is a little bit different:

       -s sector_size_options
              This option specifies the fundamental  sector  size  of
              the filesystem.  The valid sector_size_option is:

                   size=3Dvalue
                          The  sector  size is specified with a value
                          in bytes.  The default sector_size  is  512
                          bytes. The minimum value for sector size is
                          512; the maximum is  32768  (32  KiB).  The
                          sector_size  must  be a power of 2 size and
                          cannot be made larger than  the  filesystem
                          block size.

                          To  specify any options on the command line
                          in units of sectors, this  option  must  be
                          specified  first so that the sector size is
                          applied consistently to all options.

Thus the final command line was:

# mkfs.xfs -L ANameUnseen -s size=3D2048 /dev/mapper/cr_nombre
meta-data=3D/dev/mapper/cr_nombre  isize=3D512    agcount=3D4, agsize=3D3=
054592 blks
         =3D                       sectsz=3D2048  attr=3D2, projid32bit=3D=
1
         =3D                       crc=3D1        finobt=3D1, sparse=3D0,=
 rmapbt=3D0
         =3D                       reflink=3D0
data     =3D                       bsize=3D4096   blocks=3D12218368, imax=
pct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1=

log      =3Dinternal log           bsize=3D4096   blocks=3D5966, version=3D=
2
         =3D                       sectsz=3D2048  sunit=3D1 blks, lazy-co=
unt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D=
0


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 15.0 x86_64 at Telcontar)


--ndUJxwgkGmbBxKzv7gEgFLgFS5pVnKAig--

--QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQQZEb51mJKK1KpcU/W1MxgcbY1H1QUCXTlGeAAKCRC1MxgcbY1H
1URoAKCIZhOq0P+knvLwbHryzO3kL1p1FgCePLDlmr8z7r4xXMHxN/GGPT6T9g8=
=Qekq
-----END PGP SIGNATURE-----

--QckbUVJHuJ4ZfsPQkWQNwF1vpSbM8jk3d--
