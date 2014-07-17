Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 450C67F86
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 18:10:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05F148F8039
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 16:10:54 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bw7RRMydBI68mySY for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 16:10:52 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1X7uoc-00042s-G1
	for xfs@oss.sgi.com; Fri, 18 Jul 2014 09:10:18 +1000
Date: Fri, 18 Jul 2014 09:10:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsdump v3.1.4 released
Message-ID: <20140717231018.GH4453@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9078954701933117069=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============9078954701933117069==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

xfsdump v3.1.4 has just been released. This is a bug fix release
that contains fixes accumulated over the past year since the last
release.

The source code can be accessed via git using this URL:

        git://oss.sgi.com/xfs/cmds/xfsdump.git

A signed gzipped-tar archive of the source code is available here:

        ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.4.tar.gz
        ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.1.4.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

A summary of the changes during development of this release (taken
=66rom doc/CHANGES) is as follows:

	- fix partial region segfault and debug code (Eric Sandeen)
	- dump wholly sparse files correctly (Eric Sandeen)
	- restore capabilities correctly
	- memory leak fixes (Boris Ranto)
	- sys_getdents modernisation (Kyle McMartin)
	- Error message fixes (Iustin Pop)
	- Updated polish translation (Jakub Bogusz)
	- debian package build updates (Nathan Scott)

--=20
Dave Chinner
david@fromorbit.com

--H+4ONPRPur6+Ovig
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTyFfZAAoJEK3oKUf0dfod1vwP/3Gfb3oUyCljMSTeFrRacJ5b
r40+Z8n8sNGIJbFVspbQYsTPJAIgh50wQZtcDGo4Y9iRPYWTQmukJ0GHajh6ncmz
AAk31dKZVpgasfHNe/wDRhOtaA9Zh7K3yafs59Ie9wOuOWs3uI7+len9J+79PPrF
a3UqjQ0S9I10J1gF5KGsQJCA5zvSoQYuFSyKmWxbHqDCQlXbo1sSFkxHTfNoAaWO
/jCXQBrYTpVNpG9r/s7XQ0MDx7TAecGu2g6V3nX9Fk3Gpz1zlIk4NFtLWcCRnGhr
bgSYUwLhXW/UPSoz/qRk/4xZAWsrZtKxR0K+hpTfD4Ot743ArHHicRlLR/4axek9
JvN76zWonIqJiEJLxRHer45RXtZUWi66SLmv/GiwO/rfxMuiatkFdSU2eP/JknbY
vbPtOlXMEqhVu6Tm9VhzNoaOMf1AQ8m7moUvMwhfsJWIJFiaQZEmWs4EWR+9XmT8
1cEZqzDP1FmG5tE49gtzvEMzetwW0jXa4805U/Ni6qhvEb8DKXoE4F0ORmvA/ITi
DHcs3YUGjASF5rvrDdU14Q6KIQOHVxjTFbquGVPZybEgzVIb7UGLYgBLS/ee9Uis
er/XNmzzY55ExYTC55uKA4EVPkIIHFlDq/83Lga1FXhX9TWAEo3HzUljBle5XO1E
zVyuOp+0KQLDD9BOIIeM
=SDGv
-----END PGP SIGNATURE-----

--H+4ONPRPur6+Ovig--


--===============9078954701933117069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9078954701933117069==--
