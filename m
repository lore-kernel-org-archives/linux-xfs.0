Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42783 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdKYTR2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 14:17:28 -0500
Date: Sat, 25 Nov 2017 20:17:26 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171125191726.GA6886@amd>
References: <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20171117150639.0e706421@vento.lan>
 <alpine.DEB.2.20.1711171850330.2186@nanos>
 <20171117183946.GA28533@lst.de>
 <alpine.DEB.2.20.1711221207460.1751@nanos>
 <20171122095117.49c558a4@vento.lan>
 <20171122134804.GA30796@kroah.com>
 <20171125190447.GB5114@amd>
 <CA+55aFyGDE1tB-5ms6yHFUujJ815FoQQE2SceXDybiT8xcvgpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <CA+55aFyGDE1tB-5ms6yHFUujJ815FoQQE2SceXDybiT8xcvgpQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@s-opensource.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-11-25 09:11:58, Linus Torvalds wrote:
> On Sat, Nov 25, 2017 at 9:04 AM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > That does not sound like he was deciding between /* */ and //. And
> > actually this was in context of files with no existing license. You
> > made the ugly patches. Stop hiding behind Linus.
>=20
> No, Linus happily stands up for //.
>=20
> I really don't like one-liner /* */ comments. Let's face it, // was
> the _one_ thing C++ got right, among all the horrible bad decisions.
>=20
> I think we should just start moving to // in general, but only when
> adding new ones (ie I don't want to see any automatic conversion
> patches).
>=20
> And it's _particularly_ true for the whole case where we mix
> one-liners like the SPDX line with block comments. That's where /* */
> really sucks.

I agree that we should not do

/* SPDX-License-Identifier:     GPL-2.0+ */
/*
 * Driver for SMSC USB3503 USB 2.0 hub controller driver
 *
 * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
 */

There's logical place in the comment, and it should look like this:

/*
 * Driver for SMSC USB3503 USB 2.0 hub controller driver
 *
 * SPDX-License-Identifier:     GPL-2.0+
 * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
 */

So I'm not saying "use one-line comments with SPDX identifier". I'm
saying place it where people expect it.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloZwcYACgkQMOfwapXb+vJkoACfY3LlGMnMukoXzwwlI22RmuXJ
ItkAoIGbAQKW+rR/OCA2hi1eLZbA1pdy
=K+L7
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
