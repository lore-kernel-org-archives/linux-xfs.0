Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35275 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbdC1Skt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2017 14:40:49 -0400
Received: by mail-it0-f68.google.com with SMTP id y18so5228468itc.2
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2017 11:40:48 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <FEBBB5DF-1B64-468A-AD41-01E0D8D48C7A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_762C9721-09F1-473D-9911-5EDD8D7894A4";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #2]
Date: Tue, 28 Mar 2017 12:40:40 -0600
In-Reply-To: <29458.1490711932@warthog.procyon.org.uk>
References: <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net>
 <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
 <29458.1490711932@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>


--Apple-Mail=_762C9721-09F1-473D-9911-5EDD8D7894A4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Mar 28, 2017, at 8:38 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> Here are my current changes to Eric's statx interface patch.  I've =
made it
> analoguous to the stat command and so it only does statx-of-fd.
>=20
> I've made the "-m" flag able to take the words "basic" and "all" in
> preference to a number and able to take an octal or hex number as an
> alternative too.
>=20
> I've dropped the -A and -L flags since it no longer passes a path =
over.
>=20
> Finally, I've added a -c flag that causes an fstat() to be done as =
well and
> the buffers compared as a consistency check.

It probably makes sense to use "-C" to avoid confusion with xfs_io's =
"-c"
option, and also the "stat -c" option to dump only specific fields =
(which
may be useful to add at some point in the future as well).

Cheers, Andreas

>=20
> David
> ---
> diff --git a/io/stat.c b/io/stat.c
> index a7aebcd..961b6d1 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -189,12 +189,10 @@ statx_help(void)
> " Display extended file status.\n"
> "\n"
> " Options:\n"
> -" -m mask -- Specify the field mask for the statx call (default =
STATX_ALL)\n"
> -" -A -- Suppress terminal automount traversal\n"
> +" -c -- Compare against fstat/fstatat on the same file/fd\n"
> +" -m mask -- Specify the field mask for the statx call (can also be =
'basic' or 'all'; default STATX_ALL)\n"
> " -D -- Don't sync attributes with the server\n"
> " -F -- Force the attributes to be sync'd with the server\n"
> -" -L -- Follow symlinks (statx link target)\n"
> -" -O -- Add only basic stats (STATX_BASIC_STATS) to default mask\n"
> "\n"));
> }
>=20
> @@ -227,6 +225,65 @@ dump_statx(struct statx *stx)
> }
>=20
> /*
> + * Compare the contents of a statx struct with that of a stat struct =
and check
> + * that they're the same.
> + */
> +static int
> +cmp_statx(const struct statx *stx, const struct stat *st)
> +{
> +	const char *what =3D NULL;
> +
> +#define cmp(x) \
> +	do {					\
> +		what =3D #x;		\
> +		if (stx->stx_##x !=3D st->st_##x)	\
> +			goto mismatch;		\
> +	} while (0)
> +
> +	cmp(blksize);
> +	cmp(nlink);
> +	cmp(uid);
> +	cmp(gid);
> +	cmp(mode);
> +	cmp(ino);
> +	cmp(size);
> +	cmp(blocks);
> +
> +#define devcmp(x) \
> +	do {						\
> +		what =3D #x".major";			\
> +		if (stx->stx_##x##_major !=3D major(st->st_##x))	=
\
> +			goto mismatch;			\
> +		what =3D #x".minor";			\
> +		if (stx->stx_##x##_minor !=3D minor(st->st_##x))	=
\
> +			goto mismatch;			\
> +	} while (0)
> +
> +	devcmp(dev);
> +	devcmp(rdev);
> +
> +#define timecmp(x) \
> +	do {						\
> +		what =3D #x".tv_sec";			\
> +		if (stx->stx_##x##time.tv_sec !=3D =
st->st_##x##tim.tv_sec)	\
> +			goto mismatch;			\
> +		what =3D #x".tv_nsec";			\
> +		if (stx->stx_##x##time.tv_nsec !=3D =
st->st_##x##tim.tv_nsec)	\
> +			goto mismatch;			\
> +	} while (0)
> +
> +	timecmp(a);
> +	timecmp(c);
> +	timecmp(m);
> +
> +	return 0;
> +
> +mismatch:
> +	fprintf(stderr, "Mismatch between stat and statx output (%s)\n", =
what);
> +	return -1;
> +}
> +
> +/*
>  * options:
>  * 	- input flags - query type
>  * 	- output style for flags (and all else?) (chars vs. hex?)
> @@ -239,16 +296,23 @@ statx_f(
> {
> 	int		c;
> 	struct statx	stx;
> -	int		atflag =3D AT_SYMLINK_NOFOLLOW;
> -	unsigned int	m_mask =3D 0;	/* mask requested with -m */
> -	int		Oflag =3D 0, mflag =3D 0;	/* -O or -m was =
used */
> +	struct stat	st;
> +	int		atflag =3D 0;
> 	unsigned int	mask =3D STATX_ALL;
> +	int		compare =3D 0;
>=20
> -	while ((c =3D getopt(argc, argv, "m:FDLOA")) !=3D EOF) {
> +	while ((c =3D getopt(argc, argv, "cm:FD")) !=3D EOF) {
> 		switch (c) {
> +		case 'c':
> +			compare =3D 1;
> +			break;
> 		case 'm':
> -			m_mask =3D atoi(optarg);
> -			mflag =3D 1;
> +			if (strcmp(optarg, "basic") =3D=3D 0)
> +				mask =3D STATX_BASIC_STATS;
> +			else if (strcmp(optarg, "all") =3D=3D 0)
> +				mask =3D STATX_ALL;
> +			else
> +				mask =3D strtoul(optarg, NULL, 0);
> 			break;
> 		case 'F':
> 			atflag &=3D ~AT_STATX_SYNC_TYPE;
> @@ -258,38 +322,28 @@ statx_f(
> 			atflag &=3D ~AT_STATX_SYNC_TYPE;
> 			atflag |=3D AT_STATX_DONT_SYNC;
> 			break;
> -		case 'L':
> -			atflag &=3D ~AT_SYMLINK_NOFOLLOW;
> -			break;
> -		case 'O':
> -			mask =3D STATX_BASIC_STATS;
> -			Oflag =3D 1;
> -			break;
> -		case 'A':
> -			atflag |=3D AT_NO_AUTOMOUNT;
> -			break;
> 		default:
> 			return command_usage(&statx_cmd);
> 		}
> 	}
>=20
> -	if (Oflag && mflag) {
> -		printf("Cannot specify both -m mask and -O\n");
> -		return 0;
> -	}
> -
> -	/* -m overrides any other mask options */
> -	if (mflag)
> -		mask =3D m_mask;
> -
> 	memset(&stx, 0xbf, sizeof(stx));
> -	if (statx(AT_FDCWD, file->name, atflag, mask, &stx) < 0) {
> +
> +	if (statx(file->fd, NULL, atflag, mask, &stx) < 0) {
> 		perror("statx");
> 		return 0;
> 	}
>=20
> -	dump_statx(&stx);
> +	if (compare) {
> +		if (fstat(file->fd, &st) < 0) {
> +			perror("fstat");
> +			return 0;
> +		}
>=20
> +		cmp_statx(&stx, &st);
> +	}
> +
> +	dump_statx(&stx);
> 	return 0;
> }
>=20
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 77ba760..d82f882 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -884,16 +884,23 @@ and the XFS_IOC_GETXATTR system call on the =
current file. If the
> option is specified, the atime (last access), mtime
> (last modify), and ctime (last change) timestamps are also displayed.
> .TP
> -.BR statx " [ " \-O " | " "\-m mask" " ][ \-" FDLA " ]"
> +.BR statx " [ " "\-m mask" " ][ \-" cFD " ]"
> Extended information from the statx syscall.
> .RS 1.0i
> .PD 0
> .TP 0.4i
> .B \-m mask
> -Specify the field mask for the statx call (default STATX_ALL)
> +Specify the field mask for the statx call as an decimal, hex or octal =
integer
> +or
> +.RI \" basic "\" or \"" all \"
> +to specify the basic stats that
> +.IR stat ()
> +returns or all the stats known by the header file.  All is the =
default.
> .TP
> -.B \-O
> -Add only basic stats (STATX_BASIC_STATS) to default mask
> +.B \-c
> +Do an
> +.IR fstat ()
> +call as well and compare the buffers.
> .TP
> .B \-F
> Force the attributes to be sync'd with the server
> @@ -901,12 +908,6 @@ Force the attributes to be sync'd with the server
> .B \-D
> Don't sync attributes with the server
> .TP
> -.B \-L
> -Follow symlinks (statx link target)
> -.TP
> -.B \-A
> -Suppress terminal automount traversal
> -.TP
> .RE
> .IP
> .TP


Cheers, Andreas






--Apple-Mail=_762C9721-09F1-473D-9911-5EDD8D7894A4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY2q4ppIg59Q01vtYRAh4PAKC4rfLzhlJMMlCiGrQCkvbVSTtSKACdFvUU
7BcGtfSgZ67DnARh2uaBPQA=
=R6sD
-----END PGP SIGNATURE-----

--Apple-Mail=_762C9721-09F1-473D-9911-5EDD8D7894A4--
