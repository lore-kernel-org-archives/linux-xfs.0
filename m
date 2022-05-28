Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21873C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 28 May 2022 05:01:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343902AbiE1FBE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 28 May 2022 01:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235749AbiE1FBB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 May 2022 01:01:01 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B166D11E1C9;
        Fri, 27 May 2022 22:01:00 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id b200so7220619qkc.7;
        Fri, 27 May 2022 22:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QfoCFbsIaTzbUTDNfxd62r8kv2gQci5/4cPHaz9Hxaw=;
        b=nhq2jxc4rg/3RlfZWcR1v1hxLVKsFubIeHo3Xg1PZe0fxhgnbo2kqZDcO/DhO9vjNc
         T2GiLBufGjkXnEYgMsdWisRizDM58vAA8ru2OJagEIK/bsHVXgyNp4LRQqpgP06MWGh8
         jPrQeyCa4T3/5gLVsCI/maIuIzKq0Ar5VOJrUNOF8HZSVTWSgOHWtFVfuPVo4e2qAWk1
         8mD0GDxnr9AJymlRwRHtKI8Hjw49pF/Cr1Ka/Rvs999KFlIw1ABEwAcZFYVXqyNULGzP
         7kqOsCLuLZvjErayV81YCZfW4M4Pn9lQtZwtXNUBgKb6BdybnNjeD4qJz62EG81mAXAg
         wk6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QfoCFbsIaTzbUTDNfxd62r8kv2gQci5/4cPHaz9Hxaw=;
        b=Xcoz+Acj1rYCYSdz2ABeEZZpXq1FZ26TdvNdOV/h0c5j6onHn7LJMLRvla5zRgGwKV
         smGMdJ0n4BFzCCdvSIs2iIy9BKwelVxIxBz3MyRs1nIKiITYkMwkSgEMAipJHFyPY145
         H/MgTPuBTF4D0WXjbc2p5oKXBBXLLQ4zPluh1SQTejx1ZbeZ5peyziXAMTttRkIWvxM5
         6GK6i8DJRWdk7AgAuN+hDK23Uz9gdSzOXN8JLN8iV9A+OshAJj7F+AYzT7+AKbEunhNY
         zH8amVEP29azzAf1zLd5wTB7tNQBFITdtroH9nhWt9OKIsaNxSCVQDyLwYEtWo+UjOZC
         nL0A==
X-Gm-Message-State: AOAM533Wcwhvkwg1Vuz5Xk9iFumot3mwz7xUtTSlZd3UiEhKtdnTv9yb
        f6k9GinamQ6c4gK+zSpqd4Mb7x/MwdRiRTGDG4Y=
X-Google-Smtp-Source: ABdhPJxifkgqmEmHcGHYdo1w3pAaR9o5Z0Y/bcYjgCk/73Dlr9rCeZdXsBC1jKzXXHwBidwzGJ8T4JzzDrsk+q5MSpU=
X-Received: by 2002:a37:6310:0:b0:6a5:71bf:17e6 with SMTP id
 x16-20020a376310000000b006a571bf17e6mr15988378qkb.258.1653714059793; Fri, 27
 May 2022 22:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220525111715.2769700-1-amir73il@gmail.com> <YpBqfdmwQ675m72G@infradead.org>
 <CAOQ4uxjek9331geZGVbVT=gqkNTyVA_vjyjuB=2eGZD-ufeqNQ@mail.gmail.com>
 <20220527090838.GD3923443@dread.disaster.area> <CAOQ4uxgc9Zu0rvTY3oOqycGG+MoYEL3-+qghm9_qEn67D8OukA@mail.gmail.com>
 <YpDw3uVFB7LjPquX@bombadil.infradead.org> <20220527234202.GF3923443@dread.disaster.area>
In-Reply-To: <20220527234202.GF3923443@dread.disaster.area>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 28 May 2022 08:00:48 +0300
Message-ID: <CAOQ4uxgYoK=mE=Fpt8BizgHxXmgajCk=t2k6nzHb2mM=C-HvAg@mail.gmail.com>
Subject: Re: [PATH 5.10 0/4] xfs stable candidate patches for 5.10.y (part 1)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, May 28, 2022 at 2:42 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Fri, May 27, 2022 at 08:40:14AM -0700, Luis Chamberlain wrote:
> > On Fri, May 27, 2022 at 03:24:02PM +0300, Amir Goldstein wrote:
> > > On Fri, May 27, 2022 at 12:08 PM Dave Chinner <david@fromorbit.com> wrote:
> > > > Backport candidate: yes. Severe: absolutely not.
> > > In the future, if you are writing a cover letter for an improvement
> > > series or internal pull request and you know there is a backport
> > > candidate inside, if you happen to remember to mention it, it would
> > > be of great help to me.
>
> That's what "fixes" and "cc: stable" tags in the commit itself are
> for, not the cover letter.

Cover letter is an overview of the work.
A good cover letter includes an overview of the individual patches
in the context of the whole work as your cover letter did:

Summary of series:

Patches Modifications
------- -------------
1-7: log write FUA/FLUSH optimisations
8: bug fix
9-11: Async CIL pushes
12-25: xlog_write() rework
26-39: CIL commit scalability

So it was lapse of judgement on my part or carelessness that made me
eliminate the series without noting patch #8.

Furthermore, the subject of the patch has Fix and trailer has
Reported-and-tested-by:
so auto candidate selection would have picked it up easily, but my scripts
only looked for the obvious Fixes: tag inside the eliminated series, so that
is a problem with my process that I need to improve.

So the blame is entirely on me! not on you!

And yet.
"bug fix"?
Really?

I may not have been expecting more of other developers.
But I consider you to be one of the best when it comes to analyzing and
documenting complex and subtle code, so forgive me for expecting more.
I am not talking about severity or rareness or other things that may change
in time perspective. I am talking about describing the changes in a way that
benefits the prospective consumers of the cover letter (i.e. me).

It makes me sad that you are being defensive about this, because I wish
to be able to provide feedback to developers without having deal with a
responses like:
"I don't need anyone trying to tell me what I should have been doing"

Not every suggestion for an improvement is an attack.
You do not have to agree with my suggestions nor to adopt them,
but please do not dismiss them, because they come in good faith.

Thanks,
Amir.
