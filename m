Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Oct 2006 15:47:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9HMkoaG009972
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 15:46:52 -0700
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29602D197BC3
	for <xfs@oss.sgi.com>; Tue, 17 Oct 2006 15:46:05 -0700 (PDT)
Subject: Re: [PATCH 1/2] Make stuff static
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <20061017215706.GI8394166@melbourne.sgi.com>
References: <20060929032856.8DA9C18001A5E@sandeen.net>
	 <23F15D6AE8566A54B81188AC@timothy-shimmins-power-mac-g5.local>
	 <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net>
	 <20061016232250.GM11034@melbourne.sgi.com>
	 <1161042943.5723.117.camel@xenon.msp.redhat.com>
	 <20061017005038.GN11034@melbourne.sgi.com>
	 <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com>
	 <20061017215706.GI8394166@melbourne.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L9yn1wy1prqtLxRXmmGg"
Date: Tue, 17 Oct 2006 17:45:31 -0500
Message-Id: <1161125131.5723.158.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Tim Shimmin <tes@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--=-L9yn1wy1prqtLxRXmmGg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2006-10-18 at 07:57 +1000, David Chinner wrote:
> On Tue, Oct 17, 2006 at 05:13:01PM +1000, Tim Shimmin wrote:
> > --On 17 October 2006 10:50:38 AM +1000 David Chinner <dgc@sgi.com> wrot=
e:
> > >Fix them - inline functions in header files should always be "static
> > >inline".  Inline functions in .c files should always be static as
> > >well - if they need to be accessed from different source files then
> > >they need to be in header files.  Hence "STATIC inline" is broken
> > >code and should be fixed anyway. Luckily, there are very few of
> > >these to fix and they are all in .c files:
> > >
> > >chook 137% grep -rIw "STATIC inline" fs/xfs | wc -l
> > >21
> >=20
> > So you are saying that "static inline"s should always be.
>=20
> Yup.
>=20
> > So for CONFIG_XFS_DEBUG where we define STATIC and so make static
> > disappear for uses of STATIC, we will no longer touch these
> > "static inline" functions.
>=20
> Yup. The function will still get inlined, so changing it's scope on
> debug builds doesn't provide any benefit IMO. FWIW, for debug
> builds we probably want noinline....
>=20
> > I thought that for debug, we could stop them from being inline
> > for easier debugging. We could have a STATIC_INLINE :-)
>=20
> We could, but I don't think it gains us anything.
I agree with Tim on this.
when I see STATIC in the code it's generally assumed to=20
be a way to toggle of static on/off. Adding static inline=20
to the #define STATIC starts to overload the the macro=20
and creates an obfuscation that isn't immediately obvious.
STATIC_INLINE should be fairly obvious.


>=20
> Cheers,
>=20
> Dave.
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-L9yn1wy1prqtLxRXmmGg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFNV0KNRmM+OaGhBgRAvMGAJ9a5VIk7lLtXf12x9n/ngyF0rcNbQCdGMe0
AWpEtccrEFgjtbEZv86lywE=
=yonI
-----END PGP SIGNATURE-----

--=-L9yn1wy1prqtLxRXmmGg--
