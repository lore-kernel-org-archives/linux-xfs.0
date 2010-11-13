Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oADFXqaN013861 for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 09:33:52 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8043B1778FE
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 07:35:21 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id REjAddJw1AFMmnH5 for
	<xfs@oss.sgi.com>; Sat, 13 Nov 2010 07:35:21 -0800 (PST)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id C376A17E
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 16:35:20 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 81377401C33
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 16:35:19 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair of critical volume
Date: Sat, 13 Nov 2010 16:35:18 +0100
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<20101113091938.1d0553a8@galadriel.home>
	<4CDE5A4D.9090905@hardwarefreak.com>
In-Reply-To: <4CDE5A4D.9090905@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201011131635.19396@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4576592521949792041=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4576592521949792041==
Content-Type: multipart/signed;
  boundary="nextPart214976302.dGAXD90MQa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart214976302.dGAXD90MQa
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 13. November 2010 Stan Hoeppner wrote:
> You've missed the point of this sub thread discussion, or I did.  He
> stated that having the metadata show the files still exist is a
> positive thing.  The files are gone.  I stated that this discrepancy
> is not good thing.

And it's *not* a problem of the filesystem that that data is gone. The=20
OP took 1/5 of the disk area and basically overwrote it with zeroes. He=20
can be very lucky if there's even a single file still readable. That's=20
definitely *robustness* of XFS. If you take 1/5th of any filesytem and=20
replace it with zeroes, how many FS would will work after that, or be in=20
a workable state?
=20
> I believe you are confused, thinking this micro discussion is dealing
> with the OP's overall situation.  It is not.  It is dealing strictly
> with the issue of the lost set of disks, the files that were on them,
> and the fact the metadata says they still exist.  I believe this is
> due to the fact that he hasn't run a destructive xfs_repair yet,
> which I'm guessing will remove those orphaned metadata entries.

Maybe, but you took my message, which solely described that XFS is=20
incredible to still work, and mix it with the wish to still have that=20
data.

Yes, the OP is in the shit, but it's more or less his own fault. Having=20
no full backup, and destroying 1/5th of the disk is very crazy. If he=20
can still recover the rest of the contents, he can be very lucky and=20
proud to have used XFS. Other FS maybe wouldn't have been so nice.

And I believe no "chkdsk" type program like xfs-repair is designed to=20
recover from partly overwritten disks anyway. The sole purpose is to=20
bring the filesystem back to a working state.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart214976302.dGAXD90MQa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzesDcACgkQzhSR9xwSCbRsxQCgznWsxYjX9bH5uzeepc35pEei
eagAoMFo1Rl0ov9KAkX1JKcp9H0Zv7YA
=PI+Z
-----END PGP SIGNATURE-----

--nextPart214976302.dGAXD90MQa--


--===============4576592521949792041==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4576592521949792041==--
