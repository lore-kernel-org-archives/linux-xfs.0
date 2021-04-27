Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E9AC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 20:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB6E613FC
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Apr 2021 20:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhD0UGR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 16:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235412AbhD0UGQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Apr 2021 16:06:16 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0C2C06175F
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 13:05:33 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id o16so69599390ljp.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 13:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRcc/vr5Chj3M+4Hm2av7mbAqZ86imiIi9qoDwUZ/zU=;
        b=IRkv5P+hJ3HAvAVcYxfphR2IIalOpLukHJvNdIbyeYiLqB0zwJ4BoazBrHvbL7KeWQ
         YYkLIthfmcyOy+zftHPGy4a5Mdp6pRhBcLvLYvLaScIsMmWwXp0b3UxnZghldjA3FlIY
         iKXh7PqxoIO1WXdxmpi9PD3H48mfugN8DTiMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yRcc/vr5Chj3M+4Hm2av7mbAqZ86imiIi9qoDwUZ/zU=;
        b=rPE1XyqKkIHYe2xbK1jkTqnw1M8GvHM1rLhzRFcleaOrwnJDh1kP2UBbKnjyynD8Rw
         nUG87+CiZzXIxOVefGO3hQ41fT0viwdKIF4ZZ/lndDvUrS1VUf2NdGieHE/y/SplI3kE
         gPYuVD0CGKP39ttOIZFMC0GSkLJvIFoLGn+quDM1nAnYtPaTbIlY+WInraQ9myseaAWP
         wch/2tSnBTxIBCZucXD/TEd7qQdBoxjcF2cp6ZDJegfup0vs0pgp2VEON2lQPSebgJyN
         7VClfnZPnOj4wE6h8YG1XGED9W9yP4bj0ZggE99tGcEgBTgDLFKxNlPphj2HT349G52m
         WOtQ==
X-Gm-Message-State: AOAM531CJI9S/Tn8zCcBfYvmrcvCT6nY+oWigGhm4Brg+88Na2EMc0V/
        7qQM+7crXcYeWF6t+/B9WOtSqIC0G0BGTvL6
X-Google-Smtp-Source: ABdhPJwl77xnWHkgqCerjGgl/6E7YQDy4CL1jobPYHOWRqu6inSlJiyUxE/V7zUhWT97orUaQ7Zfgw==
X-Received: by 2002:a2e:581c:: with SMTP id m28mr17663552ljb.316.1619553931230;
        Tue, 27 Apr 2021 13:05:31 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id a11sm643776ljd.74.2021.04.27.13.05.30
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 13:05:30 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 2so2827388lft.4
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 13:05:30 -0700 (PDT)
X-Received: by 2002:a19:c30b:: with SMTP id t11mr5016247lff.421.1619553929885;
 Tue, 27 Apr 2021 13:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210427025805.GD3122264@magnolia> <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
 <20210427195727.GA9661@lst.de>
In-Reply-To: <20210427195727.GA9661@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 27 Apr 2021 13:05:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
Message-ID: <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 12:57 PM Christoph Hellwig <hch@lst.de> wrote:
>
> I'm aware of %pD, but 4 components here are not enough.  People
> need to distinguish between xfstests runs and something real in
> the system for these somewhat scary sounding messages.

So how many _would_ be enough? IOW, what would make %pD work better
for this case?

Why are the xfstest messages so magically different from real cases
that they'd need to be separately distinguished, and that can't be
done with just the final path component?

If you think the message is somehow unique and the path is something
secure and identifiable, you're very confused. file_path() is in no
way more "secure" than using %pD4 would be, since if there's some
actual bad actor they can put newlines etc in the pathname, they can
do chroot() etc to make the path look anything they like.

So I seriously don't understand the thinking where you claim that "<n>
components are not enough". Please explain why that could ever be a
real issue.

             Linus
