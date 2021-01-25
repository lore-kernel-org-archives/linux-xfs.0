Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BF7C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 22:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76BD9207B7
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 22:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbhAYW0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732967AbhAYVhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 16:37:25 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C65C0613ED
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 13:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=sP3cPFVs0lhP5FE+7SNDwOfGoahTwcRHGbYYGbus4qM=; b=pd1W79dEloKnauJHGH4nYcA6+v
        wx1EkmCIUDmzz1KHT/fu8u7JAczOc+Zi/HYRDD62XoKCWulDXxl/fhziR7iLt5RlYJ1yaj3LadpfC
        kF39pNEfPjxigjY2b9oCbfRkxJoH4s908EwX8iJUhbxrjEynz0Z4L8WwklSMl9mICSe8zC2O0v7TI
        5W49hHFqDdMTzuXaHf/RCzbP2/2fwMhg6POEeO/OYvcUp1WXYArdzRy+YGoPO0xWAhbcbzKRM4wfh
        AVTGGavKhA9QDZ9FqtJ3vZZkIaoSqQ8Ylt5FJUOfby+DYoJrf/it7c0ZiA24YGdh29+vx2+TiS0bD
        oezfpGKA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l49Wo-0007pX-Iy; Mon, 25 Jan 2021 21:36:06 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#898700: marked as done (xfs_quota help text mentions wrong
 command option)
Message-ID: <handler.898700.D898700.161161037428472.ackdone@bugs.debian.org>
References: <6e41890a-0e3b-0c3a-e1a0-08175c1260b0@fishpost.de>
 <1fb24cea-26f1-8814-2966-2be73608925c@rug.nl>
X-Debian-PR-Message: closed 898700
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: patch
X-Debian-PR-Source: xfsprogs
Reply-To: 898700@bugs.debian.org
Date:   Mon, 25 Jan 2021 21:36:06 +0000
Content-Type: multipart/mixed; boundary="----------=_1611610566-30092-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1611610566-30092-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Mon, 25 Jan 2021 22:32:48 +0100
with message-id <6e41890a-0e3b-0c3a-e1a0-08175c1260b0@fishpost.de>
and subject line xfs_quota help text mentions wrong command option
has caused the Debian Bug report #898700,
regarding xfs_quota help text mentions wrong command option
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
898700: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D898700
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1611610566-30092-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 15 May 2018 10:22:16 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.1-bugs.debian.org_2005_01_02
	(2015-04-28) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=4.0 tests=BAYES_00,EMPTY_BODY,
	HAS_PACKAGE,MURPHY_DRUGS_REL8,RCVD_IN_DNSWL_MED,SPF_PASS,TXREP autolearn=ham
	autolearn_force=no version=3.4.1-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 108; hammy, 122; neutral, 38; spammy,
	0. spammytokens: hammytokens:0.000-+--H*UA:52.7.0, 0.000-+--H*u:52.7.0,
	0.000-+--Nru, 0.000-+--nmu1, 0.000-+--H*u:x86_64
Return-path: <h.e.noordhof@rug.nl>
Received: from smtp5.rug.nl ([129.125.60.5])
	by buxtehude.debian.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <h.e.noordhof@rug.nl>)
	id 1fIX60-0001M4-CM
	for submit@bugs.debian.org; Tue, 15 May 2018 10:22:16 +0000
Received: from mail-wr0-f198.google.com ([172.23.16.207])
	by smtp5.rug.nl (8.14.9/8.14.9) with ESMTP id w4F9kuA3023899
	for <submit@bugs.debian.org>; Tue, 15 May 2018 11:46:56 +0200
Received: by mail-wr0-f198.google.com with SMTP id p7-v6so11686365wrj.4
        for <submit@bugs.debian.org>; Tue, 15 May 2018 02:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:openpgp:autocrypt:to:message-id
         :date:user-agent:mime-version:content-language;
        bh=ZeTZHIjLB/lzLFNd4YPA81JHgcaVOOcvL/Rl2C1rbPo=;
        b=Yw5l2l5tOXUPd7WeETv3iJfD6OQZzbxcV9G0TKsgm6IRxi3KAAosRQR8nRRDifJlJB
         kzNfczBQ3j4BNF/1on6Mt5PMvKzwSNRIEvUReu5kfqh7VBvQI1B4EXV4dI+2PoiaXX+M
         NQCxdOpz6nwWIF6kGkYlUGND6DM+p3lfGHKBkKF79RrUN/jy6c+14xaQMf55mvDFZWQs
         IANCkwLtJ9V/hZ5snNzkEa0NRYG74YGSgJWyHejwlNflLg6Nee9w0lUICR9Yds8rK/ci
         jl3hwq1d4Yow07nSMJrp4JynRDVBs2MTCF1towrBpYtq/ZuKmy2+fOJsq5VvdGKTp4Yw
         viFQ==
X-Gm-Message-State: ALKqPwe3JgbXFRQEXfsDeAcA0hx3EbAExZkTHnVmeLchr0dmRaVbdI30
	3xGPUh9ghlykB6PEt0z+kmpv/rSaacW/LwNML5tgA/RRgSOK2qw2OrHUcmMRR1W5dHQDu7fHklA
	I6sMxlgjOp7L7h+y3
X-Received: by 2002:a50:d7d7:: with SMTP id m23-v6mr16959479edj.19.1526377616172;
        Tue, 15 May 2018 02:46:56 -0700 (PDT)
X-Google-Smtp-Source: AB8JxZoR0vWSXdPpShpeZEt3XH5ScAfmwuUeR3RfEziG3k+Nymgt8hMj81G0hBQo/7aKVrq+xiJMyg==
X-Received: by 2002:a50:d7d7:: with SMTP id m23-v6mr16959462edj.19.1526377616036;
        Tue, 15 May 2018 02:46:56 -0700 (PDT)
Received: from [129.125.249.8] (bwp-249-8.rcuwp.rug.nl. [129.125.249.8])
        by smtp.gmail.com with ESMTPSA id d89-v6sm6043166edc.58.2018.05.15.02.46.55
        for <submit@bugs.debian.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 May 2018 02:46:55 -0700 (PDT)
From: Heiko Noordhof <h.e.noordhof@rug.nl>
Subject: xfs_quota help text mentions wrong command option
Openpgp: preference=signencrypt
Autocrypt: addr=h.e.noordhof@rug.nl; prefer-encrypt=mutual; keydata=
 xsBNBFNqJ+sBCAC2DjckTn+lfh0dxjajywIqImjuD646nvjNaA8aUNQD+xQkzpgc+zI1p3Q8
 LGc+AUu8lnsIfmgH6jwbLGmkLXePpJWgvi1lKm9x0Y8KrZKjyq2LbXvM4IYwdkEIIH/WJkBb
 Kzh0K0Zya9yjhRHVZN0qFNzeJEDjORcpxfLjxJ7RefrkZ1jAyasghSFHgBCgXqbLPGabDg+V
 VL6TcDM3jR1A9wnWWAWpv23kpNq6kR478hIEsBhFDBDkE5pAHb3SMoyeR7x5Ah5XjQoUQ1r2
 NkEgFvEeAYlEQ5qeLy2rF3We9WKVZjzXblGGxaZ6EaVxjW9VU1Qf30rHDmvBnwCZ0iaXABEB
 AAHNJEhlaWtvIE5vb3JkaG9mIDxoLmUubm9vcmRob2ZAcnVnLm5sPsLAeAQTAQIAIgUCU2on
 6wIbAwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ53ibUOK3M2rF3Af/WV/t94HIEtUr
 bo7l/qMwHivB37TFmvz/DMNLwxIncnwPctTI5W/uAwIuRI+CYfY5VRcW63TAPDj+AghQQXNc
 XHsFYMhnkOw9/tbgJWBtmzGinvhX7tOc+1yoCCD/dV0Fd0F1mMX5guwIT4uIIXJNn6LZHL9k
 vEWGMMBPWZQT0Ba7nJk0dDa8rMz0tg8QxgZ9M8uaYGcmLDMPFZj6Zh1w0vxG+1hBT9HeDpLu
 ktEuTM7s+nYuIQNlg+IFxOhux8l8Gfi/F3VMIsd81IB+8z0cvwsD5CifmSbJa8GRbJ2uCM8t
 kIZyUH077r749FUQ5ruWgh1bJglrOzVWIWmAoD7H+87ATQRTaifrAQgAyDEx/b0KYfuYJ/vL
 7wOYFJgkLK4fA76rkAPFaHJsZ2K+se3C3rTUPOSZWVc//GayhbJcsIabqhCXCAwmD2BKqu9R
 VXvFDhUIVWw0zmTpm251JcNtYgc9ErnqfmaRXQkP95Rsso0PgDdmyX4X/92H9MI9woCrfs3N
 G054orw5qOfFXxSjdsR/G/YvSrGF79IKA56uZ92gW8ZDgl90P8ohbSrGpcFF8pbByE9KmZya
 IM6jOrir4MgcKbgcokHeW04vzpefE74kJI/DgsepepRcmGIwrsZYSylXNPGviNh3wHQsR6mf
 1oxJ/tDrO5Kr2IfDQ34CQ7JPWunvT5qfcvdGiQARAQABwsBfBBgBAgAJBQJTaifrAhsMAAoJ
 EOd4m1DitzNqVkkIAJUNQlczKY/UFLf1rCOdC6VKpTN2+TZfkc5FjiqkgVu0IowxyWmxwoDO
 uVRh2vCN9ZOeemOqyQ3+g7m6KvHpu6fDQl7xuYnlbu8E2D5IMxYzGi5z5ZlyS6MtbkWbcOhd
 qvfJmAY7cSoJ7kGtC3ldrtHweu6qpLDw4FCSEWILfeRrhTICxaZi4PY0hflsCcCyjEREjIwN
 6MQuaYyy4mDyY0jJCh9gGHqIWSA3XG7udqZ7+exGRdQ38Om0V/QKHbZHo+9qvXbu/tZjTTc6
 eSHPD5rdw1MOqyzIM14rpk0/bnsXVBRjWX6X3vwML0F3J4SYglPq+KItsKwBXhHljpdPThk=
To: submit@bugs.debian.org
Message-ID: <1fb24cea-26f1-8814-2966-2be73608925c@rug.nl>
Date: Tue, 15 May 2018 11:46:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------698798D3F83FBEBA6BAB7600"
Content-Language: en-US
X-Virus-Scanned: clamav-milter 0.99.2 at smtp5
X-Virus-Status: Clean
X-Greylist: delayed 2117 seconds by postgrey-1.36 at buxtehude; Tue, 15 May 2018 10:22:16 UTC
Delivered-To: submit@bugs.debian.org

This is a multi-part message in MIME format.
--------------698798D3F83FBEBA6BAB7600
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Package: xfsprogs
Version: 4.9.0+nmu1
Tags: patch

The help text of the "project" command in xfs_quota says:

"A managed tree must be setup initially using the -c option with a project."

This is not correct: the -s option (as opposed to -c) will set up a
managed tree.

To reproduce:

root@bwp-249-8:~# xfs_quota -x
xfs_quota> help project

[..snip..]
A managed tree must be setup initially using the -c option with a
project.
[..snip..]

Trivial patch attached.

--------------698798D3F83FBEBA6BAB7600
Content-Type: text/x-patch;
 name="fix-quota-project-help-text.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="fix-quota-project-help-text.patch"

diff -Nru xfsprogs-4.9.0+nmu1.orig/quota/project.c xfsprogs-4.9.0+nmu1/qu=
ota/project.c
--- xfsprogs-4.9.0+nmu1.orig/quota/project.c	2017-01-05 23:05:55.00000000=
0 +0100
+++ xfsprogs-4.9.0+nmu1/quota/project.c	2018-05-15 11:31:36.508219567 +02=
00
@@ -55,7 +55,7 @@
 " and subdirectories below it (i.e. a tree) can be restricted to using a=
\n"
 " subset of the available space in the filesystem.\n"
 "\n"
-" A managed tree must be setup initially using the -c option with a proj=
ect.\n"
+" A managed tree must be setup initially using the -s option with a proj=
ect.\n"
 " The specified project name or identifier is matched to one or more tre=
es\n"
 " defined in /etc/projects, and these trees are then recursively descend=
ed\n"
 " to mark the affected inodes as being part of that tree - which sets in=
ode\n"

--------------698798D3F83FBEBA6BAB7600--

------------=_1611610566-30092-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 898700-done) by bugs.debian.org; 25 Jan 2021 21:32:54 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 16; hammy, 121; neutral, 19; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:78.0,
	0.000-+--UD:gappssmtp.com, 0.000-+--UD:20150623.gappssmtp.com,
	0.000-+--H*RU:2003
Return-path: <bastiangermann@fishpost.de>
Received: from mail-ed1-x536.google.com ([2a00:1450:4864:20::536]:36834)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1l49Ti-0007Oz-5d
	for 898700-done@bugs.debian.org; Mon, 25 Jan 2021 21:32:54 +0000
Received: by mail-ed1-x536.google.com with SMTP id d2so13759890edz.3
        for <898700-done@bugs.debian.org>; Mon, 25 Jan 2021 13:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=j4qwvyZxnzqkKk1dNYE+ojBgRoY9usyFN5yNrhf7HuA=;
        b=WE+vd9PjhJ+FeiCitt+2HDK5H6WZvOi4CmR6VS4DoWUjuvQZyvGHjskBI57BJonpcQ
         v0QRlRtli2tEnnXVWk5kGOjAakWUIDkELukALIXik8y7Vt9OneuNLDTVQncfEw0v5Vjr
         3iOQa9M6+xWZnDbxD9tshGlMxnSXL82UhnZuZjTBvS/kEpudtDFlx05Qk+esLjPqtVtm
         wl0BAM/nNUnf4KOuT71uJr4W/8kBKw2c+SXOwl24R+J5CZc1xT5Gt210kaewdOc7eH4a
         3m6cvV/36sO5Zq7M7hxPppaplSBCbXtyLhmZj+n0+gbTj7EdDkeklnTZgtu9tTnuM36F
         baYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=j4qwvyZxnzqkKk1dNYE+ojBgRoY9usyFN5yNrhf7HuA=;
        b=hsY5CqT4lagp+0EEyT1lYtm82+tWVKAP6CEtJnDMrM7maCn74dkRIqxsJsiY4ld5C1
         lLR79IlDb+tQfPAopOOa8Ij1lbkyjzwsV6EX+IskUFpekNDWvgjduKJl/pApeMwcCa/C
         DxGwio6sPlQhQO6o0FTyBb4bG4S3e81hzx1axXcvTqDcYZyjAEMhPDNIHUo1MM17UEq5
         vfBXGjuZPgdrJEcWyjZXWna2BpGLRnf2dna8RbX9iTVp+JwoJNVnXCZ/g/xEAuwy9icA
         KKtFmJ8xHndqeVYJqeaPcS61/Kj9ZU5/b8hA0DrMxA7EiGV20vN5hKra9qQKbSzKRjDS
         l6fg==
X-Gm-Message-State: AOAM531xmCAwhkvOjf3+equCkAylgjKo5mYygPnvlo9QYyFlyp6HUXmX
	sxJ+r455rnflni7iT6865rdl1gunFOIaaj2r
X-Google-Smtp-Source: ABdhPJycgP5i5jI6fzbTNfeYGEa2Q5kdFORg8kdezgn/S+YjRN75nzeba944uI5B681SkWOz4vhvRg==
X-Received: by 2002:a05:6402:31bb:: with SMTP id dj27mr2109021edb.285.1611610371244;
        Mon, 25 Jan 2021 13:32:51 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id u18sm3565607ejc.76.2021.01.25.13.32.50
        for <898700-done@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 13:32:50 -0800 (PST)
To: 898700-done@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: xfs_quota help text mentions wrong command option
Message-ID: <6e41890a-0e3b-0c3a-e1a0-08175c1260b0@fishpost.de>
Date: Mon, 25 Jan 2021 22:32:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit

Version: 5.6.0-1
Tags: upstream

This is fixed upstream and will be included in the bullseye release. The 
bug is not critical and will not be applied on any older release.
------------=_1611610566-30092-0--
