Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KDJhok021914 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 08:19:44 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 867651B8B580
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 06:22:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id z67Zd3aNuIFHvis0 for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 06:22:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 30873400
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 15:22:40 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 1D9A783C82E
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 15:21:52 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Calculating swidth On A RAID6 Volume
Date: Tue, 20 Jul 2010 15:22:39 +0200
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
In-Reply-To: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
MIME-Version: 1.0
Message-Id: <201007201522.39455@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5827399262338136230=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5827399262338136230==
Content-Type: multipart/signed;
  boundary="nextPart1947574.QRppP5lvmP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1947574.QRppP5lvmP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 20. Juli 2010 Andrew Debenham wrote:
> I'm am new to XFS and am in the process of trying to tune an XFS file
>  system.  I spent some time searching through this mailing list's
>  archives but wasn't able to find anything that matched the question
>  that I have (I apologize in advance if this issue has already been
>  addressed).

Thanks for reminding me, wanted to write a FAQ entry, done now:
http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Csw=
idth_values_for_optimal_performance

> I have a 3ware 9650SE-12M installed and have a RAID6 unit with 11 x
>  1.82 TB SATA drives and stripe size of 256KB.  I found an earlier
>  thread that discussed calculating the values for sunit and swidth
>  for RAID5, which stated that the swidth would be "sunit x (# disks
>  in stripe - 1)".  So, finally the question - would the swidth for a
>  RAID6 volume be "sunit x (# disks in stripe -2)?
>=20
> If that is the case, then here is what I would expect my values to
>  be: sunit =3D 512
> swidth =3D 4608
=20
I think sunit should be as big as the RAID controllers stripe size, as=20
it describes the smallest I/O XFS should do. So sunit=3D512 would make it=20
possible that XFS writes a single sector, while the RAID controller=20
needs to read/write 256KB with your stripe size, resulting in=20
performance degradation. But I'm no XFS dev, so maybe wait for a=20
clearing from someone who has deeper XFS knowledge than me.

sunit=3D262144
swidth=3D9

Would be my suggestion for your setup.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1947574.QRppP5lvmP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxFox8ACgkQzhSR9xwSCbQoqgCgoM/lymsAY6MtAx1G+Qs9OGDS
HksAn170J++BL/No26f1qis0hG51yO/w
=Z8UG
-----END PGP SIGNATURE-----

--nextPart1947574.QRppP5lvmP--


--===============5827399262338136230==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5827399262338136230==--
