Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA62C43334
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jun 2022 07:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiFWHeB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jun 2022 03:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiFWHeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jun 2022 03:34:00 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9904665D;
        Thu, 23 Jun 2022 00:33:59 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id h38so11364417vsv.7;
        Thu, 23 Jun 2022 00:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ESpocniU/q4MRVbb2HbrOOweZLJBRQWfVUDXhB+yLQc=;
        b=ZXY7AtwAEolr/+dQN88oSVZlY5NGtngnSugmKEIZ70BNSF18QwghZ4mQ3vV2vRpzUw
         PKFlj2BvqGJ8PhKcPOyPEFgP6sCmQo4Ct7cQXzZ0gPyRqtRPBdf8LSEJU95nT4Vbi3LS
         iO8MAdIeCE+pMnLi65qfGDmljHZGXR5d5dNJJib4oeA6mdWI80vRvhQe86G5XDHa0Fso
         kQMgkd9owHCQHVzUp5eu9dBoXqA1NkRrDVp0WWpblUTx7q7cYfWSrfp/ehPJMzVjB3Kn
         wu4Rn6+/fJdaVCQ7bM8z/ebo/Dd7ZpyjjMuxaSiSnN3BjPFdNCC7Gywp8r42oYBB9qOU
         4vNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ESpocniU/q4MRVbb2HbrOOweZLJBRQWfVUDXhB+yLQc=;
        b=csYmIFhOq8iZ/G1L9y5tbw6g5TGP0wGWHgY6nyL7Vgn+zMy/dtoyvY8gvkr9h2RxNW
         SflBF+nsKPrg7/FEi+qFtyQ0UT0rmp5Y6njAFQSheXxWNkwbHdODB78NDHnPrmDlcacB
         zTmBe8/0TE+9QEZlPar7dpA2kALRzRCcSzVU9y2BRTJpkKEDgDJOn5EHT1yyKArGSSdY
         6LnB/y2G8/pDwXnmau9/IWecs+6w8nhv5KuPaXc+Fs5q0LvIkQ4Ngl/FY29n2mA6yGyU
         WXVDu1sC5NnFw3Mds345CsvWg0dUCR4J4YzwH6TrOO0IRADEBom9J5Oka5dkGRy/TzUk
         evIQ==
X-Gm-Message-State: AJIora/1s1v0iIv+5MBnlzeOxkx1mvvAm1ptOU7YmnjbFhpLxRzK1yEb
        aAWF06oP7RWi0r3hLOzPCwig3K7nkT23S1MofIUGsK1Rblg=
X-Google-Smtp-Source: AGRyM1tC9DHBWzoDdr8m5KceDglbp6leA36dAi6pE3X6myEH5dkMCKBQVxmZOoK0DUmQbggrDpXmexQaRPnWonyOo5U=
X-Received: by 2002:a05:6102:5dc:b0:354:63f1:df8d with SMTP id
 v28-20020a05610205dc00b0035463f1df8dmr3063714vsf.72.1655969639070; Thu, 23
 Jun 2022 00:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220617100641.1653164-1-amir73il@gmail.com> <YrOpmMzn9ArsR9Dy@magnolia>
In-Reply-To: <YrOpmMzn9ArsR9Dy@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 23 Jun 2022 10:33:47 +0300
Message-ID: <CAOQ4uxhOAaYkWeKXz6M8681ZjFiOSOJQqmewoq+-P1O2oXhsOg@mail.gmail.com>
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

On Thu, Jun 23, 2022 at 2:45 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Jun 17, 2022 at 01:06:30PM +0300, Amir Goldstein wrote:
> > Hi all,
> >
> > Previously posted candidates for 5.10.y followed chronological release
> > order.
> >
> > Parts 1 and 2 of fixes from v5.10..v5.12 have already been applied to
> > v5.10.121.
> >
> > Part 3 (from 5.13) has already been posted for review [3] on June 6,
> > but following feedback from Dave, I changed my focus to get the same
> > set of patches tested and reviewed for 5.10.y/5.15.y.
> >
> > I do want to ask you guys to also find time to review part 3, because
> > we have a lot of catching up to do for 5.10.y, so we need to chew at
> > this debt at a reasonable rate.
> >
> > This post has the matching set of patches for 5.10.y that goes with
> > Leah's first set of candidates for 5.15.y [1].
> >
> > Most of the fixes are from v5.15..v5.17 except for patch 11 (v5.18-rc1).
> > All fix patches have been tagged with Fixes: by the author.
> >
> > The patches have been soaking in kdepops since Sunday. They passed more
> > than 30 auto group runs with several different versions of xfsprogs.
> >
> > The differences from Leah's 5.15.y:
> > - It is 11 patches and not 8 because of dependencies
> > - Patches 6,7 are non-fixes backported as dependency to patch 8 -
> >   they have "backported .* for dependency" in their commit message
> > - Patches 3,4,11 needed changes to apply to 5.10.y - they have a
> >   "backport" related comment in their commit message to explain what
> >   changes were needed
> > - Patch 10 is a fix from v5.12 that is re-posted as a dependency for
> >   patch 11
> >
> > Darrick,
> >
> > As the author patches 4,11 and sole reviewer of patch 3 (a.k.a
> > the non-cleanly applied patches), please take a closer look at those.
> >
> > Patch 10 has been dropped from my part 2 candidates following concerns
> > raised by Dave and is now being re-posted following feedback from
> > Christian and Christoph [2].
> >
> > If there are still concerns about patches 10 or 11, please raise a flag.
> > I can drop either of these patches before posting to stable if anyone
> > feels that they need more time to soak in master.
>
> At the current moment (keep in mind that I have 2,978 more emails to get

Oh boy! Thank you for getting to my series so soon.

> through before I'm caught up), I think it's safe to say that for patches
> 1-5:
>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>
> (patch 9 also, but see the reply I just sent for that one about grabbing
> the sync_fs fixes too)
>
> The log changes are going to take more time to go through, since that
> stuff is always tricky and /not/ something for me to be messing with at
> 4:45pm.

Let's make it easier for you then.
I already decided to defer patches 9-11.

Since you already started looking at patches 6-8, if you want to finish
that review let me know and I will wait, but if you prefer, I can also defer
the log changes 6-8 and post them along with the other log fixes from 5.14.
That means that I have a 5 patch series ACKed and ready to go to stable.

Let me know what you prefer.

Thanks,
Amir.
