Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:24326 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935150AbcIWA33 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2016 20:29:29 -0400
Date: Fri, 23 Sep 2016 10:29:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 4.8.0-rc2 
Message-ID: <20160923002925.GP340@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged as a second release candidate
(v4.8.0-rc2). Many fixes included, please test.

-Dave.

The new head of the master branch is commit:

c1a14cc xfsprogs: Release 4.8.0-rc2

New Commits:

Bill O'Donnell (3):
      [bb80e3d] libxcmd: populate fs table with xfs entries first, foreign =
entries last
      [6983238] xfs_quota: print and path output formatting: maintain rever=
se compatibility
      [2ba39cd] xfs_quota: add case for foreign fs, disabled regardless of =
foreign_allowed

Dave Chinner (1):
      [c1a14cc] xfsprogs: Release 4.8.0-rc2

Eric Sandeen (10):
      [7f510af] libxfs: move iswritable "fatal" decision to caller
      [b04647e] xfs_repair: exit with status 2 if log dirtiness is unknown
      [7e59be6] xfs_quota: Enable 3 more foreign commands
      [cb35671] xfs_quota: un-flag non-foreign-capable commands
      [2f7d042] xfs_quota: fix free command for foreign fs
      [73b54bb] xfs_io: allow chattr & chproj on foreign filesystems
      [f10a5ab] mkfs.xfs: clarify ftype defaults in manpage
      [4d457e2] libxfs: factor mount checks into helper function
      [e5c4ab5] xfs_repair: fix segfault from uninitialized tp in mv_orphan=
age
      [cbca895] xfs_copy: Fix meta UUID handling on multiple copies

Hou Tao (1):
      [4fd2b07] xfs_logprint: remove the printing of transaction type


Code Diffstat:

 VERSION                    |  2 +-
 configure.ac               |  2 +-
 copy/xfs_copy.c            | 20 +++++++------
 doc/CHANGES                | 10 +++++++
 include/path.h             |  1 +
 io/attr.c                  |  2 +-
 io/open.c                  |  2 +-
 libxcmd/paths.c            | 12 +++++++-
 libxfs/darwin.c            |  2 +-
 libxfs/freebsd.c           |  6 ++--
 libxfs/init.c              |  4 ++-
 libxfs/init.h              |  3 +-
 libxfs/irix.c              |  2 +-
 libxfs/linux.c             | 80 +++++++++++++++++++++++++++---------------=
-------
 logprint/log_misc.c        | 50 ++-----------------------------
 logprint/log_print_trans.c |  4 +--
 logprint/logprint.h        |  2 --
 man/man8/mkfs.xfs.8        | 10 +++----
 quota/edit.c               |  3 ++
 quota/free.c               | 60 +++++++++++++++++++++++--------------
 quota/init.c               | 18 +++++++----
 quota/path.c               | 37 +++++++++++++++--------
 quota/state.c              |  1 -
 repair/phase2.c            |  3 +-
 repair/phase6.c            |  2 +-
 25 files changed, 181 insertions(+), 157 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX5HdlAAoJEK3oKUf0dfodMhIP/3jn2dy2FnphmM6VXVOTjxWc
MvixCofPsewPHtyUuOZDRu5FIzImQ7Ay446bgSY+nSxyY8gcho1+9170uC+0+Xqd
GQI6Bh7mNqHR+poFCNcD7WZ7xIzPsRVS2JhDLMhfOjUA5p8gjXddjSrgXflq4mTF
NIgNKzxtsMIrSHyE8LGlWfaGx7apk2VMauxinNwKB7RnGeJrwBhqKzU9bAErUOmm
sd7SiL8V2Rlmkb2oQCHJ13iWjK2xLKrm4tT1FF/cpAK6sxn94umVnN1EN2Zcr7oQ
RdnUW6tLKLQbzE8F/lFTjHvpan6L3rUmH2DMwzTvDb8rkltXeURSacxFt8FMUYPK
F4lL+2fl2gL2wy9ebJCIIfswW+XmQPlhxMMCLNTpLRsB4BH73jaWr1jg0o2hfhLw
xsMc212sQVGCaZKcyQBu+sbiNjvd63VBZIo5bPUQJcf9O6azzuKy41OcFO/ynqsx
PZti7SGwaXD7w4OV5Tk6K2hsnSWRGj7yTJDzxTXulNlmBxl7IEiwPThUhZDw8MvC
ubCSqKG1zXxwBjI6NCLOW0F46lfKcoSMFBPvwEE/4ysCWeO+HfcuRckNc+lqSChD
TvmUDd+X7GT+rTZBnJMnvDIqVDXx3x7aeAjm6Bk4Pk6hoF3HE15hPUfgdyhNcuJT
4Bb1T/xk4pmVev7IwzIk
=/khV
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
