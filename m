Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBAKCOKW001744 for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 14:12:24 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id jYeMUFvXizV6y5m6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Dec 2012 12:14:51 -0800 (PST)
Received: from mailsrv.i.zmi.at (unknown [IPv6:2001:470:736a:27::3])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPS id 9D869182242F
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 21:15:13 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [IPv6:2001:470:736a:27::2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 52620132D9EA
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 21:14:48 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS write cache flush policy
Date: Mon, 10 Dec 2012 21:14:47 +0100
Message-ID: <1408451.5Ut0G7Wysl@saturn>
In-Reply-To: <5955806.tSHc7WOiJd@saturn>
References: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
	<20121208192927.GA17875@citd.de> <5955806.tSHc7WOiJd@saturn>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2884901500413303979=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2884901500413303979==
Content-Type: multipart/signed; boundary="nextPart1470501.2xjtRpp3a4"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1470501.2xjtRpp3a4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Samstag, 8. Dezember 2012, 20:40:07 schrieb Michael Monnerie:
> I'd like to chime in here, with a similar issue: I have Linux on my=20=

> desktop, xfs is the home partition, 16G RAM. One day my system froze,=

> no  chance to do a buffer flush via SYS-S/U/B, I had to press the
> reset button (no power off, just reset). Upon restart, lots of files
> were gone, destroyed, etc, and my KDE desktop wouldn't work anymore.

Similar problem yesterday: this time I could stop KDE, and get a root=20=

session. Killed all processes by hand, because one xfs partition was=20=

still open despite "lsof" not showing anything. At last there were only=
=20
a handful processes open, I killed "rsyncd", and suddenly disk I/O was=20=

100%, looks like it was writing a lot of buffers, the disk was about 15=
s=20
in full activity. I've seen this strange behaviour before (lot and long=
=20
disk activity on reboot), but only now I could trace it down to rsyncd.=


I have rsyncd running here as a target, my server is backuped here once=
=20
per night. So it's strange to see it having "something" open. I've move=
d=20
the backup target dir to another partition now, to see if I can see tha=
t=20
behaviour again.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531
XING: https://www.xing.com/profile/Michael_Monnerie
Twitter: @MichaelMonnerie https://twitter.com/MichaelMonnerie
FaceBook: https://www.facebook.com/michael.monnerie
LinkedIn: http://lnkd.in/uGx6ug

--nextPart1470501.2xjtRpp3a4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlDGQrcACgkQzhSR9xwSCbQ63wCeLM9Ha3plDfwpEPWRZ31zJNqs
X4MAnji9JnN7gBQpPXHd2mp4dxls5DUP
=j9WK
-----END PGP SIGNATURE-----

--nextPart1470501.2xjtRpp3a4--


--===============2884901500413303979==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2884901500413303979==--
