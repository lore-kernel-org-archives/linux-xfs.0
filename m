Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54028C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25A3923104
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 22:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbhASWdu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jan 2021 17:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbhASWdm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jan 2021 17:33:42 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2905CC061757
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 14:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Content-Type:Date:Reply-To:
        References:Message-ID:Subject:To:From:MIME-Version:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To;
        bh=uWEsZmeT0HtykdOVPIbdZjo7tW6vGPirv0D1xFLqVA0=; b=g3Z5SeZNEm5UNCo0TWpqNNWgaE
        8ZhF6USn2bTsS+JQHUV/vnylKFb1WhHaIftEqOF7ecpIELtoAQAPpwlU3Afie6ygboTdHtOq3fJM2
        ls1hr+hWofDs4g71lMNolRRRLjdPJcVuwSX6w+xrWVEy47/KpD9e0r8Lk1mEc5h07wt1apWlqShfc
        wIUVBGBjjooLXKe9xCc6ba0ArOht3PUjSnNEyYdHhgchdXuD6EdWOL1nt5dIVq2llhlEdLTrAV/DS
        knUcyDYEi/Plw/TY8w4IOqIxRJ1d8+mmhApA5CjS4/nfwswQNu3BLAKNbYqHGCjKkSYFzNxVdGCjC
        3YoyyWqQ==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l1zYf-0002IC-2g; Tue, 19 Jan 2021 22:33:05 +0000
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
X-Loop: owner@bugs.debian.org
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
Subject: Bug#976683: marked as done (xfsprogs: Import new upstream version)
Message-ID: <handler.976683.D976683.16110955418641.ackdone@bugs.debian.org>
References: <c4d44454-6b3f-c0df-c660-b625750d971c@fishpost.de>
 <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de>
X-Debian-PR-Message: closed 976683
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Source: xfsprogs
Reply-To: 976683@bugs.debian.org
Date:   Tue, 19 Jan 2021 22:33:05 +0000
Content-Type: multipart/mixed; boundary="----------=_1611095585-8809-0"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format...

------------=_1611095585-8809-0
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Your message dated Tue, 19 Jan 2021 23:32:17 +0100
with message-id <c4d44454-6b3f-c0df-c660-b625750d971c@fishpost.de>
and subject line Done: xfsprogs: Import new upstream version
has caused the Debian Bug report #976683,
regarding xfsprogs: Import new upstream version
to be marked as done.

This means that you claim that the problem has been dealt with.
If this is not the case it is now your responsibility to reopen the
Bug report if necessary, and/or fix the problem forthwith.

(NB: If you are a system administrator and have no idea what this
message is talking about, this may indicate a serious mail system
misconfiguration somewhere. Please contact owner@bugs.debian.org
immediately.)


--=20
976683: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D976683
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

------------=_1611095585-8809-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at submit) by bugs.debian.org; 6 Dec 2020 22:13:46 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 12; hammy, 135; neutral, 21; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3,
	0.000-+--UD:gappssmtp.com, 0.000-+--UD:20150623.gappssmtp.com,
	0.000-+--H*RU:2003, 0.000-+--Hx-spam-relays-external:2003
Return-path: <bastiangermann@fishpost.de>
Received: from mail-ej1-x62b.google.com ([2a00:1450:4864:20::62b]:41570)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1km2Hp-0000Cp-Ss
	for submit@bugs.debian.org; Sun, 06 Dec 2020 22:13:46 +0000
Received: by mail-ej1-x62b.google.com with SMTP id ce23so12962033ejb.8
        for <submit@bugs.debian.org>; Sun, 06 Dec 2020 14:13:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=7XyBYEuDH7KxfNM09ZMLweVPh3nQx8w3P3weebfdA+U=;
        b=S3/Hzdn2nvzz7IAMmADt1qFcQ4PeGQCKqyqxdomamn+eIZSZ64cZbAvz/BNqGbLYcb
         ijZF0SXFtSc9M7UNZpzpNGqSKBjAJu4VbAcWYBSERcdmN1z8wEhVsth/yFh01IIYVcs2
         xvCspnMB47B+ohXkEtGu9PxrSFTdx5lTSUz5Cx76YZkeju5O1Bs/7HeXKVNDUKJlY4da
         RpSFELc9WoTILjFSNekn5lWwqjE7fVynl5lSS2RaTHaW6p9R5vgP6kcXFCKcZ1ffyZ4Y
         cuz3o23Bygkxu3cTiuHFEf/bEQr5t/4cc3W7m1CRK85Xeu3IHJ5JDcTBZ3uif5tfrOHb
         XZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=7XyBYEuDH7KxfNM09ZMLweVPh3nQx8w3P3weebfdA+U=;
        b=V253Bfwe0WfwWx+SS7jeBtHQsBHgrui1IKqnXP5pUXdLYFHdZe6sjhLq4DDu+6gHZJ
         1zWskLqol9Aimz1DOt5ZlUR3HFk0xDwbn8wjf2gK89HuHWWyS+Ce2SfkB0DqcBCwS4Gu
         UI1Jq7Jdp/LwsP4Up5mWvAELzW8JKWc//kQc47QLX2pBHYvJq/dPn0/tr27S4Dc4T9Hi
         yE/gquNSbNMPplcMEs4CMTifFFJIm2yGi142ugYslpQzaiwd9qpYQ2yFoKn0g6WOmW72
         WBwuM1B1rLCc1rlj9vdy1TzIK/Y3c7fUFsy8Obu5cd9X8CvXVDXCvYA6fFWbgShDh/yC
         BzrA==
X-Gm-Message-State: AOAM532vVBlX1gsKTmTuZsyFzG4sb9gnBzo+VO81ryZhULxnOnhsZRIQ
	4v5RgzKpsVu7X5MdhXmZi6M1W/k77nFOBg==
X-Google-Smtp-Source: ABdhPJyq2AbVR6b5P76QqTeN8Ky3Z+9/V2hBzBsaDbbEB20SPYKx7JuFoOQ7OS+LR5qKdE7XXkklrw==
X-Received: by 2002:a17:906:1151:: with SMTP id i17mr16865523eja.250.1607292820777;
        Sun, 06 Dec 2020 14:13:40 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id a6sm10213085edv.74.2020.12.06.14.13.39
        for <submit@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 14:13:40 -0800 (PST)
To: submit@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: xfsprogs: Import new upstream version
Message-ID: <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de>
Date: Sun, 6 Dec 2020 23:13:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Delivered-To: submit@bugs.debian.org

Source: xfsprogs
Version: xfsprogs/5.6.0-1
Severity: important

Hi,

Please update the package to a new upstream version, preferrably the 
latest 5.9.0. As 5.7.0 removed libreadline support, this will imply 
building with libedit as filed in #695875.

Thanks,
Bastian

------------=_1611095585-8809-0
Content-Type: message/rfc822
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Received: (at 976683-done) by bugs.debian.org; 19 Jan 2021 22:32:21 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
	(2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=4.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
	autolearn=ham autolearn_force=no
	version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 15; hammy, 116; neutral, 16; spammy,
	0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:78.0,
	0.000-+--sourceversion, 0.000-+--source-version, 0.000-+--SourceVersion
Return-path: <bastiangermann@fishpost.de>
Received: from mail-wr1-x42c.google.com ([2a00:1450:4864:20::42c]:44799)
	by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <bastiangermann@fishpost.de>)
	id 1l1zXx-0002F3-N7
	for 976683-done@bugs.debian.org; Tue, 19 Jan 2021 22:32:21 +0000
Received: by mail-wr1-x42c.google.com with SMTP id w5so21238412wrm.11
        for <976683-done@bugs.debian.org>; Tue, 19 Jan 2021 14:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5dqybwTQ3p2Cii/r9O0dHIN5whU/SUM2GPK8aCJPbEs=;
        b=zQWNdUoYiYD1aH6Dz09rFDL8OUnIEWjX7PCiDj18QRYSBaJAxcL6b+DV3Vl5TWGyEG
         wz6PJ+oAmO+mNN3KcK6Ug+w4M7as1DE4phCbAGas5MivBjMNG/02VtfRq9muu+S+YuJk
         o2kxIZuDyi3sYj1yEOh8OnYcg6ZZSl3lwGYKMOo/rkt6LX/cY7OV7uz3Ip2KtjhRpn19
         CbtUJfwy6RhJG4UY9WteD+p0CCET0Xipl/sDxYgWpZj7lroQdhD9WkqcLhP+41lfwgxJ
         o4LeuMhZfgfJOt7EigvUNPrAWNnLj/cdgcaeLGs0ULUi6ZqlGwOkhjcYl6t+zpisTxVk
         yJLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5dqybwTQ3p2Cii/r9O0dHIN5whU/SUM2GPK8aCJPbEs=;
        b=XlTUfa7BfR8z+BLKPA3AMlvZoNeDXFyxpZuWiLXM4g5l0pd9tFkztOFck3ZK3kUpbC
         mkACC/4vz0vCchMXs759JWNO4pK2jfH6AanlLjrjtAAAMaZGq729i4mAZ90JCcAR8Jo9
         cFF/+HAS3S7IFGSHXyEauMRE7kBXdJ5ayzGCjunyLxxFPPhQ6/Oh2EH6RgySJCt5b7Dz
         rpb6Fd1ZFGbblPKSUP0Z/xsTUkeqNu7duqzCl12CmHgX1qM9cMad1gmRSL9dri2q0bpd
         uZ8q9Nwg/u8xT3g8HTr1r2VE0LKjiVgqTImV9hZIy46dSWlGD7/TysluQyp4Uv/0KYo1
         YnFg==
X-Gm-Message-State: AOAM533XLtPKV3dmLmJFoeEaEPhRWzDMABeuZEO+SeVUMlYyeld3Xpqu
	2tu8+G6QL07ZH9eZLGVvd8fzfh8cvv0emJ3U
X-Google-Smtp-Source: ABdhPJziVqCwWbHtyHZSoNP5R9z9Z2h5uqQf9T9j76+dF9CyYc5MgNuL81KTU/9i9sgc2Aepza4+Fw==
X-Received: by 2002:a05:6000:1788:: with SMTP id e8mr6334695wrg.171.1611095539040;
        Tue, 19 Jan 2021 14:32:19 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id g7sm145176wrx.62.2021.01.19.14.32.18
        for <976683-done@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 14:32:18 -0800 (PST)
To: 976683-done@bugs.debian.org
From: Bastian Germann <bastiangermann@fishpost.de>
Subject: Done: xfsprogs: Import new upstream version
Message-ID: <c4d44454-6b3f-c0df-c660-b625750d971c@fishpost.de>
Date: Tue, 19 Jan 2021 23:32:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CrossAssassin-Score: 2

Source: xfsprogs
Source-Version: 5.10.0-2
------------=_1611095585-8809-0--
