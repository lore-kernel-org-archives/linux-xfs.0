Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:55150 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdCQTz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 15:55:27 -0400
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#766811: marked as done (spurious library links)
Message-ID: <handler.766811.D766811.148978029129803.ackdone@bugs.debian.org>
References: <E1coxuK-000ALN-Uw@fasolo.debian.org>
 <20141026004825.GA27863@bongo.bofh.it>
Date: Fri, 17 Mar 2017 19:54:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1489780443-30420-0"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Biebl <biebl@debian.org>

This is a multi-part message in MIME format...

------------=_1489780443-30420-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Fri, 17 Mar 2017 19:51:28 +0000
with message-id <E1coxuK-000ALN-Uw@fasolo.debian.org>
and subject line Bug#766811: fixed in xfsprogs 4.9.0+nmu1
has caused the Debian Bug report #766811,
regarding spurious library links
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

------------=_1489780443-30420-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 26 Oct 2014 00:48:49 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.2-bugs.debian.org_2005_01_02
	(2011-06-06) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.0 required=4.0 tests=BAYES_00,HAS_PACKAGE,
	PGPSIGNATURE,X_DEBBUGS_CC autolearn=ham
	version=3.3.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 13; hammy, 74; neutral, 24; spammy, 0.
	spammytokens: hammytokens:0.000-+--H*c:pgp-sha256, 0.000-+--H*u:2014-03-12,
	0.000-+--H*UA:2014-03-12, 0.000-+--H*u:1.5.23, 0.000-+--H*UA:1.5.23
Return-path: <md@linux.it>
Received: from attila.bofh.it ([85.94.204.146] ident=postfix)
	by buxtehude.debian.org with esmtp (Exim 4.80)
	(envelope-from <md@linux.it>)
	id 1XiC0n-000744-4E
	for submit@bugs.debian.org; Sun, 26 Oct 2014 00:48:49 +0000
Received: by attila.bofh.it (Postfix, from userid 10)
	id 166B82E384; Sun, 26 Oct 2014 02:48:46 +0200 (CEST)
Received: by bongo.bofh.it (Postfix, from userid 1000)
	id 762652C26AC; Sun, 26 Oct 2014 02:48:25 +0200 (CEST)
Date: Sun, 26 Oct 2014 02:48:25 +0200
From: Marco d'Itri <md@linux.it>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: spurious library links
Message-ID: <20141026004825.GA27863@bongo.bofh.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
X-Reportbug-Version: 6.5.1
X-Debbugs-Cc: md@linux.it
User-Agent: Mutt/1.5.23 (2014-03-12)
Delivered-To: submit@bugs.debian.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Package: xfslibs-dev
Version: 3.2.1
Severity: normal

These links do not appear to have any purpose and should be removed:

/lib/libhandle.a -> /usr/lib/libhandle.a
/lib/libhandle.la -> /usr/lib/libhandle.la
/usr/lib/libhandle.so -> /lib/libhandle.so

Also, policy forbids to thip the .la files at all for normal libraries.

--=20
ciao,
Marco

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQGcBAEBCAAGBQJUTETZAAoJECv1pcEixPekDUAL/1ZETnJTeLt6DTKimbHXxsJW
gXC5vyI9/x50gPeGZM0QZDeoOqXkmn2NHww24ljtlar7SjyyKcsHVvWQ3e6h2GoW
vrfTfpAmsFNlx9QqolFiiLFExJbPVUFLTuINWTzDIPR+UjMlz3k0H1x5adrRbmmX
7KfscCiEVBbo+QSdFFVd3oiBriwsBLPhLxIEVwBOvBKzG5Vx+SIfPIcbS1VMMi3L
895Xj2cq4ZCOMb7bCOFybRUm6lpzK9y5gvkW7JyF56KHCr+wzXqy+NXmv6IbyoA5
G63gITsd9lwZ+f3kTYAFgZvirSVKt30deotZTmo0L8uFjMfvN4RcaeH7JP9pN37k
xgKoHeJRYPfI/scpQqNVBrGhrNke9FSbBpZt0qKBUg7NBuuncy4c1c8OUWCxehP5
iVzkTCMHzii1BtqjqiVhuwj6LZTj2hR170O1Sw2uRVFO++YVpyaQWt+zYSZkEptZ
5qQ3RGngc5ddu1V9SxTldZR0RoB/KvGruCzecNewBw==
=1jn8
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--

------------=_1489780443-30420-0
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
------------=_1489780443-30420-0--
