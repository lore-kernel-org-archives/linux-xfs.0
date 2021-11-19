Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D5CC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 746D0611CC
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Nov 2021 17:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhKSRjJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Nov 2021 12:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbhKSRjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Nov 2021 12:39:09 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E862C061574
        for <linux-xfs@vger.kernel.org>; Fri, 19 Nov 2021 09:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=E5tj838LHtgSo+KHZjVu0HHkx7SCAw0CBGDjdmU/wNY=; b=ESvz09bcG2WUixTlKijcKFXCYu
        CYldBVhQnQVCaaRQsptg4CRvGCtM9mrcaFWUUG8xpmdaaQE0HTBwvJV4q5GZQR8JDGGXZDtA9TvII
        U9Wbkp5O8yh88vU9y5mJrIpvfDvrwmyl4ADDA7N5rWG94nQVV7BT0OH0o/43y58cT1nvYkYrv+3we
        kyJLcIZE7voPlUy6yF8rcqUH3UDxh+VRcjnPfW5VVw2Iq+vdofxsVT4jiPVZIpDLEBGHD740YI285
        vH5dBe4zXk2Ea90AeQxPXYAyTp3+JVZwToA6+YklSnSJArnBmB6D8F/u7E6fe9C1BEj0KHhUGdCEV
        Y+DhP1xg==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mo7nv-0007gg-KS; Fri, 19 Nov 2021 17:36:03 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bage@debian.org>
Subject: Bug#999743: marked as done (xfsprogs FTBFS: .gitcensus: No such
 file or directory)
Message-ID: <handler.999743.D999743.163734323128457.ackdone@bugs.debian.org>
References: <b14e2072-5556-41b9-dfab-035b35f3d395@debian.org>
 <163700840784.4520.2954754823827344140.reportbug@localhost>
X-Debian-PR-Message: closed 999743
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: ftbfs
X-Debian-PR-Source: xfsprogs
Reply-To: 999743@bugs.debian.org
Date:   Fri, 19 Nov 2021 17:36:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1637343363-29542-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1637343363-29542-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Fri, 19 Nov 2021 18:33:43 +0100
with message-id <b14e2072-5556-41b9-dfab-035b35f3d395@debian.org>
and subject line xfsprogs fix
has caused the Debian Bug report #999743,
regarding xfsprogs FTBFS: .gitcensus: No such file or directory
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
999743: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D999743
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1637343363-29542-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 15 Nov 2021 20:33:43 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,TXREP,
	XMAILER_REPORTBUG autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 132; neutral, 23; spammy,
	0. spammytokens: hammytokens:0.000-+--sk:buildd.,
	0.000-+--UD:buildd.debian.org, 0.000-+--buildddebianorg,
	0.000-+--buildd.debian.org, 0.000-+--H*UA:deb10u1
Return-path: <SRS0=GrDV=QC=debian.org=bunk@stusta.mhn.de>
Received: from mail.stusta.mhn.de ([2001:4ca0:200:3:200:5efe:8d54:4505]:46560)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <SRS0=GrDV=QC=debian.org=bunk@stusta.mhn.de>)
	id 1mmiff-0000ee-Bn
	for submit@bugs.debian.org; Mon, 15 Nov 2021 20:33:43 +0000
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.stusta.mhn.de (Postfix) with ESMTPSA id 4HtLTT2DGpz2c;
	Mon, 15 Nov 2021 21:32:13 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Adrian Bunk <bunk@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs FTBFS: .gitcensus: No such file or directory
Message-ID: <163700840784.4520.2954754823827344140.reportbug@localhost>
X-Mailer: reportbug 7.5.3~deb10u1
Date: Mon, 15 Nov 2021 22:33:27 +0200
Delivered-To: submit@bugs.debian.org

Source: xfsprogs
Version: 5.14.0-rc1-1
Severity: serious
Tags: ftbfs

https://buildd.debian.org/status/logs.php?pkg=xfsprogs&ver=5.14.0-rc1-1

...
cat: .gitcensus: No such file or directory
/bin/tar: .gitcensus: Cannot stat: No such file or directory
/bin/tar: Exiting with failure status due to previous errors
gmake[2]: *** [Makefile:187: xfsprogs-5.14.0-rc1.tar.gz] Error 2

------------=_1637343363-29542-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 999743-done) by bugs.debian.org; 19 Nov 2021 17:33:51 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,TXREP,VERSION autolearn=ham
	autolearn_force=no version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 35; hammy, 104; neutral, 19; spammy,
	0. spammytokens: hammytokens:0.000-+--H*u:78.0, 0.000-+--H*u:78.14.0,
	0.000-+--H*UA:78.14.0, 0.000-+--HARC-Seal:zohoarc,
	0.000-+--HARC-Message-Signature:zohoarc
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
X-CrossAssassin-Score: 2

Version: 5.14.0-1
------------=_1637343363-29542-0--
