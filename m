Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42235 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdKYSvn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 13:51:43 -0500
Date: Sat, 25 Nov 2017 19:51:40 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch V4 01/11] Documentation: Add license-rules.rst to
 describe how to properly identify file licenses
Message-ID: <20171125185140.GA5114@amd>
References: <20171116183306.103584007@linutronix.de>
 <20171116184358.398030394@linutronix.de>
 <alpine.DEB.2.20.1711171057240.1709@nanos>
 <20171117150639.0e706421@vento.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20171117150639.0e706421@vento.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Russell King <rmk+kernel@armlinux.org.uk>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs@vger.kernel.org, Charlemagne Lasse <charlemagnelasse@gmail.com>, Carmen Bianca Bakker <carmenbianca@fsfe.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-11-17 15:06:39, Mauro Carvalho Chehab wrote:
> Hi Thomas,
>=20
> Em Fri, 17 Nov 2017 11:00:33 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> escreveu:
>=20
> > Subject: Documentation: Add license-rules.rst to describe how to proper=
ly identify file licenses
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Fri, 10 Nov 2017 09:30:00 +0100
> >=20
> > Add a file to the Documentation directory to describe how file licenses
> > should be described in all kernel files, using the SPDX identifier, as =
well
> > as where all licenses should be in the kernel source tree for people to
> > refer to (LICENSES/).
> >=20
> > Thanks to Kate, Greg and Jonathan for review and editing and Jonas for =
the
> > suggestions concerning the meta tags in the licenses files.
> >=20
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>=20
> The document itself looks good, but I think it should also mention
> what would be the expected values for the MODULE_LICENSE() macro and
> how each license would be mapped into it.
>=20
> Right now, include/linux/module.h says:
>=20
> /*
>  * The following license idents are currently accepted as indicating free
>  * software modules
>  *
>  *	"GPL"				[GNU Public License v2 or later]

Hmm. AFAICT Greg translated GPL as GPL v1 or later. That seemed
wrong... and now it seems even more wrong.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloZu7wACgkQMOfwapXb+vInsACgl8OvtwbLO8qiw6NPDgIDgFbZ
c18AnRngkGne/+G0QXQmUpHBlNz4Jf6m
=gKKs
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
