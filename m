Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 569647F37
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 20:42:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40E458F8039
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 18:42:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Bp3uy8tH0OSBB1YP for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 18:42:50 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1X7xCB-0004QZ-Mu
	for xfs@oss.sgi.com; Fri, 18 Jul 2014 11:42:47 +1000
Date: Fri, 18 Jul 2014 11:42:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUCE] xfsprogs: master branch updated to ba24eb7
Message-ID: <20140718014247.GJ4453@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2594736224434281041=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2594736224434281041==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

ba24eb7 logprint: Fix printing of AGF and AGI buffers

New Commits:

Eric Sandeen (2):
      [6bf4721] repair: copy, don't clear, stripe geometry in backup SB
      [ed350fc] libxcmd: make all comparisons using realpath'd paths

Jan Kara (1):
      [ba24eb7] logprint: Fix printing of AGF and AGI buffers

Jie Liu (1):
      [a14d409] quota: fix NULL pointer dereference in report_f

Nathan Scott (2):
      [1a05f91] xfsprogs: add a watch file into the debian packaging
      [b6ad854] xfsprogs: update debian packaging for next release


Code Diffstat:

 debian/Makefile     |  2 +-
 debian/changelog    |  7 +++++++
 debian/watch        |  3 +++
 libxcmd/paths.c     | 42 ++++++++++++++++++++++++++----------------
 logprint/log_misc.c | 20 ++++++++++++++++++--
 quota/report.c      |  2 +-
 repair/globals.h    |  2 +-
 repair/sb.c         |  2 +-
 repair/xfs_repair.c | 10 ++++------
 9 files changed, 62 insertions(+), 28 deletions(-)
 create mode 100644 debian/watch
--=20
Dave Chinner
david@fromorbit.com

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTyHuWAAoJEK3oKUf0dfodhnkP/jS1ETDgYYyqqI4XuVBxdl2G
9BX9W7UAO037WJUpGMAK0RLkyvL2T6IgxTIHKC35pZmfWaAzksYeZaNoINin/ST6
OPsQqpecr4WakKOd2RJdNs2oSUeaiP3zeZTuTmyBS4Xlx4p0Mep2kt+V2SPSsH7g
IpdhMa4ekQ5AFB86zoxtKADKcNqQCiHpD/EsDAqv8wKyBh/5O1sW7jJUseSE8Yew
gqNbfDZJfPanDKApO2H12gRv4YtBBc+5tqBK/SbVGfrM0sonWUhrXwkMdTFpWhck
kX9v3BP9mJDhDK/fiTAJteyWsAxclqe2ONKz5Bvq5vE9FwPDYOr9ONxak8FL0Zwd
THdG5XWM60snd0epG2j27dgwHKwxXWc893ctKSyNiBXxrJTgFpMCgGiDgl1BfCtg
7G1CdF5n0hIA7dPiTKrzTLcFDpYlPjjU0i15kaRgOf6+9sKtlzWvf4vgsAiHuTFK
G8ZXUX7N9FGmAuD01IgAqJvbNazCNAr/hV7l/k39jF5GJYmfguWQIM/194G6zmyp
IqN6ecmzFKMBduIWTZV1yFYF0q9lOMSsjQ1oLVElhAGcekVhOmVyFaVFP3PMhvH/
RmFnZvlQKFBUgR35oT3Y5VpWv614G26qsNladTs4dxu3sUJs5fKGCzKD7O3eL0Rl
iUTEYizavGC/zuIU3joG
=ANdA
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--


--===============2594736224434281041==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2594736224434281041==--
