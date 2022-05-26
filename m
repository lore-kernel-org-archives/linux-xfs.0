Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E969C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 15:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiEZP2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 11:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiEZP2h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 11:28:37 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B14A88A8
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:28:35 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id g3so1922005qtb.7
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 08:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BaVNrMWWIKHt2xd8BrQ63IX5vX/dyinQJaaKVP6vrbo=;
        b=ZpH8ztzXqwCA7A+n3LYx7i/3xxZTUN80hX6UIRW8qP1kOZM8I7VR78fcmbH8o9ho5p
         gd/MARUAoWi7E4ZTjDAi36myNw/lAaDhAgrTdymCreUbKZ8hn+jfx6Fx5XpkBYb7UNEE
         kpxudktxpzTVOnpm1+FUq7PXRx6r1DxVsECJVg4ROTAMWBRPC+nGwmmRKuBemP2plNUV
         jzEY5224/JVrZaz/d2P0AA/Dnspyq3nxpnxJoM1r+zrsOKgHtBQ9O1cnh0H1te/Ovvh2
         DysojUfZCA7jkoqBuOFkZywM8RIdhRfaEJlbuG4RA92nhNvtxyiHrEO1PCBvS94nNDE2
         FuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BaVNrMWWIKHt2xd8BrQ63IX5vX/dyinQJaaKVP6vrbo=;
        b=Y++7dOQUm1mBBsQcIXwFPJad9VuhCDguFSgbJiv7B0C3j1wxEKrx0x3QYnRemEOjBh
         oS9rHVgUBcaw3cttDlZcAC4Fuh6ws2wfnAiMEZSY0e8fYOUeEdh2RbYrHl02zEDauqx6
         W+F3sVuo/oZT14CX18lyS/x1P8ICctlw5JhGbReXXGyJ1WiWkfoOfKIOZxPD1NVtLJ0d
         4AsINyAqf/zjr5Cr3P6t6alfurjoTAjt46/SHZd0bQNQMyJWRpNfNhkbGfkfM7FexRb2
         /dsTJHnIYNoA8r8v5bVQdYXAadbbO7TYVBFGr58wbfwO+RlhE8zShDhRK/ayU2B669h6
         Wfzw==
X-Gm-Message-State: AOAM533rQ2xwPCOLACzhKZoTQY5l0TftdAkrkh+6J/NyppKp2aDnt5s0
        +f66S+z+MLNTBxpS/76+gyXI3rc/L8bViWW8dLg=
X-Google-Smtp-Source: ABdhPJzAK42U6snG8c9KhLvDU7TXvXmJwI6BmqH43dPCWmrPlo62Bhk1J1CWTYEgXMmMXLyNnKRqPOBgOBL8uWPc8UE=
X-Received: by 2002:ac8:4e42:0:b0:2f4:fc3c:b0c8 with SMTP id
 e2-20020ac84e42000000b002f4fc3cb0c8mr29461089qtw.684.1653578914711; Thu, 26
 May 2022 08:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster> <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster>
In-Reply-To: <Yo+M6Jhjwt/ruOfi@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 18:28:23 +0300
Message-ID: <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> > Hi Brian,
> >
> > This patch was one of my selected fixes to backport for v5.10.y.
> > It has a very scary looking commit message and the change seems
> > to be independent of any infrastructure changes(?).
> >
> > The problem is that applying this patch to v5.10.y reliably reproduces
> > this buffer corruption assertion [*] with test xfs/076.
> >
> > This happens on the kdevops system that is using loop devices over
> > sparse files inside qemu images. It does not reproduce on my small
> > VM at home.
> >
> > Normally, I would just drop this patch from the stable candidates queue
> > and move on, but I thought you might be interested to investigate this
> > reliable reproducer, because maybe this system exercises an error
> > that is otherwise rare to hit.
> >
> > It seemed weird to me that NOT reusing the extent would result in
> > data corruption, but it could indicate that reusing the extent was masking
> > the assertion and hiding another bug(?).
> >
>
> Indeed, this does seem like an odd failure. The shutdown on transaction
> cancel implies cancellation of a dirty transaction. This is not
> necessarily corruption as much as just being the generic
> naming/messaging related to shutdowns due to unexpected in-core state.
> The patch in question removes some modifications to in-core busy extent
> state during extent allocation that are fundamentally unsafe in
> combination with how allocation works. This change doesn't appear to
> affect any transaction directly, so the correlation may be indirect.
>
> xfs/076 looks like it's a sparse inode allocation test, which certainly
> seems relevant in that it is stressing the ability to allocate inode
> chunks under free space fragmentation. If this patch further restricts
> extent allocation by removing availability of some set of (recently
> freed, busy) extents, then perhaps there is some allocation failure
> sequence that was previously unlikely enough to mask some poor error
> handling logic or transaction handling (like an agfl fixup dirtying a
> transaction followed by an allocation failure, for example) that we're
> now running into.
>
> > Can you think of another reason to explain the regression this fix
> > introduces to 5.10.y?
> >
>
> Not off the top of my head. Something along the lines of the above seems
> plausible, but that's just speculation at this point.
>
> > Do you care to investigate this failure or shall I just move on?
> >
>
> I think it would be good to understand whether there's a regression
> introduced by this patch, a bug somewhere else or just some impedence
> mismatch in logic between the combination of this change and whatever
> else happens to be in v5.10.y. Unfortunately I'm not able to reproduce
> if I pull just this commit back into latest 5.10.y (5.10.118). I've
> tried with a traditional bdev as well as a preallocated and sparse
> loopback scratch dev.

I also failed to reproduce it on another VM, but it reproduces reliably
on this system. That's why I thought we'd better use this opportunity.
This system has lots of RAM and disk to spare so I have no problem
running this test in a VM in parallel to my work.

It is not actually my system, it's a system that Luis has setup for
stable XFS testing and gave me access to, so if the need arises
you could get direct access to the system, but for now, I have no
problem running the test for you.

> Have you tested this patch (backport) in isolation
> in your reproducer env or only in combination with other pending
> backports?
>

I tested it on top of 5.10.109 + these 5 patches:
https://github.com/amir73il/linux/commits/xfs-5.10.y-1

I can test it in isolation if you like. Let me know if there are
other forensics that you would like me to collect.

Thanks,
Amir.
