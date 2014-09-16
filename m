Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F3207F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:03:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C30D4AC007
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:03:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	LOn23fJyhRtUVtLm for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 15:03:43 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XU0qP-0003BO-G0
	for xfs@oss.sgi.com; Wed, 17 Sep 2014 08:03:29 +1000
Date: Wed, 17 Sep 2014 08:03:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 794b62f
Message-ID: <20140916220329.GM4322@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8057472274630709282=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8057472274630709282==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

794b62f xfsprogs: add supported file attributes to xfs.5 manpage

New Commits:

Eric Sandeen (10):
      [713ba3f] xfs_io: free fshandlep in parent_check()
      [4f10a2f] xfs_fsr: fix leaks & catch error in fsrfile()
      [e3e2793] xfs_fsr: free handlep in fsrfs
      [8f1c8e1] libhandle: Fix handle leak in path_to_fshandle error paths
      [70ac12f] xfs_io: fix leaks in parent_list()
      [9c1c2e3] xfs_db: free flist on error in write_struct()
      [5cd0710] xfs_repair: clear bad flags in process_dinode_int
      [50aeb09] xfs_repair: preserve error state in process_shortform_attr
      [4f20f6a] xfs_io: add mremap command
      [794b62f] xfsprogs: add supported file attributes to xfs.5 manpage

Jan Kara (1):
      [937ef31] repair: Set ftype for entries in lost+found

Jan Tulak (1):
      [02ef543] libhandle: fix installation for symlinked /usr

Mark Tinguely (1):
      [4263df5] mkfs: fix typo in output


Code Diffstat:

 db/write.c           |  1 +
 fsr/xfs_fsr.c        | 31 ++++++++++++----------
 include/buildmacros  |  9 ++++---
 io/mmap.c            | 73 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++
 io/parent.c          | 13 ++++++----
 libhandle/handle.c   |  1 +
 man/man5/xfs.5       | 22 +++++++++++++++-
 man/man8/xfs_io.8    | 14 ++++++++++
 mkfs/xfs_mkfs.c      |  2 +-
 po/pl.po             |  2 +-
 repair/attr_repair.c |  3 ++-
 repair/dinode.c      |  6 ++---
 repair/phase6.c      |  4 +--
 13 files changed, 149 insertions(+), 32 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUGLOwAAoJEK3oKUf0dfodj+AQAMCy7Bwrpp/EfbDfsfiYAo35
+ewYlCZ5nbEK5Jwtf/C/M1rVAzwSML2ykdJfLHh6aW63N+xCn2bUnBhKKeJyWJ+1
+4qzRC1oj86z6C3/jYClOvdFwqBRIcX3PZ8ZRbvLM0FNMCbYUvTUj2T8izeEHH40
kUx336+zLUZUyoeecIopcFH4W3WzSPMUcw1sDwwJIUJZHzg3PgjoHcjui038QfGP
Ec8nouyV0E5BjSwLbgIIeMe9xLbwmGTHDzT2J/Ef8+MN0GGi5wP2OO9il9rK+wmI
qaps27jwqARRbFjwpkCvdCCghAARJdMdi9KRwupGeS143GibZiufrwJsrCMl2GJ0
9g74TJY1nnJI7wIrwAfWPAD+1faS0fuwpfkvXdBwhqfHwgO7KNjci52AdxwdtKHS
etkhQgZuaFpBzq9jRT9AZItLJfX92jqzKfsFVX6NOT8GbECsqVl+sqF8i7n5sr4R
qb8s3uXG61iHjvLYFSB/iTteVW/t8GlSbMpa2HHX3CTJHy57h1rMK0y+xflLgIek
jotyjJzO8TQcBf2UrBvLJpC2fIIK1yItPSg+alO/bY/aA31YtYmclUcX5vxDIC1T
n40e3+LoXCKmjnIc0TMV/YTgztWfyeP19GQRICo+N7qxH/aTXkNmz3zKsjY6J74L
us7vXYEwIZQk82DJnUOP
=YWgP
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--


--===============8057472274630709282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8057472274630709282==--
