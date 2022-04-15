Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA55C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Apr 2022 08:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbiDOI5W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 04:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiDOI5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Apr 2022 04:57:22 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447532BB33;
        Fri, 15 Apr 2022 01:54:50 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id o18so5593622qtk.7;
        Fri, 15 Apr 2022 01:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xnli73CgXce9Rl9w+mcJKH48CENcIY1UXRC2Gs7We1c=;
        b=JeHd+/S20hUYk33m4PdLKvVCkbpHKTcuHtxBD3DEeBSASsbr7ndme2gX3ni87T3ntH
         zcH2X92QlsHkXs40RPwQQC5FTF/FYe0UxWPs+zyToMBmPsiqC0N1HIjsVpgDInk1/zlh
         ZpoU8jfHMCIiRK4Kj9KmUvVw6FMPk8pmokOqdy8AObYcduc+jp6HgjzbdPyhmOkQTAKe
         Xr/nixMlRkUNkiV3NyTlqiTKnaMUvJAFe471L7iI3/NgaE/RA1JNmfAiaMXxh49+m3yc
         L7jhNn0bLAnXPUanJPmNGIPwPT3w5IUM0VuzIBbpYLEOalbR+FLW1iIop7MAiMFVGyn8
         3wKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xnli73CgXce9Rl9w+mcJKH48CENcIY1UXRC2Gs7We1c=;
        b=ijq32CVW7RShvuWRpy2xBTzGuJOKK6Js6bTapNFD+UpfD14IYgfss36mP9z0NOq4WD
         UGCfDick94F8zmm9nRZSwFie6tBmrGvIMcZFOQ/oUtJ+3k6AHiUMEJy7HDCFGPKv5V6y
         W/kkrdC/h0SrlXzUQjAHUVBYscvNIRrNk00muiM5fLYoZZ6aglpzuFGKbGrqxUa9ERS4
         77Lgxn2vuXKIWgbVhHMbIShuoGTWHg9Q4WDXMUwU2lOEu31KPpMwGzd+biWH0BijS/lp
         uTKctxhaMMJ0cYB419t/MOG0uD/Xcl0fatqsTC3kufFyQLHhBgxSOtVjxrJt1eZsXC1E
         9Cqw==
X-Gm-Message-State: AOAM5322svc5r08QKNvCvKgGn6iDBa/2wx7EPwAU/R82zVgzmAfg3lZo
        bj01xU1lmqjFX8MNuOIjG6DNOzQGCMKUGkkJlkk=
X-Google-Smtp-Source: ABdhPJwi9ofCGAVcTu0utTw3kKkm8fElQKH2cJRHNPL4U0ErBxMpj+yI39F2inWs9bKSFQoza6dT/vCmsPehoxMyjlg=
X-Received: by 2002:ac8:5fc4:0:b0:2f1:e898:2973 with SMTP id
 k4-20020ac85fc4000000b002f1e8982973mr3545725qta.157.1650012889900; Fri, 15
 Apr 2022 01:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971768254.169983.13280225265874038241.stgit@magnolia> <20220412115205.d6jjudlkxs72vezd@zlang-mailbox>
 <CAOQ4uxiDW6=qgWtH8uHkOmAyZBR7vfgwgt-DA_Rn0QVihQZQLw@mail.gmail.com>
 <20220413154401.vun2usvgwlfers2r@zlang-mailbox> <20220414155007.GC17014@magnolia>
In-Reply-To: <20220414155007.GC17014@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 15 Apr 2022 11:54:37 +0300
Message-ID: <CAOQ4uxhUZJ+fjWpnoSq1TfDFTNW3W7ywKC=uQNVJ=VC4+CY9Kg@mail.gmail.com>
Subject: Re: [PATCH 2/4] generic: ensure we drop suid after fallocate
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > > > > +# Modify as appropriate.
> > > > > +_supported_fs xfs btrfs ext4
> > > >
> > > > So we have more cases will break downstream XFS testing :)
> > >
> > > Funny you should mention that.
> > > I was going to propose an RFC for something like:
> > >
> > > _fixed_by_kernel_commit fbe7e5200365 "xfs: fallocate() should call
> > > file_modified()"
> > >
> > > The first thing that could be done with this standard annotation is print a
> > > hint on failure, like LTP does:
> > >
> > > HINT: You _MAY_ be missing kernel fixes:
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fbe7e5200365
> >
> > I think it's not difficult to implement this behavior in xfstests. Generally if
> > a case covers a known bug, we record the patch commit in case description.
>
> It's not hard, but it's a treewide change to identify all the fstests
> that are regression fixes (or at least mention a commit hash) and well
> beyond the scope of adding tests for a new fallocate security behavior.
>
> In fact, it's an *entirely new project*.  One that I don't have time to
> take on myself as a condition for getting *this* patch merged.
>

To be clear, my comment had no intention to serve as a condition for
merging your patch and not for suggesting that you should do anything really.
My comment was that "I was going to propose an RFC" meaning that
I was going to send patches but didn't get to it yet.
It's not a treewide project either, it's a simple optional annotation per test,
as is the case with LTP's optional .tags array.

My plan was to start with annotating the overlay tests and the xfs tests
that I collected during my work on v5.10..v.5.17 xfs backports, as they say
The change starts with me ;)

[...]

> > >
> > > What in the behavior of fallocate() and setgid makes it so special that it needs
> > > to be restricted to "xfs btrfs ext4" and not treated as a bug for other fs?
> > > I suspect that it might be difficult or impossible to change that behavior in
> > > network filesystems?
> >
> > I'm not sure what other filesystems think about this behavior. If this's a standard
> > or most common behavior, I hope it can be a generic test (then let other fs maintainers
> > worry about their new testing failure:-P). Likes generic/673 was written for XFS,
> > then btrfs found failure, then btrfs said XFS should follow VFS as btrfs does :)
>
> It will *become* a new behavior, but I haven't spread it to any other
> filesystems other than the three listed above.  Overlayfs, for example,
> doesn't clear set.id bits or drop file capabilities, nor do things like
> f2fs and fat.  I'll get to them eventually, but I think I'll have an
> easier time persuading the other maintainers of this new behavior if I
> can tell them "Here is a change, and this is an existing fstest that
> checks the behavior for correctness."
>

TBH, I am a bit surprised that you sign yourself up to fixing all those
other filesystems. It sounds like you got plenty on your plate already.
My intention is not to talk you out of doing community work, but to ask
what is the best way for developers that find a bug which they do NOT
intend to fix, to annotate the test for that bug.

I ran into that dilema with overlay/061 which tests for some non-standard
behavior regarding mmap that has been there since day 1 and is sufficiently
hard to fix. I ended up leaving this test out of "auto" group and in
"posix" group.
I might have left it in "known" or "broken" group just the same.

Regarding *this* patch, why not leave it _supported_fs generic?
What are the downsides?
Other fs would fail the test as they should.
It's not like that new behavior is debatable, it's a proper security issue.
And especially for fs that support FALLOC_FL_COLLAPSE_RANGE
and FALLOC_FL_INSERT_RANGE, so my other suggestion if you do
not wish to inflict this new failure on all other fs is to make the test require
finsert and document in a comment why that was done.

I know that the test won't run on btrfs with this requirement, but that is not
your problem to solve and also I am quite surprised that btrfs does not
support finsert/fcollapse, so maybe that support will be added some day
and then the security thread that comes with it could be avoided.

Thanks,
Amir.
