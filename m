Return-Path: <SRS0=kniB=ZV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C22C432C3
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Nov 2019 15:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5254A217AB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Nov 2019 15:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="lUT1A0bJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfK2Put (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Nov 2019 10:50:49 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35857 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfK2Put (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Nov 2019 10:50:49 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so14799060pfd.3
        for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2019 07:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=zqzmkmsTqqNqAEU6sqwGU4uvEVY7myANFxGbhNa8Thk=;
        b=lUT1A0bJvuFzw968HjdP/fl9rNWARwc0PM4vYA/8yJCbJ/uaimus9hTdblQmfxlQKV
         Hk3pTRvXK/sBwKVtqmUD9m1Hj5DCnk2axhfyw3w3c/3Smxd9sx0XjgiViLi9GAWsZgST
         ImILVq57QBkrCOTfxSwjUOt8pRnJQmvRe1mYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zqzmkmsTqqNqAEU6sqwGU4uvEVY7myANFxGbhNa8Thk=;
        b=dWP3Dy32yG1ILT+ndV3XnwxwqhctCE8gnKP3S0pEeKlYqiXgT8frFPrr5wYrtFGl3G
         QZ2fr6tVPlc2S2UGriSbrPMnPQjEld/YoMo4jbtO/dK2Y7dkimv4Lzqu5vKONwIFJRZz
         X+J9l0l8Y2NacY1sM5AdVoj4sSbS1QfSt1kgFMFxc6LRHSF3xZjoldHYPIho2U11qgh0
         z+UMUeASthjaJceKvvA8xIcQNEfNhXtOTBfRKdG1F5ee8JOKdLNRmHe9WimJbg1CwIAZ
         3wEJ9DWE+XN+D9CzN4uJZYdzy3X9xlmXadfcFsFNv61qvkOP71K8mBxYOa4Qfx48VeWg
         O7FA==
X-Gm-Message-State: APjAAAVQqwyWBmgb0Rvjyz4cErKFE9b4GF0H6c351aiVqtH3xYgzB9oG
        GYXwH+wKX5UwWuQkEpy88FgOTg==
X-Google-Smtp-Source: APXvYqyyUukfPuCBk8nUZGZ0bnjEmJYzBWHD+mlTLp6d97G4LvWRCazYGdcctIJCVgDXHXDcuWz1Gg==
X-Received: by 2002:aa7:93a7:: with SMTP id x7mr57797282pff.36.1575042647113;
        Fri, 29 Nov 2019 07:50:47 -0800 (PST)
Received: from localhost (2001-44b8-111e-5c00-4092-39f5-bb9d-b59a.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:4092:39f5:bb9d:b59a])
        by smtp.gmail.com with ESMTPSA id a22sm1465829pfk.108.2019.11.29.07.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 07:50:46 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     Qian Cai <cai@lca.pw>
Cc:     Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux-MM <linux-mm@kvack.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: XFS check crash (WAS Re: [PATCH v11 1/4] kasan: support backing vmalloc space with real shadow memory)
In-Reply-To: <27B18BF6-757C-4CA3-A852-1EE20D4D10A9@lca.pw>
References: <20191031093909.9228-1-dja@axtens.net> <20191031093909.9228-2-dja@axtens.net> <1573835765.5937.130.camel@lca.pw> <871ru5hnfh.fsf@dja-thinkpad.axtens.net> <952ec26a-9492-6f71-bab1-c1def887e528@virtuozzo.com> <CACT4Y+ZGO8b88fUyFe-WtV3Ubr11ChLY2mqk8YKWN9o0meNtXA@mail.gmail.com> <CACT4Y+Z+VhfVpkfg-WFq_kFMY=DE+9b_DCi-mCSPK-udaf_Arg@mail.gmail.com> <CACT4Y+Yog=PHF1SsLuoehr2rcbmfvLUW+dv7Vo+1RfdTOx7AUA@mail.gmail.com> <2297c356-0863-69ce-85b6-8608081295ed@virtuozzo.com> <CACT4Y+ZNAfkrE0M=eCHcmy2LhPG_kKbg4mOh54YN6Bgb4b3F5w@mail.gmail.com> <56cf8aab-c61b-156c-f681-d2354aed22bb@virtuozzo.com> <871rtqg91q.fsf@dja-thinkpad.axtens.net> <27B18BF6-757C-4CA3-A852-1EE20D4D10A9@lca.pw>
Date:   Sat, 30 Nov 2019 02:50:43 +1100
Message-ID: <87y2vyel64.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>>>>> 
>>>>> Nope, it's vm_map_ram() not being handled
>>>> 
>>>> 
>>>> Another suspicious one. Related to kasan/vmalloc?
>>> 
>>> Very likely the same as with ion:
>>> 
>>> # git grep vm_map_ram|grep xfs
>>> fs/xfs/xfs_buf.c:                * vm_map_ram() will allocate auxiliary structures (e.g.
>>> fs/xfs/xfs_buf.c:                       bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
>> 
>> Aaargh, that's an embarassing miss.
>> 
>> It's a bit intricate because kasan_vmalloc_populate function is
>> currently set up to take a vm_struct not a vmap_area, but I'll see if I
>> can get something simple out this evening - I'm away for the first part
>> of next week.

For crashes in XFS, binder etc that implicate vm_map_ram, see:
https://lore.kernel.org/linux-mm/20191129154519.30964-1-dja@axtens.net/

The easiest way I found to repro the bug is
sudo modprobe i915 mock_selftest=-1

For lock warns, one that goes through the percpu alloc path, the patch
is already queued in mmots.

For Dmitry's latest one where there's an allocation in the
purge_vmap_area_lazy path that triggers a locking warning, you'll have
to wait until next week, sorry.

Regards,
Daniel
