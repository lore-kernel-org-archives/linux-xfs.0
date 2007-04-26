Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 12:47:10 -0700 (PDT)
Received: from mail.uni-bamberg.de (ldap.uni-bamberg.de [141.13.240.52])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QJl3fB000638
	for <linux-xfs@oss.sgi.com>; Thu, 26 Apr 2007 12:47:05 -0700
From: Martin Eisenhardt <martin.eisenhardt@wiai.uni-bamberg.de>
Subject: Unexpected XFS SB number 0x00000000
Date: Thu, 26 Apr 2007 21:46:55 +0200
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3543304.phMfCJkCqD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704262146.59921.martin.eisenhardt@wiai.uni-bamberg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.comxfs@oss.sgi.com

--nextPart3543304.phMfCJkCqD
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello list(s),

I run XFS on a software raid on Linux 2.6.19. When I invoke xfs_db in=20
read-only mode, I get:

# xfs_db -r /dev/md0
xfs_db: unexpected XFS SB magic number 0x00000000
xfs_db: read failed: Invalid argument
xfs_db: data size check failed
Segmentation fault

The system is still running, the filesystem seems to be fine (except for th=
e=20
above): files are created, written, and deleted without any problem.

So, I have two questions:

* Is there a real problem, or might a quick reboot solve this?
* If there is a real problem with the file system: What steps do you recomm=
end=20
to overcome this problem?
* How safe is it to run xfs_check and xfs_repair?

Thanks in advance!

Kind regards
Martin Eisenhardt

P.S.: Sorry for cross-posting, I just figure that maybe the XFS users on=20
non-linux systems might have a hint or two for me ... ;-)

--nextPart3543304.phMfCJkCqD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGMQGzVUsW4y0BHEIRAgz0AJ9b1WM82QzdM+XJw24JVEppa/kMhQCeOM/7
nFHLi8PkV2WrBLZj1WedVP4=
=HQDp
-----END PGP SIGNATURE-----

--nextPart3543304.phMfCJkCqD--
