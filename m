Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C9027F51
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 20:40:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 65A0130404E
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 18:40:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2VEEDpstGmu4iu7h for <xfs@oss.sgi.com>;
	Mon, 07 Jul 2014 18:40:42 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1X4KOd-00030J-OA
	for xfs@oss.sgi.com; Tue, 08 Jul 2014 11:40:39 +1000
Date: Tue, 8 Jul 2014 11:40:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUCE] xfsprogs: master branch updated to 871fbfd
Message-ID: <20140708014039.GV9508@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2040824423243821034=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2040824423243821034==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

871fbfd repair: get rid of BADFSINO

New Commits:

Dave Chinner (6):
      [b5f5c2d] repair: support more than 25 ACLs
      [97ada36] xfs_db: write command broken on 64 bit values
      [15e3986] repair: handle directory block corruption in phase 6
      [6af7c1e] libxfs: reused invalidated buffers leak state and data
      [d085fb4] repair: fix quota inode handling in secondary superblocks
      [871fbfd] repair: get rid of BADFSINO

Jan Kara (1):
      [575010d] repair: Repair directory block CRC mismatches


Code Diffstat:

 db/write.c               |  2 +-
 include/libxfs.h         |  1 +
 libxfs/rdwr.c            | 43 ++++++++++++++++++++++++++--
 libxfs/xfs_attr_remote.c |  2 +-
 repair/agheader.c        | 44 +++++++++++++++++++----------
 repair/attr_repair.c     | 73 ++++++++++++++++++++++++++++++--------------=
----
 repair/attr_repair.h     | 46 +++++++++++++++++++++---------
 repair/dir2.c            | 44 ++++++++++++++++++-----------
 repair/phase6.c          | 29 +++++++++++++------
 repair/sb.c              |  2 ++
 repair/scan.c            |  1 +
 11 files changed, 204 insertions(+), 83 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu0wWAAoJEK3oKUf0dfod+LkP/39lD73xCNI3ETE9LHGDVAGu
/xY1dBo7j9w5wz/tJ4RWBwmMcigW9LG554dE//FONmXiVfTzHeAL1nEaCa5Q3Ti1
oYwSTRybTxj3Q+MIouvbC+BFBNWwelVYQRESPQcOCAxZMFNxJHblbtaKJMMzM4i6
80z72xuy/hqTuBo4TBpmqWuYeG+uVTAOmMIv92Nx97HwU4YzIQr3PL5LqtvEesIw
FcEnAt+gMDM+dckyc3NOJkdyFkZmw6XpC0hjBFKsDqo8qnm8EPQKpRHbd0DfNWX8
vHoL5WmFtHKBKXNiNXxhDZWZhdTNDXrqk4fPjEhn+lKneX3vrMbYRvi0dsl5wfWg
oA37tzMerDNl0nSe7cD3ZhGVkxPEmtKSOvnwIkgoCY0aZj/DVx35ROxx4tSVDy8D
78Wn1yUWSikBluWrM0NRdImm90JZEvsRrws3YW/2WuItY3p+iPn35eXKQztLeGap
qyCd9jQKLc9zhhe66e+prXw1Og9WkO08ZSDngJV9yzyioxZg6De87p6ojnK2kj3n
1i2fX0yBZaVgC1puxGNhxUS8OrmLJ2M2sE7/p5PT99fG/DTa7cnxHSukFFO7CcsB
DcOFUYq9nJ/hsJa0QFGFfXq0OBSfm+Q4xtZ59vljwo7g8DnjM1ueoCvb6GzN6LwL
cjEAWvNDjNgRLcah/iHg
=fJ+5
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--


--===============2040824423243821034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2040824423243821034==--
