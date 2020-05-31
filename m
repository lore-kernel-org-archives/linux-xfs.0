Return-Path: <SRS0=JBSb=7N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D18C433DF
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 17:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93F5206E2
	for <linux-xfs@archiver.kernel.org>; Sun, 31 May 2020 17:32:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9PVXg7U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbgEaRcI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 May 2020 13:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgEaRcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 13:32:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816CAC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 10:32:06 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id y5so4523767iob.12
        for <linux-xfs@vger.kernel.org>; Sun, 31 May 2020 10:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMMW1IykvPifyAYMdeoRBL5rcPeUXwXF6tISW+DomzY=;
        b=W9PVXg7UxuxZlpaSBnLb9N0rOfUVFjfv++vc1dFV5N7ddaO5yj8H3G1YZ1DlsW/TOd
         bVXPTCp9ExmlemAar4jeg/4rzCwY4UZRjgREMHEJRwFgieQm7J1EM2YIoPZja0SUlEL7
         RrsSNYZpSntzl+y90g2vsZ6UmU0VkWNFtlf1Hq1glJQUsGR/BOvjLvVBWhXm+1+6mWAM
         5nOAHkYx750PSTg+srr0FnRIjS1FBHZaoEN4dnYb3DRnS+4uyLyJdzYYWoTp/ogg5Swi
         jkbYGAjuwyCD8OcwmK8/fUaSZ+umcN4Dykv4cGGzTEoWmtRFKYSGo4rF+arOXPZ/W+ig
         EbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMMW1IykvPifyAYMdeoRBL5rcPeUXwXF6tISW+DomzY=;
        b=et+gFkeKgkc8996XNOrAs6evOBFKRiAhMIALZBsD2IChYbkWz4azXrufpM/b6JuDIs
         FhuX0SYjNisgKy/YMRhRh7WzTw8K3ClslQcNUXxBAfLACe7tDtLu6XuJzB4zQIN6kJT7
         n3hksQSiYyA+gkDNrSy2CdX/2pSeHntOL1IIkkoCqnK5+OBMNaBFTY0w4aM5xjJiCbdJ
         KwMyGI6zQZHRAw8JJr3vQuXdYdYFzQnwoSjbUl0Nl5rCdDvMGYEL+1dG3cYVCsBmD8lT
         xHdwB1xL6vByRP8lm8GPOLzgwyKLvLTcfBHQwmhc9e8CTPhePn66jWEbrqLU3B0QBiiT
         +bKg==
X-Gm-Message-State: AOAM533zbF95M/lQA2xwPxFgA9OTBfu5wU1CrkbBvC8kr97hrTQ3vS32
        iCJWsYLoq6oN4jwKVCOGiy9SB3zJqACeotR2TcbPBGUk
X-Google-Smtp-Source: ABdhPJz7sr6PRaq3wbKAgbmvEckxlEuMKMcF6ctZOtq//AEtsj3aFxsCXi60fIl47mH9DY1xoJ/720tA7nsDQvTcCWw=
X-Received: by 2002:a02:5184:: with SMTP id s126mr15913445jaa.30.1590946325922;
 Sun, 31 May 2020 10:32:05 -0700 (PDT)
MIME-Version: 1.0
References: <157784106066.1364230.569420432829402226.stgit@magnolia>
 <CAOQ4uxjhrW3EkzNm8y7TmCTWQS82VreAVy608X7naaLPfWSFeA@mail.gmail.com>
 <20200526155724.GJ8230@magnolia> <CAOQ4uxgq+i1+q1=_bT=M_HoWWMuDaA8dqQK3m+iJZ8d+LBgA0w@mail.gmail.com>
In-Reply-To: <CAOQ4uxgq+i1+q1=_bT=M_HoWWMuDaA8dqQK3m+iJZ8d+LBgA0w@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 31 May 2020 20:31:54 +0300
Message-ID: <CAOQ4uxi7k0YP4gavw+Zd1jcxMmnpaic6iQ=uALRsxgsFReUhdw@mail.gmail.com>
Subject: Re: [PATCH 00/14] xfs: widen timestamps to deal with y2038
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > I plan to rebase the whole series after 5.8-rc1, but if you'd like to
> > look at the higher level details (particularly in the quota code, which
> > is a bit murky) sooner than later, I don't mind emailing out what I have
> > now.
> >
>
> No need. I can look at high level details on your branch.
> Will hold off review comments until rebase unless I find something
> that calls for your attention.
>

I went over the code in:
a7091aa0d632 xfs: enable big timestamps

I did not find any correctness issues.
I commented on what seems to me like a trap for future bugs
with how the incore timestamps are converted.

So besides "widen ondisk timestamps" and "enable bigtime for quota timers",
feel free to add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

For patches that do not change on rebase.

Thanks,
Amir.
