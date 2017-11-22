Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42868 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751259AbdKVRHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 12:07:19 -0500
Date: Wed, 22 Nov 2017 18:07:13 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171122170713.GD12684@amd>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
 <20171107184658.56b87d41@alans-desktop>
 <20171107191526.x3rzfcnnlmaz264d@thunk.org>
 <20171107192846.GA24617@infradead.org>
 <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cQXOx3fnlpmgJsTP"
Content-Disposition: inline
In-Reply-To: <CAOFm3uFLRCZwtw4F884Rd=5=yZnX_ibzBzyiC4f+=5iju4k81Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kate Stewart <kstewart@linuxfoundation.org>


--cQXOx3fnlpmgJsTP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi!
> Christoph:
>=20
> I am not speaking for Greg but let me highlight some issues and
> benefits as I chipped in a bit to help:
>=20
> Some data points in the 4.14.rc7 kernel:
> - there are 64,742 distinct license statements
>  ... in 114,597 blocks of text
>  ... in 42,602 files
> - license statements represent 480,455 lines of text
> - licenses are worded in 1,015 different ways
> - there are about 85 distinct licenses, the bulk being the GPL
>=20
> NB: All of these tallies were computed with scancode-toolkit [1]
>=20
> License text lines represent about 14.7% of all source comments.
> (using a CLOC to count comment lines)
>=20
> >From an engineering perspective this feels to me as pure madness,
> unless everyone in kernel land is in love with legalese!
>=20
> I like to think of it this way:
>=20
> Licensing is important but repetitive long boilerplate in patches and
> in every file is just a noisy distraction from the code substance.
>=20
> Imagine if the kernel had 500 versions of a printf() function?
> Maintainers would refactor the hell of it to use a few functions.
>=20
> Replacing the boilerplate with licensing ids is exactly the same:
> a sane refactoring to remove duplicated boilerplate.
>=20
> In the end and ideally there should be no more than one line of
> licensing info per file, so no more than 70Kish: so there are
> about 400K lines of boilerplate to remove.
>=20
> The benefits now and later:
> - no distraction with licensing boilerplate cr*p in patches and files

Well... No distraction you say?

> Note also that beside the kernel, U-Boot has adopted the same
> approach for quite a while, and in the application world the Eclipse

Yes, it works nicely for U-Boot.

But someone actually _added_ distraction. Top-level Makefile had no
distraction there and boom, here it is, totally uninteresting and just
at line one.

Lets look at random file in usb:

// SPDX-License-Identifier: GPL-2.0+
/*
 * Driver for SMSC USB3503 USB 2.0 hub controller driver
 *
 * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
 */
=2E..
MODULE_LICENSE("GPL");

=2E..do we agree that this is nowhere near distration-free? Ugly //
comment that screams for attention, away from other copyright info, it
hurts your eyes...

This would be improvement:

/*
 * Driver for SMSC USB3503 USB 2.0 hub controller driver
 *
 * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
 *
 * SPDX-License-Identifier: GPL-2.0+
 */

=2E..but what is above is just uuuugly.

=2E..as is MODULE_LICENSE having completely different tags from SPDX.

This would be even better:

/*
 * Driver for SMSC USB3503 USB 2.0 hub controller driver
 *
 * Copyright (c) 2012-2013 Dongjin Kim (tobetter@gmail.com)
 */
=2E..
SPDX_MODULE_LICENSE("GPL-2.0+")

So yes, SPDX can be improvement. But in current implementation it is
not.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cQXOx3fnlpmgJsTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAloVrsEACgkQMOfwapXb+vIf8gCeKVDad+VOZeY63vIUFBuzGlk7
CmEAoJmrfye23CNpoqWweROmFd3lfnFi
=mvVZ
-----END PGP SIGNATURE-----

--cQXOx3fnlpmgJsTP--
