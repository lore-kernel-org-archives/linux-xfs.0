Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96E407CA2
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 01:57:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E2426AC001
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 23:56:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gcipzjUl5HnTjoWr for <xfs@oss.sgi.com>;
	Mon, 14 Mar 2016 23:56:52 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1afiuD-0004DQ-HL
	for xfs@oss.sgi.com; Tue, 15 Mar 2016 17:56:37 +1100
Date: Tue, 15 Mar 2016 17:56:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.5.0 released
Message-ID: <20160315065637.GD11812@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1487865176050351677=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1487865176050351677==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repositories have just been updated and tagged with the
v4.5.0 release tag. It can be found here:

git://oss.sgi.com/xfs/cmds/xfsprogs.git v4.5.0
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.5.0

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.5.0.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.5.0.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Many thanks go to all the contributors to this release. The summary
of changes since v4.3.0 can be found listed in doc/CHANGES, which I
have reproduced in part below.

-Dave.

xfsprogs-4.5.0 (15 Mar 2015)
        - xfs_io: prevent divide-by-zero on random IO (Dmitry Monakhov)
        - xfs_db: dquot command documentation fixes (Eric Sandeen)
        - xfs_quota: better command line parsing and documentation
          (Zorro Lang)

xfsprogs-4.5.0-rc1 (17 Feb 2015)
        - libxfs: update to match kernel 4.5-rc1 code base
        - xfs_io: add DAX inode flag support
        - repair: scalability improvements on large corrupt filesystems
        - repair: directory rebuild fixes
        - mdrestore: progress accounting now works
        - metadump: fix btree block unused region zeroing
        - quota: timer command fixes (Eric Sandeen)
        - mkfs: man page cleanups (Eric Sandeen)
        - xfs_io: reflink, dedupe and other fixes (Darrick Wong)
        - quota: Q_XGETNEXTQUOTA support (Eric Sandeen)
        - build cleanups for alternate C librarys (Joshua Kinard, Felix Jan=
da)
        - db: check fixes for sparse inodes (Darrick Wong)
        - various: Fixes for Coverity reports (Vivek Trivedi)
        - xfs_io: Document zero and help commands (Eric Sandeen)
        - mkfs: DIO can use logical sector size limits (Eric Sandeen)
        - repair: don't reset log cycle numbers when zeroing (Brian Foster)
        - db: add ability to format log to a specific cycle (Brian Foster)

The new head of the master branch is commit:

53cefc4 xfsprogs: Release v4.5.0

New Commits:

Dave Chinner (1):
      [53cefc4] xfsprogs: Release v4.5.0

Dmitry Monakhov (1):
      [2ab8ecb] xfs_io: Prevent devide by zero from {pread,pwrite}_random

Eric Sandeen (1):
      [fa247a5] xfs_db: Fix dquot command docs

Zorro Lang (1):
      [c614d3b] xfs_quota: modify commands which can't handle multiple types


Code Diffstat:

 VERSION              |  2 +-
 configure.ac         |  2 +-
 db/dquot.c           |  8 +++++---
 debian/changelog     |  6 ++++++
 doc/CHANGES          |  6 ++++++
 io/pread.c           |  6 +++++-
 io/pwrite.c          |  6 +++++-
 man/man8/xfs_db.8    |  4 ++--
 man/man8/xfs_quota.8 | 14 ++++++-------
 quota/edit.c         | 60 ++++++++++++++++++++++++++++++++++++------------=
------
 quota/quot.c         | 15 +++++++++-----
 quota/quota.c        | 15 +++++++++-----
 quota/report.c       | 20 ++++++++++++------
 13 files changed, 112 insertions(+), 52 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW57IkAAoJEK3oKUf0dfodgboQAIh+Xmyx7DY0iH2M8BjuJyET
ut+dRAdIYooN9biXCM1aeHLaegMIIA1rNQ7t1yf/opHeRVz2uwa7OKhga5LNwLvr
xEEksJvWMCoz0mGe00N3PhWt34zCLZqkCnfZg0alHa3gSkteT9muqBKXRlFs0x7N
xcrLZdoTTVsiI7fY3rGOaCcZOo+88sO0nONFFTDPgMVIWo9eIC7enZpNkbrxspkg
ymTo55vTQdCg+LZx4sryu2JlAFcNcjNbxL8GBlzJhDWMKfzoVSEKDh1pRHge4LfB
jtqnDXwHhe8W1Ddh1myeJYJgC1HMTxAN5Uf4hTjjUe7/LyX0mwpd/8UlqSnVWDCE
ApT2uVtnUbAJoOTzgU2Fjyh0CAoHTKHJGhBftw8piGydk0XyFu+SWMSAGNEROEw1
jgBvvw99PdBMcwe29nr2GaqaCosG7MGQOjVU2vnjluBhs6pU6GgZB1yd/xD/FVVf
W74G1cQ4ZKO8URmjJCgPecxtLFMBuWmmFjK3eG1SYTlzyBZ/m6FBUsnNdCP732Yo
XzzT07FNaR+gvcT6gy7wDuAxjz+G9bjPTmIkMt0lTB7r5RgNAN9dor/eTt4fmbRW
vyE1eKC7qnstwwBoqU+eAbVyPXZ7sv79ObRRjGRkxfF3/hRfL5m2ApTRzqdzY7Ya
mJVZhG+4V+G47T1iuu/X
=RfUV
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--


--===============1487865176050351677==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1487865176050351677==--
