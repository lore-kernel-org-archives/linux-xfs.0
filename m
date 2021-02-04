Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEF5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 22:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EB4864FAD
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 22:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBDWPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 17:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhBDWPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 17:15:46 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C5CC061786
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 14:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=oaUQJRi8NI5S5sIN4/scgqaUDvMuOCXn/8NmkPMko3w=; b=pj54rXdd3v4VV/P/pu3IvQG00i
        LD5HQcrPKzEwMYFVw9gGr9kg5y4QyAxfcNSrdFakp8bb2d4Lku2w89Drb76GqFwrhk+fF+9eg6cZ3
        1XnRmQKSQ666mPMLu6XOcioY4EuZVQV3CZcb9BFGJplXFN4qydKQUaRErwPZ/5wuFlqHiTX2beK/B
        kDOMFGYAm2ZfnCprvjuTjqysvoZOpPJ/IsSeJ09+6xH/Jri9lccCJ7YHi3dO9o1TcgDf5Pd/TyWtV
        KwLPfyUjUgJ+7D0AEHUpaYZPM62zizIQ82tT9fA4qPyippe4MKfcKLZ806duIe2x8SgM8iEFcqLfV
        ih1Q4A2A==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7mtz-0001f1-5W; Thu, 04 Feb 2021 22:15:03 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#465733: marked as done (xfsprogs: xfs_check SEGV)
Message-ID: <handler.465733.D465733.16124767094283.ackdone@bugs.debian.org>
References: <b41ca82b-6f60-acda-6c6b-0f4e209d8c23@fishpost.de>
 <20080214114228.9734.77682.reportbug@aeon.coker.com.au>
X-Debian-PR-Message: closed 465733
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: upstream
X-Debian-PR-Source: xfsprogs
Reply-To: 465733@bugs.debian.org
Date:   Thu, 04 Feb 2021 22:15:03 +0000
Content-Type: multipart/mixed; boundary="----------=_1612476903-6371-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1612476903-6371-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Thu, 4 Feb 2021 23:11:43 +0100
with message-id <b41ca82b-6f60-acda-6c6b-0f4e209d8c23@fishpost.de>
and subject line Re: Updating bug status
has caused the Debian Bug report #465733,
regarding xfsprogs: xfs_check SEGV
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
465733: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D465733
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1612476903-6371-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 14 Feb 2008 11:42:32 +0000
X-Spam-Checker-Version: SpamAssassin 3.1.4-bugs.debian.org_2005_01_02 
	(2006-07-26) on rietz.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=4.0 tests=BAYES_00,FOURLA,HAS_PACKAGE 
	autolearn=no version=3.1.4-bugs.debian.org_2005_01_02
Return-path: <russell@coker.com.au>
Received: from smtp.sws.net.au ([61.95.69.6] helo=nospam.sws.net.au)
	by rietz.debian.org with esmtp (Exim 4.63)
	(envelope-from <russell@coker.com.au>)
	id 1JPcU4-0004x0-BW
	for submit@bugs.debian.org; Thu, 14 Feb 2008 11:42:32 +0000
Received: from localhost (localhost [127.0.0.1])
	by nospam.sws.net.au (Postfix) with ESMTP id CD12918DC2;
	Thu, 14 Feb 2008 22:42:29 +1100 (EST)
Received: from nospam.sws.net.au ([127.0.0.1])
	by localhost (etbe.coker.com.au [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id U7A+opOYPnUy; Thu, 14 Feb 2008 22:42:29 +1100 (EST)
Received: from aeon.coker.com.au (localhost [127.0.0.1])
	by nospam.sws.net.au (Postfix) with ESMTP id 6FA3C18DBB;
	Thu, 14 Feb 2008 22:42:29 +1100 (EST)
Received: by aeon.coker.com.au (Postfix, from userid 1001)
	id 4114620D3C; Thu, 14 Feb 2008 22:42:28 +1100 (EST)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Russell Coker <russell@coker.com.au>
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: xfsprogs: xfs_check SEGV
Message-ID: <20080214114228.9734.77682.reportbug@aeon.coker.com.au>
X-Mailer: reportbug 3.31
Date: Thu, 14 Feb 2008 22:42:28 +1100
Delivered-To: submit@bugs.debian.org

Package: xfsprogs
Version: 2.8.11-1
Severity: critical
Justification: breaks the whole system

I have a filesystem which causes a SEGV when I try to check it.

The problem started when I unexpectedly powered the machine down causing some
data loss.  When I booted it up again the kernel gave errors about corrupted
data structures (which I unfortunately didn't make a note of).  Now when I
try to check it (on another machine) it gives the following.

NB The filesystem has no secret data, I would be happy to give you a copy, I
could put it on a machine on the net that you can access or give you an IDE
disk with a copy if you are in Melbourne.

# xfs_check /dev/sda5
agi unlinked bucket 59 is 891 in ag 2 (inode=8389499)
agi unlinked bucket 6 is 134 in ag 3 (inode=12583046)
agi unlinked bucket 18 is 338 in ag 3 (inode=12583250)
agi unlinked bucket 51 is 179 in ag 3 (inode=12583091)
agi unlinked bucket 8 is 136 in ag 5 (inode=20971656)
agi unlinked bucket 10 is 138 in ag 5 (inode=20971658)
agi unlinked bucket 11 is 139 in ag 5 (inode=20971659)
agi unlinked bucket 14 is 142 in ag 5 (inode=20971662)
agi unlinked bucket 15 is 143 in ag 5 (inode=20971663)
agi unlinked bucket 16 is 144 in ag 5 (inode=20971664)
agi unlinked bucket 17 is 145 in ag 5 (inode=20971665)
agi unlinked bucket 19 is 147 in ag 5 (inode=20971667)
agi unlinked bucket 23 is 151 in ag 5 (inode=20971671)
agi unlinked bucket 27 is 155 in ag 5 (inode=20971675)
can't seek in filesystem at bb 20002504712
can't read btree block 16384/1
extent count for ino 50332175 data fork too low (0) for file format
bad nblocks 12 for inode 50332175, counted 1
bad nextents 9 for inode 50332175, counted 0
no . entry for directory 50332175
no .. entry for directory 50332175
/usr/sbin/xfs_check: line 28:  9686 Segmentation fault      xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1


-- System Information:
Debian Release: 4.0
  APT prefers stable
  APT policy: (500, 'stable')
Architecture: i386 (i686)
Shell:  /bin/sh linked to /bin/bash
Kernel: Linux 2.6.18-5-686
Locale: LANG=en_AU.UTF-8, LC_CTYPE=en_AU.UTF-8 (charmap=ANSI_X3.4-1968) (ignored: LC_ALL set to C)

Versions of packages xfsprogs depends on:
ii  lib 2.3.6.ds1-13etch4                    GNU C Library: Shared libraries
ii  lib 5.2-2                                GNU readline and history libraries
ii  lib 1.39+1.40-WIP-2006.11.14+dfsg-2etch1 universally unique id library

xfsprogs recommends no packages.

-- no debconf information



------------=_1612476903-6371-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 465733-done) by bugs.debian.org; 4 Feb 2021 22:11:49 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	TXREP,VERSION autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 22; hammy, 132; neutral, 33; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:78.0,
	0.000-+--UD:20150623.gappssmtp.com, 0.000-+--UD:gappssmtp.com,
	0.000-+--H*RU:2003
Return-path: <bastiangermann@fishpost.de>
Received: from mail-ed1-x534.google.com ([2a00:1450:4864:20::534]:45028)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1l7mqq-00016q-Ol
	for 465733-done@bugs.debian.org; Thu, 04 Feb 2021 22:11:49 +0000
Received: by mail-ed1-x534.google.com with SMTP id q2so3139929eds.11
        for <465733-done@bugs.debian.org>; Thu, 04 Feb 2021 14:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:subject:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=im3wbcY5kPr6luTVfuWUJtRQS5x5hGgQ7YQryrqT7gI=;
        b=wf6cMt7XYeeQ38DB2xmo0Zc03+O5xlxvZQCnGpvScsK5c+JhGIUjeD+e+VdFw8o+Sk
         JBPOaYh02lctX9zITneDqHiSJyHBM+Eo16X5GA3A/itMqMtgCKVLKn3J/hd0h2Ct3MqV
         sUvOK7smjVshkVB2OgVkyb/3HPkgXKVKaUoWrT2zXYx32M48gp3M2A+lG8i88TrSD/qD
         kerYeFC46HxReIWr0nmt6jPSI9bQ2kHNdVj91aCpGRUO0Hhh9VFDNRo8qri366zwA/mQ
         hYUbHx6oIqGGIGBfTZ6DXQLdzEWduQURLsotfFyg9+VO6L7i4IpVHvc4oDnd8S8X8A2X
         0rSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=im3wbcY5kPr6luTVfuWUJtRQS5x5hGgQ7YQryrqT7gI=;
        b=Jr9OrUYrC09sR9jZnvrY4VoVs1V2jJ4002ASX93fEr2TCFIuZP5SSTlSAKoO9fe6HG
         NcM9+7jRSU40M+I8j/skcJZUlspcY9F210Bho2FWfGfmz2QSmqDl4z5aUBkC2eaNOvzS
         cL7Qs/MGrKoe/ius+Nfyf4uMGkZrwfy/hghJL/i7gb5PVREcdcvp947RUUqvShD4Hn/6
         Rk3yvmDf33So/X6AvtV603QIdps6S4knaGbulu6a3nQt6E0z/SJwgcLUbBITbKA5W5C4
         drd7HIaxVjLLHJDOKAnMEeu4CoO3QAjLNImP0IckoJn5xllnn7bcf4uwu90gX47U/Bhd
         agZA==
X-Gm-Message-State: AOAM531+d9unLQ6O5X/jQMeduj4A5F7LWsyhk8KDQYBCvWpANnE3vNY9
	Ou7A1taY3XuIOYcADCnaYTm5PE2L7jb8xPtg
X-Google-Smtp-Source: ABdhPJx4MGTkf7brqPNJKX1Y8hyi8BTOFLn1XhAFnM/srz7RNmLBW27exwgicFmnvvOdUAFG/nM0Ag==
X-Received: by 2002:a50:c403:: with SMTP id v3mr652447edf.217.1612476705073;
        Thu, 04 Feb 2021 14:11:45 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id b3sm3094960edw.14.2021.02.04.14.11.44
        for <465733-done@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 14:11:44 -0800 (PST)
To: 465733-done@bugs.debian.org
References: <200802212158.01744.russell@coker.com.au>
 <56230.192.168.3.1.1204315305.squirrel@mail.aconex.com>
 <56230.192.168.3.1.1204315305.squirrel@mail.aconex.com>
Subject: Re: Updating bug status
From: Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <b41ca82b-6f60-acda-6c6b-0f4e209d8c23@fishpost.de>
Date: Thu, 4 Feb 2021 23:11:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <56230.192.168.3.1.1204315305.squirrel@mail.aconex.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Version: 3.2.1

On Sat, 1 Mar 2008 07:01:45 +1100 (EST) nscott@aconex.com wrote:
> In the long
> run, theres also discussion (upstream) of replacing xfs_check entirely by an
> "xfs_repair -n" wrapper, which would resolve this issue entirely (xfs_check
> has other issues beyond this one, in particular its memory footprint can be
> extreme compared to current xfs_repair).   But, thats not on the immediate
> horizon as yet.

xfs_check was replaced by xfs_repair long ago.
------------=_1612476903-6371-0--
