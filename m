Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 96CE07CA1
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 19:49:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 67BF0304043
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 17:49:22 -0700 (PDT)
Date: Mon, 26 Sep 2016 10:49:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 2e405cd
Message-ID: <20160926004917.GU340@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9196345639157197587=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com


--===============9196345639157197587==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This includes a bunch of log recovery fixes
for v5 filesystems.

REMINDER: xfs@oss.sgi.com is going at the end of the month. Please
change your XFS list subscription to linux-xfs@vger.kernel.org,
otherwise things will go silent for you....

-Dave.

The new head of the for-next branch is commit:

2e405cd Merge branch 'xfs-4.9-log-recovery-fixes' into for-next

New Commits:

Brian Foster (5):
      [12818d2] xfs: rework log recovery to submit buffers on LSN boundaries
      [22db9af] xfs: pass current lsn to log recovery buffer validation
      [040c52c] xfs: don't warn on buffers not being recovered due to LSN
      [60a4a22] xfs: update metadata LSN in buffers during log recovery
      [5cd9cee] xfs: log recovery tracepoints to track current lsn and buff=
er submission

Dave Chinner (3):
      [292378e] xfs: remote attribute blocks aren't really userdata
      [ddeb14f] xfs: quiesce the filesystem after recovery on readonly mount
      [2e405cd] Merge branch 'xfs-4.9-log-recovery-fixes' into for-next


Code Diffstat:

 fs/xfs/libxfs/xfs_alloc.c |  23 +++---
 fs/xfs/libxfs/xfs_alloc.h |  17 ++++-
 fs/xfs/libxfs/xfs_bmap.c  |  41 +++++++----
 fs/xfs/libxfs/xfs_bmap.h  |   2 +-
 fs/xfs/xfs_bmap_util.c    |   2 +-
 fs/xfs/xfs_extent_busy.c  |   2 +-
 fs/xfs/xfs_filestream.c   |   9 ++-
 fs/xfs/xfs_log_priv.h     |   3 +-
 fs/xfs/xfs_log_recover.c  | 191 ++++++++++++++++++++++++++++++++++--------=
-------
 fs/xfs/xfs_mount.c        |  14 ++++
 fs/xfs/xfs_super.c        |   2 +-
 fs/xfs/xfs_super.h        |   1 +
 fs/xfs/xfs_trace.h        |  39 ++++++++--
 13 files changed, 248 insertions(+), 98 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX6HCMAAoJEK3oKUf0dfodMzYQAKllHTwgyl/3yX/g/1MCc1gY
5XIEfFMRBPfNokuqxUtJnfA5DD5+wYdYTrF+2m5c0UWNptN9Knr+cZv+1fL/vF+Y
IbEBaFe14TG+EiQbM7QhmU3VHcbEl2XMQkjUhpFXY4jUfd/jnQmi8rRKZV1iz//3
xDFFcTday/QnS9R2TCl8M2LZtoDBD525H9dCfccGIysgliPdes5LawZ7IBNJKGRy
Z12yBlcdhPxm01XmlxC4R+Xo3SxrgVtXFVNTm23QxPPz6ACIF0l4VMSD0V2wy7Fn
30pYB7zvKuqrl7Bs99a6LIjxeQLQecSpoXhPpwmMjHFfwgQB4VI/Emef/1SSGdHW
u1WnGZYEf4v0nzD6LRHnT9zt27cj2rTBjqWpNcbomqH+Q5PtHMVw6LaQI8e//DwY
vZAYeBYlUVWkU+B/pSalvcCDsdIytGOgSU81gaSz1o+BV72xwDQReePbbwnfwdFG
3kHPYvQLKyXmaDqiBKqw/n92C5UsJQA1Y7TGPB97JaMBLFEq84/PitrZHYpoUzqf
aee4BkZI6J9VFoNudO3JMCwZfhwN3LQRZcw+RKGQlBWKxGeR59ccqnPbTla1nMmn
G4FC6LMWC2vlhTgm5PkRM96IygvljuQl/dXnQq5NvZ0s8v7cMpDYGlDNNAKnthSf
JEX4IlHd4xa9lm4+iP2w
=gfr2
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--


--===============9196345639157197587==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9196345639157197587==--
