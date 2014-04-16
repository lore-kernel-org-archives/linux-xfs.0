Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 487207F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:38:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 327C930407B
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:38:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cshwrBqUPNSvWjhR for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:38:29 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WaDrk-0006Bs-EJ
	for xfs@oss.sgi.com; Wed, 16 Apr 2014 10:38:16 +1000
Date: Wed, 16 Apr 2014 10:38:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to cd444c6
Message-ID: <20140416003816.GA15995@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2138056241556358298=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2138056241556358298==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

The new head of the master branch is commit:

cd444c6 renameat2 syscall: turn EEXIST into ENOTEMPTY

New Commits:

Miklos Szeredi (1):
      [cd444c6] renameat2 syscall: turn EEXIST into ENOTEMPTY

Theodore Ts'o (1):
      [5fba951] generic: add renameat2 system call number for i386


Code Diffstat:

 src/renameat2.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)
--=20
Dave Chinner
david@fromorbit.com

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTTdD3AAoJEK3oKUf0dfodA9gP/iubBLoi2DR2k0R0Fj50CN//
xGWMlKSGhOdlqCX2RmbbzZicLxMQdLSI98pquP9WUr2XIg/FvG7DX2cQDrIhjxa1
1W+TvuQiyd8+lQc+zbPrVl4Txu3Exx7modBG9RDJGQMpYcE4VSj0MSQB8rV1ix2W
CdrE11YufKkp1Pf8BriONIIGuY8l3swV4VQtV3HBPrnS0atrLKAf9LqT3lR2BnrQ
QIgmf2etG3TpjHOw6tSWtjJVL2HylWeyjnmaRDBJblMQ7OZRWQq6PEJMxAMmWJYO
wjkWT+WwE/oKe+WmlGw41u7b6JGLniNHqjic85Y8x2eeJGvfVMKsizpTXRos4Vx0
VJ8068avSQWN5/YVMhMJfoFa3aHIPONmxzJEdAHiyNS8+C3UaUyBMGY7+/oNmXc6
O4SNUcC9MgME5A74sRW4lkEfI5m8P2SPOMhwqiTc/RvBBX4tXxYB66+Zfpc1M131
VLG3DGjfApD2x8Dsc2OaBSU0sE2ZrIpitk7vz00hug+K4dyKFJ6hFcosOwiboSIj
l2eu7YyoS4fPp+4tJNpuEMp6riProNQ2JCnYi9Br9OXDeJV0+Hg1rlwFaFsh22ya
Nr547DUNiqantH5bFaQ57VrDQHUqOi4bGdJZBXW0uqCKu6CsPn5MYPhqPbhop981
L2EipBaO65fL5vLUJmZG
=gQIp
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--


--===============2138056241556358298==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2138056241556358298==--
