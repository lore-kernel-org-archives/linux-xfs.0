Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788A0C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 22:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A6A604D2
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 22:21:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhI0WWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 18:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbhI0WWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 18:22:45 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2926CC061575
        for <linux-xfs@vger.kernel.org>; Mon, 27 Sep 2021 15:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=RXvfkinUBXsiXC0xeCUlahKLwcV+jjcnbZAdSqc3cB8=; b=uVaApQTz1hYedGn8AQJg4+ufuM
        UvcNUlWjmoTG91rT41Pd5jMH4CFL99Uq2XlwHAcNSpSb8jbS1/FqNkS6Pjb3B6YIlly7LZhtTGJLs
        OGoMY/oZ9L0rhxqQ6WdPwsj37XewwphIcBVa+ZP2HMmfdfi3OuQRopCfTqDHPuN3mXWJEtNqVFSgw
        OTwJTbiU7Vc9NqnEsU2mtnh4s1llaMgsC63XQBpvI06x0zYQLz+Ocd7IVINHPonB9AtkG0HmkMfvl
        k5D8/ovUnD+RaOvTu+DgvsyGKfHn571s40ZEl8qV3Nn4XR4jfwwF4FCYxy3jucg0ButepCx2JSDOE
        jwvLB8pA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mUyzg-00013S-UF; Mon, 27 Sep 2021 22:21:04 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#987093: marked as done (xfsprogs: need config.guess/sub
 update for riscv64)
Message-ID: <handler.987093.D987093.16327811623677.ackdone@bugs.debian.org>
References: <4a3cbac5-64dd-b195-2e82-7c43091fad45@debian.org>
 <161865994973.3673989.14168990086972212241.reportbug@ohm.local>
X-Debian-PR-Message: closed 987093
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: ftbfs patch upstream
X-Debian-PR-Source: xfsprogs
Reply-To: 987093@bugs.debian.org
Date:   Mon, 27 Sep 2021 22:21:04 +0000
Content-Type: multipart/mixed; boundary="----------=_1632781264-4054-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1632781264-4054-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 28 Sep 2021 00:19:16 +0200
with message-id <4a3cbac5-64dd-b195-2e82-7c43091fad45@debian.org>
and subject line xfsprogs: need config.guess/sub update for riscv64
has caused the Debian Bug report #987093,
regarding xfsprogs: need config.guess/sub update for riscv64
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
987093: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D987093
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1632781264-4054-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 17 Apr 2021 11:45:53 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=4.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FOURLA,
	FROMDEVELOPER,MURPHY_DRUGS_REL8,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,TXREP,XMAILER_REPORTBUG autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 21; hammy, 150; neutral, 80; spammy,
	0. spammytokens: hammytokens:0.000-+--sk:buildd.,
	0.000-+--UD:buildd.debian.org, 0.000-+--buildddebianorg,
	0.000-+--buildd.debian.org, 0.000-+--H*M:reportbug
Return-path: <aurel32@debian.org>
Received: from hall.aurel32.net ([2001:bc8:30d7:100::1]:39344)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <aurel32@debian.org>)
	id 1lXjOa-0000k2-TL
	for submit@bugs.debian.org; Sat, 17 Apr 2021 11:45:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	 s=202004.aurel32.user; h=Date:Message-ID:Subject:To:From:
	Content-Transfer-Encoding:MIME-Version:Content-Type:Cc:From:Reply-To:Subject:
	Content-ID:Content-Description:In-Reply-To:References:X-Debbugs-Cc;
	bh=uaV+m0NGXvozQvYx92+kIrz4hE6fSx3Jpth2jGuKH+4=; b=ER3SHzp4G7YM6lsvP+w8GCnFpO
	uvQ+22Iw58uCo27Axos4RRSZ74i6L9US6HsbLvJEb8lBOfOwcwpOS5Lu6LWP+zBiMbnHl1KiwAtrs
	lnJg6FGNaeYAO7IBnBV++78fcM5mkYg9ma1cIxGB/oP3WzrAWT6BZzyfUTTfg0MNHhesZHm3q8v7s
	6fE/2+VCzNE8QdkrY2CoX+riMEUcIqE6mwDZVUqX93CAEyORWbWAxXt2OLmxSTD/YDVYSNatpiQia
	tlVvEBuiy8cWmpBYifojFH7TEslBFwb/1wcgYWIOMfhTFea9WNBZurtznGwb9aLtENYMTc+fgV2Vs
	0f4lp4CQ==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <aurel32@debian.org>)
	id 1lXjOY-0005pn-Ao; Sat, 17 Apr 2021 13:45:50 +0200
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.94)
	(envelope-from <aurel32@debian.org>)
	id 1lXjOX-00FQR1-O4; Sat, 17 Apr 2021 13:45:49 +0200
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
From: Aurelien Jarno <aurel32@debian.org>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: need config.guess/sub update for riscv64
Message-ID: <161865994973.3673989.14168990086972212241.reportbug@ohm.local>
X-Mailer: reportbug 7.10.3
Date: Sat, 17 Apr 2021 13:45:49 +0200
Delivered-To: submit@bugs.debian.org

U291cmNlOiB4ZnNwcm9ncwpWZXJzaW9uOiA1LjEwLjAtNApTZXZlcml0eTogaW1wb3J0YW50ClRh
Z3M6IGZ0YmZzIHVwc3RyZWFtIHBhdGNoCkp1c3RpZmljYXRpb246IFBvbGljeSA0LjMKVXNlcjog
ZGViaWFuLXJpc2N2QGxpc3RzLmRlYmlhbi5vcmcKVXNlcnRhZ3M6IHJpc2N2NjQKCnhmc3Byb2dz
IHVzZWQgdG8gYnVpbGQgZmluZSBvbiByaXNjdjY0IHVwIHRvIHZlcnNpb24gNS42LjAsIGJ1dCB0
aGUgbmV3CnVwc3RyZWFtIHZlcnNpb24gaW50cm9kdWNlZCBhIHJvbGxiYWNrIG9mIHRoZSBjb25m
aWcuZ3Vlc3Mvc3ViIGZpbGVzCmJhY2sgdG8gMjAxMy4gVGhpcyB2ZXJzaW9uIGlzIHdheSB0byBv
bGQgdG8gcmVjb2duaXplIHRoaXMgYXJjaGl0ZWN0dXJlLApjYXVzaW5nIGEgRlRCRlMJWzFdLgoK
VGhlIHNob3J0IHRlcm0gc29sdXRpb24gaXMgdG8gdXBkYXRlIHRob3NlIGZpbGVzIGZyb20gYXV0
b3Rvb2xzLWRldiwgYXMKcmVjb21tZW5kZWQgYnkgRGViaWFuIFBvbGljeSDCpzQuMy4gVGhpcyBp
cyB3aGF0IHRoZSBzaW5nbGUgcGF0Y2gKYmVsb3cgZG9lcywgYnkgcnVubmluZyB0aGUgZGhfdXBk
YXRlX2F1dG90b29sc19jb25maWcgY29tbWFuZCBqdXN0CmJlZm9yZSBjb25maWd1cmUuIFJlc3Rv
cmluZyB0aG9zZSBmaWxlcyBpbiB0aGUgY2xlYW4gcnVsZSBpcyBkb25lIGJ5CmRoX2NsZWFuLgoK
QXMgYSBsb25nIHRlcm0gc29sdXRpb24sIGl0IHdvdWxkIGJlIG5pY2UgaWYgdXBzdHJlYW0gY2Fu
IHNoaXAgdXBkYXRlZApmaWxlcyBpbiB0aGVpciBuZXh0IHJlbGVhc2VzLgoKVGhhbmtzLApBdXJl
bGllbgoKWzFdIGh0dHBzOi8vYnVpbGRkLmRlYmlhbi5vcmcvc3RhdHVzL2ZldGNoLnBocD9wa2c9
eGZzcHJvZ3MmYXJjaD1yaXNjdjY0JnZlcj01LjEwLjAtNCZzdGFtcD0xNjEzNDgwNjg5JnJhdz0w
CgotLS0geGZzcHJvZ3MtNS4xMC4wL2RlYmlhbi9ydWxlcworKysgeGZzcHJvZ3MtNS4xMC4wL2Rl
Ymlhbi9ydWxlcwpAQCAtNDIsNiArNDIsNyBAQAogLmNlbnN1czoKIAlAZWNobyAiPT0gZHBrZy1i
dWlsZHBhY2thZ2U6IGNvbmZpZ3VyZSIgMT4mMgogCSQoY2hlY2tkaXIpCisJZGhfdXBkYXRlX2F1
dG90b29sc19jb25maWcKIAlBVVRPSEVBREVSPS9iaW4vdHJ1ZSBkaF9hdXRvcmVjb25mCiAJJChv
cHRpb25zKSAkKE1BS0UpICQoUE1BS0VGTEFHUykgaW5jbHVkZS9wbGF0Zm9ybV9kZWZzLmgKIAl0
b3VjaCAuY2Vuc3VzCg==

------------=_1632781264-4054-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 987093-done) by bugs.debian.org; 27 Sep 2021 22:19:22 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,MURPHY_DRUGS_REL8,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	TXREP,VERSION autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 20; hammy, 120; neutral, 22; spammy,
	0. spammytokens: hammytokens:0.000-+--H*u:78.0, 0.000-+--langasek,
	0.000-+--Langasek, 0.000-+--H*RU:2003,
	0.000-+--Hx-spam-relays-external:2003
Return-path: <bastiangermann@fishpost.de>
Received: from mail-wm1-x329.google.com ([2a00:1450:4864:20::329]:37528)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1mUyy1-0000x6-P6
	for 987093-done@bugs.debian.org; Mon, 27 Sep 2021 22:19:22 +0000
Received: by mail-wm1-x329.google.com with SMTP id r83-20020a1c4456000000b0030cfc00ca5fso360722wma.2
        for <987093-done@bugs.debian.org>; Mon, 27 Sep 2021 15:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=t8YnbfR/jskXiVMfAYEgA4DsAkr0UnNEnpehiLXanMo=;
        b=ZvH6EbiFMsIP0gdfbwraF4/R6LzUDfSY2fqHvhfNB8v8je8CKEIihT8ZMioVidKowU
         oJD1xWIhH8dbiYnbWWcr7BHiEz1vWbolLixJ83IaY1V1nBXos7QtVBMSe9MX5yidLkXN
         RRM1H1FDxpm3/7gq2fnRhXBuXOWlvZr/sERkcs/x/HM5gDYJxPO6eL+ceMir13X7aVbk
         r46+t+QX+dIDslfadXc/D4IneH3ZkFmLSGgeMTac1WfykXiBQTCccEELMknmtHveh5J0
         MTdwJOjtrQUqkhkIuQQORD76mQ79aj52gO5SlEkyBNk53UjIceEgH0w6pqv/zcOCVj71
         a69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=t8YnbfR/jskXiVMfAYEgA4DsAkr0UnNEnpehiLXanMo=;
        b=5HWKBJnr5/HqRGnxQpIQC0mtLulnhs1SKrErE1wPwqnnEFNrci1fD3GDxW1jE+5TiC
         LzQzilJxIKL13VDm5lzWOcR98dtN9bjn0OW+Wx5VK62FwWuDVrDHfHUGIny4QMziXSzu
         CeMxrwp3ruyxnk394p70nysxkuuKkazyiF7LZB5FbdkgxJz2ca8k53AWPIKKI5RHRo6W
         lsYWkAPDP1uJOI1vhG4fZ6MP409JkR2+tQNCJtIGiDHWEkNleP/m9q/pA2clSa36IrF/
         ViEB2jb1ulae6fCeQI+Hp50TNeMWb2lbvTHX4AS78Mof6DbkrywHp4isRyWm4ZuHmWIp
         z6/A==
X-Gm-Message-State: AOAM5332o9hJv4kFj8YQpxA2YhkczMPzbc9Guush3WtNRCbJMDcCTZVL
	iVOBYi5F9pvBvA9Y7s9c2jAsIm3Jvs9Z7Q==
X-Google-Smtp-Source: ABdhPJzke5LrNJsk1uJhlbDN2NCelSh9tKoE4DzsojF5FGHGwV03uv7RzHNd/bbuQlmsE59rIqdYVg==
X-Received: by 2002:a05:600c:4991:: with SMTP id h17mr1454818wmp.74.1632781158511;
        Mon, 27 Sep 2021 15:19:18 -0700 (PDT)
Received: from ?IPv6:2003:d0:6f1f:7300:176a:2a16:2e65:25fe? (p200300d06f1f7300176a2a162e6525fe.dip0.t-ipconnect.de. [2003:d0:6f1f:7300:176a:2a16:2e65:25fe])
        by smtp.gmail.com with ESMTPSA id r26sm691609wmh.35.2021.09.27.15.19.17
        for <987093-done@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:19:18 -0700 (PDT)
From: Bastian Germann <bastiangermann@fishpost.de>
X-Google-Original-From: Bastian Germann <bage@debian.org>
To: 987093-done@bugs.debian.org
Subject: xfsprogs: need config.guess/sub update for riscv64
Message-ID: <4a3cbac5-64dd-b195-2e82-7c43091fad45@debian.org>
Date: Tue, 28 Sep 2021 00:19:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Version: xfsprogs/5.11.0-rc0-1

The bug was fixed via an independent patch by Steve Langasek.
------------=_1632781264-4054-0--
