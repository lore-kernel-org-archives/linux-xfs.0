Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from buxtehude.debian.org ([209.87.16.39]:55152 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751232AbdCQTz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2017 15:55:27 -0400
MIME-Version: 1.0
From: owner@bugs.debian.org (Debian Bug Tracking System)
Subject: Bug#857932: marked as done (xfslibs-dev:ppc64el Fails to install
 on multi-arch setup with merged /usr)
Message-ID: <handler.857932.D766811.148978029129803.ackdone@bugs.debian.org>
References: <E1coxuK-000ALN-Uw@fasolo.debian.org> <8737edpeu4.fsf@linaro.org>
Date: Fri, 17 Mar 2017 19:54:05 +0000
Content-Type: multipart/mixed; boundary="----------=_1489780445-30420-4"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Biebl <biebl@debian.org>

This is a multi-part message in MIME format...

------------=_1489780445-30420-4
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf-8

Your message dated Fri, 17 Mar 2017 19:51:28 +0000
with message-id <E1coxuK-000ALN-Uw@fasolo.debian.org>
and subject line Bug#766811: fixed in xfsprogs 4.9.0+nmu1
has caused the Debian Bug report #766811,
regarding xfslibs-dev:ppc64el Fails to install on multi-arch setup with mer=
ged /usr
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

------------=_1489780445-30420-4
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 16 Mar 2017 12:48:24 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.0-bugs.debian.org_2005_01_02
	(2014-02-07) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FOURLA,FVGT_m_MULTI_ODD,HAS_PACKAGE,
	RCVD_IN_DNSWL_LOW,SPF_PASS,X_DEBBUGS_CC autolearn=ham autolearn_force=no
	version=3.4.0-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 34; hammy, 150; neutral, 159; spammy,
	0. spammytokens: hammytokens:0.000-+--armhf, 0.000-+--arm64, 0.000-+--ppc64el,
	 0.000-+--builddep, 0.000-+--build-dep
Return-path: <alex.bennee@linaro.org>
Received: from mail-wm0-x234.google.com ([2a00:1450:400c:c09::234])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84_2)
	(envelope-from <alex.bennee@linaro.org>)
	id 1coUpL-0008EX-NX
	for submit@bugs.debian.org; Thu, 16 Mar 2017 12:48:24 +0000
Received: by mail-wm0-x234.google.com with SMTP id t189so46864582wmt.1
        for <submit@bugs.debian.org>; Thu, 16 Mar 2017 05:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=user-agent:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=reCRRRUy2ogaVDBNAbMgBwNbLEN+8L89PZNKeOAgDko=;
        b=kl2BWL0b2O0WJqvdujk4ppIYYYDh4Q1UgAtdFiw62jX8xQtSRov6dr1+zD5gtAOVsj
         Ar1DdNsSaLvPrkoqOQWJjbnzmymNQsjw0BkZlFmZEuX1KKqjVfWweeowhxZ6XQ3TYwUV
         GpV8XZOomTYbwUDzGmOjeEePV8pAxC/qWjuMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=reCRRRUy2ogaVDBNAbMgBwNbLEN+8L89PZNKeOAgDko=;
        b=MxxpGDW8ER2NxcQo4m07wJb5LihiMUyDIqv3ydJWkPYp7BdxCnDqg+SoG504Gmyeg5
         jJg6G1FxwIrE6f8tPmIIsdfHOnEAkeGIlABTQ1oTVbw/6hhBFzVo/5+TQhKrlcvbvS7M
         XOyCrZDDr+HtPtH3DiVZemR1TmHpw1BzCinHBzd0f/uZGRiuAZU56zQX0A4GrPH2mS1u
         2sdbECDF6lQRlk6B8uXm4BJMYcu3C+xZ8pF3Y+nXkgHUtMZr6antAS9ErE/FfSz+9ITs
         98kZ5d/SSXqjEyCJcYk0L9SnNlr50cYyPM9MwEeJBU/9f2HiJhY01Uj/EvXhxBrWiRhA
         2kTw==
X-Gm-Message-State: AFeK/H21RdFjbIgudrMO7/eNivVqnMYUsGP1jalVd9j+9gqzvSizssxAyu0q/uDxxPwBsrYG
X-Received: by 10.28.226.4 with SMTP id z4mr24056755wmg.135.1489668495883;
        Thu, 16 Mar 2017 05:48:15 -0700 (PDT)
Received: from zen.linaro.local ([81.128.185.34])
        by smtp.gmail.com with ESMTPSA id 53sm6079433wrt.52.2017.03.16.05.48.14
        for <submit@bugs.debian.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Mar 2017 05:48:15 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
	by zen.linaro.local (Postfix) with ESMTPS id 45D2B3E00CA
	for <submit@bugs.debian.org>; Thu, 16 Mar 2017 12:48:35 +0000 (GMT)
User-agent: mu4e 0.9.19; emacs 25.2.9
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfslibs-dev:ppc64el Fails to install on multi-arch setup with merged /usr
X-Debbugs-CC: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 16 Mar 2017 12:48:35 +0000
Message-ID: <8737edpeu4.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Delivered-To: submit@bugs.debian.org

Package: xfslibs-dev
Severity: normal
Tags: stretch, sid
Usertags: usr, usrmerge, multiarch

Hi,

While trying to build a cross-build environment for QEMU I ran into a
problem installing xfslibs-dev. The docker build looked like this:

  #
  # Docker ppc64el cross-compiler target
  #
  # This docker target builds on the base debian image.
  #
  # Broken in Jessie
  FROM debian:stretch-slim

  # Duplicate deb line as deb-src
  RUN cat /etc/apt/sources.list | sed "s/deb/deb-src/" >> /etc/apt/sources.list

  # Add the foreign architecture we want and install dependencies
  RUN dpkg --add-architecture ppc64el
  RUN apt update && apt dist-upgrade -yy
  RUN apt-get build-dep -yy -a ppc64el qemu
  RUN apt install -yy gcc-multilib-ppc64el binutils-multiarch

  # Specify the cross prefix for this image (see tests/docker/common.rc)
  ENV QEMU_CONFIGURE_OPTS --cross-prefix=ppc64el-linux-gnu-

The error message reported by the build-dep stage was:

  Unpacking xfslibs-dev:ppc64el (4.9.0) ...
  dpkg: error processing archive /tmp/apt-dpkg-install-u0zpz1/10-xfslibs-dev_4.9.0_ppc64el.deb (--unpack):
   unable to install new version of '/lib/libhandle.a': No such file or directory
  Errors were encountered while processing:
   /tmp/apt-dpkg-install-u0zpz1/10-xfslibs-dev_4.9.0_ppc64el.deb
  E: Sub-process /usr/bin/dpkg returned an error code (1)

Testing with debian:unstable-slim produced the same result.

After discussion on #debian-bootstrap we reproduced with a simpler setup:

  <helmut> I can reproduce your problem in unstable now. fresh sid
      debootstrap amd64; dpkg --add-architecture ppc64el; apt-get
      update; apt-get install usrmerge; apt-get install
      xfslibs-dev:ppc64el # reproduces

There seems to be debate as to if this is a straight up multi-arch bug
or a user merge bug so I've tagged them as both for now. Certainly
static libraries need to be properly placed in the relevant multi-arch
paths but this seems to work for arm64 and armhf (which I have also set
up QEMU cross build environments for).

---
Alex Bennée

------------=_1489780445-30420-4
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
------------=_1489780445-30420-4--
