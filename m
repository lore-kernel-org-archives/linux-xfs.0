Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E7818D
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 00:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803298; cv=none; b=Ns0E4fG+kIzahRyYr3Hh56zyeMvVdY4viny/Cuv735mWcUXISB60vouhNNVMnz+B4YLFT3Dq2kg1+8swARqlebuCwK1SyDYv5wT+PX8JG760Bda8QRyVQJ6V+yIxDPCqmsox1lniySfpE5jvPeYH6BxhQxT3o9IJq2FdcrBGtUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803298; c=relaxed/simple;
	bh=T2m7Ig5hek5R/JnzbEvSETLiS0yn9d35FgAPardwfZE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VTtVfONuzxJ+IbGwDc5CQWCgnUg70F4gPeaZgNtiT7N820+/0ouykCQ5Yx9v6muXoT3FHO1DiM16SOl1wZP4z692AXNEgUsx08TXxYk54eGjv6AO25o/4+d5scCPlbDzBhtpRr/qnVDD5a7ez3tJUFZNf7J7vDeWZiBLtxttus8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: kernel@mattwhitlock.name,  linux-xfs@vger.kernel.org,  hch@lst.de
Subject: Re: [RFC PATCH] libxfs: compile with a C++ compiler
In-Reply-To: <20240827234533.GE1977952@frogsfrogsfrogs> (Darrick J. Wong's
	message of "Tue, 27 Aug 2024 16:45:33 -0700")
Organization: Gentoo
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
	<20240827234533.GE1977952@frogsfrogsfrogs>
Date: Wed, 28 Aug 2024 01:01:31 +0100
Message-ID: <87le0hbjms.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

"Darrick J. Wong" <djwong@kernel.org> writes:

> From: Darrick J. Wong <djwong@kernel.org>
>
> Apparently C++ compilers don't like the implicit void* casts that go on
> in the system headers.  Compile a dummy program with the C++ compiler to
> make sure this works, so Darrick has /some/ chance of figuring these
> things out before the users do.

Thanks, this is a good idea. Double thanks for the quick fix.

1) yes, it finds the breakage:
Tested-by: Sam James <sam@gentoo.org>

2) with the fix below (CC -> CXX):
Reviewed-by: Sam James <sam@gentoo.org>

3) another thing to think about is:
* -pedantic?
* maybe do one for a bunch of standards? (I think systemd does every
possible value [1])
* doing the above for C as well

I know that sounds a bit like overkill, but systemd
does it and it's cheap to do it versus the blowup if something goes
wrong. I don't have a strong opinion on this or how far you want to go
with it.

[1] https://github.com/systemd/systemd/blob/3317aedff0901e08a8efc8346ad76b1=
84d5d40ea/src/systemd/meson.build#L60

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  configure.ac         |    1 +
>  include/builddefs.in |    7 +++++++
>  libxfs/Makefile      |    8 +++++++-
>  libxfs/dummy.cpp     |   15 +++++++++++++++
>  4 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 libxfs/dummy.cpp
>
> diff --git a/configure.ac b/configure.ac
> index 0ffe2e5dfc53..04544f85395b 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -9,6 +9,7 @@ AC_PROG_INSTALL
>  LT_INIT
>=20=20
>  AC_PROG_CC
> +AC_PROG_CXX
>  AC_ARG_VAR(BUILD_CC, [C compiler for build tools])
>  if test "${BUILD_CC+set}" !=3D "set"; then
>    if test $cross_compiling =3D no; then
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 44f95234d21b..0f312b8b88fe 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -14,6 +14,7 @@ MALLOCLIB =3D @malloc_lib@
>  LOADERFLAGS =3D @LDFLAGS@
>  LTLDFLAGS =3D @LDFLAGS@
>  CFLAGS =3D @CFLAGS@ -D_FILE_OFFSET_BITS=3D64 -D_TIME_BITS=3D64 -Wno-addr=
ess-of-packed-member
> +CXXFLAGS =3D @CXXFLAGS@ -D_FILE_OFFSET_BITS=3D64 -D_TIME_BITS=3D64 -Wno-=
address-of-packed-member
>  BUILD_CFLAGS =3D @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=3D64 -D_TIME_BITS=3D=
64
>=20=20
>  # make sure we don't pick up whacky LDFLAGS from the make environment and
> @@ -234,9 +235,15 @@ ifeq ($(ENABLE_GETTEXT),yes)
>  GCFLAGS +=3D -DENABLE_GETTEXT
>  endif
>=20=20
> +# Override these if C++ needs other options
> +SANITIZER_CXXFLAGS =3D $(SANITIZER_CFLAGS)
> +GCXXFLAGS =3D $(GCFLAGS)
> +PCXXFLAGS =3D $(PCFLAGS)
> +
>  BUILD_CFLAGS +=3D $(GCFLAGS) $(PCFLAGS)
>  # First, Sanitizer, Global, Platform, Local CFLAGS
>  CFLAGS +=3D $(FCFLAGS) $(SANITIZER_CFLAGS) $(OPTIMIZER) $(GCFLAGS) $(PCF=
LAGS) $(LCFLAGS)
> +CXXFLAGS +=3D $(FCXXFLAGS) $(SANITIZER_CXXFLAGS) $(OPTIMIZER) $(GCXXFLAG=
S) $(PCXXFLAGS) $(LCXXFLAGS)
>=20=20
>  include $(TOPDIR)/include/buildmacros
>=20=20
> diff --git a/libxfs/Makefile b/libxfs/Makefile
> index 1185a5e6cb26..bb851ab74204 100644
> --- a/libxfs/Makefile
> +++ b/libxfs/Makefile
> @@ -125,6 +125,8 @@ CFILES =3D buf_mem.c \
>  	xfs_trans_space.c \
>  	xfs_types.c
>=20=20
> +LDIRT +=3D dummy.o
> +
>  #
>  # Tracing flags:
>  # -DMEM_DEBUG		all zone memory use
> @@ -144,7 +146,11 @@ LTLIBS =3D $(LIBPTHREAD) $(LIBRT)
>  # don't try linking xfs_repair with a debug libxfs.
>  DEBUG =3D -DNDEBUG
>=20=20
> -default: ltdepend $(LTLIBRARY)
> +default: ltdepend $(LTLIBRARY) dummy.o
> +
> +dummy.o: dummy.cpp
> +	@echo "    [CXX]    $@"
> +	$(Q)$(CC) $(CXXFLAGS) -c $<

$(CXX) ;)

>=20=20
>  # set up include/xfs header directory
>  include $(BUILDRULES)
> diff --git a/libxfs/dummy.cpp b/libxfs/dummy.cpp
> new file mode 100644
> index 000000000000..a872c00ad84b
> --- /dev/null
> +++ b/libxfs/dummy.cpp
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2024 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + */
> +#include "include/xfs.h"
> +#include "include/handle.h"
> +#include "include/jdm.h"
> +
> +/* Dummy program to test C++ compilation of user-exported xfs headers */
> +
> +int main(int argc, char *argv[])
> +{
> +	return 0;
> +}

cheers,
sam

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iOUEARYKAI0WIQQlpruI3Zt2TGtVQcJzhAn1IN+RkAUCZs5o3F8UgAAAAAAuAChp
c3N1ZXItZnByQG5vdGF0aW9ucy5vcGVucGdwLmZpZnRoaG9yc2VtYW4ubmV0MjVB
NkJCODhERDlCNzY0QzZCNTU0MUMyNzM4NDA5RjUyMERGOTE5MA8cc2FtQGdlbnRv
by5vcmcACgkQc4QJ9SDfkZB/VwEA4tqYsR6DLd4BTLEEM7HI8xn3fBI4O32rsRaJ
2VRNS4cA/ifWVsgcQ/4kOktgD4pxxU20nHgs5B03IhcuxipQnTAM
=Rxv4
-----END PGP SIGNATURE-----
--=-=-=--
