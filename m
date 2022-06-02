Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E5FFC43334
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jun 2022 05:34:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiFBFe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jun 2022 01:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiFBFe2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jun 2022 01:34:28 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C8F2A5D54;
        Wed,  1 Jun 2022 22:34:27 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id 2so2772241qtw.0;
        Wed, 01 Jun 2022 22:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tpwYoGTq8qActv7yMCmPhDea6snEYh7PMLERykxwMmY=;
        b=cOlt2BeyMOlJL/q+Drsg6X3UdemiekvJTyVX2nFKFE94tKRSnShe0WH2pJ+VRifMMy
         GblnLs1kYfVX0DdPK4UADK3qdDG+RZcqUH04oQDey0+fP5eqwGikr9qjvt71eS9B6LeT
         ZZuVqxYsLiOXjrxx0CCnb6OPdByo73yRVfqLROoNun/YoeTtqo5mQwarsx2imUKO/ZZS
         Idwd06JTncvgp1CTZ+E6xiip83PE9BDo3mf2ZuiGBCbwAYq0sUPoGipM7GSC68p3g1NF
         5s66Mz8xPEjRIvEddB3CoyCD2Q7DDPAPpgWVfuG2WqEfO24pCd5H7Apiu6GAAQ/ZZcAT
         9m0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tpwYoGTq8qActv7yMCmPhDea6snEYh7PMLERykxwMmY=;
        b=oLIC5FDw9HKU1kjs9FbGOl7jIm8GR6qWMPI/OhtVkeAFUUgKo364nitL2VLt47sx4u
         lkPQ6/e8g03MD577IYPQ7I2L7rKigG0ODSn/2nLd0gzdOV1AyMe3cVCuV/Hd+jD0AApu
         HzzUxFquvGce6z8nkzChCltmf/0eYEs0/FwbQfCXjRVPLyaYsD3+jUXTjfLTQc51uaBc
         f5OaNVVfBDSa+szUoJpZw7Nkoq8Pna2tQeYByUb1vF7WAA4vCc+jfKwkYxYwvNPCkU2G
         /mUjrjhF9486qbUc6BH7C04FSCmfdmVfdjBRGfIkthkJp1ZBNBHzea3tzRW44DTC8wk+
         nd5g==
X-Gm-Message-State: AOAM531xDAF1hRFKepiDpOVusgB4yeafSt3/gPiJw+n+8oTq3A/MvjPz
        ieC5IbbSi0KNxbJyOynhFr/Fy8HT5MaFM5EAWBsZ54E8oCYAMA==
X-Google-Smtp-Source: ABdhPJxPUkHJO9Gs0vL0vY+nh5l/o1LEWGxgporxjX9F+0fkwV6xFXWxPJLM+d8LW0+9wz1QYvKSvxLvI6IlGSAn/0A=
X-Received: by 2002:ac8:5f09:0:b0:304:c31d:163e with SMTP id
 x9-20020ac85f09000000b00304c31d163emr2462070qta.2.1654148066982; Wed, 01 Jun
 2022 22:34:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area> <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org> <20220527234202.GF3923443@dread.disaster.area>
 <CAOQ4uxgYoK=mE=Fpt8BizgHxXmgajCk=t2k6nzHb2mM=C-HvAg@mail.gmail.com>
 <20220601043100.GD227878@dread.disaster.area> <CAOQ4uxgVTFjWrkpOMOTJ+dKu-YiwPi3dazrePzTzd-g6Tx1JQA@mail.gmail.com>
 <Ypg4wS3G42NSWWdQ@mit.edu>
In-Reply-To: <Ypg4wS3G42NSWWdQ@mit.edu>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 2 Jun 2022 08:34:15 +0300
Message-ID: <CAOQ4uxgeV++F53MV3pYR3SpLY357Fe=KvQVM1jFQ59jSSm4b+g@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > I was thinking later that there is another point of failure in the
> > backport process that is demonstrated in this incident -
> > An elephant in the room even -
> > We have no *standard* way to mark a patch as a bug fix,
> > so everyone is using their own scripts and regex magic.
> >
> > Fixes: is a standard that works, but it does not apply in many
> > cases, for example:
> >
> > 1. Zero day (some mark those as Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))
> > 2. Hard work to figure out the fix commit
> > 3. Discourage AUTOSEL
>
> For security fixes, just marking a bug as fixing a security bug, even
> if you try to obfuscate the Fixes tag, is often enough to tip off a
> potential attacker.   So I would consider:
>
>     Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))
>
> to Not Be A Solution for security related patches.  The real fix here

I miswrote. I meant fixes for bugs that existed since day 1.
The annotation above is adequate, but is also a bit ugly IMO.

>
>
> The hard work to figure out the fix commit is a real one, and this is
> an example of where the interests of upstream and people who want to
> do backports come into partial conflict.  The more we do code cleanup,
> refactoring, etc., to reduce technical debt --- something which is of
> great interest to upstream developers --- the harder it is to
> idetntify the fixes tag, and the harder it is to backport to bug and
> security fixes after the tech debt reduction commit has gone in.  So
> someone who only cares about backports into product kernels, to the
> exclusion of all else, would want to discourage tech debt reudction
> commits.  Except they know that won't fly, and they would be flamed to
> a crisp if they try.  :-)
>
> I suppose one workaround is if an upstream developer is too tired or
> too harried to figure out the correct value of a fixes tag, one cheesy
> way around it would be to use:
>
>     Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"))
>

I am sure that we can be more expressive than that :)

I suggested:
  Fixes: ????

Not as a joke. It is more descriptive than the above which could really
mean "I know this bug existed since day 1"

> to basically mean, this fixes a bug, but I'm not sure where it is, and
> it's long enough ago that maybe it's better if we ask the backport
> folks to figure out the dependency if the patch doesn't apply cleanly
> as to whether or not they need to do the code archeology to figure out
> if it applies to an ancient kernel like 4.19 or 5.10, because again,
> the product backport folks are likely to outnumber the upstream
> developers, and the product backport folks are linked to revenue
> streams.
>
> So I would argue that maybe a more sustainable approach is to find a
> way for the product backport folks to work together to take load off
> of the upstream developers.  I'm sure there will be times when there
> are some easy things that upstream folks can do to make things better,
> but trying to move all or most of the burden onto the upstream
> developers is as much of an unfunded mandate as Syzbot is.  :-/
>

The funny thing is that my rant was about a cover letter written
by an upstream developer, so unless what you mean is that backport
teams should invest in review and make those comments during
review, then it's too late by the time the backport team got to do their job.

You raise the resources problem and I understand that, but
I am not looking for a solution that creates more work for upstream
maintainers. Quite the contrary.

I am simply looking for a standard way to express
"attention backport teams".

What I am looking for is a solution for this problem:

Developer/maintainer has information that can be very helpful to backport
teams.

The information is known at the time of the writing and it requires no extra
effort on their part, but is not mentioned in a standard way because there
is no standard way that does not incur extra work.

Some maintainers that I am working with are very diligent about requiring Fixes:
when applicable.

It may be because of $$$ as you say, but I have a more romantic interpretation.
I believe it is because they care about the code they are developing and they
understand that mainstream is not a product and has no real user.

Unless maintainers care about downstream products, real users will perceive
their code as bad quality - no matter whose responsibility it was to
backport the
fixes or point out to the relevant fixes.

Thanks,
Amir.
