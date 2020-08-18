Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EEBC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 18:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F855221E2
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 18:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JG/9UHLb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHRSuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 14:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgHRSuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 14:50:21 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4E5C061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 11:50:21 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so18552550iln.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 11:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2MAxY9BHfofC4uuTrJrGOH9YUSHV+zNUJRDxxueW4es=;
        b=JG/9UHLbm8bGUQfKoB/5AEpiJfUCwa05wGps/od4BWEDIncsQ0uWE9njk43y9+rWbC
         CRN6TH3GenAVBB53QWEUZ+DYZawB15I6K9uU+lPOjIj3XIdzd6bo4wRAc7WAnc4021QW
         e/lGp1DzGuhPDqQMtRImT9pryALXw5tUKQsPRqyddjqJFR9cbsUwkihlbLaQmGuIKcZ/
         Y1JZ3RvcoWtIUyl6fEVAKKMYV6YqYt3sy4TfaVRwWoVtB6RL7k8DCLFdxrfgK6m0B7+X
         zzIOKApZ4PGhzbnM7Rh5R4Yn4gVBs9vZyTrvsOkxKdlRvoyb/b63qyVOeV/kyalZw1Nn
         5NaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2MAxY9BHfofC4uuTrJrGOH9YUSHV+zNUJRDxxueW4es=;
        b=dI9aIOxwozkJlybU3P+jBiKiGYwQBplinpPzOTqdCNjYMmlzfERSvpxDeoKzWWJw5w
         EzEVwcuD/zb6+jnw7F6nUOL297rf8jbG5jeLGlLCUxeNxYiTQ0kKhfVg66FYp4ynXBUB
         jD7CV+hhqSIx/3XPrQcbQNkN2hdJudqorb6oexIXf9j0aMi4r+WLzUyL2UttIooP49gF
         GHePMnYx2Rj96kFtcdaX/sCut53gq1R5/ZBKWaOfQHhZcPQWq2Zf63YojhU8TJ/EKmwD
         gWz0qEYQnvhRGh7xQKvEytt3pIatPhY3NbEsr/h+LLMFAHkUg6EjR9FJuhNvq+Do0h52
         bU5A==
X-Gm-Message-State: AOAM532RutLiAU21/h8sY7pDPE5ZTTEITATIXbzpzbiF1eYcVoBxn9Rh
        /e3iJVkXiMFjg4QaYTkr9qApRk84tF5BUHFG1/4=
X-Google-Smtp-Source: ABdhPJyEc85NN/1+baqyEbHx3KEC3YXD5pgv6qRxU67MG8LkngUuHvS9IeKCNcc3S1Uyy7Zng9PtsHiA6D5XikIr6rI=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr19507673ilf.250.1597776619765;
 Tue, 18 Aug 2020 11:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia>
 <159770515211.3958786.7094290347539609121.stgit@magnolia> <CAOQ4uxjKta9UgtJ6rWE4Wy9hxGGGJOOxu+LuLY0Mf5i1kR69Ew@mail.gmail.com>
 <20200818152523.GO6096@magnolia>
In-Reply-To: <20200818152523.GO6096@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 21:50:08 +0300
Message-ID: <CAOQ4uxj1cR+AONf3hk0H41wxGcAbK3xVSqhPnTJpz4zVXrexVw@mail.gmail.com>
Subject: Re: [PATCH 03/18] xfs: refactor quota expiration timer modification
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 6:25 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Tue, Aug 18, 2020 at 05:21:59PM +0300, Amir Goldstein wrote:
> > On Tue, Aug 18, 2020 at 2:24 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Define explicit limits on the range of quota grace period expiration
> > > timeouts and refactor the code that modifies the timeouts into helpers
> > > that clamp the values appropriately.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > There is no refactoring here, but I suppose you want to keep the commit
> > names aligned with kernel commits, so
>
> FWIW, these patches of mine where (1) 'xfs: ' is in the subject; (2) the
> changes only touch things in libxfs and the bare minimum to avoid build
> breakage; and (3) whose commit log don't really match the changes are
> straight ports of the kernel-space patches.
>
> I hesitate to use the libxfs-apply script for these patches (even though
> Eric will do that when he's resyncing for real) because the source
> commit ids will probably never match what ends up in Linus tree.
>
> I don't know if anyone /else/ follows this convention, but in my
> xfsprogs series, I try to prefix patches that change /only/ userspace
> libxfs with the tag 'libxfs: ', so that reviewers can spend more time on
> the patches that tag either libxfs directly or some userspace program.
>
> That said, this is really not obvious.  I've wondered if I should amend
> libxfs-apply to be able to quote the source commit subject line so that
> it's more obvious when a patch is simply a userspace port.  Would that
> help?
>

This wasn't a problem for me when reviewing the patches.
Kernel patches were fresh in my head and I could tell when patches were
partially applied.

I think it is more of a concern for long term maintenance of xfsprogs -
having patches with obscure commit messages that do not match the
change, so it is really up to Eric and you guys as main stakeholders.

FWIW, quoting the kernel source commit sounds like a good idea.

Thanks,
Amir.
