Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42497 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdKYTEt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 14:04:49 -0500
Date: Sat, 25 Nov 2017 20:04:47 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171125190447.GB5114@amd>
References: <20171116183306.103584007@linutronix.de>
 <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20171117150639.0e706421@vento.lan>
 <alpine.DEB.2.20.1711171850330.2186@nanos>
 <20171117183946.GA28533@lst.de>
 <alpine.DEB.2.20.1711221207460.1751@nanos>
 <20171122095117.49c558a4@vento.lan>
 <20171122134804.GA30796@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <20171122134804.GA30796@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-11-22 14:48:04, Greg Kroah-Hartman wrote:
> On Wed, Nov 22, 2017 at 09:51:17AM -0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 22 Nov 2017 12:12:04 +0100 (CET)
> > Thomas Gleixner <tglx@linutronix.de> escreveu:
> >=20
> > > On Fri, 17 Nov 2017, Christoph Hellwig wrote:
> > > > On Fri, Nov 17, 2017 at 07:11:41PM +0100, Thomas Gleixner wrote: =
=20
> > > > > Introcude a MODULE_LICENSE_SPDX macro which flags the module info=
 storage
> > > > > as 'SPDXIFY' and let the postprocessor do: =20
> > > >=20
> > > > Shouldn;t this be a FILE_LICENSE_SPDX?  I'd also much prefer that o=
ver
> > > > the nasty C99 comments to start with.  And while I'm a bit behind on
> > > > email I still haven't managed to find a good rationale for those to
> > > > start with.
> >=20
> > Yeah, I also find nasty to have things like this on each C file:
> >=20
> > // SPDX-License-Identifier: GPL-2.0
> > /*
> >  * Copyright ...
> >  * ...
> >  */
> >=20
> > Also, one may forget that headers use /**/ and end by doing the wrong
> > thing, as a common practice is to just cut-and-paste the same copyright
> > header on both C and H files at development time.
>=20
> You break the build when you get it wrong, so you will notice it.  For
> most "internal" .h files, using // is just fine.
>=20
> Yes, it's "ugly", but again, that's what Linus said he wanted it to look
> like, take it up with him :)

Linus said:

# So in general, the _hope_ is that we can just end up replacing
# existing boilerplate comments with that single line SPDX comment
# (using "//" in *.[ch] files, but obviously some other kinds of files
# end up having a different comment character, typically '#').

That does not sound like he was deciding between /* */ and //. And
actually this was in context of files with no existing license. You
made the ugly patches. Stop hiding behind Linus.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloZvs8ACgkQMOfwapXb+vIylwCfYL+Yxk78oXdtfhec0zu8/io/
ThwAn1zKayZJ1mp9Z/v+N4UrDXdy2sQZ
=7uQE
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
