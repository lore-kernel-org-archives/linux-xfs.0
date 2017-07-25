Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44480 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbdGYS4Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 14:56:25 -0400
Subject: Re: [PATCH] xfs_db: fix metadump redirection (again)
References: <20170725162740.GP4352@magnolia>
From: "Jory A. Pratt" <anarchy@gentoo.org>
Message-ID: <42c30880-1405-f88e-8853-d09ba3eccd00@gentoo.org>
Date: Tue, 25 Jul 2017 13:56:16 -0500
MIME-Version: 1.0
In-Reply-To: <20170725162740.GP4352@magnolia>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="75WC1UooahUe2JE8D1eaUwErK4jO2k77V"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--75WC1UooahUe2JE8D1eaUwErK4jO2k77V
Content-Type: multipart/mixed; boundary="LLOno8BvrFEp38lihVHI56XoH6xHVhgMp";
 protected-headers="v1"
From: "Jory A. Pratt" <anarchy@gentoo.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
 Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Message-ID: <42c30880-1405-f88e-8853-d09ba3eccd00@gentoo.org>
Subject: Re: [PATCH] xfs_db: fix metadump redirection (again)
References: <20170725162740.GP4352@magnolia>
In-Reply-To: <20170725162740.GP4352@magnolia>

--LLOno8BvrFEp38lihVHI56XoH6xHVhgMp
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 07/25/17 11:27, Darrick J. Wong wrote:
> In patch 4944defad4 ("xfs_db: redirect printfs when metadumping to
> stdout"), we solved the problem of xfs_db printfs ending up in the
> metadump stream by reassigning stdout for the duration of a stdout
> metadump.  Unfortunately, musl doesn't allow stdout to be reassigned (i=
n
> their view "extern FILE *stdout" means "extern FILE * const stdout"), s=
o
> we abandon the old approach in favor of playing games with dup() to
> switch the raw file descriptors.
>=20
> While we're at it, fix a regression where an unconverted outf test
> allows progress info to end up in the metadump stream.
>=20
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  db/metadump.c |   47 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 36 insertions(+), 11 deletions(-)
>=20
> diff --git a/db/metadump.c b/db/metadump.c
> index b58acef..8cdcb37 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -78,6 +78,7 @@ static int		obfuscate =3D 1;
>  static int		zero_stale_data =3D 1;
>  static int		show_warnings =3D 0;
>  static int		progress_since_warning =3D 0;
> +static bool		stdout_metadump;
> =20
>  void
>  metadump_init(void)
> @@ -137,7 +138,7 @@ print_progress(const char *fmt, ...)
>  	va_end(ap);
>  	buf[sizeof(buf)-1] =3D '\0';
> =20
> -	f =3D (outf =3D=3D stdout) ? stderr : stdout;
> +	f =3D stdout_metadump ? stderr : stdout;
>  	fprintf(f, "\r%-59s", buf);
>  	fflush(f);
>  	progress_since_warning =3D 1;
> @@ -2874,7 +2875,8 @@ metadump_f(
>  	xfs_agnumber_t	agno;
>  	int		c;
>  	int		start_iocur_sp;
> -	bool		stdout_metadump =3D false;
> +	int		outfd =3D -1;
> +	int		ret;
>  	char		*p;
> =20
>  	exitcode =3D 1;
> @@ -2994,16 +2996,35 @@ metadump_f(
>  		 * metadump operation so that dbprintf and other messages
>  		 * are sent to the console instead of polluting the
>  		 * metadump stream.
> +		 *
> +		 * We get to do this the hard way because musl doesn't
> +		 * allow reassignment of stdout.
>  		 */
> -		outf =3D stdout;
> -		stdout =3D stderr;
> +		fflush(stdout);
> +		outfd =3D dup(STDOUT_FILENO);
> +		if (outfd < 0) {
> +			perror("opening dump stream");
> +			goto out;
> +		}
> +		ret =3D dup2(STDERR_FILENO, STDOUT_FILENO);
> +		if (ret < 0) {
> +			perror("redirecting stdout");
> +			close(outfd);
> +			goto out;
> +		}
> +		outf =3D fdopen(outfd, "a");
> +		if (outf =3D=3D NULL) {
> +			fprintf(stderr, "cannot create dump stream\n");
> +			dup2(outfd, 1);
> +			close(outfd);
> +			goto out;
> +		}
>  		stdout_metadump =3D true;
>  	} else {
>  		outf =3D fopen(argv[optind], "wb");
>  		if (outf =3D=3D NULL) {
>  			print_warning("cannot create dump file");
> -			free(metablock);
> -			return 0;
> +			goto out;
>  		}
>  	}
> =20
> @@ -3031,15 +3052,19 @@ metadump_f(
>  	if (progress_since_warning)
>  		fputc('\n', stdout_metadump ? stderr : stdout);
> =20
> -	if (stdout_metadump)
> -		stdout =3D outf;
> -	else
> -		fclose(outf);
> +	if (stdout_metadump) {
> +		fflush(outf);
> +		fflush(stdout);
> +		ret =3D dup2(outfd, STDOUT_FILENO);
> +		if (ret < 0)
> +			perror("un-redirecting stdout");
> +	}
> +	fclose(outf);
> =20
>  	/* cleanup iocur stack */
>  	while (iocur_sp > start_iocur_sp)
>  		pop_cur();
> -
> +out:
>  	free(metablock);
> =20
>  	return 0;
>=20
I have tested and works. I appreciate you taking the time to readdress
the issue.

Thank You,

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Jory A. Pratt
Gentoo Linux Developer [Mozilla Lead]
E-Mail    : anarchy@gentoo.org
GnuPG FP  : D4AC 8D63 0B16 F7C9 08E9  B909 A0CC C3BA B4D0 88B4
GnuPG ID  : B4D088B4
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D


--LLOno8BvrFEp38lihVHI56XoH6xHVhgMp--

--75WC1UooahUe2JE8D1eaUwErK4jO2k77V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEE1KyNYwsW98kI6bkJoMzDurTQiLQFAll3lFQACgkQoMzDurTQ
iLQoxgf/Xn2iG+pLm4XOaFuUlIEI7ZGg6ydiDLEVNc/r/TqeSGrb3c2R9gzR9a2U
R2U3saUa3k0Ef/OGAaeQVbcNF0xnZyWajSacTLdYgCYkx0z7V7ZIPXh35B6Dn4RN
SyN4z7pvM7+mKgdp41eEvpGmETbUsMd83ixVr1Kl9N6DWNa+6kWN46r8vhKzITMT
qKLU/8q12mxzLdbIFBPvGxTcuLUMpHjsbC/vgeXsgK217LuK8Oi8UtoBFgUXklWj
DDMpmgukYUaevXOCtrSztkElTT532UGAiPgw8NMIXDJbYjviSICqCmHSsYf+s/hs
IuSAUX8ydcsywrcA/9l9GyJt7lqGgw==
=J0g/
-----END PGP SIGNATURE-----

--75WC1UooahUe2JE8D1eaUwErK4jO2k77V--
