Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8C6987CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 20:52:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 51CCF8F8035
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 18:52:41 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id CmkXqOrfgAN9KlUg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2016 18:52:38 -0700 (PDT)
Date: Wed, 10 Aug 2016 09:52:36 +0800
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH xfsprogs] libxcmd: link against used libs
Message-ID: <20160810015236.GD30544@vapier.lan>
References: <20160809144343.2228-1-vapier@gentoo.org>
	<20160809214910.GI19025@dastard>
MIME-Version: 1.0
In-Reply-To: <20160809214910.GI19025@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2214502182135430538=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============2214502182135430538==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline


--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10 Aug 2016 07:49, Dave Chinner wrote:
> On Tue, Aug 09, 2016 at 10:43:43PM +0800, Mike Frysinger wrote:
> > Since this lib uses symbols from libxfs (platform_findsizes) and many
> > symbols from libblkid, link against both.  Otherwise, the resulting
> > shared lib has missing symbols which makes linking against annoying.
>=20
> libxcmd is an internal library, linked directly into the xfsprogs
> binaries. It is never shipped or used outside xfsprogs, so what is
> trying to use libxcmd as a shared library that doesn't also link
> against libblkid or libxfs?

shouldn't internal libs still have coherent linkage ?  otherwise you
cause problems even internally for xfs -- any other libs or progs that
link against libxcmd have to list all the libs that libxcmd happen to
use itself.  it also means that you get correct link order which is
otherwise not guaranteed.  e.g. just because you say libxfs needs to
use libblkid doesn't mean the linker must put that after libxcmd in
the link list.
-mike

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXqojjAAoJEEFjO5/oN/WBqM4QAJBg08Gb7wPrSh/eas/fKCgf
Fd23anmhIvmn11Aal7BnvdFs5szHWkyurW+hv7IhlorqrCGnTeF9q0ikxsU0HrH8
H1RKka9E2r7ao99eZ0qVlEiIMjBLfNAP8k3kYj+25oskR2R884VwzsSiP9zQGmp+
cmkqCw4pzOlG2AaYX1013YXu8h9YIzsakhzaKbOSiBDjEZl6vGxipEm7JlE1CMWg
oabMPNdxXZM4LupjpudNp99tEsGALQIYja61kzXTrMqQYUV0k2hdUH//ooiOc80f
/X9VFDxcIr8BhmCycik9wYgd/AZ80cU8rnR7t8Vm0MyhXoEA9fFGDrD6FeLZTVMk
JhIIsHggllxxxvanMg0mJwO5anDXMX6rcv3LviewUsHbLI5PPvcj10vdAWfHrQgQ
WgykA2tZNqojUrOXWp4pwmjPpsAYfgt/cOpGX7yJ5cz57S8WFYy6eytBKD6hm+Td
plNN3aD5qQ2sLRh+Zw/lHQzzBh5S68RdqT1fB6frlo4N3Q5Uk2zJqeIZ56VXjRMA
jKCYTBOqUT/ui8G7Wg4vkNofktPgflADK6t16NOZtQ8P8H4eyl7wJiDD6SVnCVA5
kle30lG/2pRzZOHDRiJBdPGgBzv9lNVFZ5yAdFSazWoGEc0GBIW7ojoqG4UGUaeo
IiHsCkI+BgZ6W3d43odR
=OmHM
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--


--===============2214502182135430538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2214502182135430538==--
