Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:43050 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752265AbcJSADB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2016 20:03:01 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1bweKv-0002XK-9k
        for linux-xfs@vger.kernel.org; Wed, 19 Oct 2016 11:02:25 +1100
Date: Wed, 19 Oct 2016 11:02:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.8.0 released!
Message-ID: <20161019000225.GF23194@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repositories have just been updated and tagged with the
v4.8.0 release tag. It can be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.8.0

There is a *new location* for obtaining the source tarballs. They are
now hosted on kernel.org, and can be found here:

https://kernel.org/pub/linux/utils/fs/xfs/xfsprogs/

The format of the archives is slightly different now because of the
way uploads to kernel.org work. The uncompressed tarball is signed,
rather than the compressed tarball that you download. This means
there are multiple different compressed formats you can select from
and you have to decompress it before verifying the signature. The
currently available compressed files are:

	xfsprogs-4.8.0.tar.gz
	xfsprogs-4.8.0.tar.xz

And the signature (signed with the same key as this email) is in
this file:

	xfsprogs-4.8.0.tar.sign

Because this is a new location and requires a different signing
method, the old packages on oss.sgi.com could not be moved over
without resigning them. At this point in time, I have only uploaded
xfsprogs packages from 3.2.3 onwards, as they are only versions I
still have the original release tarball on my local machine. Hence
it was trivial to resign and upload them.

At some point in the near future I will download, verify, resign and
upload all the old packages on oss.sgi.com that are signed. This
should keep all currently supported distros happy, but I'm not sure
yet what I'll do with older unsigned release tarballs. I will need
to do the same thing with xfsdump packages, too.

Anyway, back to the xfsprogs v4.8.0 release - Many thanks go to all
the contributors to this release. The summary of changes since
v4.7.0 can be found listed in doc/CHANGES, which I have reproduced
in part below.

Cheers,

Dave.

----

xfsprogs-4.8-0 (17 Oct 2016)
	- no changes from v4.8.0-rc3

xfsprogs-4.8-0-rc3 (3 Oct 2016)
	- xfs_io: clean up inode command (Eric Sandeen)
	- xfs_repair: fix phase 5 btree size overestimation (Darrick Wong)
	- xfs_repair: fix phase 5 AGFL rmap update (Darrick Wong)
	- libxfs: libxfs_iget() cleanup (Eric Sandeen)
	- libxcmd: fix count of XFS filesystems in path table (Eryu Guan)

xfsprogs-4.8-0-rc2 (23 Sep 2016)
	- xfs_copy: uuid handling fixes (Eric Sandeen)
	- xfs_repair: directory rebuild segfault fix (Eric Sandeen)
	- xfs_repair: report log dirtiness correctly (Eric Sandeen)
	- libxfs: mounted filesystem detection cleanups (Eric Sandeen)
	- xfs_logprint: don't print transaction types anymore (Hou Tao)
	- xfs_quota: allow operation on non-XFS filesystems (Bill O'Donnell)
	- xfs_io: allow project quota operations on non-XFS (Eric Sandeen)
	- mkfs.xfs: man page calrification for ftype defaults (Eric Sandeen)

xfsprogs-4.8-0-rc1 (9 Sep 2016)
	- change contact emails to linux-xfs@vger.kernel.org
	- libxfs: kernel sync up to 4.8-rc1
	- Initial reverse mapping support (Darrick Wong)
	- buffer lock trace analysis tool (Darrick Wong)
	- logprint: cleanups and fixes (Darrick Wong)
	- man page updates (various)
	- libxcmd: mount option parsing fixes (Darrick Wong)
	- xfs_quota: use XFS_GETQSTATV (Eric Sandeen)
	- xfs_quota: allow use on non-XFS filesystems (Bill O'Donnell)
	- xfs_db: allow direct manipulation of CRCs (Eric Sandeen)
	- libxfs: get rid of ustat() calls (Felix Janda)

-----

The new head of the master branch is commit:

152fa26f3a8f xfsprogs: Release 4.8.0

New Commits:

Dave Chinner (1):
      [152fa26f3a8f] xfsprogs: Release 4.8.0


Code Diffstat:

 VERSION          | 2 +-
 configure.ac     | 2 +-
 debian/changelog | 6 ++++++
 doc/CHANGES      | 3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYBrgQAAoJEK3oKUf0dfodL0YP/3hQPsFcM4DVJ3kdJ0mZEUG+
7VAe0squOqHSFhxzxts8TrOM1f5l5hTXU1zRkJifzsqGQXTbc1pTdymuNbffoINN
j0Z78UDlGlh0EE7KccXvidxa5clcUE2I8BvvC4abIUae6G2Cee4qmeAuqWJ6A9cH
cXj5iNonjcQP0vEn9Xt0GTzkfYOW++moHpsSAFm+eWpsUkHic/X39XKSld4Ic7QK
F7/Fl/MklTqoeLL0ty8GyvST37xXGGSxkHR7+2yHXsjD0cuCyqanV1vy2VuZCQLw
NrCUHD9zDoSKVRrYQEuznUjjjelHWMQAPB5NiMh1b0y4RIJ/Lvp3gNNli4iS4DKZ
qNAJ6iz/8eChCayw7kxOtWxswYIXUIB0J56hzM89SNHLP2x/I3eWyiTIkWlRlGlL
T43Rsb0UTpvoEOlYf2RvmYkfD8VYgoVDHUlHSbO0p4xd38pDVHHmGrQcL8zjngUy
dIKyUMI4WyZFHr7pHQhRvzrqwCENWjyG9z3Twg/PtTncYas9PyTB7OmKck9G4YFx
Zq98xx7g3i3xUhUUcL0yA1JaDrlMYv6enKKMYFqflt01qzHl29MqqQKc9+1iM4gg
1x7knzu2D+C3XxgBOROom9Ros+maiFgJV9hjcoSpEDRs6dD4EMBqgKvi3Ktjhi0q
mJ1cceodtrYoHD/GeWPU
=COnk
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
