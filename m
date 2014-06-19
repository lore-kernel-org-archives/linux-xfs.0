Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9440929DF8
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 17:08:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08E99AC002
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2014 15:07:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nzn2K8Ad1Ri8NFI4 for <xfs@oss.sgi.com>;
	Thu, 19 Jun 2014 15:07:54 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WxkUe-0004Aa-Bs
	for xfs@oss.sgi.com; Fri, 20 Jun 2014 08:07:40 +1000
Date: Fri, 20 Jun 2014 08:07:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to cf0cc34
Message-ID: <20140619220740.GU9508@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1572293968404086840=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1572293968404086840==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

Once I have the repair ACL fixes reviewed and pushed, I think we are
pretty much at the point where we have everything we need for a
3.2.1 release candidate. Is there anything else that I've missed
that we need for 3.2.1?

-Dave.

The new head of the master branch is commit:

cf0cc34 mkfs: add "-m" options to the man page

New Commits:

Dave Chinner (1):
      [cf0cc34] mkfs: add "-m" options to the man page

Eric Sandeen (9):
      [5a7d593] xfsprogs: try to handle mkfs of a file on 4k sector device
      [3800a2a] mkfs.xfs: don't call blkid_get_topology on existing regular=
 files
      [eef20df] xfs_fsr: ensure the line we read from leftofffile is null t=
erminated
      [671632c] xfs_fsr: create a cleanup/return target in packfile()
      [3d303ba] xfs_fsr: test for more potential failures in packfile()
      [53ab4c4] xfsprogs: add mount options to xfs.5 manpage
      [e024ab5] xfsprogs: indicate default mount options in xfs.5 manpage
      [35f2764] libxfs: don't send null bp to xfs_trans_brelse()
      [75c270a] libxfs: fix crc field handling in xfs_sb_to/from_disk

Jakub Bogusz (1):
      [7a92e85] xfsprogs: update polish translation

Junxiao Bi (1):
      [c667d79] xfs_copy: fix data corruption of target


Code Diffstat:

 copy/xfs_copy.c       |     6 +-
 fsr/xfs_fsr.c         |   115 +-
 libxfs/linux.c        |    16 +-
 libxfs/xfs_da_btree.c |     3 +-
 libxfs/xfs_sb.c       |     5 +
 man/man5/xfs.5        |   207 +-
 man/man8/mkfs.xfs.8   |    45 +
 mkfs/xfs_mkfs.c       |    27 +-
 po/pl.po              | 19073 ++++++++++++++++++++++++--------------------=
----
 9 files changed, 9824 insertions(+), 9673 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTo18rAAoJEK3oKUf0dfod2MkP/iepXqtCGPB8prLlqsIsddCO
+IdArapna/Exsskkfp3XG+hiH9CN3NaCimv/EEVE/zv1zOKJ3JWX3cq9xHWIrC2B
fxp6j8Rbgat8UgpceH2DyJVc5dRoZAZ6zj7pkV6wxMwp19YbNm/JQ2qhW+JUVZzt
ktrfh/K2io7Cd6dFvPRwYOIX0ll1/Nu6XDwgTw8wWnhjbjAFwzphlb+RXH6n2dEs
xgCuAuTMDuyeUBAOZ16qL8+uA00ljoOPGQQAwkgk4lNhg+MrlRdJh78Fly0WaGI4
ZsAWBiHGdEaRzZNCByPz+no4o+2B1i7aXq6+3RF1JDOB8qBVK/w54RHJQskDLSGV
/pxToV144r5Vi/AZkiKVMjp2kZu6jaKWyZR47XBihtyIwElD6I+O0B37rrjkbOz0
VH+9xhEebtspT1E3IEfa+ac3DMJwFOytxklJ73a5/sTTpiwCInjQl6zKzwZ3kJuz
u2iH7AejleLo9W4VEyWOaph1mRYeJX323D+TCZz947DavyjAw+cTSnOrCWroK5Dl
lFkxkMZbXMYgR+kyDHAWNqLX5F9/KhARv00BbuaGAaTqp2TeFUvSs3lOnZRygfwS
5ktWLBMQwMgTpJ1MYHsT/qMJ9unzE6LTiBpY4MKc1SP9K/SYGWclLPah79JsCfF8
gCH6OQDGlTn7mCgbSWHA
=L6j/
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--


--===============1572293968404086840==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1572293968404086840==--
