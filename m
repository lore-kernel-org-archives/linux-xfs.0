Return-Path: <SRS0=QtPe=ZO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6FDC432C0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 14:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EBC62071C
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Nov 2019 14:08:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hfvteF2N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfKVOIm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 09:08:42 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35745 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbfKVOIl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Nov 2019 09:08:41 -0500
Received: by mail-lj1-f195.google.com with SMTP id r7so7553775ljg.2
        for <linux-xfs@vger.kernel.org>; Fri, 22 Nov 2019 06:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y7Fxw1EoI6u9Yzvm0V08L6huOZ8/rU/WYHUf7KIEurA=;
        b=hfvteF2NOOKAmVtMfpF4q2nY7fPnJk9C7JuCecfwnPs8IFdcqUB7HKo6MIbazNeKyq
         X+kqn7FsqE+1ZhBzIfrL5gLf1QzuJNO+RT7AHmrDrr+jho3IzB6AY+TmyBC7Zh3y32qc
         BAuuf3i8CdmK7DCzo0Q+mAo1Cuy4lrRneA1x9rjZUjjRMubGdwV7GYART+TmhNWIiTrr
         ukkznUPHJD+o1vJrOasapBBWpX5Dk1BqXtvcibPDbyoyU5C+hW8inWujmmwT1mnqM3Cw
         Y6HeNYK1Zk6+UmYUj6gN6jPk6skMjh6IYb7lrvTcztuwOmtxiuFNnLhIom4AS4CEf0sz
         WWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y7Fxw1EoI6u9Yzvm0V08L6huOZ8/rU/WYHUf7KIEurA=;
        b=mo9WvkJLQQ3NoDfeR7oKrnrwB1NonF2FEFvTMjaFuDnnlQhtjNHBymvhyQ3Rwh4ZUo
         fcrP/Q+f/+Gh7bSSnRDs5Psi3iPnaC9ECau8aXrVwhFRCjo3DH9UtAlSv9ABfk7qarvS
         lrEtVfQnypmnGrUgxMdaHMCWE6glHV0klUloLtd90/UCy6q+HffX0XAcwrVkkWtMaK5+
         0jZCbTWuCNpDbmx/DEDL13vVapyAzliLzd0ShuNCiXTR67+68a/u3sulkDMpAO86UXbi
         +Aj3Ha5IoGmfvpx84DzY+fUu+fTjH6au+GwXxh8+O4Nkc2MdO14yBXaqGREqOJl1rEDf
         JczQ==
X-Gm-Message-State: APjAAAXC0NGlTrxijln/D68fopok3G+7lEsmwHotMRS+PCdpZrCZ7Era
        54nm/sPqUqZDns2MsYruykeCg2mZk0eOpD2Zsps=
X-Google-Smtp-Source: APXvYqyV/7twX+L1cjhWg9hAlK+X5eBxvqFWprLQ2GZGBrIuzck19TwSKVYzolSFg5u0bx0/u5LDmS7vxti1pgJkeEc=
X-Received: by 2002:a2e:9016:: with SMTP id h22mr12304564ljg.137.1574431717617;
 Fri, 22 Nov 2019 06:08:37 -0800 (PST)
MIME-Version: 1.0
References: <CAKQeeLMxJR-ToX5HG9Q-z0-AL9vZG-OMjHyM+rnEEBP6k6nxHw@mail.gmail.com>
 <CAKQeeLNewDe6hu92Tu19=Opx_ao7F_fbpxOsEHaUH9e2NmLWaQ@mail.gmail.com>
 <e6222784-03a5-6902-0f2e-10303962749c@sandeen.net> <20191115234333.GP4614@dread.disaster.area>
 <CAKQeeLNm51r0g=hyH7xpe811nMTS7SP_AwAtAZMCZ0t3Fz4=4Q@mail.gmail.com>
 <CAKQeeLPzked5nptbF6HKdt=u_LkOU-RqOQ8V0r1f7PBS1xWejQ@mail.gmail.com>
 <20191119202038.GX4614@dread.disaster.area> <CAKQeeLMnkvx94ssht-nt0S8eU1uCFqVL4w2yxwY4M5X59RSROA@mail.gmail.com>
In-Reply-To: <CAKQeeLMnkvx94ssht-nt0S8eU1uCFqVL4w2yxwY4M5X59RSROA@mail.gmail.com>
From:   Andrew Carr <andrewlanecarr@gmail.com>
Date:   Fri, 22 Nov 2019 09:08:26 -0500
Message-ID: <CAKQeeLMLj-inQ4sxCLBomuthjNWbd_85VRwAVWk4TvVhLMVC6A@mail.gmail.com>
Subject: Re: Fwd: XFS Memory allocation deadlock in kmem_alloc
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave  / Others,

It appears upgrading to 4.17+ has indeed fixed the deadlock issue, or
at least no deadlocks are occurring now.

There are segfaults in xfs_db appearing now though.  I am attempting
to get the full syslog, here is an example.... thoughts?

[Thu Nov 21 10:43:20 2019] xfs_db[13076]: segfault at 12ff6001 ip
0000000000407922 sp 00007ffe1a27b2e0 error 4 in xfs_db[400000+8a000]
[Thu Nov 21 10:43:20 2019] Code: 89 cc 55 48 89 d5 53 48 89 f3 48 83
ec 48 0f b6 57 01 44 0f b6 4f 02 64 48 8b 04 25 28 00 00 00 48 89 44
24 38 31 c0 0f b6 07 <44> 0f b6 57 0d 48 8d 74 24 10 c1 e2 10 41 c1 e1
08 c1 e0 18 41 c1

Thanks so much in advance!
Andrew

On Wed, Nov 20, 2019 at 10:43 AM Andrew Carr <andrewlanecarr@gmail.com> wro=
te:
>
> Genius Dave, Thanks so much!
>
> On Tue, Nov 19, 2019 at 3:21 PM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Tue, Nov 19, 2019 at 10:49:56AM -0500, Andrew Carr wrote:
> > > Dave / Eric / Others,
> > >
> > > Syslog: https://pastebin.com/QYQYpPFY
> > >
> > > Dmesg: https://pastebin.com/MdBCPmp9
> >
> > which shows no stack traces, again.
> >
> >
> >
> > Anyway, you've twiddled mkfs knobs on these filesystems, and that
> > is the likely cause of the issue: the filesystem is using 64k
> > directory blocks - the allocation size is larger than 64kB:
> >
> > [Sun Nov 17 21:40:05 2019] XFS: nginx(31293) possible memory allocation=
 deadlock size 65728 in kmem_alloc (mode:0x250)
> >
> > Upstream fixed this some time ago:
> >
> > $ =E2=96=B6 gl -n 1 -p cb0a8d23024e
> > commit cb0a8d23024e7bd234dea4d0fc5c4902a8dda766
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Tue Mar 6 17:03:28 2018 -0800
> >
> >     xfs: fall back to vmalloc when allocation log vector buffers
> >
> >     When using large directory blocks, we regularly see memory
> >     allocations of >64k being made for the shadow log vector buffer.
> >     When we are under memory pressure, kmalloc() may not be able to fin=
d
> >     contiguous memory chunks large enough to satisfy these allocations
> >     easily, and if memory is fragmented we can potentially stall here.
> >
> >     TO avoid this problem, switch the log vector buffer allocation to
> >     use kmem_alloc_large(). This will allow failed allocations to fall
> >     back to vmalloc and so remove the dependency on large contiguous
> >     regions of memory being available. This should prevent slowdowns
> >     and potential stalls when memory is low and/or fragmented.
> >
> >     Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> >     Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >
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



--=20
With Regards,
Andrew Carr

e. andrewlanecarr@gmail.com
w. andrew.carr@openlogic.com
c. 4239489206
a. P.O. Box 1231, Greeneville, TN, 37744
