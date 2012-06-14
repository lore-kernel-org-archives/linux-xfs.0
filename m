Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5E7VPXr231311 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 02:31:25 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id dhnkixKvaBpFP96B (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Jun 2012 00:31:22 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 2E5881828D99
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 09:31:21 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 3E13ECD7C8C
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 09:32:46 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
Date: Thu, 14 Jun 2012 09:31:20 +0200
Message-ID: <9309089.RkWiC1Z3da@saturn>
In-Reply-To: <4FD8BBDF.8060503@hardwarefreak.com>
References: <4FD66513.2000108@xsnews.nl> <6637532.ZKYiNbq2uo@saturn>
	<4FD8BBDF.8060503@hardwarefreak.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9223015200864803812=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============9223015200864803812==
Content-Type: multipart/signed; boundary="nextPart3346696.vH1IMt5REL"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart3346696.vH1IMt5REL
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Mittwoch, 13. Juni 2012, 11:12:15 schrieb Stan Hoeppner:
> This is the LSI/3ware firmware default policy Michael, so every user
> is safe out-of-the-box.  If the BBU/FBU is not present (never
> installed), or the control logic determines it is not functioning
> properly, the firmware disables writeback caching.
>=20
> In absence of paying attention to logs/alerts, one will know pretty
> quickly when the BBU has failed, as write performance with many/most
> workloads will fall off a cliff.

That's good, and I guess every serious raid with bbu behaves the same. =
I=20
just wanted to make a statement because many people read "maximum=20
performance" and want this then, without understanding the downsides ak=
a=20
"all data can be gone if a crash destroys the right metadata".=20

I get calls from people then whining, and they expect me not yell at=20=

them but be friendly, which I don't like ;-)

I prefer to not speak about max perf if it means "probably eats your=20=

data". Maybe we should always write "set this for max performance" only=
=20
with secure values, and then extra "and set this for turbo boost, but i=
t=20
eats your data on a crash". Hopefully this helps keeping people from=20=

just reading "max perf" and forget about the "eats your data" part.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart3346696.vH1IMt5REL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk/Zk0gACgkQzhSR9xwSCbRMKACffSqjJKNhf+FVfnOAPdrX2B49
IqMAn0L1DTTyAy/1ZbQyN2YaNynAjxO/
=YppU
-----END PGP SIGNATURE-----

--nextPart3346696.vH1IMt5REL--


--===============9223015200864803812==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9223015200864803812==--
