Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:55151 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751230AbdCQTz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 15:55:27 -0400
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#854961: marked as done (xfslibs-dev won't install in Docker
 image (where /lib -> /usr/lib))
Message-ID: <handler.854961.D766811.148978029129803.ackdone@bugs.debian.org>
References: <E1coxuK-000ALN-Uw@fasolo.debian.org>
 <148691383691.1180.7344036562989980417.reportbug@9c82cf89c040>
Date: Fri, 17 Mar 2017 19:54:04 +0000
Content-Type: multipart/mixed; boundary="----------=_1489780444-30420-2"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Biebl <biebl@debian.org>

This is a multi-part message in MIME format...

------------=_1489780444-30420-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Fri, 17 Mar 2017 19:51:28 +0000
with message-id <E1coxuK-000ALN-Uw@fasolo.debian.org>
and subject line Bug#766811: fixed in xfsprogs 4.9.0+nmu1
has caused the Debian Bug report #766811,
regarding xfslibs-dev won't install in Docker image (where /lib -> /usr/lib)
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
766811: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D766811
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1489780444-30420-2
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 12 Feb 2017 15:37:23 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=4.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FOURLA,FREEMAIL_FROM,HAS_PACKAGE,HELO_MISC_IP,
	NML_ADSP_CUSTOM_MED,RDNS_NONE,SPF_SOFTFAIL,WORD_WITHOUT_VOWELS,
	XMAILER_REPORTBUG,X_DEBBUGS_CC autolearn=ham autolearn_force=no
	version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 60; hammy, 150; neutral, 182; spammy,
	0. spammytokens: hammytokens:0.000-+--H*M:reportbug, 0.000-+--H*MI:reportbug,
	0.000-+--H*x:reportbug, 0.000-+--H*UA:reportbug, 0.000-+--Subprocess
Return-path: <stevie.trujillo@gmail.com>
Received: from [91.189.182.65] (helo=[172.17.0.2])
	by buxtehude.debian.org with esmtp (Exim 4.84_2)
	(envelope-from <stevie.trujillo@gmail.com>)
	id 1ccwDL-0005ah-Gi
	for submit@bugs.debian.org; Sun, 12 Feb 2017 15:37:23 +0000
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfslibs-dev won't install in Docker image (where /lib -> /usr/lib)
Message-ID: <148691383691.1180.7344036562989980417.reportbug@9c82cf89c040>
X-Mailer: reportbug 7.1.4
Date: Sun, 12 Feb 2017 15:37:16 +0000
X-Debbugs-Cc: stevie.trujillo@gmail.com
Delivered-To: submit@bugs.debian.org

Package: xfslibs-dev
Version: 4.9.0
Severity: important

Dear Maintainer,

I was trying to rebuild qemu, which somehow pulls into xfslibs-dev.  To
avoid cluttering my system I tried to build qemu inside Docker, with the
debian:stretch image. The installation fails with the error below.
Before (and after) running apt-get there is no libhandle.a in /lib or
/usr/lib.


# apt-get install xfslibs-dev
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  xfslibs-dev
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 58.3 kB of archives.
After this operation, 243 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian stretch/main amd64 xfslibs-dev amd64 4.9.0 [58.3 kB]
Fetched 58.3 kB in 0s (490 kB/s)
debconf: delaying package configuration, since apt-utils is not installed
(Reading database ... 28662 files and directories currently installed.)
Preparing to unpack .../xfslibs-dev_4.9.0_amd64.deb ...
Unpacking xfslibs-dev (4.9.0) ...
dpkg: error processing archive /var/cache/apt/archives/xfslibs-dev_4.9.0_amd64.deb (--unpack):
 unable to install new version of '/lib/libhandle.a': No such file or directory
Errors were encountered while processing:
 /var/cache/apt/archives/xfslibs-dev_4.9.0_amd64.deb
E: Sub-process /usr/bin/dpkg returned an error code (1)


On my host system (also running stretch) xfslibs-dev installs fine.  I
tried to figure out what's different between the two environments, and I
found that the Docker image had /lib symlinked to /usr/lib, which my host
system had not.

https://packages.debian.org/stretch/amd64/xfslibs-dev/filelist shows
that the package tries to install both /lib/libhandle.a and
/usr/lib/libhandle.a . I speculate that this might confuse dpkg, but I
don't know how to test if this is the cause.

I tried running apt-get in strace, and found this fragment that I believe confirms my suspicion.
Because /lib -> /usr/lib, /lib/libhandle.a.dpkg-new will be removed by
the rename("/usr/lib/libhandle.a.dpkg-new", "/usr/lib/libhandle.a")
call.

rename("/usr/include/xfs/handle.h.dpkg-new", "/usr/include/xfs/handle.h") = 0
rename("/usr/include/xfs/jdm.h.dpkg-new", "/usr/include/xfs/jdm.h") = 0
rename("/usr/include/xfs/linux.h.dpkg-new", "/usr/include/xfs/linux.h") = 0
rename("/usr/include/xfs/xfs.h.dpkg-new", "/usr/include/xfs/xfs.h") = 0
rename("/usr/include/xfs/xfs_arch.h.dpkg-new", "/usr/include/xfs/xfs_arch.h") = 0
rename("/usr/include/xfs/xfs_da_format.h.dpkg-new", "/usr/include/xfs/xfs_da_format.h") = 0
rename("/usr/include/xfs/xfs_format.h.dpkg-new", "/usr/include/xfs/xfs_format.h") = 0
rename("/usr/include/xfs/xfs_fs.h.dpkg-new", "/usr/include/xfs/xfs_fs.h") = 0
rename("/usr/include/xfs/xfs_log_format.h.dpkg-new", "/usr/include/xfs/xfs_log_format.h") = 0
rename("/usr/include/xfs/xfs_types.h.dpkg-new", "/usr/include/xfs/xfs_types.h") = 0
rename("/usr/include/xfs/xqm.h.dpkg-new", "/usr/include/xfs/xqm.h") = 0
rename("/usr/lib/libhandle.a.dpkg-new", "/usr/lib/libhandle.a") = 0
rename("/usr/lib/libhandle.la.dpkg-new", "/usr/lib/libhandle.la") = 0
rename("/usr/share/doc/xfslibs-dev/changelog.Debian.gz.dpkg-new", "/usr/share/doc/xfslibs-dev/changelog.Debian.gz") = 0
rename("/usr/share/doc/xfslibs-dev/changelog.gz.dpkg-new", "/usr/share/doc/xfslibs-dev/changelog.gz") = 0
rename("/usr/share/doc/xfslibs-dev/copyright.dpkg-new", "/usr/share/doc/xfslibs-dev/copyright") = 0
rename("/usr/share/man/man3/path_to_handle.3.gz.dpkg-new", "/usr/share/man/man3/path_to_handle.3.gz") = 0
rename("/usr/share/man/man3/xfsctl.3.gz.dpkg-new", "/usr/share/man/man3/xfsctl.3.gz") = 0
rename("/lib/libhandle.a.dpkg-new", "/lib/libhandle.a") = -1 ENOENT (No such file or directory)

-- System Information:
Debian Release: 9.0
  APT prefers testing
  APT policy: (500, 'testing')
Architecture: amd64 (x86_64)

Kernel: Linux 4.9.0-1-amd64 (SMP w/1 CPU core)
Locale: LANG=en_US.utf8, LC_CTYPE=en_US.utf8 (charmap=UTF-8)
Shell: /bin/sh linked to /usr/bin/dash
Init: unable to detect

------------=_1489780444-30420-2
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 766811-close) by bugs.debian.org; 17 Mar 2017 19:51:31 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FOURLA,FROMDEVELOPER,FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,PGPSIGNATURE,
	RCVD_IN_DNSWL_MED,RP_MATCHES_RCVD autolearn=ham autolearn_force=no
	version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 78; hammy, 150; neutral, 141; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from mailly.debian.org ([2001:41b8:202:deb:6564:a62:52c3:4b72])
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=mailly.debian.org,EMAIL=hostmaster@mailly.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84_2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1coxuN-0007kR-KX
	for 766811-close@bugs.debian.org; Fri, 17 Mar 2017 19:51:31 +0000
Received: from [138.16.160.17] (helo=fasolo.debian.org)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84_2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1coxuL-0003BA-VA; Fri, 17 Mar 2017 19:51:30 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.84_2)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1coxuK-000ALN-Uw; Fri, 17 Mar 2017 19:51:28 +0000
From: Michael Biebl <biebl@debian.org>
To: 766811-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#766811: fixed in xfsprogs 4.9.0+nmu1
Message-Id: <E1coxuK-000ALN-Uw@fasolo.debian.org>
Date: Fri, 17 Mar 2017 19:51:28 +0000

Source: xfsprogs
Source-Version: 4.9.0+nmu1

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 766811@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Michael Biebl <biebl@debian.org> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Format: 1.8
Date: Fri, 17 Mar 2017 19:27:58 +0100
Source: xfsprogs
Binary: xfsprogs xfslibs-dev xfsprogs-udeb
Architecture: source
Version: 4.9.0+nmu1
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Michael Biebl <biebl@debian.org>
Description:
 xfslibs-dev - XFS filesystem-specific static libraries and headers
 xfsprogs   - Utilities for managing the XFS filesystem
 xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
Closes: 766811
Changes:
 xfsprogs (4.9.0+nmu1) unstable; urgency=medium
 .
   * Non-maintainer upload.
   * Remove code in include/buildmacros which creates bogus symlinks for
     libraries. (Closes: #766811)
Checksums-Sha1:
 5c954e8054ca48d1857919c236bd9a0c1d87b5d8 1815 xfsprogs_4.9.0+nmu1.dsc
 4d3d77915ac1e71c5418119121ab1d0f2386e704 1643816 xfsprogs_4.9.0+nmu1.tar.gz
 443b18c4123b93f76f7111d34b1574cbdd8d27cc 5592 xfsprogs_4.9.0+nmu1_source.buildinfo
Checksums-Sha256:
 c06dfa6510a7c2182bae08bd96287f16df4201e6e3b3ce51f336b0ef1833fc38 1815 xfsprogs_4.9.0+nmu1.dsc
 7866bb0e7d7256a52dc5a6aec84329858575ecd6b544db03d6af3bb66cd39631 1643816 xfsprogs_4.9.0+nmu1.tar.gz
 5100c328228196d8117429f7e802bf756f10285aafce72b9fba8087b03b567e3 5592 xfsprogs_4.9.0+nmu1_source.buildinfo
Files:
 1acb0a512e3d007978d4aa23fc2192a2 1815 admin optional xfsprogs_4.9.0+nmu1.dsc
 a8cf31861e3922a004cc7ecbc5d7f30d 1643816 admin optional xfsprogs_4.9.0+nmu1.tar.gz
 89d8f8097f9a6036798c3c2e9dfebb19 5592 admin optional xfsprogs_4.9.0+nmu1_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEECbOsLssWnJBDRcxUauHfDWCPItwFAljMNl0RHGJpZWJsQGRl
Ymlhbi5vcmcACgkQauHfDWCPItwXhRAAj6+zQiPdFZNsF2X4ooLcRuMnPWp5k113
IYhgS5DfWoIj8IGBziSv258dosjrUK+EjVRQ0xIjD2HlNcT7/ArdA9YJh+3a2KRu
H3mmCr2c/dxlGjqk3Y1B9hCUIuGrZDFUePVt641xs2bzpHDrjATZQ1X+DA7hYFAk
PXUysxz9Amioiz1mkaHGrb1itJ6G//YIYB+9WIlfRfbr6M2XqmWtrenEWykXO+OC
BlpDE4GSKwaUlcw3KMFfLItREcl9ZpcNErCbSc3j2rzdbgosyvS2Yv7sBYI6SETX
Fll27GWtmaIGimFvZD+HlOE/SH1RjAAaDnYxzJE7qBfHoJFlfa3jrZp9ytKKUmTI
5fgLlDjPDUIBimMfnZmzthWk6Fm+Ar4l4Fa5RUcqi6gXycxvoeuK93lOS45XMNGR
1i6mA2nQmZqGLl+UlluJbhbTqd+Go3UH0AGlKl1qH8JFCJ1YxRVZRcHWm23iLNz3
p75XHSGZqmdS1HVk+T0cBAszJkOdv47FbFQbg5nFVfUN+Cj4Tv4CEFunCNbotV96
Bm6c6cLolQJkkemMmTVSQyM2+INYE4bKxzDKW20pH7RsLg2NznDLys+3jQKMzXPl
dMILQEFpCKrZ7VYTYSWkzboq5sdfdJnstLvbMlplimRs2u6jhJ1xPgYN+5joveui
aUld6mwrkMA=
=q/qr
-----END PGP SIGNATURE-----
------------=_1489780444-30420-2--
