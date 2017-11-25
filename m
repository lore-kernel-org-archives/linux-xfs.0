Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42687 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdKYTMZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Nov 2017 14:12:25 -0500
Date: Sat, 25 Nov 2017 20:12:23 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171125191223.GC5114@amd>
References: <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
 <20171122170713.GD12684@amd>
 <20171122175346.GB6528@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
Content-Disposition: inline
In-Reply-To: <20171122175346.GB6528@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > This would be even better:
> >=20
> > /*
> >  * Driver for SMSC USB3503 USB 2.0 hub controller driver
> >  *
> >  * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
> >  */
> > ...
> > SPDX_MODULE_LICENSE("GPL-2.0+")
> >=20
> > So yes, SPDX can be improvement. But in current implementation it is
> > not.
>=20
> Again, as people seem to keep still missing this point, Linus asked for
> the format to look like it does today, using // at the top.  Thomas and
> I originally did it first the way with the SPDX line in the big comment
> block.
>=20
> If you don't like the format, complain and convince him otherwise, you
> are not getting anywhere by responding to this old topic about it
> again.

Hey, Linus. This // SPDX at the begining of file looks really
ugly. Can we get something that looks less bad?

And BTW I responded to this uglyness before, but you just tried to
make me shut up, and then did not reply. Given what quality you
normally expect from patch submitters, you are doing pretty poor job
here.

> Having it be the first line of the file is good, it's obvious, and
> stands out, which is the point, you want it to, it's a license :)

What is good about that? License is about the least interesting thing
about the file. Point of SPDX conversion (see the mail I was replying
to?) was to make license information _less_ intrusive, not more. Tools
can find SPDX anywhere in the file for the people that really care.

That's how it works in U-Boot, which people are using as example of
reasonable SPDX conversion:

/*
 * Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
 * Copyright (c) 2010-2011 NVIDIA Corporation
 *  NVIDIA Corporation <www.nvidia.com>
 *
 * SPDX-License-Identifier:     GPL-2.0+
 */

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--rQ2U398070+RC21q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloZwJcACgkQMOfwapXb+vLm3QCePdWz0eyK72AcRBd+Xz06TzxB
PgUAoINQSGDgbkP5QDzveW0VSFc+3is7
=O+HG
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
