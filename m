Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B35C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiF2WRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiF2WRf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:17:35 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1A936B6A
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:17:35 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id k19so6278766uap.7
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N3tgvEQgZuoDasXTxBlSvlXvlFUmJduNF2EADZXTs84=;
        b=FMKH+5VJeSx3gHoXpbhcht8rnxTq/ccOcTtPw6C5PlPl30IqX7WIZgtRwV6Ve3cUSf
         ff3RqXdDBlhI+UM35xIx+kX8RLI9PyjxGd4jJ2SWZnP2yiA+0Gx5fqTeDyThJUSMb8Pu
         6uAzgQF7UNQO6/zdGaZPFkjEcbQYL1hOgyyCII6T8hzaiuHm5E+wOR8KE3Pa0FdrXMnG
         K6TA0cGKdqGWS9tQ+A+1CwuCk1KbmkHwSn+E1HG0RieCFUxk4SGzIeUz54NFHtJCH6sl
         TqQmyi86vcc8nzyl7vZEIo4QE1RwMAoUY0H7apNN8addxCg7g9QNkfxipAjhLHcTq8Ue
         I2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N3tgvEQgZuoDasXTxBlSvlXvlFUmJduNF2EADZXTs84=;
        b=E1d1ZZKfNVo42OKn/GzijdZb3NQoqFJxPiNvX5SHAo52kuxssjB0QtnJNCbOUuEqki
         eaT8159i08FfxvzPCtGzeNDUxkoT+M94Y/tGxZpPN3+a1y7FVLvaCHYwqNi3hHN74OGZ
         Ath7ZDE0YPaX7koU42hB7vCFtA31+FJKCe9vMuUSN3tLNHVZYftVdkFaTBI65SF0xgHt
         uMA687DkfeqaaCAjuQvi+Lnm0T8jFtBaGEddNYAdm+jhfLJQnnyi8eLD1XlP4XYuNs4K
         K5f+xTfk05cgRh2K2win2msUIxwkIggeeYHHVyR9lSmiNEGNBw9nrzVkirLmB2qKVyJz
         HytQ==
X-Gm-Message-State: AJIora/9l1kHrxxPQ8kKiTHCwSkTYvdNUkL5ofNA3YfCXCSVaLl45Y5j
        nKrjy1dlaG+nGzbLMR7DV34Bzv5gBGmDsK9mhac=
X-Google-Smtp-Source: AGRyM1vd/WjbKKnRwcyrBBjDNPNqxzr/t+1nwbMfF84kFMS9kNNveUvI1FodON0u7ZtSbqv7i7e0hA1mmOXIwULX+uI=
X-Received: by 2002:a05:6130:21a:b0:37f:2ab2:879a with SMTP id
 s26-20020a056130021a00b0037f2ab2879amr3445969uac.9.1656541054299; Wed, 29 Jun
 2022 15:17:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220629213236.495647-1-amir73il@gmail.com> <YrzHuqVgvSgj8gP6@magnolia>
 <CAOQ4uxgjmqB3YGr+tD0G2f-+4aqVoqYBE4sxkbCE3FYTO21nyw@mail.gmail.com> <YrzNPp6BOujpMvC8@magnolia>
In-Reply-To: <YrzNPp6BOujpMvC8@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 30 Jun 2022 01:17:22 +0300
Message-ID: <CAOQ4uxjmH9A4RJfv2-USS6unJxcrDeMry8_gioQyE2UwjfD3eg@mail.gmail.com>
Subject: Re: [PATCH 5.10] MAINTAINERS: add Amir as xfs maintainer for 5.10.y
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Theodore Tso <tytso@mit.edu>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 1:08 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Jun 30, 2022 at 12:52:57AM +0300, Amir Goldstein wrote:
> > On Thu, Jun 30, 2022 at 12:44 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Thu, Jun 30, 2022 at 12:32:36AM +0300, Amir Goldstein wrote:
> > > > This is an attempt to direct the bots and human that are testing
> > > > LTS 5.10.y towards the maintainer of xfs in the 5.10.y tree.
> > > >
> > > > This is not an upstream MAINTAINERS entry and 5.15.y and 5.4.y will
> > > > have their own LTS xfs maintainer entries.
> > > >
> > > > Suggested-by: Darrick J. Wong <djwong@kernel.org>
> > > > Link: https://lore.kernel.org/linux-xfs/Yrx6%2F0UmYyuBPjEr@magnolia/T/#t
> > > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > > ---
> > > >  MAINTAINERS | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 7c118b507912..574151230386 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -19247,6 +19247,7 @@ F:    drivers/xen/*swiotlb*
> > > >
> > > >  XFS FILESYSTEM
> > > >  M:   Darrick J. Wong <darrick.wong@oracle.com>
> > > > +M:   Amir Goldstein <amir73il@gmail.com>
> > >
> > > Sounds good to me, though you might want to move your name to be first
> > > in line. :)
> >
> > Haha ok I can also add a typo in your email if you like :D
> > I'll send it along with the 5.13 backports.
>
> Actually -- can you change it to djwong@kernel.org while you're at it?

Ok.

Leah, note that 5.15.y needs that fix too.

> Maybe this is why I keep getting community emails chewed to death by
> Outlook.
>
> With /my/ email updated and yours first in line,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>

Thanks,
Amir.
