Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787ADC432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 15:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C73D222A2
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 15:50:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvN8lx/B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbfKSPuL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:50:11 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40866 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbfKSPuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 10:50:10 -0500
Received: by mail-lf1-f67.google.com with SMTP id v24so6562265lfi.7
        for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2019 07:50:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHM9rnMVqIIgbiRdkSn4Tm1XJ1ieQPUt/0gklGDasp0=;
        b=kvN8lx/BK5VAfjoSPToJZIMpAeGAG7/Mnj98g8wflQnYhBF6GccVYQGNmzhUk20c2a
         US68euFZfPATywlA3NfvPZlCcXBRzjSY4tT6lAuDyIcRjdPUrRXrxv+Qc3EwI481FUFs
         pbzzQpEwvUBawayB2qu2D0HcSu+5D8Kr4Mu/kOG8P9Y0i7YThEShaj6AANgO4KbtST6D
         jKWpdh/MA+y6yBcGbjFMsj58RPcyLSuMpsULqbmn0lRG4/A1/nS28/4DQhohsjQEF6CE
         fDopoVZtEsfvEOKtq9XOSHuTDGqsED9U/WOgYf+yNmX2iGqclaRe/pje4005+2Mb+/zd
         W8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHM9rnMVqIIgbiRdkSn4Tm1XJ1ieQPUt/0gklGDasp0=;
        b=t1WELFpKJuMCLPvblllUy/t045sAfrubHq9xfeoERiVKx1/4MI1cEQQdp0P3zlIQrN
         dLUPazk2RF2IEpIz/gVjjDqI8aU82Cnya2hrdkyzuICfW5GoULRDM2Ni3q44QiWw9oSz
         P/Ykolu+ylptNFM+95sb4/J6rxn57fE68HbAtjCwZZ2VIIBh/Gfj21gnvScVbS3Pn0n5
         jrxQak2qZakKDyzXs9kQJil7n4CqGJPm0b+IIOASQbrxTnOqYYVTorDimXU6Le2D5Xr5
         b62/GJlhpwXXte1gwkONadR6PbrqbHqnQrEVzsn4/5WUKrEI5gEFfH43jkP+j5DSDYXY
         VeJA==
X-Gm-Message-State: APjAAAWmc64b2EV1TgmvzzVZsews04MujeKfN+jMQntgC7PYApJX5/+a
        e8TuFIpPQS+k/MYxGzVbQMqWf/ZdYrfK7KAO2Cg=
X-Google-Smtp-Source: APXvYqwa9UUN7Mvp5+IWrNC71s8ywyXyFnrYHQImb5XaGnp+0aZKZAr+Q9xSjy/6WgNZRXxjO26CQnOnZOBrmpbMyG4=
X-Received: by 2002:a19:ed0f:: with SMTP id y15mr4534022lfy.3.1574178608570;
 Tue, 19 Nov 2019 07:50:08 -0800 (PST)
MIME-Version: 1.0
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net> <20191115234333.GP4614@dread.disaster.area>
 <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
In-Reply-To: <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
From:   Andrew Carr <andrewlanecarr@gmail.com>
Date:   Tue, 19 Nov 2019 10:49:56 -0500
Message-ID: <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com>
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dave / Eric / Others,

Syslog: https://pastebin.com/QYQYpPFY

Dmesg: https://pastebin.com/MdBCPmp9

-Andrew Carr


On Sat, Nov 16, 2019 at 11:19 AM Andrew Carr <andrewlanecarr@gmail.com> wrote:
>
> Thanks Dave,
> Checking now.
>
> On Fri, Nov 15, 2019 at 6:43 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Fri, Nov 15, 2019 at 01:52:57PM -0600, Eric Sandeen wrote:
> > > On 11/15/19 1:11 PM, Andrew Carr wrote:
> > > > Hello,
> > > >
> > > > This list has recommended enabling stack traces to determine the root
> > > > cause of issues with XFS deadlocks occurring in Centos 7.7
> > > > (3.10.0-1062).
> > > >
> > > > Based on what was recommended by Eric Sandeen, we have tried updating
> > > > the following files to generate XFS stack traces:
> > > >
> > > > # echo 11 > /proc/sys/fs/xfs/error_level
> > > >
> > > > And
> > > >
> > > > # echo 3 > /proc/sys/fs/xfs/error_level
> > > >
> > > > But no stack traces are printed to dmesg.  I was thinking of
> > > > re-compiling the kernel with debug flags enabled.  Do you think this
> > > > is necessary?
> >
> > dmesg -n 7 will remove all filters on the console/dmesg output - if
> > you've utrned this down in the past you may not be seeing messages
> > of the error level XFS is using...
> >
> > Did you check syslog - that should have all the unfiltered messages
> > in it...
> >
> > Cheers,
> >
> > Dave.
> > --
> > Dave Chinner
> > david@fromorbit.com
>
>
>
> --
> With Regards,
> Andrew Carr
>
> e. andrewlanecarr@gmail.com
> w. andrew.carr@openlogic.com
> c. 4239489206
> a. P.O. Box 1231, Greeneville, TN, 37744



-- 
With Regards,
Andrew Carr

e. andrewlanecarr@gmail.com
w. andrew.carr@openlogic.com
c. 4239489206
a. P.O. Box 1231, Greeneville, TN, 37744
