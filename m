Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E52297F56
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 16:37:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 707D4AC002
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:37:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aMXMc9FPDKYrTH9A for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2016 14:37:13 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aIl4N-0004Ae-5J
	for xfs@oss.sgi.com; Tue, 12 Jan 2016 09:36:11 +1100
Date: Tue, 12 Jan 2016 09:36:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to dde7f55
Message-ID: <20160111223611.GJ10456@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6760025056539862988=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6760025056539862988==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This should be the last update before asking
Linus to pull the branch for the current merge window. If nothing
shows up in the next couple of days, I'll send out a pull request...

-Dave.

The new head of the for-next branch is commit:

dde7f55 Merge branch 'xfs-misc-fixes-for-4.5-2' into for-next

New Commits:

Dave Chinner (5):
      [121e213] xfs: add tracepoints to readpage calls
      [e354381] xfs: bmapbt checking on debug kernels too expensive
      [b79f4a1] xfs: inode recovery readahead can race with inode buffer cr=
eation
      [7d6a13f] xfs: handle dquot buffer readahead in log recovery correctly
      [dde7f55] Merge branch 'xfs-misc-fixes-for-4.5-2' into for-next

Eric Sandeen (1):
      [f6106ef] xfs: eliminate committed arg from xfs_bmap_finish


Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c        | 141 +++++++-----------------------------=
----
 fs/xfs/libxfs/xfs_attr_remote.c |  31 ++-------
 fs/xfs/libxfs/xfs_bmap.c        |  16 +++--
 fs/xfs/libxfs/xfs_bmap.h        |   2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c   |  36 ++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |  14 ++--
 fs/xfs/libxfs/xfs_quota_defs.h  |   2 +-
 fs/xfs/libxfs/xfs_shared.h      |   1 +
 fs/xfs/xfs_aops.c               |   2 +
 fs/xfs/xfs_bmap_util.c          |  43 +++++-------
 fs/xfs/xfs_buf.c                |   7 ++
 fs/xfs/xfs_dquot.c              |  13 ++--
 fs/xfs/xfs_inode.c              |  25 +++----
 fs/xfs/xfs_iomap.c              |  10 ++-
 fs/xfs/xfs_log_recover.c        |   9 ++-
 fs/xfs/xfs_rtalloc.c            |   3 +-
 fs/xfs/xfs_symlink.c            |  12 +---
 fs/xfs/xfs_trace.h              |  26 ++++++++
 18 files changed, 159 insertions(+), 234 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWlC5aAAoJEK3oKUf0dfodQ3IP/3H9icA+AOk12PRwHHtaclA3
PWw3rdlVI7QLIPMr+2a+YBGAHKrwfnsESg02Tmb5lgDMpXZdz42f6565phakWFZH
dMYDP0R9pbODwOF8jWmaFOPrcfVD3i5BiZxdqifUmzG5KEbChaco10Vgq+akLrMr
NTWPYZIr/6yTvTApXyV+7g/jw1XyJgJTcXiKJPzJ/UKpqAlYX30Wy+HXvFu8oKLZ
1opPDPCHBiTjkdJ+wKZj8g6HGCSnwpbRWZRFjl0ltKEtVzs7vCrCLwrS+SqmJP3f
YJ2Gm6EKq73yEpT8iQ5KY4rmAX63oiWAXAcUx1MunFIYyWdkyIuzYdzAevvVrDIy
TiQicIBJV6f5LDkmBvE1xNiy7zZjILMNcoludQ8SlAIXCumlsAF5Uu0/vJ478fM3
bCu7MMFWtMSS43GacgMWA8IAL9sQQXdilCLZTqbYkrYrMdhM46uNeEcSzCKyrJCL
zn2TPjpk5KMIW2eP2cWW0f55HiuIlxMyDQn5htcMNUYFS1XHAVvcu3Cgyn1RcIt0
WbPIJVN5jGBO1U6uBiEOzKZCtH26T03FdXKqlLEIoPkf4Un7CS/RgsyU1/ikLmwP
VARFMQXlDHy5il45nqafUZxXRtGzCQd21JKBj/upGeGJm0fH9q1EBguGSUCe7RTX
Bl74OTu4Ki4vVHuTmWI+
=KogP
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--


--===============6760025056539862988==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6760025056539862988==--
