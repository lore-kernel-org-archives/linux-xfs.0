Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOG3l3d147476 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 10:03:48 -0600
Received: from cuzco.net-track.ch (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id E10C618D701C
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 08:04:11 -0800 (PST)
Received: from cuzco.net-track.ch (cuzco.net-track.ch [194.153.188.156]) by
	cuda.sgi.com with SMTP id IdM0BfeDQcSMeMex for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 08:04:11 -0800 (PST)
Date: Tue, 24 Nov 2009 17:03:51 +0100
From: Oliver Hitz <oliver@net-track.ch>
Subject: Off-line xfsrestore to avoid level 0 dumps
Message-ID: <20091124160351.GK29999@net-track.ch>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7058789881308544229=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7058789881308544229==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/ZYM6PqDyfNytx60"
Content-Disposition: inline


--/ZYM6PqDyfNytx60
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

We have to back up several fairly large XFS filesystem (multiple TB)
using xfsdump to a remote server (no tape drive involved, all on disks).

In order to avoid doing level 0 dumps every now and then, we came up
with the idea of constructing level 0 dumps off-line:

- xfsrestore of the latest level 0 dump to a temporary location
- xfsrestore of the latest level 1 dump
- xfsdump -l 0 of this location to create the new level 0 dump

By setting the time of the next level 1 dump (using the -t switch), we
can then force the dump time to that of our artificial level 0 dump.

Has anybody done this before? Can anybody see any issues with this
approach? We wouldn't want to end up with a solution where our
artificial level 0 dump drifts off from the real content of the
filesystem.

Thanks in advance for any feedback

Oliver

--/ZYM6PqDyfNytx60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksMA/kACgkQ4hxFYtsxPohUsQCgmO8mjWgW70A4pDUbLp0fmPMY
euEAoODHpiiaN4D8RZ6siSMsg0+icrt9
=GSGL
-----END PGP SIGNATURE-----

--/ZYM6PqDyfNytx60--


--===============7058789881308544229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7058789881308544229==--
