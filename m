Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 16B547F54
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 18:41:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 99CA0AC003
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 16:41:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kP78pJhtqdXVucE8 for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 16:41:03 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZSCyP-0007Q7-Cc
	for xfs@oss.sgi.com; Thu, 20 Aug 2015 09:40:49 +1000
Date: Thu, 20 Aug 2015 09:40:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch rebased to aa49338
Message-ID: <20150819234049.GM3902@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7166521564732660285=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7166521564732660285==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Content-Disposition: inline


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been rebased to add a build fix to the
xfs-misc-fixes-for-4.3-2 topic branch. The new commits are below.

-Dave.

The new head of the for-next branch is commit:

aa49338 Merge branch 'xfs-misc-fixes-for-4.3-2' into for-next

New Commits:

Dave Chinner (2):
      [3403ccc] xfs: inode lockdep annotations broke non-lockdep build
      [aa49338] Merge branch 'xfs-misc-fixes-for-4.3-2' into for-next

Code Diffstat:

 fs/xfs/xfs_inode.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV1RQAAAoJEK3oKUf0dfodZioQAL7DtVLbhvvBUReFsTQnXssB
gb2YVtmapGxWrfxa4CJJtZgDtOo2Ej2Lakaa8O6kpFKYYoAzFRAYZ9wRovsBgFdr
ZbbVjuybh7zxNS/6BUbqjdHC3Z2rLtdpbm5qpgth1YKmrqPwb4/NFS/ykMZvW7Jo
Xb92UA+lf2JXwLGsZrJWkdr3s+KpHZH8TEGMoMGPfJNYsykL58/unxIAceeJvTcH
hybx32fPj28hUNsAk7M4Xa/0CiFFvzObBMU0i5HPlkiBBVqmhxQThSoYSLJ/XAaE
oJfiRuKT8EUkXKSqwgSmiV8/uV3EEG/fczqdMDpIMQyv+AILcCEqokM7wiVH4wmD
VHK3gd7Px2I1pHEMimTUuPLfI/ST1JL2MhX3wR2BCVwJfMjqA6cpo+dEm5qN6M15
w25OWDgQYCRlmfhY4SKElthPMZIMOxZItbVVyoWZd8mPiH2ZZ1SFkUe/Gu3ACw0E
OhENLuhnNl7fsLMUOe5WR656sLDxtEPGFykd0Th5+c/ixTvlsyq0JsL+cnlfbsSz
Kwt2/3UkdIutbAygTt9gmM7XUzm6ijeOLPo28FzC8MmRFsoe6RW6BwDwZ/UHlgSN
npAo1KPO8XuoT6LA3WEyusuDQKqIQDUCmbe4Yur4/vGc60Owic364xN6w3IgCHoq
Ds68cDXB36hKCUCaK8UV
=k0Nn
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--


--===============7166521564732660285==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7166521564732660285==--
