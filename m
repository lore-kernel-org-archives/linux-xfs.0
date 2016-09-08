Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:48862 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752769AbcIHDkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Sep 2016 23:40:35 -0400
Date: Thu, 8 Sep 2016 13:40:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsdocs: master branch updated to 242d533
Message-ID: <20160908034031.GU30056@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfs documentation repository at

git://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git

has just been updated.

The new head of the master branch is commit:

242d533 xfsdocs: document the realtime reverse mapping btree

New Commits:

Darrick J. Wong (7):
      [8b5acc6] journaling_log: fix some typos in the section about EFDs
      [3db09b6] xfsdocs: document known testing procedures
      [afcda10] xfsdocs: update the on-disk format with changes for Linux 4=
=2E5
      [6e7cbb4] xfsdocs: move the discussions of short and long format btre=
es to a separate chapter
      [4302a13] xfsdocs: reverse-mapping btree documentation
      [5a9c232] xfsdocs: document refcount btree and reflink
      [242d533] xfsdocs: document the realtime reverse mapping btree


Code Diffstat:

 .../allocation_groups.asciidoc                       | 119 ++++----
 design/XFS_Filesystem_Structure/btrees.asciidoc      | 196 +++++++++++++
 .../XFS_Filesystem_Structure/data_extents.asciidoc   |  72 +----
 design/XFS_Filesystem_Structure/directories.asciidoc |   1 +
 design/XFS_Filesystem_Structure/docinfo.xml          |  47 ++++
 .../internal_inodes.asciidoc                         |   2 +
 .../XFS_Filesystem_Structure/journaling_log.asciidoc | 320 +++++++++++++++=
++++++-
 design/XFS_Filesystem_Structure/magic.asciidoc       |   9 +
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc   |  50 +++-
 .../XFS_Filesystem_Structure/reconstruction.asciidoc |  53 ++++
 design/XFS_Filesystem_Structure/refcountbt.asciidoc  | 145 ++++++++++
 design/XFS_Filesystem_Structure/reflink.asciidoc     |  40 +++
 design/XFS_Filesystem_Structure/rmapbt.asciidoc      | 307 +++++++++++++++=
++++++
 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc    | 234 ++++++++++++++++
 design/XFS_Filesystem_Structure/testing.asciidoc     |  23 ++
 .../xfs_filesystem_structure.asciidoc                |  12 +
 16 files changed, 1482 insertions(+), 148 deletions(-)
 create mode 100644 design/XFS_Filesystem_Structure/btrees.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/reconstruction.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/refcountbt.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/reflink.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/rmapbt.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/rtrmapbt.asciidoc
 create mode 100644 design/XFS_Filesystem_Structure/testing.asciidoc
--=20
Dave Chinner
david@fromorbit.com

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX0N2uAAoJEK3oKUf0dfodsDYP/2YaajuRZNl6pLg72FMOayyW
l1FbV7L96z35uQ0DrSimT0P0/8QvQQtePZvJTz5UCdJ8VLOfEutf8XQhZjMrxiTC
jd7s+R/mccm0IKzguwMOHV9nYNzqe852KjWbVrSPid9yzl7La6tLUhVr0USIfC69
OodtTfkDhMoJVhH+iML1pgN3S4p4HzvmOArvthvS1bqTsIQ77xgjEkTMTRXzSow7
8WyTV/VRZQK8jn7APQehyrtOCJMUNGSWDtaZsdrIWpLr+N/dPtXqjub9sVbkzd+l
teGX2qm0RwJR0SPFjln/QPkKRvoh808TSk+uRuMQPPBozLuZ8PNZ1R734uRaMLGr
YOgak10Lo5MIU7WLilyW2Grar+BnQcW7K1iM1/oXjE4FhNMm5ok3/9VaMnimZ6vW
kbPaBVQK+QvSZSUq7gr2QzFGnwn6PPWejZJer8j9n7SmAoOymGSWxLbN7o6ajZBZ
gN6DhRlCZompZfeDSS1sR0WToCa2WEBgL/UTBlBURGy6/1VWjndH7Kiew2yLX5gu
tG6XIqShDqqP6QnVmXh59NiLAR4GFwfE5lEbWk0ha/c0Jr0dIyiDSbifOo6uFNxv
VpgJG8FyEwSi8/SIuSEJWvqdEjtQL2r7/3b5ryewvs4VkG41vrO/vdvRkT+3ntVR
Mq7ZhPmcPtV8vUwfoaIY
=xJMY
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
