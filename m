Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 10:41:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k96HfRaG030612
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 10:41:29 -0700
Subject: Re: review: set blocksize patch - libxfs & mkfs
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
References: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gv0KoLYZIXRwJ3syxEVk"
Date: Fri, 06 Oct 2006 10:58:10 -0500
Message-Id: <1160150291.11159.29.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

--=-gv0KoLYZIXRwJ3syxEVk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2006-10-06 at 16:34 +1000, Timothy Shimmin wrote:

>  }
> Index: xfsprogs/libxfs/init.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfsprogs/libxfs/init.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/init.c	2006-10-06 14:14:03.000000000 +1000
> @@ -116,8 +116,16 @@
>  		exit(1);
>  	}
>=20
> -	if (!readonly && setblksize && (statb.st_mode & S_IFMT) =3D=3D S_IFBLK)
> -		platform_set_blocksize(fd, path, statb.st_rdev, 512);
> +	if (!readonly && setblksize && (statb.st_mode & S_IFMT) =3D=3D S_IFBLK)=
 {
> +		if (setblksize =3D=3D 1)
> +			/* use the default blocksize */
> +			(void)platform_set_blocksize(fd, path, statb.st_rdev,=20
> XFS_MIN_SECTORSIZE, 0);
> +		else {
> +			/* given an explicit blocksize to use */
> +			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
> +			    exit(1);
> +		}
should the return code always be checked for failure?
mybe something like
if (platform_set_blocksize(fd, path, statb.st_rdev,
		((setblksize =3D=3D 1)?XFS_MIN_SECTORSIZE:setblksize) 1))

would be bit cleaner


> +	}
>=20
>  	/*
>  	 * Get the device number from the stat buf - unless
> Index: xfsprogs/libxfs/irix.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfsprogs/libxfs/irix.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/irix.c	2006-10-06 14:14:03.000000000 +1000
> @@ -36,8 +36,8 @@
>  	return 1;
>  }
>=20
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,=
=20
> int fatal)
>  {
>  	return;
>  }
> Index: xfsprogs/libxfs/linux.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfsprogs/libxfs/linux.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/linux.c	2006-10-06 14:14:03.000000000 +1000
> @@ -102,16 +102,20 @@
>  	return sts;
>  }
>=20
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,=
=20
> int fatal)
>  {
> +	int error =3D 0;
> +
>  	if (major(device) !=3D RAMDISK_MAJOR) {
> -		if (ioctl(fd, BLKBSZSET, &blocksize) < 0) {
> -			fprintf(stderr, _("%s: warning - cannot set blocksize "
> +		if ((error =3D ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
> +			fprintf(stderr, _("%s: %s - cannot set blocksize "
>  					"on block device %s: %s\n"),
> -				progname, path, strerror(errno));
> +				progname, fatal ? "error": "warning",
> +				path, strerror(errno));
>  		}
>  	}
> +	return error;
>  }
>=20
>  void
> Index: xfsprogs/mkfs/xfs_mkfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfsprogs/mkfs/xfs_mkfs.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/mkfs/xfs_mkfs.c	2006-10-06 14:14:03.000000000 +1000
> @@ -634,7 +634,6 @@
>  	bzero(&fsx, sizeof(fsx));
>=20
>  	bzero(&xi, sizeof(xi));
> -	xi.setblksize =3D 1;
>  	xi.isdirect =3D LIBXFS_DIRECT;
>  	xi.isreadonly =3D LIBXFS_EXCLUSIVELY;
>=20
> @@ -1506,6 +1505,11 @@
>  	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
>  				&dsunit, &dswidth, &lsunit);
>=20
> +	if (slflag || ssflag)
> +	    xi.setblksize =3D sectorsize;
> +	else
> +	    xi.setblksize =3D 1;
> +
>  	/*
>  	 * Initialize.  This will open the log and rt devices as well.
>  	 */
> Index: xfsprogs/libxfs/init.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfsprogs/libxfs/init.h.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/init.h	2006-10-06 14:14:03.000000000 +1000
> @@ -25,7 +25,7 @@
>  extern int platform_check_iswritable (char *path, char *block,
>  					struct stat64 *sptr, int fatal);
>  extern void platform_findsizes (char *path, int fd, long long *sz, int=
=20
> *bsz);
> -extern void platform_set_blocksize (int fd, char *path, dev_t device, in=
t=20
> bsz);
> +extern int platform_set_blocksize (int fd, char *path, dev_t device, int=
=20
> bsz, int fatal);
>  extern void platform_flush_device (int fd, dev_t device);
>  extern char *platform_findrawpath(char *path);
>  extern char *platform_findrawpath (char *path);
> Index: xfsprogs/VERSION
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfsprogs/VERSION.orig	2006-10-06 14:28:43.000000000 +1000
> +++ xfsprogs/VERSION	2006-10-06 14:22:40.000000000 +1000
> @@ -3,5 +3,5 @@
>  #
>  PKG_MAJOR=3D2
>  PKG_MINOR=3D8
> -PKG_REVISION=3D13
> +PKG_REVISION=3D14
>  PKG_BUILD=3D1
>=20
--=20
Russell Cattelan <cattelan@thebarn.com>

--=-gv0KoLYZIXRwJ3syxEVk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFJn0SNRmM+OaGhBgRApeFAJ9NxbBIXGwi5mV8g0rsM8E4FyYLQACfXngq
EdDUSGj+ZOkj5E380SKzxfI=
=K22B
-----END PGP SIGNATURE-----

--=-gv0KoLYZIXRwJ3syxEVk--
