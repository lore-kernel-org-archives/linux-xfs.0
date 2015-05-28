Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 367DA7F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:53:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A84DBAC005
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 14:53:16 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HBVzFlEcExzh99NJ for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 14:53:12 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Yy5jh-0006Pk-Rn
	for xfs@oss.sgi.com; Fri, 29 May 2015 07:53:09 +1000
Date: Fri, 29 May 2015 07:53:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to cddc116
Message-ID: <20150528215309.GA15721@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4887684354345044744=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4887684354345044744==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

cddc116 xfs: xfs_iozero can return positive errno

New Commits:

Dave Chinner (5):
      [80188b0] percpu_counter: batch size aware __percpu_counter_compare()
      [8c1903d] xfs: inode and free block counters need to use __percpu_cou=
nter_compare
      [6dea405] xfs: extent size hints can round up extents past MAXEXTLEN
      [6dfe5a0] xfs: xfs_attr_inactive leaves inconsistent attr fork state =
behind
      [cddc116] xfs: xfs_iozero can return positive errno

George Wang (1):
      [74f9ce1] xfs: use percpu_counter_read_positive for mp->m_icount


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c  |  8 ++--
 fs/xfs/libxfs/xfs_attr_leaf.h  |  2 +-
 fs/xfs/libxfs/xfs_bmap.c       | 31 ++++++++++------
 fs/xfs/libxfs/xfs_ialloc.c     |  9 +++--
 fs/xfs/xfs_attr_inactive.c     | 83 +++++++++++++++++++++++++-------------=
----
 fs/xfs/xfs_file.c              |  2 +-
 fs/xfs/xfs_inode.c             | 12 ++----
 fs/xfs/xfs_mount.c             | 34 ++++++++++-------
 include/linux/percpu_counter.h | 13 ++++++-
 lib/percpu_counter.c           |  6 +--
 10 files changed, 119 insertions(+), 81 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVZ45FAAoJEK3oKUf0dfodDKgQANG3WL3Jo/L7xbzyvTPD7/2y
IQ5UJ+H2egn7r4t2Mqz/6DnPMM2nxEiWnW3R73LHLrQpugJxMOhVeK2jBwU/CsI1
zbk7+Ru5x9mVtQBbAWW2+YuYgWbQiepDdUMqGqju7WpKsv262rPm2DAMXcfXdeSd
5EjHJGZVRboRbDSdtR4QwLkWANdm0vEzvWsakrzR1Y8cGl1s9JocGdwZyCmkLgnK
e9VCJ4h6jwGwwYTWT3vlOxlRIFPIy3sBhIzyxqd8CgnQP/LPiJo0ZLX2Dpgk4oQ1
ilP5bqEGUgNiPnZJQ6HwrRCJHxrxkdXRdTtv2ZkfW++rmsSCWAwfSAmWuHW7VF+y
1oyFSL6NbpzMOYmPUNxzSmlIsmAjJB9tS19kNDFIGYYcZS74Pf4AiuhCDrzmRTOW
CZPGIK8eB/sXQfAOZbQnByxcl3kpXWfbM4bMJXh57Cicg4d4uW5EYAvHRLxPSufX
MZnIU6dlMfUHHZqq98kGWPU0wGHJsOjwxqq577TfSHJsUHaLeA5HRwyUuMOfegsA
5VjsMTEQBur8xNJX2rvpfGQK8MkPlpHbp3qr1COpdjGc6IFEW5y7enqIzRus8W0m
4KEZqrFjPdb7EDFjV9S56Q4Y5MEIFcF0hL7rBuoHxdRp9fPf7Fa6wKza8cCj2bpl
HTSMexzCT7lrZp7H5aBi
=OSTv
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--


--===============4887684354345044744==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4887684354345044744==--
