Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4U8w0VH089455 for <xfs@oss.sgi.com>; Sun, 30 May 2010 03:58:00 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BC81384CA8
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 02:00:24 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Vb51QWzVjQkQLlVC for
	<xfs@oss.sgi.com>; Sun, 30 May 2010 02:00:24 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id AF3CF800184
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 11:00:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 6416483C825
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 11:00:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: puzzling error: XenServer, LVM and XFS
Date: Sun, 30 May 2010 11:00:22 +0200
References: <201005270857.39048@zmi.at> <20100527115153.GB13112@infradead.org>
In-Reply-To: <20100527115153.GB13112@infradead.org>
MIME-Version: 1.0
Message-Id: <201005301100.22827@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0501286802025925666=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0501286802025925666==
Content-Type: multipart/signed;
  boundary="nextPart1648402.nkTk5fVA1n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1648402.nkTk5fVA1n
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 27. Mai 2010 Christoph Hellwig wrote:
> This looks like the Xen block device code is buggy and doesn't handle
> the I/O pattern XFS throws at it.  A sector 0 error during mount
>  usually is the superblock barrier test write.

One strange thing I want to mention: This doesn't only happen during=20
mount, but also during runtime:

[272445.900691] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.900959] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.900966] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.901149] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.906411] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.906693] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.906700] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.906885] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.924679] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.924948] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.924956] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272445.925111] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.543881] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.544198] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.544205] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.544354] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.548822] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.549069] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.549077] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272447.549226] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.264465] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.264808] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.264816] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.265007] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.270708] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.270950] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.270958] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272449.271107] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.481089] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.481360] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.481368] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.481646] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.484787] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.485069] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.485077] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.485220] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.504376] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.504633] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.504642] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.504790] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.505045] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.505274] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.505281] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.505425] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.512789] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.513154] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.513162] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.513309] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.530959] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.531352] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.531361] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272450.531543] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.173596] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.173887] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.173896] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.174055] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.175007] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.175268] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.175275] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.175443] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.175815] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.176056] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.176063] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.176221] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.176793] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.177010] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.177016] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.177198] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.559967] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.560240] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.560247] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.560420] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.565146] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.565408] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.565415] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272452.565581] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.296089] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.296357] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.296365] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.296523] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.301814] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.302083] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.302091] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272454.302277] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.575577] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.575824] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.575832] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.575974] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.576165] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.576403] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.576410] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.576552] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.580690] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.580981] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.580989] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272457.581186] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.343053] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.343330] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.343338] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.343521] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.343750] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.344086] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.344093] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.344236] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.348876] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.349152] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.349159] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272459.349357] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.217232] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.217530] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.217539] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.217719] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.218443] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.218712] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.218720] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.218887] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.219677] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.219943] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.219982] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.220138] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.592004] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.592285] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.592293] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.592486] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.597265] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.597531] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.597539] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272462.597706] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.375703] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.375992] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.376000] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.376157] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.381090] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.381385] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.381392] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272464.381585] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272467.608382] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272467.608671] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272467.608678] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272467.608862] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20
[272467.613789] end_request: I/O error, dev xvdb, sector 0                 =
                                                                           =
                                                                           =
 =20

Does XFS always recheck for barriers? Or is it because I specified=20
"barrier" as a mount option, but it doesn't work and XFS didn't detect=20
it doesn't work?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1648402.nkTk5fVA1n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwCKSYACgkQzhSR9xwSCbSZpACg4Tlr6fgzItE0EjhEE3dG4PAD
qFMAoMsaVnpMwey9DU93HB7Bm2SAKf7S
=jLFA
-----END PGP SIGNATURE-----

--nextPart1648402.nkTk5fVA1n--


--===============0501286802025925666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0501286802025925666==--
