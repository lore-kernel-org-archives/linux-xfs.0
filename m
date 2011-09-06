Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86BIINh073941 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 06:18:18 -0500
Received: from mailhost.ldc.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EDFE1E8534E
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 04:18:15 -0700 (PDT)
Received: from mailhost.ldc.fr (mailhost.ldc.fr [86.65.205.244]) by
	cuda.sgi.com with ESMTP id 4OHpUtSUqlZRLQa6 for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2011 04:18:15 -0700 (PDT)
Received: from localhost (unknown [192.168.2.128])
	by mailback.ldc.fr (Postfix::smtpd) with ESMTP id C760424B613
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 13:18:14 +0200 (CEST)
Received: from mailhost.ldc.fr ([127.0.0.1])
	by localhost (mailhost.ldc.fr [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id FjRmIikdome1 for <xfs@oss.sgi.com>;
	Tue,  6 Sep 2011 13:18:14 +0200 (CEST)
Received: from lnx054009.grpldc.com (domino3101.grpldc.com [192.168.11.112])
	by mailhost.ldc.fr (Postfix::smtpd) with ESMTP id 71D0024B5F9
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 13:18:14 +0200 (CEST)
Received: from domino3101.grpldc.com (domino3101 [172.20.3.111])
	by lnx054009.grpldc.com (Postfix) with ESMTP id 6C34233B79
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 13:18:14 +0200 (CEST)
Subject: XFS frozen on one directory
Message-ID: <OF62081B23.59A4BF92-ONC1257903.003AB613-C1257903.003D9151@grpldc.com>
From: Boris.SANEGRE@agis-sa.fr
Date: Tue, 6 Sep 2011 13:12:28 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hi,

Since last week, I'm trying to use XFS Project Quota feature. My server has
crashed two times.

I'have the same server using XFS with exactly same
configuration/version/hardware without project quota enabled. This server
run nice since 1 month

When my server crash, one directory becomes unabled. I can't acces to it. I
can't find any error. No error reporting in /var/log/syslog, /var/log/dmesg
or /var/log/kern.log
I find the process with command lsof, but can't kill it.
All other directories are avaibled


Example: if directory /a/b/c freeze:

	Clic with Samba on directoy failed (waitting long time, next Windows
says server doesn't reply only on this directory)
	ls /a/b/c  --> Ok
	vdir /a/b/c --> failed (frozen. CTRL + C don't work. Not possible to
kill process "vdir")
	getfacl /a/b/c -->  failed (frozen. CTRL + C don't work. Not possible
to kill process "getfacl")
	ls /a/b/c/d --> Ok (I can read subdir with this command)

	iotop --> Traffic on my disk not busy

	htop --> CPU or RAM not busy

	ps aux | grep /a/b/c --> process flag "D" (so can't be killed -->
kill -9 no =3D effect)


Information about my server:
	uname -a: Linux lnx043002 2.6.26-2-amd64 #1 SMP Tue Jan 25 05:59:43
UTC 2011 x86_64 GNU/Linux

	OS: Debian 5.0.8

	dpkg -l | grep samba
		ii  libcrypt-smbhash-perl                0.12-2
generate LM/NT hash of a password for samba
		ii  samba                                2:3.5.6~dfsg-3~bpo50+1
SMB/CIFS file, print, and login server for Unix
		ii  samba-common                         2:3.5.6~dfsg-3~bpo50+1
common files used by both the Samba server and client
		ii  samba-common-bin                     2:3.5.6~dfsg-3~bpo50+1
common files used by both the Samba server and client

	dpkg -l | grep xfs
		ii  x11-xfs-utils                        7.3+1
X font server utilities
		ii  xfsdump                              2.2.48-1
Administrative utilities for the XFS filesystem
		ii  xfsprogs                             2.9.8-1lenny1
Utilities for managing the XFS filesystem


	dpkg -l | grep lvm
		ii  lvm2                                 2.02.39-8
The Linux Logical Volume Manager


When server freeze a directory, I can't reboot server. I must reboot
machine on button.

Any help to find "why" and "how to resolve" will be very nice.
Tell me what more informations you want.
Next crash I could take screenshot of commands

Best regard.
Boris San=E8gre.





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
