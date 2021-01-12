Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434E8C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 18:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D6572311A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 18:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406448AbhALSWk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 13:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406405AbhALSWg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 13:22:36 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C5BC0617B9
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 10:21:03 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kzOHu-0006cZ-Gv; Tue, 12 Jan 2021 18:21:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#979653: xfsprogs: Incomplete debian/copyright
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          979653@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 979653
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <59b797fa-21b2-b733-88b2-81735bc7d2f5@fishpost.de> <a7a0a016-c031-4532-1292-ad12d16415cf@sandeen.net> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <793e1519-b3d9-db3e-4a71-bb6da8ff2ff2@fishpost.de> <20210112174644.GR1164246@magnolia> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 979653-submit@bugs.debian.org id=B979653.161047556224982
          (code B ref 979653); Tue, 12 Jan 2021 18:21:01 +0000
Received: (at 979653) by bugs.debian.org; 12 Jan 2021 18:19:22 +0000
Received: from mail-ed1-x534.google.com ([2a00:1450:4864:20::534]:37851)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1kzOGH-0006UQ-Qp
        for 979653@bugs.debian.org; Tue, 12 Jan 2021 18:19:22 +0000
Received: by mail-ed1-x534.google.com with SMTP id cm17so3417056edb.4
        for <979653@bugs.debian.org>; Tue, 12 Jan 2021 10:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jLosrlLkZNQYa1f2MwChAr/wI+N/uE/XvrQmYQXzsDk=;
        b=GfMSny/Jwayo61WsYJ5qnmqxznpcb0mYJqz2kklTCxyMAUPqIc1cEiyXFmNxSvUsX4
         0w/Us0lJd7i9ZUzf/FJSu76dDBqr5mpl+HZYKL8uaXNGylc5HASkXRumnBXA6xs7JQA9
         hchTtfid9gadJAe76ytdUgcIzCt0KVB+6dLwnxFtOhPwjEH5kbOWsf5JL0YDvjNwcuFx
         fwpR2NlruiWBx9M+falDB+EQc3HUCsPJ4ouobpBun8lAFMr0UgDppho6H74o5+INeZj+
         erIKaVPjVWXUyEPyZrWS33YatQnnYue7g6+AaUJZgJmOLIGw8RMKGpcnE44s4CV5+fe/
         NgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jLosrlLkZNQYa1f2MwChAr/wI+N/uE/XvrQmYQXzsDk=;
        b=QpJe3ZmJRO3FIaydfCm9vwqX4oygp9UE5hlKewFpkXNmhP4CswT+8nRv2ujW+EE/Nv
         L2pfuCfYjQstMljvcbflRjybaPU6vmMOPnKXhHnB575DfuJqvDvdfXGgAVZVRPP7YGvW
         HD4ynxAe3ycHG6ocFldyp0lnfkj1MJXmhZ75t3+orTlgV3ggBaUgkSkq94f2Wc8iCKYN
         Mnhr/dMEBznZhnYBNRbbPZDBxqi76tLIqe6CMSS/VlpRewhBBChufXn0fkkRMCUXW/le
         iKmz2qJBfzg70I+sgNxuO9LwR/qRVwO7t2XoR4vUypb709TYpQy0IuXiMe3qjvU0hBcR
         dbOQ==
X-Gm-Message-State: AOAM533Sf85CNvUNE8nxgrnKLa/n+p1R70mFMe5A2nE5AVcSwih7PXNM
        szhLlOXalQ2Eg35N4Kn6k8nUTw==
X-Google-Smtp-Source: ABdhPJwA0AsMZudcUHrCSovt3RmR6+HzGxOKk9tGzte9sklOJHaWZM7DMEV2eZfbYGQcJX2aVcrrMw==
X-Received: by 2002:aa7:c5ce:: with SMTP id h14mr364425eds.188.1610475558804;
        Tue, 12 Jan 2021 10:19:18 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id bm25sm1770714edb.73.2021.01.12.10.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 10:19:18 -0800 (PST)
To:     "Darrick J. Wong" <djwong@kernel.org>, 979653@bugs.debian.org
Cc:     Eric Sandeen <sandeen@sandeen.net>
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <24ece48a-f8e5-e350-d30d-8d6116edd9be@fishpost.de>
Date:   Tue, 12 Jan 2021 19:19:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210112174644.GR1164246@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Am 12.01.21 um 18:46 schrieb Darrick J. Wong:
> On Sun, Jan 10, 2021 at 01:23:58AM +0100, Bastian Germann wrote:
>> Files: *
>> Copyright:
>>   1995-2013 Silicon Graphics, Inc.
>>   2010-2018 Red Hat, Inc.
>>   2016-2020 Oracle.  All Rights Reserved.
> 
> /me notes that a lot of the Oracle-copyright files are actually GPL-2+,
> not GPL-2.  That might not be obvious because I bungled some of the SPDX
> tags when spdx deprecated the "GPL-2.0+" tag and we had to replace them
> all with "GPL-2.0-or-later", though it looks like they've all been
> cleaned up at this point.

Yes, I have noticed that there are some GPL-2.0-or-later and GPL-2.0+ 
licensed files. Simplifying them as GPL-2.0-only in debian/copyright 
does not harm in my opinion as the whole work including the GPL-2.0-only 
files is not usable under GPL-2.0-or-later. And someone who is 
interested in using specific files would look at their individual SPDX 
lines anyway.

> 
> Question: How can we autogenerate debian/copyright from the source files
> in the git repo?  In the long run I think it best that this becomes
> something we can automate when tagging a new upstream release.

I do not know of any SPDX to DEP-5 converter. Implementing a generic 
converter would be beneficial to more projects but is a bigger task. The 
need for it is mentioned at https://wiki.debian.org/SPDX.
Just writing a converter for xfsprogs would be doable easily from what I 
have seen.
