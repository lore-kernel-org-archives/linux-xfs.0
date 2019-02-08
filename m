Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46078 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfBHV0G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Feb 2019 16:26:06 -0500
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 7BFB978AB
        for <linux-xfs@vger.kernel.org>; Fri,  8 Feb 2019 15:24:39 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.20.0-rc1 released
Message-ID: <01ba1b68-65bb-4bae-eb4f-3bdd9b08ba5f@sandeen.net>
Date: Fri, 8 Feb 2019 15:26:04 -0600
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fl2x7IdI73oFTRSP4etceHYTJDT1nF0oK"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fl2x7IdI73oFTRSP4etceHYTJDT1nF0oK
Content-Type: multipart/mixed; boundary="L9sL31bLbHeQK57yC1G631HXlWFtZRWXo";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <01ba1b68-65bb-4bae-eb4f-3bdd9b08ba5f@sandeen.net>
Subject: [ANNOUNCE] xfsprogs-4.20.0-rc1 released

--L9sL31bLbHeQK57yC1G631HXlWFtZRWXo
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

I've pushed out a 4.20.0-rc1 release.  I know there are worthy
patches still waiting, but as close as we are to 5.0, I don't
want to keep dragging this out.  Sorry.  No real need to resubmit
unless you want to, I think I still have tabs on those fixes.

Summarized changelog for this release:

xfsprogs-4.20.0-rc1 (08 Feb 2018)
        - mkfs.xfs: null-terminate symlinks created via protofile (Eric S=
andeen)
        - xfs_repair: allow '/' in attribute names (Eric Sandeen)
        - xfs_repair: skip block reservation when fixing freelist (Darric=
k Wong)
        - xfs_repair: rebuild dir when nonroot blocks corrupt (Darrick Wo=
ng)
        - xfs_repair: int nonleaf finobt blocks with proper magic (Brian =
Foster)
        - xfs_repair: fix off by one error rebuilding high keys (Darrick =
Wong)
        - xfs_io: allow open file permissions to be changed (Dave Chinner=
)
        - xfs_io: open pipes in non-blocking mode (Dave Chinner)
        - xfs_metadump: multiple stale data zeroing fixes (Stefan Ring)
        - xfs_quota: allow reg files w/o prjinherit flag (Achilles Gaikwa=
d)
        - xfs_db: properly decode finobt record w/ sparse inodes (Darrick=
 Wong)
        - xfs_db: fix frag command to work w/ sparse inodes (Eric Sandeen=
)
        - xfs_scrub: move all executables to /usr/sbin (Darrick Wong)
        - xfs_scrub: handle totally empty inode chunks (Darrick Wong)
        - xfs.5 manpage: Remove barrier related options (Eric Sandeen)
        - xfs_io.8 manpage: rearrange command listings by section (Darric=
k Wong)
        - Remove generated scrub files under make clean (Eric Sandeen)
        - Skip scrub manpage install if not configured (Eric Sandeen)
        - Merge libxfs from kernel 4.20

I'll give this a couple days for anyone who wants to test it, and then pu=
sh
out 4.20 proper as long as no issues are found.

Thanks!
-Eric


The new head of the master branch is commit:

d586cf7 xfsprogs: Release v4.20.0-rc1

New Commits:

Eric Sandeen (1):
      [d586cf7] xfsprogs: Release v4.20.0-rc1


Code Diffstat:

 VERSION          |  4 ++--
 configure.ac     |  2 +-
 debian/changelog |  6 ++++++
 doc/CHANGES      | 22 +++++++++++++++++++++-
 4 files changed, 30 insertions(+), 4 deletions(-)


--L9sL31bLbHeQK57yC1G631HXlWFtZRWXo--

--fl2x7IdI73oFTRSP4etceHYTJDT1nF0oK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlxd8+0ACgkQIK4WkuE9
3uCaGBAAlspckaoxLaQbY7nUxl2oNxuoKUiqJ2wnq6YI968lQKfhcjZfiP4Yy4Wc
ywNahptcjqye5NclRimyELyatbDTeOdCeU4Yuo9ACfHTkCc6lENsANeWidprr2xM
JH5ep8E+7vLScV9O7WcUBIcgqkPWR6edrRydEuJouJHA8ktneFDuF05Db/CZ1Jgy
a0iZ0TSASGbkIe2ld8mJvXJ15D8TMKxh/3omd3U1OXTZ0OUIbj0ChQIUqL5dW7vS
INRKgX74cm9fb/K17zNJi1GuEl+UfQtYqr2xGe2/Bhyb7nxYDhRj6Ub6wL6JbnUu
XcNbx+QeF6mM01yiBxUjFTcplhqW3+uxDFXQDzZb+RepWWTLk0xxFehnEutfkst8
qNXdm3vzAstheXHf73q3xpfUvqk1O/6SLFwWdjulUadrNb+IC6xCxFyS54KAyK0G
hWzSJ3r5EPBOi5Kg5gkKiGltV1xikbx4f2bJ6rwiQJevWMrQeDII0ZxodoHLmLnL
a+yo9Ej6FJSp6EDobD+aUR2ArNVHLj/NBJkoIsG24+Ya5SXF2x5Ff0ge1CajzIkl
SndQv5Eac47G7KXyXWJuylQT15gbiD3P2NeYRYEEYZXIQhetj+rVbTwtkH34K9e1
C/p1FYBc/z+6NZG8EJ3aaJ2fCzxrB++I/lqJLVCNWUSoR917sk0=
=xUaT
-----END PGP SIGNATURE-----

--fl2x7IdI73oFTRSP4etceHYTJDT1nF0oK--
