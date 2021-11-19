Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D45C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E56E961A3A
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhKSRjO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:39:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbhKSRjN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:39:13 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C4FC061574
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 09:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=O01VpjKHxZhRA7gUncMp1FipHbvDVw6OpY8omZOJOls=; b=IZzU9MHmnHffa32MrtqyvVDWuy
        IAR/tJX0rC86nbMpePGKEj5w7lF971AO1+Bc2GpI3RgY9oCeVNEo3AX0ES9KRO63REXNYejYgd9s7
        LjMijMqKTf3rQJytvWlccSqfnfku8Pi20QZf48weE2aIogLmBEA/Yack1GptXqcy5aMTwW3o3qIq0
        Eg4KvpLPkf43bRpcAa+gQTNXXlEW7REwn+Z09FnTXIrzKXdmqrzRQQfYEM72rsKBl+k23laU3wtXe
        mZ8WiepJRWhJ1JDsY6JZWlG5kSatsvMUiE6oS6lTolC/66h4zCLUboZXXBWGZL1+9iII1Vtk+SsEa
        KxTrBI2Q==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mo7o1-0007hg-92; Fri, 19 Nov 2021 17:36:09 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bage@debian.org>
Subject: Bug#999879: marked as done (xfsprogs FTCBFS: [TEST] CRC32 fails
 to compile)
Message-ID: <handler.999879.D999879.163734323128445.ackdone@bugs.debian.org>
References: <b14e2072-5556-41b9-dfab-035b35f3d395@debian.org>
 <YZPJDbOH7tDyK5sb@alf.mars>
X-Debian-PR-Message: closed 999879
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: patch
X-Debian-PR-Source: xfsprogs
Reply-To: 999879@bugs.debian.org
Date:   Fri, 19 Nov 2021 17:36:09 +0000
Content-Type: multipart/mixed; boundary="----------=_1637343369-29603-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1637343369-29603-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 19 Nov 2021 18:33:43 +0100
with message-id <b14e2072-5556-41b9-dfab-035b35f3d395@debian.org>
and subject line xfsprogs fix
has caused the Debian Bug report #999879,
regarding xfsprogs FTCBFS: [TEST] CRC32 fails to compile
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
999879: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D999879
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1637343369-29603-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 18 Nov 2021 05:21:50 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=4.0 tests=BAYES_00,DATE_IN_PAST_24_48,
	FOURLA,MURPHY_DRUGS_REL8,SPF_HELO_NONE,SPF_NONE,TXREP,
	WORD_WITHOUT_VOWELS autolearn=no autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 18; hammy, 150; neutral, 59; spammy,
	0. spammytokens: hammytokens:0.000-+--grohne, 0.000-+--Grohne,
	0.000-+--buildindep, 0.000-+--build-indep, 0.000-+--H*F:U*helmut
Return-path: <helmut@subdivi.de>
Received: from isilmar-4.linta.de ([136.243.71.142]:43414)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <helmut@subdivi.de>)
	id 1mnZrq-0002Gr-Jf
	for submit@bugs.debian.org; Thu, 18 Nov 2021 05:21:50 +0000
Received: from isilmar-4.linta.de (isilmar.linta [10.0.0.1])
	by isilmar-4.linta.de (Postfix) with ESMTP id C77432013B4
	for <submit@bugs.debian.org>; Thu, 18 Nov 2021 05:21:44 +0000 (UTC)
Date: Tue, 16 Nov 2021 16:06:53 +0100
From: Helmut Grohne <helmut@subdivi.de>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs FTCBFS: [TEST] CRC32 fails to compile
Message-ID: <YZPJDbOH7tDyK5sb@alf.mars>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4YYq7XAadU7XMn+B"
Content-Disposition: inline
X-Reportbug-Version: 11.1.0
Delivered-To: submit@bugs.debian.org


--4YYq7XAadU7XMn+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Source: xfsprogs
Version: 5.14.0-rc1-1
Tags: patch
User: debian-cross@lists.debian.org
Usertags: ftcbfs
Control: block -1 by 999743

xfsprogs fails to cross build from source, because it attempts to build
its crc32 test with the build architecture compiler and thus fails
finding the liburcu, which is only requested for the host architecture.
While this test is useful for native builds, it is not that useful for
cross builds. I propose skipping it (e.g. by pre-creating the output
file). After doing so it fails via #999743. Please consider applying the
attached patch.

Helmut

--4YYq7XAadU7XMn+B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xfsprogs_5.14.0-rc1-1.1.debdiff"

diff --minimal -Nru xfsprogs-5.14.0-rc1/debian/changelog xfsprogs-5.14.0-rc1/debian/changelog
--- xfsprogs-5.14.0-rc1/debian/changelog	2021-11-14 23:18:22.000000000 +0100
+++ xfsprogs-5.14.0-rc1/debian/changelog	2021-11-16 14:43:28.000000000 +0100
@@ -1,3 +1,10 @@
+xfsprogs (5.14.0-rc1-1.1) UNRELEASED; urgency=medium
+
+  * Non-maintainer upload.
+  * Fix FTCBFS: Skip crc32 test. (Closes: #-1)
+
+ -- Helmut Grohne <helmut@subdivi.de>  Tue, 16 Nov 2021 14:43:28 +0100
+
 xfsprogs (5.14.0-rc1-1) unstable; urgency=medium
 
   [ Dave Chinner ]
diff --minimal -Nru xfsprogs-5.14.0-rc1/debian/rules xfsprogs-5.14.0-rc1/debian/rules
--- xfsprogs-5.14.0-rc1/debian/rules	2021-11-14 23:18:22.000000000 +0100
+++ xfsprogs-5.14.0-rc1/debian/rules	2021-11-16 14:43:28.000000000 +0100
@@ -40,6 +40,9 @@
 build-indep: built
 built: dibuild config
 	@echo "== dpkg-buildpackage: build" 1>&2
+ifneq ($(DEB_BUILD_ARCH),$(DEB_HOST_ARCH))
+	touch --date=+3day libfrog/crc32selftest
+endif
 	$(MAKE) $(PMAKEFLAGS) default
 	touch built
 

--4YYq7XAadU7XMn+B--

------------=_1637343369-29603-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 999879-done) by bugs.debian.org; 19 Nov 2021 17:33:51 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,TXREP,VERSION autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 35; hammy, 104; neutral, 19; spammy,
	0. spammytokens: hammytokens:0.000-+--H*u:78.0, 0.000-+--H*u:78.14.0,
	0.000-+--H*UA:78.14.0, 0.000-+--HARC-Message-Signature:zohoarc,
	0.000-+--HARC-Seal:zohoarc
Return-path: <hostmaster@neglo.de>
Received: from sender11-of-o53.zoho.eu ([31.186.226.239]:21836)
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <hostmaster@neglo.de>)
	id 1mo7ln-0007IK-8b; Fri, 19 Nov 2021 17:33:51 +0000
ARC-Seal: i=1; a=rsa-sha256; t=1637343225; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=eSMDQIOUmAZLjzbSRpcFmw+bR2zeCvqd7rvrqUz0B9Vw+fbE2kY3iQ81MWeCu/Y4r9x6xil1w40rIub6jOyhC/gFRuDj7MnCUDLjm6gvJSOt+2Lwj+886r8PPKOp1p/BOLvQskol7raO2cfcTRj0MA+SQQPorszDmpqDn6/Ii3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1637343225; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
	bh=7xMVYsdwFVr6n/FSjehHUKzRKrnOch7otSAjd9J5QUM=; 
	b=MhVy1fhd7LI6INUNsaic6OtSnvwd+zJ14YwLYwm7WObEjhYQMHWIVpCf043z3hiLyXuiOndSd7jVqTbE2XuL//xv36PRnZQ5rpmmwmJI+VsgiXy6Ta1RRyKfCtvgHJJarskYgWRwGi/hcA9OH87lQjae7h+5fFB3fBPBiPz1+x8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	spf=pass  smtp.mailfrom=hostmaster@neglo.de;
	dmarc=pass header.from=<bage@debian.org>
Received: from [192.168.1.146] (port-92-200-1-46.dynamic.as20676.net [92.200.1.46]) by mx.zoho.eu
	with SMTPS id 1637343224367707.9302193536845; Fri, 19 Nov 2021 18:33:44 +0100 (CET)
To: 999743-done@bugs.debian.org, 999879-done@bugs.debian.org
From: Bastian Germann <bage@debian.org>
Subject: xfsprogs fix
Message-ID: <b14e2072-5556-41b9-dfab-035b35f3d395@debian.org>
Date: Fri, 19 Nov 2021 18:33:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit

Version: 5.14.0-1
------------=_1637343369-29603-0--
