Return-Path: <SRS0=YlU2=7J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0279DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 06:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C980C2075A
	for <linux-xfs@archiver.kernel.org>; Wed, 27 May 2020 06:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Aw/sDQj1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgE0GiS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 May 2020 02:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgE0GiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 May 2020 02:38:18 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76E6C061A0F
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 23:38:17 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id g7so163394qvx.11
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 23:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=16SLl+3mPilnYr8f6o5VXeVQ8uh1Mbw9QHnodW3r70s=;
        b=Aw/sDQj1vVMv0wyH8eCtGTduHyZN4tgv0bqomMKfqi6GPrrT+NCkLyKQljYU6e0FE2
         0EJntjXR9gCCK0366trw5Ghbt30v5qJZfgd6skxPVhcR3bkinYVr6JliUT15bIeaYR/N
         9EsIJTrWenjHVewN/8fGykP1IHNIQKJv7hH7wH9biAja/DGoxyWIuT39B6ZWaMX3rpHO
         dF4xcAx/8rO5H1MbqP9HloyWKBqzqOSaQ95gOrDlVxcctXZ+4rbyP5tPlpsNWqQoOrPo
         D/2URQ7ZfhWvCya6SBFSlCcVxg6mJRW8+auz/Jv9/y1pZh+aVX2hH3g4E7j49J3hZ7TI
         di9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=16SLl+3mPilnYr8f6o5VXeVQ8uh1Mbw9QHnodW3r70s=;
        b=VXEvx1xFsbs6wQ1EIq/Dv3V7N/OSrNWCZDF/e7As91ZYGD5PCS85dUkN0cCeeotX5x
         UOv9JoeqJ55cqssNLTjTrNcuwrB05zmjntkNzYRCdv6RmXD+lzLad490HCR8HAIwIIPR
         2uyzemhjK4vnQjREYIQ8EAH6cn93maqObgsk1oVJUvYSHO8w/AIZXfl+il33I2XktiH6
         OntkzKunlT+Ui26kXyrfZPzOjA76IjeV3R6un361agUXnXPtxTPg09Qt7bgLcNxOV0ya
         qFcC1mEESHYtfqi0T9ZAfK9d5cB0i9pDgFCkCdhcWcGVATSv22P4PxCwzHbZPsGdeF51
         O47g==
X-Gm-Message-State: AOAM532XSWxRt6iGXkdP9z/4XBRrByyFurVsHBzwl8KuQxZu4YeQAYli
        yLhqSAUGBQzOHTQCxZrywTbopzCe0dvFqxtESFa3bg==
X-Google-Smtp-Source: ABdhPJzYwC1oOMNNyTL+AfbTq1fgeSCmKoistChYfxA78aIT3AkLA9NsDYQKFISHizbMvdC2nAXednxUZWgjJ1PvFWc=
X-Received: by 2002:a05:6214:15ce:: with SMTP id p14mr23954418qvz.159.1590561496904;
 Tue, 26 May 2020 23:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000ae2ab305a123f146@google.com> <3e1a0d59-4959-6250-9f81-3d6f75687c73@I-love.SAKURA.ne.jp>
 <CACT4Y+ap21MXTjR3wF+3NhxEtgnKSm09tMsUnbKy2_EKEgh0kg@mail.gmail.com>
 <20200527093302.16539593@canb.auug.org.au> <CACT4Y+ZFsQq65jZDRKA1rQs-GM9cyFu9Cn6y=kbx21mCryBqqA@mail.gmail.com>
 <20200527162514.404ae1da@canb.auug.org.au>
In-Reply-To: <20200527162514.404ae1da@canb.auug.org.au>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 27 May 2020 08:38:05 +0200
Message-ID: <CACT4Y+arjpDv1tbGEJ8yMO8XOik4EEpV8CU93VJOzhKbNs8kfA@mail.gmail.com>
Subject: Re: linux-next build error (8)
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        syzbot <syzbot+792dec47d693ccdc05a0@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 27, 2020 at 8:25 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Dmitry,
>
> On Wed, 27 May 2020 07:41:15 +0200 Dmitry Vyukov <dvyukov@google.com> wrote:
> >
> > On Wed, May 27, 2020 at 1:33 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > >
> > > What version of linux-next is this?  There was a problem last week with
> > > some changes in the tip tree that caused large memory usage.
> >
> > Hi Stephen,
> >
> > Detailed info about each syzbot crash is always available over the
> > dashboard link:
>
> Thanks.  As others have said, this has been taken care of - the
> problematic commits were dropped from next-2020522 and the fixes
> appeared in next-20200525.

OK, let's close this then, otherwise this is open since March, new
failures are piling up, we are not getting notifications about new
ones, and it turns into an unuseful mess.

#syz invalid
