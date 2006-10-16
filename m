Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 16:56:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GNuVaG016588
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 16:56:31 -0700
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13201D196C28
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 16:55:46 -0700 (PDT)
Subject: Re: [PATCH 1/2] Make stuff static
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <20061016232250.GM11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net>
	 <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
	 <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net>
	 <20061016232250.GM11034@melbourne.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6b2+Uh5CBg5be/cnvjPz"
Date: Mon, 16 Oct 2006 18:55:43 -0500
Message-Id: <1161042943.5723.117.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

--=-6b2+Uh5CBg5be/cnvjPz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2006-10-17 at 09:22 +1000, David Chinner wrote:
> On Mon, Oct 16, 2006 at 04:34:34PM -0500, Eric Sandeen wrote:
> > Eric Sandeen wrote:
> > > Timothy Shimmin wrote:
> > >> Okay, started looking :-)
> >=20
> > One other thing, based on the bug on osdl today, some of these larger
> > newly-static functions should probably be marked noinline to keep gcc
> > from doing things we don't want it to...
>=20
> <grumble>
>=20
> This is not an obvious compiler hint (compared to, say, likely()) as
> the functions gcc automatically inlines changes according to
> compiler version, optimisation level and platform. Hence adding
> noinline notation will be like playing whack-a-mole and I doubt it
> will be consistently used or maintained moving forward. It's the
> wrong solution, IMO.
>=20
> I think we should change the definition of STATIC so we don't have
> to poison the code to work around some stupid compiler behaviour.
> That is, unless we specifically say "inline" for static functions,
> we really mean "noinline".
So you are proposing?
/* non-debug */
#define STATIC static inline
/* debug */
#define STATIC noinline

That doesn't sound right that would inline everything that is static
which probably not a good idea in terms of stack usage.

#define STATIC static noinline
?
That doesn't work either ...
STATIC inline=20
becomes
static noline inline?


>=20
> This will also make debugging easier because we won't get stack
> traces that are apparently missing functions and all the associated
> pain that this can cause.
>=20
> Thoughts?
>=20
> Cheers,
>=20
> Dave.
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-6b2+Uh5CBg5be/cnvjPz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFNBv/NRmM+OaGhBgRAngwAJ9pD29OeW9vfof44oerTS23UO3R5gCbBV60
qoW3FFl09AGeYyRS68mCBm4=
=H6Ot
-----END PGP SIGNATURE-----

--=-6b2+Uh5CBg5be/cnvjPz--
