Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12DBC43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 17:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiFFRRX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiFFRQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 13:16:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00470366A0
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 10:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FE6260FA4
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 17:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE717C34115;
        Mon,  6 Jun 2022 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654535529;
        bh=Rh7klrEbT38QzRQrNaVMXsSVAVZuao0FvbwDidY0dY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mvVsV83xjqW1NQMFBqinJnp4Mxa/nbGnw9Fpst484b8eF44NtPhyjy2i4Z50YRHQ5
         wZ1jgPb9oai22xN8EmgRqu3oXSZW4Wjrm5ySEOssqwWgyzTYzB9pH/oq0SDlBDrexh
         18ZGUtsYn8Dh0Rbsp9ml1IsubU0vyopQ2jA0tTMUSGcVy646V44a6kNZGyVL6gSrtI
         mhu8qT1PALWUaIs7MtM5tJrOisBUy8US7CloGh9cgU6LqtFJWLecTGE5gIskfcMYKq
         5BbZx/rimnEBMwoQCoTTaeyenbFdjdvMw3Oj8MQEAlnrX/JcTB5A5Vq8O/V5RzQ96s
         G/TW6/e9SLNcA==
Date:   Mon, 6 Jun 2022 10:12:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode
 attributes
Message-ID: <Yp41aUNK/TnC3dQ8@magnolia>
References: <YpzbX/5sgRIcN2LC@magnolia>
 <20220605222940.GL1098723@dread.disaster.area>
 <Yp1EGf+d/rzCgvJ4@magnolia>
 <CAOQ4uxiMJ9gGATN8pdPhJhR-_3m2N4vcFTeBPLdLL1DFddRy9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiMJ9gGATN8pdPhJhR-_3m2N4vcFTeBPLdLL1DFddRy9g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 06, 2022 at 10:22:03AM +0300, Amir Goldstein wrote:
> On Mon, Jun 6, 2022 at 8:24 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Mon, Jun 06, 2022 at 08:29:40AM +1000, Dave Chinner wrote:
> > > On Sun, Jun 05, 2022 at 09:35:43AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > >
> > > > It is vitally important that we preserve the state of the NREXT64 inode
> > > > flag when we're changing the other flags2 fields.
> > > >
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/xfs_ioctl.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > Fixes tag?
> 
> Thank you Dave!
> 
> >
> > Does this really need one?
> 
> I say why not.

Every one of these asks adds friction for patch authors.  For code that
has already shipped in a Linus release it's a reasonable ask, but...

> I am not looking for a fight. Really, it's up to xfs maintainers how to manage
> experimental features. That is completely outside of scope for LTS.
> I only want to explain my POV as a developer.
> 
> You know my interest is in backporting fixes for LTS, so this one won't be
> relevant anyway, but if I were you, I would send this patch to stable 5.18.y
> to *reduce* burden on myself -

...WHY?

This is a fix for a new ondisk feature that landed in 5.19-rc1.  The
feature is EXPERIMENTAL, which means that it **should not** be
backported to 5.18, 5.15, or any other LTS kernel.  New features do NOT
fit the criteria for LTS backports.

That's why I didn't bother attaching a fixes tag!

> The mental burden of having to carry the doubt of whether a certain
> reported bug could have been involved with user booting into 5.18.y
> and back.
> 
> When you think about it, it kind of makes sense to have the latest .y
> in your grub menu when you are running upstream...
> Users do that - heck, user do anything you don't want them to do,
> even if eventually you can tell the users they did something that is
> not expected to work, you had already invested the time in triage.
> 
> Sure, there is always the possibility that someone in the future of 5.19.y
> will boot into 5.18.0, but that is a far less likely possibility.
> 
> For this reason, when I write new features I really try to treat the .y
> release as the true release cycle of that feature rather than the .0,
> regardless of LTS.
> If I were the developer of the feature, I would have wanted to see
> this fix applied to 5.18.y.

This fix **WILL NOT APPLY** to 5.18!

--D

> Thanks,
> Amir.
