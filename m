Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F1D8CCA47C
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Jul 2022 08:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiGXIgb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Jul 2022 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGXIga (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Jul 2022 04:36:30 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A97CB48E;
        Sun, 24 Jul 2022 01:36:28 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id 94so3353237uau.8;
        Sun, 24 Jul 2022 01:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bukET7qSPWrxf/LwGnxfpa7QXgNbfdikx5lZrigpanA=;
        b=mHZ8jxLJo480NIa4GeDG9N9PU6Xe19qNi7Vq842ww6gP58uIyrP9dsiW45KaaHnXVk
         Dmt+m3x+X70NFfygWHpIgQGK3ek7ZcjxBsMQhlpFTc6bmaomURTPkdL7l0dwe8ef67xi
         +DNuVbKXGqFLqYKA4m7pNMJdsHMBfC+HTqwugV0eel9Z9Kg7dR9genlp+Dafy31sXw9I
         6+EJ/grxL0ftHqAZvKzQtLS9W/1pwJWUXcvm5g8062fp2HbXFgixYA1ZubCYwRL+F8CL
         Ao3MfGt69bNDyN7+7l80OxBB8AeZ539t35kjsjtM1OmcYg1WNAZmFxt8gGiyx2I81gZZ
         b6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bukET7qSPWrxf/LwGnxfpa7QXgNbfdikx5lZrigpanA=;
        b=3OB6NFYxlEiaC3w+1pR9vZE7Uuj08HZbAfUlJLd1rEvF95G5xwkR43WMMyRtBzFHCy
         kml7mOwQUPA9AorZ5VTkAhe6g2ye5FHtulrshF/OW0/JSE9uYzXy/3vanf5hFfzGflxn
         IHig3mSHaB0SlKnOOf12U2diaPVHZspOIyLIwy00um1mSqrRqSvZdEFwEjuBruyM6aLE
         Q5Daqp2ATvPoLY9Fqdj+0ZiCZ2Upd3f2yB0EaAMxZGfY7dZhqz4SIoLObUV8gjGGeHK/
         zeZi1uBH0Kwff91v199LVk+G4PAaCb1oS3K5mjFLyMNVif1RLD4MydLfC/IpHBd38sG2
         EWrg==
X-Gm-Message-State: AJIora80FgC+DJ5gIacng0PjRfZQnIZkVlZotU9UVh4ayT47mssA/RFM
        LMjcJbGHsiDpC+sUIM4HXz4MQ5+TMAs53kfvhyE=
X-Google-Smtp-Source: AGRyM1sjKRFz9dBqfc1xaAGRur71gon2zJM0oeKzq+HdUJYUJQX5iNiO1gZFhcwTyjpO3kyWKCpJbadnEZs/Dz8Zkh8=
X-Received: by 2002:a9f:3523:0:b0:384:28fe:6f with SMTP id o32-20020a9f3523000000b0038428fe006fmr2030880uao.60.1658651787295;
 Sun, 24 Jul 2022 01:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <YrOpmMzn9ArsR9Dy@magnolia>
 <CAOQ4uxhOAaYkWeKXz6M8681ZjFiOSOJQqmewoq+-P1O2oXhsOg@mail.gmail.com> <YrSPNFZ+Hium1rhE@magnolia>
In-Reply-To: <YrSPNFZ+Hium1rhE@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 24 Jul 2022 10:36:15 +0200
Message-ID: <CAOQ4uxj2vk4ZPXu20PM0hHCawTVdaY+z5=0WuN__UxwNRDK5+g@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE 00/11] xfs stable candidate patches for
 5.10.y (v5.15+)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 23, 2022 at 6:05 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Jun 23, 2022 at 10:33:47AM +0300, Amir Goldstein wrote:
> > On Thu, Jun 23, 2022 at 2:45 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Fri, Jun 17, 2022 at 01:06:30PM +0300, Amir Goldstein wrote:
> > > > Hi all,
> > > >
> > > > Previously posted candidates for 5.10.y followed chronological release
> > > > order.
> > > >
> > > > Parts 1 and 2 of fixes from v5.10..v5.12 have already been applied to
> > > > v5.10.121.
> > > >
> > > > Part 3 (from 5.13) has already been posted for review [3] on June 6,
> > > > but following feedback from Dave, I changed my focus to get the same
> > > > set of patches tested and reviewed for 5.10.y/5.15.y.
> > > >
> > > > I do want to ask you guys to also find time to review part 3, because
> > > > we have a lot of catching up to do for 5.10.y, so we need to chew at
> > > > this debt at a reasonable rate.
> > > >
> > > > This post has the matching set of patches for 5.10.y that goes with
> > > > Leah's first set of candidates for 5.15.y [1].
> > > >
> > > > Most of the fixes are from v5.15..v5.17 except for patch 11 (v5.18-rc1).
> > > > All fix patches have been tagged with Fixes: by the author.
> > > >
> > > > The patches have been soaking in kdepops since Sunday. They passed more
> > > > than 30 auto group runs with several different versions of xfsprogs.
> > > >
> > > > The differences from Leah's 5.15.y:
> > > > - It is 11 patches and not 8 because of dependencies
> > > > - Patches 6,7 are non-fixes backported as dependency to patch 8 -
> > > >   they have "backported .* for dependency" in their commit message
> > > > - Patches 3,4,11 needed changes to apply to 5.10.y - they have a
> > > >   "backport" related comment in their commit message to explain what
> > > >   changes were needed
> > > > - Patch 10 is a fix from v5.12 that is re-posted as a dependency for
> > > >   patch 11
> > > >
> > > > Darrick,
> > > >
> > > > As the author patches 4,11 and sole reviewer of patch 3 (a.k.a
> > > > the non-cleanly applied patches), please take a closer look at those.
> > > >
> > > > Patch 10 has been dropped from my part 2 candidates following concerns
> > > > raised by Dave and is now being re-posted following feedback from
> > > > Christian and Christoph [2].
> > > >
> > > > If there are still concerns about patches 10 or 11, please raise a flag.
> > > > I can drop either of these patches before posting to stable if anyone
> > > > feels that they need more time to soak in master.
> > >
> > > At the current moment (keep in mind that I have 2,978 more emails to get
> >
> > Oh boy! Thank you for getting to my series so soon.
> >
> > > through before I'm caught up), I think it's safe to say that for patches
> > > 1-5:
> > >
> > > Acked-by: Darrick J. Wong <djwong@kernel.org>
> > >
> > > (patch 9 also, but see the reply I just sent for that one about grabbing
> > > the sync_fs fixes too)
> > >
> > > The log changes are going to take more time to go through, since that
> > > stuff is always tricky and /not/ something for me to be messing with at
> > > 4:45pm.
> >
> > Let's make it easier for you then.
> > I already decided to defer patches 9-11.
> >
> > Since you already started looking at patches 6-8, if you want to finish
> > that review let me know and I will wait, but if you prefer, I can also defer
> > the log changes 6-8 and post them along with the other log fixes from 5.14.

Hi Darrick,

FYI, I started testing the log fixes backports from v5.14 along with
the deferred
patches 6-8 [1] with extra focus on recoveryloop tests.

I know that Leah is also testing another batch of 5.15-only patches, so she
may yet post another 5.15-only series before my 5.10-only series.

In the meanwhile, if you have some spare time due to rc8, please try to
look at the already posted patches 6-8 [2] that were deferred from the original
stable submission per your request.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/xfs-5.10.y-for-review
[2] https://lore.kernel.org/linux-xfs/20220617100641.1653164-1-amir73il@gmail.com/
