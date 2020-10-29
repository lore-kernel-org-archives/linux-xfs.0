Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258B1C4741F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B48DD2087E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMf1nXCl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgJ2VkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJ2VkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:40:11 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF6BC0613CF;
        Thu, 29 Oct 2020 14:40:11 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id b15so5271783iod.13;
        Thu, 29 Oct 2020 14:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1WZlCf7JUTHahucfauXQzwMo4FKTOdZMhvitT8jPHlo=;
        b=iMf1nXClDBj1i649/LhE+I/IKLM+RtQKEMVQ3sT7llLq8I6v1JDV6cfi0JtjdTN1sl
         3fO6aR4ZUDen53Xa0xYiPGDFxlLCjFQxsjfrHqGkRoAxqbozo3DrqQXWoQ4lsyEqSChX
         BTnkOvb4T29gzNa5ifB/id0ZjxQWYz2F8s44nx0ltCUlfT4/xdGuPfL6P2nRnRA8ml8R
         T1znju9t2dwQIlPWeJDsceicausnDEhAbvDH+2BucFKsRUWu5BpDRFvaO9u7rqcUimM3
         M+4ZXdlSHaTFJ+oR57cwxIIGtKQ3H2qAJ5q4W7xu4cKN93ogCQCRHYsO3uFm0GMXFIMl
         bfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1WZlCf7JUTHahucfauXQzwMo4FKTOdZMhvitT8jPHlo=;
        b=bRXFWnhjWg6oop0KMTHEiGlFhPX+lYstpcE7oSQ6dTFc4/sCsWqDcx8xDBsu1SDxXC
         CvljH4z1BLUP3UQs+Y81nGr0vCSdAGcAu9mDBY43Tng1fyysITEtLtN2Fj5LSvOEZ9I1
         v9DeROeS5T51gpK6wRZeNhHyumo9jFjibPSCFc1DL6HhnTxT3FIrr3SQ4YMSOngPf+9y
         +unXMlfc5bfmgiJ/KoMtSFASJHgPB+peZmoqQwxQP58jEb/PyReW/hrdDCDD0JRQ+2xf
         OeR6pXOsClbaCcmWWEmWxBFGsuiKY6Q7bzL5rbAEWla3mP+HqAZlhZWLi0wBBpIOisOX
         saGQ==
X-Gm-Message-State: AOAM530ZCx0wpqufvStrY5tiVA0sdB1IAJ8Mu4sUvDaRnd9lLjg2fZPS
        cruM51FFGxvYE38xn6CC0xqpQDGqmLpAvg6yOY2Ud8V41M0=
X-Google-Smtp-Source: ABdhPJylv7OzpxMpJEfrTDhlJk+gIKPfsCSYCJuaVEVxR7VPtDXvU1ufCY9t7XlS6S7R4emJvtjxcjZlX29UQ7uj1+w=
X-Received: by 2002:a6b:1542:: with SMTP id 63mr5145694iov.64.1604007611151;
 Thu, 29 Oct 2020 14:40:11 -0700 (PDT)
MIME-Version: 1.0
References: <160382543472.1203848.8335854864075548402.stgit@magnolia>
 <160382544101.1203848.15837078115947156573.stgit@magnolia>
 <CAOQ4uxh9ihsUTsuaFdDTkP4rguNyAfDKq3_k6y1iEpZ3qoU2TQ@mail.gmail.com> <20201029205543.GC1061252@magnolia>
In-Reply-To: <20201029205543.GC1061252@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 29 Oct 2020 23:40:00 +0200
Message-ID: <CAOQ4uxjZ7tpkJAXVHWvj5M0G4QM4vSeQ+GXszSij7wVbePJdXw@mail.gmail.com>
Subject: Re: [PATCH 1/4] generic: check userspace handling of extreme timestamps
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Deepa Dinamani <deepa.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 29, 2020 at 11:02 PM Darrick J. Wong
<darrick.wong@oracle.com> wrote:
>
> On Thu, Oct 29, 2020 at 12:34:57PM +0200, Amir Goldstein wrote:
> > On Wed, Oct 28, 2020 at 10:25 PM Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > These two tests ensure we can store and retrieve timestamps on the
> > > extremes of the date ranges supported by userspace, and the common
> > > places where overflows can happen.
> > >
> > > They differ from generic/402 in that they don't constrain the dates
> > > tested to the range that the filesystem claims to support; we attempt
> > > various things that /userspace/ can parse, and then check that the vfs
> > > clamps and persists the values correctly.
> >
> > So this test will fail when run on stable kernels before the vfs
> > clamping changes
> > and there is no require_* to mitigate that failure.
>
> Yes, that is the intended outcome.  Those old kernels silently truncate
> the high bits from those timestamps when inodes are flushed to disk, and
> the only user-visible evidence of this comes much later when the system
> reboots and suddenly the timestamps are wrong.  Clamping also seems a
> little strange, but at least it's immediately obvious.
>
> It is very surprising that you could set a timestamp of 2 Apr 2500 on
> ext2, ls your shiny futuristic timestamp, reboot, and have it become
> 5 Nov 1955.  Only Marty McFly would be amused.
>

OK. So we can call it a bug in old kernels that is not going to be fixed
in stable updates. The minimum we can do for stable kernel testers is
provide a decent way to exclude the tests for clamping.

I guess 'check -x bigtime' is decent enough.
I might have named the group 'timelimit' but I can live with 'bigtime'.

So with fix for the rest of my minor nits, you may add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
