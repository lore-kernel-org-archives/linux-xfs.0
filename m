Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B33477F47
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 19:08:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A33888F8035
	for <xfs@oss.sgi.com>; Sun, 10 May 2015 17:08:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CzAGoo1vtxgku3D9 for <xfs@oss.sgi.com>;
	Sun, 10 May 2015 17:08:02 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YrbDY-00040Y-OB
	for xfs@oss.sgi.com; Mon, 11 May 2015 10:05:08 +1000
Date: Mon, 11 May 2015 10:05:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
Message-ID: <20150511000508.GD16689@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4663999898344544433=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4663999898344544433==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

I' ve just added a branch to the xfsprogs repository on kernel.org
that is up to date with the current 4.1-rc2 kernel code. It's smoke
tested, so I don't think there's any major problems with it. Can
everyone with development patches (i.e. things that change on disk
formats) for xfsprogs please rebase their work against this branch,
retest and repost? This branch will end up being the 3.3 release
tree...

FWIW, now that I've done this update, I'm considered how we keep
this up to date in future. Keeping the userspace code up to date and
working with all the internal kernel API changes takes quite a bit
of effort and that currently is all being done by the Maintainer.
i.e. me. This is the reason that userspace is not updated
frequently.

With this update, libxfs in the kernel and userspace are mostly
identical, so I'm thinking that a new rule for XFS developers needs
to be put in place: if you modify a libxfs kernel API, then you need
to make the same change to userspace. This means all the changes
needed for xfs_repair, xfs_db, etc, need to be done as well, because
sometimes these things are non-trivial.

A good example of this is Christoph's xfs_trans_commit() patchset.
There's 42 xfs_trans_commit() calls in userspace and it has a
completely different implementation in userspace. To put that in
context, there are 61 xfs_trans_commit() in the kernel code. If I
merge that changeset into the kernel code, then Christoph walks away
and it has become the Maintainer's problem to make userspace work
with the API change.

This *sucks* from a maintainer's POV - - it simply does not scale.
This is one of the reasons why my productivity as an XFS developer
has cratered over the last year. This userspace update work needs to
be distributed over the developers making the API and functionality
changes, so I'm throwing this out there to see what people think
about solving this problem.

I'm thinking that we need a userspace dev branch similar to the
for-next branch for the kernel code, where we aggregate topic
branches that contain each set of userspace patches that add/change
functionality that is shared with the kernel. If the developer
hasn't done the work to update userspace and test the changes there,
then the change is incomplete.

Note that I'm only suggesting this for the main XFS developers
making internal API or on-disk format changes to XFS - the typical
drive-by patches and bug fixes from random people we commit to the
kernel code will still need the maintainer to push them across to
userspace.

This will make my life easier from both an update and maintenance
point of view, and will make it easier for us as developers to get
the latest dev code faster. It will also make porting kernel changes
over to userspace faster, as the patches will mostly apply cleanly
to the userspace libxfs code base. And if it gets merged quicker,
tehn we'll get better test coverage of the dev tree because we'll be
testing it sooner. And as developers, we won't have to be working
out what changed and needs forward porting from the kernel to
userspace to make stuff work....

So, what do the people I'm asking to do more work so I don't have
to spend so much time on time consuming maintenance tasks think?

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVT/I0AAoJEK3oKUf0dfodaBAP/2i0AcvxWt/z+HEAPV5Kflyc
Bvn2oYOgImNb/PM3MhHcdVGWtGmAlutcVe9For+j/geMbSMGZ/2swF4F2ACT9106
hWYYL1thvXSjeeSlwPQMlziM6bx0sYXIUAAeQT/4pvNd8uVt1DFdADq6TeGTUdlL
344KtGn8h3D0bXyTw1rzRbIBzmDZsPFcb5aks5k31MbJ+VYU3cweeaGM6b6vlNWW
5HQitgJtLczVytQGZqk84CnaQgdOaEEGgPfzkg0UBWW6Ga4ju4Jt82kwkHkhjsy2
IC2HE3UL3SPvKItIiDjZzXCzVSAbR8oWVtGG9LL4cZaqKY44T4G+ubS3zOaXQTD+
rLKalrGiyEmn2hmfsSNcEnpa1BYy0eTzvwtNHBfP3Hx5pTImWd4ZP5vKtmdW4Eo1
SojN5rTR/3j0Zv2SMyR3XS19rjh92q74xflgwps/UMtAM5f8w146L3K8FVNFl7Lt
jMoWYaY4s5Z2sGaOlOGTyr1bS0QaanCIJnIlP2f4EK6pdxW5riqjqVZEdA21Ga++
6pAGG9Wi784TMUvERiCAmVOhBrHKrefbAC+fpOvAC1qhp962w2/EO+oEXcJDnOKM
kh8MxKHBJtmZ3/eH/P+XEQkoBaV40GSIuJDfN2GqLs7aXpogADbaWE79WybGTYR7
Kx18XEWmABGlNscUgpla
=/ncK
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--


--===============4663999898344544433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4663999898344544433==--
