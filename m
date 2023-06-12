Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE26C7EE2E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 16:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbjFLQ6M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbjFLQ6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 12:58:12 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F32FE73
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:58:11 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-4f6283d0d84so5390102e87.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686589089; x=1689181089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLoz7lxagH1eY4McVsEAypsnIWtE+LF5c+YFhdajR34=;
        b=LTQ3mmXY7CFskPvLfzwhsGbO1Hku7HHasdMxY0rwMTLbcY8JtsoTn8I0XjryAbAstB
         mmVXMdMrPHxbqX07dzk6qVSFdqR6WPzD68w3bKbp+rKWHQDCl2mhFPCrb8thRgkKzw2m
         nPnwyy3ZHxsgLz9mFZN4K+ktiBN0nRbrLNHMw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686589089; x=1689181089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLoz7lxagH1eY4McVsEAypsnIWtE+LF5c+YFhdajR34=;
        b=JJfUkkasFUUJge003o7iXf507N/z9myeo0pQCQufDtdhmCCSYCnR2yIcRUxAK8Bn3k
         coHz9mJNX+7lMMheS1a9He74Dp2uBoRHUpGU/v2sHd+B8yrtdyiYTvfTYME0uMmkpz8e
         fjIaoi4cDQ3wYT2LJv/5JkzNEJaOkexdxGymuGILki61tLlp+20UCzpEaoOQPoUEubA0
         NB1b83EOCNs5zEOfMtwLOXqfI7kEBbXBDDjF+fAe78EM0rCoOCKVGYCRSqMCMiZ+kiLp
         psM8jtWRtw30l7IumhsruhR2OsEHIcAxP7J0EsUgAFs2kdebxfNS2EJeqfxLw1Shu+81
         RSBA==
X-Gm-Message-State: AC+VfDzfJ93RxsI0klfhY5uzPdKsMX9BNPoBukaHkQerhXUY11Cd5toN
        pCJW6R595OosbKuvVRHT2bUXIom9ahJNMD7MzOqAlqDG
X-Google-Smtp-Source: ACHHUZ5FMNBL4gMyfLakjDLIUhImF+EH0cawgZPsh9n2sTmBi3nHOll8+G8ZiQ16+zCK6b6v5roc6w==
X-Received: by 2002:a19:4f0d:0:b0:4f4:dd5d:f3e4 with SMTP id d13-20020a194f0d000000b004f4dd5df3e4mr4327249lfb.26.1686589089236;
        Mon, 12 Jun 2023 09:58:09 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id e5-20020a056402104500b005153b12c9f7sm5292259edu.32.2023.06.12.09.58.08
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 09:58:08 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-51870e2dc48so59392a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 09:58:08 -0700 (PDT)
X-Received: by 2002:aa7:c90a:0:b0:516:4e6b:fa46 with SMTP id
 b10-20020aa7c90a000000b005164e6bfa46mr4635225edt.31.1686589087811; Mon, 12
 Jun 2023 09:58:07 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <20230612153629.GA11427@frogsfrogsfrogs> <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
 <af31cadf-8c15-8d88-79fb-066dc87f0324@kernel.dk> <13d9e4f2-17c5-0709-0cc0-6f92bfe9f30d@kernel.dk>
 <CAHk-=wgdBfqyNHk0iNyYpEuBUdVgq1KMzHMuEqn=ADtfyK_pkQ@mail.gmail.com> <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk>
In-Reply-To: <212a190c-f81e-2876-cf14-6d1e37d47192@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jun 2023 09:57:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
Message-ID: <CAHk-=wh0hrFjcU5C8uHvLBThrT5vQsFHb7Jk6HRP3LAJqdNx1A@mail.gmail.com>
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 9:45=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> You snipped the suspicion in my reply on why that exists, to avoid
> io_wq_worker_sleeping() triggering.

I'm not seeing why triggering io_wq_worker_sleeping() should even be a
problem in the first place.

I suspect that is entirely historical too, and has to do with how it
used to do that

        struct io_worker *worker =3D kthread_data(tsk);
        struct io_wqe *wqe =3D worker->wqe;

back in the bad old days of kthreads.

But yeah, I don't know that code.

              Linus
