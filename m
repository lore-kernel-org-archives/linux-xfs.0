Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45DA57F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 21:16:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 371FB304053
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 19:16:11 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [203.10.76.45]) by cuda.sgi.com with
	ESMTP id T9L7slPyh6CUfwLE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 19:16:10 -0800 (PST)
Date: Tue, 25 Feb 2014 14:16:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v5 0/10] fs: Introduce new
	flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-Id: <20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
In-Reply-To: <20140224005710.GH4317@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7176834272940109132=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

--===============7176834272940109132==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H"

--Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 24 Feb 2014 11:57:10 +1100 Dave Chinner <david@fromorbit.com> wrote:
>
> > Namjae Jeon (10):
> >   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
> >   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>=20
> I've pushed these to the following branch:
>=20
> 	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range
>=20
> And so they'll be in tomorrow's linux-next tree.
>=20
> >   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
>=20
> I've left this one alone for the ext4 guys to sort out.

So presumably that xfs tree branch is now completely stable and so Ted
could just merge that branch into the ext4 tree as well and put the ext4
part on top of that in his tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDAr1AAoJEMDTa8Ir7ZwVwWwP+gPZe8NtKPGNcImOr5glL63z
MIQUFgD8gf+GbRAMHjpS8YqejSSu4+9p0j3pemP3EbbQqkh2QimPCdkJXcVvj5E8
XeRlSxEEkQcozkgs137OcFGZikt0iduOh5AOJj4lf4pwfK8mcsfN1upCBO0626vu
JHHobnwqw7rVCI4YBiJ3wf2ApG5jeiUJFpRnQW65J85gHWlg3dUYkaFVBYN3QMEJ
MP2XD7xRhnq0Q9whKsKPv3awX4YtdUEkQg0gr3akiWV9ANL3XKpv46AvDnWaNIyI
J4zXZ/tGDo9bGYR4lbKyTbAVB9lxQBaGY+U527EpjeJAdweHImftoX/bE21bfs5R
97k3QSF4jUdaIeK6ho4O4/t3Xdf0FYsSo8ZXxhKN+HRssKelEbH2VieJKmVRMYwW
a3EztVYukCZ+AWrjopWtO/Ng4sYrzU/gDU2WyDonO85Tda31i6DVui4ppeix6SI/
wFu4NLkR33tkjKc6oY9+4uaxUzddq7xVeLdJQ0nmNvZOYRgDDZ861u5KREeVMGB5
9gU/4M0EB+kf89AHRmiToPaYWw6BPpowkz/39uvtBJCOusO9xzaF3lOZDYZ42FyU
noyUSzrpemZJpmTzgUowa2+WIWA5HecDqzCGBD5xHRrYWpeVNH6t5AuA+g607yWB
Pfl6QASOJRvSWjYO6aQh
=2fKf
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_14_16_01_+1100_2WgBxiSFHZfpoj/H--


--===============7176834272940109132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7176834272940109132==--
