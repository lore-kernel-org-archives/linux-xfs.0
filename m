Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24C9C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 07:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbiE0HHG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 03:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345528AbiE0HHB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 03:07:01 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3726452
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 00:06:59 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id r84so3664358qke.10
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 00:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDk/LpocLlT2sKmtzNThgAKQcoU6QhAJ8+NtV/qX2fE=;
        b=McK0q/kZwDDPH9ybu3UGjgHdZlfGArlln6YutzN3vnk1yOuYbEThPfvHVPzUm3GHjI
         3wlRFThMOpBhZjxiio7JWA1Bfzte3YFayzXFjNlKaL/0TJXv30xfkSVZuzAo20m7TlyA
         diEtNfU0Xf2kJspiAf22ziDWC+B8d49k69I/f3TQtG+oUEBNwiIPLBPPLFPbmpztlGAf
         UtsdSog0MD6jlf1ascn/7uL4I5Trqyv9MTpysU35ILReu0Qh+2bZ8AaD484cSnmQuglM
         4WMeA+fxF56Q7t/kdjjCWgSaNO2KHvK7kunz3HgHMSb0ffEuvqM3I+Y+rs1vquJ6OkMC
         EztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wDk/LpocLlT2sKmtzNThgAKQcoU6QhAJ8+NtV/qX2fE=;
        b=LA2XbH5PfAlu6gvvVR3Ppwt9sE372nK3VZMh7YMVVwAhp14jmOllt9eMKCbe+bB7HH
         23Zorcy9TudD8j8FcdoLPgJvm10n5bWNZZBbqwuccjTmIdwUzJHMAZCXi7zwnRbg0yCA
         4ti2r/+T+mhemobWehxq9ZzMdfZrDZ86Mx1egvHGjVEME/c8yBYruZTaLoUInm1BI496
         5ujcu2iz8iA+u5f+ZH6l2tGjPNPJQ5w0bIUP9poOC+AcL3cwxuS5Aj3LRJNf1V2tFjcP
         5+Un5zTkYYZ9Gpt5MhfP9Zku5sKL12Nj03/kkEO8OakNe/IBARtpbW6nXgowCIrYrTvC
         QnYQ==
X-Gm-Message-State: AOAM533xZEqwsR3E7GL8ihpuoIzTVXGO0ix+WIjiU0Ym9+yG4bR/7JO0
        6eb7gkEWTTrnG2/8QTEI01jBRIsXK1CbQ08njjE=
X-Google-Smtp-Source: ABdhPJxVB8syEBneXZfgPPelRKFNPtoa3UFpVcdFQLgPqDp1R5Kgvxmx1pzZKmIUNplDuLC94uQO1NcaMQFjSnSQsgU=
X-Received: by 2002:a05:620a:2728:b0:6a5:dac2:2311 with SMTP id
 b40-20020a05620a272800b006a5dac22311mr957208qkp.722.1653635218196; Fri, 27
 May 2022 00:06:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210222153442.897089-1-bfoster@redhat.com> <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster> <CAOQ4uxiWajRgGG2V=dYhBmVJYiRmdD+7YgkH2DMWGz6BAOXjvg@mail.gmail.com>
 <Yo+M6Jhjwt/ruOfi@bfoster> <CAOQ4uxjoLm_xwD1GBMNteHsd4zv_4vr+g7xF9_HoCquhq4yoFQ@mail.gmail.com>
 <Yo/ZZtqa5rkuh7VC@bfoster> <CAOQ4uxh0NE4zHUSEqHv8nbpD4RR49Wd_S_DnXhiWCbNqgC0dSQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxh0NE4zHUSEqHv8nbpD4RR49Wd_S_DnXhiWCbNqgC0dSQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 27 May 2022 10:06:46 +0300
Message-ID: <CAOQ4uxjB3L3eVd6WF-pqAx12P_bMpW0O1Om_p6Xnue-edif-cA@mail.gmail.com>
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

On Thu, May 26, 2022 at 11:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > I tested it on top of 5.10.109 + these 5 patches:
> > > https://github.com/amir73il/linux/commits/xfs-5.10.y-1
> > >
> > > I can test it in isolation if you like. Let me know if there are
> > > other forensics that you would like me to collect.
> > >
> >
> > Hm. Still no luck if I move to .109 and pull in those few patches. I
> > assume there's nothing else potentially interesting about the test env
> > other than the sparse file scratch dev (i.e., default mkfs options,
>
> Oh! right, this guest is debian/10 with xfsprogs 4.20, so the defaults
> are reflink=0.
>
> Actually, the section I am running is reflink_normapbt, but...
>
> ** mkfs failed with extra mkfs options added to "-f -m
> reflink=1,rmapbt=0, -i sparse=1," by test 076 **
> ** attempting to mkfs using only test 076 options: -m crc=1 -i sparse **
> ** mkfs failed with extra mkfs options added to "-f -m
> reflink=1,rmapbt=0, -i sparse=1," by test 076 **
> ** attempting to mkfs using only test 076 options: -d size=50m -m
> crc=1 -i sparse **
>
> mkfs.xfs does not accept double sparse argument, so the
> test falls back to mkfs defaults (+ sparse)
>
> I checked and xfsprogs 5.3 behaves the same, I did not check newer
> xfsprogs, but that seems like a test bug(?)
>

xfsprogs 5.16 still behaves the same, meaning that xfs/076 and many many
other tests ignore the custom mkfs options for the specific sections.
That is a big test coverage issue!

> IWO, unless xfsprogs was changed to be more tolerable to repeating
> arguments, then maybe nobody is testing xfs/076 with reflink=0 (?)
>

Bingo!
Test passes 100 runs with debian/testing - xfsprogs v5.16

I shall try to amend the test to force reflink=0 to see what happens.
You should try it as well.

Thanks,
Amir.
