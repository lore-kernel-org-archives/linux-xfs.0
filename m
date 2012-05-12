Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4CHXCRl198556 for <xfs@oss.sgi.com>; Sat, 12 May 2012 12:33:12 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id UfyK75tVP904wrVn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 May 2012 10:33:10 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id EE9A91822430
	for <xfs@oss.sgi.com>; Sat, 12 May 2012 19:33:08 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 353B2CD7C8C
	for <xfs@oss.sgi.com>; Sat, 12 May 2012 19:33:32 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: badly destroyed XFS (on LVM) - how to repair?
Date: Sat, 12 May 2012 19:33:04 +0200
Message-ID: <3096724.ecFtoeOHo8@saturn>
In-Reply-To: <1763478.Vy9F5bcWiZ@saturn>
References: <1763478.Vy9F5bcWiZ@saturn>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5193880376611581607=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5193880376611581607==
Content-Type: multipart/signed; boundary="nextPart1976836.SjO3jWyUz7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1976836.SjO3jWyUz7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Another strange thing:

I now started a "dd if=3D/dev/dm-0 of=3D/dev/null bs=3D1024k".
For the first seconds(!), it did nothing, I thought it would hang.
Then it started, but it's reading in a strange way:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq=
-sz avgqu-sz   await  svctm  %util
xvdg          139378,24     0,00 15893,61    0,00 77640,82     0,00    =
 9,77    35,96    2,26   0,06  99,88
xvda              0,00     0,00    0,00    0,00     0,00     0,00     0=
,00     0,00    0,00   0,00   0,00
xvde              0,00     0,00    0,00    0,00     0,00     0,00     0=
,00     0,00    0,00   0,00   0,00
xvdb              0,00     0,00    0,00    0,00     0,00     0,00     0=
,00     0,00    0,00   0,00   0,00
dm-0              0,00     0,00 155241,52    0,00 77620,76     0,00    =
 1,00   353,51    2,28   0,01  99,88

Very many I/Os and very slow KB/s. What could cause that?
lv readahead is 1536 sectors, that's 128KB per data disk (a 7 disk RAID=
-5) and should be OK.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1976836.SjO3jWyUz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+untQACgkQzhSR9xwSCbSzswCfcFjk+AJJcpyU4qVBSmWiwmtc
ThQAn0Kvpa9iOIdjgQJaGQTMMa7P04XL
=oDP1
-----END PGP SIGNATURE-----

--nextPart1976836.SjO3jWyUz7--


--===============5193880376611581607==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5193880376611581607==--
