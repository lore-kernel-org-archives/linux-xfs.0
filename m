Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322DFC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 21:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiF2ViU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 17:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF2ViU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:38:20 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5CB12634;
        Wed, 29 Jun 2022 14:38:19 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id d187so8652032vsd.10;
        Wed, 29 Jun 2022 14:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=glH6MA9OZFvYeXEMnrl0V5ZxmY5tpQoEsBxDvBnCdPs=;
        b=HB8Q/mm5ZYuZsVXLdVvsfVMQ6nFHNXGc01NWUWfZ+Qgg0QM6VZGKvQG5pGeWbAE5F1
         D6GrBDfMKfQzULotKMzZ0SEpMNjdGrJJs53hHKCN4ASFZqgnfP8HJCHgeKlBVP//VYK9
         g8rAG7RHmR6ok76Y9MqoiNF/HvL9aBghGBtpnq/UwU9/LvXTKLQ9jZG5Tma/FYy0ltvR
         JMOZ4W62b5aMarJitnaBMTXYRSQbbWpGuZzhHHPVdLG94q86HHVhDWr49fS1NpYLXC12
         1TjPr+4qIzAio6fDu7RDj1d4U5kz/C77maUEsqajOItOYHX1yK+EfTYMFYf5ftdzyYQ7
         Nc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=glH6MA9OZFvYeXEMnrl0V5ZxmY5tpQoEsBxDvBnCdPs=;
        b=u3mmWlTvRMIu/kCb//FdCoT6bpPJ4OhPYu2Xioeuoiok7ygd15DiNirf6Vk9nIz9lp
         XpQrNW83j0OOoC2HgcYTY8rpoJw3808mx+3SvYgbrbLzcHdn66ohmEkUgjWv3cItxWN1
         ny+H80mFkbtOY0fW9pCAOS5TaThGybQOBat2nmFYNN8lGleT8xzRTlIy8TLpsqRTrfoe
         COgJmD7QSZSNy1golmoKsQaTW5hAcPezeCWrXtzVznQ3DOWPJXFyRgjwyrzZ3iamEEXn
         MVsLD1CeA4nLK8rlXMs/5I77v/FYNgHUcSqGxjaNmTslp7zAoR3VSO69YUOEVoWyMeAY
         KX6g==
X-Gm-Message-State: AJIora/KRe4ychHgDW/NyEJrXHQZHlhhflelZMmgMkuoH3ywJeGyiwtB
        R0NOtXp0aYMagTZyH0dM/v6Ve3DR/GPG/g9kCTsGZuVB
X-Google-Smtp-Source: AGRyM1vP8KsahKVGBoQ9ovaxmB8aTyZiPDc7KSkKjLHJfJfdgqHWtUvTPZE2vOPTXnokszlTyoh+TJWDD5JoqqQ1b/M=
X-Received: by 2002:a05:6102:38c7:b0:356:4e2f:ae5b with SMTP id
 k7-20020a05610238c700b003564e2fae5bmr6295294vst.71.1656538698388; Wed, 29 Jun
 2022 14:38:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220627073311.2800330-1-amir73il@gmail.com> <Yrx71vp2SFsjVdzg@magnolia>
In-Reply-To: <Yrx71vp2SFsjVdzg@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 30 Jun 2022 00:38:07 +0300
Message-ID: <CAOQ4uxik4B5jP8rKq4oxT4x7edULPx4X9GKbMGRL5ny4r_t8DQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 CANDIDATE v2 0/7] xfs stable candidate patches for
 5.10.y (from v5.13)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 7:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Jun 27, 2022 at 10:33:04AM +0300, Amir Goldstein wrote:
> > Hi all,
> >
> > This is a resend of the series that was posted 3 weeks ago [v1].
> > The backports in this series are from circa v5.12..v5.13.
> > The remaining queue of tested 5.10 backports [1] contains 25 more patches
> > from v5.13..v5.19-rc1.
> >
> > There have been no comments on the first post except for Dave's request
> > to collaborate the backports review process with Leah who had earlier
> > sent out another series of backports for 5.15.y.
> >
> > Following Dave's request, I had put this series a side to collaborate
> > the shared review of 5.15/5.10 series with Leah and now that the shared
> > series has been posted to stable, I am re-posting to request ACKs on this
> > 5.10.y specific series.
> >
> > There are four user visible fixes in this series, one patch for dependency
> > ("rename variable mp") and two patches to improve testability of LTS.
>
> Aha, I had wondered why the journal_info thing was in this branch, and
> if that would even fit under the usual stable rules...
>
> > Specifically, I selected the fix ("use current->journal_info for
> > detecting transaction recursion") after I got a false positive assert
> > while testing LTS kernel with XFS_DEBUG and at another incident, it
> > helped me triage a regression that would have been harder to trace
> > back to the offending code otherwise.
>
> ...but clearly maintainers have been hitting this, so that's ok by /me/ to
> have it.  If nothing else, XFS doesn't support nested transactions, so any
> weird stuff that falls out was already a dangerous bug.

Exactly.

>
> Acked-by: Darrick J. Wong <djwong@kernel.org>
>

I am not going to post this to xfs list again with Acked-by
before posting to stable, because this is the second posting
already with no changes since v1.

I am going to wait until Greg picks up the already posted series
for 5.10 and 5.15 - it looks like he is also on vacation...

Thanks!
Amir.
