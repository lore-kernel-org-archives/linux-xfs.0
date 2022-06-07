Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BDDC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jun 2022 06:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiFGGtX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jun 2022 02:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiFGGtK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jun 2022 02:49:10 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0CA3EF23
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 23:49:09 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id m30so3200959vkf.11
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jun 2022 23:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nFxNrb6LPP6PKfmdys05Glsg4xiWkCgcg8ZZ3TfXGCw=;
        b=R06kiFfM7s03+8CW7D4tG5rWKIN+2czOp+Kbe7oAssb4payg42Ae+RAQjq/bz6NY/B
         Rpk39upD+oqV8xwAhKAhP+4QE/C20JCfMYs2e4OZWwYm/eeuVumRytiREQ39+dBJi2Z1
         VxE0uZylZmrVQQF+toc0BWxHA5Bast0cwHI9lZ/f442oyCzvYRCLnXyDtOKE/nZhp0dn
         V1KLPbkaxZsr5i33F0m8MQM0XQYag96hU4i5R+jVmszZ1qgDVZPiR3ShbYx7+NWbti8m
         qVlZTk7GQSZQQqMZhmEpstCsoNsLlgje0mntSnc2oIc4XvwqG0l2eVZBiQjpNOaG4KgZ
         O8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nFxNrb6LPP6PKfmdys05Glsg4xiWkCgcg8ZZ3TfXGCw=;
        b=q1wj+NWsYLvq5WnqmLtnLzUfD8pNwPx4xlAPWaVv4kbetY7XUj1ry2SGjEYGZmfRx5
         BUq3sy60yZFpEw4T/EpuXjYw0eOcX+L5922F6jHXtG6oCsy/LP6DzmH8jRG8T/7E8k5a
         jali4hXJSgmXp90iSZUxbFBXwSpN9LF6vWHwWnfl2UtE39VxeVNeJtqDZAXmbX9fZRvu
         khumboow20Doj/jnv6R5JpP/9MgqH9kptyuecTEtxZorT1WMKTy9WXG68xhnQbQtmxA2
         VWSddFDRLSquztGXbXrz/woFufe37G9mUiGgcgLMx31LMdb+G3KWiePvxs2poU5/w99P
         fFgA==
X-Gm-Message-State: AOAM530OzIAVr8xLwM7T3HPNn6+k4Wbt340TdNFO+izb4TWapVrCKM39
        kuh9q5kXBhYpJpqkZNIAqJ7LcrHXmIKBqLMX0zE0xOA83kY=
X-Google-Smtp-Source: ABdhPJz/gTK32rnYF6qnAbnNE+uGZCKJmWN8nFenS88V9Tbb9c3lPX0pl7nCssmp39ffmyuK/UnDTac1DXC/lK+B6w4=
X-Received: by 2002:a05:6122:214d:b0:35d:94e0:55fb with SMTP id
 m13-20020a056122214d00b0035d94e055fbmr6900608vkd.3.1654584548155; Mon, 06 Jun
 2022 23:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <YpzbX/5sgRIcN2LC@magnolia> <20220605222940.GL1098723@dread.disaster.area>
 <Yp1EGf+d/rzCgvJ4@magnolia> <CAOQ4uxiMJ9gGATN8pdPhJhR-_3m2N4vcFTeBPLdLL1DFddRy9g@mail.gmail.com>
 <Yp41aUNK/TnC3dQ8@magnolia>
In-Reply-To: <Yp41aUNK/TnC3dQ8@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Jun 2022 09:48:57 +0300
Message-ID: <CAOQ4uxiY7mtM=O-SO=1oL-XA9Zn3HwCNM-6QtCDGzR8V=t9O=A@mail.gmail.com>
Subject: Re: [PATCH] xfs: preserve DIFLAG2_NREXT64 when setting other inode attributes
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 6, 2022 at 8:12 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Mon, Jun 06, 2022 at 10:22:03AM +0300, Amir Goldstein wrote:
> > On Mon, Jun 6, 2022 at 8:24 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > On Mon, Jun 06, 2022 at 08:29:40AM +1000, Dave Chinner wrote:
> > > > On Sun, Jun 05, 2022 at 09:35:43AM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > >
> > > > > It is vitally important that we preserve the state of the NREXT64 inode
> > > > > flag when we're changing the other flags2 fields.
> > > > >
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/xfs_ioctl.c |    3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > Fixes tag?
> >
> > Thank you Dave!
> >
> > >
> > > Does this really need one?
> >
> > I say why not.
>
> Every one of these asks adds friction for patch authors.  For code that
> has already shipped in a Linus release it's a reasonable ask, but...
>
> > I am not looking for a fight. Really, it's up to xfs maintainers how to manage
> > experimental features. That is completely outside of scope for LTS.
> > I only want to explain my POV as a developer.
> >
> > You know my interest is in backporting fixes for LTS, so this one won't be
> > relevant anyway, but if I were you, I would send this patch to stable 5.18.y
> > to *reduce* burden on myself -
>
> ...WHY?
>
> This is a fix for a new ondisk feature that landed in 5.19-rc1.  The
> feature is EXPERIMENTAL, which means that it **should not** be
> backported to 5.18, 5.15, or any other LTS kernel.  New features do NOT
> fit the criteria for LTS backports.
>
> That's why I didn't bother attaching a fixes tag!
>
> > The mental burden of having to carry the doubt of whether a certain
> > reported bug could have been involved with user booting into 5.18.y
> > and back.
> >
> > When you think about it, it kind of makes sense to have the latest .y
> > in your grub menu when you are running upstream...
> > Users do that - heck, user do anything you don't want them to do,
> > even if eventually you can tell the users they did something that is
> > not expected to work, you had already invested the time in triage.
> >
> > Sure, there is always the possibility that someone in the future of 5.19.y
> > will boot into 5.18.0, but that is a far less likely possibility.
> >
> > For this reason, when I write new features I really try to treat the .y
> > release as the true release cycle of that feature rather than the .0,
> > regardless of LTS.
> > If I were the developer of the feature, I would have wanted to see
> > this fix applied to 5.18.y.
>
> This fix **WILL NOT APPLY** to 5.18!
>

I stand corrected.
Sorry for the noise.

Amir.
