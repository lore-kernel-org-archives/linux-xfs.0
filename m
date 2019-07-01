Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bilbo.ozlabs.org ([203.11.71.1]:49557 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfGABMM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 30 Jun 2019 21:12:12 -0400
Date: Mon, 1 Jul 2019 11:12:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the xfs tree
Message-ID: <20190701111209.699082b7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GiBgqkQeV_Fn=xa4769+.=9"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

--Sig_/GiBgqkQeV_Fn=xa4769+.=9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xfs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

fs/orangefs/file.c: In function 'orangefs_getflags':
fs/orangefs/file.c:372:7: warning: assignment to 'long unsigned int *' from=
 '__u64' {aka 'long long unsigned int'} makes pointer from integer without =
a cast [-Wint-conversion]
  uval =3D val;
       ^
fs/orangefs/file.c: In function 'orangefs_ioctl':
fs/orangefs/file.c:381:24: error: implicit declaration of function 'file_io=
ctl'; did you mean 'file_path'? [-Werror=3Dimplicit-function-declaration]
  struct inode *inode =3D file_ioctl(file);
                        ^~~~~~~~~~
                        file_path
fs/orangefs/file.c:381:24: warning: initialization of 'struct inode *' from=
 'int' makes pointer from integer without a cast [-Wint-conversion]
fs/orangefs/file.c:418:35: error: 'old_uval' undeclared (first use in this =
function); did you mean 'p4d_val'?
   ret =3D orangefs_getflags(inode, &old_uval);
                                   ^~~~~~~~
                                   p4d_val
fs/orangefs/file.c:418:35: note: each undeclared identifier is reported onl=
y once for each function it appears in

Caused by commit

  de2baa49bbae ("vfs: create a generic checking and prep function for FS_IO=
C_SETFLAGS")

I have used the xfs tree from next-20190628 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/GiBgqkQeV_Fn=xa4769+.=9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0ZXekACgkQAVBC80lX
0GwDoAf+ORrfhB4XavC2KJUhXgoqhs75kuRhvoxtnUb0j15p++q00JVuAoKXDF0e
AGuNMqTt0+nWCBwe0Ds6Vky/m20YsdT0PccVl2V3UXEDUiNShsNSVtEGuaFkqrIW
4bJUVNji3kU95lox7L8Rm6wMo1xZazCHvaeAMMMi4MmeoP4Y8oZT63MNJE0je21j
YOq9QEZiZIdeQ/hud8icxUapL8UMPLgpsOLrcV15NqTM9z+vurqRpKLJlFR9421c
XAbSX5WIlMBIfWbFCPqP2zuSng/fRJwA6/dSvNiFPDOjG8LNXIb1agCfhk/kqZdM
aNVbi57y4KdLYYHAo9skpCaHbr91AA==
=NGNr
-----END PGP SIGNATURE-----

--Sig_/GiBgqkQeV_Fn=xa4769+.=9--
