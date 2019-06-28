Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41524 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfF1Eqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 00:46:46 -0400
Received: by mail-yb1-f195.google.com with SMTP id y67so2957972yba.8
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2019 21:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
 <20190627155455.GA30113@42.do-not-panic.com> <CAOQ4uxgqgDAdKZDYwmf0M35M3D6Ctn25-VVj3wu5XSj_4c-WdA@mail.gmail.com>
 <20190627213520.GG19023@42.do-not-panic.com>
In-Reply-To: <20190627213520.GG19023@42.do-not-panic.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Jun 2019 07:46:34 +0300
Message-ID: <CAOQ4uxht-inVEjRWXtkbRPXTA9DvRNTLSPNEZ0Eh=nUhEhNO-A@mail.gmail.com>
Subject: Re: [backport request][stable] xfs: xfstests generic/538 failed on xfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alvin Zheng <Alvin@linux.alibaba.com>, gregkh <gregkh@linuxfoundation.org>, linux-xfs <linux-xfs@vger.kernel.org>, Brian Foster <bfoster@redhat.com>, "joseph.qi" <joseph.qi@linux.alibaba.com>, caspar <caspar@linux.alibaba.com>, Sasha Levin <sashal@kernel.org>

On Fri, Jun 28, 2019 at 12:35 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Thu, Jun 27, 2019 at 07:18:40PM +0300, Amir Goldstein wrote:
> > On Thu, Jun 27, 2019 at 6:55 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Thu, Jun 27, 2019 at 08:10:56PM +0800, Alvin Zheng wrote:
> > > > Hi,
> > > >
> > > >     I  was using kernel v4.19.y and found that it cannot pass the
> > > > generic/538 due to data corruption. I notice that upstream has fix this
> > > > issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y
> > > > backport this patch?
> > >
> > > Hey Alvin,
> > >
> > > Thanks for Bringing this to attention.  I'll look into this a bit more.
> > > Time for a new set of stable fixes for v4.19.y. Of course, I welcome
> > > Briant's feedback, but if he's busy I'll still look into it.
> > >
> >
> > FWIW, I tested -g quick on xfs with reflink=1,rmapbt=1 and did not
> > observe any regressions from v4.19.55.
>
> As you may recall I test all agreed upon configurations. Just one is not
> enough.

Of course. It's just a heads up that testing looks sane so far.

>
> > Luis, sorry I forgot to CC you on a request I just sent to consider 4 xfs
> > patches for stable to fix generic/529 and generic/530:
> >
> > 3b50086f0c0d xfs: don't overflow xattr listent buffer
> > e1f6ca113815 xfs: rename m_inotbt_nores to m_finobt_nores
> > 15a268d9f263 xfs: reserve blocks for ifree transaction during log recovery
> > c4a6bf7f6cc7 xfs: don't ever put nlink > 0 inodes on the unlinked list
> >
> > If you can run those patches through your setup that would be great.
>
> Sure, it may take 1-2 weeks, just a heads up. If you're OK with waiting
> then great. Otherwise I personally cannot vouch for them. What types of
> tests did you run and what configurations?
>

So far I tested, -g quick with reflink=1,rmapbt=1.

Sasha wrote that more results will be in tomorrow...

Thanks,
Amir.
