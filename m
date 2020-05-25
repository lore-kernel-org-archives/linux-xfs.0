Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B275C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 07:02:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8491206DD
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 07:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nk53v7n9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388934AbgEYHCy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 May 2020 03:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388385AbgEYHCy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 May 2020 03:02:54 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88A0C061A0E
        for <linux-xfs@vger.kernel.org>; Mon, 25 May 2020 00:02:53 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id d7so17721740ioq.5
        for <linux-xfs@vger.kernel.org>; Mon, 25 May 2020 00:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7+iOOw/QgAxLsV68rqYZ9eEavEEmLiM3PxzBIfCvL3Y=;
        b=Nk53v7n9XhZ6f8aXEPvl+q8ekmQPGy1P71wg7iCQE7SdOGLlFT2aozVvPfzBfhXL+w
         6rS0eRSKOKT5CydHgI8maYfuK6YvBrAvUW9PpmDCh+3w57nEdCJMUpTCQrKfy3xVxbI0
         KSTAoKQyFrFK7tFzEMGFsYc0E1p7cJiywGLqdxEmDWCG6u88vcs3Z9TTVN/sdsqFfASi
         gRmjVSnxStvnAwlMrewNtq3YyFxDVEB3MCv2l4rMtbLgm/Kn/NH3WH7sogc5CAZcSNBg
         lSuMqkwJa9RF3pfjI+iguQPBTchPldzTAgs7D72iYQH6RKU272OP0RHyoQUmDPzaTI5W
         881Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7+iOOw/QgAxLsV68rqYZ9eEavEEmLiM3PxzBIfCvL3Y=;
        b=glRJbttQ3CevffKk2Tv3LD7+BFkFgkTq0ehwVmWsxZzdK/e4JF6JKO+l7Sv710q/kq
         za6yv5xXF5tIfR7TthsW4e3ksz3aG1voqKcOqS/Jj0zAW4eOkzheUSjJaK8z2ZN3izXT
         Jw0lXP43a4U7mXIbNR1Jz4YdO6bwX2qi3aX/j4xI+5Y5sEDGeYrFKsxoNRFP1/a26Hp5
         zNvB1roPAvBmZqDnuGv6Tyn82hRh6n1oU+CI8ueIU+cniNkiIToboRNy+XG1WAx6JZCU
         23BubFCoZxjDVhBdR/p7ZntIQSIXnzarMTqxWvuAwmmSAWPUnKEaVeFeP8b9xFKnDf5L
         ut5A==
X-Gm-Message-State: AOAM532UTpzxfHHwMqr3dKR97XjUSh8sWlUnElqTGzjVyuQgJlj29FVr
        jbom4IlvMppUTMVnAGNfpwhJ/5Xo9vrv10E1p14=
X-Google-Smtp-Source: ABdhPJxNPqg16Oaz2ZvHJTrRIMnlr5UI/OO2eo8qNp7Zd0G7apZhCE6nXSzv/2lySKVOAACcBPHV7GUs29wQMNp9Hg8=
X-Received: by 2002:a05:6602:2437:: with SMTP id g23mr3421370iob.5.1590390173228;
 Mon, 25 May 2020 00:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200513023618.GA2040@dread.disaster.area> <20200519062338.GH17627@magnolia>
 <20200520011430.GS2040@dread.disaster.area> <20200520151510.11837539@harpe.intellique.com>
 <20200525032354.GV2040@dread.disaster.area> <20200525060804.GC252930@magnolia>
In-Reply-To: <20200525060804.GC252930@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 25 May 2020 10:02:42 +0300
Message-ID: <CAOQ4uxhOfv6K6LDva91Y1_Oe-3pd6T1jRt=9T_ZXuBrBBCpwjQ@mail.gmail.com>
Subject: Re: [XFS SUMMIT] Deprecating V4 on-disk format
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Emmanuel Florac <eflorac@intellique.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 25, 2020 at 9:12 AM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> On Mon, May 25, 2020 at 01:23:54PM +1000, Dave Chinner wrote:
> > On Wed, May 20, 2020 at 03:15:10PM +0200, Emmanuel Florac wrote:
> > > Le Wed, 20 May 2020 11:14:30 +1000
> > > Dave Chinner <david@fromorbit.com> =C3=A9crivait:
> > >
> > > > Well, there's a difference between what a distro that heavily
> > > > patches the upstream kernel is willing to support and what upstream
> > > > supports. And, realistically, v4 is going to be around for at least
> > > > one more major distro release, which means the distro support time
> > > > window is still going to be in the order of 15 years.
> > >
> > > IIRC, RedHat/CentOS v.7.x shipped with a v5-capable mkfs.xfs, but
> > > defaulted to v4. That means that unless you were extremely cautious
> > > (like I am :) 99% of RH/COs v7 will be running v4 volumes for the
> > > coming years. How many years, would you ask?
> >
> > Largely irrelevant to the question at hand, as support is dependent
> > on the distro lifecycle here. Essentially whatever is in RHEL7 is
> > supported by RH until the end of it's life.
> >
> > In RHEL8, we default to v5 filesystems, but fully support v4. That
> > will be the case for the rest of it's life. Unless the user
> > specifically asks for it, no new v4 filesystems are being created on
> > current RHEL releases.
> >
> > If we were to deprecate v4 now, then it will be marked as deprecated
> > in the next major RHEL release. That means it's still fully
> > supported in that release for it's entire life, but it will be
> > removed in the next major release after that. So we are still
> > talking about at least 15+ years of enterprise distro support for
> > the format, even if upstream drops it sooner...
>
> We probably ought to do it sooner than later though, particularly if we
> think/care about 5.9 turning into an LTS.
>
> > > As for the lifecycle of a filesystem, I just ended support on a 40 TB
> > > archival server I set up back in 2007. I still have a number of
> > > supported systems from the years 2008-2010, and about a hundred from
> > > 2010-2013. That's how reliable XFS is, unfortunately :)
> >
> > Yup, 10-15 years is pretty much the expected max life of storage
> > systems before the hardware really needs to be retired. We made v5
> > the default 5 years ago, so give it another 10 years (the sort of
> > timeframe we are talking about here) and just about
> > everything will be running v5 and that's when v4 can likely be
> > dropped.
> >
> > The other thing to consider is that we need to drop v4 before we get
> > to y2038 support issues as the format will never support dates
> > beyond that. Essentially, we need to have the deprecation discussion
> > and take action in the near future so that people have stopped using
> > it before y2038 comes along and v4 filesystems break everything.
> >
> > Not enough people think long term when it comes to computers - it
> > should be more obvious now why I brought this up for discussion...
>
> Ok then, who would like to help me get the y2038 timestamp patches
> reviewed for ~5.9? :D
>

I can help with review. Already looked at your branch.

Thanks,
Amir.
