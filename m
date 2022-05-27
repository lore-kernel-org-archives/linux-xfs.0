Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214A3C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 12:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352152AbiE0Mj4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 08:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352281AbiE0Mju (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 08:39:50 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8F61B215A;
        Fri, 27 May 2022 05:24:14 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id x65so4807478qke.2;
        Fri, 27 May 2022 05:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J7zEJJs7FqabcLZaGYBEwGspynxPf+TNYfS9GW1FuuY=;
        b=HXSVR8L29+0ymv1wOwreRzkDhY23TP33uVQyqS5/JQcjm2viqSPVUBm2as/iZKjv1x
         nTTdPrAqalohKd1ThuoDAo0uswh/x8KOaOVg/mgyYug6DghvEtYd341c5M/WltWZWmGy
         7WNiiTAX8wdS3yP9njmaRjeUXZsOaucwHTKHfgmG7EoRoJu45rRwwS8Ie7QpDORD3gS+
         M/6FKGdWZJIH44iHExhcBykNi4eldXYCWHjPYswlx3+w2N/3Gka9EzODUzYoQY7MxmuT
         Eaj6RotigPjNI1Lwv+5iqysLNRby62pFhEBj0+fXlxcrtE/4JEEpfnUdOkq7Wr2Xd5uG
         +sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7zEJJs7FqabcLZaGYBEwGspynxPf+TNYfS9GW1FuuY=;
        b=mxE07wUlzLdPqweVlJxZi5i0kLddLNrcqpDsmelkYF/YMM9CA9Oca938VpF3QTTC2E
         AGq+WtqtrcyTzjPMEKxd4ZMxRcyq+Yy68Z/+dyoUDYoh+Wzmcw7QAILViOU1yK04AcNB
         RxjtaS20fWm6SBTt0FIl+QPV9dJyh6Y3yV5B4PJuMkI2mxLw7Kz+KelI7p4Kdg4yGGob
         4Su+HFPpsVrNoKxWHtm8FKSzeJrm6uCC/0TSljNvI71nzfFEJztcX0n9C54PmD5xg+An
         FnjW8GafQwlJn0p4kOjxmYlYZ/WHTCcI+XU39DZBxITZIl43v6JbEzdwwv6e70BzTQxc
         KGYA==
X-Gm-Message-State: AOAM531M2Esaib4Xu3voyOHbUVJPVvhEF9LoDo7FlK9shyI2sGBMRXrV
        SFXzlnSzVSk72jeNGN6fvBvcbbCczW4NjBWb1Wg=
X-Google-Smtp-Source: ABdhPJy/Jru6QX8CWxEwq7t8GGfBlNEHxyPbHi83ReDWnfN5PBGf1lggWuelNKvdMlRPAaPiyv0TxiljAxsvvbKy61I=
X-Received: by 2002:a37:6310:0:b0:6a5:71bf:17e6 with SMTP id
 x16-20020a376310000000b006a571bf17e6mr13307882qkb.258.1653654253932; Fri, 27
 May 2022 05:24:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com> <20220527090838.GD3923443@dread.disaster.area>
In-Reply-To: <20220527090838.GD3923443@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 27 May 2022 15:24:02 +0300
Message-ID: <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, May 27, 2022 at 10:01:48AM +0300, Amir Goldstein wrote:
> > On Fri, May 27, 2022 at 9:06 AM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > FYI, below is the 5.10-stable backport I have been testing earlier this
> > > week that fixes a bugzilla reported hang:
> > >
> > > https://bugzilla.kernel.org/show_bug.cgi?id=214767
> > >
> > > I was just going to submit it to the stable maintaines today after
> > > beeing out of the holiday, but if you want to add it to this queue
> > > that is fine with me as well.
> > >
> >
> > Let me take it for a short spin in out xfs stable test environment, since
> > this env has caught one regression with an allegedly safe fix.
> > This env has also VMs with old xfsprogs, which is kind of important to
> > test since those LTS patches may end up in distros with old xfsprogs.
> >
> > If all is well, I'll send your patch later today to stable maintainers
> > with this first for-5.10 series.
> >
> > > ---
> > > From 8e0464752b24f2b3919e8e92298759d116b283eb Mon Sep 17 00:00:00 2001
> > > From: Dave Chinner <dchinner@redhat.com>
> > > Date: Fri, 18 Jun 2021 08:21:51 -0700
> > > Subject: xfs: Fix CIL throttle hang when CIL space used going backwards
> > >
> >
> > Damn! this patch slipped through my process (even though I did see
> > the correspondence on the list).
> >
> > My (human) process has eliminated the entire 38 patch series
> > https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/
> > without noticing the fix that was inside it.
>
> The first two times it was in much smaller patch series (5 and 8
> patches total).
>

The tool I was using tried to find the latest reference in lore
to have the closest reference to what was eventually merged
under the assumption that the last cover letter revision is the
best place to look at for overview.

In this case, however, there was an actual pull request for
the final version, but my tool wasn't aware of this practice yet,
so wasnt look for it.

>
> Also, you probably need to search for commit IDs on the list, too,
> because this discussion was held in November about backporting the
> fix to 5.10 stable kernels:
>
> Subject: Help deciding about backported patch (kernel bug 214767, 19f4e7cc8197 xfs: Fix CIL throttle hang when CIL space used going backwards)
> https://lore.kernel.org/linux-xfs/C1EC87A2-15B4-45B1-ACE2-F225E9E30DA9@flyingcircus.io/
>

Yes, as a human I was aware of this correspondence.
As a human I also forgot about it, so having the tool search
the lists for followup by commit id sounds like a good idea.

> > In this case, I guess Dave was not aware of the severity of the bug fixed
>
> I was very aware of the severity of the problem, and I don't need
> anyone trying to tell me what I should have been doing 18 months
> ago.
>

I will make a note of that.
I wasn't trying to pass judgement on you.
I was trying to analyse what needed fixing in my process as this is
the first time I employed it and this was a case study of something
that went wrong in my process.
forgive me if I got carried away with trying to read your thoughts
about the bug.

> It simply wasn't a severe bug. We had one user reporting it, and the
> when I found the bug I realised that it was a zero-day thinko in
> delayed logging accounting I made back in 2010 (~2.6.38 timeframe,
> IIRC).  IOWs, it took 10 years before we got the first indication
> there was a deep, dark corner case bug lurking in that code.
>
> The time between first post of the bug fix and merge was about 6
> months, so it also wasn't considered serious by anyone at the time
> as it missed 2 whole kernel releases before it was reviewed and
> merged...
>
> There's been a small handful of user reports of this bug since (e.g
> the bz above and the backport discussions), but it's pretty clear
> that this bug is not (and never has been) a widespread issue.  It
> just doesn't fit any of the criteria for a severe bug.
>
> Backport candidate: yes. Severe: absolutely not.
>

Understood.

In the future, if you are writing a cover letter for an improvement
series or internal pull request and you know there is a backport
candidate inside, if you happen to remember to mention it, it would
be of great help to me.

Thanks!
Amir.
