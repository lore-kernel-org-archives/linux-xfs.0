Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAE42C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 04:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiEJELp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 00:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiEJELo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 00:11:44 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F9178918
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 21:07:47 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id w3so12425624qkb.3
        for <linux-xfs@vger.kernel.org>; Mon, 09 May 2022 21:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ehVGvWILX3s/RaKTD/034edxM0rg37XjEJqy4886hrI=;
        b=m0hSPUxdxXs0BVERQhFlPlEUTY77ghiU8pj18WA5JlmuMJy3hc0AsX5GdRrrPebLqB
         WR3ZdgMNapgw30DbaN7gX2zI/RRj0rAv+mT9TMvGsIFPUpVcJ7tz3ms4hoaDunjTX6jK
         DzM5iyuG+x0gW3S+Gh+P+WwvNWWDk2bGKtddJ/eBAj92CPqSYgwd0QrdeNKXSnQNHKgf
         DguCE0uDMKZkGavj3dEi3Gx2+aa1nxJJxW0m+w14ll3pTtjBlWpTyFz+a+74AtoEt6px
         3UaxZjUrX3xoTt+8jaElW9eIgst4oWOKgXuwB8UnnVC1yP6iiSUOnicN9ONicgDlqfEH
         tlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ehVGvWILX3s/RaKTD/034edxM0rg37XjEJqy4886hrI=;
        b=7HUnQPeEpqMzY5b0d4rmGzO7xMXBBdljhUhiFmHk+C4P46UUs7QMPDGpfF6IykJMP3
         Ni2sh3mj5fZ1Kizg4AOaUczen4aAde6RB/XEVBbIraxPt+1uThDpOM2gLWR/03GDDWCd
         0U+/Epho1bm7JxF4EBAn6IPOqizVsEpTJXzNlOHWslLAwG2B9135pIylKiIphuT5dWFG
         Kp5ZaH8NXap91rksVztkTvoTaNAASEXIfD/rY26mkkZhPYqrnkPyo93O1HZChJPAyQZl
         pW9gHDtugWCMaBvI53V2GSNF1VnvihMfEi3CYRD023nHLROSmNj+f+KAYFu7uzGb3cIz
         XCug==
X-Gm-Message-State: AOAM531o3V8BXV8FNhIBLHLICtWSXOkI50VCILE48VZA5OdtScT/NzDd
        WaZGDuMo4tCEuYKfeJMfQZfpi06pPZUTQpvqInT/ARx6amA=
X-Google-Smtp-Source: ABdhPJyyCbDdAabWertM8SIyPeBTFFVAC4PdkHGb/u0dGH1nIb4R//Fxb/koJLdEf42XxP1xk6mq4+2KG+ItDdFr3l0=
X-Received: by 2002:a37:9381:0:b0:69f:62c6:56a7 with SMTP id
 v123-20020a379381000000b0069f62c656a7mr14331783qkd.643.1652155666777; Mon, 09
 May 2022 21:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220509024659.GA62606@onthe.net.au> <20220509230918.GP1098723@dread.disaster.area>
In-Reply-To: <20220509230918.GP1098723@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 10 May 2022 07:07:35 +0300
Message-ID: <CAOQ4uxgf6AHzLM-mGte_L-A+piSZTRsbdLMBT3hZFNhk-yfxZQ@mail.gmail.com>
Subject: Re: Highly reflinked and fragmented considered harmful?
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Dunlop <chris@onthe.net.au>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 2:25 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, May 09, 2022 at 12:46:59PM +1000, Chris Dunlop wrote:
> > Hi,
> >
> > Is it to be expected that removing 29TB of highly reflinked and fragmented
> > data could take days, the entire time blocking other tasks like "rm" and
> > "df" on the same filesystem?
> >
[...]
> > The story...
> >
> > I did an "rm -rf" of a directory containing a "du"-indicated 29TB spread
> > over maybe 50 files. The data would have been highly reflinked and
> > fragmented. A large part of the reflinking would be to files outside the dir
> > in question, and I imagine maybe only 2-3TB of data would actually be freed
> > by the "rm".
>
> But it's still got to clean up 29TB of shared extent references.
> Assuming worst case reflink extent fragmentation of 4kB filesystem
> blocks, 29TB is roughly 7 *billion* references that have to be
> cleaned up.
>
> TANSTAAFL.
>
[...]
>
> IOWs, the problem here is that  you asked the filesystem to perform
> *billions* of update operations by running that rm -rf command and
> your storage simply isn't up to performing such operations.
>
> What reflink giveth you, reflink taketh away.
>

When I read this story, it reads like the filesystem is to blame and
not the user.

First of all, the user did not "ask the filesystem to perform
*billions* of updates",
the user asked the filesystem to remove 50 huge files.

End users do not have to understand how filesystem unlink operation works.
But even if we agree that the user "asked the filesystem to perform *billions*
of updates" (as is the same with rm -rf of billions of files), If the
filesystem says
"ok I'll do it" and hogs the system for 10 days,
there might be something wrong with the system, not with the user.

Linux grew dirty page throttling for the same reason - so we can stop blaming
the users who copied the movie to their USB pen drive for their system getting
stuck.

This incident sounds like a very serious problem - the sort of problem that
makes users leave a filesystem with a door slam, never come back and
start tweeting about how awful fs X is.

And most users won't even try to analyse the situation as Chris did and
write about it to xfs list before starting to tweet.

From a product POV, I think what should have happened here is that
freeing up the space would have taken 10 days in the background, but
otherwise, filesystem should not have been blocking other processes
for long periods of time.

Of course, it would have been nice if there was a friendly user interface
to notify users of background cg work progress.

All this is much easier said than done, but that does not make it less true.

Can we do anything to throttle background cg work to the point that it
has less catastrophic effect on end users? Perhaps limit the amount of
journal credits allowed to be consumed by gc work? so "foreground"
operations will be less likely to hang?

I am willing to take a swing at it, if you point me at the right direction.

Thanks,
Amir.
