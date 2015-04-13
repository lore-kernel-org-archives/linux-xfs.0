Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DBCAB7F54
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 19:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B6E67304032
	for <xfs@oss.sgi.com>; Sun, 12 Apr 2015 17:59:23 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1py2pqWLaXI7CioH for <xfs@oss.sgi.com>;
	Sun, 12 Apr 2015 17:59:21 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YhSiR-00064o-M3
	for xfs@oss.sgi.com; Mon, 13 Apr 2015 10:59:07 +1000
Date: Mon, 13 Apr 2015 10:59:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 502544b
Message-ID: <20150413005907.GO15810@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7827887291786565510=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7827887291786565510==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated. These are mostly fixes to xfs_repair to handle
badly corrupted directory structures, but there are a few other
minor fixes as well.  Thanks to everyone who
reported/fixed/reviewed/tested these changes.

The new head of the master branch is commit:

502544b libhandle: add fd_to_handle to handle.h

New Commits:

Brian Foster (3):
      [31daa90] mkfs: don't zero old superblocks if file was truncated
      [9da3610] db/check: handle zero inoalignmt correctly for large block =
sizes
      [fa8fb25] repair: only check secondary sb->sb_pquotino for v5 superbl=
ocks

Darrick J. Wong (2):
      [ba1c677] xfs_repair: don't abort on bad directory leaf crc during le=
af check
      [bf43fd2] libxfs: don't write uninitialized heap contents into new di=
rectory blocks

Dave Chinner (1):
      [8bc43a3] repair: superblock buffers need to be sector sized

Eric Sandeen (14):
      [c9f5e3d] xfs_db: Allow writes of corrupted data
      [b335ecb] xfs_db: fix inode CRC validity state, and warn on read if i=
nvalid
      [6367f2a] xfs_db: nlink fields are valid for di_version =3D=3D 3, too
      [cbd361b] xfs_repair: dirty inode in process_sf_dir2 if we change nam=
elen
      [1633feb] xfs_repair: remove impossible tests in process_sf_dir2
      [1c934a2] xfs_repair: collapse 2 cases in process_sf_dir2
      [38c66ab] xfs_repair: remove last-entry hack in process_sf_dir2
      [0402bea] libxfs: remove ASSERT on ftype read from disk
      [1f60de2] xfs_repair: clear need_root_dotdot if we rebuild the root d=
ir
      [aedcecb] xfs_repair: set *parent if process_dir2_data() fixes root i=
node
      [b8ec08a] xfs_repair: don't clear . or .. in process_dir2_data
      [7d7c555] xfs_repair: validate & fix inode CRCs
      [609f6bb] xfs_db: disallow sb UUID write on v5 filesystems
      [89b8d42] xfsprogs: remove unreachable code in libxfs_inode_alloc

Sage Weil (1):
      [502544b] libhandle: add fd_to_handle to handle.h


Code Diffstat:

 db/check.c              |   8 +++-
 db/inode.c              |  17 +++++--
 db/io.c                 |  11 ++++-
 db/io.h                 |   1 +
 db/sb.c                 |  12 +++++
 db/write.c              |  35 +++++++++++++--
 include/handle.h        |   1 +
 include/libxfs.h        |   2 +
 include/xfs_da_format.h |   1 -
 libxfs/rdwr.c           |   1 +
 libxfs/util.c           |   2 -
 man/man8/xfs_db.8       |   8 +++-
 mkfs/xfs_mkfs.c         |  18 ++++++--
 repair/agheader.c       |   8 +++-
 repair/dinode.c         |  24 ++++++++++
 repair/dir2.c           | 116 ++++++++++++++------------------------------=
----
 repair/phase6.c         |  10 ++++-
 repair/scan.c           |   2 +-
 18 files changed, 175 insertions(+), 102 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVKxTbAAoJEK3oKUf0dfodx6AQAJol1uOqpkyqh+/k0y5W5axp
5Iv5i7Uo9RZjmOneqJydZmUViU/pSL6BJxBzmxyHbm/vfoLiXb6lLTLAWXhTNGx3
ZOsLZjNV98LRU4hIkgXd+TWrvuYa62pv2xaFHmWoomkQJWE6u4bwUAJXt0TRBUzg
TZJ3rxpxFbOYceCPiXUy3FlkSBrV0NGHmu6fFVaB83jXca1fkIbbYk7k7CTwlagm
YuCyiWYKQNP4kW+3AhAutCrMk9Ios+ia+CJcQltCUr0dsLHL0EQGgCnjPKM8oRct
HmNzsRBTtuIZ1la/H0V0FgVEuaRpN5x2c2E8KtvSMR1EvWy6wcVLDP/wrx04FxMk
v/LU03ZWjAtWiVtHXGC4EGhF3LoPfZoFJDc+9fJXqhes4H0rvfTzVB+aNOFCDH9b
YUrdchkGBSP2xis9SFq7oXOUoO5uFAi4mdjrPluhg/+9nZFijsznMVsHvLA4qr5e
BtPNvHu3XPSwVmmwAzPEkABGlMnS2YJIeHEfXNBU7NFW8vE68kOopAiuXft/xili
WnDZaf0+28Kw3K9nX8b+7kqDNKF2h2xST4bYdui4qhG00HNVusiQaCNolHWQNsQ3
OiXJiSUtX7s2B48sae1rE7tg4Qxv/DM60/IQchjjl1xzlmo6vQrwmU8QqUIpJR+R
hx1mmENguu6Lw/JmckvU
=WWEY
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--


--===============7827887291786565510==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7827887291786565510==--
