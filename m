Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57967C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 376F222CB2
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 07:29:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGlAe6w6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgH0H3U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Aug 2020 03:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbgH0H3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 03:29:17 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EB7C061264;
        Thu, 27 Aug 2020 00:29:16 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c6so4040048ilo.13;
        Thu, 27 Aug 2020 00:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RMGTRZOmOyaQ91kmfysIHGyzSaZOKnqn7S79Mf7yrU=;
        b=KGlAe6w6b1+K+UAwFUPZpoKXQlghUjUnm/OlRQ9cqDPQwlq9psmHOgyHOEmAvibKhy
         2Bbh9pSM7EuIr9+0ZdXekrr2b/hmTDlaZ9v2wwVyDQ21imv8iDBQd8VmX58/gYYRb71D
         t8YRKi9jJsRiCN313N09hgcva7oAJ8DYeCuNL9UEjnkHIIXWprnhfQWDkDqtkwnH3ZdG
         03VeXHAgXFaQcdY/gE169Qcch9IcNYB6p+2Cd7QxVize0v2y/g8H5FpinNJMuWAtMAN+
         3b94XHhTe+RtyEW4GKk8GBeH9pWIR8QsmPWBMrNNEIoNmF9pm8nYxUs50hBPb+/EFcxn
         syDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RMGTRZOmOyaQ91kmfysIHGyzSaZOKnqn7S79Mf7yrU=;
        b=JQxlKeS1uWZzdBEW+HPzoQbBtDnkLIPWpvKHAyPcG0fzPuC28IWyxEQQ5ceiDsjC+G
         UUWYsmoKEym8U4Wo+cOfFXotU9g6LMsNZKkfJxT972MXGp7MjsnvIFkvj5xJXhyV8FdF
         Pen3wJ0rCFjIjw5PF7sRsA7Vl5z0vrGPo+kWGAI0jESSd/UNf3CEr9LxXfrRituv22yK
         qY5fvfuGQppmJi7qX9HrRethz8mxgX06EDW25oErBpiOhaJfyuYHaYWWvsGtOJC9lt/O
         759SBW49BFjCPdv/BIZdJdSK1ZQp3DG2CkaNhAf0IfEf4pq1USCimMCllojz6DegKZEm
         J31Q==
X-Gm-Message-State: AOAM531/DUP64PlVUqvBjWl7sc6TNlcQZP5wBcfbXanu5AeyMqtB424C
        3eEJ2ADWuDAUn5KWlJhyp6+6clVwhQYEpTW83iNab8kWriU=
X-Google-Smtp-Source: ABdhPJxSbbqIYeZJ+Z7lmSbtW//MjG+xEKPIsgZ4XyIN1vsWZtBPtAYJINAE8BdbGq0XV+GI8N9ErOsr5QYY5IWXNFE=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr16661606ilf.250.1598513356140;
 Thu, 27 Aug 2020 00:29:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200826143815.360002-1-bfoster@redhat.com> <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com> <20200827070237.GA22194@infradead.org>
In-Reply-To: <20200827070237.GA22194@infradead.org>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Aug 2020 10:29:05 +0300
Message-ID: <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 10:02 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Aug 27, 2020 at 09:58:09AM +0300, Amir Goldstein wrote:
> > I imagine that ext4 could also be burned by this.
> > Do we have a reason to limit this requirement to xfs?
> > I prefer to make it generic.
>
> The whole idea that discard zeroes data is just completely broken.
> Discard is a hint that is explicitly allowed to do nothing.

I figured you'd say something like that :)
but since we are talking about dm-thin as a solution for predictable
behavior at the moment and this sanity check helps avoiding adding
new tests that can fail to some extent, is the proposed bandaid good enough
to keep those tests alive until a better solution is proposed?

Another concern that I have is that perhaps adding dm-thin to the fsx tests
would change timing of io in a subtle way and hide the original bugs that they
caught:

47c7d0b19502 ("xfs: fix incorrect log_flushed on fsync")
3af423b03435 ("xfs: evict CoW fork extents when performing finsert/fcollapse")
51e3ae81ec58 ("ext4: fix interaction between i_size, fallocate, and
delalloc after a crash")

Because at the time I (re)wrote Josef's fsx tests, they flushed out the bugs
on spinning rust much more frequently than on SSD.

So Brian, if you could verify that the fsx tests still catch the original bugs
by reverting the fixes or running with an old kernel and probably running
on a slow disk that would be great.

I know it is not a simple request, but I just don't know how else to trust
these changes. I guess a quick way for you to avoid the hassle is to add
_require_discard_zeroes (patch #1) and drop the rest.

Thanks,
Amir.
