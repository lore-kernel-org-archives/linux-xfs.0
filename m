Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 283EEC433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 21:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB56D64FC0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 21:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhBEVLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbhBEVJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Feb 2021 16:09:52 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC22BC061786
        for <linux-xfs@vger.kernel.org>; Fri,  5 Feb 2021 13:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=HjJBrqLqpzRRK6gZbeI1rk0Pn323olWcht/uzEUG6iw=; b=UxdxySbkTxDw/NeORMR/F2ruml
        Z8sr2AeyvF6ohoHjC3OPC9r4/lLMmhXdbqS7XlfrIRlPgQAPhTUh6cYW1ESPINTSQtpiKC3eA13aQ
        HjB6gJrkWkP/wLKN7Rf5Ey5mSepPdlWUBYyCKnPaX5s0m+TheWZDXVaprdawrIyofmn6ji13mH8Vh
        1wT6NKKMCehp0xI0IN4b70nhdqC8gAXCr+472t7zqdycAHg71DO3djV08KiH1aGEQg02/zQi9k4G/
        G50tuVAx8kOh9JTBM4VJPE1grklO/pG2CjAtvtrDIZ2x7dBrEfPd87cGYyhjXzupZ9HZUP5NBB2CT
        vr5oYZNQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l88Ll-0000FD-Mj; Fri, 05 Feb 2021 21:09:09 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#981361: marked as done (xfsprogs: drop unused dh-python from
 Build-Depends)
Message-ID: <handler.981361.D981361.161255912831398.ackdone@bugs.debian.org>
References: <E1l88IA-0006Ck-Qh@fasolo.debian.org> <YBROMk+U0++mH4qh@alf.mars>
X-Debian-PR-Message: closed 981361
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: patch
X-Debian-PR-Source: xfsprogs
Reply-To: 981361@bugs.debian.org
Date:   Fri, 05 Feb 2021 21:09:09 +0000
Content-Type: multipart/mixed; boundary="----------=_1612559349-931-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1612559349-931-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 05 Feb 2021 21:05:26 +0000
with message-id <E1l88IA-0006Ck-Qh@fasolo.debian.org>
and subject line Bug#981361: fixed in xfsprogs 5.10.0-3
has caused the Debian Bug report #981361,
regarding xfsprogs: drop unused dh-python from Build-Depends
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
981361: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D981361
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1612559349-931-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 29 Jan 2021 21:39:24 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=4.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	MURPHY_DRUGS_REL8,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=no
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 11; hammy, 150; neutral, 110; spammy,
	0. spammytokens: hammytokens:0.000-+--UD:kernel.org, 0.000-+--grohne,
	0.000-+--Grohne, 0.000-+--dhpython, 0.000-+--dh-python
Return-path: <helmut@subdivi.de>
Received: from isilmar-4.linta.de ([136.243.71.142]:44752)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <helmut@subdivi.de>)
	id 1l5bUC-0005zI-Kv
	for submit@bugs.debian.org; Fri, 29 Jan 2021 21:39:24 +0000
Received: from isilmar-4.linta.de (isilmar.linta [10.0.0.1])
	by isilmar-4.linta.de (Postfix) with ESMTP id E0A2A200E60
	for <submit@bugs.debian.org>; Fri, 29 Jan 2021 21:39:21 +0000 (UTC)
Date: Fri, 29 Jan 2021 19:04:34 +0100
From: Helmut Grohne <helmut@subdivi.de>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: drop unused dh-python from Build-Depends
Message-ID: <YBROMk+U0++mH4qh@alf.mars>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hfS82wKdIbknczqu"
Content-Disposition: inline
X-Reportbug-Version: 7.9.0
Delivered-To: submit@bugs.debian.org


--hfS82wKdIbknczqu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Source: xfsprogs
Version: 5.10.0-2
Tags: patch
User: helmutg@debian.org
Usertags: rebootstrap

xfsprogs participates in dependency loops relevant to architecture
bootstrap. Instead of looking into such a difficult problem, I looked
into easily droppable dependencies and found that xfsprogs does not use
dh-python in any way. Please consider applying the attached patch to
drop it.

Helmut

--hfS82wKdIbknczqu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfsprogs_5.10.0-2.1.debdiff"

diff --minimal -Nru xfsprogs-5.10.0/debian/changelog xfsprogs-5.10.0/debian/changelog
--- xfsprogs-5.10.0/debian/changelog	2021-01-14 18:59:14.000000000 +0100
+++ xfsprogs-5.10.0/debian/changelog	2021-01-29 19:02:30.000000000 +0100
@@ -1,3 +1,10 @@
+xfsprogs (5.10.0-2.1) UNRELEASED; urgency=medium
+
+  * Non-maintainer upload.
+  * Drop unused dh-python from Build-Depends. (Closes: #-1)
+
+ -- Helmut Grohne <helmut@subdivi.de>  Fri, 29 Jan 2021 19:02:30 +0100
+
 xfsprogs (5.10.0-2) unstable; urgency=low
 
   * Team upload
diff --minimal -Nru xfsprogs-5.10.0/debian/control xfsprogs-5.10.0/debian/control
--- xfsprogs-5.10.0/debian/control	2021-01-14 18:59:14.000000000 +0100
+++ xfsprogs-5.10.0/debian/control	2021-01-29 19:02:15.000000000 +0100
@@ -3,7 +3,7 @@
 Priority: optional
 Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>, Bastian Germann <bastiangermann@fishpost.de>
-Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, dh-python, pkg-config
+Build-Depends: libinih-dev, uuid-dev, dh-autoreconf, debhelper (>= 5), gettext, libtool, libedit-dev, libblkid-dev (>= 2.17), linux-libc-dev, libdevmapper-dev, libattr1-dev, libicu-dev, pkg-config
 Standards-Version: 4.0.0
 Homepage: https://xfs.wiki.kernel.org/
 

--hfS82wKdIbknczqu--

------------=_1612559349-931-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 981361-close) by bugs.debian.org; 5 Feb 2021 21:05:28 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=4.0 tests=BAYES_00,DIGITS_LETTERS,
	FVGT_m_MULTI_ODD,HAS_BUG_NUMBER,MD5_SHA1_SUM,PGPSIGNATURE,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,TXREP autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 82; hammy, 150; neutral, 134; spammy,
	0. spammytokens: hammytokens:0.000-+--HX-Debian:DAK,
	0.000-+--H*rp:D*ftp-master.debian.org, 0.000-+--HX-DAK:process-upload,
	0.000-+--Hx-spam-relays-external:sk:envelop, 0.000-+--H*r:138.16.160
Return-path: <envelope@ftp-master.debian.org>
Received: from muffat.debian.org ([2607:f8f0:614:1::1274:33]:40992)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=muffat.debian.org,EMAIL=hostmaster@muffat.debian.org (verified)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l88IC-0008AD-Ei
	for 981361-close@bugs.debian.org; Fri, 05 Feb 2021 21:05:28 +0000
Received: from fasolo.debian.org ([138.16.160.17]:51908)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=fasolo.debian.org,EMAIL=hostmaster@fasolo.debian.org (verified)
	by muffat.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l88IB-00054A-Lh; Fri, 05 Feb 2021 21:05:27 +0000
Received: from dak by fasolo.debian.org with local (Exim 4.92)
	(envelope-from <envelope@ftp-master.debian.org>)
	id 1l88IA-0006Ck-Qh; Fri, 05 Feb 2021 21:05:26 +0000
From: Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Reply-To: Bastian Germann <bastiangermann@fishpost.de>
To: 981361-close@bugs.debian.org
X-DAK: dak process-upload
X-Debian: DAK
X-Debian-Package: xfsprogs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Bug#981361: fixed in xfsprogs 5.10.0-3
Message-Id: <E1l88IA-0006Ck-Qh@fasolo.debian.org>
Date: Fri, 05 Feb 2021 21:05:26 +0000

Source: xfsprogs
Source-Version: 5.10.0-3
Done: Bastian Germann <bastiangermann@fishpost.de>

We believe that the bug you reported is fixed in the latest version of
xfsprogs, which is due to be installed in the Debian FTP archive.

A summary of the changes between this version and the previous one is
attached.

Thank you for reporting the bug, which will now be closed.  If you
have further comments please address them to 981361@bugs.debian.org,
and the maintainer will reopen the bug report if appropriate.

Debian distribution maintenance software
pp.
Bastian Germann <bastiangermann@fishpost.de> (supplier of updated xfsprogs package)

(This message was generated automatically at their request; if you
believe that there is a problem with it please contact the archive
administrators by mailing ftpmaster@ftp-master.debian.org)


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 1.8
Date: Fri, 05 Feb 2021 00:18:31 +0100
Source: xfsprogs
Architecture: source
Version: 5.10.0-3
Distribution: unstable
Urgency: medium
Maintainer: XFS Development Team <linux-xfs@vger.kernel.org>
Changed-By: Bastian Germann <bastiangermann@fishpost.de>
Closes: 570704 981361
Changes:
 xfsprogs (5.10.0-3) unstable; urgency=medium
 .
   * Drop unused dh-python from Build-Depends (Closes: #981361)
   * Only build for Linux
   * Prevent installing duplicate changelog (Closes: #570704)
Checksums-Sha1:
 900af5be1841442f9be8a64e9f29d9b961bb53da 2047 xfsprogs_5.10.0-3.dsc
 318931355b60145dbb335852c8848830ed13429e 13884 xfsprogs_5.10.0-3.debian.tar.xz
 df3f27fb3acb4a0c092d9620948a90fde44bc198 6145 xfsprogs_5.10.0-3_source.buildinfo
Checksums-Sha256:
 5515e789676e657d92fde061a40875313bbc906f30343e35a164d2df699db4da 2047 xfsprogs_5.10.0-3.dsc
 8ff1807e228afe92f489d19ddbc415358b03375320ceead38debd4408511862a 13884 xfsprogs_5.10.0-3.debian.tar.xz
 d796004671c464b0dc82ff31c3e0dd4464d44e6e7a235cde59eaa47b740fc421 6145 xfsprogs_5.10.0-3_source.buildinfo
Files:
 3eb63eadc5601aa0f5d6a6b32479a45c 2047 admin optional xfsprogs_5.10.0-3.dsc
 be5f3ab288c96161d358308e7c810a89 13884 admin optional xfsprogs_5.10.0-3.debian.tar.xz
 e5eca5118bf2497e0cfc13812c07558f 6145 admin optional xfsprogs_5.10.0-3_source.buildinfo

-----BEGIN PGP SIGNATURE-----

iQHPBAEBCgA5FiEEQGIgyLhVKAI3jM5BH1x6i0VWQxQFAmAdr2MbHGJhc3RpYW5n
ZXJtYW5uQGZpc2hwb3N0LmRlAAoJEB9ceotFVkMU0vYL/iRxjvSoq8/YdiozpiYP
D7ZVU4R75eq5l97NkAw8KqA81yYjYLsLNFLG4FPdFAagl4M2FbdoLYmPsl7XmaB+
Bz40dlxYoNV9u/JyqpnJEL9MpDalfc0FGHpdz3xCbjg0d/28DOuHXOzjy48o7Ac5
G+eQMEu/XcHLD+c0O00odPngq1blNiRWt6nINpXH7CU5q49Cv/UiqDOI6CjMnqnm
2AhqQbCP3//jCIIyYpGqawyh0RcslmigYWc0vGTtanuhe6JOi+CFKP5JpCIQ7fi3
5aJgTJRhsBSKO6YV33bTGRxW6rZgiLUehKQOqyYS0f2IaaGYGxMquoLjCoOvrD4H
Ove4eq/6z+Ad33+KBtIQV/zwsOjXAjgejPzQiTJOWfv7Rq9/o1Bl8dlKSz8KZYWu
dovtOxiVyh/jj2XTaR42l8XiR6mF1vdnWB5+A8Uom1FkykOfNE4JMmRVp9++DyH5
F8DcQabeYYPttu+C+i+llhqhJVOQGm7E6rltXpy4IX1Eaw==
=n4pB
-----END PGP SIGNATURE-----
------------=_1612559349-931-0--
