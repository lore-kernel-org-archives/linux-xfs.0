Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B8CC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 07:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350212AbiFAHKY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 03:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350192AbiFAHKY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 03:10:24 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7E568FAC;
        Wed,  1 Jun 2022 00:10:23 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id 2so608369qtw.0;
        Wed, 01 Jun 2022 00:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGEoCiBjGeK+iSAiWi2hfPbMDHcFN0l5vy+V883s2PM=;
        b=jNelCeOLBLQEhS8ZEWe2B1V4bCpge+8JIHoibBDDt/dabsH3I1+PaVYYMiEtg3EeGS
         5hnX8jmscGgd1JDZRNPgnnfS6NYgnWsjXR9VV+16idg8Sa+eweFNNPmjLrmGjUcuiDs/
         bQDfp2ZdG05A48fiA8NwaQXRNOp7NyRk8R+4qZ0Ps/7S6zdjRdCV4j8930/56w7MEQcr
         1159bNhJaEpSte+I4eGQL5KS7yN1+Tv13taB8sPXWznNcr2l2+40ayyhJnQncRWCXKkQ
         sPwV9zf2/cKKrXYLqsNw5mf7SqxWtU+t9bc1lKWgcFJrYsX/Xms7Yo015+1+NQNYk7fr
         yuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dGEoCiBjGeK+iSAiWi2hfPbMDHcFN0l5vy+V883s2PM=;
        b=oumUlhmICgCLvrL35GEVQNLlwLpVdsnFFIwV+S1BeHnt+aSiV2HOcqEYopbmdiXC2X
         mH4Tvmxz+wM5d0uBGULSWG5DOJ2REqBnQeq3pL+iGY4smIB9lNdcqgVOoHIrPWK2yqiZ
         QF20clEmE31oHM4adI8+jtJ6AfLp5IA6AAeWPNQ8IauexwTkVkRtr8w0lMS8fHN+YJw+
         7BbJzAEnBGIJgykB20h4bBWx4Z64ayXfkxj+Hp1c1TWQUOs/vRB1gZEm7AtHB5rWgvC6
         4oBn7nK1xJEVvNhdLSyA1OOUl8X3V+VbemZ0z974E+pGC114lqUazFXZceULsxwQYEgN
         ZuKQ==
X-Gm-Message-State: AOAM530khHvA7xCdeERBmAK+WhYDgBx4RFgTCQueywzydZyBO4OyjN4m
        qODyuQiIqT55RRtxgynXrAN3ikGxFjbauOg/4HSMdC5Q2gkRGQ==
X-Google-Smtp-Source: ABdhPJyhe+ffz0K7Vnbbyus3tglZD3FoRDFMsYA6YzN/mwMV7/dcC++vbqFntzPv5f3eBJn78fLZ4uwcTyifaxbdrX8=
X-Received: by 2002:ac8:5f09:0:b0:304:c31d:163e with SMTP id
 x9-20020ac85f09000000b00304c31d163emr2022871qta.2.1654067422465; Wed, 01 Jun
 2022 00:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area> <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org> <20220527234202.GF3923443@dread.disaster.area>
 <CAOQ4uxgYoK=mE=Fpt8BizgHxXmgajCk=t2k6nzHb2mM=C-HvAg@mail.gmail.com> <20220601043100.GD227878@dread.disaster.area>
In-Reply-To: <20220601043100.GD227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 1 Jun 2022 10:10:11 +0300
Message-ID: <CAOQ4uxgVTFjWrkpOMOTJ+dKu-YiwPi3dazrePzTzd-g6Tx1JQA@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 1, 2022 at 7:31 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Sat, May 28, 2022 at 08:00:48AM +0300, Amir Goldstein wrote:
> > On Sat, May 28, 2022 at 2:42 AM Dave Chinner <david@fromorbit.com> wrote:
> > >
> > > On Fri, May 27, 2022 at 08:40:14AM -0700, Luis Chamberlain wrote:
> > > > On Fri, May 27, 2022 at 03:24:02PM +0300, Amir Goldstein wrote:
> > > > > On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > > > Backport candidate: yes. Severe: absolutely not.
> > > > > In the future, if you are writing a cover letter for an improvement
> > > > > series or internal pull request and you know there is a backport
> > > > > candidate inside, if you happen to remember to mention it, it would
> > > > > be of great help to me.
> > >
> > > That's what "fixes" and "cc: stable" tags in the commit itself are
> > > for, not the cover letter.
> >
> > Cover letter is an overview of the work.
> > A good cover letter includes an overview of the individual patches
> > in the context of the whole work as your cover letter did:
> >
> > Summary of series:
> >
> > Patches Modifications
> > ------- -------------
> > 1-7: log write FUA/FLUSH optimisations
> > 8: bug fix
> > 9-11: Async CIL pushes
> > 12-25: xlog_write() rework
> > 26-39: CIL commit scalability
> >
> > So it was lapse of judgement on my part or carelessness that made me
> > eliminate the series without noting patch #8.
> >
> > Furthermore, the subject of the patch has Fix and trailer has
> > Reported-and-tested-by:
> > so auto candidate selection would have picked it up easily, but my scripts
> > only looked for the obvious Fixes: tag inside the eliminated series, so that
> > is a problem with my process that I need to improve.
> >
> > So the blame is entirely on me! not on you!
>
> I can feel a "But..." is about to arrive....
>
> > And yet.
> > "bug fix"?
> > Really?
>
> ... and there's the passive-aggressive blame-shift.
>

Not very passive ;)

> As you just said yourself, all the information you required was in
> both the cover letter and the patch, but you missed them both. You
> also missed the other 3 times this patch was posted to the list,
> too. Hence even if that cover letter said "patch 8: CIL log space
> overrun bug fix", it wouldn't have made any difference because of
> the process failures on your side.
>

That's fair.

> So what's the point you're trying to make with this comment? What is
> the problem it demonstrates that we need to address? We can't be
> much more explicit than "patch X is a bug fix" in a cover letter, so
> what are you expecting us to do differently?
>

It is a bit hard for me to express my expectations in technical terms,
because you are right - you did provide all the information.

At a very high level, I would very much like the authors of patches
and cover letters to consider the people working on backports
when they are describing their work.

There are many people working on backports on every major
company/distro so I think I am not alone in this request.

The best I can do is point to an example patch set that
I eliminated from back port for being a "rework" and where it
was made very clear that the patch set contains an independent bug fix:
https://lore.kernel.org/all/20210121154526.1852176-1-bfoster@redhat.com/

> > I may not have been expecting more of other developers.
> > But I consider you to be one of the best when it comes to analyzing and
> > documenting complex and subtle code, so forgive me for expecting more.
>
> That's not very fair.  If you are going to hold me to a high bar,
> then you need to hold everyone to that same high bar.....
>

Holding everyone to your standards is not going to be easy,
but I will try :)

> > It makes me sad that you are being defensive about this, because I wish
>
> .... because people tend to get defensive when they feel like they
> are being singled out repeatedly for things that nobody else is
> getting called out for.
>

I am sorry that I made you feel this way.

The trigger for this thread was a patch that I missed.
Doing the post mortem, I was raising the postulate [with a (?)]
that the author (who happened to be you) was not considering
the bug to be severe, which you had later confirmed.

After that, the conversation just escalated for the wrong reasons.
I was trying to make a general plea for more consideration in
the people that do backporting work and it came out wrong as
an attack on you. I need to watch my phrasing more carefully.

I sincerely apologize. It was not my intention at all.
I hope we can move past this and avoid clashes in the future.

Moving on...

I was thinking later that there is another point of failure in the
backport process that is demonstrated in this incident -
An elephant in the room even -
We have no *standard* way to mark a patch as a bug fix,
so everyone is using their own scripts and regex magic.

Fixes: is a standard that works, but it does not apply in many
cases, for example:

1. Zero day (some mark those as Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))
2. Hard work to figure out the fix commit
3. Discourage AUTOSEL

I am not sure if the patch in question was not annotated with Fixes:
for one or more of the above(?).

Regarding AUTOSEL, I hope this is not a problem anymore, because
AUTOSEL has been told to stay away from xfs code for a while now.

Regarding Zero day, I think this is a common case that deserves
attention by annotation.

Any annotation along the lines of Fixes: ????/0000
could cover cases #1 and #2 and may work with some existing auto
selection scripts without having to change them.

Granted, it may also break some existing script by making them
unselect a fix for a commit they cannot find.

Maybe instead of annotating what the fix fixes, annotation could
be somehow related to how the bug was detected, on which version,
with which test? not reproducible?

Thoughts?

Thanks,
Amir.
