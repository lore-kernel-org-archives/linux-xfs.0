Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0C7107F66
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 23:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 883E6AC003
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 21:47:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Hn7Ux2v5OevqEKR0 for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 21:47:50 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1X6ueZ-0001es-Bj
	for xfs@oss.sgi.com; Tue, 15 Jul 2014 14:47:47 +1000
Date: Tue, 15 Jul 2014 14:47:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs v3.2.1 released
Message-ID: <20140715044747.GJ22339@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6895472508873000252=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============6895472508873000252==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

xfsprogs v3.2.1 has just been released. This is mainly a bug fix
release, primary to fix several bugs that prevented xfs_repair from
correctly repairing broken filesystems in a single pass. There are
many other fixes and updates, as well as support for the shiny new
on-disk free inode btree index feature.

The source code can be accessed via git using this URL:

        git://oss.sgi.com/xfs/cmds/xfsprogs.git

A signed gzipped-tar archive of the source code is available here:

        ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.1.tar.gz
        ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.1.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

A summary of the changes during development of this release (taken
=66rom doc/CHANGES) is as follows:

        - Added support for new on-disk free inode btree (Brian Foster)
        - libxfs inode use-after free fixes (Mark Tinguely)
        - xfs_copy threading cleanups (Junxiao Bi)
        - xfs_check has been removed
        - C++ header compiler fixes (Roger Willcocks)
        - xfs_repair prefetch fixes (Eric Sandeen)
        - xfs_repair directory block CRC detection fixes (Jan Kara)
        - xfs_repair directory rebuild fixes
        - libxfs buffer error handling fixes
        - xfs_repair quota inode handling fixes
        - removed incorrect asserts from phase 2 of xfs_repair
        - updated Polish translations (Jakub Bogusz)
        - xfs_mkfs 4k sector device fixes (Eric Sandeen)
        - xfs_fsr cleanups nd fixes (Eric Sandeen)
        - mount options described in xfs(5) man page (Eric Sandeen)
--=20
Dave Chinner
david@fromorbit.com

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxLJyAAoJEK3oKUf0dfodKwYP/jmWpl65jFMHNIr4RAmBsGgB
ehQrpjciEgTk9GWkbxCREOuL4e6Tarv7CdCMqxketBgIb9PK/diwl1ym5udzxfEx
btwU+6wdC03jiz4yjgNPkJF1DLBopUJcOo/agWldk3l8BhouuQOfEvpWCNjWtLL0
PNqxTSWl+3svHIKHqS1fr8QPe4BJ35ToxQMiG7aYXSl94kIwREfNf43+AIXVZ64r
2CWDvqOPf/COossRQ+RrxPp47lFsNo7Xcmotoh43sJn03+fhNK0dPE9eNjRjou15
OPeU6V0gP4r/cVRm9OEYMaU/ZOldtJHJfvyvTtuTPQy+7+PQ5nvOFHBdY1SsXK1u
ry25V/DKP2MqONwI3lVuec5B4MMpFu2P8gzEOighcWzF+TlTdv/eP8XdiTJUKKsI
ySIGbBhKh/eqWpxdImUg2hb/C/oRBzvsw1LnvUpp1IvC4+kpHQoBpyfDdYzT7uPT
6fl9peMbJRIHA+zNFPoEisTuCRFShRUVtBbwKbvNKphJXCYSQNx+V72yqII5ffRg
03DfbaGf++eVnDM1BOHjex+hHcMbOattsMvTWjhPVm1iw6Lbs1rGAGAWWKUWw742
1VWIu83C7G2N9dWPpZSadqYtKehVqPaYwJ1XC3XuzocVwXTEeL0ystZdhHhH6qIl
lZ91kSU3SdPGOjKCBeAK
=eRwP
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--


--===============6895472508873000252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6895472508873000252==--
