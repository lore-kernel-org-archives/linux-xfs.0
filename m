Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB9F5C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 06:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D50961400
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 06:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236281AbhD1Gjk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 02:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbhD1Gjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 02:39:33 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4E8C06175F
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:38:43 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s9so13072384ljj.6
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b6VwZqx9oNhz4FxYNA4xJEfdCgjpxbGmYfY0u+nAHgY=;
        b=Q+9N2+OTIXYwD1Uxm7CD9mSRF1PCqhPbI3/v4OVEfFkoV44JchdpJ/CFhEchcqI0Eh
         51pFEZSmir7tr/W0xLFhZDpQcGqgHtPa70/8d4PF2jZ1Y96Me/QxtrXQBsPARaw8UPXF
         C80LASpwY/1IFYcvnjKQ5Z79wbSLvPG7MHSCo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b6VwZqx9oNhz4FxYNA4xJEfdCgjpxbGmYfY0u+nAHgY=;
        b=rOdwd8+OTz6PUQLcMNbu6nULppnKVN4/OXDJ8wfg5gV6lXlmorvo5mPfVxeF4d5i0h
         vu78PElN+dESvlgp+DH8J8cZOsHWoyeq76QSu77YEgnlne3ogGBe3kcb6YIGoGPtuI4O
         DTwXH+lBe7/aI2z7gPvkXt68HyBk4iQrydH5zg+1LyRxTsj5EiPDBx0FV/tbGALWDv+g
         GfuJx1RS2g6JcEYYbGCxGu2Nl6mmE4qt83e5mxOV/9UQ54DrDH/wjTctD7okqmm9YMmm
         zYnWLQzxZvVoxRFOLg3lGO+fu5fcdAenWU8vYrN9h5k1N02Aq5cjIfGd5JLNjJFLNgsX
         sZtg==
X-Gm-Message-State: AOAM530eaPzk53ahR0lzLczrQNEJ8zeH5b1hdnu5bpQ8mfBKunxdjBmb
        vLKaeisQ8Ux4V95ScNHbKKbOTsj7rDxOhTjL
X-Google-Smtp-Source: ABdhPJz80j+ek77609o+/svwKU0St7gylIAw8whsjLPBb0uQWUhQATq9WkhFpePZwTvkwdxkMW4tLA==
X-Received: by 2002:a2e:b4f5:: with SMTP id s21mr14147426ljm.320.1619591921691;
        Tue, 27 Apr 2021 23:38:41 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id m13sm156827lfu.76.2021.04.27.23.38.40
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Apr 2021 23:38:41 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id o5so37910586ljc.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Apr 2021 23:38:40 -0700 (PDT)
X-Received: by 2002:a2e:880f:: with SMTP id x15mr17646698ljh.507.1619591920505;
 Tue, 27 Apr 2021 23:38:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210427025805.GD3122264@magnolia> <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
 <20210427195727.GA9661@lst.de> <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
 <20210428061706.GC5084@lst.de>
In-Reply-To: <20210428061706.GC5084@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 27 Apr 2021 23:38:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
Message-ID: <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
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

On Tue, Apr 27, 2021 at 11:17 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Apr 27, 2021 at 01:05:13PM -0700, Linus Torvalds wrote:
> > So how many _would_ be enough? IOW, what would make %pD work better
> > for this case?
>
> Preferably all.

WHY?

You guys are making no sense at all. You're stating silly things,
backing it up with absolutely nothing.

> Nothing needs to be secure.  It just needs to not scare users because
> they can see that the first usually two components clearly identify
> this is the test file system.

This is inane blathering.

What "scary message"? It will never happen in any normal circumstance,
and the trivial thing to do for any xfs test is to make the last
component name be something really obvious for the tester - who is the
only one who will ever see it.

And if it ever *does* happen in real life, the full path really isn't
necessary either. We're talking swap files. They aren't going to be in
random places.

The "I need the whole path" thing is just crazy, and you seem to be in
denial about it. There is absolutely zero reason for it.

I don't particularly care about this code sequence, but I do care when
people start making completely pointless arguyments to make excuses
for stupid code. You have extra silly code for "oh, the temporary
allocation that we did for no good reason can fail, so now we print
"<unknown>" for that case.

So it's all kinds of odd extra code for something that never used to
even bother with a pathname at all before, and now it's suddenly
"scary" and "really important to have all the components" instead of
just being simple and straightforward.

It's a purely informational message, and you guys made it pointlessly
overcomplicated for absolutely zero reason, and now you're too
embarrassed to just admit how pointless it was.

                   Linus
