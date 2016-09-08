Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 97D9B7CA0
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 17:28:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B3BF304043
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 15:28:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qYMEvGBwlwI2ZwLQ for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 15:28:13 -0700 (PDT)
Date: Fri, 9 Sep 2016 08:27:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.8.0-rc1 released
Message-ID: <20160908222757.GZ30056@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3568718439449087020=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@vger.kernel.org
Cc: xfs@oss.sgi.com


--===============3568718439449087020==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged with v4.8.0-rc1. This is the first
release candidate with support for the new reverse mapping on-disk
format support, and contains many other updates and fixes. See the
doc/CHANGES file summary included below for details.

While you're all reading, I'll drop a reminder that the XFS list is
moving permanently to linux-xfs@vger.kernel.org at the end of
September.  Please resubscribe to the new list before then!

-Dave.

xfsprogs-4.8-0-rc1 (9 Sep 2016)
	- change contact emails to linux-xfs@vger.kernel.org
	- libxfs: kernel sync up to 4.8-rc1
	- Initial reverse mapping support (Darrick Wong)
	- buffer lock trace analysis tool (Darrick Wong)
	- logprint: cleanups and fixes (Darrick Wong)
	- man page updates (various)
	- libxcmd: mount option parsing fixes (Darrick Wong)
	- xfs_quota: use XFS_GETQSTATV (Eric Sandeen)
	- xfs_quota: allow use on non-XFS filesystems (Bill O'Donnell)
	- xfs_db: allow direct manipulation of CRCs (Eric Sandeen)
	- libxfs: get rid of ustat() calls (Felix Janda)

The new head of the master branch is commit:

130093a xfsprogs: Release 4.8.0-rc1

New Commits:

Darrick J. Wong (2):
      [6761d5a] xfs_repair: don't crash on ENOSPC rebuilding a btree
      [752ae76] xfs_db: pass the inode cluster offset when copying inodes

Dave Chinner (2):
      [4222d00] db: write via array indexing doesn't work
      [130093a] xfsprogs: Release 4.8.0-rc1

Eric Sandeen (1):
      [13061b8] xfs_db: properly set dquot_buf when operating on dquot

Felix Janda (1):
      [4e7a824] libxfs/linux.c: Replace use of ustat by stat

Zorro Lang (1):
      [88dabc1] xfs_quota: fix missing break after foreign_allowed option


Code Diffstat:

 README                   |  2 +-
 VERSION                  |  4 ++--
 configure.ac             |  2 +-
 db/dquot.c               |  1 +
 db/metadump.c            |  2 +-
 db/write.c               | 18 +++++++++++++++++-
 debian/control           |  6 +++---
 doc/CHANGES              | 13 +++++++++++++
 libxfs/linux.c           | 29 ++++++++++++++++++++---------
 libxfs/util.c            |  5 +++--
 man/man8/xfs_mdrestore.8 |  2 +-
 man/man8/xfs_metadump.8  |  2 +-
 quota/init.c             |  1 +
 repair/phase5.c          |  6 ++++--
 14 files changed, 69 insertions(+), 24 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX0eXsAAoJEK3oKUf0dfodqC4P/3msCKAX7i3fP85y2YE296rP
ztLWuNcGwNmxhJlyK9X8245/pOz4XhH270nnehTFjPQ7hKyvtEqhTBtSWw6GPtiy
HC7wXeq9AlitUv4FFiFFY76rGiqGZsepsCLIcX5K3Oa7T/m/tNyHS4++R4I9pOY0
s1bD+C0CLOqsPJk4FiiqHkFmo4KePWGaiu5FHA1lxoYr01YWxL6k215Ml+jqwdow
UIOJ/yuGQCdWTuk4P8+K306iDJDdb/6dPJAyPqtDjL3XFhRlRfZOqYUTsm+6bMR0
Xl8lSmI02x3iXv4AvAmKFnHk3R+yc+ldZYZgqwdWKSgcse9+Dx1Ev4ynUoCP1KjS
U/HWZ+K4WA6ubN5wn7SXkl8bc7Kjyumd85HLFEG5eypvJA2GfS2P4KluWEhUOFpr
BXPwsan3RF6nHh3UQnHPhiMji7Tek3G2uzxTqAjEA+GvndXAD91u69/tk/pu5HUi
zmlmi6RS6QT9sFu2EAuQClUt0WcIJRJvmxy0f4Ng53S8huaF9EkJ8yi2N9p+Yzsx
fQJaQH7W+99wnTw9SnR/NlQQxUycDcBBherkqEdZDaUL1H+105HTdUMpi7fQvJq/
zg1mgFVZNyI3l3l+RRiYYr2y2biffekPsnYMdQES+sbdxJ4U0W3VsX9BIOk8EN+f
mt8j8zm0qxAHV0iURePe
=OUcY
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--


--===============3568718439449087020==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3568718439449087020==--
