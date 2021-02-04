Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD59C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 21:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 575CE64F58
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 21:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBDVar (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBDVap (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 16:30:45 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CD7C061786
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 13:30:05 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7mCT-0003uz-2L; Thu, 04 Feb 2021 21:30:05 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#570704: duplicate /usr/share/doc/xfsprogs/changelog{,.Debian}.gz
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          570704@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 570704
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: 
References: <814371d61002201153w2201b4bdteaa3fb0f301607e0@mail.gmail.com> <814371d61002201153w2201b4bdteaa3fb0f301607e0@mail.gmail.com> <814371d61002201153w2201b4bdteaa3fb0f301607e0@mail.gmail.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 570704-submit@bugs.debian.org id=B570704.161247407113637
          (code B ref 570704); Thu, 04 Feb 2021 21:30:04 +0000
Received: (at 570704) by bugs.debian.org; 4 Feb 2021 21:27:51 +0000
Received: from mail-ed1-x530.google.com ([2a00:1450:4864:20::530]:36254)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1l7mAJ-0003Xb-PD
        for 570704@bugs.debian.org; Thu, 04 Feb 2021 21:27:51 +0000
Received: by mail-ed1-x530.google.com with SMTP id l12so6147683edt.3
        for <570704@bugs.debian.org>; Thu, 04 Feb 2021 13:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:subject:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=T8JEuCKpBw1HyjaGSAnBTF47zNBaQzb6EJLRJdS0WP8=;
        b=SIHojA0bVyps8xLc3DjPLW2uzVbRHDWeODnkLVvDgP6ItoxicYskx+7bHKiBvFbX0j
         qDz8k/6tULYlzZnjag5veDjBi+/wYhNK6/UyNYHlj0yKZuE9KXiVgsvTaSUXLm1E83Py
         p4BkBGrp2t7FCujJ5jiKlwunTf0p08uP5yG471BpIzDR7+kyCct6ujPzUur/z7gw7Q2D
         04s01eDT01cxfZryUXb9embzu7YHluoFftEwuIGbdBLqhPgZvraK8Xq8hGrK3fOh6VTb
         p0SpvQxNmLan1Izi+Kfx0o6ghhC+3bB7q0BZ5yhX6mR2EvfBR6HGFb9DOgGI9r7/wV2y
         u+wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T8JEuCKpBw1HyjaGSAnBTF47zNBaQzb6EJLRJdS0WP8=;
        b=JGKimKIPzghHLHr/kSC2Bmno+6rmfg38sDmyofRAbCOfb73ZW8K3ubVX8Fzeeqs0Br
         qUeRtyHV3nWuMXYLPyumW/1SJvj+aKMgMPudM6aCFvCaeUL0yqusDZBfNZKxZ4dCezV7
         cYeDjnMgZHTBnKyXUsh4wDd8nBazRcgGTLGcma8VKoInSEJAcFQG2DPCsjSpbyaqRXqc
         VACdyei0qBcsVXXgAEgn3vfNPzhFCWzVDglAW72+uDKyLZIPwU8GTVHCwgNzL5jdkXNd
         oC7st5CPHe//camL0KIMP0FiSyEUuwqe9rshfVFyE+auUxErnKK6GiqE+pGWKgVHvof5
         H/Jg==
X-Gm-Message-State: AOAM533Ju93miMn+IwLXdww34UHcBQxS1CKvDTE1gBffiehTim/nfAU3
        wyPpKh3FGSNhSnG2wWOxsK6Gh6GKPtLi/nR/
X-Google-Smtp-Source: ABdhPJwQZ/17tYW4ugoH61cgusqZpRfJMw+6MM7gslYc8695F/1vimG541aWJHxP4z1rWbsg5jJPIg==
X-Received: by 2002:aa7:da92:: with SMTP id q18mr537407eds.91.1612474068729;
        Thu, 04 Feb 2021 13:27:48 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id f20sm3017075edd.47.2021.02.04.13.27.47
        for <570704@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 13:27:48 -0800 (PST)
To:     570704@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <c5bd759b-693e-9702-b9ff-3f39d439a04c@fishpost.de>
Date:   Thu, 4 Feb 2021 22:27:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <814371d61002201153w2201b4bdteaa3fb0f301607e0@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, 20 Feb 2010 20:53:37 +0100 Piotr Engelking 
<inkerman42@gmail.com> wrote:
> Package: xfsprogs
> Version: 3.1.1
> Severity: minor
> 
> There are two identical Debian changelogs in the xfsprogs binary
> package:
> 
> /usr/share/doc/xfsprogs/changelog.Debian.gz
> /usr/share/doc/xfsprogs/changelog.gz
> 
> Please remove one of them.

It's changelog.gz and CHANGES.gz that have the same content.
