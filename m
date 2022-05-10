Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58478C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 06:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237206AbiEJGZi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 02:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237135AbiEJGZN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 02:25:13 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C9393E8
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 23:21:15 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id p3so10509975qvi.7
        for <linux-xfs@vger.kernel.org>; Mon, 09 May 2022 23:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xPStSvKhwZgNgW72fWdHGSPULf0/TET5zsm2gAGP/MQ=;
        b=fAYU5dlvmk1J1xgHJoLEz2jeaDXF91PooMJS+3gL1YR+hulBxEEba2RuZrIW3d8yWZ
         DMxZ4XY/9BZFF7hPk7mXGQyIvoZdQeYDBYJOmCJF1tD5BFRcgGpi+J4XRUagao+G/kmn
         iSKAVoTDnRMfRZletbOW3lpxyk2WwQCULctczF+LiZEKZmGU90NulWz5uK7i9t22F9Lz
         eIiL3pYSUM2hvUaVsGs0jqGvA9x8PFjjE/V8BCOjD/NiVXB/ym/dW8nkaOo6tXSq/KKY
         wTb86GAMfCS72PVy6KrPWTmEsESUlPFfsJfcoh5DJu7D0OH+lyp7bF6aPiJkyoTopRy1
         zhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xPStSvKhwZgNgW72fWdHGSPULf0/TET5zsm2gAGP/MQ=;
        b=senvqh96m5wOBSnJuRba6uczgHcGRBYHM+HefvVH85KdoZh2vOfOf95e+GDPzDmZWR
         iisZ6pRwDHqukZqYaMA9WuULXOb/ZATznoqLbU6AVpgldzPHJjtklkeVuKgBmnf4nG6m
         D/GQjR9uAmAZNK5VypXNFy3lP7r+UFBZe925xEJ71HHpoM65N7KFUmUUdHaeqjM7Q1QK
         VsCAiFVSws9JIRHzLS0cTbo0JGcCLF9+yO71zGkUO+Q/1EV410OdVpPSkjibqOQOz8q8
         ax04xVwe9k0iWPl6KBdiaWu3t+okwSvnCXDPNqXc9vh20GNfF8aB96TNPgOR07SkI5fv
         lvbw==
X-Gm-Message-State: AOAM531uvMD6uH/1f58FRc0e3hVEXQg/LsTlylhNSYH62VFNA/ZUHxVc
        vymujQgnYuzWCvpapqb0+G0gW175zPoelVdSa04=
X-Google-Smtp-Source: ABdhPJyb22VDPYFxs7AqKm+xjjTL9URmklCbqZiW+1IZZueDjrAJVb1HFzckQGRl+5kwv+H40zyGUVom0NlYshIIB3Y=
X-Received: by 2002:a05:6214:29e9:b0:45a:c341:baaf with SMTP id
 jv9-20020a05621429e900b0045ac341baafmr16712757qvb.77.1652163674909; Mon, 09
 May 2022 23:21:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxjBR_Z-j_g8teFBih7XPiUCtELgf=k8=_ye84J00ro+RA@mail.gmail.com>
 <20220509182043.GW27195@magnolia>
In-Reply-To: <20220509182043.GW27195@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 10 May 2022 09:21:03 +0300
Message-ID: <CAOQ4uxih7gP25XHh0wm6g9A0b8z05xAbvqEGHD8a_2uw-oDBSw@mail.gmail.com>
Subject: Re: [QUESTION] Upgrade xfs filesystem to reflink support?
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 9, 2022 at 9:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> [drop my oracle email from cc, outlook sux]
>
> On Mon, May 09, 2022 at 10:50:20AM +0300, Amir Goldstein wrote:
> > Hi Darrick and Dave,
> >
> > I might have asked this back when reflink was introduced, but cannot
> > find the question nor answer.
> >
> > Is there any a priori NACK or exceptional challenges w.r.t implementing
> > upgrade of xfs to reflink support?
>
> No, just lack of immediate user demand + time to develop and merge code
> + time to QA the whole mess to make sure it doesn't introduce any
> messes.
>

I can certainly help with QA the upgrade scenarios.

> > We have several customers with xfs formatted pre reflink that we would
> > like to consider
> > upgrading.
> >
> > Back in the time of reflink circa v4.9 there were few xfs features
> > that could be
> > upgraded, but nowadays, there are several features that could be upgraded.
> >
> > If I am not mistaken, the target audience for this upgrade would be
> > xfs formatted
> > with xfsprogs 4.17 (defaults).
> > I realize that journal size may have been smaller at that time (I need to check)
> > which may be a source of additional problems,
>
> Yes.  We've found in practice that logsize < 100MB produce serious
> scalability problems and increase deadlock opportunities on such old
> kernels.  The 64MB floor we just put in for xfsprogs 5.15 was a good
> enough downwards estimate assuming that most people will end up on 5.19+
> kernels in the (very) long run.
>
> > but hopefully, some of your work
> > to do a diet for journal credits for reflink could perhaps mitigate
> > that issue(?).
>
> That work reduces the internal transaction size but leaves the existing
> minimum log size standards intact.
>
> > Shall I take a swing at it?
>
> It's already written:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=upgrade-older-features
>

How convenient :)
I can start testing already.

> I think the upcoming nrext64 xfsprogs patches took in the first patch in
> that series.
>
> Question: Now that mkfs has a min logsize of 64MB, should we refuse
> upgrades for any filesystem with logsize < 64MB?

I think that would make a lot of sense. We do need to reduce the upgrade
test matrix as much as we can, at least as a starting point.
Our customers would have started with at least 1TB fs, so should not
have a problem with minimum logsize on upgrade.

BTW, in LSFMM, Ted had a session about "Resize patterns" regarding the
practice of users to start with a small fs and grow it, which is encouraged by
Cloud providers pricing model.

I had asked Ted about the option to resize the ext4 journal and he replied
that in theory it could be done, because the ext4 journal does not need to be
contiguous. He thought that it was not the case for XFS though.

Thanks,
Amir.
