Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD8A47F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 22:34:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47862AC003
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 20:34:09 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GqxVcvNd1YubfMi4 for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 20:34:07 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YQ7Bz-0002pZ-Vb
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 15:33:56 +1100
Date: Tue, 24 Feb 2015 15:33:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to bd76b93
Message-ID: <20150224043355.GZ4251@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7630601292238638513=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7630601292238638513==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Content-Disposition: inline


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated. With this update, I'll start the process of a
3.2.3 release - consider this update a 3.2.3-rc1 and I'll work
towards a full release over the next couple of weeks.

-Dave.

The new head of the master branch is commit:

bd76b93 mkfs: log stripe unit fails to influence default log size

New Commits:

Brian Foster (2):
      [39fe84a] metadump: include NULLFSINO check in inode copy code
      [0ab7cbc] metadump: check for non-zero inode alignment

Dave Chinner (1):
      [bd76b93] mkfs: log stripe unit fails to influence default log size

Namjae Jeon (1):
      [5c6afe9] xfsprog: xfsio: update xfs_io manpage for FALLOC_FL_INSERT_=
RANGE


Code Diffstat:

 db/metadump.c     | 3 ++-
 man/man8/xfs_io.8 | 5 +++++
 mkfs/xfs_mkfs.c   | 4 +++-
 3 files changed, 10 insertions(+), 2 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU6/8zAAoJEK3oKUf0dfod+BcQAMBuuYQw1uIRW+3+hFYYEcWd
1bihb4o/GNUg30LgRQOicKhSExHON1q+udDebCIwLwDykr3asD9cJCy0N1IUYmFq
tVjBCu9xM3RXxaV9VbqDp2YvvvT1SD/nWCL3HxE/fBQzz4bLSAdaTXkTwnEL/2Vz
+EVMh7gkiL4Ebqah6ZK+wx3rOcDah9lXEo4xoO77VVV78j/Kv4O8bXIQ4ccNzR7m
kR3S0nBMBus+zhOojZx7tEtgzSyUk+S1aPHPNtH0wISW9KYKGyhE5VpFZRuDz+MW
ZWiaOSlC4hQVydMSxt8ynIMKxQ9CfJHzRAHmXa0ONPdSsC9PO3KX/QURnqkmzras
Zb7gsuqhOOziwYYGSr0JbFhkCGhrEvRQ2AIIFV102eodXKTaSmBrtkLu49FGLXqd
33+uJZ5+xisNs/S6yz2j2j5ZNEFRV1HK00GHLOS1hznHkS2xH2ecOVAzvpcW/zJF
h8FHf/3ueCcax0iLUY4cM/+RHY7rzEBcb2jhP1Qc8czfOtot8OxDkTD3Rn4HkUQN
VwvjMDWSR0LyxMX5U5U8Z5Hf6Irq6CgZUUHYQSMQ66djwAR3dXZ0mHsghuMaTQry
qGOHlxffssInI2KlCRP8lpC3EI2GK+bGPw5909uMypnBLwkheVzK0j93ZfimVcyV
WeNhO29G1WkYD/RiF8Id
=ecl3
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--


--===============7630601292238638513==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7630601292238638513==--
