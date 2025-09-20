Received: from mail.wilcox-tech.com (mail.wilcox-tech.com [45.32.83.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEFA2236E1
	for <linux-xfs@vger.kernel.org>; Sat, 20 Sep 2025 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.32.83.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758367775; cv=none; b=Mr0JIQoyuXx4QhWIoxl5ebf3Ki6QV4/36ada6/2v4qktdOqOGTGoPgTbg3jvCRDYC8/7/ankvSjk+W6WPEBvrvg1O8c3hX/8AXhon+gY/MqPtrSXD/BhLphGfGR967jPghWt1iDLaMD0yJxEYbpMZsEvY/Lg7S058trOdhFZdpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758367775; c=relaxed/simple;
	bh=l5BsDUq6V0QVM30CNZd36t8Alxd06wFvVOwXmP8Hii0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=azmYy372KQ5EMprS5AsuC8tSwtHsoW+hw3MSFWHHH9teLPfeTd3fy//zxFsCGYVXBlM8RkDJH6j+rrfJ4iORE6foIwWi4sPnRJE16flxT+EuPx4+Nu9tTUrXNc+BMc5SrYptWtQLrMPKh0JJaRQq3pUGsVXl4FDzgjPO7Ig86Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com; spf=pass smtp.mailfrom=Wilcox-Tech.com; arc=none smtp.client-ip=45.32.83.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=Wilcox-Tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Wilcox-Tech.com
Received: (qmail 12056 invoked from network); 20 Sep 2025 11:20:55 -0000
Received: from 23.sub-75-224-99.myvzw.com (HELO smtpclient.apple) (AWilcox@Wilcox-Tech.com@75.224.99.23)
  by mail.wilcox-tech.com with ESMTPA; 20 Sep 2025 11:20:55 -0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
In-Reply-To: <20250919161400.GO8096@frogsfrogsfrogs>
Date: Sat, 20 Sep 2025 06:21:59 -0500
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
 Christoph Hellwig <hch@infradead.org>,
 linux-xfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BD23D489-C187-4100-89D4-D8159B23A385@Wilcox-Tech.com>
References: <20250919161400.GO8096@frogsfrogsfrogs>
To: "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

> On Sep 19, 2025, at 11:14, Darrick J. Wong <djwong@kernel.org> wrote:
>=20
> From: Darrick J. Wong <djwong@kernel.org>
>=20
> In commit 75faf2bc907584, someone tried to fix scrub to use the POSIX
> version of strerror_r so that the build would work with musl.
> Unfortunately, neither the author nor myself remembered that GNU libc
> imposes its own version any time _GNU_SOURCE is defined, which
> builddefs.in always does.  Regrettably, the POSIX and GNU versions =
have
> different return types and the GNU version can return any random
> pointer, so now this code is broken on glibc.
>=20
> "Fix" this standards body own goal by casting the return value to
> intptr_t and employing some gross heuristics to guess at the location =
of
> the actual error string.
>=20
> Fixes: 75faf2bc907584 ("xfs_scrub: Use POSIX-conformant strerror_r")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> v2: go the autoconf route
> ---
> configure.ac          |    1 +
> include/builddefs.in  |    1 +
> m4/package_libcdev.m4 |   46 =
++++++++++++++++++++++++++++++++++++++++++++++
> scrub/Makefile        |    4 ++++
> scrub/common.c        |    8 ++++++--
> 5 files changed, 58 insertions(+), 2 deletions(-)
>=20
> diff --git a/configure.ac b/configure.ac
> index d2407cb5de5af2..df19379b02ba55 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -183,6 +183,7 @@ AC_CONFIG_CROND_DIR
> AC_CONFIG_UDEV_RULE_DIR
> AC_HAVE_BLKID_TOPO
> AC_HAVE_TRIVIAL_AUTO_VAR_INIT
> +AC_STRERROR_R_RETURNS_STRING
>=20
> if test "$enable_ubsan" =3D "yes" || test "$enable_ubsan" =3D "probe"; =
then
>         AC_PACKAGE_CHECK_UBSAN
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 93b5c75155c0f4..5aa5742bb31b9e 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -241,6 +241,7 @@ CROND_DIR =3D @crond_dir@
> HAVE_UDEV =3D @have_udev@
> UDEV_RULE_DIR =3D @udev_rule_dir@
> HAVE_LIBURCU_ATOMIC64 =3D @have_liburcu_atomic64@
> +STRERROR_R_RETURNS_STRING =3D @strerror_r_returns_string@
>=20
> GCCFLAGS =3D -funsigned-char -fno-strict-aliasing -Wall -Werror =
-Wextra -Wno-unused-parameter
> #   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
> diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
> index ce1ba47264659c..c5538c30d2518a 100644
> --- a/m4/package_libcdev.m4
> +++ b/m4/package_libcdev.m4
> @@ -301,3 +301,49 @@ syscall(__NR_file_getattr, 0, 0, 0, 0, 0);
>        AC_MSG_RESULT(no))
>     AC_SUBST(have_file_getattr)
>   ])
> +
> +#
> +# Check if strerror_r returns an int, as opposed to a char *, because =
there are
> +# two versions of this function, with differences that are hard to =
detect.
> +#
> +# GNU strerror_r returns a pointer to a string on success, but the =
returned
> +# pointer might point to a static buffer and not buf, so you have to =
use the
> +# return value.  The declaration has the __warn_unused_result__ =
attribute to
> +# enforce this.
> +#
> +# XSI strerror_r always writes to buf and returns 0 on success, -1 on =
error.
> +#
> +# How do you select a particular version?  By defining macros, of =
course!
> +# _GNU_SOURCE always gets you the GNU version, and _POSIX_C_SOURCE >=3D=
 200112L
> +# gets you the XSI version but only if _GNU_SOURCE isn't defined.
> +#
> +# The build system #defines _GNU_SOURCE unconditionally, so when =
compiling
> +# against glibc we get the GNU version.  However, when compiling =
against musl,
> +# the _GNU_SOURCE definition does nothing and we get the XSI version =
anyway.
> +# Not definining _GNU_SOURCE breaks the build in many areas, so we'll =
create
> +# yet another #define for just this weird quirk so that we can patch =
around it
> +# in the one place we need it.
> +#
> +# Note that we have to force erroring out on the int conversion =
warnings
> +# because C doesn't consider it a hard error to cast a char pointer =
to an int
> +# even when CFLAGS contains -std=3Dgnu11.
> +AC_DEFUN([AC_STRERROR_R_RETURNS_STRING],
> +  [AC_MSG_CHECKING([if strerror_r returns char *])
> +    OLD_CFLAGS=3D"$CFLAGS"
> +    CFLAGS=3D"$CFLAGS -Wall -Werror"
> +    AC_LINK_IFELSE(
> +    [AC_LANG_PROGRAM([[
> +#define _GNU_SOURCE
> +#include <stdio.h>
> +#include <string.h>
> +  ]], [[
> +char buf[1024];
> +puts(strerror_r(0, buf, sizeof(buf)));
> +  ]])
> +    ],
> +       strerror_r_returns_string=3Dyes
> +       AC_MSG_RESULT(yes),
> +       AC_MSG_RESULT(no))
> +    CFLAGS=3D"$OLD_CFLAGS"
> +    AC_SUBST(strerror_r_returns_string)
> +  ])
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 3636a47942e98e..6375d77a291bcb 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -105,6 +105,10 @@ CFILES +=3D unicrash.c
> LCFLAGS +=3D -DHAVE_LIBICU $(LIBICU_CFLAGS)
> endif
>=20
> +ifeq ($(STRERROR_R_RETURNS_STRING),yes)
> +LCFLAGS +=3D -DSTRERROR_R_RETURNS_STRING
> +endif
> +
> # Automatically trigger a media scan once per month
> XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_INTERVAL=3D1mo
>=20
> diff --git a/scrub/common.c b/scrub/common.c
> index 9437d0abb8698b..9a33e2a9d54ed4 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -126,8 +126,12 @@ __str_out(
> fprintf(stream, "%s%s: %s: ", stream_start(stream),
> _(err_levels[level].string), descr);
> if (error) {
> - strerror_r(error, buf, DESCR_BUFSZ);
> - fprintf(stream, _("%s."), buf);
> +#ifdef STRERROR_R_RETURNS_STRING
> + fprintf(stream, _("%s."), strerror_r(error, buf, DESCR_BUFSZ));
> +#else
> + if (strerror_r(error, buf, DESCR_BUFSZ) =3D=3D 0)
> + fprintf(stream, _("%s."), buf);
> +#endif
> } else {
> va_start(args, format);
> vfprintf(stream, format, args);

I did check *build* on glibc, but I don=E2=80=99t think mine had =
warn_unused_result yet.
(It=E2=80=99s an older version.)

Thanks for fixing this, looks good to me.

The commit message isn=E2=80=99t accurate any more though.

Reviewed-by: A. Wilcox <AWilcox@Wilcox-Tech.com>

