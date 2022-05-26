Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BFFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 26 May 2022 19:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347746AbiEZTdV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 May 2022 15:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiEZTdU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 May 2022 15:33:20 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4E23CFDA
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 12:33:18 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 14so2245985qkl.6
        for <linux-xfs@vger.kernel.org>; Thu, 26 May 2022 12:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4YQsX9PEH8mSOT6tN93BNoliWSqCAIkxheh/nBeuams=;
        b=NRbaNQA3BKXXkrLw3jEi/g4ee5Bt85xPZz0e9MSszz4/YiQWfUlMJeNvbT1aWmRXzL
         N4jPk7usK+8Ba//tDoBX251oSZHUgBg/cwq0bGysAyZKiq0PrhBZq+YfDwMDHt/q1our
         Oz9bbt9jahWSjOAorD7aEKWveQOgwpqvFoBcZSIrRqdDR/w1O2Egeu+ewO9KORoatby4
         rMWmbjjQnhnX6PCOki03C9Y/hZ5kQUcLSH0GIncQ4uHVSO1kUIxPVcvMuoaxODx1lwSZ
         APw9JlBf29ynJOafJ1kDlEjThrVju75q95xFZFGhzDPFbzQYzBNNB88lAGoeUpGQkRz8
         7RyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4YQsX9PEH8mSOT6tN93BNoliWSqCAIkxheh/nBeuams=;
        b=uqlc+NhHP6gUHVXY5aIypDkBJkoN5nXnnrquDgVZkvTFozd2AEeAaVsmNih902Y/+1
         4osigBuk99LStS8yREw1JSm0EngGcq3FvAm6ICVhEVCDhZ6bKzsaQgEPoKxWFtLYbAM2
         +oAsmCNiOsD11ufeznoD9b5HmkiH8DqDszmNzRzGen9DpoB2TAuduAz5msc87Z8RwsPl
         jdYKftaqBfL0r4+d9fN8GeGV0pz0ux0L6WbVv6gh/hRUzg2L+YYruyVX/pd/RnwE0842
         wrxxm4qNgxPmtNWVVpZRUTXgutq21WFLkHXeIQX88+qtI4yqomy254OmA2aolJ/c7X+b
         E0QA==
X-Gm-Message-State: AOAM531RAdQRuCVGLUWRT3xz5cnvJ5pCkLgJmm/zWgHkqMs/PDg0Y8XU
        OjjRC2ANw3i9k2B0oGVxWp9KiPkuehCd12mJb00=
X-Google-Smtp-Source: ABdhPJzyZiRQcJf0CrU0WEct6AN4nORQ+wIM9gFjvur0c99DvyV79bqYqwC5eAGlie7SyWuuzqs6p6qJCJEuqmX487g=
X-Received: by 2002:a37:8802:0:b0:6a3:4aa4:7cb4 with SMTP id
 k2-20020a378802000000b006a34aa47cb4mr22247596qkd.722.1653593597999; Thu, 26
 May 2022 12:33:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster> <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster> <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 26 May 2022 22:33:06 +0300
Message-ID: <CAOQ4uxjtOMBtcckeoGX3iBksmNGj2y-qKYys9nqeXJOsrqBc6w@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 26, 2022 at 6:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > Hi Brian,
> > >
> > > This patch was one of my selected fixes to backport for v5.10.y.
> > > It has a very scary looking commit message and the change seems
> > > to be independent of any infrastructure changes(?).
> > >
> > > The problem is that applying this patch to v5.10.y reliably reproduces
> > > this buffer corruption assertion [*] with test xfs/076.
> > >
> > > This happens on the kdevops system that is using loop devices over
> > > sparse files inside qemu images. It does not reproduce on my small
> > > VM at home.
> > >
> > > Normally, I would just drop this patch from the stable candidates queue
> > > and move on, but I thought you might be interested to investigate this
> > > reliable reproducer, because maybe this system exercises an error
> > > that is otherwise rare to hit.
> > >
> > > It seemed weird to me that NOT reusing the extent would result in
> > > data corruption, but it could indicate that reusing the extent was masking
> > > the assertion and hiding another bug(?).
> > >
> >
> > Indeed, this does seem like an odd failure. The shutdown on transaction
> > cancel implies cancellation of a dirty transaction. This is not
> > necessarily corruption as much as just being the generic
> > naming/messaging related to shutdowns due to unexpected in-core state.
> > The patch in question removes some modifications to in-core busy extent
> > state during extent allocation that are fundamentally unsafe in
> > combination with how allocation works. This change doesn't appear to
> > affect any transaction directly, so the correlation may be indirect.
> >
> > xfs/076 looks like it's a sparse inode allocation test, which certainly
> > seems relevant in that it is stressing the ability to allocate inode
> > chunks under free space fragmentation. If this patch further restricts
> > extent allocation by removing availability of some set of (recently
> > freed, busy) extents, then perhaps there is some allocation failure
> > sequence that was previously unlikely enough to mask some poor error
> > handling logic or transaction handling (like an agfl fixup dirtying a
> > transaction followed by an allocation failure, for example) that we're
> > now running into.
> >
> > > Can you think of another reason to explain the regression this fix
> > > introduces to 5.10.y?
> > >
> >
> > Not off the top of my head. Something along the lines of the above seems
> > plausible, but that's just speculation at this point.
> >
> > > Do you care to investigate this failure or shall I just move on?
> > >
> >
> > I think it would be good to understand whether there's a regression
> > introduced by this patch, a bug somewhere else or just some impedence
> > mismatch in logic between the combination of this change and whatever
> > else happens to be in v5.10.y. Unfortunately I'm not able to reproduce
> > if I pull just this commit back into latest 5.10.y (5.10.118). I've
> > tried with a traditional bdev as well as a preallocated and sparse
> > loopback scratch dev.
>
> I also failed to reproduce it on another VM, but it reproduces reliably
> on this system. That's why I thought we'd better use this opportunity.
> This system has lots of RAM and disk to spare so I have no problem
> running this test in a VM in parallel to my work.
>
> It is not actually my system, it's a system that Luis has setup for
> stable XFS testing and gave me access to, so if the need arises
> you could get direct access to the system, but for now, I have no
> problem running the test for you.
>
> > Have you tested this patch (backport) in isolation
> > in your reproducer env or only in combination with other pending
> > backports?
> >
>
> I tested it on top of 5.10.109 + these 5 patches:
> https://github.com/amir73il/linux/commits/xfs-5.10.y-1
>
> I can test it in isolation if you like. Let me know if there are
> other forensics that you would like me to collect.
>.

FWIW, the test fails with just that one patch over 5.10.109.

Thanks,
Amir.
