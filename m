Return-Path: <SRS0=V6/9=Y5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C6BC5DF60
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 19:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C62721D6C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Nov 2019 19:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=box.com header.i=@box.com header.b="TnZ7Txjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfKETx2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Nov 2019 14:53:28 -0500
Received: from mail-oi1-f181.google.com ([209.85.167.181]:40428 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKETx2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Nov 2019 14:53:28 -0500
Received: by mail-oi1-f181.google.com with SMTP id 22so587665oip.7
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2019 11:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=box.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RIUmntvZ0zmFJftiCGbHOOSquR9vGj3YSwcBe1PFUgw=;
        b=TnZ7TxjxjxlZmGHjE9ElFH3NQrhGtXD48T7Y6tK4sAb9ZP0fh5waWP36G2Edw5TrwX
         96ICz5QmFLDCD+SYHADIULF/JfNUKLkDGDlFFjFWnehJsML0blZjKj5rTwbTE3/9+q29
         9o0do16Nrnoz41K+itehT9LzX8DelSV5HRVK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RIUmntvZ0zmFJftiCGbHOOSquR9vGj3YSwcBe1PFUgw=;
        b=gh5NS/SCJngdFureJnqwd9iwYVZitRJI0mRKTdwQLEZy0SNv3R9tCZBL3xRu6Q6WX/
         n49YXZTg068C6sImMX/h58FNSMOO+JICYkdu62lCXjjuP0/+ojDdK3PmSi8DrWBj/rrR
         LLjzKhy8XmqN+flJ3IBwsPfQWrXzXeZgsVtzcB7oIWHX7VKK1PhMnczegDK98d8rgoGN
         d7FWTUtSW36CKVDKUI4OXwnrgGnqYuvuJqqe7hvXuJ8j0I77AKKB2kgrWSYQRY+hqUCB
         tNAREQ3QVsPBNJ2o1E9KKF6tyjmth4KdmrWg6hjYbaXsBCm98JFoC9gCQhAUuiWRWkNT
         Ddww==
X-Gm-Message-State: APjAAAVxMBc0YIqv5cYn9poe0afdXTM5ciNZAyKV66dHewnIvEW59TIX
        AHTATW61RiLxLHjZknTRzmW/kChkoHi/Bjnkks0+ug==
X-Google-Smtp-Source: APXvYqy+5tlNyN40eWL3BugJl/PFFbd/XrbNUkydZA8NpRiY0R3EFWbjuApFklhoqeOz8rwfERa440KaiNun9Xs/p2s=
X-Received: by 2002:aca:417:: with SMTP id 23mr626461oie.125.1572983606843;
 Tue, 05 Nov 2019 11:53:26 -0800 (PST)
MIME-Version: 1.0
References: <CAL3_v4PZLtb4hVWksWR_tkia+A6rjeR2Xc3H-buCp7pMySxE2Q@mail.gmail.com>
 <20191105000138.GT4153244@magnolia> <c677bc5b-aa27-5f9b-65bd-5f03e4c06d7b@sandeen.net>
 <CAC752AmahECFry9x=pvqDkwQUj1PEJjoWGa2KFG1uaTzT1Bbnw@mail.gmail.com>
 <e34f4417-6ccf-3a2f-de74-edb1b54a31f5@sandeen.net> <CAL3_v4NEKn6omXJYW3emfjApi7smW+c_sZyqWnQEpfDx4yPtdA@mail.gmail.com>
 <450b41a6-4fd5-6244-229c-b7cc9512c2a7@sandeen.net>
In-Reply-To: <450b41a6-4fd5-6244-229c-b7cc9512c2a7@sandeen.net>
From:   Chris Holcombe <cholcombe@box.com>
Date:   Tue, 5 Nov 2019 11:53:15 -0800
Message-ID: <CAL3_v4P+HwxegYCO3czD56nT0rGTwZ=qgDLOWAoppOR=6mMZ+Q@mail.gmail.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Blake Golliher <bgolliher@box.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I've got the stack traces and they're massive.
https://cloud.box.com/s/5grgnjwej5prmahl92v49937w6hgdnsv
https://cloud.box.com/s/wfrjg7yhiwufpgidoq1qos8mrwtu4ij3
https://cloud.box.com/s/3wcfgfdyvcsbslfdxc9ntfdt7yrhtcjt

On Tue, Nov 5, 2019 at 9:11 AM Eric Sandeen <sandeen@sandeen.net> wrote:
>
>
>
> CAUTION: External Email
>
>
>
>
> On 11/5/19 10:25 AM, Chris Holcombe wrote:
> > Hi Eric,
> > I've attached both the dmesg command output and /var/log/dmesg.log
> > which have different values in them.
>
> Thanks.  Aaand .... I forgot that we don't dump a stack trace by default.
>
> Can you please do:
>
> # echo 11 > /proc/sys/fs/xfs/error_level
>
> and hit it again, then send a few of the backtraces from dmesg?
>
> # echo 3 > /proc/sys/fs/xfs/error_level
>
> will quiet things down again.
>
> -Eric
