Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C95C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 21:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D21520719
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 21:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbhAYVWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 16:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732535AbhAYVVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 16:21:46 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C21C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 13:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=FDdE9xmGjfZjWTJnpC9cnK2GS51MFrtA1GE0HzXnFNg=; b=IdQxoTTWSCLWfg56ZP6Z2o+w+D
        RsKdqm6OXdHHLbowkCJoJp+fpdKncTjei8drKehldV+vBJjnrrvRdp7dP/MA3KD3fQWBsov5IEMPD
        L85D2NKdMpPSYyZQlfc/W5pJ3WGwmYXuiS4KOjWUoZTOHgtzvbuqGJ6rY+DDs8EXWJ0/qbdQVpjA3
        cp/6qKqfXXlYVV1B/xKKncU4vUjxdYgc2Fci7DhwAyL9PNMNM6bOil3b4TvOqjSeB6cUNOR+luYAM
        WWss4ZU2trFQU2iOu3aC9aaBUDldiCakfU5LOgleTxWX9XDnCaF2gElisdbDC2tFGz97yKiIzagck
        1nXmoq8A==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l49IG-00067U-LK; Mon, 25 Jan 2021 21:21:04 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#890716: marked as done (xfsprogs: FTBFS with glibc 2.27:
 error: conflicting types for 'copy_file_range')
Message-ID: <handler.890716.D890716.161160960623343.ackdone@bugs.debian.org>
References: <312cb50d-30d2-4df3-b21b-92ca41807a9a@fishpost.de>
 <151890404770.12817.14651101800594863948.reportbug@ohm.local>
X-Debian-PR-Message: closed 890716
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: ftbfs patch upstream
X-Debian-PR-Source: xfsprogs
Reply-To: 890716@bugs.debian.org
Date:   Mon, 25 Jan 2021 21:21:04 +0000
Content-Type: multipart/mixed; boundary="----------=_1611609664-23523-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1611609664-23523-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Mon, 25 Jan 2021 22:20:01 +0100
with message-id <312cb50d-30d2-4df3-b21b-92ca41807a9a@fishpost.de>
and subject line xfsprogs: FTBFS with glibc 2.27: error: conflicting types =
for 'copy_file_range'
has caused the Debian Bug report #890716,
regarding xfsprogs: FTBFS with glibc 2.27: error: conflicting types for 'co=
py_file_range'
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
890716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D890716
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1611609664-23523-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 17 Feb 2018 21:47:30 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=4.0 tests=BAYES_00,FROMDEVELOPER,
	MURPHY_DRUGS_REL8,RCVD_IN_DNSWL_MED,TXREP,XMAILER_REPORTBUG autolearn=ham
	autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 31; hammy, 150; neutral, 93; spammy,
	0. spammytokens: hammytokens:0.000-+--H*M:reportbug, 0.000-+--H*MI:reportbug,
	0.000-+--H*x:reportbug, 0.000-+--H*UA:reportbug, 0.000-+--H*r:aurel32
Return-path: <aurel32@debian.org>
Received: from hall.aurel32.net ([2001:bc8:30d7:100::1])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <aurel32@debian.org>)
	id 1enAKQ-0003xO-7U
	for submit@bugs.debian.org; Sat, 17 Feb 2018 21:47:30 +0000
Received: from [2001:bc8:30d7:120:9bb5:8936:7e6a:9e36] (helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <aurel32@debian.org>)
	id 1enAKO-0001wW-EK; Sat, 17 Feb 2018 22:47:28 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.90)
	(envelope-from <aurel32@debian.org>)
	id 1enAKN-00064s-Nn; Sat, 17 Feb 2018 22:47:27 +0100
Content-Type: multipart/mixed; boundary="===============0926290008785666133=="
MIME-Version: 1.0
From: Aurelien Jarno <aurel32@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: FTBFS with glibc 2.27: error: conflicting types for 'copy_file_range'
Message-ID: <151890404770.12817.14651101800594863948.reportbug@ohm.local>
X-Mailer: reportbug 7.1.8
Date: Sat, 17 Feb 2018 22:47:27 +0100
Delivered-To: submit@bugs.debian.org

This is a multi-part MIME message sent by reportbug.


--===============0926290008785666133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Source: xfsprogs
Version: 4.9.0+nmu1
Severity: important
Tags: upstream patch
User: debian-glibc@lists.debian.org
Usertags: 2.27

xfsprogs 4.9.0+nmu1 fails to build with glibc 2.27 (2.27-0experimental0 from
experimental):

|     [CC]     copy_file_range.o
| copy_file_range.c:46:1: error: conflicting types for 'copy_file_range'
|  copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
|  ^~~~~~~~~~~~~~~
| In file included from ../include/platform_defs.h:33:0,
|                  from ../include/project.h:21,
|                  from ../include/input.h:24,
|                  from copy_file_range.c:23:
| /usr/include/unistd.h:1110:9: note: previous declaration of 'copy_file_range' was here
|  ssize_t copy_file_range (int __infd, __off64_t *__pinoff,
|          ^~~~~~~~~~~~~~~
| ../include/buildrules:59: recipe for target 'copy_file_range.o' failed
| make[3]: *** [copy_file_range.o] Error 1
| include/buildrules:35: recipe for target 'io' failed
| make[2]: *** [io] Error 2
| Makefile:74: recipe for target 'default' failed
| make[1]: *** [default] Error 2
| make[1]: Leaving directory '/<<BUILDDIR>>/xfsprogs-4.9.0+nmu1'
| debian/rules:30: recipe for target 'built' failed
| make: *** [built] Error 2
| dpkg-buildpackage: error: debian/rules build subprocess returned exit status 2

A full build logs is available there:
http://aws-logs.debian.net/2018/02/07/glibc-exp/xfsprogs_4.9.0+nmu1_unstable_glibc-exp.log


glibc 2.27 added support for copy_file_range. Unfortunately xfsprogs
also have such a function to wrap the corresponding syscall.

The problem has been fixed in upstream commit 8041435d. I have
backported it and attached it as a patch to this bug.

--===============0926290008785666133==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="xfsprogs.diff"

diff -Nru xfsprogs-4.9.0+nmu1/io/copy_file_range.c xfsprogs-4.9.0+nmu2/io/copy_file_range.c
--- xfsprogs-4.9.0+nmu1/io/copy_file_range.c
+++ xfsprogs-4.9.0+nmu2/io/copy_file_range.c
@@ -42,8 +42,12 @@
 "));
 }
 
+/*
+ * Issue a raw copy_file_range syscall; for our test program we don't want the
+ * glibc buffered copy fallback.
+ */
 static loff_t
-copy_file_range(int fd, loff_t *src, loff_t *dst, size_t len)
+copy_file_range_cmd(int fd, loff_t *src, loff_t *dst, size_t len)
 {
 	loff_t ret;
 
@@ -127,7 +131,7 @@
 		copy_dst_truncate();
 	}
 
-	ret = copy_file_range(fd, &src, &dst, len);
+	ret = copy_file_range_cmd(fd, &src, &dst, len);
 	close(fd);
 	return ret;
 }

--===============0926290008785666133==--

------------=_1611609664-23523-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 890716-done) by bugs.debian.org; 25 Jan 2021 21:20:06 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 119; neutral, 16; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:78.0,
	0.000-+--UD:gappssmtp.com, 0.000-+--UD:20150623.gappssmtp.com,
	0.000-+--H*RU:2003
Return-path: <bastiangermann@fishpost.de>
Received: from mail-ed1-x52e.google.com ([2a00:1450:4864:20::52e]:46406)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1l49HK-00064F-0T
	for 890716-done@bugs.debian.org; Mon, 25 Jan 2021 21:20:06 +0000
Received: by mail-ed1-x52e.google.com with SMTP id dj23so17259104edb.13
        for <890716-done@bugs.debian.org>; Mon, 25 Jan 2021 13:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OCz7keoKYLz0fLBPut1cY9e6lNBWAjQOwopyMsIKAKc=;
        b=1s/2AGlb/3oxYdBlNQAL4w2BJiTMaHpStdCPd7cn8Pekwxoc1YV9gLMjxDGqZudAOn
         myueeW4j36niKykZ7GXYjpxuJCKyYpxQR5cRUJ4oqBS788V0h+BcSa9doG8AW8q1Hm/v
         dSktrW5rdyR3L1z/mQPKjElVZtHqEdr/vBqFKTba+QG8BW1JV9TK/tt3hlCetMtSFSxj
         NVE2DxVjunjXfL4COhs1YQY1pf8mGfFfANzADqig7Lby/gJcPDwiwR03/0/TxRTZW5vY
         uhGwNyEG+iWMZI0YkPpjd2ek8dqiJXh1gXVXLh4MRld7e4x/gZXaAnA/CqcHij/q3Ga8
         8a5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OCz7keoKYLz0fLBPut1cY9e6lNBWAjQOwopyMsIKAKc=;
        b=lIAXNJrmTmn8Vq9YrY2HkRXA/z0l/Qi977FIpw7YUvT5TYYvrNKdGIFp7egefOLC63
         olkgngjlbSBzb7zLA/qvPxLIiCbCiCalFLdlVsVqCGQbJyOU2ZrNkuA1fkBXFOWfP6t4
         ZiU5CoCYcm6H1+uDH3Aj+dfPMKORW9sLMICp0xUGJZX5/WYFhM35fQdjPo8ZOPDRsuMf
         G5QgFnMqxcO3U8zNZchwiZMZi5ZBmLAmI9chwmOquEFTncOsGIv0z8SdHKDvqjDoKNXg
         SEU8ndMshwetsNXHYp2Zrk8VQLrOoItuVfKnhtQV4voy5hc2Bdjdofbo5PFvsJ1YZvTU
         ETkg==
X-Gm-Message-State: AOAM533fOi+CA1XEnRkWL9GKGGDydfeLWeWaeg2EAuCHYl5P2K0dwiod
	VXI2zEJoHbUfcyIXZBO7S/t9oLbtt062hb/C
X-Google-Smtp-Source: ABdhPJzwwY7c4oHlkkqnkAt/3jPtMl/tx9SjUYcq++8iQG95MqecZ6UtnMAJpxesbuzjzwSbLBm+Bg==
X-Received: by 2002:a50:8a90:: with SMTP id j16mr1997374edj.334.1611609602595;
        Mon, 25 Jan 2021 13:20:02 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id u2sm8882595ejb.65.2021.01.25.13.20.01
        for <890716-done@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:20:02 -0800 (PST)
To: 890716-done@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: xfsprogs: FTBFS with glibc 2.27: error: conflicting types for
 'copy_file_range'
Message-ID: <312cb50d-30d2-4df3-b21b-92ca41807a9a@fishpost.de>
Date: Mon, 25 Jan 2021 22:20:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit

The problem is fixed in all versions in the archive that have glibc >= 
2.27, which are buster, bullseye, and sid.
------------=_1611609664-23523-0--
