Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1O8N0wk005666 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 02:23:00 -0600
Received: from mail.4lin.net (mail.4lin.net [46.4.210.97]) by cuda.sgi.com
	with ESMTP id jRJEXE1h5sDEZBbs for <xfs@oss.sgi.com>;
	Fri, 24 Feb 2012 00:22:59 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mail.4lin.net (Postfix) with ESMTP id E265290C1
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 09:25:37 +0100 (CET)
Received: from mail.4lin.net ([127.0.0.1])
	by localhost (mail.4lin.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yW-epQ1CGWSp for <xfs@oss.sgi.com>;
	Fri, 24 Feb 2012 09:25:29 +0100 (CET)
Received: from pcdenny.rbg.informatik.tu-darmstadt.de
	(pcdenny.rbg.informatik.tu-darmstadt.de [130.83.160.152])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.4lin.net (Postfix) with ESMTPSA id E88DC55AA
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 09:25:28 +0100 (CET)
From: Denny Schierz <linuxmail@4lin.net>
Subject: Save options for XFS over ISCSI ~ 17TB (for backup)
Date: Fri, 24 Feb 2012 09:22:48 +0100
Message-Id: <A527AC3D-1CBC-48F6-9570-83E4C1A0D794@4lin.net>
Mime-Version: 1.0 (Apple Message framework v1257)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1934143535762144756=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1934143535762144756==
Content-Type: multipart/signed; boundary="Apple-Mail=_921E8ED2-FFCA-45B0-BE17-00511F036E05"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_921E8ED2-FFCA-45B0-BE17-00511F036E05
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

hi,

I want to migrate away from Solaris with ZFS to Linux with XFS (BTRFS is =
to young) . At the moment, I have Solaris 10 with ISCSI initiator =
running and a zpool with a size round about ~17TB. The ISCSI target  is =
a Linux Debian with "tgt" Daemon and connected via SAS (LSI Logic / =
Symbios Logic SAS2008) to several LSI JBODS (630j).=20

Every jbod has 12 (2TB) disks and managed by mdadm as a RAID6 device and =
on top LVM. I have two ISCSI target servers (one for _cold_ standby) and =
all servers has  power connection via UPS and a second direct one.

As I sad, I want to get away from Solaris 10 and know I search for =
options to use XFS with save options, in case of emergency (poweroff =
etc.). We use the JBODS mostly for backups (bacula) so, =
performance/realtime isn't imported, since network is the limit.

Under ZFS I can make sure,  with zpool scrub (file system check), that =
all data are completely  written and consistence. But what is the best =
way under XFS? Should I remount XFS every month for a file system check =
(re/mount) ? What happens in the case, of ISCSI problems?

So, I need just a few suggestions :-)

cu denny=

--Apple-Mail=_921E8ED2-FFCA-45B0-BE17-00511F036E05
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)

iEYEARECAAYFAk9HSNgACgkQKlzhkqt9P+CUJwCfRHR/C9/VDk1w0QzQH9ACyyb6
jScAnjd+wjYOgk79ucti7XC9AHf1iJpo
=EbY7
-----END PGP SIGNATURE-----

--Apple-Mail=_921E8ED2-FFCA-45B0-BE17-00511F036E05--


--===============1934143535762144756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1934143535762144756==--
