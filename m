Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Nov 2006 17:51:10 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAD1p1aG012469
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 17:51:02 -0800
Received: from mailgate.mysql.com (mailgate-out2.mysql.com [213.136.52.68])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64256D1D00E0
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 17:33:39 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mailgate.mysql.com (8.13.4/8.13.4) with ESMTP id kAD1Xbtd004709
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 02:33:37 +0100
Received: from mail.mysql.com ([10.222.1.99])
 by localhost (mailgate.mysql.com [10.222.1.98]) (amavisd-new, port 10026)
 with LMTP id 22554-06 for <xfs@oss.sgi.com>;
 Mon, 13 Nov 2006 02:33:37 +0100 (CET)
Received: from [192.168.1.100] (ppp163-199.static.internode.on.net [150.101.163.199])
	(authenticated bits=0)
	by mail.mysql.com (8.13.3/8.13.3) with ESMTP id kAD1XNiT032097
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 02:33:31 +0100
Subject: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
From: Stewart Smith <stewart@mysql.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yf2iUCshWZ67mA/P20R0"
Date: Mon, 13 Nov 2006 12:33:22 +1100
Message-Id: <1163381602.11914.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-yf2iUCshWZ67mA/P20R0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I recently (finally) wrote my patch to use the xfsctl to get better
allocation for NDB disk data files (datafiles and undofiles).
patch at:
http://lists.mysql.com/commits/15088

This actually ends up giving us a rather nice speed boost in some of the
test suite runs.

The problem is:
- two cluster nodes on 1 host (in the case of the mysql-test-run script)
- each node has a complete copy of the database
- ALTER TABLESPACE ADD DATAFILE / ALTER LOGFILEGROUP ADD UNDOFILE
creates files on *both* nodes. We want to zero these out.
- files are opened with O_SYNC (IIRC)

The patch I committed uses XFS_IOC_RESVSP64 to allocate (unwritten)
extents and then posix_fallocate to zero out the file (the glibc
implementation of this call just writes zeros out).

Now, ideally it would be beneficial (and probably faster) to have XFS do
this in kernel. Asynchronously would be pretty cool too.. but hey :)

The reason we don't want unwritten extents is that NDB has some realtime
properties, and futzing about with extents and the like in the FS during
transactions isn't such a good idea.

So, this would lead me to try XFS_IOC_ALLOCSP64 - which doesn't have the
"unwritten extents" warning that RESVSP64 does. However, with the two
processes writing the files out, I get heavy fragmentation. Even with a
RESVSP followed by ALLOCSP I get the same result.

So it seems that ALLOCSP re-allocates extents (even if it doesn't have
to) and really doesn't give you much (didn't do too much timing to see
if it was any quicker).

Is this expected behaviour? (it wasn't for me)
--=20
Stewart Smith, Software Engineer
MySQL AB, www.mysql.com
Office: +14082136540 Ext: 6616
VoIP: 6616@sip.us.mysql.com
Mobile: +61 4 3 8844 332

Jumpstart your cluster:
http://www.mysql.com/consulting/packaged/cluster.html

--=-yf2iUCshWZ67mA/P20R0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFV8tiKglWCUL+FDoRAl49AJ9H5/9h+KJmLLMeY0HBmxH89cRb5gCgo2ej
IK6ccyggyyTBs7vVBroRbFo=
=UFYp
-----END PGP SIGNATURE-----

--=-yf2iUCshWZ67mA/P20R0--
