Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF1C77F55
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 19:05:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A11E930404E
	for <xfs@oss.sgi.com>; Thu,  1 May 2014 17:05:17 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mpOLGIALmq3fZOgf for <xfs@oss.sgi.com>;
	Thu, 01 May 2014 17:05:15 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Wg0yS-0006sc-TI
	for xfs@oss.sgi.com; Fri, 02 May 2014 10:05:08 +1000
Date: Fri, 2 May 2014 10:05:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: 3.2.0-rc2 release tagged
Message-ID: <20140502000508.GA26353@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2447967208803743042=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2447967208803743042==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

67fcc94 xfsprogs: v3.2.0-rc2 release

This commit has been tagged with v3.2.0-rc2. I'd like everyone who
can test this to test it, as all the issues that needed to be solved
before a release coul dbe made have now been addressed. If there are
no new regressions or critical issues reported in the next week or
so, I will make an official 3.2.0 release. So, please test. :)

-Dave.

New Commits:

Dave Chinner (10):
      [b511ff4] db: don't claim unchecked CRCs are correct
      [9ba69ce] db: verify buffer on type change
      [adbb357] repair: ensure prefetched buffers have CRCs validated
      [8e7e14b] repair: detect and correct CRC errors in directory blocks
      [8f657d7] repair: detect CRC errors in AG headers
      [a76a5a7] repair: report AG btree verifier errors
      [641e65b] repair: remove more dirv1 leftovers
      [7cb3f7f] repair: handle remote symlink CRC errors
      [3a1d34e] repair: detect and handle attribute tree CRC errors
      [67fcc94] xfsprogs: v3.2.0-rc2 release

Eric Sandeen (2):
      [847bbbe] xfs_logprint: Fix error handling in xlog_print_trans_efi
      [aabc02b] mkfs.xfs: prevent close(-1) on protofile error path


Code Diffstat:

 VERSION              |   2 +-
 db/fprint.c          |  15 ++-
 db/io.c              |  26 ++++++
 db/io.h              |  13 ++-
 db/type.c            |   9 +-
 doc/CHANGES          |   5 +
 include/libxfs.h     |   3 +
 libxfs/rdwr.c        |  58 ++++++++----
 logprint/log_misc.c  |   5 +-
 mkfs/proto.c         |   3 +-
 repair/attr_repair.c |  45 +++++++--
 repair/dinode.c      | 251 +++--------------------------------------------=
----
 repair/dinode.h      |   6 --
 repair/phase6.c      |  94 +++++++++++++++----
 repair/prefetch.c    |   7 +-
 repair/scan.c        | 108 +++++++++++++++-------
 16 files changed, 311 insertions(+), 339 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTYuE0AAoJEK3oKUf0dfod014P/1VmVxBIAODq2r6k+B14R+6r
Hm5YNK1yLJPtUIo48wylVukxAoiFndzbuuzrZY/jYvWGhpocUeYS1hwhhD+HCPWr
ybYlNL9fIF/fZT632700ZTgEZwFrqT+Ba62GdVEKSzGFURKmsJ+uc+W3cjrTBSZx
bMk+r48Qmd0oyJQxmlTAUuLKleSnaV6S+tPY4jr9P/pUKqmYF4EoGhj0wIWDoXyq
MIBYkBTyvOafRciUxgz3vUkDKWO6GXdng/3jbVl7O/qKuE0dofoqGdEa5AqtTeoW
ktryd5sVEBdpy89JbGxZW7WTYmJ7plV0GpRRqSjJ6dptoGnDSUSi54Uz+WrC0ZzU
jHGyM2AERXN8ImqPTn2vTorS1htOI/qUAroS/wqTGqvU7EZXYlL7HRNNsKNrYWuy
sD2nGssJcp3dm86ewigBznfzsLryK9FJuwzTTz0/6TTftAhHyvbbmMod1areWmww
csyUBJsVLdMLblcUnv7P3i7Kt6drjpbPwtALVt1oLlzlk9WfdUJMRkDvWAZ3vEFa
D9tsTV9pkw7xwZHdQjkcviK1nrcN1xoafacBLObWnvRXpiv0xMmbLE84evSMOcza
QHmg+Qptx4meq8gsHiKhQEuy/+4FLDWNZQ7rRcxUtKCJyI+m8+yhwht5RqxbGYeS
mqe8ivAN4reUcPzvIDKe
=9Drr
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--


--===============2447967208803743042==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2447967208803743042==--
