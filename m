Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B057C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 19:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245053AbiEJTCP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 15:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiEJTCP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 15:02:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E3C17E32
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 12:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 625216113A
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 19:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDF1C385C2;
        Tue, 10 May 2022 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652209332;
        bh=aDyXWuHFxe11vc4HTrZuEN8rOKau0nJm3E7iZrF4I8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=flvRkkAk/aPpDRRdROkgeDy2INOzeijgtWaXmdeSk8TnWi2wcDudjtVElYmS8ThXA
         sEmKrlrLnxa7x8nbemV2nunvOuhcQkTcaIp00kGVn9eri2K1vF8Q1GsvGLaDDhpw5V
         +8MsvtvIP1LJQEy4GAjD9ef/9Gzrdm+7CB7MIw+wSCWQk7WoXutH6vP2oJBBfaEipq
         lQ9Aa16a0nrQpSNBF3YGsAuZv44jxqpA0UWLlzz4f5ApRgR+17JXGKklEQqEvP68BC
         flXLxk8GqF5/2eAeTReM6isfaqjztmYlqNMl+RjEPafrv8CWvblW0t7oSxz6GFBC+9
         y0bXdPpS9cbnQ==
Date:   Tue, 10 May 2022 12:02:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
Message-ID: <20220510190212.GC27195@magnolia>
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
 <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 09:21:03AM +0300, Amir Goldstein wrote:
> On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > [drop my oracle email from cc, outlook sux]
> >
> > On Mon, May 09, 2022 at 10:50:20AM +0300, Amir Goldstein wrote:
> > > Hi Darrick and Dave,
> > >
> > > I might have asked this back when reflink was introduced, but cannot
> > > find the question nor answer.
> > >
> > > Is there any a priori NACK or exceptional challenges w.r.t implementing
> > > upgrade of xfs to reflink support?
> >
> > No, just lack of immediate user demand + time to develop and merge code
> > + time to QA the whole mess to make sure it doesn't introduce any
> > messes.
> >
> 
> I can certainly help with QA the upgrade scenarios.
> 
> > > We have several customers with xfs formatted pre reflink that we would
> > > like to consider
> > > upgrading.
> > >
> > > Back in the time of reflink circa v4.9 there were few xfs features
> > > that could be
> > > upgraded, but nowadays, there are several features that could be upgraded.
> > >
> > > If I am not mistaken, the target audience for this upgrade would be
> > > xfs formatted
> > > with xfsprogs 4.17 (defaults).
> > > I realize that journal size may have been smaller at that time (I need to check)
> > > which may be a source of additional problems,
> >
> > Yes.  We've found in practice that logsize < 100MB produce serious
> > scalability problems and increase deadlock opportunities on such old
> > kernels.  The 64MB floor we just put in for xfsprogs 5.15 was a good
> > enough downwards estimate assuming that most people will end up on 5.19+
> > kernels in the (very) long run.
> >
> > > but hopefully, some of your work
> > > to do a diet for journal credits for reflink could perhaps mitigate
> > > that issue(?).
> >
> > That work reduces the internal transaction size but leaves the existing
> > minimum log size standards intact.
> >
> > > Shall I take a swing at it?
> >
> > It's already written:
> > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features
> >
> 
> How convenient :)
> I can start testing already.
> 
> > I think the upcoming nrext64 xfsprogs patches took in the first patch in
> > that series.
> >
> > Question: Now that mkfs has a min logsize of 64MB, should we refuse
> > upgrades for any filesystem with logsize < 64MB?
> 
> I think that would make a lot of sense. We do need to reduce the upgrade
> test matrix as much as we can, at least as a starting point.
> Our customers would have started with at least 1TB fs, so should not
> have a problem with minimum logsize on upgrade.
> 
> BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
> practice of users to start with a small fs and grow it, which is encouraged by
> Cloud providers pricing model.
> 
> I had asked Ted about the option to resize the ext4 journal and he replied
> that in theory it could be done, because the ext4 journal does not need to be
> contiguous. He thought that it was not the case for XFS though.

It's theoretically possible, but I'd bet that making it work reliably
will be difficult for an infrequent operation.  The old log would probably
have to clean itself, and then write a single transaction containing
both the bnobt update to allocate the new log as well as an EFI to erase
it.  Then you write to the new log a single transaction containing the
superblock and an EFI to free the old log.  Then you update the primary
super and force it out to disk, un-quiesce the log, and finish that EFI
so that the old log gets freed.

And then you have to go back and find the necessary parts that I missed.

--D

> Thanks,
> Amir.
