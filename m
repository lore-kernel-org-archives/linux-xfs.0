Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q77AIFiX043854 for <xfs@oss.sgi.com>; Tue, 7 Aug 2012 05:18:15 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id rUc9jbQa8FtXm6dI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Aug 2012 03:18:10 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs hang when filesystem filled
Date: Tue, 07 Aug 2012 12:18:07 +0200
Message-ID: <4713150.YEl5atVIJR@saturn>
In-Reply-To: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
References: <CAJ-WH_z+6HhooORtMKeO2=kURyiWMcxk_5eUbeBSz3cAXgRRfQ@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3844314893913824637=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "Guk-Bong, Kwon" <gbkwon@gmail.com>


--===============3844314893913824637==
Content-Type: multipart/signed; boundary="nextPart1423314.8U1al55IYd"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1423314.8U1al55IYd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Dienstag, 7. August 2012, 14:54:48 schrieb Guk-Bong, Kwon:
> /dev/mapper/ld1-test  94325760  94325740        20 100% /test

You should never ever come into this situation. What else than a hang=20=

would you expect? Should the server crash instead?
A filesystem should have at least 5% free at all times, below that=20
you're in a deep trouble situation that should be fixed. To keep high=20=

performance, you should even keep 15% free according to Dave Chinner.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1423314.8U1al55IYd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAg62AACgkQzhSR9xwSCbQxCwCgvCPejEBUsBTQI9PhD6jElPiB
wfwAmwXvjghsW/jIiT8CyCtEc7ZPJ0g4
=/Jje
-----END PGP SIGNATURE-----

--nextPart1423314.8U1al55IYd--


--===============3844314893913824637==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3844314893913824637==--
