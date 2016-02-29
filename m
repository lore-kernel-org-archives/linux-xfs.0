Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 637407C8C
	for <xfs@oss.sgi.com>; Sun, 28 Feb 2016 22:58:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD481AC002
	for <xfs@oss.sgi.com>; Sun, 28 Feb 2016 20:58:47 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mF3ZDKVeddLRwdkm for <xfs@oss.sgi.com>;
	Sun, 28 Feb 2016 20:58:44 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aaFur-0000CG-Rp
	for xfs@oss.sgi.com; Mon, 29 Feb 2016 15:58:41 +1100
Date: Mon, 29 Feb 2016 15:58:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 2ab8ecb
Message-ID: <20160229045841.GF29057@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4173840690673437858=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4173840690673437858==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

The new head of the master branch is commit:

2ab8ecb xfs_io: Prevent devide by zero from {pread,pwrite}_random

New Commits:

Dmitry Monakhov (1):
      [2ab8ecb] xfs_io: Prevent devide by zero from {pread,pwrite}_random

Eric Sandeen (1):
      [fa247a5] xfs_db: Fix dquot command docs

Zorro Lang (1):
      [c614d3b] xfs_quota: modify commands which can't handle multiple types


Code Diffstat:

 db/dquot.c           |  8 +++++---
 io/pread.c           |  6 +++++-
 io/pwrite.c          |  6 +++++-
 man/man8/xfs_db.8    |  4 ++--
 man/man8/xfs_quota.8 | 14 ++++++-------
 quota/edit.c         | 60 ++++++++++++++++++++++++++++++++++++------------=
------
 quota/quot.c         | 15 +++++++++-----
 quota/quota.c        | 15 +++++++++-----
 quota/report.c       | 20 ++++++++++++------
 9 files changed, 98 insertions(+), 50 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW09ABAAoJEK3oKUf0dfodgL0P/3/CpVA/oJm8joQKMR0VrLhR
q29YS8+9XoEJtrCY9buQ2beEV2p6rj5wKE1KPxh4Z3HlseNkrs7JiDYUe+wcTaYm
qJZByrwhkNOqUPVGU5UWbHoNIeE86zgP+G6Fr3IyuGQVw413zLVLcUtQ2vXIbKtC
ezd1dVsO6VYqWWnK/yGGPY8noGQKDGK8o/ivH3VaI8TvutfRPl7zEwFiDhWeLcvV
1GJlmX4c8UGTbbigmLQPUDCEDcxsRBfFtq2iq4fKwH9ACmp/TMSvPVNZeGWEEgt5
8qHz5XM6wfZq/QNaDQZJa8SV6aCZmzgxl5YuSvI5zfP22xXKAoEvp7cz3XRU72qH
0Ke3Kf+tCYBZqm94tY2NfcQGW9AkCQ6iqrjQ4M6sVpMwMQhuXC4pSWdlbUmDOUxv
YHr5Ff6ffhE1LMV/gt9r+UnhXC6Wx5f4p9q3/7Y9glr0EYSN0qk9Vgbb8EeIEx+U
Lv/LWUweyitN8DyQ2InL2O1yrvVNq5wvuA6zmd8C9fFo1IoUQudZyRnUBAR3NUmJ
hAR7Uet35z/DioqN6G1uoazTHxHlB0zd4AkMVWBaDTPs8cb/igNMuGjYKQ8HICOJ
qFM4GfKlOv0TqE386p7VSdfEURctSzxiWSP9C6fWVE3Di48QfvoBoBbd7syIyiSg
MVCztrE8vwu56R6LoFv4
=CVs1
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--


--===============4173840690673437858==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4173840690673437858==--
