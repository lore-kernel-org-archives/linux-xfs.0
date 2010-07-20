Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KLVnde042306 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 16:31:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E19711BE2675
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 14:34:48 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id DmoRf88qfKhFwaa2 for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 14:34:48 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id CEB86400
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 23:34:46 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 6CC6C83C82E
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 23:33:58 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4k sector drives
Date: Tue, 20 Jul 2010 23:34:45 +0200
References: <201007202058.35141@zmi.at>
	<20100720223905.296a780a@galadriel.home>
In-Reply-To: <20100720223905.296a780a@galadriel.home>
MIME-Version: 1.0
Message-Id: <201007202334.46105@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0532925414237920651=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0532925414237920651==
Content-Type: multipart/signed;
  boundary="nextPart1607259.LvtpkIzvV4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1607259.LvtpkIzvV4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 20. Juli 2010 Emmanuel Florac wrote:
> They come in emulation mode (like many SATA-II drives came in SATA-I
> mode). You must set them to 4K blocks manually, for WD IIRC with a
>  DOS software. And you need a controller that supports 4K blocks, too
>  (probably anything older than a year won't).
=20
Thank you Emmanuel and Stan,

http://wdc-de.custhelp.com/cgi-
bin/wdc_de.cfg/php/enduser/std_adp.php?p_faqid=3D5324&p_created=3D&p_cats=
=3D185&p_cv=3D1.185&p_pv=3D2.294&p_prods=3D227%2C294#jumper

shows a jumper exists for "advanced format", but doesn't tell what it=20
does. I'll try to set or unset it depending on what it is now, and see=20
if there's a difference.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1607259.LvtpkIzvV4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxGFnYACgkQzhSR9xwSCbT4HgCfTQEDWQLj+86xGps0Ks05COw+
I0QAoJLrEsUXWh/PYhp7YjUxUQPKNViO
=nyRc
-----END PGP SIGNATURE-----

--nextPart1607259.LvtpkIzvV4--


--===============0532925414237920651==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0532925414237920651==--
