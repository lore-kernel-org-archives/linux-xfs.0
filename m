Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B856C7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 02:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbjFFCqW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 22:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbjFFCqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 22:46:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078B111B
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 19:46:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-652d76be8c2so4823083b3a.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 19:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686019579; x=1688611579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZfxJ/Dm6xZF8lEbpNH1IMK7GCiiqLz2Js9LlY57dJLw=;
        b=s9iWe4/+4AhVM+UOQ+5fjOqrx2Y4f88qk5QkYgFtZYas5WUt+ibJbD2p0yEJ1jiXFZ
         DOsT4Q8wSp49pOJrh49I3vnvySGLMMWseBs7aGeQl/f6t6uk5wqQYhQvIcS0LydFzpFU
         qetYhGnWpXCQG2qxDl+xl75oXO7q0GS7N/xXHIWOyWxcDq6xsdQvmAPNqGoi+/cHKenL
         bxckIcDQ8fWakIJecmX5wo+n84UQb9nAC0tdlQiNUPIN//GPoqJzwR3TJXeOBv+5jGIK
         1g6PIN8gtbct2CXGgrO99Bo5N06TfE+W6obRmJ6yibDyocL6XZ2h91XOVrjXTQfE3iRQ
         LWPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686019579; x=1688611579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZfxJ/Dm6xZF8lEbpNH1IMK7GCiiqLz2Js9LlY57dJLw=;
        b=YhmGDpkxGXyOVOdtC8XsZf8ijgQvNcTG5mHU2oghg1CnodzPFWejKGT2pd7VfGWxzW
         g7pKa3f8u7/I4MYNeXOkbGFiE1SksH4ZY9lrcYdH6GnXPU/Uz7YvbnH+e34ajroFkuLF
         b6B5eK+bA7o5Q5zFHeVYXpWxsrqUvamK6tf3xE1qR2P8ZQWJ+/W8naAbvzRQA3+UpBDE
         u/7fP5jp15rYA6lEeTRBfv8nfuK8lKUZx8dAX4uwwCsxVydsz3RGLQek0t6tFp3w5eKw
         ZMgPRCIP5zKTL0CTp2NrhT9Zt+0K3wm/foeOTqRatDShVJT1cHoIT2oy9OyDW9e4CorK
         4VNw==
X-Gm-Message-State: AC+VfDy1fYAXBhEBcBataWMyfxhSsJWk9qYWoBYu55P1lx497ydT5Owk
        c24dE+mXUVNAqpQ3XsU03DMBc+0scgeaS5gv9pA=
X-Google-Smtp-Source: ACHHUZ6euL9wS2JWl5g/Wv4lu7hwNurXvYRw5oOCfOsr6caBLBp1uE43xgAKIjTcissqecMo4p+aZQ==
X-Received: by 2002:a05:6a00:2403:b0:652:7b99:df30 with SMTP id z3-20020a056a00240300b006527b99df30mr587673pfh.25.1686019579440;
        Mon, 05 Jun 2023 19:46:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-79-151.pa.nsw.optusnet.com.au. [49.179.79.151])
        by smtp.gmail.com with ESMTPSA id r3-20020a62e403000000b0064ff643f954sm5812483pfh.88.2023.06.05.19.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 19:46:18 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q6Mi7-008KNo-1Q;
        Tue, 06 Jun 2023 12:46:15 +1000
Date:   Tue, 6 Jun 2023 12:46:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Message-ID: <ZH6d938Hw/msm95A@dread.disaster.area>
References: <87zg88atiw.fsf@doe.com>
 <33c9674c-8493-1b23-0efb-5c511892b68a@leemhuis.info>
 <20230418045615.GC360889@frogsfrogsfrogs>
 <57eeb4d5-01de-b443-be8e-50b08c132e95@leemhuis.info>
 <20230605215745.GC1325469@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605215745.GC1325469@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 05, 2023 at 02:57:45PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 05, 2023 at 03:27:43PM +0200, Thorsten Leemhuis wrote:
> > /me waves friendly
> > 
> > On 18.04.23 06:56, Darrick J. Wong wrote:
> > > On Mon, Apr 17, 2023 at 01:16:53PM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> > >> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
> > >> for once, to make this easily accessible to everyone.
> > >>
> > >> Has any progress been made to fix below regression? It doesn't look like
> > >> it from here, hence I wondered if it fall through the cracks. Or is
> > >> there some good reason why this is safe to ignore?
> > > 
> > > Still working on thinking up a reasonable strategy to reload the incore
> > > iunlink list if we trip over this.  Online repair now knows how to do
> > > this[1], but I haven't had time to figure out if this will work
> > > generally.  [...]
> > 
> > I still have this issue on my list of tracked regressions, hence please
> > allow me to ask: was there any progress to resolve this? Doesn't look
> > like it, but from my point it's easy to miss something.
> 
> Yeah -- Dave put "xfs: collect errors from inodegc for unlinked inode
> recovery" in for-next yesterday, and I posted a draft of online repair
> for the unlinked lists that corrects most of the other problems that we
> found in the process of digging into this problem:
> https://lore.kernel.org/linux-xfs/168506068642.3738067.3524976114588613479.stgit@frogsfrogsfrogs/T/#m861e4b1259d9b16b9970e46dfcfdae004a5dd634
> 
> But that's looking at things from the ground up, which isn't terribly
> insightful as to what's going on, as you've noted. :)
> 
> > BTW, in case this was not yet addressed: if you have a few seconds,
> > could you please (just briefly!) explain why it seems to take quite a
> > while to resolve this? A "not booting" regressions sounds like something
> > that I'm pretty sure Linus normally wants to see addressed rather sooner
> > than later. But that apparently is not the case here. I know that XFS
> > devs normally take regressions seriously, hence I assume there are good
> > reasons for it. But I'd like to roughly understand them (is this a
> > extremely corner case issue others are unlike to run into or something
> > like that?), as I don't want Linus on my back with questions like "why
> > didn't you put more pressure on the XFS maintainers" or "you should have
> > told me about this".
> 
> First things first -- Ritesh reported problems wherein a freshly mounted
> filesystem would fail soon after because of some issue or other with the
> unlinked inode list.  He could reproduce this problem, but (AFAIK) he's
> the only user who's actually reported this.  It's not like *everyone*
> with XFS cannot boot anymore, it's just this system.  Given the sparsity
> of any other reports with similar symptoms, I do not judge this to be
> a hair-on-fire situation.
> 
> (Contrast this to the extent busy deadlock problem that Wengang Wang is
> trying to solve, which (a) is hitting many customer systems and (b)
> regularly.  Criteria like (a) make things like that a higher severity
> problem IMHO.)

Contrast this to the regression from 6.3-rc1 that caused actual user
data loss and filesystem corruption after 6.3 was released.

https://bugzilla.redhat.com/show_bug.cgi?id=2208553

That's so much more important than any problem seen in a test
environment it's not funny.

We'd already fixed this regression that caused it in 6.4-rc1 - the
original bug report (a livelock in data writeback) happened 2 days
before 6.3 released. It took me 3 days from report to having a fix
out for review (remember that timeframe).

At the time we didn't recognise the wider corruption risk the
failure we found exposed us to, so we didn't push it to stable
immediately. Hence when users started tripping over corruption and I
triaged it down to misdirected data write from -somewhere-. Eric
then found a reproducer and bisected to a range of XFS changes, and
I then realised what the problem was....

Stuff like this takes days of effort and multiple people to get to
the bottom of, and -everything else- gets ignored while we work
through the corruption problem.

Thorsten, I'm betting that you didn't even know about this
regression - it's been reported, tracked, triaged and fixed
completely outside the scope and visibility of the "kernel
regression tracker". Which clearly shows that we don't actually need
some special kernel regression tracker infrastructure to do our jobs
properly, nor do we need a nanny to make sure we actually are
prioritising things correctly....

....

> Dave's patch addresses #5 by plumbing error returns up the stack so that
> frontend processes that push the background gc threads can receive
> errors and throw them out to userspace.

Right, the inodegc regression fix simply restored the previous
status quo.  Nothing more, nothing less, exactly what we want
regression fixes to do. But it took some time for me to get to
because there were much higher priority events occurring....

....

> The problem with putting this in online repair is that Dave (AFAIK)
> feels very strongly that every bug report needs to be triaged
> immediately, and that takes priority over reviewing new code such as
> online repair.

My rationale is that we can ignore it once we know the scope of the
issue, but until we know that information the risk of being
unprepared for sudden escalation is rather high and that's even
worse for stress and burnout levels.

The fedora corruption bug I mention above is a canonical example of
why triaging bug reports immediately is important - the original bug
report was clearly somethign that needed to be fixed straight away,
regardless of the fact we didn't know it could cause misdirected
writes at the time.

Once we got far enough into the fedora bug report triage, I simply
pointed the distro at the commit for them to test, and they did
everything else. Once confirmation that it fixed the problem came
in, I sent it immediately to the stable kernel maintainers.

IOWs, if I had not paid attention to the original bug report, it
would have taken me several more days to find the problem and fix it
(remember it took me ~3 days from report to fix originally).  Users
would have been exposed to the corruption bug for much longer than
they were, and that doesn't make a bad situation any better.

And don't get me started on syzkaller and "security researchers"
raising inappropriate CVEs....

So, yeah, immediate triage is pretty much required at this point for
all bug reports because the downstream impacts of ignoring them is
only causing more stress and burnout risk for lots more people. The
number of downstream people pulled into (and still dealing with the
fallout of) that recent, completely unnecessary CVE fire drill was
just ... crazy.

We can choose to ignore triaged bug reports if they aren't important
enough to deal with immediately (like this unlinked inode list
issue), but we can make the decision (and justify it) based on the
knowledge we have rather instead of claiming ignorance. We're
supposed to be professional engineers, yes?

> That's the right thing to do, but every time someone
> sends in some automated fuzzer report, it slows down online repair
> review.  This is why I'm burned out and cranky as hell about script
> kiddies dumping zerodays on the list and doing no work to help us fix
> the problems.

Reality sucks, and I hate it too. We get handed all the shit
sandwiches and everyone seems to expect that we will simply to eat
them up without complaining. But it's not like we didn't expect it -
upstream Linux development has always been a great big shit sandwich
and it's not going to be changing any time soon....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
