Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1B6F7F3F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 15:44:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E02C1304053
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2014 13:44:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	NDQVKaxXMHV1Alnt for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2014 13:44:37 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XwHih-0001Ad-68
	for xfs@oss.sgi.com; Thu, 04 Dec 2014 08:44:23 +1100
Date: Thu, 4 Dec 2014 08:44:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs v3.2.2 released
Message-ID: <20141203214423.GQ9561@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0249572128333492389=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0249572128333492389==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

xfsprogs v3.2.2 has just been released. This is mainly a bug fix
release, mostly for improvements to xfs_repair for handling badly
broken filesystems.  There are many other fixes and updates; more
details are below.

The source code can be accessed via git using this URL:

        git://oss.sgi.com/xfs/cmds/xfsprogs.git

and the release is tagged with the "v3.2.2" tag to make it easy to
check out the exact source used for the release.

A signed gzipped-tar archive of the source code is available here:

        ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.2.tar.gz
        ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.2.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

A summary of the changes during development of this release (taken
=66rom doc/CHANGES) is as follows:

        - Debian packaging updates (Nathan Scott)
        - xfs_repair, mkfs.xfs stripe geometry fixes (Eric Sandeen)
        - libxcmd path handling fixes (Eric Sandeen)
        - xfs_crash crash fix (Jie Liu)
        - xfs_logprint AGI/AGF handling improvements (Jan Kara)
        - libhandle support for symlinked /usr (Jan Tulak)
        - fix multiple Coverity and sparse reported issues (Eric Sandeen)
        - new mremap, sync, syncfs commands for xfs_io (Eric Sandeen)
        - man page updates (Eric Sandeen, Mark Tinguely)
        - xfs_repair sets ftype in lost+found dirents (Jan Kara)
        - xfs_repair handles bad inodes better (Eric Sandeen)
        - xfs_repair freelist rebuild improvements
        - xfs_repair finobt crash fixes (Brian Foster)
        - xfs_copy handles 4k sector devices better (Eric Sandeen)

--=20
Dave Chinner
david@fromorbit.com

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUf4Q2AAoJEK3oKUf0dfodD78QAKYpDfTKD053stFo86pfRUDk
U7cLoigXHtF6PdC26r39OBGpn5tNjlfmYsJMMmCKFUhpqAvlvaxhjtfLdpcxIhSd
uF2b3/65X/KYA/00qAKSewlRFT+eynk1nXU7lU5YtyhCuCJp8nRuMlRyB1sBBIpz
pwlpopq+3ytUgLf2ZLTJTVfy5bKaYhjRg8tztzBOzlEf1jUE6RYFeJ8fZPkRCvhq
WklSMZ0nCmcYrblHTW1OKXY7dJjdjhrRgXIM/kmL7komFiGYUE+29l96cSFyJs+C
qPJsi7j66PW4+U8mEJih2YYS1hBoEOPRMo/f8rxsAqCLh9RVZ+LQb9MykbH8gMKT
txwKoePiJzehGmYmpcJB9CWtvwS8/TLlzbSJ4OkC/eKapEEIoDK7E3f/vzL6hhUt
PsTzDRlR/PYh6B4ffrG9SfGKxF9/W4rTzDQSN8UtCqLlUJiMXFDQ7vcWBqqWHwCc
sPTZaucPO0AVmLXfhIwmZiTfX8elYpqa91dIlscyU+3GUS1KZ3oAIX2dxEVu6Cmg
Aq6RRSRgIKnAqIJo0jblJKl/I3D5Td0THp6ndzI2coM5+tKlya1nm0nNq1xey8JH
BbcTJOcev1nf+fWpUausJ9f85rhVmj7dRGnuqIx44kktWmrttcTclesSZpARGHGf
iW0iRSbauU0Nj1S03Lt4
=/0JD
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--


--===============0249572128333492389==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0249572128333492389==--
