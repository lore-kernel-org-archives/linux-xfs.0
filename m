Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8846C7F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 21:22:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08575AC004
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 19:22:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OhSUXwU6q5ZgOA6S for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2015 19:22:20 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZmBgb-0003km-7y
	for xfs@oss.sgi.com; Wed, 14 Oct 2015 13:21:01 +1100
Date: Wed, 14 Oct 2015 13:21:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsdump: v3.1.5 released
Message-ID: <20151014022101.GP27164@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9120548748863551332=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============9120548748863551332==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsdump repositories have just been updated and tagged with the
v3.1.5 release tag. This is a minor bugfix release, and the changes
can be found below.

The source code can be found in these git repositories:

git://oss.sgi.com/xfs/cmds/xfsdump v3.1.5
git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git v3.1.5

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.5.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.5.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

-Dave.

The new head of the master branch is commit:

60e04ee xfsdump: Release v3.1.5

New Commits:

Dave Chinner (1):
      [60e04ee] xfsdump: Release v3.1.5

Nathan Scott (1):
      [5ce9dae] xfsdump: remove use of __psint_t, it is no longer available

Rich Johnston (2):
      [be93e52] xfsrestore: fix fs uuid order check for incremental restores
      [87d192c] xfsrestore: fix 2GB directory dump limitation for multi-str=
eam

rjohnston@sgi.com (1):
      [33ff057] xfsdump: prevent segfault in cb_add_inogrp


Code Diffstat:

 VERSION                 |   2 +-
 common/drive_minrmt.c   |   4 +-
 common/drive_scsitape.c |   4 +-
 common/drive_simple.c   |  28 ++++++-----
 common/util.h           |   4 +-
 configure.ac            |   2 +-
 debian/changelog        |   6 +++
 doc/CHANGES             |   6 +++
 dump/content.c          |  16 +++---
 dump/inomap.c           |   8 ++-
 inventory/inv_api.c     | 130 ++++++++++++++++++++++++++++----------------=
----
 inventory/inv_mgr.c     |  53 +++++++++++++-------
 inventory/inv_priv.h    |   7 +--
 inventory/inventory.h   |  21 +++++---
 restore/content.c       |  23 +++++----
 15 files changed, 189 insertions(+), 125 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWHbwMAAoJEK3oKUf0dfodUKIQAKO5YPwteaoicqUN2N5othnx
CI6dCM5ir4XXtxSnyqK9uZAzUCZrPVNAXGiD5P3Y2F0N+XCNno/1LK+4BTu+D0eR
lq5tztGNfgdLyagvf6VwgXjrC1KJ7d+jpsWEq/CAh7kdMgE3rHZkWWvHm7KbbeTb
EEhiqYnO0B1Mbd3i4WoLWcbJNNthB5wmgSLoTau8xnh+I5DXt0C8PbfS+3ASEH2t
xLV1HPBSuDb2JASX7PM294dwtpae0CwtopqASVtJeu/RgiDganvD5s0+aDZxy72Q
NcIHsWEB2v38rkGh3LHRA5UwEK+x2wt6X0vHnhhb21yiCP0954Rnxaj6RBquFrIs
bjSVJ93nJ8vEcNerESC6joNiwB9b8xiPkhN4I1IkxZcHT2Y4E1GmvPFiOXXPW+uI
BuXAl1xWa6uDrCsXWNNPIDOlgVG0tMMRUmi5zeWoAUylC6YQTviOfql59/M8lst0
h2vgZAT1Y7MDX3KFAJVqz7uFkrp84XtRcBZQbCqx+9VFDEVLuE/WCoGdCW7Ah5RA
weprQnsixhC/+MV9vtcco2OEnySUVnG+GSrlV6HCF0YSwAMKZ4NmTN6m1rI+BYzt
eG6iT9NficZl+qjzgkMFZyfONqF86iwy5JVttEXm7Z3RJ3krS35axe5tXJdCEpO4
9Fr2JWqYz1VVoNl/QP45
=Ayw0
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--


--===============9120548748863551332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9120548748863551332==--
