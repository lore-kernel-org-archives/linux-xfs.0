Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76351C4361B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Dec 2020 17:58:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4411422475
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Dec 2020 17:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbgLOR55 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Dec 2020 12:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgLOR5s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Dec 2020 12:57:48 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F22C0617A7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Dec 2020 09:57:08 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kpEZO-0002Wo-9M; Tue, 15 Dec 2020 17:57:06 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#976683: xfsprogs: Import new upstream version
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          976683@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 976683
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de> <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de> <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 976683-submit@bugs.debian.org id=B976683.16080549249102
          (code B ref 976683); Tue, 15 Dec 2020 17:57:05 +0000
Received: (at 976683) by bugs.debian.org; 15 Dec 2020 17:55:24 +0000
Received: from mail-ej1-x635.google.com ([2a00:1450:4864:20::635]:45434)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1kpEXj-0002M8-E1
        for 976683@bugs.debian.org; Tue, 15 Dec 2020 17:55:24 +0000
Received: by mail-ej1-x635.google.com with SMTP id qw4so28921807ejb.12
        for <976683@bugs.debian.org>; Tue, 15 Dec 2020 09:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:subject:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IJfdwBLjNgbsuZFk8AcNGR9vHpYUJIMPhwMH7V49+Vk=;
        b=IH+jM7dJLPX2IyIl/8QkAt+oARqWrXvDQJQGimpd589vTXMO8TECE/k/t1t9fF49GC
         IfnVfL+3jneRRCPbg07XAN7cigkf4id32NDQqa7tbvdWlxxBW5KTag2in3rpBTNWnZAN
         e8Eztv9b8W065XkWWBpDrjFCKESgwI8laExP7VuKLxlsaGUqmmL6nuizeyi4w2MMrM9a
         bCdqa/hdWNXz8Z5tWsOzxsAeaEBgxngSiq4s6xBf1T0ZV1j+7ym/zaz+rEZXOPmTkWN7
         JkEZUhdgpTfkduReaOazkhFoyLFkmRD51A13ywnvnUQGFXph9JLWiSCkiWrxAdStpKcI
         zKog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IJfdwBLjNgbsuZFk8AcNGR9vHpYUJIMPhwMH7V49+Vk=;
        b=l2khYVU1jnbB3eLwpgWcEuIFIm/X99vDRqsb5W4XoQkiFMXwG5/Cw+1KVv/5LSO41z
         Ak9tCr6/JBPnqLKZE0v7RNpkwBMJ6BcfNLF4uofRZqtqmc9q36y0/FAOMc4TrgTyyiKQ
         8YU/+rK7DKWFi28LXJxr9fix5HK4k9iGKGNba4/SNoJxOKk35qcUUKNY3tm3JwwEE6vP
         6JD/j3XcdgQnnJQIqtjr6PFvtIQ+1goWqMqZdAAkh6QTAfUa4rxKt603s9cCP3IoqhGg
         0GuST35JUov4MPnVrVhsR9ameVULUIxmbNCOtUKVVOHrlotg+Y1j7IOFB+/hn3yGV+dt
         kJ/g==
X-Gm-Message-State: AOAM532eyaY5mO0xvu2PKYBQgVeMGB2jvWBTzMMyUEz+2P3Vn5y37kJO
        /1aaI8NuqewmjPp2n08ofxLY4pctpo5+uQ==
X-Google-Smtp-Source: ABdhPJzp5IkSDDHsEnF12xsGDwpWB39kWAowl1vtSC7hoRUuwJHaBghBrNy/1rYZXHt+gv0Vkbqc8Q==
X-Received: by 2002:a17:906:7f11:: with SMTP id d17mr27906890ejr.534.1608054918848;
        Tue, 15 Dec 2020 09:55:18 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id d13sm5118727edx.27.2020.12.15.09.55.17
        for <976683@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 09:55:18 -0800 (PST)
To:     976683@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <0580a107-275d-3e5f-6818-65d6da583385@fishpost.de>
Date:   Tue, 15 Dec 2020 18:55:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <8b769e38-3ffd-5e8c-7a57-d451daa30e67@fishpost.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, 6 Dec 2020 23:13:38 +0100 Bastian Germann 
<bastiangermann@fishpost.de> wrote:
> Source: xfsprogs
> Version: xfsprogs/5.6.0-1
> Severity: important
> 
> Hi,
> 
> Please update the package to a new upstream version, preferrably the 
> latest 5.9.0. As 5.7.0 removed libreadline support, this will imply 
> building with libedit as filed in #695875.
> 
> Thanks,
> Bastian

Now, 5.10.0 is available. The only change that is needed in addition to 
the patch given in #695875 to build it is adding libinih-dev to the 
Build-Dependencies: 
https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/commit/?id=fe4a31eae2b514de94e84a8f84a263471b6c71a3
