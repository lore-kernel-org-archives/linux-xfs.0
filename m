Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MG4f7s244572 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 11:04:42 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36AE63F80F1
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:07:21 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id hCZEorzFawLcTsDY for
	<xfs@oss.sgi.com>; Tue, 22 Jun 2010 09:07:21 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 037CD17D
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 18:07:19 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id B775A83C828
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 18:06:58 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: advice for repair after IO error on raid device
Date: Tue, 22 Jun 2010 18:07:18 +0200
References: <cone.1277217402.916517.87295.1001@bork.lsof.org>
In-Reply-To: <cone.1277217402.916517.87295.1001@bork.lsof.org>
MIME-Version: 1.0
Message-Id: <201006221807.19191@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7535535658838987732=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7535535658838987732==
Content-Type: multipart/signed;
  boundary="nextPart30416575.0clGQv9Z8g";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart30416575.0clGQv9Z8g
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 22. Juni 2010 Roel van Meer wrote:
> Jun 21 23:23:59 backup2 kernel: arcmsr6: abort device command of scsi
>  id =3D 0 lun =3D 0 Jun 21 23:24:10 backup2 kernel: arcmsr6: ccb
>  =3D'0xffff8800cb88ad40'????????????????????????????? isr got aborted

This does not sound like a simple failed disk. We also use Areca RAID=20
controllers, they are great, and a failed disk does *never* influence=20
the running system - that's what you have the RAID controller for, after=20
all. You only receive an e-mail from the controller about the disabled=20
disk.

The "isr got aborted" sounds like a driver problem, please report that=20
log snipped to areca support so they can help you (I'd be interested in=20
the results too - please tell me per PM once you know). The address is
support@areca.com.tw, and they tend to answer quickly and good.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart30416575.0clGQv9Z8g
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwg37cACgkQzhSR9xwSCbTFrwCg1azEZLuzkhEXZ5cDImApenaJ
WswAn2yFageL7Hh6SK+mGkLXE/H/T3QS
=SCPJ
-----END PGP SIGNATURE-----

--nextPart30416575.0clGQv9Z8g--


--===============7535535658838987732==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7535535658838987732==--
