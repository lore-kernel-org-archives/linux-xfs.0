Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 13:10:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65KAGBS001413
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 13:10:16 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93EAC18810E4
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 13:11:18 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id sQ5aH93GyrxcCxwL for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 13:11:18 -0700 (PDT)
Received: from localhost (DSL01.83.171.151.103.ip-pool.NEFkom.net [83.171.151.103])
	by mail.lichtvoll.de (Postfix) with ESMTP id 75A9B5AE2C
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 22:11:17 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: grub fails boot after update
Date: Sat, 5 Jul 2008 22:11:10 +0200
References: <alpine.LNX.1.10.0807011712470.20393@fbirervta.pbzchgretzou.qr> <486C4D7E.8060608@sandeen.net> <20080703044755.GA13630@jdc.jasonjgw.net> (sfid-20080703_143045_158241_F738FCFB)
In-Reply-To: <20080703044755.GA13630@jdc.jasonjgw.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1458418.nLvPYxNhxp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807052211.10899.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart1458418.nLvPYxNhxp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

Am Donnerstag 03 Juli 2008 schrieb Jason White:
> On Wed, Jul 02, 2008 at 10:54:38PM -0500, Eric Sandeen wrote:
> > This really is grub that is busted, but I'd still just suggest using
> > ext3 to (mostly) work around the breakage for the foreseeable future.
> >
> > The other option is to teach grub to always do its io via the
> > filesystem not the block device while the fs is mounted (IIRC there
> > are various & sundry non-intuitive commands which actually nudge grub
> > towards or away from this desired behavior... --with-stage2=3D/path is
> > one I think, skipping the "verification" phase (i.e. trying to read
> > the block dev while mounted) is another)
>
> Does grub 2 (still in development when last I checked) improve on this
> situation?
>
> I managed to get Grub 1 installed on machines with XFS root file
> systems by running the install from within the grub "shell" environment
> rather than using grub-install. Maybe this skips the checks that
> attempt to read the block device directly. I also recall that
> grub-install failed.

I use GRUB 1 on XFS ever since. But I also used the GRUB shell directly to=
=20
write it. grub-install doesn't work reliable.

I even use the functionality to save the last booted menu entry=20
into /boot/grub/default without a problem.

I agree, reading or writing a mounted filesystem directly is not a good=20
idea.

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1458418.nLvPYxNhxp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhv1V4ACgkQmRvqrKWZhMdDqwCePOKU7SJNz/BZzeyK4RFzmCil
MJMAn2geMcOGw3UWCJKl/gE39nsaLfK+
=ckdq
-----END PGP SIGNATURE-----

--nextPart1458418.nLvPYxNhxp--
