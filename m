Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C980EC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 04:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiF2Ec6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 00:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiF2Ec6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 00:32:58 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859BF2A421
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 21:32:56 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id n16so5301430ual.12
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 21:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ee5q0fAeT0180kZ2E+9dCw7oEghqwm+CUTU6a6BNI0=;
        b=p40IMyqsWQSm/6ZNlZrcf/AvVLe6G0euCPayPjMcGz8j8h8CCdZv5ZphxteJCJyd2o
         zk4VxBb1c5nUHYh7ctd6L1CvOAEWUtEw87LjkwFF9hFn7XMEkdruGo5buVwxbLEoVNmP
         3qUf+4CHytSPHB1lCU5IDxu14ce6hQVFqEoLeso2pn4zpqA37B6QZ89bmAcC9hD+riJd
         5HanJZaSOZHMdDBFbpiXncVfB/Wal12JjInUDfevIWBht0aE1bwUqbdXDrUsbo/NfZnM
         hOAJUfCM/j9eUSA2qSeBbJnAvViuEQto2El8QqaIU9q7fb0XVI+YDS6ILZFYYKr9weSS
         fmlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ee5q0fAeT0180kZ2E+9dCw7oEghqwm+CUTU6a6BNI0=;
        b=Ml1sMAfuMjjGYMOSmpaUWDh7YFBQzJzdwE7sNtY9+VO5CnEIkJaT9SGBk3FVb1ru7S
         1JmPaYhv4w0jxjJWKF+YsyuWGYQDXGb5RHvfno8dygklC3u/EvMX+iG/thl1zTnW4N4+
         yVAOcXFs6pDVI1DdymfFBqHn++5yOuw6Mc79B/K+oeaQq0uI6KQzctu5qvSemqVTXL75
         72/grIXWNySnusWxyTTBBRA/n6bDZolsgMH3XuDXz/Bdz5egfSf7NNA18O6zGIPC8PY+
         QXc9wgbdRHeBENDBeay+rmyBLRYWGUP+c5YrIsS6yX4Otf+5RuODBxTwIhD7xZ02sll5
         TO4Q==
X-Gm-Message-State: AJIora8hzn87jKg5AVTCu/0NBCHFqs9s0sCXg5NHr/SbM9GXl1kcIcc3
        H/v45hgufGEZ0SBMFbksyTbOKc19yUgVuCjLJVUCYX1Z7OYf9w==
X-Google-Smtp-Source: AGRyM1s3oofvOYl0F7WGaAYR8REDwFOO6tHnNdzZYOopHIuJi3lrU1vQnVhHTr06RBVyeeWs7umBoDs8zFoN3PN4CpI=
X-Received: by 2002:a9f:23c2:0:b0:365:958:e807 with SMTP id
 60-20020a9f23c2000000b003650958e807mr407442uao.114.1656477175661; Tue, 28 Jun
 2022 21:32:55 -0700 (PDT)
MIME-Version: 1.0
References: <CA+6OtaVMKW=K2mfbi=3A7fuPw2BmHv-zcx2jVKg9yEEY4wab3g@mail.gmail.com>
 <Yrt7t2Y1tsgAUFAr@magnolia> <20220628224453.GL227878@dread.disaster.area>
In-Reply-To: <20220628224453.GL227878@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 29 Jun 2022 07:32:43 +0300
Message-ID: <CAOQ4uxiWBMZSy9R9KNFKf5ptqM38naaSS5vLY2hdbYLvT0L5VA@mail.gmail.com>
Subject: Re: syzkaller@googlegroups.com
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Ayushman Dutta <ayushman999@gmail.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 1:52 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jun 28, 2022 at 03:07:51PM -0700, Darrick J. Wong wrote:
> > [+linux-xfs]
> >
> > On Tue, Jun 28, 2022 at 02:27:36PM -0500, Ayushman Dutta wrote:
> > > Kernel Version: 5.10.122
> > >
> > > Kernel revision: 58a0d94cb56fe0982aa1ce9712e8107d3a2257fe
> > >
> > > Syzkaller Dashboard report:
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 1 PID: 8503 at mm/util.c:618 kvmalloc_node+0x15a/0x170
> > > mm/util.c:618
> >
> > No.  Do not DM your syzbot reports to random XFS developers.
> >
> > Especially do not send me *three message* with 300K of attachments; even
> > the regular syzbot runners dump all that stuff into a web portal.
> >
> > If you are going to run some scripted tool to randomly
> > corrupt the filesystem to find failures, then you have an
> > ethical and moral responsibility to do some of the work to
> > narrow down and identify the cause of the failure, not just
> > throw them at someone else to do all the work.
>
> /me reads the stack trace, takes 30s to look at the change log,
> finds commit 29d650f7e3ab ("xfs: reject crazy array sizes being fed
> to XFS_IOC_GETBMAP*").
>

I don't have the syzbot link here, but I assume this is reproducible
and not reproducing on mainline, so in fact syzbot should be capable
of finding the fix commit itself.

If syzbot can hear me, next time you find an xfs bug that is reproducible
on 5.10.y and not on mainline, you may send it to me.

Darrick, if you want to find a creative way to encode that request
in MAINTAINERS as you suggested, that is fine by me.
It should be something that makes it easy to teach the few bots that run
on LTS kernels to find the right recipients and spam us instead of you.
We could add a P: Subsystem Profile document, which contains stable
maintainers info but that is less robot friendly.
I don't have a better idea.

This fix patch is in my xfs-5.10.y queue - it will probably take several
weeks/month until it gets reviewed. I could expedite it if anyone
feels that I should.

Thanks,
Amir.
