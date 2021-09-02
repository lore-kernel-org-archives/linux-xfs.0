Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46590C4320E
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 15:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EE646101A
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 15:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345918AbhIBPtC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 11:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345873AbhIBPtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 11:49:02 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E510C061575
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 08:48:03 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id l18so4376721lji.12
        for <linux-xfs@vger.kernel.org>; Thu, 02 Sep 2021 08:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5wsPeIhzYXabpZGJAWeTrSQOBVTFZSeI6/V+A/PKS+M=;
        b=ERUiyJetgJfhv6CSzrx6t3BC3sUidOHQEL/eDPlppAa2ihMq3Wb2UVSXXDUuPuaU1A
         4/XvqW5lS+oI+M7I2xMssmbTqkpxCPxhR1wO2lWfQBg4oc+w/Mm4258ukKLi75PZRBLY
         Wn2b943/0K9fY7TmwJ8wE1L+ipYVBjxFcZqsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wsPeIhzYXabpZGJAWeTrSQOBVTFZSeI6/V+A/PKS+M=;
        b=fRJQHWkHeXoC+ogTLxUUugsIHR2zA4NdHO62x5rivayY3p/TTnrZTwGFEAlX7PAtPJ
         z2j/dDIa9rsmO1jZD6gsqg9zuUsA/YrkWVBn6aoTYJscd8LB21E9Xo3vwMgPpWiTJZmF
         6kLaWkq13rodCgtZQqZIseLdeL0HvPeYoMptqTCf3pJTyq3B8ViCte/KrFQ5r9QILMu9
         0dXbbghTwqEbIA0FZPs4gD28Vcof4cqymDgYkIGCV5vSfHarH4g697FxBPBJpJ5BED4S
         d3h13dnLriJPcl66WdtodjhlPpNI4h0E/fvu0zHXpCH2oyBNLQzZoxXdlTJatn6mknuk
         W0vA==
X-Gm-Message-State: AOAM533EBUJbUuv0QSS3EFEyxzsD/PvyRyQkkZVd+VQkL/LksVW7wu6I
        cjeVowmMOxnLN7r4AzH56l1J8tx6hB7BVLpp
X-Google-Smtp-Source: ABdhPJyDIqSxYAw080ZhskRSwv0BgcssdMOe4DmVOQWAXvR0DbOAaf51idZTYL6IqWAlQ28Uv3Nyiw==
X-Received: by 2002:a2e:5c9:: with SMTP id 192mr3119385ljf.337.1630597680417;
        Thu, 02 Sep 2021 08:48:00 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id n4sm252227lji.100.2021.09.02.08.47.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 08:47:59 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id t12so5120310lfg.9
        for <linux-xfs@vger.kernel.org>; Thu, 02 Sep 2021 08:47:58 -0700 (PDT)
X-Received: by 2002:a05:6512:228f:: with SMTP id f15mr3148224lfu.253.1630597678499;
 Thu, 02 Sep 2021 08:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210831211847.GC9959@magnolia>
In-Reply-To: <20210831211847.GC9959@magnolia>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Sep 2021 08:47:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whyVPgkAfARB7gMjLEyu0kSxmb6qpqfuE_r6QstAzgHcA@mail.gmail.com>
Message-ID: <CAHk-=whyVPgkAfARB7gMjLEyu0kSxmb6qpqfuE_r6QstAzgHcA@mail.gmail.com>
Subject: Re: [GIT PULL] xfs: new code for 5.15
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 2:18 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> As for new features: we now batch inode inactivations in percpu
> background threads, which sharply decreases frontend thread wait time
> when performing file deletions and should improve overall directory tree
> deletion times.

So no complaints on this one, but I do have a reaction: we have a lot
of these random CPU hotplug events, and XFS now added another one.

I don't see that as a problem, but just the _randomness_ of these
callbacks makes me go "hmm". And that "enum cpuhp_state" thing isn't
exactly a thing of beauty, and just makes me think there's something
nasty going on.

For the new xfs usage, I really get the feeling that it's not that XFS
actually cares about the CPU states, but that this is literally tied
to just having percpu state allocated and active, and that maybe it
would be sensible to have something more specific to that kind of use.

We have other things that are very similar in nature - like the page
allocator percpu caches etc, which for very similar reasons want cpu
dead/online notification.

I'm only throwing this out as a reaction to this - I'm not sure
another interface would be good or worthwhile, but that "enum
cpuhp_state" is ugly enough that I thought I'd rope in Thomas for CPU
hotplug, and the percpu memory allocation people for comments.

IOW, just _maybe_ we would want to have some kind of callback model
for "percpu_alloc()" and it being explicitly about allocations
becoming available or going away, rather than about CPU state.

Comments?

> Lastly, with this release, two new features have graduated to supported
> status: inode btree counters (for faster mounts), and support for dates
> beyond Y2038.

Oh, I had thought Y2038 was already a non-issue for xfs. Silly me.

              Linus
