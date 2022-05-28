Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DBBC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 28 May 2022 14:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiE1OXf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 May 2022 10:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiE1OXe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 May 2022 10:23:34 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5771834B
        for <linux-xfs@vger.kernel.org>; Sat, 28 May 2022 07:23:33 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id j14so6568658qvo.3
        for <linux-xfs@vger.kernel.org>; Sat, 28 May 2022 07:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C5bRaDZTfL6P7H3B0dU1pDqdS9Fj6dNMGogLP3jtWYA=;
        b=DxgrpQ1I8iZu99AweC0N97kgwMC6OlbiBvA7+92yCr1rjjn0rGVvP+Znj/1TA/KCCJ
         84aCGl3ig5h8s/7+A+/v0uUOoFdBuKj1yV5LeTBeHPq+RPqVwUObmdzcLJmW5PEXuW4h
         NKHMF5PcgG5LO3HeDVPZ65YY7/RQsZ3nX0S/I/+T5UgpaUdQ4sGTiuNsRTeKxwGM5VjZ
         cQeg6eBzC5gJ7zjUjqb9HhplhXKGWntTmGY/NFTAnaA/sY1Us3f190ZFMWEQY/119KSu
         1/C3sihogbLTpeeTEJgPi+Vskb3aKPlOn7bk0Ap+b1ysDtgz/O8c/wG+pd9o+WWvMS5z
         dc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C5bRaDZTfL6P7H3B0dU1pDqdS9Fj6dNMGogLP3jtWYA=;
        b=shqZtlqId1yk396sPpnCIwxFThmGi7mvnPe53fLg2tw4X+PY4ROIJG1WM0Q86fImhU
         MIzTk5V7P1LfxSmICj4E6HzTh3rrDlqAbydmxwyJjIq3XBXTG5jU5lfVPMYb42xG+dL3
         SbNs9SASIGiyqVIKJuiSYzI9MTe3igZYuH0/ImfsiEyEsjdI1t70QhTtiZ07O+6gja+z
         /qYD7pstdepIWnsLSE9BMG/dtM6/Vp31GHokYNqIVAh001yHhVSEYoIr4FHOABY345vb
         u1at+0zhdTnpe+EJhPpf9P1DeUCkXsqT7B2wXilRJwFxnt+t4l8EZvC0VDeoj2K9T3E2
         uFaw==
X-Gm-Message-State: AOAM5300RJJ05aXAJvMZoN6nmnxrJ+7gecYUOy/HmbhcXrKpXBtB0/qO
        sNPp04Uh3sogpfN4/fhT52neyXHTGzhp/BnaDB78pIxvXO6GoA==
X-Google-Smtp-Source: ABdhPJwSjvnTYe61rzm2l1+FYRQLvsmGqLfaY3p7xK37e6eh4T/79KR4snud3uaKy5QFEAAXvTx+ZWSUuMGVlo1M+N0=
X-Received: by 2002:a05:6214:1c83:b0:443:6749:51f8 with SMTP id
 ib3-20020a0562141c8300b00443674951f8mr39427701qvb.74.1653747811191; Sat, 28
 May 2022 07:23:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster> <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster> <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
 <Yo/ZZtqa5rkuh7VC@bfoster>
In-Reply-To: <Yo/ZZtqa5rkuh7VC@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 28 May 2022 17:23:19 +0300
Message-ID: <CAOQ4uxgAiJFSUcEcWZo6qT_Pe84pOQ-B8ZORz_y5TQw4NQMjBA@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Gao Xiang <hsiangkao@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 10:47 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Thu, May 26, 2022 at 06:28:23PM +0300, Amir Goldstein wrote:
> > > > Hi Brian,
> > > >
> > > > This patch was one of my selected fixes to backport for v5.10.y.
> > > > It has a very scary looking commit message and the change seems
> > > > to be independent of any infrastructure changes(?).
> > > >
> > > > The problem is that applying this patch to v5.10.y reliably reproduces
> > > > this buffer corruption assertion [*] with test xfs/076.
> > > >
> > > > This happens on the kdevops system that is using loop devices over
> > > > sparse files inside qemu images. It does not reproduce on my small
> > > > VM at home.
> > > >
> > > > Normally, I would just drop this patch from the stable candidates queue
> > > > and move on, but I thought you might be interested to investigate this
> > > > reliable reproducer, because maybe this system exercises an error
> > > > that is otherwise rare to hit.
> > > >
> > > > It seemed weird to me that NOT reusing the extent would result in
> > > > data corruption, but it could indicate that reusing the extent was masking
> > > > the assertion and hiding another bug(?).
> > > >
> > >
> > > Indeed, this does seem like an odd failure. The shutdown on transaction
> > > cancel implies cancellation of a dirty transaction. This is not
> > > necessarily corruption as much as just being the generic
> > > naming/messaging related to shutdowns due to unexpected in-core state.
> > > The patch in question removes some modifications to in-core busy extent
> > > state during extent allocation that are fundamentally unsafe in
> > > combination with how allocation works. This change doesn't appear to
> > > affect any transaction directly, so the correlation may be indirect.
> > >
> > > xfs/076 looks like it's a sparse inode allocation test, which certainly
> > > seems relevant in that it is stressing the ability to allocate inode
> > > chunks under free space fragmentation. If this patch further restricts
> > > extent allocation by removing availability of some set of (recently
> > > freed, busy) extents, then perhaps there is some allocation failure
> > > sequence that was previously unlikely enough to mask some poor error
> > > handling logic or transaction handling (like an agfl fixup dirtying a
> > > transaction followed by an allocation failure, for example) that we're
> > > now running into.
> > >
> > > > Can you think of another reason to explain the regression this fix
> > > > introduces to 5.10.y?
> > > >
> > >
> > > Not off the top of my head. Something along the lines of the above seems
> > > plausible, but that's just speculation at this point.
> > >
> > > > Do you care to investigate this failure or shall I just move on?
> > > >
> > >
> > > I think it would be good to understand whether there's a regression
> > > introduced by this patch, a bug somewhere else or just some impedence
> > > mismatch in logic between the combination of this change and whatever
> > > else happens to be in v5.10.y. Unfortunately I'm not able to reproduce
> > > if I pull just this commit back into latest 5.10.y (5.10.118). I've
> > > tried with a traditional bdev as well as a preallocated and sparse
> > > loopback scratch dev.
> >
> > I also failed to reproduce it on another VM, but it reproduces reliably
> > on this system. That's why I thought we'd better use this opportunity.
> > This system has lots of RAM and disk to spare so I have no problem
> > running this test in a VM in parallel to my work.
> >
> > It is not actually my system, it's a system that Luis has setup for
> > stable XFS testing and gave me access to, so if the need arises
> > you could get direct access to the system, but for now, I have no
> > problem running the test for you.
> >
> > > Have you tested this patch (backport) in isolation
> > > in your reproducer env or only in combination with other pending
> > > backports?
> > >
> >
> > I tested it on top of 5.10.109 + these 5 patches:
> > https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> >
> > I can test it in isolation if you like. Let me know if there are
> > other forensics that you would like me to collect.
> >
>
> Hm. Still no luck if I move to .109 and pull in those few patches. I
> assume there's nothing else potentially interesting about the test env
> other than the sparse file scratch dev (i.e., default mkfs options,
> etc.)? If so and you can reliably reproduce, I suppose it couldn't hurt
> to try and grab a tracepoint dump of the test when it fails (feel free
> to send directly or upload somewhere as the list may punt it, and please
> also include the dmesg output that goes along with it) and I can see if
> that shows anything helpful.
>
> I think what we want to know initially is what error code we're
> producing (-ENOSPC?) and where it originates, and from there we can
> probably work out how the transaction might be dirty. I'm not sure a
> trace dump will express that conclusively. If you wanted to increase the
> odds of getting some useful information it might be helpful to stick a
> few trace_printk() calls in the various trans cancel error paths out of
> xfs_create() to determine whether it's the inode allocation attempt that
> fails or the subsequent attempt to create the directory entry..
>

The error (-ENOSPC) comes from this v5.10 code in xfs_dir_ialloc():

        if (!ialloc_context && !ip) {
                *ipp = NULL;
                return -ENOSPC;
        }

Which theoretically might trip after xfs_ialloc() has marked the transaction
dirty(?).

This specific code is gone with this cleanup series in v5.11:

https://lore.kernel.org/linux-xfs/20201209112820.114863-1-hsiangkao@redhat.com/

When the $SUBJECT patch is applied to v5.11.16 the test xfs/076 does not fail.

So either the $SUBJECT patch (from 5.12) is incompatible with v5.10 code
or the cleanup series somehow managed to make my system not reproduce
the bug anymore.

I will assume the former and drop this patch from v5.10.y candidates.
If you want me to continue to research the bug on v5.10 let me know
what else you want me to check.

Thanks,
Amir.
