Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58312 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbeC0U2H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Mar 2018 16:28:07 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8F37E2B0F
        for <linux-xfs@vger.kernel.org>; Tue, 27 Mar 2018 15:27:42 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 04a2d5d
Message-ID: <56744a06-3ca7-0dba-e569-462fd9c57b4b@sandeen.net>
Date: Tue, 27 Mar 2018 15:28:04 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mBi4EoRCzSRqkgrNyDyT5MNJoSlCQZnix"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mBi4EoRCzSRqkgrNyDyT5MNJoSlCQZnix
Content-Type: multipart/mixed; boundary="7986ZSH9FVBjwQSLaQqaeV8VEkYppXIbh";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <56744a06-3ca7-0dba-e569-462fd9c57b4b@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 04a2d5d

--7986ZSH9FVBjwQSLaQqaeV8VEkYppXIbh
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

(I've left off the removal of non-linux platforms for now)

The new head of the for-next branch is commit:

04a2d5d fsck.xfs: allow forced repairs using xfs_repair

New Commits:

Baruch Siach (2):
      [40b2e29] workqueue: add missing pthreads header
      [e2bc34d] xfs_scrub: add missing paths header

Darrick J. Wong (4):
      [3452f45] xfs_repair: implement custom ifork verifiers
      [be66eb8] libfrog: fs_table_lookup_mount should realpath the argume=
nt
      [938f7b7] xfs_fsr: refactor mountpoint finding to use libfrog paths=
 functi
      [9cf846b] mkfs: enable sparse inodes by default

Dave Chinner (1):
      [7459528] xfs_io: fix operation time reporting

Eric Sandeen (2):
      [f8cd7da] xfs_repair: use custom ifork verifier in mv_orphanage
      [4aa3c02] metadump/restore: don't use errno after fwrite/fread fail=
ures

Jan Tulak (2):
      [7c3e94a] xfs_repair: add flag -e to modify exit code for corrected=
 errors
      [04a2d5d] fsck.xfs: allow forced repairs using xfs_repair


Code Diffstat:

 db/metadump.c             |  4 +--
 fsck/xfs_fsck.sh          | 57 +++++++++++++++++++++++++++++++++++-
 fsr/Makefile              |  4 ++-
 fsr/xfs_fsr.c             | 73 ++++++-----------------------------------=
------
 include/path.h            |  1 +
 include/workqueue.h       |  2 ++
 libfrog/paths.c           | 51 ++++++++++++++++++++++++---------
 libxcmd/input.c           | 16 +++++------
 libxfs/libxfs_api_defs.h  |  2 ++
 man/man8/fsck.xfs.8       |  7 +++++
 man/man8/xfs_repair.8     | 22 ++++++++++----
 mdrestore/xfs_mdrestore.c | 13 ++++-----
 mkfs/xfs_mkfs.c           |  4 +--
 repair/phase6.c           | 60 ++++++++++++++++++++++++++++++++++++--
 repair/xfs_repair.c       | 15 +++++++++-
 scrub/xfs_scrub.c         |  1 +
 16 files changed, 225 insertions(+), 107 deletions(-)


--7986ZSH9FVBjwQSLaQqaeV8VEkYppXIbh--

--mBi4EoRCzSRqkgrNyDyT5MNJoSlCQZnix
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlq6qVUACgkQIK4WkuE9
3uByXRAAkdlzzou9yrr3+1aYO1IGiZn5DeBhlJHabWGaRcaFhtCYi2bELF4g5u4d
UC4rZAy3TkXgUo015i0l4JswmsCNY0uT0pgK7hEuAH1BGNcYjuFjDiAcOQyUX88R
qDO+JSvpH8c2DKotQ0Pg+I2zL6blnhEzLFWRaABERZxCjHZw7jRQwiakrasqXmsN
soUnM1DkLX2RK9cirQZWP7R8WGEQUtk8RaH/ZeDlCsi348lEYHRBorSfj4uHN7Ne
5n8Rwr8y4o86xSjDunG3bp3PWBmjmeld3h11P8nua+1i4pgvNyAnezg9iw4ISoAM
B0IvYlwXNYhyuxBWx8VNQt9TJ1WQizdM8J1+DmviRG8HbTvn+Dh6z5loCtIKxC5g
ZrA6Wmkg2Mw03H09UAOYkm4esQ3Sp6EvrBqcdkQv2cdms3znZnHGhpT2q3ZGF+6S
lY/D6yDTCW1h1fTO+7q9+24XLUs5ZBcSOKYjBJY/+3K+deRhhKOxKbvbBk771Bn5
NP/HwQfMyIDJw8OTw/U71RFeikAZMdcj2EFIU83zgW9uFfRs4/rmZD7I4rbBED/J
HE5vn0arM9r3/fRfqqfhC44cTg4+ZsunAP4T2KlGIRv5YT6t4KePYOjxgRwKHAuP
oiWe3yiVR51mSOuCBZLzgN1bIjXTTvflhVsA75WMAjs4pjfaAlg=
=3aI/
-----END PGP SIGNATURE-----

--mBi4EoRCzSRqkgrNyDyT5MNJoSlCQZnix--
