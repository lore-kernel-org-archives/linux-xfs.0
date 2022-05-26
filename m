Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37447C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 03:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbiEZDnR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 May 2022 23:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiEZDnR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 May 2022 23:43:17 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97E0D76
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 20:43:15 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id r1so832325qvz.8
        for <linux-xfs@vger.kernel.org>; Wed, 25 May 2022 20:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xXp/o/HU9ljknKFi/FCb8aJhdSMb59xbg2n9D4/nnbc=;
        b=blPsS0bhXly5NuDTrEmFpandwAHnga4harPlrTLLfbMmq9cnvO2WvOLwmNpDb+oAMt
         ijPECuARND+TGU/GK3tkfK3QjGquWyRGEQ4jeoQULP0AONEj+N+QEAgJ0oeAtES/VN1e
         BWaCA0yKUd9/N/6gEgAx6Gt35Nz0Ssa+KD5Z44ZAanQ7B2YrEuWXyLkfAeNwT8BOXtWa
         X133OZpEFuqjbImiMIXzXUyMVyLveIT+BYXyg2ouEn/taU+zLWYrvqS1Z1I+OkYyw7QY
         v67VpJtkBaV7t0pBSd9JddfEiLwieIPfvolP7xEiBG/NFA/PRQ6c7Z7Ep7WTnpfVO+Nw
         S/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXp/o/HU9ljknKFi/FCb8aJhdSMb59xbg2n9D4/nnbc=;
        b=Wu9peEhpjZnDukLIBlgbuYS2xK/ZF/24MFeXslOMVwlDZqJB5DSfhp/eHV87yKrQen
         P7VjOcIIn8XVz1s0zrC4I1opfJiKmyJqY+q8BOyimYYf+E/4Tsiy8cJeFz1INwdHOazn
         Hdx1KmiW6ECrftliVy36O7iENhugOjxoQN2VKxZVx9o4D7tb1PYiRj0kbya4Tpdh6FIZ
         3AaGMkj8Zz54duMwFYQBrKA4RKvDNMZiPAqKUdDY0FJwqLee1hXcLuVfrkTfZ3eLbFuh
         X4Kg+opwHSYIu8nq824a7c5cuCacZSRUJMFLckijJOv/SQdZHoY56U4w/SesiOQ0fH2z
         J1Lg==
X-Gm-Message-State: AOAM530paYLs1WjMxZUqABH9qfxqWf8OFnkLr1pw0LYh8PvbEnLN2Kjh
        P0o9OcAUDicTbcf/jgGnlPsa4irgjenhWfHEZPw=
X-Google-Smtp-Source: ABdhPJz/Q66V/ZSJpXHj1ukuE0c2RJJ0q0HxNVXfKR7AzKKK21x331p2p6+mUN/+Ikm4x2y0Ur4Mo9p1JaNhr8tk/24=
X-Received: by 2002:a05:6214:2409:b0:432:bf34:362f with SMTP id
 fv9-20020a056214240900b00432bf34362fmr28992042qvb.66.1653536594408; Wed, 25
 May 2022 20:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <Yo6ePjvpC7nhgek+@magnolia>
In-Reply-To: <Yo6ePjvpC7nhgek+@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 06:43:02 +0300
Message-ID: <CAOQ4uxjtOJ_=65MXVv0Ry0Z224dBxeLJ44FB_O-Nr9ke1epQ=Q@mail.gmail.com>
Subject: Re: XFS LTS backport cabal
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Leah Rumancik <lrumancik@google.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Shirley Ma <shirley.ma@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Tyler Hicks <code@tyhicks.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 12:23 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> Hi everyone,
>

Hi Darrick!

Thanks for making this introduction.

I've added Tyler (Microsoft) for his interest in 5.10 LTS backports
and Luis (Samsung) who has worked with the stable maintainers on xfs
backports in the past and is collaborating with me on 5.10 LTS testing
these days.

> As most of the people cc'd on this message are aware, there's been a
> recent groundswell of interest in increasing the amount of staff time
> assigned to backporting bug fixes to LTS kernels.  As part of preparing
> to resume maintainership on June 5th, I thought it would be a good idea
> to introduce all the participants (that I know of!) and to capture a
> summary of everyone's thoughts w.r.t. how to make stable backports
> happen.
>
> First, some introductions: Leah and Ted work at Google, and they've
> expressed interest in 5.15 LTS backports.  Dave and Eric are the other
> upstream XFS maintainers, so I've included them.  Amir seems to be
> working on 5.10 LTS backports for his employer(?).

Correct, my goals are twofold:

1. Consolidate duplicate efforts on stable kernel -
For CTERA products that are shippened as a VM image, I do not *need*
my backports to CTERA kernel to go to LTS. I *want* them to go to LTS.
As a community of developers who work for different companies,
we work so well together on upstream and so poorly apart on the
stable kernels that we each maintain.
I would like to see that change.

2. For CTERA products that run in containers in the cloud, we rely on the flow
of fixes to LTS kernels that will someday flow into the container host OS
of the cloud provider. Unless I start sending patches to cloud
providers directly,
LTS is my only path to get things fixed in the future.
For this use case, we do not even have the luxury of assuming a recent LTS
kernel. The major cloud providers released host OS images based on 5.10
only late 2021.

> Chandan and I work
> at Oracle (obviously) and he's also been working on a few 5.15 LTS
> backports.
>
> I won't speak for other organizations, but we (Oracle) are also
> interested in stable backports for the 5.4 and 4.14 LTS kernels, since
> we have customers running <cough> derivatives of those kernels.  Given
> what I've heard from others, many kernel distributors lean on the LTS
> kernels.
>
> The goal of this thread, then, is to shed some light on who's currently
> doing what to reduce duplication of LTS work, and to make sure that
> we're all more or less on the same page with regards to what we will and
> won't try to push to stable.  (A side goal of mine is to help everyone
> working on the stable branches to avoid the wrath and unhelpful form
> letters of the stable maintainers.)
>
> Briefly, I think the patches that flow into XFS could be put into three
> rough categories:
>
> (a) Straightforward fixes.  These are usually pretty simple fixes (e.g.
> omitted errno checking, insufficient validation, etc.) sometimes get
> proper Fixes tags, which means that AUTOSEL can be of some benefit.
>
> (b) Probable fixes.  Often these aren't all that obvious -- for example,
> the author may be convinced that they correct a mis-interaction between
> subsystems, but we would like the changes to soak in upstream for a few
> months to build confidence that they solve the problem and without
> causing more problems.
>
> (c) Everything else.  New features, giant refactorings, etc.  These
> generally should not be backported, unless someone has a /really/ good
> reason.
>
> Here are a few principles I'd like to see guiding stable backport
> efforts:
>
> 1. AUTOSEL is a good tool to _start_ the process of identifying low
> hanging fruit to backport.  Automation is our friend, but XFS is complex
> so we still need people who have kept up with linux-xfs to know what's
> appropriate (and what compile tests can't find) to finish the process.
>

I am very happy that you stepped up to write these expectations.
Please spell out the process you want to see, because it was not
clear to Ted and to me how we should post the xfs stable candidates.

Should we post to xfs list and wait for explicit ACK/RVB on every patch?
Should we post to xfs list and if no objections are raised post to stable?
For those of you not subscribed to xfs list, I have just sent my first crop
of 5.10 candidates yesterday [1]. Still waiting to see how that plays out.

[1] https://lore.kernel.org/linux-xfs/20220525111715.2769700-1-amir73il@gmail.com/

> 2. Some other tag for patches that could be a fix, but need a few months
> to soak.  This is targetted at (b), since I'm terrible at remembering
> that there are patches that are reaching ripeness.

The question is, to soak in 'master' or to soak in a release?
which means to soak in the stable kernel.

My opinion is that if we want exposure to real users that use diverse
userspace tools, then soaking in stable is the right answer, so typically
(b) patches would be soaking ~2 months in -rc and then ~2 more months
in .y and at that point they can ONLY be considered for LTS, because that
.y release (which is not LTS) is EOL.

>
> 3. fstesting -- new patches proposed for stable branches shouldn't
> introduce new regressions, and ideally there would also be a regression
> test that would now pass.  As Dave and I have stated in the past,
> fstests is a big umbrella of a test suite, which implies that A/B
> testing is the way to go.  I think at least Zorro and I would like to
> improve the tagging in fstests to make it more obvious which tests
> contain enough randomness that they cannot be expected to behave 100%
> reliably.
>
> Here's a couple of antipatterns from the past:
>
> i. Robots shovelling patches into stable kernels with no testing.
>
> ii. Massively large backports.  New features don't go to stable kernels,
> and I doubt the stable kernel maintainers will accept that anyway.  I
> grok the temptation to backport more so that it's easier to land future
> fixes via AUTOSEL, but I personally wouldn't endorse frontloading a
> bunch of work to chase a promise of less future work.
>
> And a question or two:
>
> a> I've been following the recent fstests threads, and it seems to me
> that there are really two classes of users -- sustaining people who want
> fstests to run reliably so they can tell if their backports have broken
> anything; and developers, who want the randomness to try to poke into
> dusty corners of the filesystem.  Can we make it easier to associate
> random bits of data (reliability rates, etc.) with a given fstests
> configuration?  And create a test group^Wtag for the tests that rely on
> RNGs to shake things up?
>

I'm a big fan of that idea :)

> b> Testing relies very heavily on being able to spin up a lot of testing
> resources.  Can/should we make it easier for people with a kernel.org
> account to get free(ish) cloud accounts with the LF members who are also
> cloud vendors?
>
> Thoughts? Flames?
>

Here is one thought - the stable candidate review process is bound to add
more work to the overloaded xfs maintainer.

I think it is a classic role to delegate to xfs stable tree maintainer(s).
The xfs stable maintainer(s) job would be to ping reviewers for acks
make sure patches are tested according to the standard and then
curate a tree and communicate with the stable maintainers.

Ideally, there will be a maintainer per LTS tree, which could naturally
align with the interest of employers and easier for developers to justify
spent time, but the load can be shared among maintainers, as nagging
for review is often not LTS specific.

If xfs maintainers are willing to put their trust in me, I volunteer for the
job of xfs stable patch hurding in general and/or 5.10 LTS specific,
which I am also contributing to.

Thanks,
Amir.
