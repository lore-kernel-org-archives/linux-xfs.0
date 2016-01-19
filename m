Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 398647F37
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 15:42:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B2FF8F8052
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2016 13:42:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RlSg5MUaTIdt6UJj for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2016 13:42:33 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aLe2p-0006xa-Ht
	for xfs@oss.sgi.com; Wed, 20 Jan 2016 08:42:31 +1100
Date: Wed, 20 Jan 2016 08:42:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to ee3804d
Message-ID: <20160119214231.GS6033@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1334574155548193076=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1334574155548193076==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This contains a couple of regression fixes
for the recent 4.5 merge, and the XFS_IOC_FS[SG]SETXATTR API vfs
promotion that I forgot to merge into the original pull request.
If nothing comes up, I'll ask Linus to pull these in a couple of
days time.

-Dave.

The new head of the for-next branch is commit:

ee3804d Merge branch 'xfs-misc-fixes-for-4.5-3' into for-next

New Commits:

Dave Chinner (7):
      [334e580] fs: XFS_IOC_FS[SG]SETXATTR to FS_IOC_FS[SG]ETXATTR promotion
      [e7b8948] xfs: use FS_XFLAG definitions directly
      [58f88ca] xfs: introduce per-inode DAX enablement
      [4c931f7] Merge branch 'xfs-setxattr-promotion' into for-next
      [3e85286] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
      [85bec54] xfs: log mount failures don't wait for buffers to be releas=
ed
      [ee3804d] Merge branch 'xfs-misc-fixes-for-4.5-3' into for-next


Code Diffstat:

 fs/xfs/libxfs/xfs_format.h | 11 +++++-
 fs/xfs/libxfs/xfs_fs.h     | 38 +------------------
 fs/xfs/xfs_buf.c           | 10 +++++
 fs/xfs/xfs_inode.c         | 60 ++++++++++++++++++------------
 fs/xfs/xfs_ioctl.c         | 92 +++++++++++++++++++++++++++---------------=
----
 fs/xfs/xfs_iops.c          |  4 +-
 fs/xfs/xfs_trans_ail.c     |  1 -
 include/uapi/linux/fs.h    | 33 +++++++++++++++++
 8 files changed, 147 insertions(+), 102 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWnq3HAAoJEK3oKUf0dfod9ikQAIFmmb19FqS42E7u74IJaPLq
13CuYWnqULrJwzfhQUoeJeavIrcHWj6whV756QwSNG/c9c2ODp/H8l6e+vPw0Ggm
fOPav3T0vufWz+trgVZjMY/DiViYVas+wM9paliFC15XTq9tGgaP98CCCTpcQ4JM
9cbKegcbM3jcR2clq1Z3biXPzdQjVMJFYyapZiO9Z1jHE8ziC+hPFD0T74YbbU6P
t5FqVRbfGmjLANlicbaPoty8Eis+noLUEykjPIlFVFYLcHdsZd45KX5dV1ESVcUD
mmiAxzmRnZ1GlrejX5iGRdaOprfQjZPy6S/BGZMydelV85/X0327bImXbXzLL+8j
dTde/VPXKi23eyqGe869VmIqpSX1/HLUbIupeRKbLbvfM9NRv4bfGdZxD4KXhiPr
gSPmjsTpGq69fxMwZpcA+MCuowWNhOfySM0UQ0htm3MMytcRIHy5VmhOYC45Dvx6
fqgvUVCtZoWIk+wL5ZqUSpgzARqKmWeJGIm/QvUBikdQ/ct/zGSJ6kmQhQVjJWkJ
oXr1lsMh/KMYK22m5mLvGL+uXQaCUZoRQJhlcA0NF1kbSMLaE19s6TdXO+3SDHPF
9YJDjNhnfCusXMCXdl/VUV02Cyotj3zPjDrez94m5QNnkdKwzYlM0qwGAUldmakN
uBCmRXlWKe5p2UEpO3Fk
=mIFI
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--


--===============1334574155548193076==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1334574155548193076==--
