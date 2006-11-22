Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Nov 2006 17:23:32 -0800 (PST)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAM1NNaI001397
	for <xfs@oss.sgi.com>; Tue, 21 Nov 2006 17:23:25 -0800
Subject: Re: [PATCH 1/2] Make stuff static
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <20061122004216.GT11034@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net>
	 <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
	 <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net>
	 <20061016232250.GM11034@melbourne.sgi.com>
	 <1161042943.5723.117.camel@xenon.msp.redhat.com>
	 <20061017005038.GN11034@melbourne.sgi.com>
	 <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com>
	 <20061017215706.GI8394166@melbourne.sgi.com>
	 <1161125131.5723.158.camel@xenon.msp.redhat.com>
	 <20061122004216.GT11034@melbourne.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6xPZTyS3NQLbgyeu3PBL"
Date: Tue, 21 Nov 2006 19:09:43 -0600
Message-Id: <1164157783.19915.46.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Tim Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--=-6xPZTyS3NQLbgyeu3PBL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-11-22 at 11:42 +1100, David Chinner wrote:
> On Tue, Oct 17, 2006 at 05:45:31PM -0500, Russell Cattelan wrote:
> > On Wed, 2006-10-18 at 07:57 +1000, David Chinner wrote:
> > > On Tue, Oct 17, 2006 at 05:13:01PM +1000, Tim Shimmin wrote:
> > > > I thought that for debug, we could stop them from being inline
> > > > for easier debugging. We could have a STATIC_INLINE :-)
> > >=20
> > > We could, but I don't think it gains us anything.
> > I agree with Tim on this.
> > when I see STATIC in the code it's generally assumed to=20
> > be a way to toggle of static on/off. Adding static inline=20
> > to the #define STATIC starts to overload the the macro=20
> > and creates an obfuscation that isn't immediately obvious.
> > STATIC_INLINE should be fairly obvious.
>=20
> Ok, so I've had time to look at this again. Here's the definitions
> of STATIC and STATIC_INLINE for debug and nondebug from the
> patch (whitespace damaged):
>=20
> Index: 2.6.x-xfs-new/fs/xfs/support/debug.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- 2.6.x-xfs-new.orig/fs/xfs/support/debug.h   2006-11-22 10:54:37.08998=
4780 +1100
> +++ 2.6.x-xfs-new/fs/xfs/support/debug.h        2006-11-22 11:30:20.43332=
6839 +1100
> @@ -38,13 +38,37 @@ extern void assfail(char *expr, char *f,
>=20
>  #ifndef DEBUG
>  # define ASSERT(expr)  ((void)0)
> -#else
> +
> +#ifndef STATIC
> +# define STATIC static noinline
> +#endif
> +
> +#ifndef STATIC_INLINE
> +# define STATIC_INLINE static inline
> +#endif
> +
> +#else /* DEBUG */
> +
>  # define ASSERT(expr)  ASSERT_ALWAYS(expr)
>  extern unsigned long random(void);
> -#endif
>=20
>  #ifndef STATIC
> -# define STATIC static
> +# define STATIC noinline
> +#endif
> +
> +/*
> + * We stop inlining of inline functions in debug mode.
> + * Unfortunately, this means static inline in header files
> + * get multiple definitions, so they need to remain static.
> + * This then gives tonnes of warnings about unused but defined
> + * functions, so we need to add the unused attribute to prevent
> + * these spurious warnings.
> + */
> +#ifndef STATIC_INLINE
> +# define STATIC_INLINE static __attribute__ ((unused)) noinline
>  #endif
>=20
> +#endif /* DEBUG */
> +
> +
>  #endif  /* __XFS_SUPPORT_DEBUG_H__ */
>=20
> ------
>=20
> Is this acceptible to everyone?
Yup.

>=20
> FWIW, there is one other thing that this conversion causes
> problems with, and that's variable definitions. i.e. we can't
> use STATIC on them any more because of the "noinline" attribute
> it has. Do we care about this and if so, any suggestions on
> how to keep this functionality (a different STATIC_xxx define
> for structures)?
So I know things like systemtap kgdb oprofile all work better when
functions are not static, but what about variables/structures?
do things really get that confused?
Maybe we shouldn't worry about conditioning them and just make them
static

=20=20


>=20
> Cheers,
>=20
> Dave.
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-6xPZTyS3NQLbgyeu3PBL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFY6NXNRmM+OaGhBgRAhAOAJ9TZfVNTZJCP+bBnvSGtGGEpl1GaACfauSg
+V4kBh6aZQUOh2WK++10dg4=
=/5gO
-----END PGP SIGNATURE-----

--=-6xPZTyS3NQLbgyeu3PBL--
