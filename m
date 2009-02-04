Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14FPDgA159134 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 09:25:13 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 747EFE6A27
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 07:24:33 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 302X1c7yJABvl4PM for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 07:24:33 -0800 (PST)
Received: from mailsrv2.i.zmi.at (h081217054243.dyn.cm.kabsi.at
	[81.217.54.243])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 3D42A3D4F
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:24:33 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id EC9A9400171
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:24:32 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_force_shutdown after Raid crash
Date: Wed, 4 Feb 2009 16:24:27 +0100
References: <498376CF.8020806@renderforce.de> <200902040952.45440@zmi.at>
	<20090204122241.GL24173@disturbed>
In-Reply-To: <20090204122241.GL24173@disturbed>
MIME-Version: 1.0
Message-Id: <200902041624.32354@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0351599141675911664=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0351599141675911664==
Content-Type: multipart/signed;
  boundary="nextPart5224402.24jGHsuhDg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5224402.24jGHsuhDg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

(compressing 2 answers here)

On Mittwoch 04 Februar 2009 Dave Chinner wrote:
> > With a single hard disk and barriers turned on (on=3Ddefault), a
> > powerfail "only" looses data in the cache but at least does not
> > destroy the filesystem.
>
> I'd drop this paragraph - powerfail can destroy filesystems even on
> a single disk (e.g. root directory gets corrupted).

Isn't that what barriers are for? If I understand correctly, barriers=20
help against destroying the filesys, except root dir? But that should=20
"easily" be fixable with xfs_repair or so?

I'd like to have a paragraph for normal XFS users, a PC with harddisks,=20
maybe with onboard RAID1 or 10. So if I could let the paragraph, that=20
should be OK (as I hope the root dir destroy is a very, very seldom=20
case).

> > With a RAID controller with battery backed cache, you should turn
> > off barriers, as recommended above. But then you *must* disable the
> > hard disk write cache in order to ensure to keep the filesystem
> > intact after a power failure.
>
> I'd change this to say "*must* disable the individual hard disk
> write caches" to make it clear that it is referencing the disks
> behind the raid controller. I'd also say "The method for doing this
> is different for each RAID controller. Please consult your RAID
> controller documentation to determine how to change these settings."

That sounds good and I'll put it in.

On Mittwoch 04 Februar 2009 Emmanuel Florac wrote:
> I have some controllers at hand, and I had a quick glance :
> - Areca : Allows setting individual cache for passthru disks, needs
> actual testing for drives part of an array.

Areca allows "Disk Write Cache Mode" on/off under "System Controls" ->=20
"System Config" in the archttpd web interface, plus per Volume write=20
back cache on/off, but that's not relevant when using battery (and those=20
who don't - don't care anyway about their data).

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart5224402.24jGHsuhDg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmJszAACgkQzhSR9xwSCbTaoACg6udMEqM+KztpqeWtO8CwTFXD
PjoAoN7wdkuplK2pidl1hHP/k8saBtpF
=5vXg
-----END PGP SIGNATURE-----

--nextPart5224402.24jGHsuhDg--


--===============0351599141675911664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0351599141675911664==--
