Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDF7C88CB2
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 15:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbjFLP5T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238591AbjFLP4q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 11:56:46 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542BA1A7
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 08:56:45 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f60a27c4a2so5058863e87.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 08:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1686585403; x=1689177403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ugCj9YhfDUqOrFu4vKJ/c5GJ+ui7RcmNnGjLCf8eEY=;
        b=JJotxGl8KOTjITNCHaLDw6NzEzsWXz5Fu12VZ+4h7dmxgwhO19QcltY4zHOLQ/pLE0
         i3/d7k/DwHOfxUTOD7uwU+KG85ZNvmO5Ceusqf+J2DHO3073HRlwNudGyLUg8xdS4dNW
         lgulr6K9yCt9KRYkGKt4jEt5I/1megOVAuNjY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686585403; x=1689177403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ugCj9YhfDUqOrFu4vKJ/c5GJ+ui7RcmNnGjLCf8eEY=;
        b=GL5dLH/nKBqg+NWP4qkyIr6j+Q7WCVuDNwg5ouGKEXGRKFU4P9mc6uqgY6IPqU6ftb
         biPK79E+lde8qEe7shg8ZThoTYAJkZh+xA3l9CfyODOuxwY4dlTx2fZhWEfIiCG7LFSG
         wxQTvYUw3c7Tqa1DAf+HBeOY38faQNFlVF4Ja9RpJtYFLnAKdhl778NsDiFmK2UdXs+7
         bnf0BjGmLrEomNIg8AFD8PkYbS9sbFm/v53ckTxP6AAfzbeXBqhKW88AbWTnqjM2hQGM
         uyOqn7kIgD/ssad8PELNZeyi9UQAuci4ojFFjCQxOEDD7lNQHNqFdnnPneFkhmyKjRjQ
         Iosg==
X-Gm-Message-State: AC+VfDyuz0PqIcwbVmqpKdQ5WqvcgkfV2bgKh3Dxl7e065d4KxZIs8AT
        jk54qmQI/dfyJ2MzP+EVZVMjc1PBT4mSsRveLyO1ww==
X-Google-Smtp-Source: ACHHUZ5TkqzFqhltWdLN7PHYzYnXzBOzs10iGw7YOV86nSNccTBFcYTzj5Jm11vyJreP9EzeYAr9ug==
X-Received: by 2002:a19:6d1c:0:b0:4f6:520d:6b9b with SMTP id i28-20020a196d1c000000b004f6520d6b9bmr3847870lfc.60.1686585403318;
        Mon, 12 Jun 2023 08:56:43 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id c14-20020ac2530e000000b004f63d223acfsm1472637lfh.139.2023.06.12.08.56.42
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:56:42 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f624daccd1so5072889e87.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 08:56:42 -0700 (PDT)
X-Received: by 2002:a19:6445:0:b0:4f6:1e9c:cb11 with SMTP id
 b5-20020a196445000000b004f61e9ccb11mr4517490lfj.14.1686585402149; Mon, 12 Jun
 2023 08:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area> <20230612015145.GA11441@frogsfrogsfrogs>
 <ZIaBQnCKJ6NsqGhd@dread.disaster.area> <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
 <20230612153629.GA11427@frogsfrogsfrogs>
In-Reply-To: <20230612153629.GA11427@frogsfrogsfrogs>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Jun 2023 08:56:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
Message-ID: <CAHk-=wiN-JcUh4uhDNmA4hp26Mg+c2DTuzgWY2fZ6hytDtOMCg@mail.gmail.com>
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
To:     "Darrick J. Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>,
        linux-xfs@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 8:36=E2=80=AFAM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> > Or maybe Darrick (who doesn't see the issue) is running on raw
> > hardware, and you and Zorro are running in a virtual environment?
>
> Ahah, it turns out that liburing-dev isn't installed on the test fleet,
> so fstests didn't get built with io_uring support.  That probably
> explains why I don't see any of these hangs.
>
> Oh.  I can't *install* the debian liburing-dev package because it has
> a versioned dependency on linux-libc-dev >=3D 5.1, which isn't compatible
> with me having a linux-libc-dev-djwong package that contains the uapi
> headers for the latest upstream kernel and Replaces: linux-libc-dev.
> So either I have to create a dummy linux-libc-dev with adequate version
> number that pulls in my own libc header package, or rename that package.
>
> <sigh> It's going to take me a while to research how best to split this
> stupid knot.

Oh, no, that's great. It explains why you don't see the problem, and
Dave and Zorro do. Perfect.

No need for you to install any liburing packages, at least for this
issue. You'll probably want it eventually just for test coverage, but
for now it's the smoking gun we wanted - I was looking at why vhost
would be impacted, because that commit so intentionally *tried* to not
do anything at all to io_uring.

But it obviously failed. Which then in turn explains the bug.

Not that I see exactly where it went wrong yet, but at least we're
looking at the right thing. Adding Jens to the participants, in case
he sees what goes wrong.

Jens, commit f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix
freezer/ps regression") seems to have broken core dumping with
io_uring threads, even though it tried very hard not to. See

  https://lore.kernel.org/all/20230611124836.whfktwaumnefm5z5@zlang-mailbox=
/

for the beginning of this thread.

Honestly, that "try to not change io_uring" was my least favorite part
of that patch, because I really think we want to try to aim for these
user helper threads having as much infrastructure in common as
possible. And when it comes to core dumps, I do not believe that
waiting for the io_uring thread adds anything to the end result,
because the only reason we wait for it is to put in the thread
register state into the core dump, and for kernel helper threads, that
information just isn't useful. It's going to be the state that caused
the thread to be created, not anything that is worth saving in a core
dump for.

So I'd actually prefer to just simplify the logic entirely, and say
"PF_USER_WORKER tasks do not participate in core dumps, end of story".
io_uring didn't _care_, so including them wasn't a pain, but if the
vhost exit case can be delayed, I'd rather just say "let's do thig
thing for both io_uring and vhost, and not split those two cases up".

Anyway, I don't see exactly what goes wrong, but I feel better just
from this having been narrowed down to io_uring threads. I suspect
Jens actually might even have a core-dumping test-case somewhere,
since core dumping was a thing that io_uring ended up having some
issues with at one point.

           Linus
