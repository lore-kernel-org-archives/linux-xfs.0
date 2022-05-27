Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1BFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 14:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiE0OQg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 10:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343843AbiE0OQf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 10:16:35 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B891112AAF
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 07:16:33 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id i15so4123226qvk.6
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 07:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NidGqeAlwh3Yc7EJ31C5dFaWgLiBRdZBC8SkhA21P9g=;
        b=U2ysYZHSJm0dLWwxqz/wlBtvjsxB/dO5H7GHafvliYlssXCxxzRNXd38Sn0iL94rxe
         NteWiNN6hUeQ9xkbVbmqp7pQ3YqrgMkII2g9a7qCEFKCwz2F2q5ZNZ7tKiAwQ1iaq3rb
         d3lL+rQdRbqYrEAHl1LdowNR8IrJoMHOWQf5uz2RsHH9qvLxycJw0u22LbEsEEJBOw0R
         1PG/6MbdnsQSN01siZnoB3ZQlSXrLovbHiY1LRoPI7AAuFWc78VHAy72JD87gTG7Me1G
         xAyKGSALFFOe46bkIHBIONhnHoYqh2lIdTCkN+zqEIyBywceNyA2/K9xRICGJ6hrgNmN
         kzug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NidGqeAlwh3Yc7EJ31C5dFaWgLiBRdZBC8SkhA21P9g=;
        b=JYkR5zwNPuwMxgYFGt3GvNj3j+fJLTbF5oRvN2JMn7WgyYYAIXqM5M23hehU4o1sXS
         +nVA+BS0vmNbsziSA/OsFa4tVAphk2NbrVm8zY9ixw29z6kYrw4nZWKsl7/SRXrHs0ht
         WKL/+fYi23SdV9MwNett5re+4qTO3cwuEDSnk7KTfzXnRFPjOhzbV0F7NBwlgPv7OafB
         C3a6luC6Z8/e+8Gr7KMVvr+qxCIkYJvRKHkoSYqH6qBqR8xtjNNwv16hPxlo636lGFPB
         O/EQ7QttBzCoPR4kGQxJAWbmiSfo9a51oduAQywrrLtGGfC2nr9PV+YsWCpe4pW6+FmS
         lr7A==
X-Gm-Message-State: AOAM53101D0ydIGBbDeRT9TpKzjxWZVE+wu4rErlaAelAzfazUz3fLkG
        mfmZzcCC77icR7vDWBh2k6343qiyQzLJN6jS0YMDxE/RqsA=
X-Google-Smtp-Source: ABdhPJylJ0BAcj5cJTbTq38Yl0TVMdVQlyVg2dgnzsIE5Q4Q2m0+ycA60Cb3Y2NNSrNgMfLc/EBqgexXOu474QaHT6w=
X-Received: by 2002:a05:6214:766:b0:462:1701:bca1 with SMTP id
 f6-20020a056214076600b004621701bca1mr28756508qvz.77.1653660992826; Fri, 27
 May 2022 07:16:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster> <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster> <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
 <Yo/ZZtqa5rkuh7VC@bfoster> <CAOQ4uxh0NE4zHUSEqHv8nbpD4RR49Wd_S_DnXhiWCbNqgC0dSQ@mail.gmail.com>
 <CAOQ4uxjB3L3eVd6WF-pqAx12P_bMpW0O1Om_p6Xnue-edif-cA@mail.gmail.com> <YpDI/WdB9FuX2XXt@bfoster>
In-Reply-To: <YpDI/WdB9FuX2XXt@bfoster>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 27 May 2022 17:16:21 +0300
Message-ID: <CAOQ4uxgu1akpKjwkSr4jagwYPNvidciamHUxUvyxPP+tB1ihgw@mail.gmail.com>
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 27, 2022 at 3:50 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Fri, May 27, 2022 at 10:06:46AM +0300, Amir Goldstein wrote:
> > On Thu, May 26, 2022 at 11:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > > > I tested it on top of 5.10.109 + these 5 patches:
> > > > > https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> > > > >
> > > > > I can test it in isolation if you like. Let me know if there are
> > > > > other forensics that you would like me to collect.
> > > > >
> > > >
> > > > Hm. Still no luck if I move to .109 and pull in those few patches. I
> > > > assume there's nothing else potentially interesting about the test env
> > > > other than the sparse file scratch dev (i.e., default mkfs options,
> > >
> > > Oh! right, this guest is debian/10 with xfsprogs 4.20, so the defaults
> > > are reflink=0.
> > >
> > > Actually, the section I am running is reflink_normapbt, but...
> > >
> > > ** mkfs failed with extra mkfs options added to "-f -m
> > > reflink=1,rmapbt=0, -i sparse=1," by test 076 **
> > > ** attempting to mkfs using only test 076 options: -m crc=1 -i sparse **
> > > ** mkfs failed with extra mkfs options added to "-f -m
> > > reflink=1,rmapbt=0, -i sparse=1," by test 076 **
> > > ** attempting to mkfs using only test 076 options: -d size=50m -m
> > > crc=1 -i sparse **
> > >
> > > mkfs.xfs does not accept double sparse argument, so the
> > > test falls back to mkfs defaults (+ sparse)
> > >
> > > I checked and xfsprogs 5.3 behaves the same, I did not check newer
> > > xfsprogs, but that seems like a test bug(?)
> > >
> >
> > xfsprogs 5.16 still behaves the same, meaning that xfs/076 and many many
> > other tests ignore the custom mkfs options for the specific sections.
> > That is a big test coverage issue!
> >
> > > IWO, unless xfsprogs was changed to be more tolerable to repeating
> > > arguments, then maybe nobody is testing xfs/076 with reflink=0 (?)
> > >
> >
> > Bingo!
> > Test passes 100 runs with debian/testing - xfsprogs v5.16
> >
> > I shall try to amend the test to force reflink=0 to see what happens.
> > You should try it as well.
> >
>
> Interesting. If I set -mreflink=0 xfs/076 seems to do the right thing
> and format the scratch device as expected, but I'm still not seeing a
> failure on my system for whatever reason.

Me neither (on my home VM).
I will investigate the assertion on the system where it reproduces.
May take me some time but I will get to it.

Thanks,
Amir.
