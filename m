Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA27C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D5A22E01
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhASWev (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727959AbhASWeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 17:34:00 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134CCC061575
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 14:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=qug7uDba06iSft/n5pee2mul0OItXucd7ykS4eh3O3U=; b=coGVz1qdtFz0MkcICrdHx9CM0U
        FyTITCtpoO0f1vgyxaxXHkInOP42o1y3zunykQFDyl/KIXLqMpxwTSP3CXmITuObdbMbzNe/RMqMM
        nEGuuwnAeYo9pZZDR9GRYrPGETuXmXefNt1tRqishPmd7d0GuIOwbYgpH8rpvAyT7DdtAGttOhMgV
        eZ5/+Oo+uSYA65gK9+XaEkObNZAq3NyqIiboHeNrWB5fZ7Z+a24B5y+1IqWrH2tQx+zlNXJxvWBaS
        PYELXIohCLYYv3PD1082BAmlCicHDViB2DC5DIFwm6sqqPxvS1gttzooHEI8U/iXfiUHcM4o8Z8pe
        /J6dN61w==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l1zYd-0002Hv-BS; Tue, 19 Jan 2021 22:33:03 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#695875: marked as done (Build with libedit rather than
 libreadline5)
Message-ID: <handler.695875.D695875.16110954648370.ackdone@bugs.debian.org>
References: <a2e94dea-73f1-ca64-8426-bd4e65864e44@fishpost.de>
 <20121213212730.25675.16201.reportbug@localhost>
X-Debian-PR-Message: closed 695875
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: patch
X-Debian-PR-Source: xfsprogs
Reply-To: 695875@bugs.debian.org
Date:   Tue, 19 Jan 2021 22:33:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1611095583-8797-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1611095583-8797-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 19 Jan 2021 23:30:59 +0100
with message-id <a2e94dea-73f1-ca64-8426-bd4e65864e44@fishpost.de>
and subject line Done: Build with libedit rather than libreadline5
has caused the Debian Bug report #695875,
regarding Build with libedit rather than libreadline5
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
695875: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D695875
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1611095583-8797-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 13 Dec 2012 21:27:22 +0000
X-Spam-Checker-Version: SpamAssassin 3.3.1-bugs.debian.org_2005_01_02
	(2010-03-16) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=4.0 tests=BAYES_00,FOURLA,HAS_PACKAGE,
	MURPHY_DRUGS_REL8,RCVD_IN_PBL,RCVD_IN_SORBS_DUL,RDNS_DYNAMIC,SPF_SOFTFAIL,
	XMAILER_REPORTBUG,X_DEBBUGS_CC autolearn=ham
	version=3.3.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 6; hammy, 147; neutral, 41; spammy, 1.
	spammytokens:0.960-+--(unknown) hammytokens:0.000-+--(unknown),
	0.000-+--(unknown), 0.000-+--(unknown), 0.000-+--(unknown), 0.000-+--(unknown)
Return-path: <nick.black@sprezzatech.com>
Received: from z65-50-38-158.ips.direcpath.com ([65.50.38.158] helo=[127.0.0.1])
	by buxtehude.debian.org with esmtp (Exim 4.72)
	(envelope-from <nick.black@sprezzatech.com>)
	id 1TjGJO-0007Y3-9A
	for submit@bugs.debian.org; Thu, 13 Dec 2012 21:27:22 +0000
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
From: Nick Black <nick.black@sprezzatech.com>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: Build-Depend on libreadline6 rather than libreadline5
Message-ID: <20121213212730.25675.16201.reportbug@localhost>
X-Mailer: reportbug 6.4.3
Date: Thu, 13 Dec 2012 16:27:30 -0500
X-Debbugs-Cc: dank@qemfd.net
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 3.1.9
Severity: normal
Tags: patch

Dear Maintainer,

Hello! During development of SprezzOS, I noticed that the xfsprogs
package Build-Depends on

	     libreadline-gplv2-dev | libreadline5-dev

libreadline5-dev no longer exists in the archive; the current
implementation is libreadline6-dev. Please make this change, so that
machines with libreadline6-dev installed can build the package.

-- System Information:
Debian Release: turing-β/sid
  APT prefers unstable
  APT policy: (500, 'unstable'), (1, 'experimental')
Architecture: amd64 (x86_64)

Kernel: Linux 3.7.0 (SMP w/8 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages xfsprogs depends on:
ii  libblkid1     2.22.1-SprezzOS3
ii  libc6         2.13-37
ii  libreadline5  5.2-12
ii  libuuid1      2.22.1-SprezzOS3

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.51-8
pn  attr     <none>
pn  quota    <none>
pn  xfsdump  <none>

-- no debconf information

------------=_1611095583-8797-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 695875-done) by bugs.debian.org; 19 Jan 2021 22:31:04 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 14; hammy, 118; neutral, 16; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:78.0,
	0.000-+--sourceversion, 0.000-+--source-version, 0.000-+--SourceVersion
Return-path: <bastiangermann@fishpost.de>
Received: from mail-wr1-x436.google.com ([2a00:1450:4864:20::436]:36540)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1l1zWh-0002AR-QT
	for 695875-done@bugs.debian.org; Tue, 19 Jan 2021 22:31:04 +0000
Received: by mail-wr1-x436.google.com with SMTP id 6so13983193wri.3
        for <695875-done@bugs.debian.org>; Tue, 19 Jan 2021 14:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5dqybwTQ3p2Cii/r9O0dHIN5whU/SUM2GPK8aCJPbEs=;
        b=pTFgZ76l8eXbGQgOxNF7yG4sjwvgXfOWnFH3pvjqnApFYGslYoNBSkxIcUQKEeOXF7
         t98SL/9xQmFoLzrW0v/Zj486ol6MdlJVRu6jJCkPZ0ElsmNwdR0HB7gve7fkwp29TiwB
         6ABLfG6WmsfgcJEJLrqt6staPYnGO5QuVc1Wj+I769A0Ez2NISzvu/zxxGttQGYNXLG3
         tbwwmH1UwGhAPP8IlDQT6p/WWrrYh1YHuYk74TpMUNmMWllm3hDxpjea5X+reK+Tfdnd
         YAiBfdGa16vR8T9wsu9o9CyDqxdpaAYtbkk5QGuAWqbbg1hzvTrUHkMpXp3pBvomb/uA
         x1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5dqybwTQ3p2Cii/r9O0dHIN5whU/SUM2GPK8aCJPbEs=;
        b=gzuakGMGuN4AIQT5QhUSoNgAM8IvZIqCFV7cdh+s7XR0thRRKVXKscbO4ktqPToG+h
         7UKq5ypYEWsqUZv+UZ59sWtQ/aTAFv7fvpgLfMLVZ1DHh0cDxa7L13VMOXmdOR+wtB5G
         5djmrwvWtPcSP7Qjpmx+DQadHVbKm+fFGPQkumsYru6dRu3rkVsXx8V0jt2Ln0RyrhCE
         mgbcrREFUJZKd8ablfkQ7qvRhmd50rWR3tLk0yrUqjbeGRh2RAJG4+W28F74VfiLEdD3
         qjp0fnMGOqET/Pts8XWNyrmy7usc0IMHQ/xIQHtLu6ERmhrPIxMsahBowaSd2sNx9eAf
         nhMQ==
X-Gm-Message-State: AOAM533EVw/rKICRB9w/Mvmfwa4X5uTTsgn8xMYdbMeRiWYRFHsT2esL
	bGnPhOFSmr+l3O/z279c4pLK2TDvRZzdRaAx
X-Google-Smtp-Source: ABdhPJz3QUwymRk1mhk6LG28O3DaebFMiDMeqE9ccXq/wwB9gAsxu2AVh3ayi2cZ2K0ImwmZhObamA==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr6325104wru.215.1611095461195;
        Tue, 19 Jan 2021 14:31:01 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id h16sm237445wmb.41.2021.01.19.14.31.00
        for <695875-done@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 14:31:00 -0800 (PST)
To: 695875-done@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: Done: Build with libedit rather than libreadline5
Message-ID: <a2e94dea-73f1-ca64-8426-bd4e65864e44@fishpost.de>
Date: Tue, 19 Jan 2021 23:30:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Source: xfsprogs
Source-Version: 5.10.0-2
------------=_1611095583-8797-0--
