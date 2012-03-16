Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GB76iD046521 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 06:07:06 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 1yYTN4FPuCS19CFs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Mar 2012 04:07:02 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 12:06:54 +0100
Message-ID: <3633779.GerkmFcqtU@saturn>
In-Reply-To: <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2970943114750648901=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Linux RAID <linux-raid@vger.kernel.org>, Peter Grandi <pg@lxra2.for.sabi.co.uk>, Jessie Evangelista <jessie.evangelista@gmail.com>


--===============2970943114750648901==
Content-Type: multipart/signed; boundary="nextPart2250665.9ql0y8N4me"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2250665.9ql0y8N4me
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 16. M=C3=A4rz 2012, 11:36:07 schrieb Jessie Evangelista:
> If you were in my place with the resource constraints, you'd go with:=

> xfs with barriers on top of mdraid10 with device cache ON and setting=

> vm/dirty_bytes, vm/dirty_background_bytes, vm/dirty_expire_centisecs,=

> vm/dirty_writeback_centisecs to safe values

If you ever experienced a crash where lots of sensible and important=20=

data were lost, you would not even think about "device cache ON".

> could you please suggest a hardware raid card with BBU that's cheap?

"Cheap" is a varying definition. How much is your data worth? How much=20=

does one day of blackout cost?=20

I've been very happy with Areca Controllers, like the 12x0 and 1680=20
series, and now there's the newer 1882 series like=20
http://geizhals.at/eu/721745
plus a BBU for about 100=E2=82=AC.

You can even mix RAID levels on the same disks, example of 8x1TB define=
=20
a RAID0 of 500G and the rest a RAID6. Online expansion possible,=20
scheduled background verify, e-mail notification on everything, logging=
,=20
ntp times, oob-mgmnt via it's own network interface, ...
Very reliable, I never had a problem. And they have a good support team=
.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2250665.9ql0y8N4me
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9jHtMACgkQzhSR9xwSCbRr5gCdFsTbgI5PSGoK/QZs18dY3Z5g
+YIAoJTOux9xS23y4jSC0sWAz++hYSvw
=hmCD
-----END PGP SIGNATURE-----

--nextPart2250665.9ql0y8N4me--


--===============2970943114750648901==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2970943114750648901==--
